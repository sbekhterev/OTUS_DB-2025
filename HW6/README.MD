# Индексы PostgreSQL

## Создать индекс к какой-либо из таблиц вашей БД

1. Используем ранее созданую таблицу 
    ```amplicode sql
    CREATE TABLE dic."Products" (
	"ID" int4 DEFAULT nextval('dic.dic_seq'::regclass) NOT NULL,
	"ProductName" varchar(255) NOT NULL,
	"ProductUnitId" int4 NOT NULL,
	ean varchar NOT NULL,
	CONSTRAINT "Products_ProductName_key" UNIQUE ("ProductName"),
	CONSTRAINT "Products_ean_key" UNIQUE (ean),
	CONSTRAINT "Products_pkey" PRIMARY KEY ("ID")
    );
   ```
   
2. Заполним данными (использовал ранее написаную хранимую [Products_add](https://github.com/sbekhterev/OTUS_DB-2025/blob/5b90d09411e5e8233f89b167b5827c75ece09761/HW5/sql/PROCEDURE_dic.Products_add.sql) 
   и скрипт [add_product](https://github.com/sbekhterev/OTUS_DB-2025/blob/6329f13431c3c839be152073ebc1e6568b65743a/Project/add_product.py))