///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если НЕ Параметры.Отбор.Свойство("Недействителен") Тогда
		Параметры.Отбор.Вставить("Недействителен", Ложь);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаОбъекта" И Параметры.Свойство("ОбъектАвторизации") Тогда
		СтандартнаяОбработка	= Ложь;
		ВыбраннаяФорма			= "ФормаЭлемента";

		НайденныйВнешнийПользователь			= Неопределено;
		ЕстьПравоДобавленияВнешнегоПользователя	= Ложь;

		ОбъектАвторизацииИспользуется = ПользователиСервер.сП_ОбъектАвторизацииИспользуется(Параметры.ОбъектАвторизации, Неопределено, НайденныйВнешнийПользователь, ЕстьПравоДобавленияВнешнегоПользователя);

		Если ОбъектАвторизацииИспользуется Тогда
			Параметры.Вставить("Ключ", НайденныйВнешнийПользователь);
		ИначеЕсли ЕстьПравоДобавленияВнешнегоПользователя Тогда
			Параметры.Вставить("ОбъектАвторизацииНовогоВнешнегоПользователя", Параметры.ОбъектАвторизации);
		Иначе
			ВызватьИсключение "Разрешение на вход в программу не предоставлялось.";
		КонецЕсли;

		Параметры.Удалить("ОбъектАвторизации");
	КонецЕсли;
КонецПроцедуры

#КонецЕсли
