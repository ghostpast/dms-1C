///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("ПараметрыОткрытияФормыОтчета", ПараметрыОткрытияФормыОтчета) Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеВерсииИБСервер.ОИБ_ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Доступен = ?(Объект.ТолькоДляАвтора, "ТолькоДляАвтора", "УказаннымПользователям");

	ПолныеПраваНаВарианты	= ВариантыОтчетовСервер.ВО_ПолныеПраваНаВарианты();
	ПравоНаЭтотВариант		= ПолныеПраваНаВарианты Или Объект.Автор = ПользователиСервер.сП_АвторизованныйПользователь();
	Если Не ПравоНаЭтотВариант Тогда
		ТолькоПросмотр								= Истина;
		Элементы.ДеревоПодсистем.ТолькоПросмотр		= Истина;
	КонецЕсли;

	Если Объект.ПометкаУдаления Тогда
		Элементы.ДеревоПодсистем.ТолькоПросмотр		= Истина;
	КонецЕсли;

	Если Не Объект.Пользовательский Тогда
		Элементы.Наименование.ТолькоПросмотр		= Истина;
		Элементы.Доступен.ТолькоПросмотр			= Истина;
		Элементы.Автор.ТолькоПросмотр				= Истина;
		Элементы.Автор.АвтоОтметкаНезаполненного	= Ложь;
	КонецЕсли;

	ЭтоВнешний = (Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внешний);
	Если ЭтоВнешний Тогда
		Элементы.ДеревоПодсистем.ТолькоПросмотр		= Истина;
	КонецЕсли;

	Элементы.Доступен.ТолькоПросмотр				= Не ПолныеПраваНаВарианты;
	Элементы.Автор.ТолькоПросмотр					= Не ПолныеПраваНаВарианты;
	Элементы.ТехническаяИнформация.Видимость		= ПолныеПраваНаВарианты;

	// Заполнение имени отчета для команды "Просмотр".
	Если Объект.ТипОтчета = Перечисления.ТипыОтчетов.Внутренний
		Или Объект.ТипОтчета = Перечисления.ТипыОтчетов.Расширение Тогда
		ИмяОтчета = Объект.Отчет.Имя;
	ИначеЕсли Объект.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный Тогда
		ИмяОтчета = Объект.Отчет.ИмяОбъекта;
	Иначе
		ИмяОтчета = Объект.Отчет;
	КонецЕсли;

	ПерезаполнитьДерево(Ложь);

	ВариантыОтчетовСервер.ВО_ОпределитьПоведениеСпискаПользователейВариантаОтчета(ЭтотОбъект);
	ВариантыОтчетовСервер.ВО_ВывестиПризнакУведомленияПользователейВариантаОтчета(Элементы.УведомитьПользователей);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ПараметрыОткрытияФормыОтчета <> Неопределено Тогда
		Отказ = Истина;
		ВариантыОтчетовКлиент.ВО_ОткрытьФормуОтчета(Неопределено, ПараметрыОткрытияФормыОтчета);
	КонецЕсли;

	ВариантыОтчетовКлиент.ВО_ОформитьПользователейВариантаОтчета(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник <> ЭтотОбъект И (ИмяСобытия = "Запись_ВариантыОтчетов" Или ИмяСобытия = "Запись_НаборКонстант") Тогда
		ПерезаполнитьДерево(Истина);
		Элементы.ДеревоПодсистем.Развернуть(ДеревоПодсистем.ПолучитьЭлементы()[0].ПолучитьИдентификатор(), Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	СпроситьОУведомленииПользователей(Отказ);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Запись свойств, связанных с предопределенным вариантом отчета.
	ОписаниеИзменено = Ложь;
	Если ЭтоПредопределенный Тогда
		ПредопределенныйВариант = ТекущийОбъект.ПредопределенныйВариант.ПолучитьОбъект();

		ОписаниеИзменено = Не ПустаяСтрока(Объект.Описание) И НРег(СокрЛП(Объект.Описание)) <> НРег(СокрЛП(ПредопределенныйВариант.Описание));
		Если Не ОписаниеИзменено Тогда
			ТекущийОбъект.Описание = "";
			Для каждого ПредставлениеВарианта Из ТекущийОбъект.Представления Цикл
				ПредставлениеВарианта.Описание = "";
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;

	// Запись дерева подсистем.
	ДеревоПриемник = РеквизитФормыВЗначение("ДеревоПодсистем", Тип("ДеревоЗначений"));
	Если ТекущийОбъект.ЭтоНовый() Тогда
		ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Использование", 1), Истина);
	Иначе
		ИзмененныеРазделы = ДеревоПриемник.Строки.НайтиСтроки(Новый Структура("Модифицированность", Истина), Истина);
	КонецЕсли;
	ВариантыОтчетовСервер.ВО_ДеревоПодсистемЗаписать(ТекущийОбъект, ИзмененныеРазделы);

	Если ЭтоПредопределенный И Не ОписаниеИзменено Тогда
		ТекущийОбъект.Представления.Очистить();
	КонецЕсли;

	ТекущийОбъект.ДополнительныеСвойства.Вставить("ПользователиВарианта", ПользователиВарианта);
	ТекущийОбъект.ДополнительныеСвойства.Вставить("УведомитьПользователей", УведомитьПользователей);
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// Зарезервировано для новых подсистем

	ПерезаполнитьДерево(Ложь);
	ЗаполнитьИзПредопределенного(ТекущийОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	ВариантыОтчетовКлиент.ВО_ОбновитьОткрытыеФормы(Объект.Ссылка, ЭтотОбъект);
	БазоваяПодсистемаКлиент.СП_РазвернутьУзлыДерева(ЭтотОбъект, "ДеревоПодсистем", "*", Истина);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// Зарезервировано для новых подсистем

	ЗаполнитьИзПредопределенного(ТекущийОбъект);

	РегистрыСведений.НастройкиВариантовОтчетов.ПрочитатьНастройкиДоступностиВариантаОтчета(ТекущийОбъект.Ссылка, ПользователиВарианта, ИспользоватьГруппыПользователей, ИспользоватьВнешнихПользователей);
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	БазоваяПодсистемаКлиент.ОН_ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Описание", "Описание");
КонецПроцедуры

&НаКлиенте
Процедура ДоступенПриИзменении(Элемент)
	Объект.ТолькоДляАвтора = (Доступен = "ТолькоДляАвтора");
	ВариантыОтчетовКлиент.ВО_ПроверитьПользователейВариантаОтчета(ЭтотОбъект);
	ВариантыОтчетовКлиент.ВО_ОформитьПользователейВариантаОтчета(ЭтотОбъект, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)

КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ВО_ОформитьПользователейВариантаОтчета(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПередУдалением(Элемент, Отказ)
	Если Не ИспользоватьГруппыПользователей И Не ИспользоватьВнешнихПользователей Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ВариантыОтчетовКлиент.ВО_ПользователиВариантаОтчетаОбработкаВыбора(ЭтотОбъект, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПользователиВариантаПометкаПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ВО_ОформитьПользователейВариантаОтчета(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемИспользованиеПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ВО_ДеревоПодсистемИспользованиеПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ДеревоПодсистемВажностьПриИзменении(Элемент)
	ВариантыОтчетовКлиент.ВО_ДеревоПодсистемВажностьПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьПользователей(Команда)
	ВариантыОтчетовКлиент.ВО_ПодобратьПользователейВариантаОтчета(ЭтотОбъект, ИспользоватьГруппыПользователей);
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьГруппыВнешнихПользователей(Команда)
	ВариантыОтчетовКлиент.ВО_ПодобратьПользователейВариантаОтчета(ЭтотОбъект, Элементы.ПользователиВариантаГруппаПодобрать.Видимость, Истина);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();

	ВариантыОтчетовСервер.ВО_УстановитьУсловноеОформлениеСпискаПользователейВариантаОтчета(ЭтотОбъект);
	ВариантыОтчетовСервер.ВО_УстановитьУсловноеОформлениеДереваПодсистем(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция ПерезаполнитьДерево(Прочитать)
	ВыделенныеСтроки = ВариантыОтчетовСервер.О_ЗапомнитьВыделенныеСтроки(ЭтотОбъект, "ДеревоПодсистем", "Ссылка");
	Если Прочитать Тогда
		ЭтотОбъект.Прочитать();
	КонецЕсли;
	ДеревоПриемник = ВариантыОтчетовСервер.ВО_ДеревоПодсистемСформировать(ЭтотОбъект, Объект);
	ЗначениеВРеквизитФормы(ДеревоПриемник, "ДеревоПодсистем");
	ВариантыОтчетовСервер.О_ВосстановитьВыделенныеСтроки(ЭтотОбъект, "ДеревоПодсистем", ВыделенныеСтроки);

	Возврат Истина;
КонецФункции

&НаСервере
Процедура ЗаполнитьИзПредопределенного(ВариантОбъект)
	ЭтоПредопределенный = ВариантыОтчетовСервер.ВО_ЭтоПредопределенныйВариантОтчета(ВариантОбъект);

	Если Не ЭтоПредопределенный Тогда
		Возврат;
	КонецЕсли;

	ПредопределенныйВариант		= ВариантОбъект.ПредопределенныйВариант.ПолучитьОбъект();

	ВариантОбъект.Наименование	= ПредопределенныйВариант.Наименование;
	ВариантОбъект.Описание		= ПредопределенныйВариант.Описание;
КонецПроцедуры

&НаКлиенте
Процедура СпроситьОУведомленииПользователей(Отказ)
	Если Не УведомитьПользователей Или ВопросОУведомленииПользователейЗадан Тогда
		Возврат;
	КонецЕсли;

	КоличествоПользователей = КоличествоПользователейВариантОтчета(ПользователиВарианта);

	Если КоличествоПользователей < 10 Тогда
		Возврат;
	КонецЕсли;

	Отказ									= Истина;
	ВопросОУведомленииПользователейЗадан	= Истина;

	Обработчик = Новый ОписаниеОповещения("ПослеВопросаОУведомленииПользователей", ЭтотОбъект);
	ВариантыОтчетовКлиент.сВО_СпроситьОУведомленииПользователей(Обработчик, КоличествоПользователей);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОУведомленииПользователей(Ответ, ДополнительныеПараметры) Экспорт
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		УведомитьПользователей = Ложь;
	КонецЕсли;

	Записать();
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоПользователейВариантОтчета(ПользователиВарианта)
	Возврат РегистрыСведений.НастройкиВариантовОтчетов.КоличествоПользователейВариантОтчета(ПользователиВарианта);
КонецФункции
