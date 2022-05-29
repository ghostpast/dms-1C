///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	Если ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ПроверитьЗаполнениеПредопределенного(Отказ);
	КонецЕсли;
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если Не ДополнительныеСвойства.Свойство("ЗаполнениеПредопределенных") Тогда
		ВызватьИсключение "Запись в справочник ""Предопределенные варианты отчетов"" запрещена. Его данные заполняются автоматически.";
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьЗаполнениеПредопределенного(Отказ)
	Если ПометкаУдаления Тогда
		Возврат;
	КонецЕсли;
	Если ЗначениеЗаполнено(Отчет) Тогда
		Возврат;
	КонецЕсли;

	ВызватьИсключение "Не заполнено поле ""Отчет""";
КонецПроцедуры

#Иначе
ВызватьИсключение "Недопустимый вызов объекта на клиенте.";
#КонецЕсли
