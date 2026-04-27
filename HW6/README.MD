# Индексы PostgreSQL

## Создать индекс к какой-либо из таблиц вашей БД

1. Используем ранее созданую таблицу 
    ```amplicode sql
    CREATE TABLE dic."Products" (
	\*"ID" int4 DEFAULT nextval('dic.dic_seq'::regclass) NOT NULL,
	\*"ProductName" varchar(255) NOT NULL,
	\*"ProductUnitId" int4 NOT NULL,
	\*ean varchar NOT NULL,
	\*CONSTRAINT "Products_ProductName_key" UNIQUE ("ProductName"),
	\*CONSTRAINT "Products_ean_key" UNIQUE (ean),
	\*CONSTRAINT "Products_pkey" PRIMARY KEY ("ID")
    );
   ```