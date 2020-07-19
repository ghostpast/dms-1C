///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ВариантыОтчетов

Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	Если Не СистемаВзаимодействия.ИспользованиеДоступно() Тогда
		Возврат;
	КонецЕсли;

	Обработчик	= Новый ОписаниеОповещения("ВО_ОбработатьДействияСообщения", ВариантыОтчетовКлиент);
	СистемаВзаимодействия.ПодключитьОбработчикДействияСообщения(Обработчик);
КонецПроцедуры

Процедура ВО_ОбработатьДействияСообщения(Сообщение, Действие, ДополнительныеПараметры) Экспорт
	Если Действие = "ПрименитьПереданныеНастройки" Тогда
		Оповестить(Действие, Сообщение.Данные);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
