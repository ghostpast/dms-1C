///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ВариантыОтчетов

Процедура ВО_ПриПодключенииОтчета(ПараметрыОткрытия) Экспорт
	ВариантыОтчетовСервер.ВО_ПриПодключенииОтчета(ПараметрыОткрытия);
КонецПроцедуры

Функция ВО_ТипСубконто(Счет, НомерСубконто) Экспорт
	Если Счет = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	ОбъектМетаданных = Счет.Метаданные();

	Если Не Метаданные.ПланыСчетов.Содержит(ОбъектМетаданных) Тогда
		Возврат Неопределено;
	КонецЕсли;

	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПланСчетовВидыСубконто.ВидСубконто.ТипЗначения КАК Тип
	|ИЗ
	|	&ПолноеИмяТаблицы КАК ПланСчетовВидыСубконто
	|ГДЕ
	|	ПланСчетовВидыСубконто.Ссылка = &Ссылка
	|	И ПланСчетовВидыСубконто.НомерСтроки = &НомерСтроки";

	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПолноеИмяТаблицы", ОбъектМетаданных.ПолноеИмя() + ".ВидыСубконто");

	Запрос.УстановитьПараметр("Ссылка",			Счет);
	Запрос.УстановитьПараметр("НомерСтроки",	НомерСубконто);

	Выборка = Запрос.Выполнить().Выбрать();

	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат Выборка.Тип;
КонецФункции

Функция ВО_СвойстваВариантовОтчетовИзФайлов(ОписаниеФайлов) Экспорт
	Возврат ВариантыОтчетовСервер.ВО_СвойстваВариантовОтчетовИзФайлов(ОписаниеФайлов);
КонецФункции

Функция ВО_СвойстваВариантаОтчетаИзФайла(ОписаниеФайла, ВариантОтчетаОснование) Экспорт
	Возврат ВариантыОтчетовСервер.ВО_СвойстваВариантаОтчетаИзФайла(ОписаниеФайла, ВариантОтчетаОснование);
КонецФункции

Процедура ВО_ПоделитьсяПользовательскимиНастройками(ВыбранныеПользователи, ОписаниеНастроек) Экспорт
	ВариантыОтчетовСервер.ВО_ПоделитьсяПользовательскимиНастройками(ВыбранныеПользователи, ОписаниеНастроек);
КонецПроцедуры

#КонецОбласти
