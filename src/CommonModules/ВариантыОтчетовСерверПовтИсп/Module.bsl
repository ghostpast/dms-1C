///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ВариантыОтчетов

Функция ВО_ДоступныеОтчеты(ПроверятьФункциональныеОпции = Истина) Экспорт
	Результат			= Новый Массив;
	ПолныеИменаОтчетов	= Новый Массив;

	ПоУмолчаниюВсеПодключены = Неопределено;
	Для Каждого ОтчетМетаданные Из Метаданные.Отчеты Цикл
		Если Не ПравоДоступа("Просмотр", ОтчетМетаданные) Или Не ВариантыОтчетовСервер.ВО_ОтчетПодключенКХранилищу(ОтчетМетаданные, ПоУмолчаниюВсеПодключены) Тогда
			Продолжить;
		КонецЕсли;
		Если ПроверятьФункциональныеОпции И Не БазоваяПодсистемаСервер.ОН_ОбъектМетаданныхДоступенПоФункциональнымОпциям(ОтчетМетаданные) Тогда
			Продолжить;
		КонецЕсли;
		ПолныеИменаОтчетов.Добавить(ОтчетМетаданные.ПолноеИмя());
	КонецЦикла;

	ИдентификаторыОтчетов = Справочники.ИдентификаторыОбъектовМетаданных.ИдентификаторыОбъектовМетаданных(ПолныеИменаОтчетов, Истина);
	Для Каждого ИдентификаторОтчета Из ИдентификаторыОтчетов Цикл
		Результат.Добавить(ИдентификаторОтчета.Значение);
	КонецЦикла;

	Возврат Новый ФиксированныйМассив(Результат);
КонецФункции

#КонецОбласти
