///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Не ПустаяСтрока(Параметры.ТекстПредложения) Тогда
		Элементы.ДекорацияПояснение.Заголовок = Параметры.ТекстПредложения
			+ Символы.ПС
			+ "Установить?";
	ИначеЕсли Не Параметры.ВозможноПродолжениеБезУстановки Тогда
		Элементы.ДекорацияПояснение.Заголовок =
			"Для выполнения действия требуется установить расширение для работы с 1С:Предприятием.
			           |Установить?";
	КонецЕсли;
	Если Не Параметры.ВозможноПродолжениеБезУстановки Тогда
		Элементы.ПродолжитьБезУстановки.Заголовок	= "Отмена";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИПродолжить(Команда)
	Оповещение = Новый ОписаниеОповещения("УстановитьИПродолжитьЗавершение", ЭтотОбъект);
	НачатьУстановкуРасширенияРаботыСФайлами(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьБезУстановки(Команда)
	Закрыть("БольшеНеПредлагать");
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИПродолжитьЗавершение(Контекст) Экспорт
	Оповещение = Новый ОписаниеОповещения("УстановитьИПродолжитьПослеПодключенияРасширения", ЭтотОбъект);
	НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИПродолжитьПослеПодключенияРасширения(Подключено, Контекст) Экспорт
	Если Подключено Тогда
		Закрыть("РасширениеПодключено");
	Иначе
		Закрыть("ПродолжитьБезУстановки");
	КонецЕсли;
КонецПроцедуры
