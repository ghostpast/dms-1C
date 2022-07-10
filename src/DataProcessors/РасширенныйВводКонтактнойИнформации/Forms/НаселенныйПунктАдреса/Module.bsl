///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("НаселенныйПунктДетально", НаселенныйПунктДетально);
	ИспользоватьАвтоподбор = Истина;
	Если НаселенныйПунктДетально <> Неопределено Тогда
		ТипАдреса = НаселенныйПунктДетально.AddressType;
		Если НаселенныйПунктДетально.Свойство("Country") И СтрСравнить(ПредопределенноеЗначение("Справочник.СтраныМира.Россия"), НаселенныйПунктДетально.Country) = 0 Тогда
			МуниципальныйРайон   = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "MunDistrict");
			Поселение            = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Settlement");
			ВнутригородскойРайон = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "CityDistrict");
			Территория           = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Territory");

			// Зарезервировано для новых подсистем

			ИсключатьГородИзМуниципальногоАдреса = Ложь;
		Иначе
			ИспользоватьАвтоподбор = Ложь;
		КонецЕсли;

		Регион               = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Area");
		Район                = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "District");
		НаселенныйПункт      = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Locality");
		Если СтрСравнить(ТипАдреса, "Муниципальный") = 0 Тогда
			Если Не ИсключатьГородИзМуниципальногоАдреса Тогда
				Город = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "City");
			Иначе
				Город = "";
			КонецЕсли;
		Иначе
			Город            = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "City");
		КонецЕсли;
	Иначе
		ТипАдреса				= "Муниципальный";
		НаселенныйПунктДетально	= КонтактнаяИнформацияКлиентСервер.РСА_ОписаниеНовойКонтактнойИнформации(Перечисления.ТипыКонтактнойИнформации.Адрес);
	КонецЕсли;

	ЕстьПравоЗагружатьКлассификатор = Обработки.РасширенныйВводКонтактнойИнформации.ЕстьВозможностьИзмененияАдресногоКлассификатора();
	СведенияОАдресномКлассификаторе = КонтактнаяИнформацияСерверПовтИсп.сУКИ_СведенияОДоступностиАдресногоКлассификатора();
	КлассификаторДоступен           = СведенияОАдресномКлассификаторе.Получить("КлассификаторДоступен");

	Если Не Параметры.ОтображатьКнопкиВыбора Тогда
		ОтключитьКнопкиВыбораУЧастейАдреса();
	КонецЕсли;

	Если БазоваяПодсистемаСервер.ОН_ЭтоМобильныйКлиент() Тогда
		ПоложениеКоманднойПанели			= ПоложениеКоманднойПанелиФормы.Авто;
		Элементы.ФормаКомандаОК.Отображение	= ОтображениеКнопки.Картинка;
		Элементы.ФормаСправка.Видимость		= Ложь;
		Элементы.ФормаОтмена.Видимость		= Ложь;
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметры.ТипАдреса) Тогда
		Элементы.ТипАдреса.Видимость = Ложь;
		ТипАдреса = Параметры.ТипАдреса;
	КонецЕсли;

	Элементы.ВнутригородскойРайон.Видимость = ЗначениеЗаполнено(ВнутригородскойРайон);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОтобразитьПоляПоТипуАдреса();
КонецПроцедуры

&НаСервере
Процедура ОтключитьКнопкиВыбораУЧастейАдреса()
	Элементы.СубъектРФ.КнопкаВыбора				= Ложь;
	Элементы.Район.КнопкаВыбора					= Ложь;
	Элементы.МуниципальныйРайон.КнопкаВыбора	= Ложь;
	Элементы.Город.КнопкаВыбора					= Ложь;
	Элементы.Поселение.КнопкаВыбора				= Ложь;
	Элементы.ВнутригородскойРайон.КнопкаВыбора	= Ложь;
	Элементы.НаселенныйПункт.КнопкаВыбора		= Ложь;
	Элементы.Территория.КнопкаВыбора			= Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТипАдресаПриИзменении(Элемент)
	НаселенныйПунктДетально.AddressType = ?(ТипАдреса = "Муниципальный", "Муниципальный", "Административно-территориальный");
	ОтобразитьПоляПоТипуАдреса();
	ОпределитьПоляАдреса();
КонецПроцедуры

&НаКлиенте
Процедура СубъектРФАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "Area", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РайонАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "District", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МуниципальныйРайонАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "MunDistrict", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГородАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "City", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПоселениеАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "Settlement", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВнутригородскойРайонАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "CityDistrict", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "Locality", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	АвтоПодборПоУровню(Текст, ДанныеВыбора, "Territory", СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СубъектРФНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РайонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МуниципальныйРайонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПоселениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГородНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВнутригородскойРайонНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СубъектРФОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура РайонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура МуниципальныйРайонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ГородОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ПоселениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ВнутригородскойРайонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура СубъектРФПриИзменении(Элемент)
	ИзменитьУровеньАдреса("Area", Регион);
КонецПроцедуры

&НаКлиенте
Процедура РайонПриИзменении(Элемент)
	ИзменитьУровеньАдреса("District", Район);
КонецПроцедуры

&НаКлиенте
Процедура МуниципальныйРайонПриИзменении(Элемент)
	ИзменитьУровеньАдреса("MunDistrict", МуниципальныйРайон);
КонецПроцедуры

&НаКлиенте
Процедура ГородПриИзменении(Элемент)
	ИзменитьУровеньАдреса("City", Город);
КонецПроцедуры

&НаКлиенте
Процедура ПоселениеПриИзменении(Элемент)
	ИзменитьУровеньАдреса("Settlement", Поселение);
КонецПроцедуры

&НаКлиенте
Процедура ВнутригородскойРайонПриИзменении(Элемент)
	ИзменитьУровеньАдреса("CityDistrict", ВнутригородскойРайон);
КонецПроцедуры

&НаКлиенте
Процедура НаселенныйПунктПриИзменении(Элемент)
	ИзменитьУровеньАдреса("Locality", НаселенныйПункт);
КонецПроцедуры

&НаКлиенте
Процедура ТерриторияПриИзменении(Элемент)
	ИзменитьУровеньАдреса("Territory", Территория);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	Если Модифицированность Тогда
		Закрыть(ВозвращаемыеДанныеОбАдресе());
	Иначе
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ИмяУровняПоНазваниюЭлемента(ИмяЭлемента)
	ИменаУровней = Новый Соответствие;
	ИменаУровней.Вставить("СубъектРФ",				"Area");
	ИменаУровней.Вставить("Район",					"District");
	ИменаУровней.Вставить("МуниципальныйРайон",		"MunDistrict");
	ИменаУровней.Вставить("Город",					"City");
	ИменаУровней.Вставить("Поселение",				"Settlement");
	ИменаУровней.Вставить("ВнутригородскойРайон",	"CityDistrict");
	ИменаУровней.Вставить("НаселенныйПункт",		"Locality");
	ИменаУровней.Вставить("Территория",				"Territory");

	Возврат ИменаУровней[ИмяЭлемента];
КонецФункции

&НаКлиенте
Функция ВозвращаемыеДанныеОбАдресе()
	Результат										= КонтактнаяИнформацияКлиентСервер.РСА_ВозвращаемыеДанныеОбАдресе();

	Результат.НаселенныйПунктДетально				= НаселенныйПунктДетально;
	Результат.ИсключатьГородИзМуниципальногоАдреса	= ИсключатьГородИзМуниципальногоАдреса;

	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораАдресныхОбъектов(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	ИмяУровня = ИмяУровняПоНазваниюЭлемента(Элемент.Имя);

	РодительскийИдентификатор	= ИдентификаторРодителяУровняАдреса(ИмяУровня, НаселенныйПунктДетально, ТипАдреса);
	Уровень						= КонтактнаяИнформацияКлиентСервер.РСА_СопоставлениеНаименованиеУровнюАдреса(ИмяУровня);

	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТипАдреса", ТипАдреса);
	ПараметрыОткрытия.Вставить("Уровень",   Уровень);
	ПараметрыОткрытия.Вставить("Родитель",  РодительскийИдентификатор);

	ОткрытьФорму("Обработка.РасширенныйВводКонтактнойИнформации.Форма.ВыборАдресаПоУровню", ПараметрыОткрытия, Элемент);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьПоляАдреса()
	Регион               = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Area");
	Район                = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "District");
	МуниципальныйРайон   = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "MunDistrict");

	Если ИсключатьГородИзМуниципальногоАдреса И СтрСравнить(ТипАдреса, "Муниципальный") = 0 Тогда
		Город            = "";
	Иначе
		Город            = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "City");
	КонецЕсли;

	Поселение            = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Settlement");
	ВнутригородскойРайон = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "CityDistrict");
	НаселенныйПункт      = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Locality");
	Территория           = ПредставлениеУровняАдреса(НаселенныйПунктДетально, "Territory")
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеУровняАдреса(Адрес, ИмяУровня)
	Если Адрес.Свойство(ИмяУровня) И ЗначениеЗаполнено(Адрес[ИмяУровня]) Тогда
		Возврат КонтактнаяИнформацияКлиентСервер.УКИ_СоединитьНаименованиеИТипАдресногоОбъекта(
			Адрес[ИмяУровня], Адрес[ИмяУровня +"Type"], СтрСравнить(ИмяУровня, "Area") = 0);
	КонецЕсли;

	Возврат "";
КонецФункции

&НаКлиенте
Процедура ОтобразитьПоляПоТипуАдреса()
	Если СтрСравнить("ЕАЭС", ТипАдреса) <> 0 Тогда
		ЭтоМуниципальныйАдрес					= СтрСравнить("Муниципальный", ТипАдреса) = 0;
		Элементы.Район.Видимость				= НЕ ЭтоМуниципальныйАдрес;
		Элементы.МуниципальныйРайон.Видимость	= ЭтоМуниципальныйАдрес;
		Элементы.Поселение.Видимость			= ЭтоМуниципальныйАдрес;
	Иначе
		Элементы.ТипАдреса.Видимость            = Ложь;
		Элементы.МуниципальныйРайон.Видимость   = Ложь;
		Элементы.Поселение.Видимость            = Ложь;
		Элементы.ВнутригородскойРайон.Видимость = Ложь;
		Элементы.Территория.Видимость           = Ложь;
		Элементы.СубъектРФ.Заголовок            = "Регион";
		Элементы.СубъектРФ.КнопкаВыбора         = Ложь;
		Элементы.Район.КнопкаВыбора             = Ложь;
		Элементы.Город.КнопкаВыбора             = Ложь;
		Элементы.НаселенныйПункт.КнопкаВыбора   = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура АвтоПодборПоУровню( Знач Текст, ДанныеВыбора, ИмяУровня, СтандартнаяОбработка)
	Если ИспользоватьАвтоподбор И ЗначениеЗаполнено(Текст) Тогда
		ДанныеВыбора			= АвтоПодборВариантов(Текст, ИмяУровня, ТипАдреса, НаселенныйПунктДетально);
		СтандартнаяОбработка	= НЕ ДанныеВыбора.Количество() > 0;
		Модифицированность		= Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция АвтоПодборВариантов(Текст, ИмяУровня, ТипАдреса, НаселенныйПунктДетально)
	ДанныеВыбора = Новый СписокЗначений;

	Если ЗначениеЗаполнено(Текст) Тогда
		РодительскийИдентификатор = ИдентификаторРодителяУровняАдреса(ИмяУровня, НаселенныйПунктДетально, ТипАдреса);

		Если НЕ ЗначениеЗаполнено(РодительскийИдентификатор) И СтрСравнить(ИмяУровня, "Area") <> 0 Тогда
			Возврат ДанныеВыбора;
		КонецЕсли;

		Уровень = КонтактнаяИнформацияКлиентСервер.РСА_СопоставлениеНаименованиеУровнюАдреса(ИмяУровня);

		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Идентификатор", РодительскийИдентификатор);
		ДополнительныеПараметры.Вставить("ТипАдреса", ТипАдреса);
		ДополнительныеПараметры.Вставить("Уровень", Уровень);

		// Зарезервировано для новых подсистем

		Если ДанныеВыбора.Количество() = 0 Тогда
			ИменаУровней			= КонтактнаяИнформацияКлиентСервер.РСА_ИменаУровнейАдреса(ТипАдреса, Истина, Истина);
			ОчищатьИдентификатор	= Ложь;
			Для каждого Уровень Из ИменаУровней Цикл
				Если СтрСравнить(ИмяУровня, Уровень) = 0 Тогда
					ОчищатьИдентификатор = Истина;
				КонецЕсли;
				Если ОчищатьИдентификатор Тогда
					НаселенныйПунктДетально[Уровень + "Id"] = "";
				КонецЕсли;
			КонецЦикла;
			НаселенныйПунктДетально["Id"] = ИдентификаторРодителяУровняАдреса(ИмяУровня, НаселенныйПунктДетально, ТипАдреса);
		КонецЕсли;
	КонецЕсли;

	Возврат ДанныеВыбора;
КонецФункции

&НаСервереБезКонтекста
Функция ИдентификаторРодителяУровняАдреса(Знач ИмяУровня, Знач НаселенныйПунктДетально, Знач ТипАдреса)
	РодительскийИдентификатор = Неопределено;
	ИменаУровнейАдреса = КонтактнаяИнформацияКлиентСервер.РСА_ИменаУровнейАдреса(ТипАдреса, Ложь);
	Для каждого УровеньАдреса Из ИменаУровнейАдреса Цикл
		Если УровеньАдреса = ИмяУровня Тогда
			Возврат РодительскийИдентификатор;
		КонецЕсли;
		Если ЗначениеЗаполнено(НаселенныйПунктДетально[УровеньАдреса + "Id"]) Тогда
			РодительскийИдентификатор = НаселенныйПунктДетально[УровеньАдреса + "Id"];
		КонецЕсли;
	КонецЦикла;

	Возврат РодительскийИдентификатор;
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(Элемент, Знач ВыбранноеЗначение, СтандартнаяОбработка)
	Если ПустаяСтрока(ВыбранноеЗначение) Тогда
		ТекстПредупреждения = "Выбор из списка недоступен, т.к в адресном классификаторе отсутствует информация о адресных сведениях.";
		ПоказатьПредупреждение(, ТекстПредупреждения );
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("Идентификатор") И ПустаяСтрока(ВыбранноеЗначение.Идентификатор) Тогда
		 СтандартнаяОбработка = Ложь;

		Возврат;
	КонецЕсли;

	СведенияОбАдресе = Новый Структура;
	СведенияОбАдресе.Вставить("ЗагруженныеДанные", Неопределено);
	СведенияОбАдресе.Вставить("Идентификатор",     Неопределено);
	СведенияОбАдресе.Вставить("Муниципальный",     СтрСравнить("Муниципальный", ТипАдреса) = 0);

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Если ВыбранноеЗначение.Отказ Или ПустаяСтрока(ВыбранноеЗначение.Идентификатор) Тогда
			Возврат;
		КонецЕсли;

		Идентификатор                      = ВыбранноеЗначение.Идентификатор;
		СведенияОбАдресе.ЗагруженныеДанные = ВыбранноеЗначение.ЗагруженныеДанные;
	Иначе
		Идентификатор = ВыбранноеЗначение;
	КонецЕсли;
	СведенияОбАдресе.Идентификатор = Идентификатор;

	СтандартнаяОбработка	= Ложь;
	НаселенныйПунктДетально	= НаселенныйПунктДетальноПоИдентификатору(СведенияОбАдресе, ИсключатьГородИзМуниципальногоАдреса);
	ОпределитьПоляАдреса();
	Элемент.ОбновитьТекстРедактирования();

	Если ЕстьПравоЗагружатьКлассификатор И Не КлассификаторДоступен И ВыбранноеЗначение.ПредлагатьЗагрузкуКлассификатора Тогда
		// Предлагаем загрузить классификатор.
		ПредложениеЗагрузкиКлассификатора(СтрШаблон("Данные для ""%1"" не загружены.", ВыбранноеЗначение.Представление), ВыбранноеЗначение.Представление);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПредложениеЗагрузкиКлассификатора(Знач Текст = "", Знач Регион = Неопределено)
	Возврат;

	// Зарезервировано для новых подсистем
КонецПроцедуры

&НаКлиенте
Процедура ПредложениеЗагрузкиКлассификатораЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;

	ЗагрузитьАдресныйКлассификатор(ДополнительныеПараметры);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьАдресныйКлассификатор(Знач ДополнительныеПараметры = Неопределено)
	// Зарезервировано для новых подсистем
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаселенныйПунктДетальноПоИдентификатору(ИдентификаторНаселенногоПункта, ИсключатьГородИзМуниципальногоАдреса)
	Возврат Обработки.РасширенныйВводКонтактнойИнформации.СписокРеквизитовНаселенныйПункт(ИдентификаторНаселенногоПункта, ИсключатьГородИзМуниципальногоАдреса);
КонецФункции

&НаКлиенте
Процедура ИзменитьУровеньАдреса(ИмяУровня, Значение)
	Если ТипАдреса =  "Административно-территориальный" Или ТипАдреса =  "Муниципальный" Тогда
		НаименованиеСокращение						= КонтактнаяИнформацияКлиентСервер.УКИ_НаименованиеСокращение(Значение);

		НаселенныйПунктДетально[ИмяУровня]			= НаименованиеСокращение.Наименование;
		НаселенныйПунктДетально[ИмяУровня + "Type"]	= НаименованиеСокращение.Сокращение;
		НаселенныйПунктДетально[ИмяУровня + "Id"]	= "";
	Иначе
		НаселенныйПунктДетально[ИмяУровня]			= Значение;
	КонецЕсли
КонецПроцедуры
