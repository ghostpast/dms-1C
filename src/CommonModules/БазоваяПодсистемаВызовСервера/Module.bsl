///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СтандартныеПодсистемы

Процедура СП_СкрытьРабочийСтолПриНачалеРаботыСистемы(Скрыть = Истина) Экспорт
	Если ТекущийРежимЗапуска() = Неопределено Тогда
		Возврат;
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);

	// Сохранение или восстановление состава форм начальной страницы.
	КлючОбъекта         = "Общее/НастройкиНачальнойСтраницы";
	КлючОбъектаХранения = "Общее/НастройкиНачальнойСтраницыПередОчисткой";
	СохраненныеНастройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъектаХранения, "");

	Если ТипЗнч(Скрыть) <> Тип("Булево") Тогда
		Скрыть = ТипЗнч(СохраненныеНастройки) = Тип("ХранилищеЗначения");
	КонецЕсли;

	Если Скрыть Тогда
		Если ТипЗнч(СохраненныеНастройки) <> Тип("ХранилищеЗначения") Тогда
			ТекущиеНастройки = ХранилищеСистемныхНастроек.Загрузить(КлючОбъекта);
			СохраняемыеНастройки = Новый ХранилищеЗначения(ТекущиеНастройки);
			ХранилищеСистемныхНастроек.Сохранить(КлючОбъектаХранения, "", СохраняемыеНастройки);
		КонецЕсли;
		БазоваяПодсистемаСервер.СП_УстановитьПустуюФормуНаРабочийСтол();
	Иначе
		Если ТипЗнч(СохраненныеНастройки) = Тип("ХранилищеЗначения") Тогда
			СохраненныеНастройки = СохраненныеНастройки.Получить();
			Если СохраненныеНастройки = Неопределено Тогда
				ХранилищеСистемныхНастроек.Удалить(КлючОбъекта, Неопределено,
					ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
			Иначе
				ХранилищеСистемныхНастроек.Сохранить(КлючОбъекта, "", СохраненныеНастройки);
			КонецЕсли;
			ХранилищеСистемныхНастроек.Удалить(КлючОбъектаХранения, Неопределено,
				ПользователиИнформационнойБазы.ТекущийПользователь().Имя);
		КонецЕсли;
	КонецЕсли;

	ТекущиеПараметры = Новый Соответствие(ПараметрыСеанса.ПараметрыКлиентаНаСервере);

	Если Скрыть Тогда
		ТекущиеПараметры.Вставить("СкрытьРабочийСтолПриНачалеРаботыСистемы", Истина);
	ИначеЕсли ТекущиеПараметры.Получить("СкрытьРабочийСтолПриНачалеРаботыСистемы") <> Неопределено Тогда
		ТекущиеПараметры.Удалить("СкрытьРабочийСтолПриНачалеРаботыСистемы");
	КонецЕсли;

	ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ТекущиеПараметры);
КонецПроцедуры


Процедура СП_ПроверитьПравоОтключитьЛогикуНачалаРаботыСистемы() Экспорт
	СП_СкрытьРабочийСтолПриНачалеРаботыСистемы(Истина);

	Если Не ПравоДоступа("Администрирование", Метаданные) Тогда
		ВызватьИсключение "Недостаточно прав для работы с отключенной логикой работы системы.";
	КонецЕсли;

	ПользователиСервер.сП_ПроверитьПраваТекущегоПользователяПриВходе();
КонецПроцедуры

Функция СП_ЗаписатьОшибкуВЖурналРегистрацииПриЗапускеИлиЗавершении(ПрекратитьРаботу, Знач Событие, Знач ТекстОшибки) Экспорт
	Если Событие = "Запуск" Тогда
		ИмяСобытия = "Запуск программы";
		Если ПрекратитьРаботу Тогда
			НачалоОписанияОшибки = "Возникла исключительная ситуация при запуске программы. Запуск программы аварийно завершен.";
		Иначе
			НачалоОписанияОшибки = "Возникла исключительная ситуация при запуске программы.";
		КонецЕсли;
	Иначе
		ИмяСобытия				= "Завершение программы";
		НачалоОписанияОшибки	= "Возникла исключительная ситуация при завершении программы.";
	КонецЕсли;

	ОписаниеОшибки = НачалоОписанияОшибки
		+ Символы.ПС + Символы.ПС
		+ ТекстОшибки;

	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, Неопределено, Неопределено, ОписаниеОшибки, РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);

	Возврат НачалоОписанияОшибки;
КонецФункции

Функция СП_ПараметрыРаботыКлиентаПриЗапуске(Параметры) Экспорт
	НовыеПараметры = Новый Структура;
	СП_ДобавитьПоправкиКВремени(НовыеПараметры, Параметры);

	Параметры.Вставить("ИменаВременныхПараметров", Новый Массив);

	Для каждого КлючИЗначение Из Параметры Цикл
		Параметры.ИменаВременныхПараметров.Добавить(КлючИЗначение.Ключ);
	КонецЦикла;

	БазоваяПодсистемаКлиентСервер.ОН_ДополнитьСтруктуру(Параметры, НовыеПараметры);

	СП_ОбработатьПараметрыКлиентаНаСервере(Параметры);

	Если Параметры.ПолученныеПараметрыКлиента <> Неопределено Тогда
		Если НЕ Параметры.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
			// Обновить состояние скрытия рабочего стола, если при предыдущем
			// запуске произошел сбой до момента штатного восстановления.
			СП_СкрытьРабочийСтолПриНачалеРаботыСистемы(Неопределено);
		КонецЕсли;
	КонецЕсли;

	Если НЕ БазоваяПодсистемаСервер.СП_ДобавитьПараметрыРаботыКлиентаПриЗапуске(Параметры) Тогда
		Возврат СП_ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры);
	КонецЕсли;

	ПользователиСервер.сП_ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры, Неопределено, Ложь);

	ИнтеграцияПодсистемСервер.ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры);

	Возврат СП_ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры);
КонецФункции

Функция СП_ФиксированныеПараметрыКлиентаБезВременныхПараметров(Параметры)
	ПараметрыКлиента	= Параметры;
	Параметры			= Новый Структура;

	Для каждого ИмяВременногоПараметра Из ПараметрыКлиента.ИменаВременныхПараметров Цикл
		Параметры.Вставить(ИмяВременногоПараметра, ПараметрыКлиента[ИмяВременногоПараметра]);
		ПараметрыКлиента.Удалить(ИмяВременногоПараметра);
	КонецЦикла;
	Параметры.Удалить("ИменаВременныхПараметров");

	УстановитьПривилегированныйРежим(Истина);

	Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы =
		ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить(
			"СкрытьРабочийСтолПриНачалеРаботыСистемы") <> Неопределено;

	УстановитьПривилегированныйРежим(Ложь);

	Возврат БазоваяПодсистемаСервер.ОН_ФиксированныеДанные(ПараметрыКлиента);
КонецФункции

Процедура СП_ОбработатьПараметрыКлиентаНаСервере(Знач Параметры)
	ПривилегированныйРежимУстановленПриЗапуске = ПривилегированныйРежим();
	УстановитьПривилегированныйРежим(Истина);

	Если ПараметрыСеанса.ПараметрыКлиентаНаСервере.Количество() = 0 Тогда
		// Первый серверный вызов с клиента при запуске.
		ПараметрыКлиента = Новый Соответствие;
		ПараметрыКлиента.Вставить("ПараметрЗапуска",							Параметры.ПараметрЗапуска);
		ПараметрыКлиента.Вставить("СтрокаСоединенияИнформационнойБазы",			Параметры.СтрокаСоединенияИнформационнойБазы);
		ПараметрыКлиента.Вставить("ПривилегированныйРежимУстановленПриЗапуске",	ПривилегированныйРежимУстановленПриЗапуске);
		ПараметрыКлиента.Вставить("ЭтоВебКлиент",								Параметры.ЭтоВебКлиент);
		ПараметрыКлиента.Вставить("ЭтоМобильныйКлиент",							Параметры.ЭтоМобильныйКлиент);
		ПараметрыКлиента.Вставить("ЭтоLinuxКлиент",								Параметры.ЭтоLinuxКлиент);
		ПараметрыКлиента.Вставить("ЭтоMacOSКлиент",								Параметры.ЭтоMacOSКлиент);
		ПараметрыКлиента.Вставить("ЭтоWindowsКлиент",							Параметры.ЭтоWindowsКлиент);
		ПараметрыКлиента.Вставить("ИспользуемыйКлиент",							Параметры.ИспользуемыйКлиент);
		ПараметрыКлиента.Вставить("ОперативнаяПамять",							Параметры.ОперативнаяПамять);
		ПараметрыКлиента.Вставить("КаталогПрограммы",							Параметры.КаталогПрограммы);
		ПараметрыКлиента.Вставить("ИдентификаторКлиента",						Параметры.ИдентификаторКлиента);
		ПараметрыКлиента.Вставить("РазрешениеОсновногоЭкрана",					Параметры.РазрешениеОсновногоЭкрана);

		ПараметрыСеанса.ПараметрыКлиентаНаСервере = Новый ФиксированноеСоответствие(ПараметрыКлиента);

		Если СтрНайти(НРег(Параметры.ПараметрЗапуска), НРег("ЗапуститьОбновлениеИнформационнойБазы")) > 0 Тогда
			ОбновлениеВерсииИБСервер.сОИБ_УстановитьЗапускОбновленияИнформационнойБазы(Истина);
		КонецЕсли;

		Если ПланыОбмена.ГлавныйУзел() <> Неопределено
			Или ЗначениеЗаполнено(Константы.ГлавныйУзел.Получить()) Тогда
			// Предотвращение случайного обновления предопределенных данных в подчиненном узле РИБ:
			// - при запуске с временно отмененным главным узлом;
			// - при реструктуризации данных в процессе восстановления узла.
			Если ПолучитьОбновлениеПредопределенныхДанныхИнформационнойБазы()
				<> ОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически Тогда
				УстановитьОбновлениеПредопределенныхДанныхИнформационнойБазы(
				ОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически);
			КонецЕсли;
			Если ПланыОбмена.ГлавныйУзел() <> Неопределено
				И Не ЗначениеЗаполнено(Константы.ГлавныйУзел.Получить()) Тогда
				// Сохранение главного узла для возможности восстановления.
				БазоваяПодсистемаСервер.СП_СохранитьГлавныйУзел();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция СП_ПараметрыРаботыКлиента(СвойстваКлиента) Экспорт
	Параметры = Новый Структура;
	СП_ДобавитьПоправкиКВремени(Параметры, СвойстваКлиента);

	ИнтеграцияПодсистемСервер.ПриДобавленииПараметровРаботыКлиента(Параметры);

	Возврат БазоваяПодсистемаСервер.ОН_ФиксированныеДанные(Параметры);
КонецФункции

Процедура СП_ДобавитьПоправкиКВремени(Параметры, СвойстваКлиента)
	ДатаСеанса				= ТекущаяДатаСеанса();
	ДатаСеансаУниверсальная	= УниверсальноеВремя(ДатаСеанса, ЧасовойПоясСеанса());

	Параметры.Вставить("ПоправкаКВремениСеанса",			ДатаСеанса - СвойстваКлиента.ТекущаяДатаНаКлиенте);
	Параметры.Вставить("ПоправкаКУниверсальномуВремени",	ДатаСеансаУниверсальная - ДатаСеанса);
	Параметры.Вставить("СмещениеСтандартногоВремени",		СмещениеСтандартногоВремени(ЧасовойПоясСеанса()));
	Параметры.Вставить("СмещениеДатыКлиента",				ТекущаяУниверсальнаяДатаВМиллисекундах()
		- СвойстваКлиента.ТекущаяУниверсальнаяДатаВМиллисекундахНаКлиенте);
КонецПроцедуры

Процедура СП_ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры) Экспорт
	Параметры.Вставить("КонфигурацияБазыДанныхИзмененаДинамически", КонфигурацияБазыДанныхИзмененаДинамически()
		Или Справочники.ВерсииРасширений.РасширенияИзмененыДинамически());

	ПользователиСервер.сП_ПриВыполненииСтандартныхПериодическихПроверокНаСервере(Параметры);

    // Зарезервировано для новых подсистем
КонецПроцедуры

#КонецОбласти

#Область ОбщегоНазначения

Процедура ОН_ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Настройки,
			ОписаниеНастроек = Неопределено,
			ИмяПользователя = Неопределено,
			ОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт

	БазоваяПодсистемаСервер.ОН_ХранилищеСохранить(ХранилищеОбщихНастроек,
		КлючОбъекта,
		КлючНастроек,
		Настройки,
		ОписаниеНастроек,
		ИмяПользователя,
		ОбновитьПовторноИспользуемыеЗначения);
КонецПроцедуры

#КонецОбласти
