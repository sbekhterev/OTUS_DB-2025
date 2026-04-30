# Индексы PostgreSQL

## Создать индекс к какой-либо из таблиц вашей БД

1. Используем ранее созданую таблицу 
    ```amplicode sql
    CREATE TABLE dic."Products" (
	"ID" int4 DEFAULT nextval('dic.dic_seq'::regclass) NOT NULL,
	"ProductName" varchar(255) NOT NULL,
	"ProductUnitId" int4 NOT NULL,
	ean varchar NOT NULL);
   ```

   
2. Заполним данными (использовал ранее написаную хранимую [Products_add](https://github.com/sbekhterev/OTUS_DB-2025/blob/5b90d09411e5e8233f89b167b5827c75ece09761/HW5/sql/PROCEDURE_dic.Products_add.sql) 
   и скрипт [add_product](https://github.com/sbekhterev/OTUS_DB-2025/blob/6329f13431c3c839be152073ebc1e6568b65743a/Project/add_product.py))


3. Создадим индекс по полю ProductName:
   ```amplicode sql
   create index "idx_ProductName" on dic."Products" ("ProductName");
   ```
   
## Прислать текстом результат команды explain, в которой используется данный индекс


   ```amplicode sql
    explain
    select p."ProductName" from "Products" p where p."ProductName" = 'Салат Мимоза';
   ```
   ```
   QUERY PLAN                                                                                |
   ------------------------------------------------------------------------------------------+
   Index Only Scan using "idx_ProductName" on "Products" p  (cost=0.42..8.44 rows=1 width=30)|
     Index Cond: ("ProductName" = 'Салат Мимоза'::text)                                      |
   ```


## Реализовать индекс для полнотекстового поиска


1. Добавляем расширение pg_trgm:
   ```amplicode sql
   create extension if not exists pg_trgm;
   ```


2. Создаём индекс:
   ```amplicode sql
   create index "gin_idx_ProductName" on dic."Products" using gin ("ProductName" gin_trgm_ops);
   ```
   

3. Результат команды explain:
   ```amplicode sql
   explain
   select p."ProductName" from "Products" p where p."ProductName" ~ '%салат%';
   ```
   ```amplicode sql
   QUERY PLAN                                                                          |
   ------------------------------------------------------------------------------------+
   Bitmap Heap Scan on "Products" p  (cost=47.61..96.01 rows=13 width=30)              |
     Recheck Cond: (("ProductName")::text ~ '%салат%'::text)                           |
     ->  Bitmap Index Scan on "gin_idx_ProductName"  (cost=0.00..47.60 rows=13 width=0)|
           Index Cond: (("ProductName")::text ~ '%салат%'::text)                       |
   ```
   

## Реализовать индекс на часть таблицы или индекс на поле с функцией


1. Используем таблицу кассиров:
   ```amplicode sql
    CREATE TABLE dic."Cashier" (
	    "ID" int4 DEFAULT nextval('dic.dic_seq'::regclass) NOT NULL,
	    "FirstName" varchar(255) NOT NULL,
	    "LastName" varchar(255) NOT NULL,
	    "PatronymicName" varchar(255) NULL,
    	"Hiring" date NOT NULL,
    	"Firing" date NULL,
	    "RoleId" int4 NOT NULL,
    	CONSTRAINT "Cashier_pkey" PRIMARY KEY ("ID"));
   ```
   

3. Заполняем тестовыми данными [add_cashier](HW6/add_cashier.py):



4. Создаём индекс для поиска по ФИО кассиров с приведением первой буквы каждого слова к заглавной  для быстрого поиска:
   ```amplicode sql
   create index "idx_fio_Cashier" on dic."Cashier" 
   (initcap("FirstName" || ' ' || "LastName" || ' ' ||coalesce("PatronymicName", '')));
   ``` 


5. Результат команды explain:
   ```amplicode sql
   explain
   select * from dic."Cashier" c 
   where initcap("FirstName" || ' ' || "LastName" || ' ' ||coalesce("PatronymicName", ''))
   = 'Мирон Федоров Тимофеевич';
   ```
   ```amplicode sql
   QUERY PLAN                                                                                                                                                                                          |
   ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   Index Scan using "idx_fio_Cashier" on "Cashier" c  (cost=0.42..8.44 rows=1 width=65)                                                                                                                |
     Index Cond: (initcap(((((("FirstName")::text || ' '::text) || ("LastName")::text) || ' '::text) || (COALESCE("PatronymicName", ''::character varying))::text)) = 'Мирон Федоров Тимофеевич'::text)|
   ```
   

## Создать индекс на несколько полей


1. Создадим индекс для поска по фио и дате найма:
   ```amplicode sql
   create index "idx_hiring_cashiers" on dic."Cashier" 
   (("FirstName" || ' ' || "LastName" || ' ' ||coalesce("PatronymicName", '')), "Hiring");
   ```
   
2. Результат команды explain:
   ```amplicode sql
   explain
    select * from dic."Cashier" c 
     where ("FirstName" || ' ' || "LastName" || ' ' ||coalesce("PatronymicName", '')) = 'Мирон Федоров Тимофеевич' 
       and c."Hiring" > '2000-01-01';
   ```
   ```
   QUERY PLAN                                                                                                                                                                                                                       |
   ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   Index Scan using idx_hiring_cashiers on "Cashier" c  (cost=0.42..8.44 rows=1 width=65)                                                                                                                                           |
     Index Cond: ((((((("FirstName")::text || ' '::text) || ("LastName")::text) || ' '::text) || (COALESCE("PatronymicName", ''::character varying))::text) = 'Мирон Федоров Тимофеевич'::text) AND ("Hiring" > '2000-01-01'::date))|
   ```
   

## Написать комментарии к каждому из индексов


Комментарии даны


## Описать что и как делали и с какими проблемами столкнулись


Для корректной работы индексов в таблице должны быть записи.
При работе с функциями, запрос должен сожержать точно такую же функцию.