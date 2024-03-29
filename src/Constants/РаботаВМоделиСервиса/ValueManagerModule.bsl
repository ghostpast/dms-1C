///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеСвойства.Вставить("ТекущееЗначение", Константы.РаботаВМоделиСервиса.Получить());
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	// Следующие константы взаимоисключающие, используются в отдельных функциональных опциях.

	Если Значение Тогда
		Константы.РаботаВЛокальномРежиме.Установить(Ложь);
		Константы.РаботаВАвтономномРежиме.Установить(Ложь);
	ИначеЕсли Константы.РаботаВАвтономномРежиме.Получить() Тогда
		Константы.РаботаВМоделиСервиса.Установить(Ложь);
	Иначе
		Константы.РаботаВЛокальномРежиме.Установить(Истина);
	КонецЕсли;

	Если ДополнительныеСвойства.ТекущееЗначение <> Значение Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;
КонецПроцедуры

#Иначе
ВызватьИсключение "Недопустимый вызов объекта на клиенте.";
#КонецЕсли
