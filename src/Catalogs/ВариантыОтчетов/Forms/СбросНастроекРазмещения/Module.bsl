///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Варианты = БазоваяПодсистемаКлиентСервер.ОН_СвойствоСтруктуры(Параметры, "Варианты"); // Массив из СправочникСсылка.ВариантыОтчетов
	Если ТипЗнч(Варианты) <> Тип("Массив") Тогда
		ТекстОшибки = "Не указаны варианты отчетов.";

		Возврат;
	КонецЕсли;

	ОпределитьПоведениеВМобильномКлиенте();
	ИзменяемыеВарианты.ЗагрузитьЗначения(Варианты);
	Отфильтровать();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, ТекстОшибки);
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура КомандаСбросить(Команда)
	КоличествоВыбранныхВариантов = ИзменяемыеВарианты.Количество();
	Если КоличествоВыбранныхВариантов = 0 Тогда
		ПоказатьПредупреждение(, "Не указаны варианты отчетов.");

		Возврат;
	КонецЕсли;

	КоличествоВариантов = СброситьНастройкиРазмещенияСервер(ИзменяемыеВарианты);
	Если КоличествоВариантов = 1 И КоличествоВыбранныхВариантов = 1 Тогда
		СсылкаВарианта		= ИзменяемыеВарианты[0].Значение;
		ОповещениеЗаголовок	= "Сброшены настройки размещения варианта отчета";
		ОповещениеСсылка	= ПолучитьНавигационнуюСсылку(СсылкаВарианта);
		ОповещениеТекст		= Строка(СсылкаВарианта);
		ПоказатьОповещениеПользователя(ОповещениеЗаголовок, ОповещениеСсылка, ОповещениеТекст);
	Иначе
		ОповещениеТекст = "Сброшены настройки размещения
		|вариантов отчетов (%1 шт.).";
		ОповещениеТекст = СтрШаблон(ОповещениеТекст, Формат(КоличествоВариантов, "ЧН=0; ЧГ=0"));
		ПоказатьОповещениеПользователя(, , ОповещениеТекст);
	КонецЕсли;
	ВариантыОтчетовКлиент.ВО_ОбновитьОткрытыеФормы();
	Закрыть();
КонецПроцедуры

&НаСервереБезКонтекста
Функция СброситьНастройкиРазмещенияСервер(Знач ИзменяемыеВарианты)
	КоличествоВариантов = 0;
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		Для Каждого ЭлементСписка Из ИзменяемыеВарианты Цикл
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ЭлементСписка.Значение);
		КонецЦикла;
		Блокировка.Заблокировать();

		Для Каждого ЭлементСписка Из ИзменяемыеВарианты Цикл
			ВариантОбъект = ЭлементСписка.Значение.ПолучитьОбъект(); // СправочникОбъект.ВариантыОтчетов
			Если ВариантыОтчетовСервер.ВО_СброситьНастройкиВариантаОтчета(ВариантОбъект) Тогда
				ВариантОбъект.Записать();
				КоличествоВариантов = КоличествоВариантов + 1;
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;

	Возврат КоличествоВариантов;
КонецФункции

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	Если Не БазоваяПодсистемаСервер.ОН_ЭтоМобильныйКлиент() Тогда
		Возврат;
	КонецЕсли;

	ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
КонецПроцедуры

&НаСервере
Процедура Отфильтровать()
	КоличествоДоФильтрации = ИзменяемыеВарианты.Количество();

	Запрос			= Новый Запрос;
	Запрос.Текст	=
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВариантыОтчетовРазмещение.Ссылка
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетовРазмещение
	|ГДЕ
	|	ВариантыОтчетовРазмещение.Ссылка В(&МассивВариантов)
	|	И ВариантыОтчетовРазмещение.Пользовательский = ЛОЖЬ
	|	И ВариантыОтчетовРазмещение.ТипОтчета В (&ТипВнутренний, &ТипРасширение)
	|	И ВариантыОтчетовРазмещение.ПометкаУдаления = ЛОЖЬ";

	Запрос.УстановитьПараметр("МассивВариантов",	ИзменяемыеВарианты.ВыгрузитьЗначения());
	Запрос.УстановитьПараметр("ТипВнутренний",		Перечисления.ТипыОтчетов.Внутренний);
	Запрос.УстановитьПараметр("ТипРасширение",		Перечисления.ТипыОтчетов.Расширение);

	МассивВариантов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	ИзменяемыеВарианты.ЗагрузитьЗначения(МассивВариантов);

	КоличествоПослеФильтрации = ИзменяемыеВарианты.Количество();
	Если КоличествоДоФильтрации <> КоличествоПослеФильтрации Тогда
		Если КоличествоПослеФильтрации = 0 Тогда
			ТекстОшибки = "Сброс настроек размещения выбранных вариантов отчетов не требуется по одной или нескольким причинам:
			|- Выбраны пользовательские варианты отчетов.
			|- Выбраны помеченные на удаление варианты отчетов.
			|- Выбраны варианты дополнительных или внешних отчетов.";
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
