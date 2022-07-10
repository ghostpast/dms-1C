///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// Зарезервировано для новых подсистем

	Если ЗначениеЗаполнено(Параметры.ПодробноеПредставлениеОшибки) Тогда
		БазоваяПодсистемаСервер.ЖР_ДобавитьСообщениеДляЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Ошибка,,, Параметры.ПодробноеПредставлениеОшибки);
	КонецЕсли;

	ТекстСообщенияОбОшибке = СтрШаблон("При обновлении версии программы возникла ошибка:
		|
		|%1",
		Параметры.КраткоеПредставлениеОшибки);

	Элементы.ТекстСообщенияОбОшибке.Заголовок	= ТекстСообщенияОбОшибке;

	ВремяНачалаОбновления		= Параметры.ВремяНачалаОбновления;
	ВремяОкончанияОбновления	= ТекущаяДатаСеанса();

	Если Не ПользователиСервер.П_ЭтоПолноправныйПользователь(, Истина) Тогда
		Элементы.ФормаОткрытьВнешнююОбработку.Видимость = Ложь;
	КонецЕсли;

	// Зарезервировано для новых подсистем

	ИспользуютсяПрофилиБезопасности = Ложь;

	// Зарезервировано для новых подсистем

	Элементы.ФормаПроверитьНаличиеИсправлений.Видимость = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Зарезервировано для новых подсистем
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСведенияОРезультатахОбновленияНажатие(Элемент)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала",		ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания",	ВремяОкончанияОбновления);
	ПараметрыФормы.Вставить("ЗапускатьНеВФоне",	Истина);

	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПерезагрузитьПрограмму(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработку(Команда)
	ОбработкаПродолжения = Новый ОписаниеОповещения("ОткрытьВнешнююОбработкуПослеПодтвержденияБезопасности", ЭтотОбъект);
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ПредупреждениеБезопасности",,,,,, ОбработкаПродолжения);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработкуПослеПодтвержденияБезопасности(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;

	// Зарезервировано для новых подсистем

	Оповещение = Новый ОписаниеОповещения("ОткрытьВнешнююОбработкуЗавершение", ЭтотОбъект);
	ПараметрыЗагрузки							= БазоваяПодсистемаКлиент.ФС_ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы		= УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр				= "Внешняя обработка(*.epf)|*.epf";
	ПараметрыЗагрузки.Диалог.МножественныйВыбор	= Ложь;
	ПараметрыЗагрузки.Диалог.Заголовок			= "Выберите внешнюю обработку";
	БазоваяПодсистемаКлиент.ФС_ЗагрузитьФайл(Оповещение, ПараметрыЗагрузки);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ИмяВнешнейОбработки = ПодключитьВнешнююОбработку(Результат.Хранение);
		ОткрытьФорму(ИмяВнешнейОбработки + ".Форма");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПодключитьВнешнююОбработку(АдресВоВременномХранилище)
	Если Не ПользователиСервер.П_ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение "Недостаточно прав доступа.";
	КонецЕсли;

	Менеджер		= ВнешниеОбработки;
	ИмяОбработки	= Менеджер.Подключить(АдресВоВременномХранилище, , Ложь, БазоваяПодсистемаСервер.ОН_ОписаниеЗащитыБезПредупреждений());

	Возврат Менеджер.Создать(ИмяОбработки, Ложь).Метаданные().ПолноеИмя();
КонецФункции

&НаКлиенте
Процедура ПроверитьНаличиеИсправлений(Команда)
	Результат = ДоступныеИсправленияНаСервере();

	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Ошибка Тогда
		ПоказатьПредупреждение(, Результат.КраткоеОписаниеОшибки);

		Возврат;
	КонецЕсли;

	ПараметрыВопроса										= БазоваяПодсистемаКлиент.СП_ПараметрыВопросаПользователю();
	ПараметрыВопроса.ПредлагатьБольшеНеЗадаватьЭтотВопрос	= Ложь;
	ПараметрыВопроса.Заголовок								= "Проверка наличия исправлений";
	ПараметрыВопроса.Картинка								= БиблиотекаКартинок.Информация;

	Если Результат.КоличествоИсправлений = 0 Тогда
		Сообщение = "Доступных исправлений (патчей) не найдено.";
		БазоваяПодсистемаКлиент.СП_ПоказатьВопросПользователю(Неопределено, Сообщение, РежимДиалогаВопрос.ОК, ПараметрыВопроса);

		Возврат;
	КонецЕсли;

	Сообщение = "Найдено исправлений: %1. Выполнить установку?";
	Сообщение = СтрШаблон(Сообщение, Результат.КоличествоИсправлений);

	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьДоступныеИсправленияПродолжение", ЭтотОбъект, Результат);

	ПараметрыВопроса.Картинка			= БиблиотекаКартинок.Вопрос32;
	ПараметрыВопроса.КнопкаПоУмолчанию	= КодВозвратаДиалога.Да;
	БазоваяПодсистемаКлиент.СП_ПоказатьВопросПользователю(ОписаниеОповещения, Сообщение, РежимДиалогаВопрос.ДаНет, ПараметрыВопроса);
КонецПроцедуры

&НаСервере
Функция ДоступныеИсправленияНаСервере()
	Результат = Неопределено;
	// Зарезервировано для новых подсистем

	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ПроверитьДоступныеИсправленияПродолжение(Результат, ДополнительныеПараметры) Экспорт
	Возврат;

	// Зарезервировано для новых подсистем
КонецПроцедуры
