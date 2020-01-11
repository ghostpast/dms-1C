///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбщегоНазначения

Процедура ОН_Проверить(Знач Условие, Знач Сообщение = "", Знач КонтекстПроверки = "") Экспорт
	Если Условие <> Истина Тогда
		Если ПустаяСтрока(Сообщение) Тогда
			ТекстИсключения = "Недопустимая операция"; // Assertion failed
		Иначе
			ТекстИсключения = Сообщение;
		КонецЕсли;

		Если Не ПустаяСтрока(КонтекстПроверки) Тогда
			ТекстИсключения = СтрШаблон(
				"%1 в %2",
				ТекстИсключения,
				КонтекстПроверки);
		КонецЕсли;

		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
КонецПроцедуры

Процедура ОН_ПроверитьПараметр(Знач ИмяПроцедурыИлиФункции, Знач ИмяПараметра, Знач ЗначениеПараметра,
	Знач ОжидаемыеТипы, Знач ОжидаемыеТипыСвойств = Неопределено) Экспорт

	Контекст = "БазоваяПодсистемаКлиентСервер.ПроверитьПараметр";

	ОН_Проверить(
		ТипЗнч(ИмяПроцедурыИлиФункции) = Тип("Строка"),
		"Недопустимое значение параметра ИмяПроцедурыИлиФункции",
		Контекст);

	ОН_Проверить(
		ТипЗнч(ИмяПараметра) = Тип("Строка"),
		"Недопустимое значение параметра ИмяПараметра",
		Контекст);

	ЭтоКорректныйТип = ОН_ЗначениеОжидаемогоТипа(ЗначениеПараметра, ОжидаемыеТипы);

	ОН_Проверить(
		ЭтоКорректныйТип <> Неопределено,
		"Недопустимое значение параметра ОжидаемыеТипы",
		Контекст);

	ОН_Проверить(
		ЭтоКорректныйТип,
		СтрШаблон(
			"Недопустимое значение параметра %1 в %2.
				|Ожидалось: %3; передано значение: %4 (тип %5).",
			ИмяПараметра,
			ИмяПроцедурыИлиФункции,
			ОН_ПредставлениеТипов(ОжидаемыеТипы),
			?(ЗначениеПараметра <> Неопределено,
				ЗначениеПараметра,
				"Неопределено"),
		ТипЗнч(ЗначениеПараметра)));

	Если ТипЗнч(ЗначениеПараметра) = Тип("Структура") И ОжидаемыеТипыСвойств <> Неопределено Тогда
		ОН_Проверить(
			ТипЗнч(ОжидаемыеТипыСвойств) = Тип("Структура"),
			"Недопустимое значение параметра ИмяПроцедурыИлиФункции",
			Контекст);

		Для каждого Свойство Из ОжидаемыеТипыСвойств Цикл
			ОжидаемоеИмяСвойства = Свойство.Ключ;
			ОжидаемыйТипСвойства = Свойство.Значение;
			ЗначениеСвойства = Неопределено;

			ОН_Проверить(
				ЗначениеПараметра.Свойство(ОжидаемоеИмяСвойства, ЗначениеСвойства),
				СтрШаблон(
					"Недопустимое значение параметра %1 (Структура) в %2.
						|В структуре ожидалось свойство %3 (тип %4).",
					ИмяПараметра,
					ИмяПроцедурыИлиФункции,
					ОжидаемоеИмяСвойства,
					ОжидаемыйТипСвойства));

			ЭтоКорректныйТип = ОН_ЗначениеОжидаемогоТипа(ЗначениеСвойства, ОжидаемыйТипСвойства);

			ОН_Проверить(
				ЭтоКорректныйТип,
				СтрШаблон(
					"Недопустимое значение свойства %1 в параметре %2 (Структура) в %3.
						|Ожидалось: %4; передано значение: %5 (тип %6).",
					ОжидаемоеИмяСвойства,
					ИмяПараметра,
					ИмяПроцедурыИлиФункции,
					ОН_ПредставлениеТипов(ОжидаемыеТипы),
					?(ЗначениеСвойства <> Неопределено,
						ЗначениеСвойства,
						"Неопределено"),
				ТипЗнч(ЗначениеСвойства)));
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

Функция ОН_ЗначениеОжидаемогоТипа(Значение, ОжидаемыеТипы)
	ТипЗначения = ТипЗнч(Значение);

	Если ТипЗнч(ОжидаемыеТипы) = Тип("ОписаниеТипов") Тогда
		Возврат ОжидаемыеТипы.СодержитТип(ТипЗначения);
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Тип") Тогда
		Возврат ТипЗначения = ОжидаемыеТипы;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Массив")
		Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированныйМассив") Тогда

		Возврат ОжидаемыеТипы.Найти(ТипЗначения) <> Неопределено;
	ИначеЕсли ТипЗнч(ОжидаемыеТипы) = Тип("Соответствие")
		Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированноеСоответствие") Тогда

		Возврат ОжидаемыеТипы.Получить(ТипЗначения) <> Неопределено;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

Функция ОН_ПредставлениеТипов(ОжидаемыеТипы)
	Если ТипЗнч(ОжидаемыеТипы) = Тип("Массив")
		Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированныйМассив")
		Или ТипЗнч(ОжидаемыеТипы) = Тип("Соответствие")
		Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированноеСоответствие") Тогда

		Результат	= "";
		Индекс		= 0;
		Для Каждого Элемент Из ОжидаемыеТипы Цикл
			Если ТипЗнч(ОжидаемыеТипы) = Тип("Соответствие")
				Или ТипЗнч(ОжидаемыеТипы) = Тип("ФиксированноеСоответствие") Тогда

				Тип = Элемент.Ключ;
			Иначе
				Тип = Элемент;
			КонецЕсли;

			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + ", ";
			КонецЕсли;

			Результат	= Результат + ОН_ПредставлениеТипа(Тип);
			Индекс	= Индекс + 1;
			Если Индекс > 10 Тогда
				Результат = СтрШаблон(
					"%1,... (всего %2 типов)",
					Результат,
					ОжидаемыеТипы.Количество());
				Прервать;
			КонецЕсли;
		КонецЦикла;

		Возврат Результат;
	Иначе
		Возврат ОН_ПредставлениеТипа(ОжидаемыеТипы);
	КонецЕсли;
КонецФункции

Функция ОН_ПредставлениеТипа(Тип)
	Если Тип = Неопределено Тогда
		Возврат "Неопределено";
	ИначеЕсли ТипЗнч(Тип) = Тип("ОписаниеТипов") Тогда
		ТипСтрокой = Строка(Тип);
		Возврат
			?(СтрДлина(ТипСтрокой) > 150,
				СтрШаблон(
					"%1,... (всего %2 типов)",
					Лев(ТипСтрокой, 150),
					Тип.Типы().Количество()),
				ТипСтрокой);
	Иначе
		ТипСтрокой = Строка(Тип);

		Возврат
			?(СтрДлина(ТипСтрокой) > 150,
				Лев(ТипСтрокой, 150) + "...",
				ТипСтрокой);
	КонецЕсли;
КонецФункции

Процедура ОН_ДополнитьСтруктуру(Приемник, Источник, Заменять = Неопределено) Экспорт
	Для Каждого Элемент Из Источник Цикл
		Если Заменять <> Истина И Приемник.Свойство(Элемент.Ключ) Тогда
			Если Заменять = Ложь Тогда
				Продолжить;
			Иначе
				ВызватьИсключение СтрШаблон("Пересечение ключей источника и приемника: ""%1"".", Элемент.Ключ);
			КонецЕсли
		КонецЕсли;
		Приемник.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла;
КонецПроцедуры

Функция ОН_СвойствоСтруктуры(Структура, Ключ, ЗначениеПоУмолчанию = Неопределено) Экспорт
	Если Структура = Неопределено Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;

	Результат = ЗначениеПоУмолчанию;
	Если Структура.Свойство(Ключ, Результат) Тогда
		Возврат Результат;
	Иначе
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
КонецФункции

#КонецОбласти
