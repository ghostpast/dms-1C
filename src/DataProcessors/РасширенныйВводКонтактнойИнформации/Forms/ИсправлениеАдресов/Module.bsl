///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИдентификаторПроверки = Параметры.ИдентификаторПроверки;

	Если ИдентификаторПроверки = "КонтактнаяИнформацияСервер.РСА_ИсправитьТипЗданияЛитерВАдресах" Тогда
		Заголовок						= "Исправление адресов с типом здания Литер";
		Элементы.Пояснение.Заголовок	= СтрШаблон(Элементы.Пояснение.Заголовок, Строка(Параметры.ВидПроверки.Свойство2));
	 Иначе
		Заголовок						= "Исправление устаревших адресов";
		Элементы.Пояснение.Заголовок	= СтрШаблон(Элементы.Пояснение.Заголовок, Строка(Параметры.ВидПроверки.Свойство2));
	КонецЕсли;

	Если БазоваяПодсистемаСервер.ОН_ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсправитьАдреса(Команда)
	Если ИдентификаторПроверки = "КонтактнаяИнформацияСервер.РСА_ИсправитьТипЗданияЛитерВАдресах" Тогда
		ДлительнаяОперация = ИсправитьАдресаСТипомЛитерВФоне(ИдентификаторПроверки);
	Иначе
		ДлительнаяОперация = ИсправитьУстаревшиеАдресаВФоне(ИдентификаторПроверки);
	КонецЕсли;
	ПараметрыОжидания		= БазоваяПодсистемаКлиент.ДО_ПараметрыОжидания(ЭтотОбъект);
	ОповещениеОЗавершении	= Новый ОписаниеОповещения("ИсправитьПроблемуВФонеЗавершение", ЭтотОбъект);
	БазоваяПодсистемаКлиент.ДО_ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницу(Форма, ИмяСтраницы)
	ЭлементыФормы = Форма.Элементы;
	Если ИмяСтраницы = "ИдетИсправлениеПроблемы" Тогда
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Истина;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Ложь;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Ложь;
		ЭлементыФормы.Исправить.Видимость                          = Истина;
	ИначеЕсли ИмяСтраницы = "ИсправлениеУспешноВыполнено" Тогда
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Ложь;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Ложь;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Истина;
		ЭлементыФормы.Закрыть.КнопкаПоУмолчанию                    = Истина;
		ЭлементыФормы.Исправить.Видимость                           = Ложь;
	Иначе // "Вопрос"
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Ложь;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Истина;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Ложь;
		ЭлементыФормы.Исправить.Видимость                          = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИсправитьУстаревшиеАдресаВФоне(ИдентификаторПроверки)
	Если ДлительнаяОперация <> Неопределено Тогда
		БазоваяПодсистемаСервер.ДО_ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;

	УстановитьТекущуюСтраницу(ЭтотОбъект, "ИдетИсправлениеПроблемы");

	ПараметрыВыполнения								= БазоваяПодсистемаСервер.ДО_ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания	= "Исправление устаревших адресов контактной информации";

	ПараметрыВыполненияФоновогоЗадания = Новый Структура;
	ПараметрыВыполненияФоновогоЗадания.Вставить("ИдентификаторПроверки", ИдентификаторПроверки);
	ПараметрыВыполненияФоновогоЗадания.Вставить("ВидПроверки", Параметры.ВидПроверки);

	Возврат БазоваяПодсистемаСервер.ДО_ВыполнитьВФоне("КонтактнаяИнформацияСервер.РСА_ИсправитьУстаревшиеАдресаВФоне", ПараметрыВыполненияФоновогоЗадания, ПараметрыВыполнения);
КонецФункции

&НаСервере
Функция ИсправитьАдресаСТипомЛитерВФоне(ИдентификаторПроверки)
	Если ДлительнаяОперация <> Неопределено Тогда
		БазоваяПодсистемаСервер.ДО_ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;

	УстановитьТекущуюСтраницу(ЭтотОбъект, "ИдетИсправлениеПроблемы");

	ПараметрыВыполнения								= БазоваяПодсистемаСервер.ДО_ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания	= "Исправление адресов контактной информации  с типом здания Литер";

	ПараметрыВыполненияФоновогоЗадания = Новый Структура;
	ПараметрыВыполненияФоновогоЗадания.Вставить("ИдентификаторПроверки", ИдентификаторПроверки);
	ПараметрыВыполненияФоновогоЗадания.Вставить("ВидПроверки", Параметры.ВидПроверки);

	Возврат БазоваяПодсистемаСервер.ДО_ВыполнитьВФоне("КонтактнаяИнформацияСервер.РСА_ИсправитьТипЗданияЛитерВАдресахВФоне", ПараметрыВыполненияФоновогоЗадания, ПараметрыВыполнения);
КонецФункции

&НаКлиенте
Процедура ИсправитьПроблемуВФонеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ДлительнаяОперация = Неопределено;

	Если Результат = Неопределено Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, "ИдетИсправлениеПроблемы");
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, "Вопрос");
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		Результат = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Элементы.НадписьУспешноеИсправление.Заголовок = СтрШаблон(Элементы.НадписьУспешноеИсправление.Заголовок, Результат.ИсправленоОбъектов, Результат.ВсегоОбъектов);
		КонецЕсли;
		УстановитьТекущуюСтраницу(ЭтотОбъект, "ИсправлениеУспешноВыполнено");
	КонецЕсли;
КонецПроцедуры
