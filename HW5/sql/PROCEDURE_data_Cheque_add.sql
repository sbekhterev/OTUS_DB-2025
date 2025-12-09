CREATE OR REPLACE PROCEDURE data.Cheque_add(Cheque_data jsonb)
LANGUAGE plpgsql
AS $$
DECLARE
ChequePositions_record jsonb;
ChequePayment_record jsonb;

StoreId_record integer;
ZNKKT_record text;
FNKKT_record bigint;
CashierId_record integer;
ChequeStart_record timestamp;
ChequeEnd_record timestamp;
ShiftDate_record date;
ChequeTypeId_record integer;
Discount_record text;
FDKKT_record integer;
TerminalId_record integer;
ShiftId_record integer;
current_FNKKT_record bigint;

ChequeId_record integer;
ProductId_record integer;
Amount_position_record integer;
PriceId_record integer;
Price_record decimal(10,2);
Discount_position_record text;

PaymentTypeID_record integer;
Amount_payment_record decimal(10,2);
Change_payment_record decimal(10,2);
Discount_payment_record text;
Cheque_id_record integer;

BEGIN
--- Определяем основные переменные
RAISE NOTICE 'Начинаем добавление чека';
StoreId_record := Cheque_data->>'StoreId';
ZNKKT_record := (Cheque_data->>'ZNKKT')::text;
FNKKT_record := Cheque_data->>'FNKKT';
CashierId_record := Cheque_data->>'CashierId';
ChequeStart_record := (Cheque_data->>'ChequeStart')::timestamp;
ChequeEnd_record := (Cheque_data->>'ChequeEnd')::timestamp;
ShiftDate_record := ChequeStart_record::date;
ChequeTypeId_record := Cheque_data->>'ChequeTypeId';
Discount_record := Cheque_data->>'Discount';
FDKKT_record := Cheque_data->>'FDKKT';
--- Получаем id терминала
SELECT t."ID"
INTO TerminalId_record
FROM  dic."Terminal" t
WHERE t."StoreId" = StoreId_record AND t."ZNKKT" = ZNKKT_record;
IF TerminalId_record IS NULL THEN
	RAISE EXCEPTION 'Терминал не найден для StoreId=% и ZNKKT=%', StoreId_record, ZNKKT_record;
END IF;
RAISE NOTICE 'Терминал найден: ID = %', TerminalId_record;
--- Проверяем открыта ли смена, если да, получаем её номер
SELECT s."ID"
INTO ShiftId_record
FROM data."Shift" s
WHERE s."TerminalId" = TerminalId_record
  and s."ZNKKT" = ZNKKT_record
  and s."ShiftEnd" is null;
IF ShiftId_record IS NULL THEN
	RAISE NOTICE 'Формируем новую сену для терминала %', TerminalId_record;
--- Проверяем что ФН актуальный, если нет, то обновляем
	SELECT t."FNKKT" INTO current_FNKKT_record FROM dic."Terminal" t WHERE t."ZNKKT" = ZNKKT_record;
	IF current_FNKKT_record IS DISTINCT FROM FNKKT_record THEN
		UPDATE dic."Terminal" SET "FNKKT" = FNKKT_record WHERE "ZNKKT" = ZNKKT_record;
		RAISE NOTICE 'ФН Терминала % был заменён', ZNKKT_record;
	END IF;
	INSERT INTO data."Shift" ("TerminalId", "ShiftDate", "ShiftStart", "ZNKKT", "FNKKT")
	VALUES (TerminalId_record, ShiftDate_record, ChequeStart_record, ZNKKT_record, FNKKT_record)
	RETURNING "ID" INTO ShiftId_record;
END IF;
RAISE NOTICE 'Добавляем чек в смену % для терминала %', ShiftId_record, TerminalId_record;
--- Создаём чек
INSERT INTO data."Cheque" ("ShiftId", "CashierId", "ChequeStart", "ChequeEnd", "ChequeTypeId", "Discount", "FDKKT")
VALUES (ShiftId_record, CashierId_record, ChequeStart_record, ChequeEnd_record, ChequeTypeId_record, Discount_record, FDKKT_record)
RETURNING "ID" INTO ChequeId_record;
--- Добавляем позиции чека
FOR ChequePositions_record IN SELECT * FROM jsonb_array_elements(Cheque_data->'ChequePositions')
LOOP
	ProductId_record := ChequePositions_record->>'ProductId';
	Amount_position_record := ChequePositions_record->>'Amount';
	PriceId_record := ChequePositions_record->>'PriceId';
	Price_record := ChequePositions_record->>'Price';
	Discount_position_record := ChequePositions_record->>'Discount';
	INSERT INTO data."ChequePositions" ("ChequeId", "ProductId", "Amount", "PriceId", "Price", "Discount")
	VALUES (ChequeId_record, ProductId_record, Amount_position_record, PriceId_record, Price_record, Discount_position_record);
	RAISE NOTICE 'Товар % в кол-ве % по цене % добавлен', ProductId_record, Amount_position_record, Price_record;
END LOOP;
---- Добавляем оплаты
ChequePayment_record := Cheque_data->'ChequePayment';
PaymentTypeID_record := ChequePayment_record->>'PaymentTypeID';
Amount_payment_record := ChequePayment_record->>'Amount';
Discount_payment_record := ChequePayment_record->>'Discount';
Change_payment_record := ChequePayment_record->>'Change';
INSERT INTO data."ChequePayment" ("ChequeId", "PaymentTypeId", "Discount", "Amount", "Change")
VALUES (ChequeId_record, PaymentTypeID_record, Discount_payment_record, Amount_payment_record, Change_payment_record);
RAISE NOTICE 'Оплаты чека % созданы', ChequeId_record;
END;
$$;