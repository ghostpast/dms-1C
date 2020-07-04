///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


Перем ДанныеДляЗаписи;
Перем ПодготовленыДанные;

Процедура ПередЗаписью(Отказ, Замещение)
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.

	Если ПодготовленыДанные Тогда
		Загрузить(ДанныеДляЗаписи);
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	// Проверка значения свойства ОбменДанными.Загрузка отсутствует по причине того, что ограничения,
	// накладываемые данным кодом, не должны обходить установкой этого свойства равным Истина
	// (на стороне кода, который выполняет попытку записи в данный регистр).
	//
	// Данный регистр не должен входить в любые обмены или операции выгрузки / загрузки данных при включенном
	// разделении по областям данных.
КонецПроцедуры

Процедура ПодготовитьДанныеДляЗаписи() Экспорт
	ПараметрыПолучения = Неопределено;
	Если Не ДополнительныеСвойства.Свойство("ПараметрыПолучения", ПараметрыПолучения) Тогда
		ВызватьИсключение "Не определены параметры получения данных";
	КонецЕсли;

	ДанныеДляЗаписи = Выгрузить();

	Для Каждого Строка Из ДанныеДляЗаписи Цикл
		Данные			= РегистрыСведений.КэшПрограммныхИнтерфейсов.ПодготовитьДанныеКэшаВерсий(Строка.ТипДанных, ПараметрыПолучения);
		Строка.Данные	= Новый ХранилищеЗначения(Данные);
	КонецЦикла;

	ПодготовленыДанные = Истина;
КонецПроцедуры

ДанныеДляЗаписи		= Новый ТаблицаЗначений;
ПодготовленыДанные	= Ложь;

#Иначе
ВызватьИсключение "Недопустимый вызов объекта на клиенте.";
#КонецЕсли
