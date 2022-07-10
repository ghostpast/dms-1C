///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ГлавныйУзел = Константы.ГлавныйУзел.Получить();

	Если Не ЗначениеЗаполнено(ГлавныйУзел) Тогда
		ВызватьИсключение "Главный узел не сохранен.";
	КонецЕсли;

	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		ВызватьИсключение "Главный узел установлен.";
	КонецЕсли;

	Элементы.ТекстПредупреждения.Заголовок = СтрШаблон(Элементы.ТекстПредупреждения.Заголовок, Строка(ГлавныйУзел));
КонецПроцедуры

&НаКлиенте
Процедура Восстановить(Команда)
	ВосстановитьНаСервере();

	Закрыть(Новый Структура("Отказ", Ложь));
КонецПроцедуры

&НаКлиенте
Процедура Отключить(Команда)
	ОтключитьНаСервере();

	Закрыть(Новый Структура("Отказ", Ложь));
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	Закрыть(Новый Структура("Отказ", Истина));
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтключитьНаСервере()
	НачатьТранзакцию();
	Попытка
		ГлавныйУзел						= Константы.ГлавныйУзел.Получить();

		ГлавныйУзелМенеджер				= Константы.ГлавныйУзел.СоздатьМенеджерЗначения();
		ГлавныйУзелМенеджер.Значение	= Неопределено;
		ОбновлениеВерсииИБСервер.ОИБ_ЗаписатьДанные(ГлавныйУзелМенеджер);

		// Зарезервировано для новых подсистем

		БазоваяПодсистемаСервер.СП_ВосстановитьПредопределенныеЭлементы();

		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();

		ВызватьИсключение;
	КонецПопытки;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ВосстановитьНаСервере()
	ГлавныйУзел = Константы.ГлавныйУзел.Получить();

	ПланыОбмена.УстановитьГлавныйУзел(ГлавныйУзел);
КонецПроцедуры
