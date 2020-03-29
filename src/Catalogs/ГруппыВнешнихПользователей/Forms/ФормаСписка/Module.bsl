///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НастроитьПорядокГруппыВсеВнешниеПользователи(Список);

	Если Параметры.РежимВыбора Тогда
		БазоваяПодсистемаСервер.СП_УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;

		// Исключение выбора группы Все внешние пользователи в качестве родителя.
		БазоваяПодсистемаКлиентСервер.ОН_УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", Справочники.ГруппыВнешнихПользователей.ВсеВнешниеПользователи,
			ВидСравненияКомпоновкиДанных.НеРавно, , Параметры.Свойство("ВыборРодителя"));

		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Заголовок							= "Подбор групп внешних пользователей";
			Элементы.Список.МножественныйВыбор	= Истина;
			Элементы.Список.РежимВыделения		= РежимВыделенияТаблицы.Множественный;
		Иначе
			Заголовок							= "Выбор группы внешних пользователей";
		КонецЕсли;

		АвтоЗаголовок = Ложь;
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;

	Если БазоваяПодсистемаСервер.ОН_ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	СписокПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура НастроитьПорядокГруппыВсеВнешниеПользователи(Список)
	Перем Порядок;

	// Порядок.
	Порядок											= Список.КомпоновщикНастроек.Настройки.Порядок;
	Порядок.ИдентификаторПользовательскойНастройки	= "ОсновнойПорядок";
	Порядок.Элементы.Очистить();

	ЭлементПорядка						= Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле					= Новый ПолеКомпоновкиДанных("Предопределенный");
	ЭлементПорядка.ТипУпорядочивания	= НаправлениеСортировкиКомпоновкиДанных.Убыв;
	ЭлементПорядка.РежимОтображения		= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование		= Истина;

	ЭлементПорядка						= Порядок.Элементы.Добавить(Тип("ЭлементПорядкаКомпоновкиДанных"));
	ЭлементПорядка.Поле					= Новый ПолеКомпоновкиДанных("Наименование");
	ЭлементПорядка.ТипУпорядочивания	= НаправлениеСортировкиКомпоновкиДанных.Возр;
	ЭлементПорядка.РежимОтображения		= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементПорядка.Использование		= Истина;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СписокПриИзмененииНаСервере()
	// Зарезервировано для новых подсистем
КонецПроцедуры

