# Компоненты современной СУБД

![Схема табиц и связей БД](store%20chain.png)

[SQL - скрипт для создания таблиц](store%20chain.sql)

## Кардинальность, индексы, ограничения

### *Region - Справочник регионы*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|RegionName|Наименование региона|Поиск по региону|Высокая|UNIQUE NOT NULL, VARCHR(150)|
|RegionTypeId|ID типа региона|Поиск по ID типа региона|Низкая|NOT NULL, FOREIGN KEY RegionType.ID, INTEGER|
|FederalDistrict|Наименование Федерального округа|Поиск по федеральному округу|Низкая|UNIQUE NOT NULL, VARCHR(20)|
|TimeZone|Временная зона|Поиск по временной зоне|Средняя|NOT NULL, VARCHR(255)|

### *RegionType - Справочник типов регионов*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|RegionType|Тип региона скоращённый|Поиск по сокрашённому типу|Высокая|UNIQUE, NOT NULL, VARCHR(10)|
|RegionTypeFull|Тип региона полный|Поиск по полному типу|Высокая|UNIQUE, NOT NULL, VARCHR(50)|

### *Address - Адреса магазинов*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|RegionId|ID Региона|Поиск по ID региона|Низкая|NOT NULL, FOREIGN KEY Region.ID, INTEGER|
|PostalCode|Почтовый код|Поиск по почтовому коду|Высокая|NOT NULL, VARCHR(10)|
|City|Наименование города|Поиск по городу|Высокая|VARCHR(150)|
|CityTypeId|ID типа города|Поиск по ID типа города|Низкая|FOREIGN KEY CityType.ID, INTEGER|
|Settelment|Наименование поселения|Поиск по посленению|Высокая|VARCHR(150)|
|SettelmentTypeId|ID Типа поселения|Поиск по ID типа поселения|Низкая|FOREIGN KEY SettelmentType.ID, INTEGER|
|Street|Наименование улицы|Поиск по улице|Высокая|VARCHR(150)|
|StreetTypeId|ID типа улицы|Поиск по ID типа улицы|Низкая|FOREIGN KEY StreetType.ID, INTEGER|
|House|Номер дома|Поиск по номеру дома|Высокая|VARCHR(150)|

#### Индексы:
- CREATE INDEX idx_PostalCode ON Address(PostalCode);
- CREATE INDEX idx_City ON Address(City);
- CREATE INDEX idx_Settelment ON Address(Settelment);
- CREATE INDEX idx_Street ON Address(Street);
- CREATE INDEX idx_House ON Address(House);
- CREATE INDEX idx_City_Settelment_Street_House ON Address(City, Settelment, Street, House);


### *SettelmentType - Справочник типов послений*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|SettelmentType|Тип поселения скоращённый|Поиск по сокрашённому типу поселений|Высокая|UNIQUE, NOT NULL, VARCHR(10)|
|SettelmentTypeFull|Тип поселения полный|Поиск по полному типу поселений|Высокая|UNIQUE, NOT NULL, VARCHR(50)|

### *CityType - Справочник типов городов*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|CityType|Тип гороода скоращённый|Поиск по сокрашённому типу городов|Высокая|UNIQUE, NOT NULL, VARCHR(10)|
|CityTypeFull|Тип гороода полный|Поиск по полному типу городов|Высокая|UNIQUE, NOT NULL, VARCHR(50)|

### *StreetType - Справочник типов улиц*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|StreetType|Тип улицы скоращённый|Поиск по сокрашённому типу улиц|Высокая|UNIQUE, NOT NULL, VARCHR(10)|
|StreetTypeFull|Тип улицы полный|Поиск по полному типу улиц|Высокая|UNIQUE, NOT NULL, VARCHR(50)|

### *Store - Магазины*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|StoreName|Произвольное название магазина|Поиск по названию магазина|Высокая|NOT NULL, UNIQUE, VARCHR(255)|
|Organization|Юр.лицо на которое отрыт магазин|Поиск по названию организаций|Средняя|NOT NULL, VARCHR(255)|
|INN|ИНН юр.лица или подразделения магаина|Поиск по ИНН|Средняя|NOT NULL, VARCHR(12)|
|AddressId|ID Адреса магазина|Поиск по ID адреса магазина|Высокая|FOREIGN KEY Address.ID, INTEGER|
|StartTime|Время открытия магазина|Поиск по началу времени работы|Низкая|NOT NULL, TIME|
|EndTime|Время завершения работы магазина|Поиск по окончанию времени работы|Низкая|NOT NULL, TIME|

#### Индексы:
- CREATE INDEX "idx_StoreName" ON "Store" ("StoreName");
- CREATE INDEX "idx_Organization" ON "Store" ("Organization");
- CREATE INDEX "idx_INN" ON "Store" ("INN");
- CREATE INDEX "idx_AddressId" ON "Store" ("AddressId");

### *Terminal - Номер кассы*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|TerminalName|Имя кассы (номер, произвольное имя)|Поиск по имени кассы|Низкая|NOT NULL, VARCHR(255)|
|StoreId|ID магазина в котром касса установленна|Поиск по ID магазина|Средняя|NOT NULL, FOREIGN KEY Store.ID, INTEGER|
|ZNKKT|Заводской номер Контрольно Кассовой Техники (ККТ)|Поиск по ЗН ККТ|Высокая|UNIQUE, NOT NULL, VARCHR(50)|
|FNKKT|Регистрационный номер ККТ (если требуется)|Поиск по РН ККТ|Высокая|UNIQUE, BIGINT|

#### Индексы:
- CREATE INDEX "idx_StoreId" ON "Terminal" ("StoreId");
- CREATE INDEX "idx_ZNKKT" ON "Terminal" ("ZNKKT");
- CREATE INDEX "idx_FNKKT" ON "Terminal" ("FNKKT");

### *Cashier - Справочник кассиров*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|FirstName|Имя|Поиск по имени|Высокая|NOT NULL, VARCHR(255)|
|LastName|Фамилия|Поиск по фамилии|Высокая|NOT NULL, VARCHR(255)|
|PatronymicName|Отчество|Поиск по отчеству|Высокая|NOT NULL,VARCHR(255)|
|Hiring|Дата приёма на работу|Поиск по дате найам|Средняя|NOT NULL, DATE|
|Firing|Дата уволнения (не обязательное поле)|Поиск по дате увалнения|Средняя|DATE|
|RoleId|ID Роли кассира|Поиск по ID роли|Низкая|NOT NULL, FOREIGN KEY Role.ID, INTEGER|

#### Индексы:
- CREATE INDEX "idx_FirstName_LastName_PatronymicName" ON "Cashier" ("FirstName", "LastName", "PatronymicName");
- CREATE INDEX "idx_Hiring" ON "Cashier" ("Hiring");
- CREATE INDEX "Firing" ON "Cashier" ("Firing");

### *Role - Справочник ролей кассиров*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|RoleName|Имя роли кассира|Поиск по имени роли|Высокая|UNIQUE, NOT NULL, VARCHR(255)|

### *Shift - Кассовые смены*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|TerminalId|ID кассы|Поиск по ID кассы|Средняя|NOT NULL, FOREIGN KEY Terminal.ID, INTEGER|
|ShiftDate|Дата смены|Поиск по дате смены|Средняя|NOT NULL, DATE|
|ShiftStart|Дата и время открытия смены|Поиск по времени открытия чека|Высокая|NOT NULL, TIMESTAMP|
|ShiftEnd|Дата и время закрытия смены|Поиск по времени закрытия чека|Высокая|TIMESTAMP|
|ZNKKT|Заводской номер ККТ на которой открыли смену|Поиск по ЗН ККТ|Средняя|NOT NULL, VARCHR(50)|
|FNKKT|Регистрационный номер ККТ на которой открыли смену (если требуется)|Поиск по РН ККТ|Средняя|BIGINT|

#### Индексы:
- CREATE INDEX "idx_TerminalId" ON "Shift" ("TerminalId");
- CREATE INDEX "idx_ShiftDate" ON "Shift" ("ShiftDate");
- CREATE INDEX "idx_ShiftStart" ON "Shift" ("ShiftStart");
- CREATE INDEX "ShiftStart" ON "Shift" ("ShiftEnd");
- CREATE INDEX "idx_ZNKKT" ON "Shift" ("ZNKKT");
- CREATE INDEX "FNKKT" ON "Shift" ("FNKKT");

### *Cheque - кассовые чеки*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|ShiftId|ID смены чека|Поиск по ID чека|Средняя|NOT NULL, FOREIGN KEY Shift.ID, INTEGER|
|CashierId|ID кассира|Поиск по ID кассира|Средняя|NOT NULL, FOREIGN KEY Cashier.ID, INTEGER|
|ChequeStart|Дата и время открытия чека|Поиск по времени отрытия чека|Высокая|NOT NULL, TIMESTAMP|
|ChequeEnd|Дата и время закрытия чека (чек может быть не закрыт, например идёт продажа)|Поиск по времени закрытия чека|Высокая|TIMESTAMP|
|ChequeTypeId|ID типа чека (продажа, возврат, отменён и пр.)|Поиск по типу чека|Низкая|NOT NULL, FOREIGN KEY ChequeType.ID, INTEGER|
|Discount|Скидка чека, если применена|Поиск по скидки чека|Низкая|VARCHR(255)|
|FDKKT|Номер фискального документа, если ККТ зарегистрирована|Поиск по номеру фискального документа|Высокая|BIGINT|

#### Индексы:
- CREATE INDEX "idx_ShiftId" ON "Cheque" ("ShiftId");
- CREATE INDEX "idx_CashierId" ON "Cheque" ("CashierId");
- CREATE INDEX "idx_ChequeStart" ON "Cheque" ("ChequeStart");
- CREATE INDEX "idx_ChequeEnd" ON "Cheque" ("ChequeEnd");
- CREATE INDEX "idx_FDKKT" ON "Cheque" ("FDKKT");

### *ChequeType - Справочник типов чека*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|ChequeType|Наименование типа чека|Поиск по типу чека|Высокая|UNIQUE, NOT NULL, VARCHR(255)|

### *ChequePositions - Позиция в чеке*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|ChequeId|ID Чека|Поиск по ID чека|Средняя|NOT NULL, FOREIGN KEY Cheque.ID, INTEGER|
|ProductId|ID товара|Поиск по ID товара|Средняя|NOT NULL, FOREIGN KEY Product.ID, INTEGER|
|Amount|Кол-во товара|Поиск по кол-ву товара|Средняя|NOT NULL, REAL, CHECK (Amount > 0)|
|PriceId|ID Цены товара|Поиск по ID цены товара|Средняя|NOT NULL, FOREIGN KEY Price.ID, INTEGER|
|Price|Цена товара|Поиск по цене|Средняя|NOT NULL, REAL, CHECK (Price > 0)|
|Discount|Скидка на позицию товара|Писк по скидке на позицию|Низкая|VARCHR(255)|

#### Индексы:
- CREATE INDEX "idx_ChequeId" ON "ChequePositions" ("ChequeId");
- CREATE INDEX "idx_ProductId" ON "ChequePositions" ("ProductId");
- CREATE INDEX "idx_Amount" ON "ChequePositions" ("Amount");
- CREATE INDEX "idx_PriceId" ON "ChequePositions" ("PriceId");
- CREATE INDEX "idx_Price" ON "ChequePositions" ("Price");

### *Products - Справочни товара*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|ProductName|Наименование|Поиск по имени товара|Высокая|NOT NULL, UNIQUE, VARCHR(255)|
|ProductUnitId|ID единицы измерения товара|Поиск по ID ед. измерения товара|Низкая|NOT NULL, FOREIGN KEY ProductUnit.ID, INTEGER|

#### Индексы:
- CREATE INDEX "idx_ProductName" ON "Products" ("ProductName");

### *ProductUnit - Справочник единиц измерения товра*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|UnitName|Наименование еденицы|Поиск по названию ед. измерения|Высокая|NOT NULL, UNIQUE, VARCHR(255)|
|UnitType|Тип единцы|Поиск по типу ед. изменения|Низкая|NOT NULL, UNIQUE, VARCHR(255)|

### *ProductCategory - Справочник категорий товаров*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|CategoryName|Наименование категории|Поиск по названию категрии|Высокая|NOT NULL, UNIQUE, VARCHR(255)|
|ParentCategory|Родительская категория|Поиск по родительским категориям|Средняя|FOREIGN KEY ProductCategory.ID, INTEGER|

#### Индексы:
- CREATE INDEX "idx_CategoryName" ON "ProductCategory" ("CategoryName");

### *ProductsProductCategory - Таблица связи товаров и категорий*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ProductsId|ID товара|Поиск по ID товара|Высокая|NOT NULL, FOREIGN KEY Products.ID, INTEGER|
|ProductCategoryId|ID категории товара|Поиск по ID категории|Высокая|NOT NULL, FOREIGN KEY ProductCategory.ID, INTEGER|

#### Индексы:
- CREATE INDEX "idx_ProductsId_ProductCategoryId" ON "ProductsProductCategory" ("ProductsId", "ProductCategoryId");


### *ChequePayment - Позиция в чеке*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|ChequeId|ID Чека|Поиск по ID чека|Высокая|NOT NULL, FOREIGN KEY Cheque.ID, INTEGER|
|PaymentTypeId|ID типа оплаты|Поиск по ID типа оплаты|Низкая|NOT NULL, FOREIGN KEY PaymentType.ID, INTEGER|
|Discount|Скида на платёж|Поиск по скидки на платёж|Низкая|VARCHR(255)|
|Amount|Сумма средств переданных для оплаты (отрицательная, в случае возврата)|Поиск по сумме платежа|Высокая|NOT NULL, REAL|
|Change|Сдача|Поиск по сумме сдачи|Средняя|REAL, CHECK (Price > 0)|

#### Индексы:
- CREATE INDEX "idx_ChequeId" ON "ChequePayment" ("ChequeId");
- CREATE INDEX "idx_Amount" ON "ChequePayment" ("Amount");

### *PaymentType - Справочник типов оплаты*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|PaymentName|Наименование оплаты|Поиск по названию оплаты|Высокая|NOT NULL, UNIQUE, VARCHR(255)|
|Cashless|Признак безналичной оплаты|Поиск по признаку|Средняя|NOT NULL, BOOL|

### *Price - Справочник цен*

|Поле|Описание поля|Описание запроса|Кардинальность|Ограничения|
|--------|--------|--------|--------|--------|
|ID|Ключ|Поиск по ID|Высокая|PRIMARY KEY, UNIQUE, NOT NULL, INTEGER|
|ProductId|ID товара|Поиск по ID товара|Высокая|NOT NULL, FOREIGN KEY Product.ID, INTEGER|
|Price|цена за единицу товара|Поиск по чене товара|Низкая|NOT NULL, REAL, CHECK (Price > 0)|
|StartDate|Дата начала дейсвтия цены|Поиск по дате начала цены|Низкая|NOT NULL, DATE|
|EndDate|Дата окончания действия цены|Поиск по дате окончания цены|Низкая|DATE|

#### Индексы:
- CREATE INDEX "idx_ProductId" ON "Price" ("ProductId");
- CREATE INDEX "idx_Price" ON "Price" ("Price");