///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПараметрРаботыРасширения(ИмяПараметра, БезУчетаВерсииРасширений = Ложь) Экспорт
	ВерсияРасширений = ?(БезУчетаВерсииРасширений, Справочники.ВерсииРасширений.ПустаяСсылка(), ПараметрыСеанса.ВерсияРасширений);

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПараметрыРаботыВерсийРасширений.ХранилищеПараметра
	|ИЗ
	|	РегистрСведений.ПараметрыРаботыВерсийРасширений КАК ПараметрыРаботыВерсийРасширений
	|ГДЕ
	|	ПараметрыРаботыВерсийРасширений.ВерсияРасширений = &ВерсияРасширений
	|	И ПараметрыРаботыВерсийРасширений.ИмяПараметра = &ИмяПараметра";
	Запрос.УстановитьПараметр("ВерсияРасширений", ВерсияРасширений);
	Запрос.УстановитьПараметр("ИмяПараметра", ИмяПараметра);

	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ХранилищеПараметра.Получить();
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);

	Возврат Неопределено;
КонецФункции

Процедура УстановитьПараметрРаботыРасширения(ИмяПараметра, Значение, БезУчетаВерсииРасширений = Ложь) Экспорт
	ВерсияРасширений					= ?(БезУчетаВерсииРасширений, Справочники.ВерсииРасширений.ПустаяСсылка(), ПараметрыСеанса.ВерсияРасширений);

	НаборЗаписей						= РегистрыСведений.ПараметрыРаботыПрограммы.СлужебныйНаборЗаписей(РегистрыСведений.ПараметрыРаботыВерсийРасширений);
	НаборЗаписей.Отбор.ВерсияРасширений.Установить(ВерсияРасширений);
	НаборЗаписей.Отбор.ИмяПараметра.Установить(ИмяПараметра);

	НоваяЗапись							= НаборЗаписей.Добавить();
	НоваяЗапись.ВерсияРасширений		= ВерсияРасширений;
	НоваяЗапись.ИмяПараметра			= ИмяПараметра;
	НоваяЗапись.ХранилищеПараметра		= Новый ХранилищеЗначения(Значение);

	НаборЗаписей.Записать();
КонецПроцедуры

Процедура ОчиститьВсеПараметрыРаботыРасширений() Экспорт
	УстановитьПривилегированныйРежим(Истина);

	НачатьТранзакцию();
	Попытка
		НаборЗаписей						= РегистрыСведений.ПараметрыРаботыПрограммы.СлужебныйНаборЗаписей(РегистрыСведений.ИдентификаторыОбъектовВерсийРасширений);
		НаборЗаписей.Отбор.ВерсияРасширений.Установить(ПараметрыСеанса.ВерсияРасширений);
		НаборЗаписей.Записать();

		НаборЗаписей						= РегистрыСведений.ПараметрыРаботыПрограммы.СлужебныйНаборЗаписей(РегистрыСведений.ПараметрыРаботыВерсийРасширений);
		НаборЗаписей.Отбор.ВерсияРасширений.Установить(ПараметрыСеанса.ВерсияРасширений);
		НаборЗаписей.Записать();

		ИнтеграцияПодсистемСервер.ПриОчисткеВсехПараметровРаботыРасширений();

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

Процедура ЗаполнитьВсеПараметрыРаботыРасширений() Экспорт
	// Заполнить идентификаторы объектов метаданных расширений.
	Если ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) Тогда
		Обновить	= Справочники.ИдентификаторыОбъектовРасширений.ИдентификаторыОбъектовТекущейВерсииРасширенийЗаполнены();
		БазоваяПодсистемаСерверПовтИсп.СП_ИдентификаторыОбъектовМетаданныхПроверкаИспользования(Истина, Истина);
	Иначе
		Обновить = Истина;
	КонецЕсли;

	Если Обновить Тогда
		Справочники.ИдентификаторыОбъектовРасширений.ОбновитьДанныеСправочника();
	КонецЕсли;

	// Зарезервировано для новых подсистем

	ИнтеграцияПодсистемСервер.ПриЗаполненииВсехПараметровРаботыРасширений();

	ИмяПараметра = "СтандартныеПодсистемы.БазоваяФункциональность.ДатаПоследнегоЗаполненияВсехПараметровРаботыРасширений";
	РегистрыСведений.ПараметрыРаботыВерсийРасширений.УстановитьПараметрРаботыРасширения(ИмяПараметра, ТекущаяДатаСеанса(), Истина);

	// Зарезервировано для новых подсистем
КонецПроцедуры

#КонецЕсли