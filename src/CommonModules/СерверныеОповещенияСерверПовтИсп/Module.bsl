///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СерверныеОповещения

Функция сСО_ЭтоСеансОтправкиСерверныхОповещенийКлиентам() Экспорт
	Если ТекущийРежимЗапуска() <> Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	ТекущееФоновоеЗадание = ПолучитьТекущийСеансИнформационнойБазы().ПолучитьФоновоеЗадание();
	Если ТекущееФоновоеЗадание = Неопределено Или ТекущееФоновоеЗадание.ИмяМетода <> Метаданные.РегламентныеЗадания.ОтправкаСерверныхОповещенийКлиентам.ИмяМетода Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
КонецФункции

#КонецОбласти
