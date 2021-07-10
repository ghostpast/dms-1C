///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();
	ИнициализироватьДанныеФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьЗаголовок();
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеНастройкиПриИзменении(Элемент)
	ВариантМодифицирован = Истина;
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеНастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Элемент.ТекущийЭлемент = Элементы.БыстрыеНастройкиВидСравнения Тогда
		ВыбратьВидСравнения(Элемент, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура БыстрыеНастройкиПометкаПриИзменении(Элемент)
	Запись = Элементы.БыстрыеНастройки.ТекущиеДанные;
	ИзменитьРежимОтображенияЭлементаНастроек(Запись);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометку(Команда)
	 ИзменитьРежимОтображенияНастроек();
	 ВариантМодифицирован = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометку(Команда)
	ИзменитьРежимОтображенияНастроек(Ложь);
	ВариантМодифицирован = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРасширеннымНастройкам(Команда)
	НастройкиОтчета.Вставить("ФормаНастроекРасширенныйРежим", 1);

	ОписаниеНастроекОтчета = ОписаниеНастроекОтчета(НастройкиОтчета);

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта",							КлючТекущегоВарианта);
	ПараметрыФормы.Вставить("Вариант",								КомпоновщикНастроек.Настройки);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки",			КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("НастройкиОтчета",						НастройкиОтчета);
	ПараметрыФормы.Вставить("ВариантНаименование",					ОписаниеНастроекОтчета.Наименование);
	ПараметрыФормы.Вставить("ИмяСтраницы",							"СтраницаОтборы");
	ПараметрыФормы.Вставить("СброситьПользовательскиеНастройки",	Истина);

	ОткрытьФорму(НастройкиОтчета.ПолноеИмя + ".ФормаНастроек", ПараметрыФормы, ВладелецФормы);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Применить(Команда)
	СохранитьПорядокЭлементовНастроек();

	Результат = Новый Структура;
	Результат.Вставить("ИмяСобытия",								"ИзменитьСоставБыстрыхНастроек");
	Результат.Вставить("КомпоновщикНастроекКД",						КомпоновщикНастроек);
	Результат.Вставить("ВариантМодифицирован",						ВариантМодифицирован);
	Результат.Вставить("СброситьПользовательскиеНастройки",			ВариантМодифицирован);
	Результат.Вставить("ПользовательскиеНастройкиМодифицированы",	ВариантМодифицирован);

	Закрыть(Результат);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();

	Элемент							= УсловноеОформление.Элементы.Добавить();

	ГруппаОтбораЭлемента			= Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбораЭлемента.ТипГруппы	= ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента					= ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("БыстрыеНастройки.ТипНастройки");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение	= Тип("ЗначениеПараметраНастроекКомпоновкиДанных");

	ОтборЭлемента					= ГруппаОтбораЭлемента.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("БыстрыеНастройки.ТипНастройки");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение	= Тип("ЭлементОтбораКомпоновкиДанных");

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",			"");
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать",	Ложь);

	ПолеЭлемента					= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле				= Новый ПолеКомпоновкиДанных(Элементы.БыстрыеНастройкиВидСравнения.Имя);

	ЦветНедоступногоЗначения		= Метаданные.ЭлементыСтиля.ТекстЗапрещеннойЯчейкиЦвет.Значение;

	Элемент							= УсловноеОформление.Элементы.Добавить();

	ОтборЭлемента					= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение		= Новый ПолеКомпоновкиДанных("БыстрыеНастройки.ТипНастройки");
	ОтборЭлемента.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение	= Тип("ЗначениеПараметраНастроекКомпоновкиДанных");

	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветНедоступногоЗначения);

	ПолеЭлемента					= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле				= Новый ПолеКомпоновкиДанных(Элементы.БыстрыеНастройкиВидСравнения.Имя);
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанныеФормы()
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НастройкиОтчета, КлючТекущегоВарианта");

	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(НастройкиОтчета.АдресСхемы));
	КомпоновщикНастроек.ЗагрузитьНастройки(Параметры.КомпоновщикНастроек.ПолучитьНастройки());

	ЗаполнитьБыстрыеНастройки();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьБыстрыеНастройки()
	СведенияОНастройках = ВариантыОтчетовСервер.О_СведенияОПользовательскихНастройках(КомпоновщикНастроек.Настройки);

	Схема = ПолучитьИзВременногоХранилища(НастройкиОтчета.АдресСхемы);

	ПорядокЭлементовНастроек = БазоваяПодсистемаКлиентСервер.ОН_СвойствоСтруктуры(КомпоновщикНастроек.Настройки.ДополнительныеСвойства, "ПорядокЭлементовНастроек", Новый Соответствие);

	Для Каждого СведенияОНастройке Из СведенияОНастройках Цикл
		ИдентификаторПользовательскойНастройки = СведенияОНастройке.Ключ;

		Настройки = СведенияОНастройке.Значение.Настройки;
		Если ТипЗнч(Настройки) <> Тип("НастройкиКомпоновкиДанных") Тогда
			Настройки = КомпоновщикНастроек.Настройки;
		КонецЕсли;

		ОписаниеНастройки	= СведенияОНастройке.Значение.ОписаниеНастройки;
		ЭлементНастроек		= СведенияОНастройке.Значение.ЭлементНастройки;

		Если ПараметрСхемыВыключен(Схема, ЭлементНастроек) Тогда
			Продолжить;
		КонецЕсли;

		ТипНастройки = ТипЗнч(ЭлементНастроек);

		Запись											= БыстрыеНастройки.Добавить();
		Запись.Пометка									= (ЭлементНастроек.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
		Запись.Заголовок								= ЗаголовокНастройки(ЭлементНастроек, ОписаниеНастройки, ТипНастройки, ИдентификаторПользовательскойНастройки);
		Запись.ИдентификаторПользовательскойНастройки	= ИдентификаторПользовательскойНастройки;
		Запись.ТипНастройки								= ТипНастройки;
		Запись.КартинкаНастройки						= КартинкаНастройки(ЭлементНастроек, ТипНастройки);

		Если ОписаниеНастройки <> Неопределено Тогда
			Запись.ТипЗначения = ОписаниеНастройки.ТипЗначения;
		КонецЕсли;

		УстановитьУсловиеФильтра(Запись, ОписаниеНастройки, ТипНастройки, ИдентификаторПользовательскойНастройки);

		ПорядокЭлемента = ПорядокЭлементовНастроек[ИдентификаторПользовательскойНастройки];

		Если ПорядокЭлемента <> Неопределено Тогда
			Запись.Порядок = ПорядокЭлемента;
		КонецЕсли;
	КонецЦикла;

	БыстрыеНастройки.Сортировать("Порядок");

	НайденныеЗаписи = БыстрыеНастройки.НайтиСтроки(Новый Структура("Порядок", 0));

	Если НайденныеЗаписи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Порядок = БыстрыеНастройки[БыстрыеНастройки.Количество() - 1].Порядок;

	Для Каждого Запись Из НайденныеЗаписи Цикл
		Порядок			= Порядок + 1;
		Запись.Порядок	= Порядок;
	КонецЦикла;

	БыстрыеНастройки.Сортировать("Порядок");
КонецПроцедуры

&НаСервере
Функция ПараметрСхемыВыключен(Схема, ЭлементНастроек)
	Если ТипЗнч(ЭлементНастроек) <> Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
		Возврат Ложь;
	КонецЕсли;

	ПараметрСхемы = Схема.Параметры.Найти(Строка(ЭлементНастроек.Параметр));

	Если ПараметрСхемы = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат ПараметрСхемы.ОграничениеИспользования;
КонецФункции

&НаСервере
Функция ЗаголовокНастройки(ЭлементНастроек, ОписаниеНастройки, ТипНастройки, ИдентификаторПользовательскойНастройки)
	ЗначениеНастройки		= ЗначениеНастройки(ЭлементНастроек, ОписаниеНастройки, ТипНастройки, ИдентификаторПользовательскойНастройки);
	ПредставлениеНастройки	= ПредставлениеНастройки(ЭлементНастроек, ОписаниеНастройки, ТипНастройки);

	Если ЗначениеЗаполнено(ЗначениеНастройки) И ЗначениеНастройки <> ПредставлениеНастройки Тогда
		Возврат СтрШаблон("%1 (%2)", ЗначениеНастройки, ПредставлениеНастройки);
	КонецЕсли;

	Возврат ПредставлениеНастройки;
КонецФункции

&НаСервере
Функция ЗначениеНастройки(ЭлементНастроек, ОписаниеНастройки, ТипНастройки, ИдентификаторПользовательскойНастройки)
	ЭлементПользовательскихНастроек = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдентификаторПользовательскойНастройки);

	ЗначениеНастройки	= Неопределено;
	ИмяПоляНастройки	= Неопределено;

	Если ТипНастройки = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ТипЗнч(ЭлементПользовательскихНастроек.Значение) <> Тип("Булево") Тогда
		ЗначениеНастройки	= ЭлементПользовательскихНастроек.Значение;
		ИмяПоляНастройки	= Строка(ЭлементНастроек.Параметр);

	ИначеЕсли ТипНастройки = Тип("ЭлементОтбораКомпоновкиДанных") И Не (ТипЗнч(ЭлементПользовательскихНастроек.ПравоеЗначение) = Тип("Булево") И ЗначениеЗаполнено(ЭлементНастроек.Представление)) Тогда
		ЗначениеНастройки	= ЭлементПользовательскихНастроек.ПравоеЗначение;
		ИмяПоляНастройки	= Строка(ЭлементНастроек.ЛевоеЗначение);
	Иначе
		Возврат ЗначениеНастройки;
	КонецЕсли;

	Если ОписаниеНастройки <> Неопределено И ОписаниеНастройки.ДоступныеЗначения <> Неопределено Тогда
		ДоступноеЗначение = ОписаниеНастройки.ДоступныеЗначения.НайтиПоЗначению(ЗначениеНастройки);

		Если ДоступноеЗначение <> Неопределено И ЗначениеЗаполнено(ДоступноеЗначение.Представление) Тогда
			Возврат ДоступноеЗначение.Представление;
		КонецЕсли;
	КонецЕсли;

	ДоступныеЗначения			= БазоваяПодсистемаКлиентСервер.ОН_СвойствоСтруктуры(КомпоновщикНастроек.Настройки.ДополнительныеСвойства, "ДоступныеЗначения", Новый Структура);

	ДоступныеЗначенияНастройки	= БазоваяПодсистемаКлиентСервер.ОН_СвойствоСтруктуры(ДоступныеЗначения, ИмяПоляНастройки, Новый СписокЗначений);

	НайденноеЗначениеНастройки = ДоступныеЗначенияНастройки.НайтиПоЗначению(ЗначениеНастройки);

	Если НайденноеЗначениеНастройки <> Неопределено И ЗначениеЗаполнено(НайденноеЗначениеНастройки.Представление) Тогда
		Возврат НайденноеЗначениеНастройки.Представление;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(ЗначениеНастройки) Тогда
		Возврат "Не установлено";
	КонецЕсли;

	Возврат Строка(ЗначениеНастройки);
КонецФункции

&НаСервере
Функция ПредставлениеНастройки(ЭлементНастроек, ОписаниеНастройки, ТипНастройки)
	ПредставлениеНастройки = "";

	Если ЗначениеЗаполнено(ЭлементНастроек.ПредставлениеПользовательскойНастройки) Тогда
		ПредставлениеНастройки = ЭлементНастроек.ПредставлениеПользовательскойНастройки;
	ИначеЕсли ТипНастройки = Тип("ЭлементОтбораКомпоновкиДанных") И ЗначениеЗаполнено(ЭлементНастроек.Представление) Тогда
		ПредставлениеНастройки = ЭлементНастроек.Представление;
	ИначеЕсли ОписаниеНастройки <> Неопределено Тогда
		ПредставлениеНастройки = ОписаниеНастройки.Заголовок;
	ИначеЕсли ТипНастройки = Тип("НастройкиКомпоновкиДанных") Или ТипНастройки = Тип("ГруппировкаКомпоновкиДанных") Или ТипНастройки = Тип("ДиаграммаКомпоновкиДанных") Или ТипНастройки = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Или ТипНастройки = Тип("ТаблицаКомпоновкиДанных") Или ТипНастройки = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		ПредставлениеНастройки = ВариантыОтчетовСервер.сВО_ПредставлениеЭлементаСтруктуры(ЭлементНастроек);
	ИначеЕсли ТипНастройки = Тип("КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных") Или ТипНастройки = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Или ТипНастройки = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных") Тогда
		ПредставлениеНастройки = ВариантыОтчетовСервер.сВО_ПредставлениеЭлементовСтруктуры(ЭлементНастроек);
	ИначеЕсли ТипНастройки = Тип("ВыбранныеПоляКомпоновкиДанных") Тогда
		ПредставлениеНастройки = ВариантыОтчетовСервер.сВО_ПредставлениеВыбранныхПолей(ЭлементНастроек);
	ИначеЕсли ТипНастройки = Тип("ПорядокКомпоновкиДанных") Тогда
		ПредставлениеНастройки = ВариантыОтчетовСервер.сВО_ПредставлениеСортировки(ЭлементНастроек);
	ИначеЕсли ТипНастройки = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
		ПредставлениеНастройки = ВариантыОтчетовСервер.сВО_ПредставлениеЭлементаСортировки(ЭлементНастроек);
	ИначеЕсли ТипНастройки = Тип("УсловноеОформлениеКомпоновкиДанных") Тогда
		ПредставлениеНастройки = ВариантыОтчетовСервер.сВО_ПредставлениеУсловногоОформления(ЭлементНастроек);
	ИначеЕсли ТипНастройки = Тип("ЭлементУсловногоОформленияКомпоновкиДанных") Тогда
		ПредставлениеНастройки = ВариантыОтчетовКлиентСервер.О_ПредставлениеЭлементаУсловногоОформления(ЭлементНастроек, Неопределено, "");
	КонецЕсли;

	Возврат ПредставлениеНастройки;
КонецФункции

&НаСервере
Функция КартинкаНастройки(ЭлементНастроек, ТипНастройки)
	КартинкаНастройки = -1;

	Если ТипНастройки = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Или ТипНастройки = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		КартинкаНастройки = 17;
	ИначеЕсли ТипНастройки = Тип("НастройкиКомпоновкиДанных") Тогда
		КартинкаНастройки = 20;
	ИначеЕсли ТипНастройки = Тип("ГруппировкаКомпоновкиДанных") Или ТипНастройки = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Или ТипНастройки = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		КартинкаНастройки = 7;
	ИначеЕсли ТипНастройки = Тип("КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных") Или ТипНастройки = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Или ТипНастройки = Тип("КоллекцияЭлементовСтруктурыДиаграммыКомпоновкиДанных") Тогда
		КартинкаНастройки = 22;
	ИначеЕсли ТипНастройки = Тип("ТаблицаКомпоновкиДанных") Тогда
		КартинкаНастройки = 9;
	ИначеЕсли ТипНастройки = Тип("ДиаграммаКомпоновкиДанных") Тогда
		КартинкаНастройки = 11;
	ИначеЕсли ТипНастройки = Тип("ВыбранныеПоляКомпоновкиДанных") Тогда
		КартинкаНастройки = 18;
	ИначеЕсли ТипНастройки = Тип("ПорядокКомпоновкиДанных") Или ТипНастройки = Тип("ЭлементПорядкаКомпоновкиДанных") Тогда
		КартинкаНастройки = 19;
	ИначеЕсли ТипНастройки = Тип("УсловноеОформлениеКомпоновкиДанных") Или ТипНастройки = Тип("ЭлементУсловногоОформления") Тогда
		КартинкаНастройки = 20;
	КонецЕсли;

	Возврат КартинкаНастройки;
КонецФункции

&НаСервере
Процедура УстановитьУсловиеФильтра(Запись, ОписаниеНастройки, ТипНастройки, ИдентификаторПользовательскойНастройки)
	Если ТипНастройки <> Тип("ЗначениеПараметраНастроекКомпоновкиДанных") И ТипНастройки <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;

	ЭлементПользовательскихНастроек = КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ИдентификаторПользовательскойНастройки);

	Если ТипНастройки = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Запись.ВидСравнения = ЭлементПользовательскихНастроек.ВидСравнения;
	КонецЕсли;

	Если ОписаниеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если ТипНастройки = Тип("ЗначениеПараметраНастроекКомпоновкиДанных") Тогда
		Если ОписаниеНастройки.ДоступенСписокЗначений Тогда
			Запись.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		Иначе
			Запись.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		КонецЕсли;

		Возврат;
	КонецЕсли;

	ДоступныеУсловия = Запись.ДоступныеВидыСравнения;

	Для Каждого Элемент Из ОписаниеНастройки.ДоступныеВидыСравнения Цикл
		ЗаполнитьЗначенияСвойств(ДоступныеУсловия.Добавить(), Элемент);
	КонецЦикла;

	Если ДоступныеУсловия.НайтиПоЗначению(Запись.ВидСравнения) = Неопределено Тогда
		Запись.ВидСравнения = ДоступныеУсловия[0].Значение;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРежимОтображенияНастроек(Пометка = Истина)
	Для Каждого Запись Из БыстрыеНастройки Цикл
		Запись.Пометка = Пометка;
		ИзменитьРежимОтображенияЭлементаНастроек(Запись);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРежимОтображенияЭлементаНастроек(Запись)
	Настройки			= КомпоновщикНастроек.ПользовательскиеНастройки;

	ЭлементыНастроек	= Настройки.ПолучитьОсновныеНастройкиПоИдентификаторуПользовательскойНастройки(Запись.ИдентификаторПользовательскойНастройки);

	ЭлементНастроек		= ЭлементыНастроек[0];

	Если Запись.Пометка Тогда
		ЭлементНастроек.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
	Иначе
		ЭлементНастроек.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
	КонецЕсли;

	ОбновитьЗаголовок();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовок()
	КоличествоБыстрыхНастроек = 0;

	Для Каждого Запись Из БыстрыеНастройки Цикл
		Если Запись.Пометка Тогда
			КоличествоБыстрыхНастроек = КоличествоБыстрыхНастроек + 1;
		КонецЕсли;
	КонецЦикла;

	Заголовок = СтрШаблон("Быстрые настройки (%1 из %2)", КоличествоБыстрыхНастроек, БыстрыеНастройки.Количество());
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВидСравнения(Элемент, СтандартнаяОбработка)
	Запись = Элементы.БыстрыеНастройки.ТекущиеДанные;

	Если Запись = Неопределено Или Запись.ТипНастройки <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;

	ПараметрыВыбора = Новый Структура("ИдентификаторЗаписи", Элементы.БыстрыеНастройки.ТекущаяСтрока);

	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ПослеВыбораВидаСравнения", ЭтотОбъект, ПараметрыВыбора), Запись.ДоступныеВидыСравнения, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораВидаСравнения(ВыбранныйВидСравнения, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(ВыбранныйВидСравнения) <> Тип("ЭлементСпискаЗначений") Тогда
		Возврат;
	КонецЕсли;

	Запись				= БыстрыеНастройки.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторЗаписи);
	Запись.ВидСравнения	= ВыбранныйВидСравнения.Значение;

	Настройки			= КомпоновщикНастроек.ПользовательскиеНастройки;

	ЭлементыНастроек	= Настройки.ПолучитьОсновныеНастройкиПоИдентификаторуПользовательскойНастройки(Запись.ИдентификаторПользовательскойНастройки);

	ЭлементНастроек					= ЭлементыНастроек[0];
	ЭлементНастроек.ВидСравнения	= ВыбранныйВидСравнения.Значение;

	ВариантМодифицирован = Истина;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеНастроекОтчета(Описание)
	Возврат Описание;
КонецФункции

&НаКлиенте
Процедура СохранитьПорядокЭлементовНастроек()
	ПорядокЭлементовНастроек	= Новый Соответствие;

	Порядок						= 0;

	Для Каждого Запись Из БыстрыеНастройки Цикл
		Порядок			= Порядок + 1;
		Запись.Порядок	= Порядок;
		ПорядокЭлементовНастроек.Вставить(Запись.ИдентификаторПользовательскойНастройки, Порядок);
	КонецЦикла;

	КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ПорядокЭлементовНастроек", ПорядокЭлементовНастроек);
КонецПроцедуры
