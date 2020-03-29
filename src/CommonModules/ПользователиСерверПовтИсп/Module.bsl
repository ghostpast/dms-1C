///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область Пользователи

Функция сП_НедоступныеРолиПоТипуПользователя(ДляВнешнихПользователей) Экспорт
	Если ДляВнешнихПользователей Тогда
		НазначениеРолейПользователя = "ДляВнешнихПользователей";
	ИначеЕсли ПользователиСервер.П_ЭтоПолноправныйПользователь(, Истина, Ложь) Тогда
		// Пользователь с ролью АдминистраторСистемы в локальном режиме работы
		// может выдавать административные права.
		НазначениеРолейПользователя = "ДляАдминистраторов";
	Иначе
		НазначениеРолейПользователя = "ДляПользователей";
	КонецЕсли;

	Возврат сП_НедоступныеРоли(НазначениеРолейПользователя);
КонецФункции

Функция сП_НедоступныеРоли(Назначение = "ДляПользователей") Экспорт
	сП_ПроверитьНазначение(Назначение,
		"Ошибка в функции НедоступныеРоли общего модуля ПользователиСерверПовтИсп.");

	НазначениеРолей = сП_НазначениеРолей();
	НедоступныеРоли = Новый Соответствие;

	Для Каждого Роль Из Метаданные.Роли Цикл
		Если Назначение <> "ДляАдминистраторов"
		   И НазначениеРолей.ТолькоДляАдминистраторовСистемы.Получить(Роль.Имя) <> Неопределено
		 // Для внешних пользователей.
		 Или Назначение = "ДляВнешнихПользователей"
		   И НазначениеРолей.ТолькоДляВнешнихПользователей.Получить(Роль.Имя) = Неопределено
		   И НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Получить(Роль.Имя) = Неопределено
		 // Для пользователей.
		 Или (Назначение = "ДляПользователей" Или Назначение = "ДляАдминистраторов")
		   И НазначениеРолей.ТолькоДляВнешнихПользователей.Получить(Роль.Имя) <> Неопределено
		 // Совместно для пользователей и внешних пользователей.
		 Или Назначение = "СовместноДляПользователейИВнешнихПользователей"
		   И Не НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Получить(Роль.Имя) <> Неопределено Тогда

			НедоступныеРоли.Вставить(Роль.Имя, Истина);
		КонецЕсли;
	КонецЦикла;

	Возврат Новый ФиксированноеСоответствие(НедоступныеРоли);
КонецФункции

Функция сП_НазначениеРолей() Экспорт
	НазначениеРолей = ПользователиСервер.П_НазначениеРолей();

	Назначение = Новый Структура;
	Для Каждого ОписаниеНазначенияРолей Из НазначениеРолей Цикл
		Имена = Новый Соответствие;
		Для Каждого Имя Из ОписаниеНазначенияРолей.Значение Цикл
			Имена.Вставить(Имя, Истина);
		КонецЦикла;
		Назначение.Вставить(ОписаниеНазначенияРолей.Ключ, Новый ФиксированноеСоответствие(Имена));
	КонецЦикла;

	Возврат Новый ФиксированнаяСтруктура(Назначение);
КонецФункции

Процедура сП_ПроверитьНазначение(Назначение, ЗаголовокОшибки)
	Если Назначение <> "ДляАдминистраторов"
	   И Назначение <> "ДляПользователей"
	   И Назначение <> "ДляВнешнихПользователей"
	   И Назначение <> "СовместноДляПользователейИВнешнихПользователей" Тогда

		ВызватьИсключение ЗаголовокОшибки + Символы.ПС + Символы.ПС + СтрШаблон(
			"Параметр Назначение ""%1"" указан некорректно.
			           |
			           |Допустимы только следующие значения:
			           |- ""ДляАдминистраторов"",
			           |- ""ДляПользователей"",
			           |- ""ДляВнешнихПользователей"",
			           |- ""СовместноДляПользователейИВнешнихПользователей"".",
			Назначение);
	КонецЕсли;
КонецПроцедуры

Функция сП_СвойстваТекущегоПользователяИБ() Экспорт
	ПользовательИБ = ПользователиИнформационнойБазы.ТекущийПользователь();

	Свойства = Новый Структура;
	Свойства.Вставить("УказанТекущийПользовательИБ", Истина);
	Свойства.Вставить("УникальныйИдентификатор", ПользовательИБ.УникальныйИдентификатор);
	Свойства.Вставить("Имя",                     ПользовательИБ.Имя);

	Свойства.Вставить("ПравоАдминистрирование", ?(ПривилегированныйРежим(),
		ПравоДоступа("Администрирование", Метаданные, ПользовательИБ),
		ПравоДоступа("Администрирование", Метаданные)));

	Свойства.Вставить("РольДоступнаАдминистраторСистемы",
		РольДоступна(Метаданные.Роли.АдминистраторСистемы)); // Не заменять на РолиДоступны.

	Свойства.Вставить("РольДоступнаПолныеПрава",
		РольДоступна(Метаданные.Роли.ПолныеПрава)); // Не заменять на РолиДоступны.

	Возврат Новый ФиксированнаяСтруктура(Свойства);
КонецФункции

Функция сП_ЭтоСеансВнешнегоПользователя() Экспорт
	УстановитьПривилегированныйРежим(Истина);

	ПользовательИБ				= ПользователиИнформационнойБазы.ТекущийПользователь();
	ИдентификаторПользователяИБ	= ПользовательИБ.УникальныйИдентификатор;

	ПользователиСервер.П_НайтиНеоднозначныхПользователейИБ(Неопределено, ИдентификаторПользователяИБ);

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИдентификаторПользователяИБ", ИдентификаторПользователяИБ);

	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК ЗначениеИстина
	|ИЗ
	|	Справочник.ВнешниеПользователи КАК ВнешниеПользователи
	|ГДЕ
	|	ВнешниеПользователи.ИдентификаторПользователяИБ = &ИдентификаторПользователяИБ";

	// Пользователь, который не найден в справочнике ВнешниеПользователи не может быть внешним.
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции

Функция сП_Настройки() Экспорт
	Настройки = Новый Структура;
	Настройки.Вставить("ОбщиеНастройкиВхода", Истина);
	Настройки.Вставить("РедактированиеРолей", Истина);

	ИнтеграцияПодсистемСервер.ПриОпределенииНастроек(Настройки);

	ВсеНастройки = ПользователиСервер.сП_НастройкиВхода();
	ВсеНастройки.Вставить("ОбщиеНастройкиВхода", Настройки.ОбщиеНастройкиВхода);
	ВсеНастройки.Вставить("РедактированиеРолей", Настройки.РедактированиеРолей);

	Возврат БазоваяПодсистемаСервер.ОН_ФиксированныеДанные(ВсеНастройки);
КонецФункции

Функция сП_ПустыеСсылкиТиповОбъектовАвторизации() Экспорт
	ПустыеСсылки = Новый Массив;

	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ВнешнийПользователь.Тип.Типы() Цикл
		Если Не БазоваяПодсистемаСервер.ОН_ЭтоСсылка(Тип) Тогда
			Продолжить;
		КонецЕсли;
		ОписаниеТипаСсылки = Новый ОписаниеТипов(БазоваяПодсистемаКлиентСервер.ОН_ЗначениеВМассиве(Тип));
		ПустыеСсылки.Добавить(ОписаниеТипаСсылки.ПривестиЗначение(Неопределено));
	КонецЦикла;

	Возврат Новый ФиксированныйМассив(ПустыеСсылки);
КонецФункции

Функция сП_ВсеРоли() Экспорт
	Массив			= Новый Массив;
	Соответствие	= Новый Соответствие;

	Таблица			= Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(256)));

	Для каждого Роль Из Метаданные.Роли Цикл
		ИмяРоли = Роль.Имя;

		Массив.Добавить(ИмяРоли);
		Соответствие.Вставить(ИмяРоли, Роль.Синоним);
		Таблица.Добавить().Имя = ИмяРоли;
	КонецЦикла;

	ВсеРоли = Новый Структура;
	ВсеРоли.Вставить("Массив",       Новый ФиксированныйМассив(Массив));
	ВсеРоли.Вставить("Соответствие", Новый ФиксированноеСоответствие(Соответствие));
	ВсеРоли.Вставить("Таблица",      Новый ХранилищеЗначения(Таблица));

	Возврат БазоваяПодсистемаСервер.ОН_ФиксированныеДанные(ВсеРоли, Ложь);
КонецФункции

Функция сП_ДеревоРолей(ПоПодсистемам = Истина, Назначение = "ДляПользователей") Экспорт
	сП_ПроверитьНазначение(Назначение, "Ошибка в функции сП_ДеревоРолей общего модуля ПользователиСерверПовтИсп.");

	НедоступныеРоли = ПользователиСерверПовтИсп.сП_НедоступныеРоли(Назначение);

	Дерево = Новый ДеревоЗначений;
	Дерево.Колонки.Добавить("ЭтоРоль", Новый ОписаниеТипов("Булево"));
	Дерево.Колонки.Добавить("Имя",     Новый ОписаниеТипов("Строка"));
	Дерево.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(1000)));

	Если ПоПодсистемам Тогда
		сП_ЗаполнитьПодсистемыИРоли(Дерево.Строки, Неопределено, НедоступныеРоли);
	КонецЕсли;

	// Добавление ненайденных ролей.
	Для Каждого Роль Из Метаданные.Роли Цикл
		Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено Или ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
			Продолжить;
		КонецЕсли;

		Отбор = Новый Структура("ЭтоРоль, Имя", Истина, Роль.Имя);
		Если Дерево.Строки.НайтиСтроки(Отбор, Истина).Количество() = 0 Тогда
			СтрокаДерева				= Дерево.Строки.Добавить();
			СтрокаДерева.ЭтоРоль		= Истина;
			СтрокаДерева.Имя			= Роль.Имя;
			СтрокаДерева.Синоним	= ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЕсли;
	КонецЦикла;

	Дерево.Строки.Сортировать("ЭтоРоль Убыв, Синоним Возр", Истина);

	Возврат Новый ХранилищеЗначения(Дерево);
КонецФункции

Процедура сП_ЗаполнитьПодсистемыИРоли(КоллекцияСтрокДерева, Подсистемы, НедоступныеРоли, ВсеРоли = Неопределено)
	Если Подсистемы = Неопределено Тогда
		Подсистемы = Метаданные.Подсистемы;
	КонецЕсли;

	Если ВсеРоли = Неопределено Тогда
		ВсеРоли = Новый Соответствие;
		Для Каждого Роль Из Метаданные.Роли Цикл
			Если НедоступныеРоли.Получить(Роль.Имя) <> Неопределено  Или ВРег(Лев(Роль.Имя, СтрДлина("Удалить"))) = ВРег("Удалить") Тогда
				Продолжить;
			КонецЕсли;
			ВсеРоли.Вставить(Роль, Истина);
		КонецЦикла;
	КонецЕсли;

	Для Каждого Подсистема Из Подсистемы Цикл
		ОписаниеПодсистемы			= КоллекцияСтрокДерева.Добавить();
		ОписаниеПодсистемы.Имя		= Подсистема.Имя;
		ОписаниеПодсистемы.Синоним	= ?(ЗначениеЗаполнено(Подсистема.Синоним), Подсистема.Синоним, Подсистема.Имя);

		сП_ЗаполнитьПодсистемыИРоли(ОписаниеПодсистемы.Строки, Подсистема.Подсистемы, НедоступныеРоли, ВсеРоли);

		Для Каждого ОбъектМетаданных Из Подсистема.Состав Цикл
			Если ВсеРоли[ОбъектМетаданных] = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Роль					= ОбъектМетаданных;
			ОписаниеРоли			= ОписаниеПодсистемы.Строки.Добавить();
			ОписаниеРоли.ЭтоРоль	= Истина;
			ОписаниеРоли.Имя		= Роль.Имя;
			ОписаниеРоли.Синоним	= ?(ЗначениеЗаполнено(Роль.Синоним), Роль.Синоним, Роль.Имя);
		КонецЦикла;

		Отбор = Новый Структура("ЭтоРоль", Истина);
		Если ОписаниеПодсистемы.Строки.НайтиСтроки(Отбор, Истина).Количество() = 0 Тогда
			КоллекцияСтрокДерева.Удалить(ОписаниеПодсистемы);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
