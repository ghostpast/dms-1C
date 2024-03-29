///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПеренестиНастройки() Экспорт
	Блокировка = Новый БлокировкаДанных;
	Блокировка.Добавить("Константа.УдалитьНастройкиВходаПользователей");
	Блокировка.Добавить("Константа.НастройкиВходаПользователей");

	НачатьТранзакцию();

	Попытка
		Блокировка.Заблокировать();

		УстановитьПривилегированныйРежим(Истина);

		СохраненныеНастройки = Константы.УдалитьНастройкиВходаПользователей.Получить().Получить();
		Если СохраненныеНастройки <> Неопределено Тогда
			Константы.НастройкиВходаПользователей.Установить(Новый ХранилищеЗначения(СохраненныеНастройки));
			Константы.УдалитьНастройкиВходаПользователей.Установить(Новый ХранилищеЗначения(Неопределено));
		КонецЕсли;

		УстановитьПривилегированныйРежим(Ложь);

		ЗафиксироватьТранзакцию();

		ЗаписьЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Информация, Метаданные.Константы.НастройкиВходаПользователей,, "Настройки входа пользователей успешно перенесены");
	Исключение
		ОтменитьТранзакцию();

		ТекстОшибки = СтрШаблон("Ошибка переноса настроек входа пользователя:
				 |%1",
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));

		ЗаписьЖурналаРегистрации("Обновление информационной базы", УровеньЖурналаРегистрации.Ошибка, Метаданные.Константы.НастройкиВходаПользователей,, ТекстОшибки);

		ВызватьИсключение "Ошибка переноса настроек входа пользователя. Подробности в журнале регистрации.";
	КонецПопытки;
КонецПроцедуры

#КонецЕсли
