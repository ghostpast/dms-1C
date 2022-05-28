///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция УникальныйИдентификаторДляФормул(ПредставлениеОбъекта, СсылкаНаТекущийОбъект, Родитель) Экспорт
	Идентификатор = ИдентификаторДляФормул(ПредставлениеОбъекта);
	Если ПустаяСтрока(Идентификатор) Тогда
		// Представление состоит и спецсимволов или цифр.
		Префикс			= "Идентификатор";
		Идентификатор	= ИдентификаторДляФормул(Префикс + ПредставлениеОбъекта);
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
	Запрос.Текст	= "ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул КАК ИдентификаторДляФормул
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул = &ИдентификаторДляФормул
	|	И ВидыКонтактнойИнформации.Ссылка <> &СсылкаНаТекущийОбъект
	|	И ВидыКонтактнойИнформации.Ссылка В ИЕРАРХИИ (&РодительВерхнегоУровня)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул КАК ИдентификаторДляФормул
	|ИЗ
	|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации
	|ГДЕ
	|	ВидыКонтактнойИнформации.ИдентификаторДляФормул ПОДОБНО &ИдентификаторДляФормулПодобие
	|	И ВидыКонтактнойИнформации.Ссылка <> &СсылкаНаТекущийОбъект
	|	И ВидыКонтактнойИнформации.Ссылка В ИЕРАРХИИ (&РодительВерхнегоУровня)";
	Запрос.УстановитьПараметр("СсылкаНаТекущийОбъект", СсылкаНаТекущийОбъект);
	Запрос.УстановитьПараметр("РодительВерхнегоУровня", РодительВерхнегоУровня);
	Запрос.УстановитьПараметр("ИдентификаторДляФормул", Идентификатор);
	Запрос.УстановитьПараметр("ИдентификаторДляФормулПодобие", Идентификатор + "%");

	РезультатыЗапроса					= Запрос.ВыполнитьПакет();
	УникальностьПоТочномуСоответствию	= РезультатыЗапроса[0];
	Если НЕ УникальностьПоТочномуСоответствию.Пустой() Тогда
		// Есть элементы с данным идентификатором.
		ИспользованныеИдентификаторы	= Новый Соответствие;
		ВыборкаПодобных					= РезультатыЗапроса[1].Выбрать();
		Пока ВыборкаПодобных.Следующий() Цикл
			ИспользованныеИдентификаторы.Вставить(ВРег(ВыборкаПодобных.ИдентификаторДляФормул), Истина);
		КонецЦикла;

		ДобавляемыйНомер		= 1;
		ИдентификаторБезНомера	= Идентификатор;
		Пока НЕ ИспользованныеИдентификаторы.Получить(ВРег(Идентификатор)) = Неопределено Цикл
			ДобавляемыйНомер	= ДобавляемыйНомер + 1;
			Идентификатор		= ИдентификаторБезНомера + ДобавляемыйНомер;
		КонецЦикла;
	КонецЕсли;
	ИспользованныеИдентификаторы = Новый Соответствие;

	Возврат Идентификатор;
КонецФункции

Функция ИдентификаторДляФормул(СтрокаПредставления) Экспорт
	СпецСимволы = СпецСимволы();

	Идентификатор = "";
	БылСпецСимвол = Ложь;

	Для НомСимвола = 1 По СтрДлина(СтрокаПредставления) Цикл
		Символ = Сред(СтрокаПредставления, НомСимвола, 1);

		Если СтрНайти(СпецСимволы, Символ) <> 0 Тогда
			БылСпецСимвол = Истина;
			Если Символ = "_" Тогда
				Идентификатор = Идентификатор + Символ;
			КонецЕсли;
		ИначеЕсли БылСпецСимвол ИЛИ НомСимвола = 1 Тогда
			БылСпецСимвол = Ложь;
			Идентификатор = Идентификатор + ВРег(Символ);
		Иначе
			Идентификатор = Идентификатор + Символ;
		КонецЕсли;
	КонецЦикла;

	Возврат Идентификатор;
КонецФункции

Функция СпецСимволы()
	Диапазоны = Новый Массив;
	Диапазоны.Добавить(Новый Структура("Мин, Макс", 0, 32));
	Диапазоны.Добавить(Новый Структура("Мин, Макс", 127, 191));

	СпецСимволы = " .,+,-,/,*,?,=,<,>,(,)%!@#$%&*""№:;{}[]?()\|/`~'^_";
	Для Каждого Диапазон Из Диапазоны Цикл
		Для КодСимвола = Диапазон.Мин По Диапазон.Макс Цикл
			СпецСимволы = СпецСимволы + Символ(КодСимвола);
		КонецЦикла;
	КонецЦикла;

	Возврат СпецСимволы;
КонецФункции

Функция НаименованиеДляФормированияИдентификатора(Знач Наименование, Знач Представления)
	Если ТекущийЯзык().КодЯзыка <> Метаданные.ОсновнойЯзык.КодЯзыка Тогда
		Отбор = Новый Структура;
		Отбор.Вставить("КодЯзыка", Метаданные.ОсновнойЯзык.КодЯзыка);
		НайденныеСтроки = Представления.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда
			Наименование = НайденныеСтроки[0].Наименование;
		КонецЕсли;
	КонецЕсли;

	Возврат Наименование;
КонецФункции

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	Запрос			= Новый Запрос;
	Запрос.Текст	= "ВЫБРАТЬ
		|	ВидыКонтактнойИнформации.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ВидыКонтактнойИнформации КАК ВидыКонтактнойИнформации";

	РезультатЗапроса = Запрос.Выполнить().Выгрузить();

	ОбновлениеВерсииИБСервер.ОИБ_ОтметитьКОбработке(Параметры, РезультатЗапроса.ВыгрузитьКолонку("Ссылка"));
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	ВидКонтактнойИнформацииСсылка = ОбновлениеВерсииИБСервер.ОИБ_ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации");

	ЯзыковБольшеОдного	= Метаданные.Языки.Количество() > 1;
	Наименования		= КонтактнаяИнформацияСерверПовтИсп.сУКИ_НаименованияВидовКонтактнойИнформации();

	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;

	Пока ВидКонтактнойИнформацииСсылка.Следующий() Цикл
		Блокировка			= Новый БлокировкаДанных;
		ЭлементБлокировки	= Блокировка.Добавить("Справочник.ВидыКонтактнойИнформации");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ВидКонтактнойИнформацииСсылка.Ссылка);

		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();

			ВидКонтактнойИнформации = ВидКонтактнойИнформацииСсылка.Ссылка.ПолучитьОбъект(); // СправочникОбъект.ВидыКонтактнойИнформации

			// Исправление наименований на разных языках
			Если ЯзыковБольшеОдного Тогда
				ИмяВида = ?(ЗначениеЗаполнено(ВидКонтактнойИнформации.ИмяПредопределенногоВида), ВидКонтактнойИнформации.ИмяПредопределенногоВида, ВидКонтактнойИнформации.ИмяПредопределенныхДанных);

				Если ЗначениеЗаполнено(ИмяВида) Тогда
					УстановитьНаименованияВидовКонтактнойИнформации(ВидКонтактнойИнформации, ИмяВида, Наименования);
				КонецЕсли;
			КонецЕсли;

			Если Не ВидКонтактнойИнформации.ЭтоГруппа Тогда
				Если ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты Или ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Skype Или ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.Другое Тогда
					ВидКонтактнойИнформации.ВидРедактирования = "ПолеВвода";
				ИначеЕсли ВидКонтактнойИнформации.Тип = Перечисления.ТипыКонтактнойИнформации.ВебСтраница Тогда
					ВидКонтактнойИнформации.ВидРедактирования = "Диалог";
				Иначе
					ВидКонтактнойИнформации.ВидРедактирования = "ПолеВводаИДиалог";
				КонецЕсли;
			КонецЕсли;

			Если НЕ ВидКонтактнойИнформации.ЭтоГруппа И НЕ ЗначениеЗаполнено(ВидКонтактнойИнформации.ИдентификаторДляФормул) Тогда
				НаименованиеДляИдентификатора					= НаименованиеДляФормированияИдентификатора(ВидКонтактнойИнформации.Наименование, ВидКонтактнойИнформации.Представления);
				ВидКонтактнойИнформации.ИдентификаторДляФормул	= УникальныйИдентификаторДляФормул(НаименованиеДляИдентификатора, ВидКонтактнойИнформации.Ссылка, ВидКонтактнойИнформации.Родитель);
			КонецЕсли;

			ОбновлениеВерсииИБСервер.ОИБ_ЗаписатьДанные(ВидКонтактнойИнформации);
			ОбъектовОбработано = ОбъектовОбработано + 1;

			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();

			// Если не удалось обработать какой-либо вид контактной информации, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;

			ТекстСообщения = СтрШаблон("Не удалось обработать вид контактной информации: %1 по причине: %2", ВидКонтактнойИнформацииСсылка.Ссылка, ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Предупреждение, Метаданные.Справочники.ВидыКонтактнойИнформации, ВидКонтактнойИнформацииСсылка.Ссылка, ТекстСообщения);
		КонецПопытки;
	КонецЦикла;

	Параметры.ОбработкаЗавершена = НЕ ОбновлениеВерсииИБСервер.ОИБ_ЕстьДанныеДляОбработки(Параметры.Очередь, "Справочник.ВидыКонтактнойИнформации", Неопределено);

	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтрШаблон("Процедуре ЗаполнитьВидыКонтактнойИнформации не удалось обработать некоторые виды контактной информации (пропущены): %1", ПроблемныхОбъектов);

		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Информация, Метаданные.Справочники.ВидыКонтактнойИнформации,, СтрШаблон("Процедура ЗаполнитьВидыКонтактнойИнформации обработала очередную порцию видов контактной информации: %1", ОбъектовОбработано));
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьНаименованияВидовКонтактнойИнформации(ВидКонтактнойИнформации, ИмяВида, Наименования)
	Для Каждого Язык Из Метаданные.Языки Цикл
		Представление = Наименования[Язык.КодЯзыка][ИмяВида];
		Если ЗначениеЗаполнено(Представление) Тогда
			Если Язык = Метаданные.ОсновнойЯзык Тогда
				ВидКонтактнойИнформации.Наименование = Представление;
			Иначе
				Если Наименования[Язык.КодЯзыка][ИмяВида] <> Неопределено Тогда
					Отбор = Новый Структура;
					Отбор.Вставить("КодЯзыка",     Язык.КодЯзыка);
					Отбор.Вставить("Наименование", Представление);
					НайденныеСтроки = ВидКонтактнойИнформации.Представления.НайтиСтроки(Отбор);
					Если НайденныеСтроки.Количество() > 0 Тогда
						НоваяСтрока = НайденныеСтроки[0];
					Иначе
						НоваяСтрока = ВидКонтактнойИнформации.Представления.Добавить();
					КонецЕсли;
					НоваяСтрока.КодЯзыка     = Язык.КодЯзыка;
					НоваяСтрока.Наименование = Представление;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецЕсли
