///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область РегламентныеЗадания

Функция РЗ_НайтиЗадания(Отбор) Экспорт
	РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования();

	КопияОтбора		= БазоваяПодсистемаСервер.ОН_СкопироватьРекурсивно(Отбор);
	СписокЗаданий	= РегламентныеЗадания.ПолучитьРегламентныеЗадания(КопияОтбора);

	Возврат СписокЗаданий;
КонецФункции

Процедура РЗ_ИзменитьЗадание(Знач Идентификатор, Знач Параметры) Экспорт
	РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования();

	Идентификатор = РЗ_УточненныйИдентификаторЗадания(Идентификатор);

	РЗ_ИзменитьРегламентноеЗадание(Идентификатор, Параметры);
КонецПроцедуры

Процедура РЗ_ИзменитьРегламентноеЗадание(Знач Идентификатор, Знач Параметры) Экспорт
	РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования();

	Идентификатор			= РЗ_УточненныйИдентификаторЗадания(Идентификатор);
	ИдентификаторЗадания	= РЗ_УникальныйИдентификаторЗадания(Идентификатор);

	Если ИдентификаторЗадания = Неопределено Тогда
		ТекстИсключения = СтрШаблон("Регламентное задание по переданному идентификатору не найдено.
				|
				|Если регламентное задание не предопределенное, то его необходимо сначала добавить
				|в список заданий при помощи метода %1.",
			"РегламентныеЗаданияСервер.РЗ_ДобавитьЗадание");

		ВызватьИсключение ТекстИсключения;
	КонецЕсли;

	Блокировка			= Новый БлокировкаДанных;
	ЭлементБлокировки	= Блокировка.Добавить("РегистрСведений.КэшПрограммныхИнтерфейсов");
	ЭлементБлокировки.УстановитьЗначение("Идентификатор", Строка(ИдентификаторЗадания));

	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		Если Задание <> Неопределено Тогда
			ЕстьИзменения = Ложь;

			РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, "Наименование", Параметры, ЕстьИзменения);
			РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, "Использование", Параметры, ЕстьИзменения);
			РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, "Ключ", Параметры, ЕстьИзменения);
			РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, "ИмяПользователя", Параметры, ЕстьИзменения);
			РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, "ИнтервалПовтораПриАварийномЗавершении", Параметры, ЕстьИзменения);
			РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, "КоличествоПовторовПриАварийномЗавершении", Параметры, ЕстьИзменения);
			РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, "Параметры", Параметры, ЕстьИзменения);
			РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, "Расписание", Параметры, ЕстьИзменения);

			Если ЕстьИзменения Тогда
				Задание.Записать();
			КонецЕсли;
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

Процедура РЗ_УдалитьЗадание(Знач Идентификатор) Экспорт
	РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования();

	Идентификатор = РЗ_УточненныйИдентификаторЗадания(Идентификатор);

	РЗ_УдалитьРегламентноеЗадание(Идентификатор);
КонецПроцедуры

Процедура РЗ_УдалитьРегламентноеЗадание(Знач Идентификатор) Экспорт
	РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования();

	Идентификатор = РЗ_УточненныйИдентификаторЗадания(Идентификатор);

	СписокЗаданий = Новый Массив; // Массив из РегламентноеЗадание.

	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И Идентификатор.Предопределенное Тогда
		ВызватьИсключение("Предопределенное регламентное задание удалить невозможно.");
	ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И Не Идентификатор.Предопределенное Тогда
		СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
		Если РегламентноеЗадание <> Неопределено Тогда
			СписокЗаданий.Добавить(РегламентноеЗадание);
		КонецЕсли;
	КонецЕсли;

	Для Каждого РегламентноеЗадание Из СписокЗаданий Цикл
		ИдентификаторЗадания = РЗ_УникальныйИдентификаторЗадания(РегламентноеЗадание);

		Блокировка			= Новый БлокировкаДанных;
		ЭлементБлокировки	= Блокировка.Добавить("РегистрСведений.КэшПрограммныхИнтерфейсов");
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", Строка(ИдентификаторЗадания));

		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
			Если Задание <> Неопределено Тогда
				Задание.Удалить();
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();

			ВызватьИсключение;
		КонецПопытки;
	КонецЦикла;
КонецПроцедуры

Процедура РЗ_ЗаблокироватьРегламентноеЗадание(Идентификатор) Экспорт
	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
		ИдентификаторБлокировки = Идентификатор.Имя;
	Иначе
		ИдентификаторБлокировки = Строка(Идентификатор);
	КонецЕсли;

	Блокировка			= Новый БлокировкаДанных;
	ЭлементБлокировки	= Блокировка.Добавить("РегистрСведений.КэшПрограммныхИнтерфейсов");
	ЭлементБлокировки.УстановитьЗначение("Идентификатор", ИдентификаторБлокировки);
	Блокировка.Заблокировать();
КонецПроцедуры

Функция РЗ_УникальныйИдентификаторЗадания(Знач Идентификатор, ВРазделенномРежимеИдентификаторЗаданияОчереди = Ложь)
	Если ТипЗнч(Идентификатор) = Тип("УникальныйИдентификатор") Тогда
		Возврат Идентификатор;
	КонецЕсли;

	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Возврат Идентификатор.УникальныйИдентификатор;
	КонецЕсли;

	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Возврат Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;

	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И Идентификатор.Предопределенное Тогда
		Возврат РегламентныеЗадания.НайтиПредопределенное(Идентификатор).УникальныйИдентификатор;
	ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") И НЕ Идентификатор.Предопределенное Тогда
		СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
		Для каждого РегламентноеЗадание Из СписокЗаданий Цикл
			Возврат РегламентноеЗадание.УникальныйИдентификатор;
		КонецЦикла;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

Процедура РЗ_ОбновитьЗначениеСвойстваЗадания(Задание, ИмяСвойства, ПараметрыЗадания, ЕстьИзменения)
	Если Не ПараметрыЗадания.Свойство(ИмяСвойства) Тогда
		Возврат;
	КонецЕсли;

	Если Задание[ИмяСвойства] = ПараметрыЗадания[ИмяСвойства]
	 Или ТипЗнч(Задание[ИмяСвойства]) = Тип("РасписаниеРегламентногоЗадания")
	   И ТипЗнч(ПараметрыЗадания[ИмяСвойства]) = Тип("РасписаниеРегламентногоЗадания")
	   И Строка(Задание[ИмяСвойства]) = Строка(ПараметрыЗадания[ИмяСвойства]) Тогда

		Возврат;
	КонецЕсли;

	Если ТипЗнч(Задание[ИмяСвойства]) = Тип("РасписаниеРегламентногоЗадания") И ТипЗнч(ПараметрыЗадания[ИмяСвойства]) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Задание[ИмяСвойства], ПараметрыЗадания[ИмяСвойства]);
	Иначе
		Задание[ИмяСвойства] = ПараметрыЗадания[ИмяСвойства];
	КонецЕсли;

	ЕстьИзменения			= Истина;
КонецПроцедуры

Функция РЗ_ДобавитьЗадание(Параметры) Экспорт
	РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования();

	Задание = РЗ_ДобавитьРегламентноеЗадание(Параметры);

	Возврат Задание;
КонецФункции

Функция РЗ_ДобавитьРегламентноеЗадание(Параметры) Экспорт
	РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования();

	МетаданныеЗадания	= Параметры.Метаданные;
	Задание				= РегламентныеЗадания.СоздатьРегламентноеЗадание(МетаданныеЗадания);

	Если Параметры.Свойство("Наименование") Тогда
		Задание.Наименование = Параметры.Наименование;
	Иначе
		Задание.Наименование = МетаданныеЗадания.Наименование;
	КонецЕсли;

	Если Параметры.Свойство("Использование") Тогда
		Задание.Использование = Параметры.Использование;
	Иначе
		Задание.Использование = МетаданныеЗадания.Использование;
	КонецЕсли;

	Если Параметры.Свойство("Ключ") Тогда
		Задание.Ключ = Параметры.Ключ;
	Иначе
		Задание.Ключ = МетаданныеЗадания.Ключ;
	КонецЕсли;

	Если Параметры.Свойство("ИмяПользователя") Тогда
		Задание.ИмяПользователя = Параметры.ИмяПользователя;
	КонецЕсли;

	Если Параметры.Свойство("ИнтервалПовтораПриАварийномЗавершении") Тогда
		Задание.ИнтервалПовтораПриАварийномЗавершении = Параметры.ИнтервалПовтораПриАварийномЗавершении;
	Иначе
		Задание.ИнтервалПовтораПриАварийномЗавершении = МетаданныеЗадания.ИнтервалПовтораПриАварийномЗавершении;
	КонецЕсли;

	Если Параметры.Свойство("КоличествоПовторовПриАварийномЗавершении") Тогда
		Задание.КоличествоПовторовПриАварийномЗавершении = Параметры.КоличествоПовторовПриАварийномЗавершении;
	Иначе
		Задание.КоличествоПовторовПриАварийномЗавершении = МетаданныеЗадания.КоличествоПовторовПриАварийномЗавершении;
	КонецЕсли;

	Если Параметры.Свойство("Параметры") Тогда
		Задание.Параметры = Параметры.Параметры;
	КонецЕсли;

	Если Параметры.Свойство("Расписание") Тогда
		Задание.Расписание = Параметры.Расписание;
	КонецЕсли;

	Задание.Записать();

	Возврат Задание;
КонецФункции

Процедура РЗ_УстановитьИспользованиеПредопределенногоРегламентногоЗадания(ЗаданиеМетаданные, Использование) Экспорт
	ИдентификаторЗадания = РЗ_УникальныйИдентификаторЗадания(ЗаданиеМетаданные);

	Блокировка			= Новый БлокировкаДанных;
	ЭлементБлокировки	= Блокировка.Добавить("РегистрСведений.КэшПрограммныхИнтерфейсов");
	ЭлементБлокировки.УстановитьЗначение("Идентификатор", Строка(ИдентификаторЗадания));

	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);

		Если Задание.Использование <> Использование Тогда
			Задание.Использование = Использование;
			Задание.Записать();
		КонецЕсли;

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

Процедура РЗ_ОтменитьВыполнениеЗадания(Знач РегламентноеЗадание, ТекстДляЖурнала) Экспорт
	ТекущийСеанс = ПолучитьТекущийСеансИнформационнойБазы().ПолучитьФоновоеЗадание();
	Если ТекущийСеанс = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если РегламентноеЗадание = Неопределено Тогда
		Для Каждого Задание Из Метаданные.РегламентныеЗадания Цикл
			Если Задание.ИмяМетода = ТекущийСеанс.ИмяМетода Тогда
				РегламентноеЗадание = Задание;

				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	Если РегламентноеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ЗаписьЖурналаРегистрации("Отмена фонового задания", УровеньЖурналаРегистрации.Предупреждение, РегламентноеЗадание,, ТекстДляЖурнала);

	ТекущийСеанс.Отменить();
	ТекущийСеанс.ОжидатьЗавершенияВыполнения(1);
КонецПроцедуры

Процедура РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования()
	ПроверятьПраваАдминистрированияСистемы = Истина;

	Если НЕ ПользователиСервер.П_ЭтоПолноправныйПользователь(, ПроверятьПраваАдминистрированияСистемы) Тогда
		ВызватьИсключение "Нарушение прав доступа.";
	КонецЕсли;
КонецПроцедуры

Функция РЗ_Задание(Знач Идентификатор) Экспорт
	РЗ_ВызватьИсключениеЕслиНетПраваАдминистрирования();

	Идентификатор = РЗ_УточненныйИдентификаторЗадания(Идентификатор);

	РегламентноеЗадание = Неопределено;

	Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
		Если Идентификатор.Предопределенное Тогда
			РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Идентификатор);
		Иначе
			СписокЗаданий = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Новый Структура("Метаданные", Идентификатор));
			Если СписокЗаданий.Количество() > 0 Тогда
				РегламентноеЗадание = СписокЗаданий[0];
			КонецЕсли;
		КонецЕсли;
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	КонецЕсли;

	Возврат РегламентноеЗадание;
КонецФункции

Функция РЗ_УточненныйИдентификаторЗадания(Знач Идентификатор)
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;

	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		ОбъектМетаданных = Метаданные.РегламентныеЗадания.Найти(Идентификатор);
		Если ОбъектМетаданных = Неопределено Тогда
			Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
		Иначе
			Идентификатор = ОбъектМетаданных;
		КонецЕсли;
	КонецЕсли;

	Возврат Идентификатор;
КонецФункции

Функция сРЗ_РегламентноеЗаданиеДоступноПоФункциональнымОпциям(Задание, ЗависимостиЗаданий = Неопределено) Экспорт
	Если ЗависимостиЗаданий = Неопределено Тогда
		ЗависимостиЗаданий = сРЗ_РегламентныеЗаданияЗависимыеОтФункциональныхОпций();
	КонецЕсли;

	ОтключитьВПодчиненномУзлеРИБ		= Ложь;
	ОтключитьВАвтономномРабочемМесте	= Ложь;
	Использование						= Неопределено;
	ЭтоПодчиненныйУзелРИБ				= БазоваяПодсистемаСервер.ОН_ЭтоПодчиненныйУзелРИБ();
	ЭтоАвтономноеРабочееМесто			= БазоваяПодсистемаСервер.ОН_ЭтоАвтономноеРабочееМесто();

	НайденныеСтроки = ЗависимостиЗаданий.НайтиСтроки(Новый Структура("РегламентноеЗадание", Задание));
	Для Каждого СтрокаЗависимости Из НайденныеСтроки Цикл
		ОтключитьВПодчиненномУзлеРИБ		= (СтрокаЗависимости.ДоступноВПодчиненномУзлеРИБ = Ложь) И ЭтоПодчиненныйУзелРИБ;
		ОтключитьВАвтономномРабочемМесте	= (СтрокаЗависимости.ДоступноВАвтономномРабочемМесте = Ложь) И ЭтоАвтономноеРабочееМесто;

		Если ОтключитьВПодчиненномУзлеРИБ Или ОтключитьВАвтономномРабочемМесте Тогда
			Возврат Ложь;
		КонецЕсли;

		Если СтрокаЗависимости.ФункциональнаяОпция = Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ЗначениеФО = ПолучитьФункциональнуюОпцию(СтрокаЗависимости.ФункциональнаяОпция.Имя);

		Если Использование = Неопределено Тогда
			Использование = ЗначениеФО;
		ИначеЕсли СтрокаЗависимости.ЗависимостьПоИ Тогда
			Использование = Использование И ЗначениеФО;
		Иначе
			Использование = Использование Или ЗначениеФО;
		КонецЕсли;
	КонецЦикла;

	Если Использование = Неопределено Тогда
		Возврат Истина;
	Иначе
		Возврат Использование;
	КонецЕсли;
КонецФункции

Функция сРЗ_РегламентныеЗаданияЗависимыеОтФункциональныхОпций() Экспорт
	Зависимости = Новый ТаблицаЗначений;
	Зависимости.Колонки.Добавить("РегламентноеЗадание");
	Зависимости.Колонки.Добавить("ФункциональнаяОпция");
	Зависимости.Колонки.Добавить("ЗависимостьПоИ", Новый ОписаниеТипов("Булево"));
	Зависимости.Колонки.Добавить("ДоступноВПодчиненномУзлеРИБ");
	Зависимости.Колонки.Добавить("ВключатьПриВключенииФункциональнойОпции");
	Зависимости.Колонки.Добавить("ДоступноВАвтономномРабочемМесте");
	Зависимости.Колонки.Добавить("РаботаетСВнешнимиРесурсами",  Новый ОписаниеТипов("Булево"));
	Зависимости.Колонки.Добавить("Параметризуется",  Новый ОписаниеТипов("Булево"));

	ИнтеграцияПодсистемСервер.ПриОпределенииНастроекРегламентныхЗаданий(Зависимости);

	Зависимости.Сортировать("РегламентноеЗадание");

	Возврат Зависимости;
КонецФункции

Функция сРЗ_ЗначениеНастройки(ИмяНастройки) Экспорт
	Настройки = Новый Структура;
	Настройки.Вставить("РасположениеКомандыСнятияБлокировки", "Блокировку также можно снять позднее в разделе <b>Администрирование - Обслуживание</b>.");

	Возврат Настройки[ИмяНастройки];
КонецФункции

Процедура сРЗ_ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	Обработчик						= Обработчики.Добавить();
	Обработчик.Версия				= "2.3.3.12";
	Обработчик.НачальноеЗаполнение	= Истина;
	Обработчик.РежимВыполнения		= "Оперативно";
	Обработчик.Процедура			= "РегламентныеЗаданияСервер.БРСВР_ОбновитьПараметрыБлокировкиРаботыСВнешнимиРесурсами";
КонецПроцедуры

#КонецОбласти

#Область БлокировкаРаботыСВнешнимиРесурсами

Процедура БРСВР_ПриДобавленииПараметровРаботыКлиентаПриЗапуске(ПараметрыРаботыКлиента, ЭтоВызовПередНачаломРаботыСистемы) Экспорт
	ПоказатьФормуБлокировки = Ложь;

	Если ЭтоВызовПередНачаломРаботыСистемы И ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована Тогда
		ПараметрыБлокировки = БРСВР_СохраненныеПараметрыБлокировки();

		УстановленПризнакНеобходимостиПринятияРешения = ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Неопределено;

		ПоказатьФормуБлокировки = УстановленПризнакНеобходимостиПринятияРешения И ПользователиСервер.П_ЭтоПолноправныйПользователь();
	КонецЕсли;

	ПараметрыРаботыКлиента.Вставить("ПоказатьФормуБлокировкиРаботыСВнешнимиРесурсами", ПоказатьФормуБлокировки);
КонецПроцедуры

Процедура БРСВР_ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	Обработчики.Вставить("РаботаСВнешнимиРесурсамиЗаблокирована", "РегламентныеЗаданияСервер.БРСВР_ПриУстановкеПараметровСеанса");
КонецПроцедуры

Процедура БРСВР_ПриУстановкеПараметровСеанса(ИмяПараметра, УстановленныеПараметры) Экспорт
	Если ИмяПараметра = "РаботаСВнешнимиРесурсамиЗаблокирована" Тогда

		НачатьТранзакцию();
		Попытка
			БРСВР_ЗаблокироватьДанныеПараметровБлокировки();

			ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована	= БРСВР_УстановитьБлокировкуРаботыСВнешнимиРесурсами();
			УстановленныеПараметры.Добавить("РаботаСВнешнимиРесурсамиЗаблокирована");

			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();

			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

Процедура БРСВР_ПриНачалеВыполненияРегламентногоЗадания(РегламентноеЗадание) Экспорт
	ЗапускЗаданияРазрешен = БазоваяПодсистемаСервер.ОН_ХранилищеЗагрузить(ХранилищеСистемныхНастроек, "РегламентныеЗадания", РегламентноеЗадание.ИмяМетода, Неопределено, Неопределено, Неопределено);

	Если ЗапускЗаданияРазрешен = Истина Тогда
		Возврат;
	КонецЕсли;

	Если Не БРСВР_РегламентноеЗаданиеРаботаетСВнешнимиРесурсами(РегламентноеЗадание) Тогда
		Возврат;
	КонецЕсли;

	Если Не ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована Тогда
		Возврат;
	КонецЕсли;

	НачатьТранзакцию();
	Попытка
		БРСВР_ЗаблокироватьДанныеПараметровБлокировки();

		ПараметрыБлокировки = БРСВР_СохраненныеПараметрыБлокировки();
		БРСВР_ОтключитьРегламентноеЗадание(ПараметрыБлокировки, РегламентноеЗадание);
		БРСВР_СохранитьПараметрыБлокировки(ПараметрыБлокировки);

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;

	ТекстИсключения = СтрШаблон("Изменилась строка соединения информационной базы.
			           |Возможно информационная база была перемещена.
			           |Регламентное задание ""%1"" отключено.",
			РегламентноеЗадание.Синоним);

	РЗ_ОтменитьВыполнениеЗадания(РегламентноеЗадание, ТекстИсключения);

	ВызватьИсключение ТекстИсключения;
КонецПроцедуры

Функция БРСВР_РегламентноеЗаданиеРаботаетСВнешнимиРесурсами(РегламентноеЗадание)
	ЗависимостиЗаданий = сРЗ_РегламентныеЗаданияЗависимыеОтФункциональныхОпций();

	Отбор = Новый Структура;
	Отбор.Вставить("РегламентноеЗадание",			РегламентноеЗадание);
	Отбор.Вставить("РаботаетСВнешнимиРесурсами",	Истина);

	НайденныеСтроки = ЗависимостиЗаданий.НайтиСтроки(Отбор);

	Возврат НайденныеСтроки.Количество() <> 0;
КонецФункции

Функция БРСВР_ТекущиеПараметрыБлокировки()
	Результат = Новый Структура;
	Результат.Вставить("ИдентификаторБазы",						БазоваяПодсистемаСервер.СП_ИдентификаторИнформационнойБазы());
	Результат.Вставить("ЭтоФайловаяБаза",						БазоваяПодсистемаСервер.ОН_ИнформационнаяБазаФайловая());
	Результат.Вставить("СтрокаСоединения",						СтрокаСоединенияИнформационнойБазы());
	Результат.Вставить("ИмяКомпьютера",							ИмяКомпьютера());
	Результат.Вставить("ПроверятьИмяСервера",					Истина);
	Результат.Вставить("РаботаСВнешнимиРесурсамиЗаблокирована",	Ложь);
	Результат.Вставить("ОтключенныеЗадания",					Новый Массив);
	Результат.Вставить("ПричинаБлокировки",						"");

	Возврат Результат;
КонецФункции

Функция БРСВР_СохраненныеПараметрыБлокировки() Экспорт
	УстановитьПривилегированныйРежим(Истина);
	Сохраненные = Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Получить().Получить();
	УстановитьПривилегированныйРежим(Ложь);

	Результат = БРСВР_ТекущиеПараметрыБлокировки();

	Если Сохраненные = Неопределено Тогда
		БРСВР_СохранитьПараметрыБлокировки(Результат); // Автоматическая инициализация.
		Если БазоваяПодсистемаСервер.ОН_ИнформационнаяБазаФайловая() Тогда
			БРСВР_ЗаписатьИдентификаторФайловойБазыВФайлПроверки(Результат.ИдентификаторБазы);
		КонецЕсли;
	КонецЕсли;

	Если ТипЗнч(Сохраненные) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Результат, Сохраненные); // Переинициализация новых свойств.
	КонецЕсли;

	Возврат Результат;
КонецФункции

Процедура БРСВР_ЗаблокироватьДанныеПараметровБлокировки()
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("Константа.ПараметрыБлокировкиРаботыСВнешнимиРесурсами");
	Блокировка.Заблокировать();
КонецПроцедуры

Процедура БРСВР_СохранитьПараметрыБлокировки(ПараметрыБлокировки)
	УстановитьПривилегированныйРежим(Истина);

	ХранилищеЗначения = Новый ХранилищеЗначения(ПараметрыБлокировки);
	Константы.ПараметрыБлокировкиРаботыСВнешнимиРесурсами.Установить(ХранилищеЗначения);

	УстановитьПривилегированныйРежим(Ложь);
КонецПроцедуры

Процедура БРСВР_ОтключитьРегламентноеЗадание(ПараметрыБлокировки, РегламентноеЗадание)
	Отбор = Новый Структура;
	Отбор.Вставить("Метаданные", РегламентноеЗадание);
	Отбор.Вставить("Использование", Истина);

	НайденныеЗадания = РЗ_НайтиЗадания(Отбор);

	Для Каждого Задание Из НайденныеЗадания Цикл
		РЗ_ИзменитьЗадание(Задание, Новый Структура("Использование", Ложь));
		ПараметрыБлокировки.ОтключенныеЗадания.Добавить(Задание.УникальныйИдентификатор);
	КонецЦикла;
КонецПроцедуры

Процедура БРСВР_ЗаписатьИдентификаторФайловойБазыВФайлПроверки(ИдентификаторБазы)
	СодержимоеФайла = СтрШаблон("%1
		           |
		           |Файл создан автоматически прикладным решением ""%2"".
		           |Он содержит идентификатор информационной базы и позволяет определить, что эта информационная база была скопирована.
		           |
		           |При копировании файлов информационной базы, в том числе при создании резервной копии, не следует копировать этот файл.
		           |Одновременное использование двух копий информационной базы с одинаковым идентификатором может привести к конфликтам
		           |при синхронизации данных, отправке почты и другой работе с внешними ресурсами.
		           |
		           |Если файл отсутствует в папке с информационной базой, то программа запросит администратора, разрешено
		           |ли ей работать с внешними ресурсами.",
		ИдентификаторБазы,
		Метаданные.Синоним);

	ИмяФайла = БазоваяПодсистемаКлиентСервер.ОН_КаталогФайловойИнформационнойБазы() + ПолучитьРазделительПути() + "DoNotCopy.txt";

	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла);
	Попытка
		ЗаписьТекста.Записать(СодержимоеФайла);
	Исключение
		ЗаписьТекста.Закрыть();

		ВызватьИсключение;
	КонецПопытки;
	ЗаписьТекста.Закрыть();
КонецПроцедуры

Процедура БРСВР_РазрешитьРаботуСВнешнимиРесурсами() Экспорт
	НачатьТранзакцию();
	Попытка
		БРСВР_ЗаблокироватьДанныеПараметровБлокировки();

		ПараметрыБлокировки = БРСВР_СохраненныеПараметрыБлокировки();
		БРСВР_ВключитьОтключенныеРегламентныеЗадания(ПараметрыБлокировки);

		НовыеПараметрыБлокировки						= БРСВР_ТекущиеПараметрыБлокировки();
		НовыеПараметрыБлокировки.ПроверятьИмяСервера	= ПараметрыБлокировки.ПроверятьИмяСервера;
		БРСВР_СохранитьПараметрыБлокировки(НовыеПараметрыБлокировки);

		Если БазоваяПодсистемаСервер.ОН_ИнформационнаяБазаФайловая() Тогда
			БРСВР_ЗаписатьИдентификаторФайловойБазыВФайлПроверки(НовыеПараметрыБлокировки.ИдентификаторБазы);
		КонецЕсли;

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

	ИнтеграцияПодсистемСервер.ПриРазрешенииРаботыСВнешнимиРесурсами();

	ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована = Ложь;

	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

Процедура БРСВР_ЗапретитьРаботуСВнешнимиРесурсами() Экспорт
	НачатьТранзакцию();
	Попытка
		ИдентификаторИнформационнойБазы = Новый УникальныйИдентификатор;
		Константы.ИдентификаторИнформационнойБазы.Установить(Строка(ИдентификаторИнформационнойБазы));

		БРСВР_ЗаблокироватьДанныеПараметровБлокировки();

		ПараметрыБлокировки											= БРСВР_СохраненныеПараметрыБлокировки();
		ПараметрыБлокировки.ИдентификаторБазы						= ИдентификаторИнформационнойБазы;
		ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована	= Истина;
		БРСВР_СохранитьПараметрыБлокировки(ПараметрыБлокировки);

		Если БазоваяПодсистемаСервер.ОН_ИнформационнаяБазаФайловая() Тогда
			БРСВР_ЗаписатьИдентификаторФайловойБазыВФайлПроверки(ПараметрыБлокировки.ИдентификаторБазы);
		КонецЕсли;

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

	ИнтеграцияПодсистемСервер.ПриЗапретеРаботыСВнешнимиРесурсами();

	ПараметрыСеанса.РаботаСВнешнимиРесурсамиЗаблокирована = Истина;

	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры

Процедура БРСВР_УстановитьПроверкуИмениСервераВПараметрыБлокировки(ПроверятьИмяСервера) Экспорт
	НачатьТранзакцию();
	Попытка
		БРСВР_ЗаблокироватьДанныеПараметровБлокировки();

		ПараметрыБлокировки						= БРСВР_СохраненныеПараметрыБлокировки();
		ПараметрыБлокировки.ПроверятьИмяСервера	= ПроверятьИмяСервера;
		БРСВР_СохранитьПараметрыБлокировки(ПараметрыБлокировки);

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

Процедура БРСВР_ВключитьОтключенныеРегламентныеЗадания(ПараметрыБлокировки)
	Для Каждого ИдентификаторЗадания Из ПараметрыБлокировки.ОтключенныеЗадания Цикл
		Если ТипЗнч(ИдентификаторЗадания) <> Тип("УникальныйИдентификатор") Тогда
			Продолжить;
		КонецЕсли;

		Отбор							= Новый Структура("УникальныйИдентификатор");
		Отбор.УникальныйИдентификатор	= ИдентификаторЗадания;
		НайденныеЗадания				= РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);

		Для Каждого ОтключенноеЗадание Из НайденныеЗадания Цикл
			ОтключенноеЗадание.Использование	= Истина;
			ОтключенноеЗадание.Записать();
		КонецЦикла;

		Отбор = Новый Структура;
		Отбор.Вставить("УникальныйИдентификатор", ИдентификаторЗадания);
		Отбор.Вставить("Использование", Ложь);

		НайденныеЗадания = РЗ_НайтиЗадания(Отбор);

		Для Каждого Задание Из НайденныеЗадания Цикл
			РЗ_ИзменитьЗадание(Задание, Новый Структура("Использование", Истина));
			ПараметрыБлокировки.ОтключенныеЗадания.Добавить(Задание.УникальныйИдентификатор);
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры

Функция БРСВР_УстановитьБлокировкуРаботыСВнешнимиРесурсами()
	ПараметрыБлокировки = БРСВР_СохраненныеПараметрыБлокировки();

	Если ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Неопределено Тогда
		Возврат Истина; // Установлен признак необходимости принятия решения о блокировке.
	ИначеЕсли ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована = Истина Тогда
		Возврат Истина; // Блокировка работы с внешними ресурсами подтверждена администратором.
	КонецЕсли;

	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	Если СтрокаСоединения = ПараметрыБлокировки.СтрокаСоединения Тогда
		Возврат Ложь; // Если строка соединения совпадает, то дальнейшую проверку не выполняем.
	КонецЕсли;

	ЭтоФайловаяБаза = БазоваяПодсистемаСервер.ОН_ИнформационнаяБазаФайловая();

	ПеремещенаМеждуФайловымИКлиентСервернымРежимом = ЭтоФайловаяБаза <> ПараметрыБлокировки.ЭтоФайловаяБаза;
	Если ПеремещенаМеждуФайловымИКлиентСервернымРежимом Тогда
		ТекстСообщения = ?(ЭтоФайловаяБаза, "Информационная база была перемещена из клиент-серверного режима работы в файловый.", "Информационная база была перемещена из файловый режима работы в клиент-серверный.");
		БРСВР_УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);

		Возврат Истина;
	КонецЕсли;

	// Ниже код с учетом того, что режим работы не менялся:
	// 1. была файловая осталась файловая;
	// 2. была клиент-серверная осталась клиент-серверная.

	Если ЭтоФайловаяБаза Тогда
		// Для файловой базы строка соединения может быть разной при подключении с различных компьютеров,
		// поэтому проверку перемещения базы осуществляем через файл проверки.
		Если Не БРСВР_ФайлПроверкиИдентификатораФайловойБазыСуществует() Тогда
			ТекстСообщения = НСтр("ru = 'В папке информационной базы отсутствует файл проверки DoNotCopy.txt.'");
			БРСВР_УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);

			Возврат Истина;
		КонецЕсли;

		ИзменилсяИдентификаторИнформационнойБазы = БРСВР_ИдентификаторФайловойБазыИзФайлаПроверки() <> ПараметрыБлокировки.ИдентификаторБазы;

		Если ИзменилсяИдентификаторИнформационнойБазы Тогда
			ТекстСообщения =  "Идентификатор информационной базы в файле проверки DoNotCopy.txt не соответствует идентификатору в текущей базе.";
			БРСВР_УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);

			Возврат Истина;
		КонецЕсли;
	Иначе // Клиент-серверная база
		ИмяБазы										= НРег(БазоваяПодсистемаКлиентСервер.СФ_ПараметрыИзСтроки(СтрокаСоединения).Ref);
		ИмяСервераМенеджераПодключений				= НРег(БазоваяПодсистемаКлиентСервер.СФ_ПараметрыИзСтроки(СтрокаСоединения).Srvr);
		ИмяСервераРабочегоПроцесса					= НРег(ИмяКомпьютера());

		СохраненноеИмяБазы							= НРег(БазоваяПодсистемаКлиентСервер.СФ_ПараметрыИзСтроки(ПараметрыБлокировки.СтрокаСоединения).Ref);
		СохраненноеИмяСервераМенеджераПодключений	= НРег(БазоваяПодсистемаКлиентСервер.СФ_ПараметрыИзСтроки(ПараметрыБлокировки.СтрокаСоединения).Srvr);
		СохраненноеИмяСервераРабочегоПроцесса		= НРег(ПараметрыБлокировки.ИмяКомпьютера);

		ИзменилосьИмяБазы		= ИмяБазы <> СохраненноеИмяБазы;
		ИзменилосьИмяКомпьютера	= ПараметрыБлокировки.ПроверятьИмяСервера И ИмяСервераРабочегоПроцесса <> СохраненноеИмяСервераРабочегоПроцесса И СтрНайти(СохраненноеИмяСервераМенеджераПодключений, ИмяСервераМенеджераПодключений) = 0;

		// В случае масштабируемого кластера СохраненноеИмяСервераМенеджераПодключений может содержать имена
		// нескольких серверов, которые могут выступать в роли менеджера подключения
		// при этом ИмяСервераМенеджераПодключений при запуске сеанса регламентного задания будет содержать имя
		// текущего активного менеджера. Чтобы обыграть эту ситуацию ищется вхождение текущего в сохраненном имени.

		Если ИзменилосьИмяБазы Или ИзменилосьИмяКомпьютера Тогда
			ТекстСообщения = СтрШаблон("Изменились параметры контроля уникальности клиент-серверной базы.
				           |
				           |Было:
				           |Строка соединения: <%1>
				           |Имя компьютера: <%2>
				           |
				           |Стало:
				           |Строка соединения: <%3>
				           |Имя компьютера: <%4>
				           |
				           |Проверять имя сервера: <%5>",
				ПараметрыБлокировки.СтрокаСоединения,
				СохраненноеИмяСервераРабочегоПроцесса,
				СтрокаСоединения,
				ИмяСервераРабочегоПроцесса,
				ПараметрыБлокировки.ПроверятьИмяСервера);

			БРСВР_УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения);

			Возврат Истина;
		КонецЕсли;
	КонецЕсли;

	Возврат Ложь;
КонецФункции

Процедура БРСВР_УстановитьПризнакНеобходимостиПринятияРешенияОБлокировке(ПараметрыБлокировки, ТекстСообщения)
	ПараметрыБлокировки.РаботаСВнешнимиРесурсамиЗаблокирована	= Неопределено;
	ПараметрыБлокировки.ПричинаБлокировки						= БРСВР_ПредставлениеПричиныБлокировки(ПараметрыБлокировки);
	БРСВР_СохранитьПараметрыБлокировки(ПараметрыБлокировки);

	ИнтеграцияПодсистемСервер.ПриЗапретеРаботыСВнешнимиРесурсами();

	ЗаписьЖурналаРегистрации("Работа с внешними ресурсами заблокирована", УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
КонецПроцедуры

Функция БРСВР_ПредставлениеПричиныБлокировки(ПараметрыБлокировки)
	Возврат СтрШаблон("Блокировка выполнена на сервере <b>%1</b> в <b>%2</b> %3.
		           |
		           |Размещение информационной базы изменилось с
		           |<b>%4</b>
		           |на
		           |<b>%5</b>",
		ИмяКомпьютера(),
		ТекущаяДата(), // АПК:143 Информация о блокировке нужна в дате сервера.
		БРСВР_ПредставлениеТекущейОперации(),
		БРСВР_ПредставлениеСтрокиСоединения(ПараметрыБлокировки.СтрокаСоединения),
		БРСВР_ПредставлениеСтрокиСоединения(СтрокаСоединенияИнформационнойБазы()));
КонецФункции

Функция БРСВР_ПредставлениеТекущейОперации()
	ТекущийСеансИнформационнойБазы	= ПолучитьТекущийСеансИнформационнойБазы();
	ФоновоеЗадание					= ТекущийСеансИнформационнойБазы.ПолучитьФоновоеЗадание();
	ЭтоСеансРегламентногоЗадания	= ФоновоеЗадание <> Неопределено И ФоновоеЗадание.РегламентноеЗадание <> Неопределено;

	Если ЭтоСеансРегламентногоЗадания Тогда
		Возврат СтрШаблон("при попытке выполнения регламентного задания <b>%1</b>", ФоновоеЗадание.РегламентноеЗадание.Наименование);
	КонецЕсли;

	Возврат СтрШаблон("при входе пользователя <b>%1</b>", ИмяПользователя());
КонецФункции

Функция БРСВР_ПредставлениеСтрокиСоединения(СтрокаСоединения)
	Результат = СтрокаСоединения;

	Параметры = БазоваяПодсистемаКлиентСервер.СФ_ПараметрыИзСтроки(СтрокаСоединения);
	Если Параметры.Свойство("File") Тогда
		Результат = Параметры.File;
	КонецЕсли;

	Возврат Результат;
КонецФункции

Функция БРСВР_ФайлПроверкиИдентификатораФайловойБазыСуществует()
	ФайлИнфо = Новый Файл(БазоваяПодсистемаКлиентСервер.ОН_КаталогФайловойИнформационнойБазы() + ПолучитьРазделительПути() + "DoNotCopy.txt");

	Возврат ФайлИнфо.Существует();
КонецФункции

Функция БРСВР_ИдентификаторФайловойБазыИзФайлаПроверки()
	ЧтениеТекста		= Новый ЧтениеТекста(БазоваяПодсистемаКлиентСервер.ОН_КаталогФайловойИнформационнойБазы() + ПолучитьРазделительПути() + "DoNotCopy.txt");
	ИдентификаторБазы	= ЧтениеТекста.ПрочитатьСтроку();
	ЧтениеТекста.Закрыть();

	Возврат ИдентификаторБазы;
КонецФункции

Процедура БРСВР_ОбновитьПараметрыБлокировкиРаботыСВнешнимиРесурсами() Экспорт
	НачатьТранзакцию();
	Попытка
		БРСВР_ЗаблокироватьДанныеПараметровБлокировки();

		ПараметрыБлокировки = БРСВР_СохраненныеПараметрыБлокировки();

		БРСВР_СохранитьПараметрыБлокировки(ПараметрыБлокировки);

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
