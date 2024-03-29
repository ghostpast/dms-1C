///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если СтрНачинаетсяС(ИмяПредопределенныхДанных, "Удалить") Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ЭтоГруппа Тогда
		Результат = КонтактнаяИнформацияСервер.сУКИ_ПроверитьПараметрыВидаКонтактнойИнформации(ЭтотОбъект);
		Если Результат.ЕстьОшибки Тогда
			Отказ = Истина;

			ВызватьИсключение Результат.ТекстОшибки;
		КонецЕсли;
		ИмяГруппы = БазоваяПодсистемаСервер.ОН_ЗначениеРеквизитаОбъекта(Родитель, "ИмяПредопределенногоВида");
		Если ПустаяСтрока(ИмяГруппы) Тогда
			ИмяГруппы = БазоваяПодсистемаСервер.ОН_ЗначениеРеквизитаОбъекта(Родитель, "ИмяПредопределенныхДанных");
		КонецЕсли;

		ПроверкаИдентификатораДляФормул(Отказ);
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	УстановитьСостояниеРегламентногоЗадания();
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если СтрНачинаетсяС(ИмяПредопределенныхДанных, "Удалить") Тогда
		ПроверяемыеРеквизиты.Очистить();
		Возврат;
	КонецЕсли;

	Если ЭтоГруппа Тогда
		НепроверяемыеРеквизиты = Новый Массив;
		НепроверяемыеРеквизиты.Добавить("Родитель");
		БазоваяПодсистемаСервер.ОН_УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	КонецЕсли;
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ИмяПредопределенногоВида = "";
	Если НЕ ЭтоГруппа Тогда
		ИдентификаторДляФормул = "";
	КонецЕсли;
КонецПроцедуры

Процедура ПроверкаИдентификатораДляФормул(Отказ)
	Если НЕ ДополнительныеСвойства.Свойство("ПроверкаИдентификатораДляФормулВыполнена") Тогда
		// Программная запись.
		Если ЗначениеЗаполнено(ИдентификаторДляФормул) Тогда
			Справочники.ВидыКонтактнойИнформации.ПроверитьУникальностьИдентификатора(ИдентификаторДляФормул, Ссылка, Родитель, Отказ);
		Иначе
			// Установка идентификатора.
			ИдентификаторДляФормул = Справочники.ВидыКонтактнойИнформации.УникальныйИдентификаторДляФормул(НаименованиеДляФормированияИдентификатора(), Ссылка, Родитель);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция НаименованиеДляФормированияИдентификатора()
	ЗаголовокДляИдентификатора = Наименование;

	Возврат ЗаголовокДляИдентификатора;
КонецФункции

Процедура УстановитьСостояниеРегламентногоЗадания()
	Статус = ?(ИсправлятьУстаревшиеАдреса = Истина, Истина, Неопределено);
	КонтактнаяИнформацияСервер.РСА_УстановитьСостояниеРегламентногоЗадания(Статус);
КонецПроцедуры

#Иначе
ВызватьИсключение "Недопустимый вызов объекта на клиенте.";
#КонецЕсли
