///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Предопределенный Или Объект.ЗапретитьРедактированиеПользователем Тогда
		Элементы.Наименование.ТолькоПросмотр			= Истина;
		Элементы.Родитель.ТолькоПросмотр				= Истина;
		Элементы.Тип.ТолькоПросмотр						= Истина;
		Элементы.ГруппаТипОбщиеДляВсех.ТолькоПросмотр	= Объект.ЗапретитьРедактированиеПользователем;
		Элементы.ИдентификаторДляФормул.ТолькоПросмотр	= Истина;
	Иначе
		// Зарезервировано для новых подсистем

		Элементы.Родитель.ТолькоПросмотр				= Истина;
		Элементы.Тип.ТолькоПросмотр						= Истина;
	КонецЕсли;

	Если Объект.Ссылка.Пустая() Тогда
		Объект.ВидРедактирования = "ПолеВводаИДиалог";
	КонецЕсли;

	СсылкаРодителя											= Объект.Родитель;
	Элементы.ХранитьИсториюИзменений.Доступность			= Объект.ВидРедактирования = "Диалог";
	Элементы.РазрешитьВводНесколькихЗначений.Доступность	= НЕ Объект.ХранитьИсториюИзменений;

	Если Не Объект.МожноИзменятьСпособРедактирования Тогда
		Элементы.ВидРедактирования.Доступность					= Ложь;
		Элементы.РазрешитьВводНесколькихЗначений.Доступность	= Ложь;
		Элементы.ГруппаНаименованиеНастройкиПоТипам.Доступность	= Ложь;
		Элементы.ХранитьИсториюИзменений.Доступность			= Ложь;
	КонецЕсли;

	Элементы.ГруппаХранитьИсториюИзменений.Видимость = Ложь;

	Если Объект.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес ИЛИ НЕ СсылкаРодителя.Пустая() ИЛИ СсылкаРодителя.Уровень() = 0 Тогда
		ТабличнаяЧасть				= Неопределено;

		РеквизитыРодителя			= БазоваяПодсистемаСервер.ОН_ЗначенияРеквизитовОбъекта(СсылкаРодителя, "ИмяПредопределенныхДанных, ИмяПредопределенногоВида");
		ИмяПредопределенногоВида	= ?(ЗначениеЗаполнено(РеквизитыРодителя.ИмяПредопределенногоВида), РеквизитыРодителя.ИмяПредопределенногоВида, РеквизитыРодителя.ИмяПредопределенныхДанных);

		Если СтрНачинаетсяС(ИмяПредопределенногоВида, "Справочник") Тогда
			ИмяОбъекта = Сред(ИмяПредопределенногоВида, СтрДлина("Справочник") + 1);
			Если Метаданные.Справочники.Найти(ИмяОбъекта) <> Неопределено Тогда
				ТабличнаяЧасть = Метаданные.Справочники[ИмяОбъекта].ТабличныеЧасти.Найти("КонтактнаяИнформация");
			КонецЕсли;
		ИначеЕсли СтрНачинаетсяС(ИмяПредопределенногоВида, "Документ") Тогда
			ИмяОбъекта = Сред(ИмяПредопределенногоВида, СтрДлина("Документ") + 1);
			Если Метаданные.Документы.Найти(ИмяОбъекта) <> Неопределено Тогда
				ТабличнаяЧасть = Метаданные.Документы[ИмяОбъекта].ТабличныеЧасти.Найти("КонтактнаяИнформация");
			КонецЕсли;
		КонецЕсли;

		Если ТабличнаяЧасть <> Неопределено Тогда
			Если ТабличнаяЧасть.Реквизиты.Найти("ДействуетС") <> Неопределено Тогда
				Элементы.ГруппаХранитьИсториюИзменений.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если (Объект.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Или Объект.Тип = Перечисления.ТипыКонтактнойИнформации.Факс) И Объект.ВидРедактирования = "Диалог" Тогда
		Элементы.МаскаПриВводеНомераТелефона.Доступность = Ложь;
	КонецЕсли;

	ДоступныДополнительныеНастройкиАдреса					= (Метаданные.Обработки.Найти("РасширенныйВводКонтактнойИнформации") <> Неопределено И Метаданные.Обработки["РасширенныйВводКонтактнойИнформации"].Формы.Найти("НастройкиАдреса") <> Неопределено);

	Элементы.ЗаполнитьИдентификаторДляФормул.Доступность	= НЕ Элементы.ИдентификаторДляФормул.ТолькоПросмотр;

	КонтактнаяИнформацияСервер.РСА_ЗаполнитьМаскиНомераТелефона(Элементы.ШаблонМаскиНомераТелефона.СписокВыбора);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзменитьОтображениеПриИзмененииТипа();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПослеВводаСтрокНаРазныхЯзыках" И Параметр = ЭтотОбъект Тогда
		Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
			ОбновитьПредлагаемоеЗначениеИдентификатора();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если НЕ ПараметрыЗаписи.Свойство("КогдаИдентификаторДляФормулУжеИспользуется") И ЗначениеЗаполнено(Объект.ИдентификаторДляФормул) Тогда
		// Заполнение идентификатора для формул
		// и проверка есть ли свойство с тем же наименованием.
		ТекстВопроса = ИдентификаторДляФормулУжеИспользуется(Объект.ИдентификаторДляФормул, Объект.Ссылка, Объект.Родитель);

		Если ЗначениеЗаполнено(ТекстВопроса) Тогда
			Кнопки = Новый СписокЗначений;
			Кнопки.Добавить("ПродолжитьЗапись",              "Продолжить");
			Кнопки.Добавить("ВернутьсяКВводуИдентификатора", "Отмена");

			ПоказатьВопрос(Новый ОписаниеОповещения("ПослеОтветаНаВопросКогдаИдентификаторДляФормулУжеИспользуется", ЭтотОбъект, ПараметрыЗаписи), ТекстВопроса, Кнопки, , "ПродолжитьЗапись");

			Отказ = Истина;
		Иначе
			ПараметрыЗаписи.Вставить("ПроверкаИдентификатораДляФормулВыполнена");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Не ТекущийОбъект.ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;

	Если ВидКИСТакимНаименованиемУжеСуществует(ТекущийОбъект) Тогда
		ВызватьИсключение СтрШаблон("Вид контактной информации с наименованием %1 уже существует. Задайте другое наименование.", Строка(ТекущийОбъект.Наименование));
	КонецЕсли;

	// Формирование идентификатора для формул дополнительного реквизита (сведения).
	Если Не ЗначениеЗаполнено(ТекущийОбъект.ИдентификаторДляФормул) Или ПараметрыЗаписи.Свойство("КогдаИдентификаторДляФормулУжеИспользуется") Тогда
		НаименованиеОбъекта						= НаименованиеДляФормированияИдентификатора(ТекущийОбъект.Наименование, ТекущийОбъект.Представления);
		ТекущийОбъект.ИдентификаторДляФормул	= Справочники.ВидыКонтактнойИнформации.УникальныйИдентификаторДляФормул(НаименованиеОбъекта, ТекущийОбъект.Ссылка, ТекущийОбъект.Родитель);

		ПараметрыЗаписи.Вставить("ПроверкаИдентификатораДляФормулВыполнена");
	КонецЕсли;
	Если ПараметрыЗаписи.Свойство("ПроверкаИдентификатораДляФормулВыполнена") Тогда
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПроверкаИдентификатораДляФормулВыполнена");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	// Зарезервировано для новых подсистем

	Элементы.ЗаполнитьИдентификаторДляФормул.Доступность = НЕ Элементы.ИдентификаторДляФормул.ТолькоПросмотр;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	ПроверяемыеРеквизиты.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбновитьПредлагаемоеЗначениеИдентификатора();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	ИзменитьРеквизитыПриИзмененииТипа();
	ИзменитьОтображениеПриИзмененииТипа();
КонецПроцедуры

&НаКлиенте
Процедура ТипОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВидРедактированияПриИзменении(Элемент)
	Если Объект.ВидРедактирования = "Диалог" Тогда
		Элементы.ХранитьИсториюИзменений.Доступность     = Истина;
		Объект.ВводитьНомерПоМаске                       = Ложь;
		Элементы.МаскаПриВводеНомераТелефона.Доступность = Ложь;
	Иначе
		Элементы.ХранитьИсториюИзменений.Доступность     = Ложь;
		Объект.ХранитьИсториюИзменений                   = Ложь;
		Элементы.МаскаПриВводеНомераТелефона.Доступность = Истина;
	КонецЕсли;

	Элементы.РазрешитьВводНесколькихЗначений.Доступность = НЕ Объект.ХранитьИсториюИзменений;
КонецПроцедуры

&НаКлиенте
Процедура ХранитьИсториюИзмененийПриИзменении(Элемент)
	Если Объект.ХранитьИсториюИзменений Тогда
		Объект.РазрешитьВводНесколькихЗначений = Ложь;
	КонецЕсли;

	Элементы.РазрешитьВводНесколькихЗначений.Доступность = Не Объект.ХранитьИсториюИзменений;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВводНесколькихЗначенийПриИзменении(Элемент)
	Если Объект.РазрешитьВводНесколькихЗначений Тогда
		Объект.ХранитьИсториюИзменений = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РодительОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура МеждународныйФорматАдресаПриИзменении(Элемент)
	ИзменитьОтображениеПриИзмененииТипа();
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Открытие(Элемент, СтандартнаяОбработка)

КонецПроцедуры

&НаКлиенте
Процедура ДоступностьПолейДляАдреса()
	Если Объект.ВидРедактирования = "ПолеВвода" Тогда
		Объект.ВключатьСтрануВПредставление					= Ложь;
		Элементы.ВключатьСтрануВПредставление.Доступность	= Ложь;
	Иначе
		Элементы.ВключатьСтрануВПредставление.Доступность	= Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	// Зарезервировано для новых подсистем
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если НЕ Результат = Неопределено Тогда
		Элементы.ЗаполнитьИдентификаторДляФормул.Доступность = НЕ Элементы.ИдентификаторДляФормул.ТолькоПросмотр;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеНастройкиАдреса(Команда)
	ОповещениеОЗакрытие = Новый ОписаниеОповещения("ПослеЗакрытияФормыНастроекАдреса", ЭтотОбъект);
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("Объект", Объект);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтотОбъект.ТолькоПросмотр);
	ИмяФормыНастройкиАдреса = "Обработка.РасширенныйВводКонтактнойИнформации.Форма.НастройкиАдреса";
	ОткрытьФорму(ИмяФормыНастройкиАдреса, ПараметрыФормы,,,,, ОповещениеОЗакрытие);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИдентификаторДляФормул(Команда)
	ЗаполнитьИдентификаторДляФормулНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтображениеПриИзмененииТипа()
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Элементы.Проверки.ТекущаяСтраница					= Элементы.Проверки.ПодчиненныеЭлементы.Адрес;
		Элементы.ВидРедактирования.Доступность				= Объект.МожноИзменятьСпособРедактирования;
		Элементы.ДополнительныеНастройкиАдреса.Видимость	= ДоступныДополнительныеНастройкиАдреса;
		Элементы.ДополнительныеНастройкиАдреса.Доступность	= Не Объект.МеждународныйФорматАдреса;
		Элементы.ВидРедактирования.Видимость				= Истина;

		ДоступностьПолейДляАдреса();
	Иначе
		Элементы.ДополнительныеНастройкиАдреса.Видимость = Ложь;
		Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
			Элементы.Проверки.ТекущаяСтраница		= Элементы.Проверки.ПодчиненныеЭлементы.АдресЭлектроннойПочты;
			Элементы.ВидРедактирования.Видимость	= Ложь;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Skype") Тогда
			Элементы.Проверки.ТекущаяСтраница		= Элементы.Проверки.ПодчиненныеЭлементы.Skype;
			Элементы.ВидРедактирования.Видимость	= Ложь;
			Элементы.РазрешитьВводНесколькихЗначений.Доступность = Истина;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
			Элементы.Проверки.ТекущаяСтраница		= Элементы.Проверки.ПодчиненныеЭлементы.Телефон;
			Элементы.ВидРедактирования.Доступность	= Объект.МожноИзменятьСпособРедактирования;
			Элементы.ВидРедактирования.Видимость	= Истина;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Другое") Тогда
			Элементы.Проверки.ТекущаяСтраница		= Элементы.Проверки.ПодчиненныеЭлементы.Другое;
			Элементы.ВидРедактирования.Доступность	= Ложь;
			Элементы.ВидРедактирования.Видимость	= Ложь;
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
			Элементы.Проверки.ТекущаяСтраница					= Элементы.Проверки.ПодчиненныеЭлементы.Прочие;
			Элементы.ВидРедактирования.Видимость 				= Ложь;
			Элементы.ГруппаХранитьИсториюИзменений.Видимость	= Ложь;
		Иначе
			Элементы.Проверки.ТекущаяСтраница		= Элементы.Проверки.ПодчиненныеЭлементы.Прочие;
			Элементы.ВидРедактирования.Доступность	= Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРеквизитыПриИзмененииТипа()
	Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Элементы.ХранитьИсториюИзменений.Доступность = Истина;
	Иначе
		Объект.ХранитьИсториюИзменений               = Ложь;
		Элементы.ХранитьИсториюИзменений.Доступность = Ложь;

		Если Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты") Тогда
			Объект.ВидРедактирования = "ПолеВвода";
		ИначеЕсли Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Или Объект.Тип = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
			// Нет изменений
		Иначе
			Объект.ВидРедактирования = "ПолеВводаИДиалог";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияФормыНастроекАдреса(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Объект, Результат);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьПредлагаемоеЗначениеИдентификатора()
	ПредлагаемыйИдентификатор = "";
	Если Не Элементы.ИдентификаторДляФормул.ТолькоПросмотр Тогда
		Представление				= НаименованиеДляФормированияИдентификатора(Объект.Наименование, Объект.Представления);
		ПредлагаемыйИдентификатор	= Справочники.ВидыКонтактнойИнформации.УникальныйИдентификаторДляФормул(Представление, Объект.Ссылка, Объект.Родитель);
		Если ПредлагаемыйИдентификатор <> Объект.ИдентификаторДляФормул Тогда
			Объект.ИдентификаторДляФормул	= ПредлагаемыйИдентификатор;
			Модифицированность				= Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИдентификаторДляФормулНаСервере()
	ЗаголовокДляИдентификатора		= НаименованиеДляФормированияИдентификатора(Объект.Наименование, Объект.Представления);
	Объект.ИдентификаторДляФормул	= Справочники.ВидыКонтактнойИнформации.УникальныйИдентификаторДляФормул(ЗаголовокДляИдентификатора, Объект.Ссылка, Объект.Родитель);
КонецПроцедуры

&НаСервереБезКонтекста
Функция НаименованиеДляФормированияИдентификатора(Знач Наименование, Знач Представления)
	Если ТекущийЯзык().КодЯзыка <> Метаданные.ОсновнойЯзык.КодЯзыка Тогда
		Отбор = Новый Структура();
		Отбор.Вставить("КодЯзыка", Метаданные.ОсновнойЯзык.КодЯзыка);
		НайденныеСтроки = Представления.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Наименование = НайденныеСтроки[0].Наименование;
		КонецЕсли;
	КонецЕсли;

	Возврат Наименование;
КонецФункции

&НаКлиенте
Процедура ПослеОтветаНаВопросКогдаИдентификаторДляФормулУжеИспользуется(Ответ, ПараметрыЗаписи) Экспорт
	Если Ответ <> "ПродолжитьЗапись" Тогда
		Если ПараметрыЗаписи.Свойство("ОбработкаПродолжения") Тогда
			ВыполнитьОбработкуОповещения(Новый ОписаниеОповещения(ПараметрыЗаписи.ОбработкаПродолжения.ИмяПроцедуры, ЭтотОбъект, ПараметрыЗаписи.ОбработкаПродолжения.Параметры), Истина);
		КонецЕсли;
	Иначе
		ПараметрыЗаписи.Вставить("КогдаИдентификаторДляФормулУжеИспользуется");
		Записать(ПараметрыЗаписи);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВидКИСТакимНаименованиемУжеСуществует(ТекущийОбъект)
	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ ПЕРВЫЕ 1
		|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
		|ГДЕ
		|	ВидыКонтактнойИнформации.Наименование = &Наименование
		|	И ВидыКонтактнойИнформации.Родитель = &Родитель
		|	И ВидыКонтактнойИнформации.Ссылка <> &Ссылка";

	Запрос.УстановитьПараметр("Наименование", ТекущийОбъект.Наименование);
	Запрос.УстановитьПараметр("Родитель",     ТекущийОбъект.Родитель);
	Запрос.УстановитьПараметр("Ссылка",       ТекущийОбъект.Ссылка);

	РезультатЗапроса = Запрос.Выполнить();

	Возврат Не РезультатЗапроса.Пустой();
КонецФункции


&НаСервереБезКонтекста
Функция ИдентификаторДляФормулУжеИспользуется(Знач ИдентификаторДляФормул, Знач ТекущийВидКонтактнойИнформации, Знач Родитель)
	ПроверочныйИдентификатор = Справочники.ВидыКонтактнойИнформации.ИдентификаторДляФормул(ИдентификаторДляФормул);
	Если ВРег(ИдентификаторДляФормул) <> ВРег(ПроверочныйИдентификатор) Тогда
		ТекстВопроса = "Идентификатор ""%1"" не соответствует правилам именования переменных.
		                          |Идентификатор не должен содержать пробелов и специальных символов.
		                          |
		                          |Создать новый идентификатор для формул и продолжить запись?";
		ТекстВопроса = СтрШаблон(ТекстВопроса, ИдентификаторДляФормул);

		Возврат ТекстВопроса;
	КонецЕсли;

	РодительВерхнегоУровня = Родитель;
	Пока ЗначениеЗаполнено(РодительВерхнегоУровня) Цикл
		Значение = БазоваяПодсистемаСервер.ОН_ЗначениеРеквизитаОбъекта(РодительВерхнегоУровня, "Родитель");
		Если ЗначениеЗаполнено(Значение) Тогда
			РодительВерхнегоУровня = Значение;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВидыКонтактнойИнформации.Ссылка
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул = &ИдентификаторДляФормул
	|	И ВидыКонтактнойИнформации.Ссылка <> &Ссылка
	|	И ВидыКонтактнойИнформации.Ссылка В ИЕРАРХИИ (&Родитель)";

	Запрос.УстановитьПараметр("Ссылка",					ТекущийВидКонтактнойИнформации);
	Запрос.УстановитьПараметр("ИдентификаторДляФормул",	ИдентификаторДляФормул);
	Запрос.УстановитьПараметр("Родитель",				РодительВерхнегоУровня);

	Выборка = Запрос.Выполнить().Выбрать();

	Если НЕ Выборка.Следующий() Тогда
		Возврат "";
	КонецЕсли;

	ТекстВопроса = "Существует вид контактной информации с идентификатором для формул
	                          |""%1"".
	                          |
	                          |Рекомендуется использовать другой идентификатор для формул,
	                          |иначе программа может работать некорректно.
	                          |
	                          |Создать новый идентификатор для формул и продолжить запись?";
	ТекстВопроса = СтрШаблон(ТекстВопроса, ИдентификаторДляФормул);

	Возврат ТекстВопроса;
КонецФункции
