///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьУсловноеОформление();

	Если Параметры.Свойство("ТолькоПросмотр") Тогда
		Элементы.История.ТолькоПросмотр = Параметры.ТолькоПросмотр;
	КонецЕсли;

	ВидКонтактнойИнформации				= Параметры.ВидКонтактнойИнформации;
	ТипКонтактнойИнформации				= Параметры.ВидКонтактнойИнформации.Тип;
	ПроверятьКорректность				= ВидКонтактнойИнформации.ПроверятьКорректность;
	ПредставлениеКонтактнойИнформации	= Параметры.ВидКонтактнойИнформации.Наименование;

	Если ТипЗнч(Параметры.СписокКонтактнойИнформации) = Тип("Массив") Тогда
		Для каждого СтрокаКонтактнойИнформации Из Параметры.СписокКонтактнойИнформации Цикл
			СтрокаТаблицы		= История.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицы, СтрокаКонтактнойИнформации);
			СтрокаТаблицы.Тип	= ТипКонтактнойИнформации;
			СтрокаТаблицы.Вид	= ВидКонтактнойИнформации;
		КонецЦикла;
		ЭтотОбъект.Заголовок					= СтрШаблон("История изменений (%1)", ПредставлениеКонтактнойИнформации);
		Элементы.ИсторияПредставление.Заголовок	= ПредставлениеКонтактнойИнформации;
	Иначе
		Отказ = Истина;
	КонецЕсли;
	РедактированиеТолькоВДиалоге = ВидКонтактнойИнформации.ВидРедактирования = "Диалог";
	Если ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
		ИмяФормыРедактирования						= "ВводАдреса";
	ИначеЕсли ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
		ИмяФормыРедактирования						= "ВводТелефона";
	Иначе
		ИмяФормыРедактирования						= "";
		Элементы.ИсторияПредставление.КнопкаВыбора	= Ложь;
	КонецЕсли;

	История.Сортировать("ДействуетС Убыв");

	Если Параметры.Свойство("ИзФормыВводаАдреса") И Параметры.ИзФормыВводаАдреса Тогда
		Элементы.ИсторияВыбрать.КнопкаПоУмолчанию		= Истина;
		РежимВыбора										= Параметры.ИзФормыВводаАдреса;
		Элементы.ГруппаКоманднаяПанель.Видимость		= Ложь;
		Элементы.ИсторияВыбрать.Видимость				= Истина;
		Элементы.ИсторияИзменить.Видимость				= Ложь;
		Элементы.ИсторияПредставление.ТолькоПросмотр	= Истина;
		Если Параметры.Свойство("ДействуетС") Тогда
			ДатаПриОткрытие	= Параметры.ДействуетС;
			Отбор			= Новый Структура("ДействуетС", ДатаПриОткрытие);
			НайденныеСтроки	= История.НайтиСтроки(Отбор);
			Если НайденныеСтроки.Количество() > 0 Тогда
				Элементы.История.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если БазоваяПодсистемаСервер.ОН_ЭтоМобильныйКлиент() Тогда
		Элементы.Переместить(Элементы.ОК, Элементы.ФормаКоманднаяПанель);
		Элементы.Отмена.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПредставлениеПриИзменении(Элемент)
	ЭтотОбъект.ТекущийЭлемент.ТекущиеДанные.ЗначенияПолей = КонтактнаяИнформацияXMLПоПредставлению(ЭтотОбъект.ТекущийЭлемент.ТекущиеДанные.Представление, ВидКонтактнойИнформации);
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПередУдалением(Элемент, Отказ)
	// Если есть хотя бы одна запись старше удаляемой, то удалять можно.
	ДействуетС = Элемент.ТекущиеДанные.ДействуетС;
	Если ЭтоПерваяДата(ДействуетС) Тогда
		Отказ = Истина;
	КонецЕсли;
	Если НЕ Отказ Тогда
		ДополнительныеПараметры	= Новый Структура("ИдентификаторСтроки", Элемент.ТекущаяСтрока);
		Оповещение				= Новый ОписаниеОповещения("ПослеОтветаНаВопросПроУдаление", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, "Удалить адрес действующий с " + Формат(ДействуетС, "ДЛФ=DD")+ "?", РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	Если РежимВыбора Тогда
		СформироватьДанные(Истина);
	Иначе
		ОткрытьФормуРедактированияАдреса(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущийЭлемент.Имя = "ИсторияДействуетС" Тогда
		Если ЭтоПерваяДата(Элемент.ТекущиеДанные.ДействуетС) Тогда
			Отказ = Истина;
		КонецЕсли;
		ПредыдущаяДата = Элемент.ТекущиеДанные.ДействуетС;
	Иначе
		ОткрытьФормуРедактированияАдреса(Элементы.История.ТекущаяСтрока);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПриИзменении(Элемент)
	Если Элемент.ТекущийЭлемент.Имя = "ИсторияДействуетС" Тогда
		Индекс												= История.Индекс(ЭтотОбъект.ТекущийЭлемент.ТекущиеДанные);
		ЭтотОбъект.ТекущийЭлемент.ТекущиеДанные.ДействуетС	= ДопустимаяДатаИстории(ПредыдущаяДата, ЭтотОбъект.ТекущийЭлемент.ТекущиеДанные.ДействуетС, Индекс);
		История.Сортировать("ДействуетС Убыв");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияАдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если РежимВыбора Тогда
		СформироватьДанные();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Элементы.ИсторияИзменить.Доступность				= НЕ ЭтоПерваяДата(Элемент.ТекущиеДанные.ДействуетС) И НЕ ЭтотОбъект.ТолькоПросмотр;
		Элементы.ИсторияУдалить.Доступность					= НЕ ЭтоПерваяДата(Элемент.ТекущиеДанные.ДействуетС) И НЕ ЭтотОбъект.ТолькоПросмотр;
		Элементы.ИсторияКонтекстноеМенюИзменить.Доступность	= НЕ ЭтоПерваяДата(Элемент.ТекущиеДанные.ДействуетС) И НЕ ЭтотОбъект.ТолькоПросмотр;
		Элементы.ИсторияКонтекстноеМенюУдалить.Доступность	= НЕ ЭтоПерваяДата(Элемент.ТекущиеДанные.ДействуетС) И НЕ ЭтотОбъект.ТолькоПросмотр;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если РежимВыбора Тогда
		СформироватьДанные();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИсторияДействуетСПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	СформироватьДанные();
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ЗакрытиеФормыБезСохранения = Истина;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	СформироватьДанные();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьДанные(ВводНовогоАдреса = Ложь)
	ЗакрытиеФормыБезСохранения	= Истина;
	Результат					= Новый Структура;

	ВариантыДат					= Новый Соответствие;
	ОтсутствуетНачальнаяДата	= Истина;
	ДействующийАдрес			= 0;
	МинимальнаяДельта			= Неопределено;
	ТекущаяДатаПроверки			= БазоваяПодсистемаКлиент.ОН_ДатаСеанса();
	Для Индекс = 0 По История.Количество() - 1 Цикл
		Если НЕ ЗначениеЗаполнено(История[Индекс].ДействуетС) Тогда
			ОтсутствуетНачальнаяДата = Ложь;
		КонецЕсли;
		Если ВариантыДат[История[Индекс].ДействуетС] = Неопределено Тогда
			ВариантыДат.Вставить(История[Индекс].ДействуетС, Истина);
		Иначе
			БазоваяПодсистемаКлиентСервер.сОН_СообщитьПользователю("Не допускается ввод адресов с одинаковыми датами.",, "История[" + Формат(Индекс, "ЧГ=0") + "].ДействуетС", "", Ложь);

			Возврат;
		КонецЕсли;
		Дельта = История[Индекс].ДействуетС - ТекущаяДатаПроверки;
		Если Дельта < 0 И (МинимальнаяДельта = Неопределено ИЛИ Дельта > МинимальнаяДельта) Тогда
			МинимальнаяДельта	= Дельта;
			ДействующийАдрес	= Индекс;
		КонецЕсли;
		История[Индекс].ЭтоИсторическаяКонтактнаяИнформация = Истина;
		История[Индекс].ХранитьИсториюИзменений             = Истина;
	КонецЦикла;

	История[ДействующийАдрес].ЭтоИсторическаяКонтактнаяИнформация = Ложь;

	Если НЕ ВводНовогоАдреса И ОтсутствуетНачальнаяДата Тогда
		ПоказатьПредупреждение(, "Отсутствует адрес, действующий с даты начала ведения учета.");

		Возврат;
	КонецЕсли;

	Результат.Вставить("История",						История);
	Результат.Вставить("РедактированиеТолькоВДиалоге",	РедактированиеТолькоВДиалоге);
	Результат.Вставить("Модифицированность",			Модифицированность);
	Если РежимВыбора Тогда
		Результат.Вставить("ВводНовогоАдреса", ВводНовогоАдреса);
		Если ВводНовогоАдреса Тогда
			Результат.Вставить("ТекущийАдрес", БазоваяПодсистемаКлиент.ОН_ДатаСеанса());
		Иначе
			Результат.Вставить("ТекущийАдрес", Элементы.История.ТекущиеДанные.ДействуетС);
		КонецЕсли;
	КонецЕсли;

	Закрыть(Результат);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияАдреса(Знач ВыбраннаяСтрока)
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации",	ВидКонтактнойИнформации);
	ПараметрыОткрытия.Вставить("ИзФормыИстории",			Истина);
	ПараметрыОткрытия.Вставить("ТолькоПросмотр",			Элементы.История.ТолькоПросмотр);
	Если ВыбраннаяСтрока = Неопределено Тогда
		Если История.Количество() = 1 И ПустаяСтрока(История[0].Представление) Тогда
			ПараметрыОткрытия.Вставить("ДействуетС", Дата(1, 1, 1));
		Иначе
			ПараметрыОткрытия.Вставить("ДействуетС", БазоваяПодсистемаКлиент.ОН_ДатаСеанса());
		КонецЕсли;
		ПараметрыОткрытия.Вставить("ВводНовогоАдреса", Истина);
		ДополнительныеПараметры = Новый Структура("Новый", Истина);
	Иначе
		ДанныеСтроки = История.НайтиПоИдентификатору(ВыбраннаяСтрока);
		ПараметрыОткрытия.Вставить("ЗначенияПолей", ДанныеСтроки.ЗначенияПолей);
		ПараметрыОткрытия.Вставить("Значение",      ДанныеСтроки.Значение);
		ПараметрыОткрытия.Вставить("Представление", ДанныеСтроки.Представление);
		ПараметрыОткрытия.Вставить("ДействуетС",    ДанныеСтроки.ДействуетС);
		ПараметрыОткрытия.Вставить("Комментарий",   ДанныеСтроки.Комментарий);
		ДополнительныеПараметры = Новый Структура("ДействуетС, Новый", ДанныеСтроки.ДействуетС, НЕ ЗначениеЗаполнено(ДанныеСтроки.ЗначенияПолей));
	КонецЕсли;

	Оповещение = Новый ОписаниеОповещения("ПослеРедактированияАдреса", ЭтотОбъект, ДополнительныеПараметры);
	КонтактнаяИнформацияКлиент.УКИ_ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия,, Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросПроУдаление(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		История.Удалить(История.НайтиПоИдентификатору(ДополнительныеПараметры.ИдентификаторСтроки));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента		= Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле	= Новый ПолеКомпоновкиДанных(Элементы.ИсторияДействуетС.Имя);

	ОтборЭлемента				= Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение	= Новый ПолеКомпоновкиДанных("История.ДействуетС");
	ОтборЭлемента.ВидСравнения	= ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста",		ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр",	Истина);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",				"Начальное значение");
КонецПроцедуры

&НаКлиенте
Функция ДопустимаяДатаИстории(СтараяДата, НоваяДата, Индекс)
	Отбор = Новый Структура("ДействуетС", НоваяДата);
	НайденныеСтроки = История.НайтиСтроки(Отбор);
	Если НайденныеСтроки.Количество() > 1 Тогда
		БазоваяПодсистемаКлиентСервер.сОН_СообщитьПользователю("Не допускается ввод адресов с одинаковыми датами.",, "История[" + Формат(Индекс, "ЧГ=0") + "].ДействуетС", "", Ложь);
		Если ЗначениеЗаполнено(СтараяДата) Тогда
			Возврат СтараяДата;
		Иначе
			Возврат БазоваяПодсистемаКлиент.ОН_ДатаСеанса();
		КонецЕсли;
	КонецЕсли;

	Возврат НоваяДата;
КонецФункции

&НаКлиенте
Процедура ПослеРедактированияАдреса(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;

	Если ДополнительныеПараметры.Новый Тогда
		ДействуетС		= РезультатЗакрытия.ДействуетС;
		Отбор			= Новый Структура("ДействуетС", ДействуетС);
		НайденныеСтроки	= История.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Строка = НайденныеСтроки[0];
		Иначе
			Строка = История.Вставить(0);
		КонецЕсли;

		Строка.ДействуетС				= РезультатЗакрытия.ДействуетС;
		Строка.ЗначенияПолей			= РезультатЗакрытия.КонтактнаяИнформация;
		Строка.Значение					= РезультатЗакрытия.Значение;
		Строка.Представление			= РезультатЗакрытия.Представление;
		Строка.Комментарий				= РезультатЗакрытия.Комментарий;
		Строка.Вид						= РезультатЗакрытия.Вид;
		Строка.Тип						= РезультатЗакрытия.Тип;
		Строка.ХранитьИсториюИзменений	= Истина;
		Элементы.История.ТекущаяСтрока	= Строка.ПолучитьИдентификатор();;
		Элементы.История.ТекущийЭлемент	= Элементы.История.ПодчиненныеЭлементы.ИсторияПредставление;
		История.Сортировать("ДействуетС Убыв");
	Иначе
		ДействуетС		= ДополнительныеПараметры.ДействуетС;
		Отбор			= Новый Структура("ДействуетС", ДействуетС);
		НайденныеСтроки	= История.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].Представление	= РезультатЗакрытия.Представление;
			НайденныеСтроки[0].ЗначенияПолей	= РезультатЗакрытия.КонтактнаяИнформация;
			НайденныеСтроки[0].Комментарий		= РезультатЗакрытия.Комментарий;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ЭтоПерваяДата(ДействуетС)
	Для каждого СтрокаИстории Из История Цикл
		Если СтрокаИстории.ДействуетС < ДействуетС Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;

	Возврат Истина;
КонецФункции

&НаСервере
Функция КонтактнаяИнформацияXMLПоПредставлению(Текст, ВидКонтактнойИнформации)
	Возврат КонтактнаяИнформацияСервер.сУКИ_СтруктураВСтрокуJSON(КонтактнаяИнформацияСервер.сУКИ_КонтактнаяИнформацияПоПредставлению(Текст, ВидКонтактнойИнформации));
КонецФункции
