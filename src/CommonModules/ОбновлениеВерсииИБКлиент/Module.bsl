///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбновлениеИнформационнойБазы

Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	ПараметрыКлиента = БазоваяПодсистемаКлиентПовтИсп.СП_ПараметрыРаботыКлиентаПриЗапуске();

	Если ПараметрыКлиента.Свойство("ИнформационнаяБазаЗаблокированаДляОбновления") Тогда
		Кнопки	= Новый СписокЗначений;
		Кнопки.Добавить("Перезапустить", "Перезапустить");
		Кнопки.Добавить("Завершить",     "Завершить работу");

		ПараметрыВопроса	= Новый Структура;
		ПараметрыВопроса.Вставить("КнопкаПоУмолчанию",	"Перезапустить");
		ПараметрыВопроса.Вставить("КнопкаТаймаута",		"Перезапустить");
		ПараметрыВопроса.Вставить("Таймаут",			60);

		ОписаниеПредупреждения	= Новый Структура;
		ОписаниеПредупреждения.Вставить("Кнопки",				Кнопки);
		ОписаниеПредупреждения.Вставить("ПараметрыВопроса",		ПараметрыВопроса);
		ОписаниеПредупреждения.Вставить("ТекстПредупреждения",	ПараметрыКлиента.ИнформационнаяБазаЗаблокированаДляОбновления);

		Параметры.Отказ						= Истина;
		Параметры.ИнтерактивнаяОбработка	= Новый ОписаниеОповещения("СП_ПоказатьПредупреждениеИПродолжить", БазоваяПодсистемаКлиент, ОписаниеПредупреждения);
	КонецЕсли;
КонецПроцедуры

Процедура ПередНачаломРаботыСистемы2(Параметры) Экспорт
	ПараметрыКлиента = БазоваяПодсистемаКлиентПовтИсп.СП_ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("НеобходимоВыполнитьОбработчикиОтложенногоОбновления") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОИБ_ИнтерактивнаяОбработкаПроверкиСтатусаОтложенногоОбновления", ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

Процедура ПередНачаломРаботыСистемы3(Параметры) Экспорт
	ПараметрыКлиента	= БазоваяПодсистемаКлиентПовтИсп.СП_ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыКлиента.Свойство("НеобходимоОбновлениеПараметровРаботыПрограммы") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОИБ_ЗагрузитьОбновитьПараметрыРаботыПрограммы", ОбновлениеВерсииИБКлиент);
	КонецЕсли;
КонецПроцедуры

Процедура ПередНачаломРаботыСистемы4(Параметры) Экспорт
	ПараметрыРаботыКлиента = БазоваяПодсистемаКлиентПовтИсп.СП_ПараметрыРаботыКлиентаПриЗапуске();

	Если ПараметрыРаботыКлиента.Свойство("НеобходимоОбновлениеИнформационнойБазы") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения("ОИБ_НачатьОбновлениеИнформационнойБазы", ЭтотОбъект);
	Иначе
		Если ПараметрыРаботыКлиента.Свойство("ЗагрузитьСообщениеОбменаДанными") Тогда
			Перезапустить	= Ложь;
			ОбновлениеВерсииИБВызовСервера.сОИБ_ВыполнитьОбновлениеИнформационнойБазы(Истина, Перезапустить);
			Если Перезапустить Тогда
				Параметры.Отказ			= Истина;
				Параметры.Перезапустить	= Истина;
			КонецЕсли;
		КонецЕсли;
		ОИБ_ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры);
	КонецЕсли;
КонецПроцедуры

Процедура ПередНачаломРаботыСистемы5(Параметры) Экспорт
	Если БазоваяПодсистемаКлиент.ОН_ИнформационнаяБазаФайловая() И СтрНайти(ПараметрЗапуска, "ВыполнитьОбновлениеИЗавершитьРаботу") > 0 Тогда
		ПрекратитьРаботуСистемы();
	КонецЕсли;
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	ОИБ_ПоказатьОписаниеИзмененийСистемы();
КонецПроцедуры

Процедура ОИБ_НачатьОбновлениеИнформационнойБазы(Параметры, ОбработкаПродолжения) Экспорт
	ИмяПараметра	= "СтандартныеПодсистемы.ОбновлениеВерсииИБ.ФормаИндикацияХодаОбновленияИБ";
	Форма			= ПараметрыПриложения.Получить(ИмяПараметра);

	Если Форма = Неопределено Тогда
		ИмяФормы	= "Обработка.РезультатыОбновленияПрограммы.Форма.ОбновлениеВерсииПрограммы";
		Форма		= ОткрытьФорму(ИмяФормы,,,,,, Новый ОписаниеОповещения("ОИБ_ПослеЗакрытияФормыИндикацияХодаОбновленияИБ", ЭтотОбъект, Параметры));
		ПараметрыПриложения.Вставить(ИмяПараметра, Форма);
	КонецЕсли;

	Форма.ОбновитьИнформационнуюБазу();
КонецПроцедуры

Процедура ОИБ_ПослеНачалаРаботыСистемы() Экспорт
	ПараметрыКлиента = БазоваяПодсистемаКлиентПовтИсп.СП_ПараметрыРаботыКлиентаПриЗапуске();

	Если ПараметрыКлиента.Свойство("ПоказатьСообщениеОбОшибочныхОбработчиках")
		Или ПараметрыКлиента.Свойство("ПоказатьОповещениеОНевыполненныхОбработчиках") Тогда

		ПодключитьОбработчикОжидания("ОИБ_ПроверитьСтатусОтложенногоОбновления", 2, Истина);
	КонецЕсли;
КонецПроцедуры

Процедура ОИБ_ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры, Контекст) Экспорт
	ИмяФормы	= "Обработка.РезультатыОбновленияПрограммы.Форма.ОбновлениеВерсииПрограммы";
	Форма		= ОткрытьФорму(ИмяФормы,,,,,, Новый ОписаниеОповещения("ОИБ_ПослеЗакрытияФормыИндикацияХодаОбновленияИБ", ЭтотОбъект, Параметры));
	ПараметрыПриложения.Вставить("СтандартныеПодсистемы.ОбновлениеВерсииИБ.ФормаИндикацияХодаОбновленияИБ", Форма);
	Форма.ЗагрузитьОбновитьПараметрыРаботыПрограммы(Параметры);
КонецПроцедуры

Процедура ОИБ_ПослеЗакрытияФормыИндикацияХодаОбновленияИБ(Результат, Параметры) Экспорт
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Результат = Новый Структура("Отказ, Перезапустить", Истина, Ложь);
	КонецЕсли;

	Если Результат.Отказ Тогда
		Параметры.Отказ = Истина;
		Если Результат.Перезапустить Тогда
			Параметры.Перезапустить = Истина;
		КонецЕсли;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
КонецПроцедуры

Процедура ОИБ_ИнтерактивнаяОбработкаПроверкиСтатусаОтложенногоОбновления(Параметры, Контекст) Экспорт
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.ОтложенноеОбновлениеНеЗавершено",,,,,, Новый ОписаниеОповещения("ОИБ_ПослеЗакрытияФормыПроверкиСтатусаОтложенногоОбновления",ЭтотОбъект, Параметры));
КонецПроцедуры

Процедура ОИБ_ПослеЗакрытияФормыПроверкиСтатусаОтложенногоОбновления(Результат, Параметры) Экспорт
	Если Результат <> Истина Тогда
		Параметры.Отказ = Истина;
	КонецЕсли;

	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
КонецПроцедуры

Процедура ОИБ_ОповеститьОтложенныеОбработчикиНеВыполнены() Экспорт
	Если БазоваяПодсистемаКлиент.СП_ПараметрКлиента("ЭтоСеансВнешнегоПользователя") Тогда
		Возврат;
	КонецЕсли;

	ПоказатьОповещениеПользователя(
		"Работа в программе временно ограничена",
		"e1cib/app/Обработка.РезультатыОбновленияПрограммы",
		"Не завершен переход на новую версию",
		БиблиотекаКартинок.Предупреждение32);
КонецПроцедуры

Процедура ОИБ_ЗакрытьФормуИндикацииХодаОбновленияЕслиОткрыта(Параметры)
	ИмяПараметра	= "СтандартныеПодсистемы.ОбновлениеВерсииИБ.ФормаИндикацияХодаОбновленияИБ";
	Форма			= ПараметрыПриложения.Получить(ИмяПараметра);
	Если Форма = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Форма.Открыта() Тогда
		Форма.НачатьЗакрытие();
	КонецЕсли;
	ПараметрыПриложения.Удалить(ИмяПараметра);
КонецПроцедуры

Процедура ОИБ_ПоказатьОписаниеИзмененийСистемы()
	ПараметрыРаботыКлиента	= БазоваяПодсистемаКлиентПовтИсп.СП_ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.ПоказатьОписаниеИзмененийСистемы Тогда
		ПараметрыФормы	= Новый Структура;
		ПараметрыФормы.Вставить("ПоказыватьТолькоИзменения", Истина);

		ОткрытьФорму("ОбщаяФорма.ОписаниеИзмененийПрограммы", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры

Процедура ОИБ_ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя <> "Отчет.ПрогрессОтложенногоОбновления" Тогда
		Возврат;
	КонецЕсли;

	Расшифровка = Область.Расшифровка;

	Расшифровка			= ФормаОтчета.ОтчетТабличныйДокумент.ТекущаяОбласть.Расшифровка;
	ЗначениеРасшифровки	= ОбновлениеВерсииИБВызовСервера.сОИБ_ДанныеРасшифровкиОтчета(ФормаОтчета.ОтчетДанныеРасшифровки, Расшифровка);

	Если ЗначениеРасшифровки <> Неопределено Тогда
		Если ЗначениеРасшифровки.ИмяПоля = "ЕстьОшибки" Тогда
			Значение = ЗначениеРасшифровки.Значение;
			Если Значение.Количество() <> 3 Тогда
				Возврат;
			КонецЕсли;

			ЕстьОшибки = Значение[1];
			Если ЕстьОшибки = Истина Тогда
				СтандартнаяОбработка	= Ложь;
				ОтборЖурнала			= Новый Структура;
				ОтборЖурнала.Вставить("Уровень", "Ошибка");
				ОтборЖурнала.Вставить("СобытиеЖурналаРегистрации","Обновление информационной базы");
				ОтборЖурнала.Вставить("ДатаНачала", ЗначениеРасшифровки.НачалоОбновления);
				ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", ОтборЖурнала, Неопределено);
			КонецЕсли;
		ИначеЕсли ЗначениеРасшифровки.ИмяПоля = "ПроблемаВДанных" Тогда
			Значение = ЗначениеРасшифровки.Значение;
			Если Значение.Количество() <> 3 Тогда
				Возврат;
			КонецЕсли;

			ЕстьОшибки = Значение[2];
			Если ЕстьОшибки = Истина Тогда
				СтандартнаяОбработка = Ложь;

				// Зарезервировано для новых подсистем
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОИБ_ПриОбработкеКоманды(ФормаОтчета, Команда, Результат) Экспорт
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя = "Отчет.ПрогрессОтложенногоОбновления" Тогда
		Расшифровка			= ФормаОтчета.ОтчетТабличныйДокумент.ТекущаяОбласть.Расшифровка;
		Кеш					= ФормаОтчета.Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("Кеш");
		КешПриоритетов		= ФормаОтчета.Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("КешПриоритетов");
		ЗначениеРасшифровки	= ОбновлениеВерсииИБВызовСервера.сОИБ_ДанныеРасшифровкиОтчета(ФормаОтчета.ОтчетДанныеРасшифровки, Расшифровка, Кеш.Значение, КешПриоритетов.Значение);

		Если ЗначениеРасшифровки = Неопределено Тогда
			Возврат;
		КонецЕсли;

		Если Команда.Имя = "ПрогрессОтложенногоОбновленияЗависимости" И ЗначениеРасшифровки.ИмяПоля = "ОбработчикОбновления" Тогда
			ОткрытьФорму("Отчет.ПрогрессОтложенногоОбновления.Форма.ЗависимостьОбработчика", ЗначениеРасшифровки);
		ИначеЕсли Команда.Имя = "ПрогрессОтложенногоОбновленияОшибки" Тогда
			ОтборЖурнала = Новый Структура;
			ОтборЖурнала.Вставить("Уровень", "Ошибка");
			ОтборЖурнала.Вставить("СобытиеЖурналаРегистрации", "Обновление информационной базы");
			ОтборЖурнала.Вставить("ДатаНачала", ЗначениеРасшифровки.НачалоОбновления);
			ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", ОтборЖурнала, Неопределено);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
