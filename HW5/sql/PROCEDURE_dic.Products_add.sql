CREATE OR REPLACE PROCEDURE dic.Products_add(product_data jsonb)
LANGUAGE plpgsql
AS $$
DECLARE
	product_record jsonb;
	product_name text;
	product_unit text;
	product_ean text;
	product_categories text[];
	product_price decimal(10,2);
--	price_start_date date;
--	price_end_date date;
	Price_List integer;
	unit_id integer;
	return_product_id integer;
	product_category text;
	product_category_id integer;
	required_keys text[] := ARRAY['Name', 'Unit', 'EAN', 'Category', 'Price'];
	required_key text;
	missing_keys text[];
BEGIN
    -- Проверяем валидность JSON
IF product_data IS NULL THEN
	RAISE EXCEPTION 'JSON data cannot be NULL';
END IF;
IF NOT (product_data ? 'Products') THEN
	RAISE EXCEPTION 'JSON must contain "Products" key';
END IF;
FOR product_record IN SELECT * FROM jsonb_array_elements(product_data->'Products')
LOOP
	-- Проверяем наличие обязательных ключей для каждого продукта
	missing_keys := ARRAY[]::text[];
	FOREACH required_key IN ARRAY required_keys
	LOOP
		IF NOT (product_record ? required_key) THEN
                missing_keys := array_append(missing_keys, required_key);
		END IF;
	END LOOP;
	-- Если есть отсутствующие ключи
	IF array_length(missing_keys, 1) > 0 THEN
		RAISE EXCEPTION 'Product % is missing required keys: %', product_record->>'Name',
		array_to_string(missing_keys, ', ');
	END IF;
	--- Задаём переенные
	product_name := product_record->>'Name';
	product_unit := product_record->>'Unit';
	product_ean := product_record->>'EAN';
	product_price := (product_record->>'Price')::decimal(10,2);
--	price_start_date := (product_record->>'PriceStart')::date;
--	price_end_date := (product_record->>'PriceEnd')::date;
	Price_List := product_record->> 'PriceList';
	product_categories := ARRAY(SELECT jsonb_array_elements_text(product_record->'Category'))::text[];
	IF EXISTS (SELECT 1 FROM dic."Products" WHERE "ProductName" = product_name) THEN
		RAISE NOTICE 'Product "%" already exists. skiped', product_name;
		CONTINUE;  -- Полностью пропускаем
	END IF;
	--- Начинаем Вставку
	RAISE NOTICE 'Processing: %', product_name;
	--- Получаем ID ед. измерения
	SELECT "ID"
	INTO unit_id
	FROM dic."ProductUnit"
	WHERE "UnitName" = product_unit;
	--- Добавляем товар в таблицу
	INSERT INTO dic."Products" ("ProductName", "ProductUnitId", "ean")
	VALUES (product_name, unit_id, product_ean)
	RETURNING "ID" INTO return_product_id;
	--- Вставляем Цены
	RAISE NOTICE '%, %, %', return_product_id, product_price, Price_List;
	INSERT INTO dic."Price" ("ProductId", "Price", "PriceListId")
	VALUES (return_product_id, product_price, Price_List);
	--- Начинаем вставлять категории
	FOREACH product_category  IN ARRAY product_categories
	LOOP
		--- Получаем ID категории
		SELECT "ID"
		INTO product_category_id
		FROM dic."ProductCategory"
		WHERE "CategoryName" = product_category;
		--- Вставляем в ProductsProductCategory ссылки на товары и категории
		INSERT INTO dic."ProductsProductCategory" ("ProductsId", "ProductCategoryId")
		VALUES (return_product_id, product_category_id);
	END LOOP;
END LOOP;
END;
$$;