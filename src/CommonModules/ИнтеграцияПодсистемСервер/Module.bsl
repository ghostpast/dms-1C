///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	// Зарезервировано для новых подсистем

	ОбновлениеВерсииИБСервер.сОИБ_ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);

		// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	// Зарезервировано для новых подсистем

	ПользователиСервер.сП_ПриДобавленииПараметровРаботыКлиента(Параметры);

	// Зарезервировано для новых подсистем

	БазоваяПодсистемаСервер.СП_ДобавитьПараметрыРаботыКлиента(Параметры);

	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПередЗапускомПрограммы() Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	ОбновлениеВерсииИБСервер.сОИБ_ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);
	ПользователиСервер.сП_ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики);

	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриУстановкеПараметровСеанса(Параметры) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОпределенииОбъектовСНачальнымЗаполнением(Объекты) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриДобавленииПодсистем(МодулиПодсистем) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	// Зарезервировано для новых подсистем

	БазоваяПодсистемаСервер.СП_ПриОпределенииНазначенияРолей(НазначениеРолей);

	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеЗаписиАдминистратораПриАвторизации(Комментарий) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриСозданииАдминистратора(Администратор, Уточнение) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеУстановкиПользователяИБ(Ссылка, ПарольПользователяСервиса) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОпределенииНастроек(Настройки) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриПолученииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриСохраненииПрочихНастроек(СведенияОПользователе, Настройки) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеОбновленияСоставовГруппПользователей(УчастникиИзменений, ИзмененныеГруппы) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеИзмененияОбъектаАвторизацииВнешнегоПользователя(ВнешнийПользователь, СтарыйОбъектАвторизации, НовыйОбъектАвторизации) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеДобавленияИзмененияПользователяИлиГруппы(Ссылка, ЭтоНовый) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОпределенииТекстаВопросаПередЗаписьюПервогоАдминистратора(ТекстВопроса) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОпределенииДействийВФорме(Ссылка, ДействияВФорме) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры
