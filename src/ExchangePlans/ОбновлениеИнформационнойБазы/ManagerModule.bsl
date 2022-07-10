///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция УзлыМеньшейОчереди(Очередь) Экспорт
	Запрос			= Новый Запрос;
	Запрос.Текст	=
	"ВЫБРАТЬ
	|	ОбновлениеИнформационнойБазы.Ссылка КАК Ссылка
	|ИЗ
	|	ПланОбмена.ОбновлениеИнформационнойБазы КАК ОбновлениеИнформационнойБазы
	|ГДЕ
	|	ОбновлениеИнформационнойБазы.Очередь < &Очередь
	|	И НЕ ОбновлениеИнформационнойБазы.ЭтотУзел
	|	И НЕ ОбновлениеИнформационнойБазы.Временная
	|	И ОбновлениеИнформационнойБазы.Очередь <> 0";

	Запрос.УстановитьПараметр("Очередь", Очередь);

	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
КонецФункции

Функция УзелПоОчереди(Очередь, Временная = Ложь) Экспорт
	Если ТипЗнч(Очередь) <> Тип("Число") Или Очередь = 0 Тогда
		ВызватьИсключение СтрШаблон("Невозможно получить узел плана обмена %1, т.к. не передан номер очереди.", "ОбновлениеИнформационнойБазы");
	КонецЕсли;

	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ОбновлениеИнформационнойБазы.Ссылка КАК Ссылка
		|ИЗ
		|	ПланОбмена.ОбновлениеИнформационнойБазы КАК ОбновлениеИнформационнойБазы
		|ГДЕ
		|	ОбновлениеИнформационнойБазы.Очередь = &Очередь
		|	И ОбновлениеИнформационнойБазы.Временная = &Временная
		|	И НЕ ОбновлениеИнформационнойБазы.ЭтотУзел");
	Запрос.УстановитьПараметр("Очередь", Очередь);
	Запрос.УстановитьПараметр("Временная", Временная);
	Выборка = Запрос.Выполнить().Выбрать();

	Если Выборка.Следующий() Тогда
		Узел = Выборка.Ссылка;
	Иначе
		НачатьТранзакцию();

		Попытка
			Блокировки = Новый БлокировкаДанных;
			Блокировка = Блокировки.Добавить("ПланОбмена.ОбновлениеИнформационнойБазы");
			Блокировка.УстановитьЗначение("Очередь", Очередь);
			Блокировка.УстановитьЗначение("Временная", Временная);
			Блокировки.Заблокировать();

			Выборка = Запрос.Выполнить().Выбрать();

			Если Выборка.Следующий() Тогда
				Узел = Выборка.Ссылка;
			Иначе
				ОчередьСтрокой			= Строка(Очередь);
				УзелОбъект				= СоздатьУзел();
				УзелОбъект.Очередь		= Очередь;
				УзелОбъект.Временная	= Временная;
				УзелОбъект.УстановитьНовыйКод(ОчередьСтрокой);
				УзелОбъект.Наименование	= ОчередьСтрокой + ?(Временная, " Новая для перезапуска", "");
				УзелОбъект.Записать();
				Узел					= УзелОбъект.Ссылка;
			КонецЕсли;

			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();

			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;

	Возврат Узел;
КонецФункции

#КонецЕсли
