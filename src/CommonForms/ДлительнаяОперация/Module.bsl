///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаКлиенте
Перем ИнтервалОжидания;
&НаКлиенте
Перем ФормаЗакрывается;

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ТекстСообщения = "Пожалуйста, подождите...";
	Если Не ПустаяСтрока(Параметры.ТекстСообщения) Тогда
		ТекстСообщения = Параметры.ТекстСообщения + Символы.ПС + ТекстСообщения;
		Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = ТекстСообщения;
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		Элементы.СообщениеОперации.Заголовок			= Параметры.Заголовок;
		Элементы.СообщениеОперации.ОтображатьЗаголовок	= Истина;
	Иначе
		Элементы.СообщениеОперации.ОтображатьЗаголовок	= Ложь;
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметры.ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	КонецЕсли;

	Если БазоваяПодсистемаСервер.ОН_ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Параметры.ВыводитьОкноОжидания Тогда
		ФормаЗакрывается	= Ложь;
		Статус				= "Выполняется";

		ДлительнаяОперация = Новый Структура;
		ДлительнаяОперация.Вставить("Статус", Статус);
		ДлительнаяОперация.Вставить("ИдентификаторЗадания", Параметры.ИдентификаторЗадания);
		ДлительнаяОперация.Вставить("Сообщения", Новый ФиксированныйМассив(Новый Массив));
		ДлительнаяОперация.Вставить("АдресРезультата", Параметры.АдресРезультата);
		ДлительнаяОперация.Вставить("АдресДополнительногоРезультата", Параметры.АдресДополнительногоРезультата);

		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПриЗавершенииДлительнойОперации", ЭтотОбъект);
		ОповещениеОПрогрессе  = Новый ОписаниеОповещения("ПриПолученииПрогрессаДлительнойОперации", ЭтотОбъект);

		ПараметрыОжидания									= БазоваяПодсистемаКлиент.ДО_ПараметрыОжидания(ВладелецФормы);
		ПараметрыОжидания.ВыводитьОкноОжидания				= Ложь;
		ПараметрыОжидания.Интервал							= Параметры.Интервал;
		ПараметрыОжидания.ОповещениеОПрогрессеВыполнения	= ОповещениеОПрогрессе;

		БазоваяПодсистемаКлиент.ДО_ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если Статус <> "Выполняется" Тогда
		Возврат;
	КонецЕсли;

	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	ПодключитьОбработчикОжидания("Подключаемый_ОтменитьЗадание", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ФормаЗакрывается = Истина;
	ОтключитьОбработчикОжидания("Подключаемый_ОтменитьЗадание");

	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;

	Если Статус <> "Выполняется" Тогда
		Возврат;
	КонецЕсли;

	ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОтменитьЗадание()
	ФормаЗакрывается = Истина;

	ДлительнаяОперация = ПроверитьИОтменитьЕслиВыполняется(ИдентификаторЗадания);
	ЗавершитьДлительнуюОперациюИЗакрытьФорму(ДлительнаяОперация);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещение()
	Если Параметры.ОповещениеПользователя = Неопределено Тогда
		Возврат;
	КонецЕсли;

	БазоваяПодсистемаКлиент.ДО_ПоказатьОповещение(Параметры.ОповещениеПользователя, ВладелецФормы);
КонецПроцедуры

&НаКлиенте
Функция РезультатВыполнения(ДлительнаяОперация)
	Результат = Новый Структура;
	Результат.Вставить("Статус",							ДлительнаяОперация.Статус);
	Результат.Вставить("АдресРезультата",					Параметры.АдресРезультата);
	Результат.Вставить("АдресДополнительногоРезультата",	Параметры.АдресДополнительногоРезультата);
	Результат.Вставить("КраткоеПредставлениеОшибки",		ДлительнаяОперация.КраткоеПредставлениеОшибки);
	Результат.Вставить("ПодробноеПредставлениеОшибки",		ДлительнаяОперация.ПодробноеПредставлениеОшибки);
	Результат.Вставить("Сообщения",							Новый ФиксированныйМассив(Новый Массив));

	Если Параметры.ПолучатьРезультат Тогда
		Результат.Вставить("Результат", ДлительнаяОперация.Результат);
	КонецЕсли;

	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ВозвращатьРезультатВОбработкуВыбора()
	Возврат ОписаниеОповещенияОЗакрытии = Неопределено И Параметры.ПолучатьРезультат И ТипЗнч(ВладелецФормы) = Тип("ФормаКлиентскогоПриложения");
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	БазоваяПодсистемаСервер.ДО_ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьИОтменитьЕслиВыполняется(ИдентификаторЗадания)
	ДлительнаяОперация = БазоваяПодсистемаСервер.ДО_ОперацияВыполнена(ИдентификаторЗадания);

	Если ДлительнаяОперация.Статус = "Выполняется" Тогда
		ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		ДлительнаяОперация.Статус = "Отменено";
	КонецЕсли;

	Возврат ДлительнаяОперация;
КонецФункции

&НаКлиенте
Процедура ЗавершитьДлительнуюОперациюИЗакрытьФорму(ДлительнаяОперация)
	Если ДлительнаяОперация = Неопределено Тогда
		Статус = "Отменено";
	Иначе
		Статус = ДлительнаяОперация.Статус;
	КонецЕсли;

	Если Статус = "Отменено" Тогда
		Закрыть(Неопределено);

		Возврат;
	КонецЕсли;

	Если Параметры.ПолучатьРезультат Тогда
		Если Статус = "Выполнено" Тогда
			ДлительнаяОперация.Вставить("Результат", ПолучитьИзВременногоХранилища(Параметры.АдресРезультата));
		Иначе
			ДлительнаяОперация.Вставить("Результат", Неопределено);
		КонецЕсли;
	КонецЕсли;

	Если Статус = "Выполнено" Тогда
		ПоказатьОповещение();
		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ОповеститьОВыборе(ДлительнаяОперация.Результат);

			Возврат;
		КонецЕсли;
		Результат = РезультатВыполнения(ДлительнаяОперация);
		Закрыть(Результат);
	ИначеЕсли Статус = "Ошибка" Тогда
		Результат = РезультатВыполнения(ДлительнаяОперация);
		Закрыть(Результат);
		Если ВозвращатьРезультатВОбработкуВыбора() Тогда
			ВызватьИсключение ДлительнаяОперация.КраткоеПредставлениеОшибки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииДлительнойОперации(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	Если ФормаЗакрывается Или Не Открыта() Тогда
		Возврат;
	КонецЕсли;

	ЗавершитьДлительнуюОперациюИЗакрытьФорму(ДлительнаяОперация);
КонецПроцедуры

&НаКлиенте
Процедура ПриПолученииПрогрессаДлительнойОперации(ДлительнаяОперация, ДополнительныеПараметры) Экспорт
	Если ФормаЗакрывается Или Не Открыта() Тогда
		Возврат;
	КонецЕсли;

	Если Параметры.ВыводитьПрогрессВыполнения И ДлительнаяОперация.Прогресс <> Неопределено Тогда
		Процент = 0;
		Если ДлительнаяОперация.Прогресс.Свойство("Процент", Процент) Тогда
			Элементы.ДекорацияПроцент.Видимость = Истина;
			Элементы.ДекорацияПроцент.Заголовок = Строка(Процент) + "%";
		КонецЕсли;

		Текст = "";
		Если ДлительнаяОперация.Прогресс.Свойство("Текст", Текст) Тогда
			Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = СокрЛП(Текст);
		КонецЕсли;
	КонецЕсли;

	Если Параметры.ВыводитьСообщения И ДлительнаяОперация.Сообщения <> Неопределено И ВладелецФормы <> Неопределено Тогда
		ИдентификаторНазначения = ВладелецФормы.УникальныйИдентификатор;
		Для Каждого СообщениеПользователю Из ДлительнаяОперация.Сообщения Цикл
			СообщениеПользователю.ИдентификаторНазначения = ИдентификаторНазначения;
			СообщениеПользователю.Сообщить();
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры
