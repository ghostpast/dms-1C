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
	ОпределитьПоведениеВМобильномКлиенте();

	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НастройкиОтчета, КомпоновщикНастроек, СвойстваЗаголовка, Документ");
	АдресДанныхРасшифровки = Параметры.ДанныеРасшифровки;
	НастройкиОтчета.Вставить("КэшЗначенийОтборов", Параметры.КэшЗначенийОтборов);

	Инициализировать();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьЗначенияДополнительныхВозможностей();
КонецПроцедуры

&НаКлиенте
Процедура ИспользованиеПриИзменении(Элемент)
	СнятьФильтрПоУсловию = Не Использование;
КонецПроцедуры

&НаКлиенте
Процедура ВидСравненияПриИзменении(Элемент)
	Использование		= Истина;
	ПолеПравогоЗначения = Элементы.ПравоеЗначение;

	Если ВариантыОтчетовКлиентСервер.О_ЭтоВидСравненияСписка(ВидСравнения) Тогда
		ПравоеЗначение				= ВариантыОтчетовКлиентСервер.О_ЗначенияСписком(ПравоеЗначение);
		ПравоеЗначение.ТипЗначения	= Значения.ТипЗначения;

		УточнитьПравоеЗначение(ПравоеЗначение, ДоступныеЗначения);

		ПолеПравогоЗначения.ОграничениеТипа		= Новый ОписаниеТипов("СписокЗначений");
		ПолеПравогоЗначения.ВыбиратьТип			= Ложь;
		ПолеПравогоЗначения.РежимВыбораИзСписка	= Ложь;
		ПолеПравогоЗначения.КнопкаВыбора		= Истина;
	Иначе
		Если ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений") Тогда
			Если ПравоеЗначение.Количество() > 0 Тогда
				ПравоеЗначение = ПравоеЗначение[0].Значение;
			Иначе
				ПравоеЗначение = Значения.ТипЗначения.ПривестиЗначение();
			КонецЕсли;
		КонецЕсли;

		ДоступныеТипы	= Значения.ТипЗначения.Типы();
		ЭтоСтрока		= ДоступныеТипы.Количество() = 1 И ДоступныеТипы.Найти(Тип("Строка")) <> Неопределено;

		ОписаниеФильтра			= ОписаниеФильтра(КомпоновщикНастроек, СвойстваЗаголовка);
		ВыборГруппИЭлементов	= ВариантыОтчетовКлиент.О_ЗначениеТипаИспользованиеГруппИЭлементов(?(ОписаниеФильтра = Неопределено, Неопределено, ОписаниеФильтра.ВыборГруппИЭлементов), ВидСравнения);

		ПолеПравогоЗначения.ОграничениеТипа			= Значения.ТипЗначения;
		ПолеПравогоЗначения.ВыбиратьТип				= (ДоступныеТипы.Количество() <> 1);
		ПолеПравогоЗначения.РежимВыбораИзСписка		= (ПолеПравогоЗначения.СписокВыбора.Количество() > 0);
		ПолеПравогоЗначения.КнопкаВыбора			= Не ЭтоСтрока И Не ПолеПравогоЗначения.РежимВыбораИзСписка;
		ПолеПравогоЗначения.ВыборГруппИЭлементов	= ВариантыОтчетовКлиентСервер.О_ЗначениеТипаГруппыИЭлементы(ВыборГруппИЭлементов, ВидСравнения);
	КонецЕсли;

	ОпределитьДоступностьПоляПравогоЗначения(ПолеПравогоЗначения, ВидСравнения);
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначениеПриИзменении(Элемент)
	Использование = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ТипЗнч(ПравоеЗначение) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;

	СтандартнаяОбработка = Ложь;

	Фильтр			= Фильтр(КомпоновщикНастроек, СвойстваЗаголовка);
	ОписаниеФильтра	= ОписаниеФильтра(КомпоновщикНастроек, СвойстваЗаголовка);

	ПараметрыВыбора			= ВариантыОтчетовКлиентСервер.О_ПараметрыВыбора(КомпоновщикНастроек.Настройки, КомпоновщикНастроек.ПользовательскиеНастройки.Элементы, Фильтр);

	ВыборГруппИЭлементов	= ВариантыОтчетовКлиент.О_ЗначениеТипаИспользованиеГруппИЭлементов(?(ОписаниеФильтра = Неопределено, Неопределено, ОписаниеФильтра.ВыборГруппИЭлементов), ВидСравнения);

	Если ПравоеЗначение.Количество() = 0 Тогда
		Отмеченные = Новый СписокЗначений;

		Для Каждого Значение Из Значения Цикл
			Если Значение.Пометка Тогда
				ЗаполнитьЗначенияСвойств(Отмеченные.Добавить(), Значение);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Отмеченные = БазоваяПодсистемаКлиент.ОН_СкопироватьРекурсивно(ПравоеЗначение);
	КонецЕсли;

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отмеченные",							Отмеченные);
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

	ПравоеЗначение.Очистить();

	Для Каждого Элемент Из ВыбранноеЗначение Цикл
		Если Элемент.Пометка Тогда
			ЗаполнитьЗначенияСвойств(ПравоеЗначение.Добавить(), Элемент);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПриИзменении(Элемент)
	Использование = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле <> Элементы.ЗначенияЗначение Тогда
		Возврат;
	КонецЕсли;

	Строка = Значения.НайтиПоИдентификатору(ВыбраннаяСтрока);

	ПоказатьЗначение(Неопределено, Строка.Значение);
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияПометкаПриИзменении(Элемент)
	СнятьФильтрПоУсловию = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ФильтроватьИСформировать(Команда)
	ПрименитьНастройки(Команда);
КонецПроцедуры

&НаКлиенте
Процедура Фильтровать(Команда)
	ПрименитьНастройки(Команда);
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию(Команда)
	ВариантыОтчетовКлиент.сВО_Сортировать(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию(Команда)
	ВариантыОтчетовКлиент.сВО_Сортировать(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоВыбранномуПолю(Команда)
	ВариантыОтчетовКлиент.сВО_СгруппироватьПоВыбранномуПолю(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПолеСлева(Команда)
	ВариантыОтчетовКлиент.сВО_ВыбратьПолеОтчетаИзМеню(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьПолеСправа(Команда)
	ВариантыОтчетовКлиент.сВО_ВыбратьПолеОтчетаИзМеню(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьГруппировкуВыше(Команда)
	ВариантыОтчетовКлиент.сВО_ВыбратьПолеОтчетаИзМеню(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ВставитьГруппировкуНиже(Команда)
	ВариантыОтчетовКлиент.сВО_ВыбратьПолеОтчетаИзМеню(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьПолеВлево(Команда)
	ВариантыОтчетовКлиент.сВО_ПереместитьПолеГоризонтально(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьПолеВправо(Команда)
	ВариантыОтчетовКлиент.сВО_ПереместитьПолеГоризонтально(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьПолеВыше(Команда)
	ВариантыОтчетовКлиент.сВО_ПереместитьПолеВертикально(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьПолеНиже(Команда)
	ВариантыОтчетовКлиент.сВО_ПереместитьПолеВертикально(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура СкрытьПоле(Команда)
	ВариантыОтчетовКлиент.сВО_СкрытьПоле(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ПереименоватьПоле(Команда)
	Если Не ЗначениеЗаполнено(ПредставлениеПоля) Тогда
		БазоваяПодсистемаКлиентСервер.сОН_СообщитьПользователю("Необходимо ввести новый заголовок поля",, "ПредставлениеПоля", "",  Ложь);

		Возврат;
	КонецЕсли;

	ВариантыОтчетовКлиент.сВО_ПереименоватьПоле(ЭтотОбъект, Команда, ПредставлениеПоля);
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПоляНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	ПредставлениеПоля = Элемент.ТекстРедактирования;
	ПереименоватьПоле(Команды.Найти("ПереименоватьПоле"));
КонецПроцедуры

&НаКлиенте
Процедура ОформитьОтрицательные(Команда)
	ВариантыОтчетовКлиент.сВО_ОформитьКрасным(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура ОформитьПоложительные(Команда)
	ВариантыОтчетовКлиент.сВО_ОформитьЗеленым(ЭтотОбъект, Команда);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВысотуСтроки(Команда)
	Если Не ЗначениеЗаполнено(ВысотаСтроки) Тогда
		БазоваяПодсистемаКлиентСервер.сОН_СообщитьПользователю("Необходимо ввести высоту строки",, "ВысотаСтроки", "",  Ложь);

		Возврат;
	КонецЕсли;

	ВариантыОтчетовКлиент.сВО_УстановитьВысотуСтроки(ЭтотОбъект, Команда, СвойстваЗаголовка, ВысотаСтроки);
	ОповеститьОВыборе(КомпоновщикНастроек.Настройки);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьШиринуКолонки(Команда)
	Если Не ЗначениеЗаполнено(ШиринаКолонки) Тогда
		БазоваяПодсистемаКлиентСервер.сОН_СообщитьПользователю("Необходимо ввести ширину колонки",, "ШиринаКолонки");

		Возврат;
	КонецЕсли;

	ВариантыОтчетовКлиент.сВО_УстановитьШиринуКолонки(ЭтотОбъект, Команда, СвойстваЗаголовка, ШиринаКолонки);
	ОповеститьОВыборе(КомпоновщикНастроек.Настройки);
КонецПроцедуры

&НаКлиенте
Процедура ОформитьЕще(Команда)
	ВариантыОтчетовКлиент.сВО_ОформитьЕще(ВладелецФормы, Команда);
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВывестиВсеЗначенияРазделаОтчетаНажатие(Элемент)
	Обработчик = Новый ОписаниеОповещения("ПослеЗаполненияЗначений", ЭтотОбъект);
	РезультатЗаполнения = НачатьЗаполнениеЗначений(УникальныйИдентификатор);

	ПараметрыОжидания = БазоваяПодсистемаКлиент.ДО_ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;

	Обработчик = Новый ОписаниеОповещения("ПриЗаполненииЗначений", ЭтотОбъект);
	БазоваяПодсистемаКлиент.ДО_ОжидатьЗавершение(РезультатЗаполнения, Обработчик, ПараметрыОжидания);
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();

	Элемент						= УсловноеОформление.Элементы.Добавить();

	ОтборЭлемента				= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение	= Новый ПолеКомпоновкиДанных("Значения.Значение");
	ОтборЭлемента.ВидСравнения	= ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", "(Пустые)");

	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ЗначенияЗначение.Имя);
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
Процедура Инициализировать()
	ЗаголовокПоля	= СвойстваЗаголовка.Текст;
	Заголовок		= СтрШаблон("Настройка поля: %1", ЗаголовокПоля);

	ПредставлениеПоля				= ЗаголовокПоля;
	КоличествоПервыхЧитаемыхСтрок	= 500;

	УстановитьСвойстваФильтраПоУсловию(ЗаголовокПоля);
	ОпределитьВидыИерархииЗначений();

	ЗаполнитьЗначения();

	ОбновитьИндексыГруппИЭлементов();
	УточнитьДоступныеТипыЗначений();
	ОпределитьДоступностьДополнительныхВозможностей();
КонецПроцедуры

&НаСервере
Процедура УстановитьСвойстваФильтраПоУсловию(ЗаголовокПоля)
	Элементы.ВидСравнения.ДоступныеТипы	= Новый ОписаниеТипов("ВидСравненияКомпоновкиДанных");
	ВидыСравнения						= Элементы.ВидСравнения.СписокВыбора;

	Если СвойстваЗаголовка.ТипЗначения <> Неопределено Тогда
		Значения.ТипЗначения = СвойстваЗаголовка.ТипЗначения;
	КонецЕсли;

	ОписаниеФильтра = ОписаниеФильтра(КомпоновщикНастроек, СвойстваЗаголовка);

	Если ОписаниеФильтра = Неопределено Тогда
		Для Каждого ТекущийВид Из ВидСравненияКомпоновкиДанных Цикл
			ВидыСравнения.Добавить(ТекущийВид);
		КонецЦикла;
	Иначе
		Для Каждого ТекущийВид Из ОписаниеФильтра.ДоступныеВидыСравнения Цикл
			ЗаполнитьЗначенияСвойств(ВидыСравнения.Добавить(), ТекущийВид);
		КонецЦикла;

		Значения.ТипЗначения						= ОписаниеФильтра.ТипЗначения;
		Элементы.ЗначенияЗначение.ОграничениеТипа	= Значения.ТипЗначения;

		Если ОписаниеФильтра.ДоступныеЗначения <> Неопределено Тогда
			ДоступныеЗначения.ТипЗначения	= ОписаниеФильтра.ТипЗначения;
			ДоступныеЗначения				= ОписаниеФильтра.ДоступныеЗначения;
		КонецЕсли;
	КонецЕсли;

	ВидСравнения = ВидыСравнения[0].Значение;
КонецПроцедуры

&НаСервере
Процедура УточнитьДоступныеТипыЗначений()
	ДоступныеТипы = Значения.ТипЗначения.Типы();

	Если ДоступныеТипы.Количество() = 0 Тогда
		Индексы = Новый Соответствие;

		Для Каждого Элемент Из Значения Цикл
			ТипЗначения = ТипЗнч(Элемент.Значение);

			Если Индексы[ТипЗначения] <> Неопределено Тогда
				Продолжить;
			КонецЕсли;

			ДоступныеТипы.Добавить(ТипЗначения);
			Индексы.Вставить(ТипЗначения, Истина);
		КонецЦикла;

		Значения.ТипЗначения = Новый ОписаниеТипов(ДоступныеТипы);
	КонецЕсли;

	Фильтр = Фильтр(КомпоновщикНастроек, СвойстваЗаголовка);

	Если ТипЗнч(Фильтр) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Фильтр, "Использование, ПравоеЗначение");

		ДоступныеВидыСравнения = Элементы.ВидСравнения.СписокВыбора;

		Если ДоступныеВидыСравнения.НайтиПоЗначению(Фильтр.ВидСравнения) <> Неопределено Тогда
			ВидСравнения = Фильтр.ВидСравнения;
		КонецЕсли;
	КонецЕсли;

	ЭтоСписок = (ТипЗнч(ПравоеЗначение) = Тип("СписокЗначений"));

	Если ЭтоСписок Тогда
		ПравоеЗначение.ТипЗначения	= Значения.ТипЗначения;
		ПравоеЗначение				= Фильтр.ПравоеЗначение;

		УточнитьПравоеЗначение(ПравоеЗначение, ДоступныеЗначения);
	Иначе
		Элементы.ПравоеЗначение.ОграничениеТипа = Значения.ТипЗначения;
	КонецЕсли;

	ПолеПравогоЗначения = Элементы.ПравоеЗначение;

	Для Каждого Элемент Из ДоступныеЗначения Цикл
		ЗаполнитьЗначенияСвойств(ПолеПравогоЗначения.СписокВыбора.Добавить(), Элемент);
	КонецЦикла;

	ПолеПравогоЗначения.РежимВыбораИзСписка	= Не ЭтоСписок И (ПолеПравогоЗначения.СписокВыбора.Количество() > 0);
	ПолеПравогоЗначения.ВыбиратьТип			= Не ЭтоСписок И ДоступныеТипы.Количество() <> 1 И Не ПолеПравогоЗначения.РежимВыбораИзСписка;

	ЭтоСтрока								= Не ЭтоСписок И ДоступныеТипы.Количество() = 1 И ДоступныеТипы.Найти(Тип("Строка")) <> Неопределено;

	Элементы.ПравоеЗначение.КнопкаВыбора	= Не ЭтоСтрока И Не ПолеПравогоЗначения.РежимВыбораИзСписка;

	ОпределитьДоступностьПоляПравогоЗначения(ПолеПравогоЗначения, ВидСравнения);
КонецПроцедуры

&НаСервере
Процедура ОпределитьДоступностьДополнительныхВозможностей()
	ДействияДополнительныхВозможностей = ДействияДополнительныхВозможностей();

	Для Каждого Действие Из ДействияДополнительныхВозможностей Цикл
		Элементы[Действие].Доступность = СвойстваЗаголовка[Действие];
	КонецЦикла;

	Элементы.ПредставлениеПоля.Доступность		= Элементы.ПереименоватьПоле.Доступность;
	Элементы.ПереименоватьПолеЕще.Доступность	= Элементы.ПереименоватьПоле.Доступность;

	СистемнаяИнформация = Новый СистемнаяИнформация;

	Если БазоваяПодсистемаКлиентСервер.ОН_СравнитьВерсии(СистемнаяИнформация.ВерсияПриложения, "8.3.16.0") >= 0 Тогда
		КартинкаВыбора = БиблиотекаКартинок["ОформлениеФлажок"];
	Иначе
		КартинкаВыбора = БиблиотекаКартинок["ЗаписатьИЗакрыть"];
	КонецЕсли;

	Элементы.ПереименоватьПолеЕще.Картинка			= КартинкаВыбора;
	Элементы.УстановитьВысотуСтрокиЕще.Картинка		= КартинкаВыбора;
	Элементы.УстановитьШиринуКолонкиЕще.Картинка	= КартинкаВыбора;
КонецПроцедуры

&НаСервере
Функция ДействияДополнительныхВозможностей()
	Действия = Новый Массив;
	Действия.Добавить("ВставитьПолеСлева");
	Действия.Добавить("ВставитьПолеСправа");
	Действия.Добавить("ВставитьГруппировкуВыше");
	Действия.Добавить("ВставитьГруппировкуНиже");

	Действия.Добавить("ПереместитьПолеВлево");
	Действия.Добавить("ПереместитьПолеВправо");
	Действия.Добавить("ПереместитьПолеВыше");
	Действия.Добавить("ПереместитьПолеНиже");

	Действия.Добавить("СортироватьПоВозрастанию");
	Действия.Добавить("СортироватьПоУбыванию");

	Действия.Добавить("СкрытьПоле");
	Действия.Добавить("ПереименоватьПоле");

	Действия.Добавить("ОформитьОтрицательные");
	Действия.Добавить("ОформитьПоложительные");
	Действия.Добавить("ОформитьЕще");

	Возврат Действия;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьЗначенияДополнительныхВозможностей()
	ПараметрыВысоты	= ВариантыОтчетовКлиент.сВО_ПараметрыРазмераПоляОтчета(ЭтотОбъект, СвойстваЗаголовка);
	ВысотаСтроки	= ПараметрыВысоты.Размер;

	ПараметрыШирины	= ВариантыОтчетовКлиент.сВО_ПараметрыРазмераПоляОтчета(ЭтотОбъект, СвойстваЗаголовка, "Ширина");
	ШиринаКолонки	= ПараметрыШирины.Размер;
КонецПроцедуры

&НаСервере
Функция НачатьЗаполнениеЗначений(ИдентификаторЗадания)
	ВыведеныВсеЗначенияРазделаОтчета					= Истина;
	Элементы.ОпцииЗаполненияФильтраПоЗначению.Видимость	= Не ВыведеныВсеЗначенияРазделаОтчета;

	Элементы.ФильтрПоЗначениюСтраницы.ТекущаяСтраница	= Элементы.Ожидание;
	Элементы.СтатусыОжидания.ТекущаяСтраница			= Элементы.ОжиданиеЗаполнения;

	Элементы.ПредставлениеДлительнойОперации.Заголовок	= СтрШаблон("Выполняется чтение строк поля: %1", ПредставлениеПоля);

	ПараметрыМетода								= БазоваяПодсистемаСервер.ДО_ПараметрыВыполненияФункции(ИдентификаторЗадания);
	ПараметрыМетода.НаименованиеФоновогоЗадания	= "Заполнение фильтра по значению";
	ПараметрыМетода.ЗапуститьВФоне				= Истина;

	РезультатЗаполнения = БазоваяПодсистемаСервер.ДО_ВыполнитьФункцию(ПараметрыМетода, "ВариантыОтчетовСлужебный.ЗаполнитьЗначенияФильтра", ПараметрыЗаполненияЗначений());

	Возврат РезультатЗаполнения;
КонецФункции

&НаКлиенте
Процедура ПриЗаполненииЗначений(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Статус = "Ошибка" Или Результат.Статус = "Выполнено" Тогда
		ПослеЗаполненияЗначений(Результат, ДополнительныеПараметры);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначения()
	ДанныеРасшифровки	= ПолучитьИзВременногоХранилища(АдресДанныхРасшифровки);
	РезультатЗаполнения	= Неопределено;

	Если ТипЗнч(СвойстваЗаголовка.Расшифровка) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
		ЗаполнитьЗначенияГруппировкиКолонки(ДанныеРасшифровки);
	Иначе
		РезультатЗаполнения = ВариантыОтчетовСервер.сВО_ЗаполнитьЗначенияФильтра(ПараметрыЗаполненияЗначений());
		РезультатЗаполнения.Удалить("Значения");
	КонецЕсли;

	ЗавершитьЗаполнениеЗначений(РезультатЗаполнения);
КонецПроцедуры

&НаСервере
Процедура ЗавершитьЗаполнениеЗначений(РезультатЗаполнения = Неопределено)
	Если РезультатЗаполнения <> Неопределено Тогда
		КоличествоСтрокВРазделеОтчета		= РезультатЗаполнения.КоличествоСтрокВРазделеОтчета;
		ВыведеныВсеЗначенияРазделаОтчета	= РезультатЗаполнения.ВыведеныВсеЗначенияРазделаОтчета;

		Если РезультатЗаполнения.Свойство("Значения") Тогда
			БазоваяПодсистемаКлиентСервер.ОН_ДополнитьТаблицу(РезультатЗаполнения.Значения, Значения);
		КонецЕсли;
	КонецЕсли;

	Фильтр = Фильтр(КомпоновщикНастроек, СвойстваЗаголовка);

	ДополнитьЗначенияДоступными();
	ДополнитьЗначенияИзКэша(Фильтр);
	УточнитьПометкиЗначений(Фильтр);

	Значения.СортироватьПоЗначению();

	ПоказатьСтатистикуЗаполненияЗначений();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаполненияЗначений(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Статус = "Ошибка" Тогда
		ОбработатьОшибкуЗаполненияЗначений(Результат.КраткоеПредставлениеОшибки, Результат.ПодробноеПредставлениеОшибки);
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		РезультатЗаполнения = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		ЗавершитьЗаполнениеЗначений(РезультатЗаполнения);

		Элементы.ФильтрПоЗначениюСтраницы.ТекущаяСтраница = Элементы.ЗначенияФильтра;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработатьОшибкуЗаполненияЗначений(КраткоеПредставлениеОшибки, ПодробноеПредставлениеОшибки)
	ШаблонКомментария = "Не удалось заполнить фильтр по значению по причине: %1";

	Элементы.СтатусыОжидания.ТекущаяСтраница	= Элементы.ОшибкаЗаполнения;
	Элементы.ОписаниеОшибкиЗаполнения.Заголовок	= СтрШаблон(ШаблонКомментария, КраткоеПредставлениеОшибки);

	Комментарий									= СтрШаблон(ШаблонКомментария, ПодробноеПредставлениеОшибки);

	ЗаписьЖурналаРегистрации("Настройка поля отчета.Заполнение фильтра по значению", УровеньЖурналаРегистрации.Ошибка,, НастройкиОтчета.ВариантСсылка, Комментарий);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЗначенияГруппировкиКолонки(ДанныеРасшифровки)
	ДоступныеТипы	= Значения.ТипЗначения;
	Индексы			= Новый Соответствие;

	Для Каждого ЭлементРасшифровки Из ДанныеРасшифровки.Элементы Цикл
		Если ТипЗнч(ЭлементРасшифровки) <> Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Или ЭлементРасшифровки.ОсновноеДействие <> ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
			Продолжить;
		КонецЕсли;

		Поля = ЭлементРасшифровки.ПолучитьПоля();

		Если Поля.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;

		Значение = Поля[0].Значение;

		Если Не ЗначениеЗаполнено(Значение) Или Индексы[Значение] <> Неопределено Или Не ДоступныеТипы.СодержитТип(ТипЗнч(Значение)) Тогда
			Продолжить;
		КонецЕсли;

		Индексы.Вставить(Значение, Истина);

		ДоступноеЗначение = ДоступныеЗначения.НайтиПоЗначению(Значение);

		Если ДоступноеЗначение = Неопределено Тогда
			Значения.Добавить(Значение,, Истина);
		Иначе
			ДоступноеЗначение.Пометка = Истина;
			ЗаполнитьЗначенияСвойств(Значения.Добавить(), ДоступноеЗначение);
		КонецЕсли;
	КонецЦикла;

	ВыведеныВсеЗначенияРазделаОтчета = Истина;
КонецПроцедуры

&НаСервере
Процедура ДополнитьЗначенияДоступными()
	Для Каждого Элемент Из ДоступныеЗначения Цикл
		Если Значения.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Значения.Добавить(), Элемент,, "Пометка");
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДополнитьЗначенияИзКэша(Фильтр)
	ЗначенияФильтра = ЗначениеФильтраИзКэша(Фильтр);

	Если ТипЗнч(ЗначенияФильтра) <> Тип("СписокЗначений") Тогда
		Возврат;
	КонецЕсли;

	Для Каждого Элемент Из ЗначенияФильтра Цикл
		Если Значения.НайтиПоЗначению(Элемент.Значение) = Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Значения.Добавить(), Элемент,, "Пометка");
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ЗначениеФильтраИзКэша(Фильтр)
	Если ТипЗнч(Фильтр) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Возврат Неопределено;
	КонецЕсли;

	КэшЗначенийОтборов = НастройкиОтчета.КэшЗначенийОтборов;

	ЗначениеФильтра = Неопределено;

	Если ЗначениеЗаполнено(Фильтр.ИдентификаторПользовательскойНастройки) Тогда
		ЗначениеФильтра = КэшЗначенийОтборов[Фильтр.ИдентификаторПользовательскойНастройки];
	КонецЕсли;

	Если ЗначениеФильтра <> Неопределено Тогда
		Возврат ВариантыОтчетовКлиентСервер.О_ЗначенияСписком(ЗначениеФильтра);
	КонецЕсли;

	ФильтрОсновныхНастроек = Неопределено;

	Если ЗначениеЗаполнено(Фильтр.ИдентификаторПользовательскойНастройки) Тогда

		НайденныеНастройки = КомпоновщикНастроек.ПользовательскиеНастройки.ПолучитьОсновныеНастройкиПоИдентификаторуПользовательскойНастройки(Фильтр.ИдентификаторПользовательскойНастройки);

		Если НайденныеНастройки.Количество() > 0 Тогда
			ФильтрОсновныхНастроек = НайденныеНастройки[0];
		КонецЕсли;
	Иначе
		ФильтрОсновныхНастроек = Фильтр;
	КонецЕсли;

	Если ТипЗнч(ФильтрОсновныхНастроек) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		ЗначениеФильтра = КэшЗначенийОтборов[ФильтрОсновныхНастроек.ЛевоеЗначение];
	КонецЕсли;

	Если ЗначениеФильтра <> Неопределено Тогда
		Возврат ВариантыОтчетовКлиентСервер.О_ЗначенияСписком(ЗначениеФильтра);
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

&НаСервере
Процедура УточнитьПометкиЗначений(Фильтр)
	Если ТипЗнч(Фильтр) <> Тип("ЭлементОтбораКомпоновкиДанных") Или Не Фильтр.Использование Тогда
		Возврат;
	КонецЕсли;

	Пометка				= Неопределено;
	ОднозначныеУсловия	= ОднозначныеУсловия();

	Если ОднозначныеУсловия.Равенства.Найти(Фильтр.ВидСравнения) <> Неопределено Тогда
		Пометка = Истина;
	ИначеЕсли ОднозначныеУсловия.Неравенства.Найти(Фильтр.ВидСравнения) <> Неопределено Тогда
		Пометка = Ложь;
	КонецЕсли;

	Если Пометка = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Значения.ЗаполнитьПометки(Не Пометка);
	ЗначениеФильтра = ВариантыОтчетовКлиентСервер.О_ЗначенияСписком(Фильтр.ПравоеЗначение);

	Для Каждого Элемент Из ЗначениеФильтра Цикл
		НайденныйЭлемент = Значения.НайтиПоЗначению(Элемент.Значение);

		Если НайденныйЭлемент <> Неопределено Тогда
			НайденныйЭлемент.Пометка = Пометка;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция ОднозначныеУсловия()
	УсловияРавенства = Новый Массив;
	УсловияРавенства.Добавить(ВидСравненияКомпоновкиДанных.Равно);
	УсловияРавенства.Добавить(ВидСравненияКомпоновкиДанных.ВИерархии);
	УсловияРавенства.Добавить(ВидСравненияКомпоновкиДанных.ВСписке);
	УсловияРавенства.Добавить(ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии);

	УсловияНеравенства = Новый Массив;
	УсловияНеравенства.Добавить(ВидСравненияКомпоновкиДанных.НеРавно);
	УсловияНеравенства.Добавить(ВидСравненияКомпоновкиДанных.НеВИерархии);
	УсловияНеравенства.Добавить(ВидСравненияКомпоновкиДанных.НеВСписке);
	УсловияНеравенства.Добавить(ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии);

	ОднозначныеУсловия = Новый Структура;
	ОднозначныеУсловия.Вставить("Равенства", УсловияРавенства);
	ОднозначныеУсловия.Вставить("Неравенства", УсловияНеравенства);

	Возврат ОднозначныеУсловия;
КонецФункции

&НаСервере
Процедура ОбновитьИндексыГруппИЭлементов()
	ИндексыГруппИЭлементов = СтандартныеИндексыГруппИЭлементов();

	Для Каждого Элемент Из Значения Цикл
		Значение = Элемент.Значение;

		Если Не ЗначениеЗаполнено(Значение) Или Не БазоваяПодсистемаСервер.ОН_ЭтоСсылка(ТипЗнч(Значение)) Тогда
			Продолжить;
		КонецЕсли;

		МетаданныеЗначения = Значение.Метаданные();

		Если Не Метаданные.Справочники.Содержит(МетаданныеЗначения) И Не Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеЗначения) Тогда
			Продолжить;
		КонецЕсли;

		СвойстваЗначения = Новый Структура("ЭтоГруппа");
		ЗаполнитьЗначенияСвойств(СвойстваЗначения, Значение);

		Если СвойстваЗначения.ЭтоГруппа = Истина Тогда
			ИндексыГруппИЭлементов.Группы.Вставить(Значение, Истина);
		Иначе
			ИндексыГруппИЭлементов.Элементы.Вставить(Значение, Истина);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция СтандартныеИндексыГруппИЭлементов()
	Индексы = Новый Структура;
	Индексы.Вставить("Группы",		Новый Соответствие);
	Индексы.Вставить("Элементы",	Новый Соответствие);

	Возврат Индексы;
КонецФункции

&НаСервере
Процедура ОпределитьВидыИерархииЗначений()
	ВидыИерархииЗначений = Новый Соответствие;

	ВидыИерархии = Метаданные.СвойстваОбъектов.ВидИерархии;
	ТипыЗначений = Значения.ТипЗначения.Типы();

	Для Каждого ТипЗначения Из ТипыЗначений Цикл
		Если Не БазоваяПодсистемаСервер.ОН_ЭтоСсылка(ТипЗначения) Тогда
			Продолжить;
		КонецЕсли;

		МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗначения);

		Если Не Метаданные.Справочники.Содержит(МетаданныеОбъекта) И Не Метаданные.ПланыВидовХарактеристик.Содержит(МетаданныеОбъекта) Тогда
			Продолжить;
		КонецЕсли;

		Если МетаданныеОбъекта.ВидИерархии = ВидыИерархии.ИерархияГруппИЭлементов Тогда
			ВидИерархии = ВидИерархииИерархияГруппИЭлементов();
		Иначе
			ВидИерархии = ВидИерархииИерархияЭлементов();
		КонецЕсли;

		ВидыИерархииЗначений.Вставить(ТипЗначения, ВидИерархии);
	КонецЦикла;

	НастройкиОтчета.Вставить("ВидыИерархииЗначений", ВидыИерархииЗначений);
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ВидИерархииИерархияГруппИЭлементов()
	Возврат "ИерархияГруппИЭлементов";
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ВидИерархииИерархияЭлементов()
	Возврат "ИерархияЭлементов";
КонецФункции

&НаСервере
Функция ПараметрыЗаполненияЗначений()
	Значения.Очистить();

	СвойстваРезультата = НастройкиОтчета.СвойстваРезультата; // см. ВариантыОтчетовСлужебный.СвойстваРезультатаОтчета
	ГраницаРаздела = СвойстваРезультата.ГраницыРазделов[СвойстваЗаголовка.ПорядокРаздела - 1].Значение;

	ДанныеРасшифровки = ПолучитьИзВременногоХранилища(АдресДанныхРасшифровки);

	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Значения",							Значения);
	ПараметрыЗаполнения.Вставить("СвойстваЗаголовка",					СвойстваЗаголовка);
	ПараметрыЗаполнения.Вставить("Документ",							Документ);
	ПараметрыЗаполнения.Вставить("Заголовки",							СвойстваРезультата.Заголовки);
	ПараметрыЗаполнения.Вставить("ГраницаРаздела",						ГраницаРаздела);
	ПараметрыЗаполнения.Вставить("ДанныеРасшифровки",					ДанныеРасшифровки);
	ПараметрыЗаполнения.Вставить("ДоступныеЗначения",					ДоступныеЗначения);
	ПараметрыЗаполнения.Вставить("КоличествоПервыхЧитаемыхСтрок",		КоличествоПервыхЧитаемыхСтрок);
	ПараметрыЗаполнения.Вставить("ВыведеныВсеЗначенияРазделаОтчета",	ВыведеныВсеЗначенияРазделаОтчета);

	Возврат ПараметрыЗаполнения;
КонецФункции

&НаКлиенте
Процедура ПослеВыбораПоля(ВыбранноеПоле, ДополнительныеПараметры) Экспорт
	ВариантыОтчетовКлиент.сВО_ПослеВыбораПоля(ВыбранноеПоле, ДополнительныеПараметры);

	Если ТипЗнч(ВыбранноеПоле) = Тип("ДоступноеПолеКомпоновкиДанных") Тогда
		ОповеститьОВыборе(КомпоновщикНастроек.Настройки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьНастройки(Команда)
	Отказ = Ложь;

	Если СнятьФильтрПоУсловию Тогда
		ВариантыОтчетовКлиент.сВО_СнятьФильтр(ЭтотОбъект, СвойстваЗаголовка);
	Иначе
		ПрименитьФильтр(Отказ);
	КонецЕсли;

	Результат = ВариантыОтчетовКлиент.сВО_СтандартныйРезультатНастройкиИзКонтекстногоМеню(КомпоновщикНастроек, Команда.Действие, ВладелецФормы.УникальныйИдентификатор);

	Если Команда.Имя = Элементы.Фильтровать.ИмяКоманды Тогда
		Результат.УчитыватьВремяФормирования = Ложь;
	КонецЕсли;

	Если Не Отказ Тогда
		ОповеститьОВыборе(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьФильтр(Отказ)
	Фильтр = Фильтр(КомпоновщикНастроек, СвойстваЗаголовка);

	Если ТипЗнч(Фильтр) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Фильтры					= ВариантыОтчетовКлиентСервер.сВО_ФильтрыРазделаОтчета(КомпоновщикНастроек.Настройки, СвойстваЗаголовка);

		Фильтр					= Фильтры.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Фильтр.ЛевоеЗначение	= СвойстваЗаголовка.Поле;
	КонецЕсли;

	Фильтр.Использование = Истина;

	Если Использование Тогда
		Фильтр.ВидСравнения		= ВидСравнения;
		Фильтр.ПравоеЗначение	= ПравоеЗначение;

		ВариантыОтчетовКлиент.О_КэшироватьЗначениеОтбора(КомпоновщикНастроек, Фильтр, Значения);

		Возврат;
	КонецЕсли;

	СписокПомеченных	= Новый СписокЗначений;
	СписокНепомеченных	= Новый СписокЗначений;

	Для Каждого Элемент Из Значения Цикл
		Если Элемент.Пометка Тогда
			ЗаполнитьЗначенияСвойств(СписокПомеченных.Добавить(), Элемент);
		Иначе
			ЗаполнитьЗначенияСвойств(СписокНепомеченных.Добавить(), Элемент);
		КонецЕсли;
	КонецЦикла;

	Если СписокНепомеченных.Количество() = 0 Тогда
		НастройкиОтчета.СвойстваРезультата.ИтоговыеНастройки = КомпоновщикНастроек.Настройки;
		ВариантыОтчетовКлиент.сВО_СнятьФильтр(ЭтотОбъект, СвойстваЗаголовка);
		Фильтр = Неопределено;
	ИначеЕсли СписокПомеченных.Количество() = 1 Тогда
		Фильтр.ВидСравнения		= ВидСравненияКомпоновкиДанных.Равно;
		Фильтр.ПравоеЗначение	= СписокПомеченных[0].Значение;
	ИначеЕсли СписокНепомеченных.Количество() = 1 Тогда
		Фильтр.ВидСравнения		= ВидСравненияКомпоновкиДанных.НеРавно;
		Фильтр.ПравоеЗначение	= СписокНепомеченных[0].Значение;
	ИначеЕсли СписокПомеченных.Количество() = 0 Или СписокПомеченных.Количество() > СписокНепомеченных.Количество() Тогда
		Фильтр.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		Фильтр.ПравоеЗначение = СписокНепомеченных;
	Иначе
		Фильтр.ВидСравнения		= ВидСравненияКомпоновкиДанных.ВСписке;
		Фильтр.ПравоеЗначение	= СписокПомеченных;
	КонецЕсли;

	Если ТипЗнч(Фильтр) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;

	УточнитьУсловиеФильтра(Фильтр, Отказ);
	ВариантыОтчетовКлиент.О_КэшироватьЗначениеОтбора(КомпоновщикНастроек, Фильтр, Значения);
КонецПроцедуры

&НаКлиенте
Процедура УточнитьУсловиеФильтра(Фильтр, Отказ)
	ИспользуютсяГруппы		= Ложь;
	ИспользуютсяЭлементы	= Ложь;

	ЗначенияФильтра = ВариантыОтчетовКлиентСервер.О_ЗначенияСписком(Фильтр.ПравоеЗначение, Истина);

	Если ЗначенияФильтра.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ПроверитьИспользованиеГруппИЭлементов(ЗначенияФильтра, ИспользуютсяГруппы, ИспользуютсяЭлементы);

	Если Не ИспользуютсяГруппы И Не ИспользуютсяЭлементы Тогда
		Возврат;
	КонецЕсли;

	Если Не ИспользуютсяГруппы И ИспользуютсяЭлементы Тогда
		Возврат;
	КонецЕсли;

	Если ИспользуютсяГруппы И ИспользуютсяЭлементы Тогда
		Отказ = Истина;

		ТекстПредупреждения = "В списке выбраны группы и элементы.
			|Необходимо выбрать только группы или только элементы.";

		ПоказатьПредупреждение(, ТекстПредупреждения);

		Возврат;
	КонецЕсли;

	Если Фильтр.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
		Фильтр.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии;
	ИначеЕсли Фильтр.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
		Фильтр.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии;
	Иначе
		Фильтр.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура  ПроверитьИспользованиеГруппИЭлементов(ЗначенияФильтра, ИспользуютсяГруппы, ИспользуютсяЭлементы)
	Если ИндексыГруппИЭлементов.Группы.Количество() = 0 И ИндексыГруппИЭлементов.Элементы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ТипГруппировкиПоля		= ТипГруппировкиПоля();
	ВидыИерархииЗначений	= НастройкиОтчета.ВидыИерархииЗначений;

	Для Каждого Элемент Из ЗначенияФильтра Цикл
		Если ИндексыГруппИЭлементов.Группы[Элемент.Значение] = Истина
			Или (ИндексыГруппИЭлементов.Элементы[Элемент.Значение] = Истина
				И ТипГруппировкиПоля <> ТипГруппировкиКомпоновкиДанных.Элементы
				И ВидыИерархииЗначений[ТипЗнч(Элемент.Значение)] = ВидИерархииИерархияЭлементов()) Тогда

			ИспользуютсяГруппы = Истина;

		ИначеЕсли ИндексыГруппИЭлементов.Элементы[Элемент.Значение] = Истина Тогда
			ИспользуютсяЭлементы = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ТипГруппировкиПоля()
	ТипГруппировкиПоля = ТипГруппировкиКомпоновкиДанных.Элементы;
	ТекущаяГруппировка = КомпоновщикНастроек.Настройки.ПолучитьОбъектПоИдентификатору(СвойстваЗаголовка.ИдентификаторГруппировки);

	Если ТипЗнч(ТекущаяГруппировка) <> Тип("ГруппировкаКомпоновкиДанных") И ТипЗнч(ТекущаяГруппировка) <> Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		Возврат ТипГруппировкиПоля;
	КонецЕсли;

	ПолеГруппировки = ВариантыОтчетовКлиентСервер.сВО_ПолеОтчета(ТекущаяГруппировка.ПоляГруппировки, СвойстваЗаголовка.Поле);

	Если ПолеГруппировки = Неопределено Тогда
		Возврат ТипГруппировкиПоля;
	КонецЕсли;

	Возврат ПолеГруппировки.ТипГруппировки;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция Фильтр(КомпоновщикНастроек, СвойстваЗаголовка, Фильтры = Неопределено)
	Если Фильтры = Неопределено Тогда
		Фильтры = ВариантыОтчетовКлиентСервер.сВО_ФильтрыРазделаОтчета(КомпоновщикНастроек.Настройки, СвойстваЗаголовка);
	КонецЕсли;

	Возврат ВариантыОтчетовКлиентСервер.сВО_ФильтрРазделаОтчета(Фильтры, СвойстваЗаголовка.Поле);
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеФильтра(КомпоновщикНастроек, СвойстваЗаголовка)
	ОписаниеФильтра = Неопределено;

	Если СвойстваЗаголовка.Поле <> Неопределено Тогда
		ОписаниеФильтра = КомпоновщикНастроек.Настройки.ДоступныеПоляОтбора.НайтиПоле(СвойстваЗаголовка.Поле);
	КонецЕсли;

	Возврат ОписаниеФильтра;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УточнитьПравоеЗначение(ПравоеЗначение, ДоступныеЗначения)
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

&НаКлиентеНаСервереБезКонтекста
Процедура ОпределитьДоступностьПоляПравогоЗначения(Поле, ВидСравнения)
	Поле.Доступность = ВидСравнения <> ВидСравненияКомпоновкиДанных.Заполнено И ВидСравнения <> ВидСравненияКомпоновкиДанных.НеЗаполнено;
КонецПроцедуры

&НаСервере
Процедура ПоказатьСтатистикуЗаполненияЗначений()
	Если ВыведеныВсеЗначенияРазделаОтчета Тогда
		Элементы.ОпцииЗаполненияФильтраПоЗначению.Видимость = Не ВыведеныВсеЗначенияРазделаОтчета;

		Возврат;
	КонецЕсли;

	Элементы.СтатистикаФильтраПоЗначению.Заголовок = СтрШаблон("Выведено %1 первых значений.", Значения.Количество());

	Элементы.ВывестиВсеЗначенияРазделаОтчета.РасширеннаяПодсказка.Заголовок = СтрШаблон("Выведено %1 уникальных значений из первых %2 строк отчета. Всего строк в разделе отчета - %3.", Значения.Количество(), КоличествоПервыхЧитаемыхСтрок, КоличествоСтрокВРазделеОтчета);
КонецПроцедуры
