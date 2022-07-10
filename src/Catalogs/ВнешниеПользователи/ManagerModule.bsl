///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
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

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	СписокВнешнихПользователей = ПользователиСервер.сП_ВнешниеПользователиДляВключенияВосстановленияПароля();

	Если СписокВнешнихПользователей.Количество() > 0 Тогда
		ОбновлениеВерсииИБСервер.ОИБ_ОтметитьКОбработке(Параметры, СписокВнешнихПользователей);
	КонецЕсли;
КонецПроцедуры


Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	ВнешнийПользовательСсылка = ОбновлениеВерсииИБСервер.ОИБ_ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВнешниеПользователи");

	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	СписокОшибок = Новый Массив;

	Пока ВнешнийПользовательСсылка.Следующий() Цикл
		ОбъектАвторизации	= БазоваяПодсистемаСервер.ОН_ЗначениеРеквизитаОбъекта(ВнешнийПользовательСсылка.Ссылка, "ОбъектАвторизации");
		Результат			= ПользователиСервер.сП_ОбновитьПочтуДляВосстановленияПароля(ВнешнийПользовательСсылка.Ссылка, ОбъектАвторизации);

		Если Результат.Статус = "Ошибка" Тогда
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			СписокОшибок.Добавить(Результат.ТекстОшибки);
		Иначе
			ОбъектовОбработано = ОбъектовОбработано + 1;
			ОбновлениеВерсииИБСервер.ОИБ_ОтметитьВыполнениеОбработки(ВнешнийПользовательСсылка.Ссылка);
		КонецЕсли;
	КонецЦикла;

	Параметры.ОбработкаЗавершена = НЕ ОбновлениеВерсииИБСервер.ОИБ_ЕстьДанныеДляОбработки(Параметры.Очередь, "Справочник.ВнешниеПользователи", Неопределено);

	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтрШаблон("Не удалось обработать некоторых внешних пользователей (пропущены): %1
				|%2", ПроблемныхОбъектов, СтрСоединить(СписокОшибок, Символы.ПС));

		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Информация, Метаданные.Справочники.ВнешниеПользователи,, СтрШаблон("Обработана очередная порция внешних пользователей: %1", ОбъектовОбработано));
	КонецЕсли;
КонецПроцедуры

#КонецЕсли
