# DML: вставка, обновление, удаление, выборка данных в PostgreSQL.

## Заполнение схемы словарей тестовыми данными

[SQL скрипт с тестовыми данными](sql/dic_test_data.sql)
[SQL скрипт хранимой процедуры добавления товара](./sql/PROCEDURE_dic.Products_add.sql)
[json файл с примерами товара](./sql/products.json)

## Задания:

1. Напишите запрос по своей базе с регулярным выражением, добавьте пояснение, что вы хотите найти.

   * Найти кассиров с латинскими буквами в ФИО:
   ```amplicode sql
   SELECT c."ID", c."FirstName", c."LastName", c."PatronymicName"
     FROM dic."Cashier" c
    WHERE concat(c."FirstName", c."LastName", c."PatronymicName") ~ '[A-Z,a-z]+';
   ```
   * Найти кассиров с латинскими буквами в ФИО и подсветить место ошибки:
   ```amplicode sql
    SELECT c."ID", 
           regexp_replace(concat(c."FirstName", ' ', c."LastName", ' ', c."PatronymicName"), '[A-Z,a-z]', '_','g')
      FROM dic."Cashier" c
     WHERE concat(c."FirstName", c."LastName", c."PatronymicName") ~ '[A-Z,a-z]+';
   ```
   
2. Напишите запрос по своей базе с использованием LEFT JOIN и INNER JOIN, 
   как порядок соединений в FROM влияет на результат? Почему?

   * Выведем ФИО кассира и если он старший кассир напишем его должность:
   ```amplicode sql
   SELECT concat(c."FirstName", ' ', c."LastName", ' ', c."PatronymicName") AS "ФИО",
	      r."RoleName" AS "Должность"
     FROM dic."Cashier" c
     LEFT JOIN (SELECT * FROM dic."Role" WHERE "RoleName" = 'Старший кассир') r ON r."ID" = c."RoleId";
   ```
   * В случае INNER JOIN у нас в данном запросе будут только старшие кассиры:
   ```amplicode sql
   SELECT concat(c."FirstName", ' ', c."LastName", ' ', c."PatronymicName") AS "ФИО",
	   r."RoleName" AS "Должность"
     FROM dic."Cashier" c
    INNER JOIN (SELECT * FROM dic."Role" WHERE "RoleName" = 'Старший кассир') r ON r."ID" = c."RoleId";
   ```
   Порядок соединения влияет на результат запроса. Так при LEFT JOIN будут выданы результаты для всех записей таблицы
   указанной первой (при RIGHT JOIN будут возвращены результаты второй таблицы). INNER JOIN вернёт только те записи,
   которые есть в обеих таблицах.

3. Напишите запрос на добавление данных с выводом информации о добавленных строках.
   (Пример из скрипта выше)
   ```amplicode sql
   INSERT INTO dic."Address" ("RegionId", "PostalCode", "City", "CityTypeId", "Street", "StreetTypeId", "House")
   VALUES
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Удмуртская'), '426019', 'Ижевск', 32, 'Западная', 33, '24'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Саратовская'), '410076', 'Саратов', 32, 'Верхняя', 33, '15'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Волгоградская'), '400012', 'Волгоград', 32, 'Дорожная', 33, '33'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Санкт-Петербург'), '197046', null, 32, 'Куйбышева', 33, '30'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Краснодарский'), '350910', 'Краснодар', 32, 'им. Пушкина', 33, '30'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Пермский'), '614058', 'Пермь', 32, 'Озерная', 33, '11'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Волгоградская'), '400066', 'Волгоград', 32, 'Труда', 33, '42'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Татарстан'), '420012', 'Казань', 32, 'Овражная', 33, '27'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Саратовская'), '410050', 'Саратов', 32, 'Красноармейская', 33, '29'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Ростовская'), '344011', 'Ростов-на-Дону', 32, 'Красноармейская', 33, '17'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Башкортостан'), '450052', 'Уфа', 32, 'Дзержинского', 33, '50'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Татарстан'), '420099', 'Казань', 32, 'Почтовая', 33, '42'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Воронежская'), '394011', 'Воронеж', 32, 'Речная', 33, '16'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Воронежская'), '394030', 'Воронеж', 32, 'Средне-Московская', 33, '7'),
   ((SELECT "ID" FROM "Region" WHERE "RegionName" = 'Пермский'), '614000', 'Пермь', 32, 'Механизаторов', 33, '44')
   RETURNING *;
   ```

4. Напишите запрос с обновлением данные используя UPDATE FROM.
   (Пример из скрипта выше)
   ```amplicode sql
   INSERT INTO dic."Store" ("StoreName", "AddressId", "INN", "Organization", "StartTime", "EndTime")
   SELECT concat('Магазин-', 
                  COALESCE(a."Settelment", a."City", 
                          (SELECT r."RegionName"  FROM dic."Region" r WHERE r."ID" = a."RegionId")),
                  '-', a."Street" ) AS store_name,
          a."ID", 
          '7725858900' AS inn, 
          'ООО "Ромашка"' AS org, 
          '09:00' AS StartTime, 
          '23:00' AS EndTime
   FROM dic."Address" a
   ON CONFLICT DO NOTHING;
   ```

5. Напишите запрос для удаления данных с оператором DELETE используя join с другой таблицей с помощью using.
   
   * Вставим новое значение в таблицу dic."CityType". С этим значением нет связи в таблице dic."Address".
   ```amplicode sql
   INSERT INTO dic."CityType" ("CityType", "CityTypeFull" ) VALUES ('пгт', 'Посёлок городского типа');
   ```
   
   * Удалим все значения из таблицы dic."CityType" на которые не ссылаются в таблице dic."Address".
   ```amplicode sql
   DELETE FROM "CityType" ct  
    USING dic."Address" a
    WHERE a."CityTypeId" <> ct."ID";
   ```
   
6. Приведите пример использования утилиты COPY

   ```amplicode sql
   COPY (SELECT * FROM dic."CityType" ct) TO '/var/lib/postgresql/data/res_copy.csv' WITH CSV HEADER;
   ```