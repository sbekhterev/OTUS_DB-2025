# Транзакции, MVCC, ACID в MySQL 

## Описание/Пошаговая инструкция выполнения домашнего задания:
- Описать пример транзакции из своего проекта с изменением данных в нескольких таблицах. Реализовать в виде хранимой процедуры.
- Загрузить данные из приложенных в материалах csv.
- Реализовать следующими путями:
  - LOAD DATA
  - Задание со *: загрузить используя mysqlimport

## Описать пример транзакции из своего проекта с изменением данных в нескольких таблицах. Реализовать в виде хранимой процедуры.
Создаём хранимую процедуру добавления товара из JSON:
```amplicode sql
DELIMITER $$
CREATE PROCEDURE products_add(IN product_data JSON)
BEGIN
DECLARE json_len INT;
DECLARE product_obj JSON;
DECLARE categories_arr JSON;
DECLARE i INT DEFAULT 0;
DECLARE j INT;
DECLARE P_Name VARCHAR(255);
DECLARE P_Unit VARCHAR(255);
DECLARE P_Category VARCHAR(255);
DECLARE P_Unit_id INT;
DECLARE P_Products_id INT;
DECLARE P_PriceList INT;
DECLARE cat_total INT;
DECLARE P_Price DECIMAL(12,2);
DECLARE P_EAN VARCHAR(255);
SET AUTOCOMMIT=0;
START TRANSACTION;
SET json_len = JSON_LENGTH(product_data, '$.Products');
WHILE i < json_len DO
	SET product_obj = JSON_EXTRACT(product_data, CONCAT('$.Products[', i, ']'));
	SET P_Name = JSON_UNQUOTE(JSON_EXTRACT(product_obj, '$.Name'));
	SET P_Unit = JSON_UNQUOTE(JSON_EXTRACT(product_obj, '$.Unit'));
	SET P_EAN = JSON_UNQUOTE(JSON_EXTRACT(product_obj, '$.EAN'));
	SET P_Price = JSON_UNQUOTE(JSON_EXTRACT(product_obj, '$.Price'));
	SET P_PriceList = JSON_UNQUOTE(JSON_EXTRACT(product_obj, '$.PriceList'));
	SELECT Id INTO P_Unit_id FROM ProductUnit WHERE UnitName = P_Unit LIMIT 1;
 	INSERT INTO Products (ProductName, ProductUnitId, EAN) VALUES (P_Name, P_Unit_id, P_EAN); -- Добавляем в таблицу товаров
	SELECT Id INTO P_Products_id FROM Products WHERE ProductName = P_Name LIMIT 1; -- Получаем ID товара
	INSERT INTO Price (Price, PriceListId, ProductId) VALUES (P_Price, P_PriceList, P_Products_id); -- Добавляем Цену
	SET categories_arr = JSON_EXTRACT(product_obj, '$.Category');
	SET cat_total = JSON_LENGTH(categories_arr);
	SET j = 0;
	WHILE j < cat_total DO
		SET P_Category = JSON_UNQUOTE(JSON_EXTRACT(categories_arr, CONCAT('$[', j, ']')));
		SELECT ID INTO @cat_id FROM ProductCategory WHERE CategoryName = P_Category; -- Получаем ID категории
		INSERT INTO ProductsProductCategory (ProductCategoryId, ProductsId) VALUES (@cat_id, P_Products_id); -- Связываем категорию и товар
		SET j = j + 1;
	END WHILE;
	SET i = i + 1;
END WHILE;
COMMIT;
END$$
DELIMITER ;
```
Выполняем:
```amplicode sql
CALL products_add('{"Products":[{"Name":"Кока-Кола 0.5л","Unit":"шт","Category":["Напитки"],"Price":150,"EAN":"4600000000001","PriceList":1},{"Name":"Пепси 1л","Unit":"шт","Category":["Напитки"],"Price":180,"EAN":"4600000000002","PriceList":1}]}');
```
Проверяем:
```amplicode sql
SELECT p.ID, p.ProductName, p.EAN, pu.UnitName, p2.Price, pc.CategoryName  
  FROM Products p 
  JOIN ProductUnit pu ON pu.ID = p.ProductUnitId 
  JOIN Price p2 ON p2.ProductId = p.ID 
  JOIN ProductsProductCategory ppc ON ppc.ProductsId = p.ID 
  JOIN ProductCategory pc ON pc.ID = ppc.ProductCategoryId 
 WHERE p.ProductName in ('Кока-Кола 0.5л', 'Пепси 1л');
```
| ID | ProductName    | EAN           | UnitName | Price  | CategoryName |
|----|----------------|---------------|----------|--------|--------------|
| 13 | Кока-Кола 0.5л | 4600000000001 | шт       | 150.00 | Напитки      |
| 14 | Пепси 1л       | 4600000000002 | шт       | 180.00 | Напитки      |

## Загрузить данные из приложенных в материалах csv.
Копируем [файл](./csv/users-39289-1025cc.csv) в контейнер:
```shell
docker cp ./csv/users-39289-1025cc.csv otusdb:/var/lib/mysql/users.csv
```
Создаём БД HW12, переключаемся на неё и создаём таблицу Users:
```amplicode sql
mysql> CREATE DATABASE HW12;
Query OK, 1 row affected (0.02 sec)
mysql> use HW12;
Database changed
mysql> CREATE TABLE IF NOT EXISTS users (
    ->     user VARCHAR(32) NOT NULL PRIMARY KEY,
    ->     city VARCHAR(32)
    -> );
Query OK, 0 rows affected (0.05 sec)
```
Проверяем что настройки безопасности корректны и выполняем команду LOAD DATA:
```amplicode sql
mysql> SHOW VARIABLES LIKE "secure_file_priv";
+------------------+-----------------+
| Variable_name    | Value           |
+------------------+-----------------+
| secure_file_priv | /var/lib/mysql/ |
+------------------+-----------------+
1 row in set (0.01 sec)

mysql> LOAD DATA INFILE '/var/lib/mysql/users.csv'
    -> INTO TABLE users
    -> FIELDS TERMINATED BY ',';
Query OK, 3 rows affected (0.01 sec)
Records: 3  Deleted: 0  Skipped: 0  Warnings: 0

```
Проверяем: 
```amplicode sql
mysql> SELECT * FROM users;
```
| user              | city      |
|-------------------|-----------|
| admin@example.com | Москва    |
| guest@example.com |           |
| user@example.com  | Волгоград |

## Задание со *: загрузить используя mysqlimport
Выполняем команду:
```shell
docker-compose exec otusdb mysqlimport --delete --fields-terminated-by=','  -u root -p HW12 /var/lib/mysql/users.csv
```
Проверяем:
```shell
docker-compose exec otusdb mysql -u root -p HW12 -e 'SELECT * FROM users;'
```
| user              | city      |
|-------------------|-----------|
| admin@example.com | Москва    |
| guest@example.com |           |
| user@example.com  | Волгоград |