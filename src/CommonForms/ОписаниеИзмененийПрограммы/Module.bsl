///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НастройкиПодсистемы  = ОбновлениеВерсииИБСервер.сОИБ_НастройкиПодсистемы();
	АдресФормыВПрограмме = НастройкиПодсистемы.РасположениеОписанияИзмененийПрограммы;

	Если ЗначениеЗаполнено(АдресФормыВПрограмме) Тогда
		Элементы.АдресФормыВПрограмме.Заголовок = АдресФормыВПрограмме;
	КонецЕсли;

	Если Не Параметры.ПоказыватьТолькоИзменения Тогда
		Элементы.АдресФормыВПрограмме.Видимость = Ложь;
	КонецЕсли;

	Заголовок = СтрШаблон("Что нового в конфигурации %1", Метаданные.Синоним);

	Если ЗначениеЗаполнено(Параметры.ВремяНачалаОбновления) Тогда
		ВремяНачалаОбновления = Параметры.ВремяНачалаОбновления;
		ВремяОкончанияОбновления = Параметры.ВремяОкончанияОбновления;
	КонецЕсли;

	Разделы			= ОбновлениеВерсииИБСервер.сОИБ_НеотображавшиесяРазделыОписанияИзменений();
	ПоследняяВерсия	= ОбновлениеВерсииИБСервер.сОИБ_ПоследняяВерсияОтображенияИзмененийСистемы();

	Если Разделы.Количество() = 0 Тогда
		ДокументОписаниеОбновлений = Метаданные.ОбщиеМакеты.Найти("ОписаниеИзмененийСистемы");
		Если ДокументОписаниеОбновлений <> Неопределено
			И (ПоследняяВерсия = Неопределено
				Или Не Параметры.ПоказыватьТолькоИзменения) Тогда
			ВсеРазделы = ОбновлениеВерсииИБСервер.сОИБ_РазделыОписанияИзменений();
			Если ТипЗнч(ВсеРазделы) = Тип("СписокЗначений") И ВсеРазделы.Количество() <> 0 Тогда
				Для Каждого Элемент Из ВсеРазделы Цикл
					Разделы.Добавить(Элемент.Представление);
				КонецЦикла;
				ДокументОписаниеОбновлений = ОбновлениеВерсииИБСервер.сОИБ_ДокументОписаниеОбновлений(Разделы);
			Иначе
				ДокументОписаниеОбновлений = ПолучитьОбщийМакет(ДокументОписаниеОбновлений);
			КонецЕсли;
		Иначе
			ДокументОписаниеОбновлений = Новый ТабличныйДокумент();
		КонецЕсли;
	Иначе
		ДокументОписаниеОбновлений = ОбновлениеВерсииИБСервер.сОИБ_ДокументОписаниеОбновлений(Разделы);
	КонецЕсли;

	Если ДокументОписаниеОбновлений.ВысотаТаблицы = 0 Тогда
		Текст = СтрШаблон("Конфигурация успешно обновлена на версию %1", Метаданные.Версия);
		ДокументОписаниеОбновлений.Область("R1C1:R1C1").Текст = Текст;
	КонецЕсли;

	ОписанияПодсистем  = БазоваяПодсистемаСерверПовтИсп.СП_ОписанияПодсистем();
	Для каждого ИмяПодсистемы Из ОписанияПодсистем.Порядок Цикл
		ОписаниеПодсистемы = ОписанияПодсистем.ПоИменам.Получить(ИмяПодсистемы);
		Если НЕ ЗначениеЗаполнено(ОписаниеПодсистемы.ОсновнойСерверныйМодуль) Тогда
			Продолжить;
		КонецЕсли;
		Модуль = БазоваяПодсистемаСервер.ОН_ОбщийМодуль(ОписаниеПодсистемы.ОсновнойСерверныйМодуль);
		Модуль.ПриПодготовкеМакетаОписанияОбновлений(ДокументОписаниеОбновлений);
	КонецЦикла;

	ОписаниеОбновлений.Очистить();
	ОписаниеОбновлений.Вывести(ДокументОписаниеОбновлений);

	СведенияОбОбновлении		= ОбновлениеВерсииИБСервер.сОИБ_СведенияОбОбновленииИнформационнойБазы();
	ВремяНачалаОбновления		= СведенияОбОбновлении.ВремяНачалаОбновления;
	ВремяОкончанияОбновления	= СведенияОбОбновлении.ВремяОкончанияОбновления;

	Если СведенияОбОбновлении.ОтложенноеОбновлениеЗавершеноУспешно <> Неопределено
		Или СведенияОбОбновлении.ДеревоОбработчиков <> Неопределено
			И СведенияОбОбновлении.ДеревоОбработчиков.Строки.Количество() = 0 Тогда
		Элементы.ОтложенноеОбновление.Видимость = Ложь;
	КонецЕсли;

	Если БазоваяПодсистемаСервер.ОН_ИнформационнаяБазаФайловая() Тогда
		ЗаголовокСообщения								= "Необходимо выполнить дополнительные процедуры обработки данных";
		Элементы.ОтложенноеОбновлениеДанных.Заголовок	= ЗаголовокСообщения;
	КонецЕсли;

	Если Не ПользователиСервер.П_ЭтоПолноправныйПользователь(, Истина) Тогда
		Элементы.ОтложенноеОбновлениеДанных.Заголовок = "Не выполнены дополнительные процедуры обработки данных";
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ВремяНачалаОбновления) И Не ЗначениеЗаполнено(ВремяОкончанияОбновления) Тогда
		Элементы.ТехническаяИнформацияОРезультатахОбновления.Видимость = Ложь;
	ИначеЕсли ПользователиСервер.П_ЭтоПолноправныйПользователь() Тогда
		Элементы.ТехническаяИнформацияОРезультатахОбновления.Видимость = Истина;
	Иначе
		Элементы.ТехническаяИнформацияОРезультатахОбновления.Видимость = Ложь;
	КонецЕсли;

	КлиентСервернаяБаза = Не БазоваяПодсистемаСервер.ОН_ИнформационнаяБазаФайловая();

	// Отображение информации о блокировке регламентных заданий.
	Если Не КлиентСервернаяБаза
		И ПользователиСервер.П_ЭтоПолноправныйПользователь(, Истина) Тогда
		ПараметрЗапускаКлиента					= ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска");
		ВыполненоОтключениеРегламентныхЗаданий	= СтрНайти(ПараметрЗапускаКлиента, "РегламентныеЗаданияОтключены") <> 0;
		Если Не ВыполненоОтключениеРегламентныхЗаданий Тогда
			Элементы.ГруппаОтключеныРегламентныеЗадания.Видимость = Ложь;
		КонецЕсли;
	Иначе
		Элементы.ГруппаОтключеныРегламентныеЗадания.Видимость = Ложь;
	КонецЕсли;

	Элементы.ОписаниеОбновлений.ГоризонтальнаяПолосаПрокрутки = ИспользованиеПолосыПрокрутки.НеИспользовать;

	ОбновлениеВерсииИБСервер.сОИБ_УстановитьФлагОтображенияОписанийПоТекущуюВерсию();

	Если БазоваяПодсистемаСервер.ОН_ЭтоМобильныйКлиент() Тогда
		Элементы.КоманднаяПанельФормы.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если КлиентСервернаяБаза Тогда
		ПодключитьОбработчикОжидания("ОбновитьСтатусОтложенногоОбновления", 60);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОбновленийВыбор(Элемент, Область, СтандартнаяОбработка)
	Если ТипЗнч(Область) = Тип("ОбластьЯчеекТабличногоДокумента") И (СтрНайти(Область.Текст, "http://") = 1 Или СтрНайти(Область.Текст, "https://") = 1) Тогда
		БазоваяПодсистемаКлиент.ФС_ОткрытьНавигационнуюСсылку(Область.Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСведенияОРезультатахОбновленияНажатие(Элемент)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьОшибкиИПредупреждения",	Истина);
	ПараметрыФормы.Вставить("ДатаНачала",						ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания",					ВремяОкончанияОбновления);

	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОтложенноеОбновлениеДанных(Команда)
	ОткрытьФорму("Обработка.РезультатыОбновленияПрограммы.Форма.РезультатыОбновленияПрограммы");
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусОтложенногоОбновления()
	ОбновитьСтатусОтложенногоОбновленияНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьСтатусОтложенногоОбновленияНаСервере()
	СведенияОбОбновлении = ОбновлениеВерсииИБСервер.сОИБ_СведенияОбОбновленииИнформационнойБазы();
	Если СведенияОбОбновлении.ВремяОкончаниеОтложенногоОбновления <> Неопределено Тогда
		Элементы.ОтложенноеОбновление.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтключеныРегламентныеЗаданияОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Оповещение		= Новый ОписаниеОповещения("ОтключеныРегламентныеЗаданияОбработкаНавигационнойСсылкиЗавершение", ЭтотОбъект);
	ТекстВопроса	= "Перезапустить программу?";
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
КонецПроцедуры

&НаКлиенте
Процедура ОтключеныРегламентныеЗаданияОбработкаНавигационнойСсылкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		НовыйПараметрЗапуска = СтрЗаменить(ПараметрЗапуска, "РегламентныеЗаданияОтключены", "");
		НовыйПараметрЗапуска = СтрЗаменить(НовыйПараметрЗапуска, "ЗапуститьОбновлениеИнформационнойБазы", "");
		НовыйПараметрЗапуска = "/C """ + НовыйПараметрЗапуска + """";
		ПрекратитьРаботуСистемы(Истина, НовыйПараметрЗапуска);
	КонецЕсли;
КонецПроцедуры
