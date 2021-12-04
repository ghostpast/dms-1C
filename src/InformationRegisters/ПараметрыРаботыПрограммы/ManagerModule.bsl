///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция НеобходимоОбновление(НастройкаПодчиненногоУзлаРИБ = Ложь) Экспорт
	// Обновление в локальном режиме.
	Если ОбновлениеВерсииИБСерверПовтИсп.сОИБ_НеобходимоОбновлениеИнформационнойБазы() Тогда
		Возврат Истина;
	КонецЕсли;

	// Зарезервировано для новых подсистем

	Возврат Ложь;
КонецФункции

Процедура УстановитьПараметрРаботыПрограммы(ИмяПараметра, Значение) Экспорт
	Если БазоваяПодсистемаСервер.СП_ВерсияПрограммыОбновленаДинамически() Тогда
		ВызватьИсключение "Версия программы обновлена, требуется перезапустить сеанс.";
	КонецЕсли;

	ОписаниеЗначения = Новый Структура;
	ОписаниеЗначения.Вставить("Версия", Метаданные.Версия);
	ОписаниеЗначения.Вставить("Значение", Значение);

	УстановитьХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра, ОписаниеЗначения);
КонецПроцедуры

Процедура ОбновитьПараметрРаботыПрограммы(ИмяПараметра, Значение, ЕстьИзменения = Ложь, СтароеЗначение = Неопределено) Экспорт
	БазоваяПодсистемаСервер.СП_ПроверитьДинамическоеОбновлениеВерсииПрограммы();

	ОписаниеЗначения = ОписаниеЗначенияПараметраРаботыПрограммы(ИмяПараметра);
	СтароеЗначение = ОписаниеЗначения.Значение;

	Если Не БазоваяПодсистемаСервер.ОН_ДанныеСовпадают(Значение, СтароеЗначение) Тогда
		ЕстьИзменения = Истина;
	ИначеЕсли ОписаниеЗначения.Версия = Метаданные.Версия Тогда
		Возврат;
	КонецЕсли;

	УстановитьПараметрРаботыПрограммы(ИмяПараметра, Значение);
КонецПроцедуры

Функция ПараметрРаботыПрограммы(ИмяПараметра) Экспорт
	ОписаниеЗначения = ОписаниеЗначенияПараметраРаботыПрограммы(ИмяПараметра);

	Если БазоваяПодсистемаСервер.СП_ВерсияПрограммыОбновленаДинамически() Тогда
		Возврат ОписаниеЗначения.Значение;
	КонецЕсли;

	Если ОписаниеЗначения.Версия <> Метаданные.Версия Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат ОписаниеЗначения.Значение;
КонецФункции

Функция ОписаниеЗначенияПараметраРаботыПрограммы(ИмяПараметра)
	ОписаниеЗначения = ХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра);

	Если ТипЗнч(ОписаниеЗначения) <> Тип("Структура")
	 Или ОписаниеЗначения.Количество() <> 2
	 Или Не ОписаниеЗначения.Свойство("Версия")
	 Или Не ОписаниеЗначения.Свойство("Значение") Тогда

		Если БазоваяПодсистемаСервер.СП_ВерсияПрограммыОбновленаДинамически() Тогда
			ВызватьИсключение "Версия программы обновлена, требуется перезапустить сеанс.";
		КонецЕсли;
		ОписаниеЗначения = Новый Структура("Версия, Значение");
	КонецЕсли;

	Возврат ОписаниеЗначения;
КонецФункции

Функция ХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяПараметра", ИмяПараметра);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПараметрыРаботыПрограммы.ХранилищеПараметра
	|ИЗ
	|	РегистрСведений.ПараметрыРаботыПрограммы КАК ПараметрыРаботыПрограммы
	|ГДЕ
	|	ПараметрыРаботыПрограммы.ИмяПараметра = &ИмяПараметра";

	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ХранилищеПараметра.Получить();
	КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);

	Возврат Неопределено;
КонецФункции

Процедура УстановитьХранимыеДанныеПараметраРаботыПрограммы(ИмяПараметра, ХранимыеДанные)
	НаборЗаписей					= СлужебныйНаборЗаписей(РегистрыСведений.ПараметрыРаботыПрограммы);
	НаборЗаписей.Отбор.ИмяПараметра.Установить(ИмяПараметра);

	НоваяЗапись						= НаборЗаписей.Добавить();
	НоваяЗапись.ИмяПараметра		= ИмяПараметра;
	НоваяЗапись.ХранилищеПараметра	= Новый ХранилищеЗначения(ХранимыеДанные);

	НаборЗаписей.Записать();
КонецПроцедуры

Функция ТребуетсяЗагрузитьПараметрыРаботыПрограммы() Экспорт
	Возврат НеобходимоОбновление() И БазоваяПодсистемаСервер.ОН_ЭтоПодчиненныйУзелРИБ();
КонецФункции

Функция ЗагрузитьПараметрыРаботыПрограммыВФоне(ОжидатьЗавершение, ИдентификаторФормы, СообщитьПрогресс) Экспорт
	ПараметрыОперации								= БазоваяПодсистемаСервер.ДО_ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыОперации.НаименованиеФоновогоЗадания	= "Фоновая загрузка параметров работы программы";
	ПараметрыОперации.ОжидатьЗавершение				= ОжидатьЗавершение;

	Если БазоваяПодсистемаСервер.ОН_РежимОтладки() Тогда
		СообщитьПрогресс = Ложь;
	КонецЕсли;

	Возврат БазоваяПодсистемаСервер.ДО_ВыполнитьВФоне("РегистрыСведений.ПараметрыРаботыПрограммы.ОбработчикДлительнойОперацииЗагрузкиПараметровРаботыПрограммы", СообщитьПрогресс, ПараметрыОперации);
КонецФункции

Процедура ОбработчикДлительнойОперацииЗагрузкиПараметровРаботыПрограммы(СообщитьПрогресс, АдресХранилища) Экспорт
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("КраткоеПредставлениеОшибки",		Неопределено);
	РезультатВыполнения.Вставить("ПодробноеПредставлениеОшибки",	Неопределено);

	Попытка
		ЗагрузитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(СообщитьПрогресс);
	Исключение
		ИнформацияОбОшибке									= ИнформацияОбОшибке();
		РезультатВыполнения.КраткоеПредставлениеОшибки		= ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		РезультатВыполнения.ПодробноеПредставлениеОшибки	= ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		// Переход в режим открытия формы повторной синхронизации данных перед запуском
		// с двумя вариантами "Синхронизировать и продолжить" и "Продолжить".

		// Зарезервировано для новых подсистем
	КонецПопытки;

	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
КонецПроцедуры

Процедура ЗагрузитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(СообщитьПрогресс)
	БазоваяПодсистемаСервер.СП_ПроверитьДинамическоеОбновлениеВерсииПрограммы();

	НастройкаПодчиненногоУзлаРИБ	= Ложь;
	Если Не НеобходимоОбновление(НастройкаПодчиненногоУзлаРИБ) Или Не БазоваяПодсистемаСервер.ОН_ЭтоПодчиненныйУзелРИБ() Тогда
		Возврат;
	КонецЕсли;

	// РИБ-обмен данными, обновление в подчиненном узле ИБ.

	// Зарезервировано для новых подсистем

	УстановитьПривилегированныйРежим(Истина);

	Если Не НастройкаПодчиненногоУзлаРИБ Тогда
		// Зарезервировано для новых подсистем

		Если СообщитьПрогресс Тогда
			БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(5);
		КонецЕсли;
	КонецЕсли;

	// Проверка загрузки идентификаторов объектов метаданных из главного узла.
	СписокКритичныхИзменений	= "";
	Попытка
		Справочники.ИдентификаторыОбъектовМетаданных.ВыполнитьОбновлениеДанных(Ложь, Ложь, Истина, , СписокКритичныхИзменений);
	Исключение
		// Переход в режим открытия формы повторной синхронизации данных перед запуском
		// с одним вариантом "Синхронизировать и продолжить".

		// Зарезервировано для новых подсистем
		ВызватьИсключение;
	КонецПопытки;

	Если ЗначениеЗаполнено(СписокКритичныхИзменений) Тогда
		ИмяСобытия	= "Идентификаторы объектов метаданных.Требуется загрузить критичные изменения";
		ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка,,, СписокКритичныхИзменений);

		// Переход в режим открытия формы повторной синхронизации данных перед запуском
		// с одним вариантом "Синхронизировать и продолжить".

		// Зарезервировано для новых подсистем

		ТекстОшибки = "Информационная база не может быть обновлена из-за проблемы в главном узле:
			           |- главный узел был некорректно обновлен (возможно не был увеличен номер версии конфигурации,
			           |  из-за чего не заполнился справочник Идентификаторы объектов метаданных);
			           |- либо были отменены к выгрузке приоритетные данные (элементы
			           |  справочника Идентификаторы объектов метаданных).
			           |
			           |Заново выполните обновление главного узла, зарегистрируйте к выгрузке
			           |приоритетные данные и повторите синхронизацию данных:
			           |- в главном узле запустите программу с параметром /C ЗапуститьОбновлениеИнформационнойБазы;
			           |%1";
		Если НастройкаПодчиненногоУзлаРИБ Тогда
			// Настройка подчиненного узла РИБ при первом запуске.
			ТекстОшибки = СтрШаблон(ТекстОшибки, "- затем повторите создание подчиненного узла.");
		Иначе
			// Обновление подчиненного узла РИБ.
			ТекстОшибки = СтрШаблон(ТекстОшибки, "- затем повторите синхронизацию данных с этой информационной базой
				           | (сначала в главном узле, затем в этой информационной базе после перезапуска).");
		КонецЕсли;

		ВызватьИсключение ТекстОшибки;
	КонецЕсли;

	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(10);
	КонецЕсли;

	// Зарезервировано для новых подсистем
КонецПроцедуры

Функция ОбновитьПараметрыРаботыПрограммыВФоне(ОжидатьЗавершение, ИдентификаторФормы, СообщитьПрогресс) Экспорт
	ПараметрыОперации								= БазоваяПодсистемаСервер.ДО_ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыОперации.НаименованиеФоновогоЗадания	= "Фоновое обновление параметров работы программы";
	ПараметрыОперации.ОжидатьЗавершение				= ОжидатьЗавершение;
	ПараметрыОперации.БезРасширений					= Истина;

	Если БазоваяПодсистемаСервер.ОН_РежимОтладки() И Не ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) Тогда
		СообщитьПрогресс = Ложь;
	КонецЕсли;

	Если ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) И Не ДоступноВыполнениеФоновыхЗаданий() Тогда
		ВызватьИсключение "Обновление параметров работы программы, когда подключены расширения конфигурации,
			           |может быть выполнено только в фоновом задании без расширений конфигурации.
			           |
			           |В файловой информационной базе фоновое задание невозможно запустить
			           |из другого фонового задания, а также из COM-Соединения.
			           |
			           |Для выполнения обновления необходимо, либо делать обновление интерактивно
			           |через запуск 1С:Предприятия, либо временно отключать расширения конфигурации.";
	КонецЕсли;

	Возврат БазоваяПодсистемаСервер.ДО_ВыполнитьВФоне("РегистрыСведений.ПараметрыРаботыПрограммы.ОбработчикДлительнойОперацииОбновленияПараметровРаботыПрограммы", СообщитьПрогресс, ПараметрыОперации);
КонецФункции

Процедура ОбработчикДлительнойОперацииОбновленияПараметровРаботыПрограммы(СообщитьПрогресс, АдресХранилища) Экспорт
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("КраткоеПредставлениеОшибки",		Неопределено);
	РезультатВыполнения.Вставить("ПодробноеПредставлениеОшибки",	Неопределено);

	Попытка
		ОбновитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(СообщитьПрогресс);
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		РезультатВыполнения.КраткоеПредставлениеОшибки		= ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		РезультатВыполнения.ПодробноеПредставлениеОшибки	= ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		// Переход в режим открытия формы повторной синхронизации данных перед запуском
		// с двумя вариантами "Синхронизировать и продолжить" и "Продолжить".

		// Зарезервировано для новых подсистем
	КонецПопытки;

	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
КонецПроцедуры

Процедура ОбновитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(СообщитьПрогресс)
	БазоваяПодсистемаСервер.СП_ПроверитьДинамическоеОбновлениеВерсииПрограммы();

	Если ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) И Не ВыполнятьОбновлениеБезФоновогоЗадания() Тогда
		ВызватьИсключение "Не удалось обновить параметры работы программы по причине:
			           |Найдены подключенные расширения конфигурации.";
	КонецЕсли;

	// Зарезервировано для новых подсистем

	// Нет РИБ-обмена данными
	// или обновление в главном узле ИБ
	// или обновление при первом запуске подчиненного узла
	// или обновление после загрузки справочника "Идентификаторы объектов метаданных" из главного узла.

	ОбновитьПараметрыРаботыПрограммы(СообщитьПрогресс);

	// Зарезервировано для новых подсистем
КонецПроцедуры

Процедура ОбновитьПараметрыРаботыПрограммы(СообщитьПрогресс = Ложь)
	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(15);
	КонецЕсли;

	Если Не БазоваяПодсистемаСерверПовтИсп.СП_ОтключитьИдентификаторыОбъектовМетаданных() Тогда
		Справочники.ИдентификаторыОбъектовМетаданных.ВыполнитьОбновлениеДанных(Ложь, Ложь, Ложь);
	КонецЕсли;
	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(25);
	КонецЕсли;

	// Зарезервировано для новых подсистем

	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(45);
	КонецЕсли;

	// Зарезервировано для новых подсистем

	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(55);
	КонецЕсли;

	// Зарезервировано для новых подсистем

	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(65);
	КонецЕсли;

	ИмяПараметра = "СтандартныеПодсистемы.БазоваяФункциональность.ДатаОбновленияВсехПараметровРаботыПрограммы";
	РегистрыСведений.ПараметрыРаботыПрограммы.УстановитьПараметрРаботыПрограммы(ИмяПараметра, ТекущаяДатаСеанса());

	// Зарезервировано для новых подсистем
КонецПроцедуры

Функция ДоступноВыполнениеФоновыхЗаданий()
	Если ТекущийРежимЗапуска() = Неопределено И БазоваяПодсистемаСервер.ОН_ИнформационнаяБазаФайловая() Тогда
		Сеанс = ПолучитьТекущийСеансИнформационнойБазы();
		Если Сеанс.ИмяПриложения = "COMConnection" Или Сеанс.ИмяПриложения = "BackgroundJob" Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;

	Возврат Истина;
КонецФункции

Функция ВыполнятьОбновлениеБезФоновогоЗадания()
	Если Не ДоступноВыполнениеФоновыхЗаданий() И Не ЕстьРолиМодифицированныеРасширениями() Тогда

		Возврат Истина;
	КонецЕсли;

	Возврат Ложь;
КонецФункции

Функция ЕстьРолиМодифицированныеРасширениями()
	Для Каждого Роль Из Метаданные.Роли Цикл
		Если Роль.ЕстьИзмененияРасширениямиКонфигурации() Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;

	Возврат Ложь;
КонецФункции

Функция ОбновитьПараметрыРаботыВерсийРасширенийВФоне(ОжидатьЗавершение, ИдентификаторФормы, СообщитьПрогресс) Экспорт
	ПараметрыОперации								= БазоваяПодсистемаСервер.ДО_ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыОперации.НаименованиеФоновогоЗадания	= "Фоновое обновление параметров работы версий расширений";
	ПараметрыОперации.ОжидатьЗавершение				= ОжидатьЗавершение;

	Если БазоваяПодсистемаСервер.ОН_РежимОтладки() Тогда
		СообщитьПрогресс = Ложь;
	КонецЕсли;

	Возврат БазоваяПодсистемаСервер.ДО_ВыполнитьВФоне(
		"РегистрыСведений.ПараметрыРаботыПрограммы.ОбработчикДлительнойОперацииОбновленияПараметровВерсийРасширений",
		СообщитьПрогресс,
		ПараметрыОперации);
КонецФункции

Процедура ОбработчикДлительнойОперацииОбновленияПараметровВерсийРасширений(СообщитьПрогресс, АдресХранилища) Экспорт
	РезультатВыполнения = Новый Структура;
	РезультатВыполнения.Вставить("КраткоеПредставлениеОшибки",		Неопределено);
	РезультатВыполнения.Вставить("ПодробноеПредставлениеОшибки",	Неопределено);

	Попытка
		ОбновитьПараметрыРаботыВерсийРасширенийCУчетомРежимаВыполнения(СообщитьПрогресс);
	Исключение
		ИнформацияОбОшибке									= ИнформацияОбОшибке();
		РезультатВыполнения.КраткоеПредставлениеОшибки		= ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке);
		РезультатВыполнения.ПодробноеПредставлениеОшибки	= ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		// Переход в режим открытия формы повторной синхронизации данных перед запуском
		// с двумя вариантами "Синхронизировать и продолжить" и "Продолжить".

		// Зарезервировано для новых подсистем
	КонецПопытки;

	ПоместитьВоВременноеХранилище(РезультатВыполнения, АдресХранилища);
КонецПроцедуры

Процедура ОбновитьПараметрыРаботыВерсийРасширенийCУчетомРежимаВыполнения(СообщитьПрогресс)
	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(65);
	КонецЕсли;

	УстановитьПривилегированныйРежим(Истина);
	ПараметрЗапускаКлиента = ПараметрыСеанса.ПараметрыКлиентаНаСервере.Получить("ПараметрЗапуска");
	УстановитьПривилегированныйРежим(Ложь);
	Если СтрНайти(НРег(ПараметрЗапускаКлиента), НРег("ЗапуститьОбновлениеИнформационнойБазы")) > 0 Тогда
		РегистрыСведений.ПараметрыРаботыВерсийРасширений.ОчиститьВсеПараметрыРаботыРасширений();
	КонецЕсли;

	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(75);
	КонецЕсли;

	РегистрыСведений.ПараметрыРаботыВерсийРасширений.ЗаполнитьВсеПараметрыРаботыРасширений();

	Если СообщитьПрогресс Тогда
		БазоваяПодсистемаСервер.ДО_СообщитьПрогресс(95);
	КонецЕсли;
КонецПроцедуры

Функция ОбработанныйРезультатДлительнойОперации(Результат, Операция) Экспорт
	КраткоеПредставлениеОшибки		= Неопределено;
	ПодробноеПредставлениеОшибки	= Неопределено;

	Если Результат = Неопределено Или Результат.Статус = "Отменено" Тогда
		Если Операция = "ЗагрузкаПараметровРаботыПрограммы" Тогда
			КраткоеПредставлениеОшибки = "Не удалось загрузить параметры работы программы по причине:
				           |Фоновое задание, выполняющее загрузку отменено.";
		ИначеЕсли Операция = "ОбновлениеПараметровРаботыПрограммы" Тогда
			КраткоеПредставлениеОшибки = "Не удалось обновить параметры работы программы по причине:
				           |Фоновое задание, выполняющее обновление отменено.";
		Иначе // ОбновлениеПараметровРаботыВерсийРасширений.
			КраткоеПредставлениеОшибки = "Не удалось обновить параметры работы версий расширений по причине:
				           |Фоновое задание, выполняющее обновление отменено.";
		КонецЕсли;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатВыполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		УдалитьИзВременногоХранилища(Результат.АдресРезультата);

		Если ТипЗнч(РезультатВыполнения) = Тип("Структура") Тогда
			КраткоеПредставлениеОшибки		= РезультатВыполнения.КраткоеПредставлениеОшибки;
			ПодробноеПредставлениеОшибки	= РезультатВыполнения.ПодробноеПредставлениеОшибки;
		ИначеЕсли Операция = "ЗагрузкаПараметровРаботыПрограммы" Тогда
			КраткоеПредставлениеОшибки = "Не удалось загрузить параметры работы программы по причине:
				           |Фоновое задание, выполняющее загрузку не вернуло результат.";
		ИначеЕсли Операция = "ОбновлениеПараметровРаботыПрограммы" Тогда
			КраткоеПредставлениеОшибки = "Не удалось обновить параметры работы программы по причине:
				           |Фоновое задание, выполняющее обновление не вернуло результат.";
		Иначе // ОбновлениеПараметровРаботыВерсийРасширений.
			КраткоеПредставлениеОшибки = "Не удалось обновить параметры работы версий расширений по причине:
				           |Фоновое задание, выполняющее обновление не вернуло результат.";
		КонецЕсли;
	ИначеЕсли Результат.Статус <> "ЗагрузкаПараметровРаботыПрограммыНеТребуется"
	        И Результат.Статус <> "ЗагрузкаИОбновлениеПараметровРаботыПрограммыНеТребуются"
	        И Результат.Статус <> "ОбновлениеПараметровРаботыВерсийРасширенийНеТребуется" Тогда

		// Ошибка выполнения фонового задания.
		КраткоеПредставлениеОшибки		= Результат.КраткоеПредставлениеОшибки;
		ПодробноеПредставлениеОшибки	= Результат.ПодробноеПредставлениеОшибки;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ПодробноеПредставлениеОшибки) И ЗначениеЗаполнено(КраткоеПредставлениеОшибки) Тогда
		ПодробноеПредставлениеОшибки = КраткоеПредставлениеОшибки;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(КраткоеПредставлениеОшибки) И ЗначениеЗаполнено(ПодробноеПредставлениеОшибки) Тогда
		КраткоеПредставлениеОшибки = ПодробноеПредставлениеОшибки;
	КонецЕсли;

	ОбработанныйРезультат = Новый Структура;
	ОбработанныйРезультат.Вставить("КраткоеПредставлениеОшибки",   КраткоеПредставлениеОшибки);
	ОбработанныйРезультат.Вставить("ПодробноеПредставлениеОшибки", ПодробноеПредставлениеОшибки);

	Возврат ОбработанныйРезультат;
КонецФункции

Процедура ЗагрузитьОбновитьПараметрыРаботыПрограммы() Экспорт
	Попытка
		Если ТребуетсяЗагрузитьПараметрыРаботыПрограммы() Тогда
			ЗагрузитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(Ложь);
		КонецЕсли;
	Исключение
		// Зарезервировано для новых подсистем

		ВызватьИсключение;
	КонецПопытки;

	Если ЗначениеЗаполнено(ПараметрыСеанса.ПодключенныеРасширения) И Не ВыполнятьОбновлениеБезФоновогоЗадания() Тогда
		// Запуск фонового задания обновления параметров.
		Результат				= ОбновитьПараметрыРаботыПрограммыВФоне(Неопределено, Неопределено, Ложь);
		ОбработанныйРезультат	= ОбработанныйРезультатДлительнойОперации(Результат, Ложь);

		Если ЗначениеЗаполнено(ОбработанныйРезультат.КраткоеПредставлениеОшибки) Тогда
			ВызватьИсключение ОбработанныйРезультат.ПодробноеПредставлениеОшибки;
		КонецЕсли;
	Иначе
		Попытка
			ОбновитьПараметрыРаботыПрограммыCУчетомРежимаВыполнения(Ложь);
		Исключение
			// Зарезервировано для новых подсистем

			ВызватьИсключение;
		КонецПопытки;
		ОбновитьПараметрыРаботыВерсийРасширенийCУчетомРежимаВыполнения(Ложь);
	КонецЕсли;
КонецПроцедуры

Функция СлужебныйНаборЗаписей(МенеджерРегистра) Экспорт
	НаборЗаписей										= МенеджерРегистра.СоздатьНаборЗаписей();
	НаборЗаписей.ДополнительныеСвойства.Вставить("НеВыполнятьКонтрольУдаляемых");
	НаборЗаписей.ДополнительныеСвойства.Вставить("ОтключитьМеханизмРегистрацииОбъектов");
	НаборЗаписей.ОбменДанными.Получатели.АвтоЗаполнение	= Ложь;
	НаборЗаписей.ОбменДанными.Загрузка					= Истина;

	Возврат НаборЗаписей;
КонецФункции

#КонецЕсли
