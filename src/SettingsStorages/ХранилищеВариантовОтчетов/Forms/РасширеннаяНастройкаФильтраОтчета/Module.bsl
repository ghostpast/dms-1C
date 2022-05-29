///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ОпределитьПоведениеВМобильномКлиенте();

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НастройкиОтчета, КомпоновщикНастроек, КлючТекущегоВарианта");

	СвойстваЗаголовка = Параметры.СвойстваЗаголовка;

	Заголовок = СтрШаблон("Фильтровать по полю: %1", СвойстваЗаголовка.Текст);

	ИнициализироватьДанныеФормы();

	УстановитьУсловноеОформление();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПривестиПравыеЗначенияКУсловию();
КонецПроцедуры

&НаКлиенте
Процедура ТипГруппыЭлементовФильтраПриИзменении(Элемент)
	ИспользованиеГруппы	= Истина;
	Использование2		= Истина;
КонецПроцедуры

&НаКлиенте
Процедура ВидСравнения1ПриИзменении(Элемент)
	ПривестиПравоеЗначениеКУсловию(1);
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначение1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначение1ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ПравоеЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеГруппыПриИзменении(Элемент)
	Использование2 = ИспользованиеГруппы;
КонецПроцедуры

&НаКлиенте
Процедура ЛевоеЗначение2ПриИзменении(Элемент)
	Если ЗначениеЗаполнено(ЛевоеЗначение2) Тогда
		ИспользованиеГруппы	= Истина;
		Использование2		= Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВидСравнения2ПриИзменении(Элемент)
	ИспользованиеГруппы	= Истина;
	Использование2		= Истина;

	ПривестиПравоеЗначениеКУсловию(2);
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначение2ПриИзменении(Элемент)
	ИспользованиеГруппы	= Истина;
	Использование2		= Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначение2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначение2ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ПравоеЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиКРасширеннымНастройкам(Команда)
	Настройки						= КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(СвойстваЗаголовка.ИдентификаторНастроек);
	ГруппировкаФильтра				= ВариантыОтчетовКлиентСервер.сВО_ГруппировкаФильтра(Настройки, СвойстваЗаголовка);
	ИдентификаторГруппировкаФильтра	= Настройки.ПолучитьИдентификаторПоОбъекту(ГруппировкаФильтра);

	ПутьКЭлементуСтруктурыНастроек = ВариантыОтчетовКлиент.О_ПолныйПутьКЭлементуНастроек(КомпоновщикНастроек.Настройки, ГруппировкаФильтра);

	ОписаниеНастроекОтчета = ОписаниеНастроекОтчета(НастройкиОтчета);

	Если ТипЗнч(ГруппировкаФильтра) = Тип("НастройкиКомпоновкиДанных") Тогда
		ЗаголовокГруппировкаФильтра = СтрШаблон("Фильтры отчета ""%1""", ОписаниеНастроекОтчета.Наименование);
	Иначе
		ЗаголовокГруппировкаФильтра = СтрШаблон("Фильтры группировки ""%1"" отчета ""%2""", Строка(ГруппировкаФильтра.ПоляГруппировки), ОписаниеНастроекОтчета.Наименование);
	КонецЕсли;

	ДобавитьФильтры();

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючВарианта",								КлючТекущегоВарианта);
	ПараметрыФормы.Вставить("Вариант",									КомпоновщикНастроек.Настройки);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки",				КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("НастройкиОтчета",							НастройкиОтчета);
	ПараметрыФормы.Вставить("ВариантНаименование",						ОписаниеНастроекОтчета.Наименование);
	ПараметрыФормы.Вставить("ИдентификаторЭлементаСтруктурыНастроек",	ИдентификаторГруппировкаФильтра);
	ПараметрыФормы.Вставить("ПутьКЭлементуСтруктурыНастроек",			ПутьКЭлементуСтруктурыНастроек);
	ПараметрыФормы.Вставить("ТипЭлементаСтруктурыНастроек",				Строка(ТипЗнч(ГруппировкаФильтра)));
	ПараметрыФормы.Вставить("Заголовок",								ЗаголовокГруппировкаФильтра);
	ПараметрыФормы.Вставить("ИмяСтраницы",								"СтраницаОтборы");
	ПараметрыФормы.Вставить("ОтображатьСтраницы",						Ложь);

	ОткрытьФорму(НастройкиОтчета.ПолноеИмя + ".ФормаНастроек", ПараметрыФормы, ВладелецФормы);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьИСформировать(Команда)
	ПрименитьФильтры(Команда);
КонецПроцедуры

&НаКлиенте
Процедура Фильтровать(Команда)
	ПрименитьФильтры(Команда);
КонецПроцедуры

&НаСервере
Процедура ОпределитьПоведениеВМобильномКлиенте()
	ЭтоМобильныйКлиент = БазоваяПодсистемаСервер.ОН_ЭтоМобильныйКлиент();
	Если Не ЭтоМобильныйКлиент Тогда
		Возврат;
	КонецЕсли;

	ОсновныеКоманды = Элементы.КомандыОсновные.ПодчиненныеЭлементы;

	Для НомерКоманды = 1 По ОсновныеКоманды.Количество() Цикл
		Элементы.Переместить(ОсновныеКоманды[0], Элементы.ФормаКоманднаяПанель);
	КонецЦикла;

	Элементы.ФильтроватьИСформировать.Отображение = ОтображениеКнопки.Картинка;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();

	Элемент						= УсловноеОформление.Элементы.Добавить();

	ОтборЭлемента				= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение	= Новый ПолеКомпоновкиДанных("ПредставлениеЛевогоЗначения1");
	ОтборЭлемента.ВидСравнения	= ВидСравненияКомпоновкиДанных.Заполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ЛевоеЗначение1"));

	ПолеЭлемента				= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле			= Новый ПолеКомпоновкиДанных(Элементы.ЛевоеЗначение1.Имя);

	Элемент						= УсловноеОформление.Элементы.Добавить();

	ОтборЭлемента				= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение	= Новый ПолеКомпоновкиДанных("ПредставлениеЛевогоЗначения2");
	ОтборЭлемента.ВидСравнения	= ВидСравненияКомпоновкиДанных.Заполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ЛевоеЗначение2"));

	ПолеЭлемента				= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле			= Новый ПолеКомпоновкиДанных(Элементы.ЛевоеЗначение2.Имя);
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьДанныеФормы()
	Фильтры			= Неопределено;
	ОписаниеФильтра	= ОписаниеФильтра(КомпоновщикНастроек, СвойстваЗаголовка, Фильтры);

	Если ОписаниеФильтра <> Неопределено Тогда
		ТипЗначенияФильтра = ОписаниеФильтра.ТипЗначения;
	КонецЕсли;

	УстановитьЛевоеЗначение(СвойстваЗаголовка.Поле);
	УстановитьДоступныеВидыСравнения(ОписаниеФильтра);
	УстановитьПравоеЗначение(ОписаниеФильтра);

	ТипГруппыЭлементовФильтра = Элементы.ТипГруппыЭлементовФильтра.СписокВыбора[0].Значение;

	НайтиФильтры(Фильтры);
КонецПроцедуры

&НаСервере
Процедура УстановитьЛевоеЗначение(Поле)
	Для НомерЭлемента = 1 По 2 Цикл
		ИмяЭлемента = СтрШаблон("ЛевоеЗначение%1", НомерЭлемента);

		ЭтотОбъект[ИмяЭлемента]					= Поле;
		Элементы[ИмяЭлемента].ОграничениеТипа	= Новый ОписаниеТипов("ПолеКомпоновкиДанных");

		ИмяЭлемента = СтрШаблон("ПредставлениеЛевогоЗначения%1", НомерЭлемента);

		ЭтотОбъект[ИмяЭлемента] = СвойстваЗаголовка.Текст;

	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступныеВидыСравнения(ОписаниеФильтра)
	Если ОписаниеФильтра = Неопределено Тогда
		ВидыСравнения = ВидСравненияКомпоновкиДанных;
	Иначе
		ВидыСравнения = ОписаниеФильтра.ДоступныеВидыСравнения.ВыгрузитьЗначения();
	КонецЕсли;

	Для НомерЭлемента = 1 По 2 Цикл
		ИмяЭлемента = СтрШаблон("ВидСравнения%1", НомерЭлемента);

		Элементы[ИмяЭлемента].ДоступныеТипы	= Новый ОписаниеТипов("ВидСравненияКомпоновкиДанных");

		Список								= Элементы[ИмяЭлемента].СписокВыбора;

		Для Каждого ТекущийВид Из ВидыСравнения Цикл
			Список.Добавить(ТекущийВид);
		КонецЦикла;

		ЭтотОбъект[ИмяЭлемента] = Список[0].Значение;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьПравоеЗначение(ОписаниеФильтра)
	Если ОписаниеФильтра <> Неопределено И ОписаниеФильтра.ДоступныеЗначения <> Неопределено Тогда

		ДоступныеЗначения = ОписаниеФильтра.ДоступныеЗначения;
	КонецЕсли;

	Для НомерЭлемента = 1 По 2 Цикл
		ИмяЭлемента = СтрШаблон("ПравоеЗначение%1", НомерЭлемента);

		ПолеПравогоЗначения = Элементы[ИмяЭлемента];
		ПолеПравогоЗначения.СписокВыбора.Очистить();

		Для Каждого ДоступноеЗначение Из ДоступныеЗначения Цикл
			ЗаполнитьЗначенияСвойств(ПолеПравогоЗначения.СписокВыбора.Добавить(), ДоступноеЗначение);
		КонецЦикла;

		ПолеПравогоЗначения.РежимВыбораИзСписка = ПолеПравогоЗначения.СписокВыбора.Количество() > 0;

		Условие = ЭтотОбъект[СтрШаблон("ВидСравнения%1", НомерЭлемента)];
		ОпределитьДоступностьПоляПравогоЗначения(ПолеПравогоЗначения, Условие);
	КонецЦикла;

	ДоступныеТипы		= ?(ОписаниеФильтра = Неопределено, Новый ОписаниеТипов("Неопределено"), ОписаниеФильтра.ТипЗначения);
	ДанныеРасшифровки	= ПолучитьИзВременногоХранилища(Параметры.ДанныеРасшифровки);

	ЗначениеЯчейки	= ВариантыОтчетовСервер.сВО_ЗначениеЯчейки(Параметры.Ячейка, ДоступныеТипы, ДанныеРасшифровки);
	ПравоеЗначение1	= ЗначениеЯчейки.Значение;
КонецПроцедуры

&НаСервере
Процедура НайтиФильтры(Фильтр)
	Для Каждого Элемент Из Фильтр.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ИспользованиеГруппы	= Элемент.Использование;
			ЭлементыГруппы		= Элемент.Элементы;

			Если ЭлементыГруппы.Количество() <> 2 Или ЭлементыГруппы[0].ЛевоеЗначение <> ЛевоеЗначение1 Или ЭлементыГруппы[1].ЛевоеЗначение <> ЛевоеЗначение2 Тогда
				Продолжить;
			КонецЕсли;

			УстановитьСвойстваФильтра(ЭлементыГруппы[0], 1);
			УстановитьСвойстваФильтра(ЭлементыГруппы[1], 2);

			ТипГруппыЭлементовФильтра = СтрЗаменить(Элемент.ТипГруппы, " ", "");
		ИначеЕсли Элемент.ЛевоеЗначение = ЛевоеЗначение1 Тогда
			УстановитьСвойстваФильтра(Элемент, 1);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваФильтра(Фильтр, НомерЭлемента)
	Если Не Фильтр.ИСпользование Тогда
		Возврат;
	КонецЕсли;

	ЭтотОбъект[СтрШаблон("Использование%1", НомерЭлемента)]		= Фильтр.Использование;
	ЭтотОбъект[СтрШаблон("ВидСравнения%1", НомерЭлемента)]		= Фильтр.ВидСравнения;
	ЭтотОбъект[СтрШаблон("ПравоеЗначение%1", НомерЭлемента)]	= Фильтр.ПравоеЗначение;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФильтры()
	Фильтры = Фильтры(КомпоновщикНастроек, СвойстваЗаголовка);

	УдалитьФильтры(Фильтры);

	Если ИспользованиеГруппы Тогда
		Группа = ГруппаФильтра(Фильтры);
		ДобавитьФильтр(Группа, ЛевоеЗначение1, ВидСравнения1, ПравоеЗначение1);
		ДобавитьФильтр(Группа, ЛевоеЗначение2, ВидСравнения2, ПравоеЗначение2, 1);
	Иначе
		ДобавитьФильтр(Фильтры, ЛевоеЗначение1, ВидСравнения1, ПравоеЗначение1);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФильтры(Фильтры)
	ФильтрыКУдалению = Новый Массив;

	Для Каждого Элемент Из Фильтры.Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			ЭлементыГруппы = Элемент.Элементы;
			Если ЭлементыГруппы.Количество() = 2 И ЭлементыГруппы[0].ЛевоеЗначение = ЛевоеЗначение1 И ЭлементыГруппы[1].ЛевоеЗначение = ЛевоеЗначение2 Тогда
				ФильтрыКУдалению.Добавить(Элемент);
			КонецЕсли;
		ИначеЕсли Элемент.ЛевоеЗначение = ЛевоеЗначение1 Тогда
			ФильтрыКУдалению.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;

	Для Каждого Фильтр Из ФильтрыКУдалению Цикл
		Фильтры.Элементы.Удалить(Фильтр);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ГруппаФильтра(Фильтр)
	Группа					= Фильтр.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	Группа.ТипГруппы		= ТипГруппыЭлементовОтбораКомпоновкиДанных[ТипГруппыЭлементовФильтра];
	Группа.Использование	= ИспользованиеГруппы;

	Возврат Группа;
КонецФункции

&НаКлиенте
Процедура ДобавитьФильтр(Фильтр, ЛевоеЗначение, ВидСравнения, ПравоеЗначение, Индекс = 0)
	Элемент					= Фильтр.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	Элемент.ЛевоеЗначение	= ЛевоеЗначение;
	Элемент.ВидСравнения	= ВидСравнения;
	Элемент.ПравоеЗначение	= ПравоеЗначение;
	Элемент.Использование	= Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПривестиПравыеЗначенияКУсловию()
	Для НомерЭлемента = 1 По 2 Цикл
		ПривестиПравоеЗначениеКУсловию(НомерЭлемента);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПривестиПравоеЗначениеКУсловию(НомерЭлемента)
	Условие				= ЭтотОбъект[СтрШаблон("ВидСравнения%1", НомерЭлемента)];

	ИмяПравогоЗначения	= СтрШаблон("ПравоеЗначение%1", НомерЭлемента);
	ПолеПравогоЗначения	= Элементы[ИмяПравогоЗначения];

	Если ВариантыОтчетовКлиентСервер.О_ЭтоВидСравненияСписка(Условие) Тогда
		ПравоеЗначение								= ВариантыОтчетовКлиентСервер.О_ЗначенияСписком(ЭтотОбъект[ИмяПравогоЗначения]);
		ЭтотОбъект[ИмяПравогоЗначения]				= ПравоеЗначение;
		ЭтотОбъект[ИмяПравогоЗначения].ТипЗначения	= ТипЗначенияФильтра;

		УточнитьПравоеЗначение(ЭтотОбъект[ИмяПравогоЗначения]);

		ПолеПравогоЗначения.ОграничениеТипа		= Новый ОписаниеТипов("СписокЗначений");
		ПолеПравогоЗначения.ВыбиратьТип			= Ложь;
		ПолеПравогоЗначения.РежимВыбораИзСписка	= Ложь;
		ПолеПравогоЗначения.КнопкаВыбора		= Истина;
	Иначе
		Если ТипЗнч(ЭтотОбъект[ИмяПравогоЗначения]) = Тип("СписокЗначений") Тогда
			Если ЭтотОбъект[ИмяПравогоЗначения].Количество() > 0 Тогда
				ПравоеЗначение = ЭтотОбъект[ИмяПравогоЗначения][0].Значение;
			Иначе
				ПравоеЗначение = ТипЗначенияФильтра.ПривестиЗначение();
			КонецЕсли;

			ЭтотОбъект[ИмяПравогоЗначения] = ПравоеЗначение;
		КонецЕсли;

		ДоступныеТипы	= ТипЗначенияФильтра.Типы();
		ЭтоСтрока		= ДоступныеТипы.Количество() = 1 И ДоступныеТипы.Найти(Тип("Строка")) <> Неопределено;

		ОписаниеФильтра			= ОписаниеФильтра(КомпоновщикНастроек, СвойстваЗаголовка);
		ВыборГруппИЭлементов	= ВариантыОтчетовКлиент.О_ЗначениеТипаИспользованиеГруппИЭлементов(?(ОписаниеФильтра = Неопределено, Неопределено, ОписаниеФильтра.ВыборГруппИЭлементов), Условие);

		ПолеПравогоЗначения.ОграничениеТипа			= ТипЗначенияФильтра;
		ПолеПравогоЗначения.ВыбиратьТип				= (ДоступныеТипы.Количество() <> 1);
		ПолеПравогоЗначения.РежимВыбораИзСписка		= (ПолеПравогоЗначения.СписокВыбора.Количество() > 0);
		ПолеПравогоЗначения.КнопкаВыбора			= Не ЭтоСтрока И Не ПолеПравогоЗначения.РежимВыбораИзСписка;
		ПолеПравогоЗначения.ВыборГруппИЭлементов	= ВариантыОтчетовКлиентСервер.О_ЗначениеТипаГруппыИЭлементы(ВыборГруппИЭлементов, Условие);
	КонецЕсли;

	ОпределитьДоступностьПоляПравогоЗначения(ПолеПравогоЗначения, Условие);
КонецПроцедуры

&НаКлиенте
Процедура УточнитьПравоеЗначение(ПравоеЗначение)
	Если ТипЗнч(ПравоеЗначение) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;

	Для Каждого Элемент Из ПравоеЗначение Цикл
		ДоступноеЗначение = ДоступныеЗначения.НайтиПоЗначению(Элемент.Значение);

		Если ДоступноеЗначение <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Элемент, ДоступноеЗначение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ПравоеЗначение = ЭтотОбъект[Элемент.Имя];

	Если ТипЗнч(ПравоеЗначение) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;

	ОписаниеФильтра	= ОписаниеФильтра(КомпоновщикНастроек, СвойстваЗаголовка);
	Фильтр			= Фильтр(КомпоновщикНастроек, СвойстваЗаголовка);

	ПараметрыВыбора			= ВариантыОтчетовКлиентСервер.О_ПараметрыВыбора(КомпоновщикНастроек.Настройки, КомпоновщикНастроек.ПользовательскиеНастройки.Элементы, Фильтр);

	ВыборГруппИЭлементов	= ВариантыОтчетовКлиент.О_ЗначениеТипаИспользованиеГруппИЭлементов(?(ОписаниеФильтра = Неопределено, Неопределено, ОписаниеФильтра.ВыборГруппИЭлементов), ВидСравнения);

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отмеченные",							ПравоеЗначение);
	ПараметрыОткрытия.Вставить("ОписаниеТипов",							ПравоеЗначение.ТипЗначения);
	ПараметрыОткрытия.Вставить("ЗначенияДляВыбора",						Элемент.СписокВыбора);
	ПараметрыОткрытия.Вставить("ЗначенияДляВыбораЗаполнены",			Элемент.СписокВыбора.Количество() > 0);
	ПараметрыОткрытия.Вставить("ОграничиватьВыборУказаннымиЗначениями",	ДоступныеЗначения.Количество() > 0);
	ПараметрыОткрытия.Вставить("Представление",							СвойстваЗаголовка.Текст);
	ПараметрыОткрытия.Вставить("ПараметрыВыбора",						Новый Массив(ПараметрыВыбора));
	ПараметрыОткрытия.Вставить("ВыборГруппИЭлементов",					ВыборГруппИЭлементов);
	ПараметрыОткрытия.Вставить("БыстрыйВыбор",							?(ОписаниеФильтра = Неопределено, Ложь, ОписаниеФильтра.БыстрыйВыбор));

	ОткрытьФорму("ОбщаяФорма.ВводЗначенийСпискомСФлажками", ПараметрыОткрытия, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;

	ПравоеЗначение = ЭтотОбъект[Элемент.Имя];
	ПравоеЗначение.Очистить();

	Для Каждого Элемент Из ВыбранноеЗначение Цикл
		Если Элемент.Пометка Тогда
			ЗаполнитьЗначенияСвойств(ПравоеЗначение.Добавить(), Элемент);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьФильтры(Команда)
	ДобавитьФильтры();

	Результат = ВариантыОтчетовКлиент.сВО_СтандартныйРезультатНастройкиИзКонтекстногоМеню(КомпоновщикНастроек, Команда.Действие, ВладелецФормы.УникальныйИдентификатор);

	Если Команда.Имя = Элементы.Фильтровать.ИмяКоманды Тогда
		Результат.УчитыватьВремяФормирования = Ложь;
	КонецЕсли;

	ОповеститьОВыборе(Результат);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция Фильтры(КомпоновщикНастроек, СвойстваЗаголовка)
	Настройки = КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(СвойстваЗаголовка.ИдентификаторНастроек);

	Возврат ВариантыОтчетовКлиентСервер.сВО_ФильтрыРазделаОтчета(Настройки, СвойстваЗаголовка);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция Фильтр(КомпоновщикНастроек, СвойстваЗаголовка)
	Фильтры = Фильтры(КомпоновщикНастроек, СвойстваЗаголовка);

	Возврат ВариантыОтчетовКлиентСервер.сВО_ФильтрРазделаОтчета(Фильтры, СвойстваЗаголовка.Поле);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеФильтра(КомпоновщикНастроек, СвойстваЗаголовка, Фильтры = Неопределено)
	ОписаниеФильтра = Неопределено;

	Если Фильтры = Неопределено Тогда
		Фильтры = Фильтры(КомпоновщикНастроек, СвойстваЗаголовка);
	КонецЕсли;

	Если СвойстваЗаголовка.Поле <> Неопределено Тогда
		ОписаниеФильтра = Фильтры.ДоступныеПоляОтбора.НайтиПоле(СвойстваЗаголовка.Поле);
	КонецЕсли;

	Возврат ОписаниеФильтра;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОпределитьДоступностьПоляПравогоЗначения(Поле, Условие)
	Поле.Доступность = Условие <> ВидСравненияКомпоновкиДанных.Заполнено И Условие <> ВидСравненияКомпоновкиДанных.НеЗаполнено;
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеНастроекОтчета(Описание)
	Возврат Описание;
КонецФункции
