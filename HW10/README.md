# Типы данных в MySQL.

## Цель:

### Подбирать нужные типы данных;
- Определиться с типом ID
- Изучить тип JSON.

### Описание/Пошаговая инструкция выполнения домашнего задания:
- проанализировать типы данных в своем проекте, изменить при необходимости. В README указать что на что поменялось и почему.
- добавить тип JSON в структуру. Проанализировать какие данные могли бы там хранится. привести примеры SQL для добавления записей и выборки.

## Проанализировать типы данных в своем проекте

- Для большинства идентификаторов строк в таблицах выбран тип int, unsigned, auto_increment. Т.к. в них не ожидается 
большое кол-во данных.
- Для таблиц: Cheque (чеки), ChequePayment (платежи по чекам), ChequePositions (позиции в чеке), Products (продукты) и 
Shift (смены) идентификаторы типа bigint, unsigned, auto_increment.
```
ALTER TABLE Cheque modify column ID bigint unsigned auto_increment;
ALTER TABLE ChequePayment modify column ID bigint unsigned auto_increment;
ALTER TABLE ChequePositions modify column ID bigint unsigned auto_increment;
ALTER TABLE Products modify column ID bigint unsigned auto_increment;
ALTER TABLE Shift modify column ID bigint unsigned auto_increment;
ALTER TABLE ProductsProductCategory modify column ProductsId bigint unsigned not null;
```

### По созданным таблицам:

#### *Address - Адреса магазинов*

| Field            | Type             | Null | Key | Default | Extra          | Описание                                                    |
|------------------|------------------|------|-----|---------|----------------|-------------------------------------------------------------|
| ID               | int(10) unsigned | NO   | PRI |         | auto_increment | Ключ, обычное целое число, автоинкремент                    |
| RegionId         | int(10) unsigned | NO   |     |         |                | ID Региона, ключ                                            |
| PostalCodeId     | int(10) unsigned | NO   |     |         |                | Почтовый код, цифровой, внешний ключ                        |
| City             | varchar(150)     | NO   |     |         |                | Наименование города, текстовый, переменный до 150 знаков    |
| CityTypeId       | int(10) unsigned | NO   |     |         |                | ID типа города, цифровой, внешний ключ                      |
| Settelment       | varchar(150)     | NO   |     |         |                | Наименование поселения, текстовый, переменный до 150 знаков |
| SettelmentTypeId | int(10) unsigned | NO   |     |         |                | ID Типа поселения, цифровой, внешний ключ                   |
| Street           | varchar(150)     | NO   |     |         |                | Наименование улицы, текстовый, переменный до 150 знаков     |
| StreetTypeId     | int(10) unsigned | NO   |     |         |                | ID типа улицы, цифровой, внешний ключ                       |
| House            | varchar(150)     | YES  |     |         |                | Номер дома, текстовый, переменный до 150 знаков             |
 
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Address modify column RegionId int(10) unsigned not null;
ALTER TABLE Address modify column PostalCodeId int(10) unsigned not null;
ALTER TABLE Address modify column CityTypeId int(10) unsigned not null;
ALTER TABLE Address modify column StreetTypeId int(10) unsigned not null;
ALTER TABLE Address modify column SettelmentTypeId int(10) unsigned not null;
ALTER TABLE Address ADD FOREIGN KEY (RegionId) REFERENCES Region (ID);
ALTER TABLE Address ADD FOREIGN KEY (PostalCodeId) REFERENCES PostalCode (ID);
ALTER TABLE Address ADD FOREIGN KEY (CityTypeId) REFERENCES CityType (ID);
ALTER TABLE Address ADD FOREIGN KEY (StreetTypeId) REFERENCES StreetType (ID);
ALTER TABLE Address ADD FOREIGN KEY (SettelmentTypeId) REFERENCES SettelmentType (ID);
```

#### *Cashier - Справочник кассиров*

| Field          | Type             | Null | Key | Default | Extra          | Описание                                             |
|----------------|------------------|------|-----|---------|----------------|------------------------------------------------------|
| ID             | int(10) unsigned | NO   | PRI |         | auto_increment | ID кассира, ключ, обычное целое число, автоинкремент |
| FirstName      | varchar(255)     | NO   |     |         |                | Имя, текстовый, переменный до 255 знаков             |
| LastName       | varchar(255)     | NO   |     |         |                | Фамилия, текстовый, переменный до 255 знаков         |
| PatronymicName | varchar(255)     | YES  |     |         |                | Отчество, текстовый, переменный до 255 знаков        |
| Hiring         | date             | NO   |     |         |                | Дата найма, дата                                     |
| Firing         | date             | YES  |     |         |                | Дата увольнения, дата                                |
| RoleId         | int(10) unsigned | NO   |     |         |                | Должность, цифровой, внешний ключ                    |

Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Cashier modify column RoleId int(10) unsigned not null;
ALTER TABLE Cashier ADD FOREIGN KEY (RoleId) REFERENCES Role (ID);
```

#### *Cheque - кассовые чеки*

| Field        | Type                | Null | Key | Default | Extra          | Описание                                                   |
|--------------|---------------------|------|-----|---------|----------------|------------------------------------------------------------|
| ID           | bigint(20) unsigned | NO   | PRI |         | auto_increment | ID Чека, ключ, большое целое число, автоинкремент          |
| ShiftId      | int(11)             | NO   |     |         |                | ID смены чека, цифровой, внешний ключ                      |
| CashierId    | int(11)             | NO   |     |         |                | ID кассира, цифровой, внешний ключ                         |
| ChequeStart  | timestamp           | NO   |     |         |                | Дата и время открытия чека, временная метка                |
| ChequeEnd    | timestamp           | YES  |     |         |                | Дата и время закрытия чека, временная метка                |
| ChequeTypeId | int(11)             | NO   |     |         |                | ID типа чека, цифровой, внешний ключ                       |
| Discount     | varchar(255)        | YES  |     |         |                | Скидка чека, текстовый, переменный до 255 знаков           |
| FDKKT        | bigint(20)          | YES  |     |         |                | Номер фискального документа, цифровой, большое целое число |
| PriceListId  | int(11)             | NO   |     |         |                | ID прайс-листа в чеке, цифровой, внешний ключ              |

Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Cheque modify column ShiftId int(10) unsigned not null;
ALTER TABLE Cheque modify column CashierId int(10) unsigned not null;
ALTER TABLE Cheque modify column ChequeTypeId int(10) unsigned not null;
ALTER TABLE Cheque modify column PriceListId int(10) unsigned not null;
ALTER TABLE Cheque ADD FOREIGN KEY (ShiftId) REFERENCES Region (ID);
ALTER TABLE Cheque ADD FOREIGN KEY (CashierId) REFERENCES PostalCode (ID);
ALTER TABLE Cheque ADD FOREIGN KEY (ChequeTypeId) REFERENCES CityType (ID);
ALTER TABLE Cheque ADD FOREIGN KEY (PriceListId) REFERENCES StreetType (ID);
```

#### *ChequePayment - платежи в чеках*

| Field         | Type                | Null | Key | Default | Extra          | Описание                                             |
|---------------|---------------------|------|-----|---------|----------------|------------------------------------------------------|
| ID            | bigint(20) unsigned | NO   | PRI |         | auto_increment | ID платежа, ключ, большое целое число, автоинкремент |
| ChequeId      | int(11)             | YES  |     |         |                | ID Чека, цифровой, внешний ключ                      |
| PaymentTypeId | int(11)             | NO   |     |         |                | ID типа оплаты, цифровой, внешний ключ               |
| Discount      | varchar(255)        | YES  |     |         |                | Скида на платёж, текстовый, переменный до 255 знаков |
| Amount        | double              | NO   |     |         |                | Сумма средств для оплаты                             |
| Change        | double              | YES  |     |         |                | Сдача                                                |

Первое что видим, что Amount и Change используют double, вместо decimal, это может привести к ошибкам округления.
Исправим это:
```
ALTER TABLE ChequePayment modify column Amount decimal(12,2) not null;
ALTER TABLE ChequePayment modify column `Change` decimal(12,2);
```
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE ChequePayment modify column ChequeId bigint(20) unsigned not null;
ALTER TABLE ChequePayment modify column PaymentTypeId int(10) unsigned not null;
ALTER TABLE ChequePayment ADD FOREIGN KEY (ChequeId) REFERENCES Cheque (ID);
ALTER TABLE ChequePayment ADD FOREIGN KEY (PaymentTypeId) REFERENCES PaymentType (ID);
```

#### *ChequePositions - Позиция в чеке*

| Field     | Type                | Null | Key | Default | Extra          | Описание                                                     |
|-----------|---------------------|------|-----|---------|----------------|--------------------------------------------------------------|
| ID        | bigint(20) unsigned | NO   | PRI |         | auto_increment | ID платежа, ключ, большое целое число, автоинкремент         |
| ChequeId  | int(11)             | NO   |     |         |                | ID Чека, цифровой, внешний ключ                              |
| ProductId | int(11)             | NO   |     |         |                | ID товара цифровой, внешний ключ                             |
| Amount    | double              | NO   |     |         |                | Кол-во товара                                                |
| PriceId   | bigint(20)          | NO   |     |         |                | ID Цены товара цифровой, внешний ключ                        |
| Price     | double              | NO   |     |         |                | Цена товара                                                  |
| Discount  | varchar(255)        | YES  |     |         |                | Скидка на позицию товара текстовый, переменный до 255 знаков |
Так же меняем тип у Price (decimal(12,2)) и Amount (decimal(8,3))
```
ALTER TABLE ChequePositions modify column Amount decimal(8,3) not null;
ALTER TABLE ChequePositions modify column Price decimal(12,2) not null;
```
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE ChequePositions modify column ChequeId bigint(20) unsigned not null;
ALTER TABLE ChequePositions modify column ProductId bigint(20) unsigned not null;
ALTER TABLE ChequePositions modify column PriceId int(10) unsigned not null;
ALTER TABLE ChequePositions ADD FOREIGN KEY (ChequeId) REFERENCES Cheque (ID);
ALTER TABLE ChequePositions ADD FOREIGN KEY (ProductId) REFERENCES Products (ID);
ALTER TABLE ChequePositions ADD FOREIGN KEY (PriceId) REFERENCES Price (ID);
```

#### *ChequeType - Справочник типов чека*

| Field      | Type             | Null | Key | Default | Extra          | Описание                                                    |
|------------|------------------|------|-----|---------|----------------|-------------------------------------------------------------|
| ID         | int(10) unsigned | NO   | PRI |         | auto_increment | ID типа чека, ключ, обычное целое число, автоинкремент      |
| ChequeType | varchar(255)     | NO   | UNI |         |                | Наименование типа чека, текстовый, переменный до 255 знаков |

#### *CityType - Справочник типов городов*

| Field       | Type             | Null | Key | Default | Extra          | Описание                                                             |
|-------------|------------------|------|-----|---------|----------------|----------------------------------------------------------------------|
| ID          | int(10) unsigned | NO   | PRI |         | auto_increment | ID типа населённого пункта, ключ, обычное целое число, автоинкремент |
| CityType    | varchar(10)      | NO   | UNI |         |                | Тип гороода скоращённый, текстовый, переменный до 10 знаков          |
| Description | varchar(50)      | NO   | UNI |         |                | Тип гороода полный, текстовый, переменный до 50 знаков               |

#### *PaymentType - Справочник типов оплаты*

| Field       | Type             | Null | Key | Default | Extra          | Описание                                                 |
|-------------|------------------|------|-----|---------|----------------|----------------------------------------------------------|
| ID          | int(10) unsigned | NO   | PRI |         | auto_increment | ID типа оплаты, ключ, обычное целое число, автоинкремент |
| PaymentName | varchar(255)     | NO   | UNI |         |                | Наименование оплаты, текстовый, переменный до 255 знаков |
| Cashless    | tinyint(1)       | NO   |     |         |                | Признак безналичной оплаты, малое целое число            |

#### *PostalCode - Справочник почтовый индексов*

| Field      | Type             | Null | Key | Default | Extra          | Описание                                                       |
|------------|------------------|------|-----|---------|----------------|----------------------------------------------------------------|
| ID         | int(10) unsigned | NO   | PRI |         | auto_increment | ID постового индекса, ключ, обычное целое число, автоинкремент |
| PostalCode | varchar(10)      | NO   |     |         |                | Почтовый индекс, текстовый, переменный до 10 знаков            |

#### *Price - Справочник цен*

| Field       | Type             | Null | Key | Default | Extra          | Описание                                                       |
|-------------|------------------|------|-----|---------|----------------|----------------------------------------------------------------|
| ID          | int(10) unsigned | NO   | PRI |         | auto_increment | ID постового индекса, ключ, обычное целое число, автоинкремент |
| PriceListId | int(11)          | YES  |     |         |                | ID прайс-листа в чеке, цифровой, внешний ключ                  |
| ProductId   | int(11)          | NO   |     |         |                | ID товара  цифровой, внешний ключ                              |
| Price       | double           | NO   |     |         |                | Цена товара                                                    |
Так же меняем тип у Price (decimal(12,2))
```
ALTER TABLE Price modify column Price decimal(12,2) not null;
```
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Price modify column PriceListId int(10) unsigned not null;
ALTER TABLE Price modify column ProductId bigint(20) unsigned not null;
ALTER TABLE Price ADD FOREIGN KEY (PriceListId) REFERENCES PriceList (ID);
ALTER TABLE Price ADD FOREIGN KEY (ProductId) REFERENCES Products (ID);
```

#### *ProductCategory - Справочник категорий товаров*

| Field          | Type             | Null | Key | Default | Extra          | Описание                                                      |
|----------------|------------------|------|-----|---------|----------------|---------------------------------------------------------------|
| ID             | int(10) unsigned | NO   | PRI |         | auto_increment | ID категории товара, ключ, обычное целое число, автоинкремент |
| CategoryName   | varchar(255)     | NO   |     |         |                | Наименование категории, текстовый, переменный до 255 знаков   |
| ParentCategory | int(10)          | YES  |     |         |                | Родительская категория, обычное целое число                   |

#### *ProductUnit - Справочник единиц измерения товра*

| Field    | Type             | Null | Key | Default | Extra          | Описание                                                              |
|----------|------------------|------|-----|---------|----------------|-----------------------------------------------------------------------|
| ID       | int(10) unsigned | NO   | PRI |         | auto_increment | ID единицы измерений товара, ключ, обычное целое число, автоинкремент |
| UnitName | varchar(255)     | NO   | UNI |         |                | Наименование еденицы, текстовый, переменный до 255 знаков             |
| UnitType | varchar(255)     | NO   | UNI |         |                | Тип единцы, текстовый, переменный до 255 знаков                       |

#### *Products - Справочни товара*

| Field         | Type                | Null | Key | Default | Extra          | Описание                                             |
|---------------|---------------------|------|-----|---------|----------------|------------------------------------------------------|
| ID            | bigint(20) unsigned | NO   | PRI |         | auto_increment | ID товара, ключ, большое целое число, автоинкремент  |
| ProductName   | varchar(255)        | NO   | UNI |         |                | Наименование, текстовый, переменный до 255 знаков    |
| ProductUnitId | int(11)             | NO   |     |         |                | ID единицы измерения товара, цифровой, внешний ключ  |
| EAN           | varchar(255)        | NO   | UNI |         |                | Штрихкод товара, текстовый, переменный до 255 знаков |
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Products modify column ProductUnitId int(10) unsigned not null;
ALTER TABLE Products ADD FOREIGN KEY (ProductUnitId) REFERENCES ProductUnit (ID);
```

#### *ProductsProductCategory - Таблица связи товаров и категорий*

| Field             | Type                | Null | Key | Default | Extra | Описание                                               |
|-------------------|---------------------|------|-----|---------|-------|--------------------------------------------------------|
| ProductsId        | bigint(20) unsigned | NO   |     |         |       | ID товара, большое целое число, внешний ключ           |
| ProductCategoryId | int(11)             | NO   |     |         |       | ID категории товара, большое целое число, внешний ключ |
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE ProductsProductCategory modify column ProductsId bigint(20) unsigned not null;
ALTER TABLE ProductsProductCategory modify column ProductCategoryId int(10) unsigned not null;
ALTER TABLE ProductsProductCategory ADD FOREIGN KEY (ProductsId) REFERENCES Products (ID);
ALTER TABLE ProductsProductCategory ADD FOREIGN KEY (ProductCategoryId) REFERENCES ProductCategory (ID);
```

#### *Region - Справочник регионы*

| Field           | Type             | Null | Key | Default | Extra          | Описание                                                             |
|-----------------|------------------|------|-----|---------|----------------|----------------------------------------------------------------------|
| ID              | int(10) unsigned | NO   | PRI |         | auto_increment | ID региона, ключ, обычное целое число, автоинкремент                 |
| RegionName      | varchar(150)     | NO   | UNI |         |                | Наименование региона, текстовый, переменный до 150 знаков            |
| RegionTypeId    | int(11)          | NO   |     |         |                | ID типа региона,  цифровой, внешний ключ                             |
| FederalDistrict | varchar(20)      | NO   |     |         |                | Наименование Федерального округа, текстовый, переменный до 20 знаков |
| TimeZone        | varchar(255)     | NO   |     |         |                | Временная зона, текстовый, переменный до 255 знаков                  |
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Region modify column RegionTypeId int(10) unsigned not null;
ALTER TABLE Region ADD FOREIGN KEY (RegionTypeId) REFERENCES RegionType (ID);
```

#### *RegionType - Справочник типов регионов*

| Field       | Type             | Null | Key | Default | Extra          | Описание                                                    |
|-------------|------------------|------|-----|---------|----------------|-------------------------------------------------------------|
| ID          | int(10) unsigned | NO   | PRI |         | auto_increment | ID типа региона, ключ, обычное целое число, автоинкремент   |
| RegionType  | varchar(10)      | NO   | UNI |         |                | Тип региона скоращённый, текстовый, переменный до 10 знаков |
| Description | varchar(50)      | NO   | UNI |         |                | Тип региона полный, текстовый, переменный до 50 знаков      |


#### *Role - Справочник ролей кассиров*

| Field    | Type             | Null | Key | Default | Extra          | Описание                                              |
|----------|------------------|------|-----|---------|----------------|-------------------------------------------------------|
| ID       | int(10) unsigned | NO   | PRI |         | auto_increment | ID роли, ключ, обычное целое число, автоинкремент     |
| RoleName | varchar(255)     | NO   | UNI |         |                | Имя роли кассира, текстовый, переменный до 255 знаков |

#### *SettelmentType - Справочник типов послений*

| Field          | Type             | Null | Key | Default | Extra          | Описание                                                      |
|----------------|------------------|------|-----|---------|----------------|---------------------------------------------------------------|
| ID             | int(10) unsigned | NO   | PRI |         | auto_increment | ID типа поселения, ключ, обычное целое число, автоинкремент   |
| SettelmentType | varchar(10)      | NO   | UNI |         |                | Тип поселения скоращённый, текстовый, переменный до 10 знаков |
| Description    | varchar(50)      | NO   | UNI |         |                | Тип поселения полный, текстовый, переменный до 50 знаков      |


#### *Shift - Кассовые смены*


| Field      | Type                | Null | Key | Default | Extra          | Описание                                                |
|------------|---------------------|------|-----|---------|----------------|---------------------------------------------------------|
| ID         | bigint(20) unsigned | NO   | PRI |         | auto_increment | ID товара, ключ, большое целое число, автоинкремент     |
| TerminalId | int(11)             | NO   |     |         |                | ID кассы, цифровой, внешний ключ                        |
| ShiftDate  | date                | NO   |     |         |                | Дата смены, дата                                        |
| ShiftStart | timestamp           | NO   |     |         |                | Дата и время открытия смены, таймштамп                  |
| ShiftEnd   | timestamp           | YES  |     |         |                | Дата и время закрытия смены, таймштамп                  |
| ZNKKT      | varchar(255)        | NO   |     |         |                | Заводской номер ККТ, текстовый, переменный до 10 знаков |
| FNKKT      | bigint(20)          | YES  |     |         |                | Регистрационный номер ККТ, большое целое число          |
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Shift modify column TerminalId int(10) unsigned not null;
ALTER TABLE Shift ADD FOREIGN KEY (TerminalId) REFERENCES Terminal (ID);
```

#### *Store - Магазины*

| Field        | Type             | Null | Key | Default | Extra          | Описание                                                                  |
|--------------|------------------|------|-----|---------|----------------|---------------------------------------------------------------------------|
| ID           | int(10) unsigned | NO   | PRI |         | auto_increment | ID магазина, ключ, большое целое число, автоинкремент                     |
| StoreName    | varchar(255)     | NO   | UNI |         |                | Произвольное название магазина, текстовый, переменный до 255 знаков       |
| Organization | varchar(255)     | NO   |     |         |                | Юр.лицо на которое отрыт магазин, текстовый, переменный до 255 знаков     |
| INN          | varchar(12)      | NO   |     |         |                | ИНН юр.лица или подразделения магаина, текстовый, переменный до 12 знаков |
| AddressId    | int(11)          | NO   |     |         |                | ID Адреса магазина, цифровой, внешний ключ                                |
| StartTime    | time             | NO   |     |         |                | Время открытия магазина, врнемя                                           |
| EndTime      | time             | NO   |     |         |                | Время завершения работы магазина, время                                   |
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Store modify column AddressId int(10) unsigned not null;
ALTER TABLE Store ADD FOREIGN KEY (AddressId) REFERENCES Address (ID);
```

#### *StreetType - Справочник типов улиц*

| Field       | Type             | Null | Key | Default | Extra          | Описание                                                  |
|-------------|------------------|------|-----|---------|----------------|-----------------------------------------------------------|
| ID          | int(10) unsigned | NO   | PRI |         | auto_increment | ID типа улицы, ключ, большое целое число, автоинкремент   |
| StreetType  | varchar(10)      | NO   | UNI |         |                | Тип улицы скоращённый, текстовый, переменный до 10 знаков |
| Description | varchar(50)      | NO   | UNI |         |                | Тип улицы полный, текстовый, переменный до 50 знаков      |

### *Terminal - Номер кассы*

| Field        | Type             | Null | Key | Default | Extra          | Описание                                                                       |
|--------------|------------------|------|-----|---------|----------------|--------------------------------------------------------------------------------|
| ID           | int(10) unsigned | NO   | PRI |         | auto_increment | ID кассы, ключ, большое целое число, автоинкремент                             |
| TerminalName | varchar(255)     | NO   |     |         |                | Имя кассы (номер, произвольное имя) текстовый, переменный до 255 знаков        |
| StoreId      | int(11)          | NO   |     |         |                | ID магазина, цифровой, внешний ключ                                            |
| ZNKKT        | varchar(50)      | NO   |     |         |                | Заводской номер Контрольно Кассовой Техники текстовый, переменный до 50 знаков |
| FNKKT        | bigint(20)       | YES  |     |         |                | Регистрационный номер ККТ, большое целое число                                 |
Создаём внешние ключи (проверяем что тип данных идентичен, добавляем значение свойство unsigned):
```
ALTER TABLE Terminal modify column StoreId int(10) unsigned not null;
ALTER TABLE Terminal ADD FOREIGN KEY (StoreId) REFERENCES Store (ID);
```
