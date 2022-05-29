///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт
	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;
КонецПроцедуры

Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт
	Элемент								= Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных	= "ВсеПользователи";
	Элемент.Наименование				= "Все пользователи";
КонецПроцедуры

#КонецЕсли
