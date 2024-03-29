///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	// Зарезервировано для новых подсистем

	// Проверка минимальных прав на вход в программу.
	Параметры.Модули.Добавить(ПользователиКлиент);

	// Проверка блокировки информационной базы для обновления.
	Параметры.Модули.Добавить(ОбновлениеВерсииИБКлиент);

	// Проверка минимально допустимой версии платформы для запуска.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", БазоваяПодсистемаКлиент, 2));

	// Проверка необходимости восстановления связи с главным узлом.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", БазоваяПодсистемаКлиент, 3));

	// Проверка необходимости выбора начальных неизменяемых настроек ИБ (основной язык, часовой пояс).
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", БазоваяПодсистемаКлиент, 4));

	// Зарезервировано для новых подсистем

	// Проверка статуса обработчиков отложенного обновления.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеВерсииИБКлиент, 2));

	Параметры.Модули.Добавить(СерверныеОповещенияКлиент);

	// Загрузка/обновление параметров работы программы.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеВерсииИБКлиент, 3));

	// Проверка авторизации пользователя.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ПользователиКлиент, 2));

	// Зарезервировано для новых подсистем

	// Обновление информационной базы.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеВерсииИБКлиент, 4));

	// Обработка ключа запуска ВыполнитьОбновлениеИЗавершитьРаботу.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ОбновлениеВерсииИБКлиент, 5));

	// Смена пароля при входе, если требуется.
	Параметры.Модули.Добавить(Новый Структура("Модуль, Номер", ПользователиКлиент, 3));

	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриНачалеРаботыСистемы(Параметры) Экспорт
	// Зарезервировано для новых подсистем

	МодульВариантыОтчетовКлиент = БазоваяПодсистемаКлиент.ОН_ОбщийМодуль("ВариантыОтчетовКлиент");
	Параметры.Модули.Добавить(МодульВариантыОтчетовКлиент);

	// Зарезервировано для новых подсистем

	МодульОбновлениеИнформационнойБазыКлиент	= БазоваяПодсистемаКлиент.ОН_ОбщийМодуль("ОбновлениеВерсииИБКлиент");
	Параметры.Модули.Добавить(МодульОбновлениеИнформационнойБазыКлиент);

	// Зарезервировано для новых подсистем

	МодульРегламентныеЗаданияКлиент				= БазоваяПодсистемаКлиент.ОН_ОбщийМодуль("РегламентныеЗаданияКлиент");
	Параметры.Модули.Добавить(МодульРегламентныеЗаданияКлиент);

	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеНачалаРаботыСистемы() Экспорт
	БазоваяПодсистемаКлиент.СП_ПослеНачалаРаботыСистемы();
	СерверныеОповещенияКлиент.СО_ПослеНачалаРаботыСистемы();

	// Зарезервировано для новых подсистем

	ОбновлениеВерсииИБКлиент.ОИБ_ПослеНачалаРаботыСистемы();
	ПользователиКлиент.сП_ПослеНачалаРаботыСистемы();

	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, Предупреждения) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОбработкеВыбора(ФормаОтчета, ВыбранноеЗначение, ИсточникВыбора, Результат) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОбработкеОповещения(ФормаОтчета, ИмяСобытия, Параметр, Источник, ОповещениеОбработано) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка) Экспорт
	// Зарезервировано для новых подсистем

	ОбновлениеВерсииИБКлиент.ОИБ_ПриОбработкеВыбораТабличногоДокумента(ФормаОтчета, Элемент, Область, СтандартнаяОбработка);
КонецПроцедуры

Процедура ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОбработкеДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриОбработкеКоманды(ФормаОтчета, Команда, Результат) Экспорт
	ОбновлениеВерсииИБКлиент.ОИБ_ПриОбработкеКоманды(ФормаОтчета, Команда, Результат);

	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеФормирования(ФормаОтчета, ОтчетСформирован) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПередПериодическойОтправкойДанныхКлиентаНаСервер(Параметры) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПослеПериодическогоПолученияДанныхКлиентаНаСервере(Результаты) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ПриНачалеВыбораЗначений(ФормаОтчета, УсловияВыбора, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт
	// Зарезервировано для новых подсистем
КонецПроцедуры
