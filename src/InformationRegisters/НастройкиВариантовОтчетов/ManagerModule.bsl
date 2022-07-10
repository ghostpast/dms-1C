///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура СброситьНастройки(ВариантСсылка = Неопределено) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	Если ВариантСсылка <> Неопределено Тогда
		НаборЗаписей.Отбор.Вариант.Установить(ВариантСсылка, Истина);
	КонецЕсли;
	НаборЗаписей.Записать(Истина);
КонецПроцедуры

Процедура ПрочитатьНастройкиДоступностиВариантаОтчета(ВариантОтчета, ПользователиВарианта, ИспользоватьГруппыПользователей = Неопределено, ИспользоватьВнешнихПользователей = Неопределено) Экспорт 
	Если Не ПравоДоступа("Чтение", Метаданные.Справочники.Пользователи) Тогда
		Возврат;
	КонецЕсли;

	ПользователиВарианта.Очистить();

	ИспользоватьГруппыПользователей		= ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
	ИспользоватьВнешнихПользователей	= ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");

	#Область ЗапросПользователейВарианта

	// АПК:96-вкл При получении результата объединения второго и третьего запросов, в результат могут попасть неуникальные записи.

	Запрос			= Новый Запрос;
	Запрос.Текст	=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИСТИНА КАК Пометка,
	|	Настройки.Пользователь КАК Значение,
	|	ПРЕДСТАВЛЕНИЕ(Настройки.Пользователь) КАК Представление,
	|	ВЫБОР
	|		КОГДА ТИПЗНАЧЕНИЯ(Настройки.Пользователь) = ТИП(Справочник.Пользователи)
	|			ТОГДА ""СостояниеПользователя02""
	|		КОГДА ТИПЗНАЧЕНИЯ(Настройки.Пользователь) = ТИП(Справочник.ГруппыВнешнихПользователей)
	|			ТОГДА ""СостояниеПользователя10""
	|		ИНАЧЕ ""СостояниеПользователя04""
	|	КОНЕЦ КАК Картинка,
	|	ИСТИНА В (
	|			ВЫБРАТЬ ПЕРВЫЕ 1
	|				ИСТИНА
	|			ИЗ
	|				РегистрСведений.СоставыГруппПользователей КАК СоставыГруппПользователей
	|			ГДЕ
	|				СоставыГруппПользователей.Пользователь = &ТекущийПользователь
	|				И СоставыГруппПользователей.ГруппаПользователей = Настройки.Пользователь
	|				И НЕ СоставыГруппПользователей.ГруппаПользователей В (
	|					ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи),
	|					ЗНАЧЕНИЕ(Справочник.ГруппыВнешнихПользователей.ВсеВнешниеПользователи))
	|		) КАК ЭтоТекущийПользователь
	|ИЗ
	|	РегистрСведений.НастройкиВариантовОтчетов КАК Настройки
	|ГДЕ
	|	(&ИспользоватьГруппыПользователей
	|		ИЛИ &ИспользоватьВнешнихПользователей)
	|	И Настройки.Вариант = &ВариантОтчета
	|	И ТИПЗНАЧЕНИЯ(Настройки.Пользователь) <> ТИП(Справочник.ВнешниеПользователи)
	|	И Настройки.Подсистема = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)
	|	И Настройки.Видимость
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА &ВариантОтчета В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.ВариантыОтчетов.ПустаяСсылка))
	|		ТОГДА Пользователи.Ссылка = &ТекущийПользователь
	|		ИНАЧЕ НЕ Настройки.Вариант ЕСТЬ NULL
	|	КОНЕЦ КАК Пометка,
	|	Пользователи.Ссылка КАК Значение,
	|	ПРЕДСТАВЛЕНИЕ(Пользователи.Ссылка) КАК Представление,
	|	""СостояниеПользователя02"" КАК Картинка,
	|	Пользователи.Ссылка = &ТекущийПользователь КАК ЭтоТекущийПользователь
	|ИЗ
	|	Справочник.Пользователи КАК Пользователи
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкиВариантовОтчетов КАК Настройки
	|		ПО Настройки.Вариант = &ВариантОтчета
	|		И Настройки.Пользователь В (Пользователи.Ссылка, НЕОПРЕДЕЛЕНО)
	|		И Настройки.Подсистема = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)
	|		И Настройки.Видимость
	|ГДЕ
	|	НЕ &ИспользоватьГруппыПользователей
	|	И НЕ &ИспользоватьВнешнихПользователей
	|	И НЕ Пользователи.ПометкаУдаления
	|	И НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.Служебный
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ИСТИНА КАК Пометка,
	|	Пользователи.Ссылка КАК Значение,
	|	ПРЕДСТАВЛЕНИЕ(Пользователи.Ссылка) КАК Представление,
	|	""СостояниеПользователя02"" КАК Картинка,
	|	Пользователи.Ссылка = &ТекущийПользователь КАК ЭтоТекущийПользователь
	|ИЗ
	|	РегистрСведений.НастройкиВариантовОтчетов КАК Настройки
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей КАК ГруппыПользователей
	|		ПО ГруппыПользователей.Ссылка = Настройки.Пользователь
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыПользователей.Состав КАК СоставыГруппПользователей
	|		ПО СоставыГруппПользователей.Ссылка = ГруппыПользователей.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО Пользователи.Ссылка = СоставыГруппПользователей.Пользователь
	|ГДЕ
	|	НЕ &ИспользоватьГруппыПользователей
	|	И НЕ &ИспользоватьВнешнихПользователей
	|	И Настройки.Вариант = &ВариантОтчета
	|	И Настройки.Подсистема = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)
	|	И Настройки.Видимость
	|	И НЕ ГруппыПользователей.ПометкаУдаления
	|	И НЕ Пользователи.ПометкаУдаления
	|	И НЕ Пользователи.Недействителен
	|	И НЕ Пользователи.Служебный
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ИСТИНА КАК Пометка,
	|	&ТекущийПользователь КАК Значение,
	|	ПРЕДСТАВЛЕНИЕ(&ТекущийПользователь) КАК Представление,
	|	""СостояниеПользователя02"" КАК Картинка,
	|	ИСТИНА КАК ЭтоТекущийПользователь
	|ГДЕ
	|	&ВариантОтчета В (НЕОПРЕДЕЛЕНО, ЗНАЧЕНИЕ(Справочник.ВариантыОтчетов.ПустаяСсылка))";

	Запрос.УстановитьПараметр("ВариантОтчета",						ВариантОтчета);
	Запрос.УстановитьПараметр("ИспользоватьГруппыПользователей",	ИспользоватьГруппыПользователей);
	Запрос.УстановитьПараметр("ИспользоватьВнешнихПользователей",	ИспользоватьВнешнихПользователей);
	Запрос.УстановитьПараметр("ТекущийПользователь",				ПользователиСервер.сП_АвторизованныйПользователь());

	// АПК:96-выкл При получении результата объединения второго и третьего запросов, в результат могут попасть неуникальные записи.

	#КонецОбласти

	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.НайтиСледующий(Неопределено, "Значение") Тогда
		ПользователиВарианта.Добавить(,, Истина, БиблиотекаКартинок.СостояниеПользователя04);

		Возврат;
	КонецЕсли;

	Выборка.Сбросить();

	Пока Выборка.Следующий() Цикл
		ЭлементСписка = ПользователиВарианта.Добавить();
		ЗаполнитьЗначенияСвойств(ЭлементСписка, Выборка,, "Картинка");
		ЭлементСписка.Картинка = БиблиотекаКартинок[Выборка.Картинка];

		Если Выборка.ЭтоТекущийПользователь Тогда
			ЭлементСписка.Представление = ЭлементСписка.Представление + " [ЭтоТекущийПользователь]";
		КонецЕсли;
	КонецЦикла;

	ПользователиВарианта.СортироватьПоЗначению();
КонецПроцедуры

Процедура ЗаписатьНастройкиДоступностиВариантаОтчета(ВариантОтчета, ЭтоНовыйВариантОтчета, ПользователиВарианта = Неопределено, УведомитьПользователей = Ложь) Экспорт 
	Если ПользователиВарианта = Неопределено Тогда
		ПользователиВарианта = ПользователиВариантаОтчетаПоУмолчанию(ВариантОтчета);
	КонецЕсли;

	Если ТипЗнч(ПользователиВарианта) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;

	НачатьТранзакцию();

	Попытка
		Блокировка = Новый БлокировкаДанных;

		Если Не ЭтоНовыйВариантОтчета Тогда
			ЭлементБлокировки = Блокировка.Добавить(Метаданные.РегистрыСведений.НастройкиВариантовОтчетов.ПолноеИмя());
			ЭлементБлокировки.УстановитьЗначение("Вариант", ВариантОтчета);
		КонецЕсли;

		Блокировка.Заблокировать();

		ДобавитьПользователейВариантаОтчета(ВариантОтчета, ПользователиВарианта, УведомитьПользователей);

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

Функция КоличествоПользователейВариантОтчета(ПользователиВарианта) Экспорт
	УстановитьПривилегированныйРежим(Истина);

	ВыбранныеПользователи = Новый Массив;

	ВсеПользователи = Справочники.ГруппыПользователей.ВсеПользователи;

	Для Каждого ПользовательВарианта Из ПользователиВарианта Цикл
		Если Не ПользовательВарианта.Пометка Тогда
			Продолжить;
		КонецЕсли;

		ВыбранныйПользователь = ПользовательВарианта.Значение;

		Если ВыбранныйПользователь = Неопределено Тогда
			ВыбранныйПользователь = ВсеПользователи;
		КонецЕсли;

		ВыбранныеПользователи.Добавить(ВыбранныйПользователь);
	КонецЦикла;

	Запрос			= Новый Запрос;
	Запрос.Текст	=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Составы.Пользователь) КАК КоличествоПользователей
	|ИЗ
	|	РегистрСведений.СоставыГруппПользователей КАК Составы
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО Пользователи.Ссылка = Составы.Пользователь
	|ГДЕ
	|	Составы.ГруппаПользователей В (&ВыбранныеПользователи)
	|	И Составы.Пользователь <> &ТекущийПользователь
	|	И НЕ ТИПЗНАЧЕНИЯ(Составы.Пользователь) В (
	|		ТИП(Справочник.ВнешниеПользователи),
	|		ТИП(Справочник.ГруппыВнешнихПользователей))
	|	И Составы.Используется
	|	И НЕ Пользователи.Служебный";

	Запрос.УстановитьПараметр("ВыбранныеПользователи",	ВыбранныеПользователи);
	Запрос.УстановитьПараметр("ТекущийПользователь",	ПользователиСервер.сП_АвторизованныйПользователь());

	Выборка = Запрос.Выполнить().Выбрать();

	Возврат ?(Выборка.Следующий(), Выборка.КоличествоПользователей, 0);
КонецФункции

Функция ПользователиВариантаОтчетаПоУмолчанию(ВариантОтчета)
	Если НастройкиДоступностиВариантаОтчетаУстановлены(ВариантОтчета) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Запрос			= Новый Запрос;
	Запрос.Текст	=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	НЕОПРЕДЕЛЕНО КАК Пользователь
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК Отчеты
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыОтчетов.Размещение КАК РазмещениеОтчетов
	|		ПО РазмещениеОтчетов.Ссылка = Отчеты.Ссылка
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов КАК ОтчетыКонфигурации
	|		ПО ОтчетыКонфигурации.Ссылка = Отчеты.ПредопределенныйВариант
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетов.Размещение КАК РазмещениеОтчетовКонфигурации
	|		ПО РазмещениеОтчетовКонфигурации.Ссылка = Отчеты.ПредопределенныйВариант
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетовРасширений КАК ОтчетыРасширений
	|		ПО ОтчетыРасширений.Ссылка = Отчеты.ПредопределенныйВариант
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПредопределенныеВариантыОтчетовРасширений.Размещение КАК РазмещениеОтчетовРасширений
	|		ПО РазмещениеОтчетовРасширений.Ссылка = Отчеты.ПредопределенныйВариант
	|ГДЕ
	|	Отчеты.Ссылка = &ВариантОтчета
	|	И ЕСТЬNULL(РазмещениеОтчетов.Использование, ИСТИНА)
	|	И НЕ ЕСТЬNULL(РазмещениеОтчетов.Подсистема,
	|		ЕСТЬNULL(РазмещениеОтчетовКонфигурации.Подсистема, РазмещениеОтчетовРасширений.Подсистема)) ЕСТЬ NULL
	|	И ЕСТЬNULL(ОтчетыКонфигурации.ВидимостьПоУмолчанию, ОтчетыРасширений.ВидимостьПоУмолчанию) = ИСТИНА";

	Запрос.УстановитьПараметр("ВариантОтчета", ВариантОтчета);

	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;

	ПользователиВарианта = Новый СписокЗначений;
	ПользователиВарианта.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ГруппыВнешнихПользователей, СправочникСсылка.ГруппыПользователей, СправочникСсылка.Пользователи");

	ПользователиВарианта.Добавить(,, Истина);

	Возврат ПользователиВарианта;
КонецФункции

Функция НастройкиДоступностиВариантаОтчетаУстановлены(ВариантОтчета)
	Запрос			= Новый Запрос;
	Запрос.Текст	=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ИСТИНА
	|ИЗ
	|	РегистрСведений.НастройкиВариантовОтчетов
	|ГДЕ
	|	Вариант = &ВариантОтчета
	|	И Подсистема = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)";

	Запрос.УстановитьПараметр("ВариантОтчета", ВариантОтчета);

	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

Процедура ДобавитьПользователейВариантаОтчета(ВариантОтчета, ПользователиВарианта, УведомитьПользователей)
	Записи = РегистрыСведений.НастройкиВариантовОтчетов.СоздатьНаборЗаписей();
	Записи.ДополнительныеСвойства.Вставить("УведомитьПользователей", УведомитьПользователей);

	Подсистема = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();

	ВключитьБизнесЛогику = Не ПараметрыСеанса.ВыполняетсяОбновлениеИБ;

	Записи.Отбор.Вариант.Установить(ВариантОтчета);
	Записи.Отбор.Подсистема.Установить(Подсистема);

	ОбщиеГруппыПользователей = Новый Массив;
	ОбщиеГруппыПользователей.Добавить(Справочники.ГруппыПользователей.ВсеПользователи);
	ОбщиеГруппыПользователей.Добавить(Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи);

	Если ПользователиВарианта.НайтиПоЗначению(Неопределено) <> Неопределено Или ПользователиВарианта.Количество() = 1 И ОбщиеГруппыПользователей.Найти(ПользователиВарианта[0].Значение) <> Неопределено Тогда
		Запись				= Записи.Добавить();
		Запись.Вариант		= ВариантОтчета;
		Запись.Подсистема	= Подсистема;
		Запись.Видимость	= Истина;

		ОбновлениеВерсииИБСервер.ОИБ_ЗаписатьНаборЗаписей(Записи,,, ВключитьБизнесЛогику);

		Возврат;
	КонецЕсли;

	ВыбранныеПользователи = ВыбранныеПользователиВариантаОтчета(ПользователиВарианта);

	Для Каждого Пользователь Из ВыбранныеПользователи Цикл
		Запись				= Записи.Добавить();
		Запись.Вариант		= ВариантОтчета;
		Запись.Пользователь	= Пользователь;
		Запись.Подсистема	= Подсистема;
		Запись.Видимость	= Истина;
	КонецЦикла;

	ОбновлениеВерсииИБСервер.ОИБ_ЗаписатьНаборЗаписей(Записи,,, ВключитьБизнесЛогику);
КонецПроцедуры

Функция ВыбранныеПользователиВариантаОтчета(ПользователиВарианта)
	ИспользоватьГруппыПользователей		= ПолучитьФункциональнуюОпцию("ИспользоватьГруппыПользователей");
	ИспользоватьВнешнихПользователей	= ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");

	Если ИспользоватьГруппыПользователей Или ИспользоватьВнешнихПользователей Тогда
		Возврат ПользователиВарианта.ВыгрузитьЗначения();
	КонецЕсли;

	ВыбранныеПользователи = Новый Массив;

	Для Каждого ЭлементСписка Из ПользователиВарианта Цикл
		Если ЭлементСписка.Пометка Тогда
			ВыбранныеПользователи.Добавить(ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;

	Возврат ВыбранныеПользователи;
КонецФункции

Процедура ОповеститьПользователейВариантаОтчета(Записи) Экспорт
	#Область Проверка

	// Зарезервировано для новых подсистем

	#КонецОбласти
КонецПроцедуры

Функция ПользователиВариантаОтчета(ВариантОтчета, ВыбранныеПользователи = Неопределено) Экспорт
	Запрос			= Новый Запрос;
	Запрос.Текст	=
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Составы.Пользователь КАК Ссылка,
	|	Пользователи.ИдентификаторПользователяИБ КАК Идентификатор
	|ИЗ
	|	РегистрСведений.НастройкиВариантовОтчетов КАК Настройки
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоставыГруппПользователей КАК Составы
	|		ПО Составы.ГруппаПользователей = Настройки.Пользователь
	|		ИЛИ Настройки.Пользователь = НЕОПРЕДЕЛЕНО
	|			И Составы.ГруппаПользователей = ЗНАЧЕНИЕ(Справочник.ГруппыПользователей.ВсеПользователи)
	|	ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	|		ПО Пользователи.Ссылка = Составы.Пользователь
	|ГДЕ
	|	Настройки.Вариант = &ВариантОтчета
	|	И Настройки.Подсистема = ЗНАЧЕНИЕ(Справочник.ИдентификаторыОбъектовМетаданных.ПустаяСсылка)
	|	И НЕ ТИПЗНАЧЕНИЯ(Настройки.Пользователь) В (
	|		ТИП(Справочник.ВнешниеПользователи),
	|		ТИП(Справочник.ГруппыВнешнихПользователей))
	|	И Настройки.Видимость
	|	И Составы.Используется
	|	И Пользователи.Ссылка <> &ТекущийПользователь
	|	И (НЕ &ПользователиВыбраны
	|		ИЛИ Пользователи.Ссылка В (&ВыбранныеПользователи))
	|	И НЕ Пользователи.Служебный";

	Запрос.УстановитьПараметр("ВариантОтчета",			ВариантОтчета);
	Запрос.УстановитьПараметр("ТекущийПользователь",	ПользователиСервер.сП_АвторизованныйПользователь());
	Запрос.УстановитьПараметр("ПользователиВыбраны",	ВыбранныеПользователи <> Неопределено);
	Запрос.УстановитьПараметр("ВыбранныеПользователи",	ВыбранныеПользователи);

	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	Вариант = ОбновлениеВерсииИБСервер.ОИБ_ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВариантыОтчетов");

	Данные					= Новый Структура("Вариант, Пользователь, Подсистема, Видимость, БыстрыйДоступ");
	Данные.Подсистема		= Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
	Данные.Видимость		= Истина;
	Данные.БыстрыйДоступ	= Ложь;

	МетаданныеРегистра		= Метаданные.РегистрыСведений.НастройкиВариантовОтчетов;
	ПредставлениеРегистра	= МетаданныеРегистра.Представление();

	Обработано	= 0;
	Отказано	= 0;

	Пока Вариант.Следующий() Цикл
		Данные.Вариант = Вариант.Ссылка;

		Попытка
			ПеренестиНастройкиДоступностиВариантаОтчета(Данные);
			Обработано = Обработано + 1;
		Исключение
			Отказано = Отказано + 1;

			ШаблонКомментария = "Не удалось перенести настройки доступности варианта отчета ""%1"" в регистр ""%2""
				|по причине: %3";

			Комментарий = СтрШаблон(ШаблонКомментария, Вариант.Ссылка, ПредставлениеРегистра, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

			ЗаписьЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Предупреждение, МетаданныеРегистра,, Комментарий);
		КонецПопытки;
	КонецЦикла;

	Параметры.ОбработкаЗавершена = НЕ ОбновлениеВерсииИБСервер.ОИБ_ЕстьДанныеДляОбработки(Параметры.Очередь, Метаданные.Справочники.ВариантыОтчетов.ПолноеИмя(), Неопределено);

	Если Обработано = 0 И Отказано <> 0 Тогда
		ШаблонСообщения = "Не удалось обработать некоторые настройки вариантов отчетов: %1";
		ТекстСообщения = СтрШаблон(ШаблонСообщения, Отказано);

		ВызватьИсключение ТекстСообщения;
	Иначе
		ШаблонКомментария = "Обработан очередной пакет настроек вариантов отчетов: %1";
		Комментарий = СтрШаблон(ШаблонКомментария, Обработано);
		ЗаписьЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Информация, МетаданныеРегистра,, Комментарий);
	КонецЕсли;
КонецПроцедуры

Процедура ПеренестиНастройкиДоступностиВариантаОтчета(Данные)
	НачатьТранзакцию();

	Попытка
		Блокировка = Новый БлокировкаДанных;

		ЭлементБлокировки = Блокировка.Добавить("Справочник.ВариантыОтчетов");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Данные.Вариант);

		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.НастройкиВариантовОтчетов");
		ЭлементБлокировки.УстановитьЗначение("Вариант", Данные.Вариант);

		Блокировка.Заблокировать();

		Записи = СоздатьНаборЗаписей();
		Записи.Отбор.Вариант.Установить(Данные.Вариант);
		Записи.Отбор.Пользователь.Установить(Данные.Пользователь);
		Записи.Отбор.Подсистема.Установить(Данные.Подсистема);

		Запись = Записи.Добавить();
		ЗаполнитьЗначенияСвойств(Запись, Данные);

		ОбновлениеВерсииИБСервер.ОИБ_ЗаписатьНаборЗаписей(Записи);
		ОбновлениеВерсииИБСервер.ОИБ_ОтметитьВыполнениеОбработки(Данные.Вариант);

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

#КонецЕсли
