CREATE SCHEMA IF NOT EXISTS "dic";
CREATE SCHEMA IF NOT EXISTS "data";
CREATE TABLE IF NOT EXISTS "dic"."Region" (
  "ID" integer PRIMARY KEY,
  "RegionName" varchar(150) UNIQUE NOT NULL,
  "RegionTypeId" integer NOT NULL,
  "FederalDistrict" varchar(20) NOT NULL,
  "TimeZone" varchar NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."RegionType" (
  "ID" integer PRIMARY KEY,
  "RegionType" varchar(10) UNIQUE NOT NULL,
  "RegionTypeFull" varchar(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."Address" (
  "ID" integer PRIMARY KEY,
  "RegionId" integer NOT NULL,
  "PostalCode" varchar(10) NOT NULL,
  "City" varchar(150) NOT NULL,
  "CityTypeId" integer NOT NULL,
  "Settelment" varchar(150) NOT NULL,
  "SettelmentTypeId" integer NOT NULL,
  "Street" varchar(150) NOT NULL,
  "StreetTypeId" integer NOT NULL,
  "House" varchar(150)
);
CREATE TABLE IF NOT EXISTS "dic"."SettelmentType" (
  "ID" integer PRIMARY KEY,
  "SettelmentType" varchar(10) UNIQUE NOT NULL,
  "SettelmentTypeFull" varchar(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."CityType" (
  "ID" integer PRIMARY KEY,
  "CityType" varchar(10) UNIQUE NOT NULL,
  "CityTypeFull" varchar(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."StreetType" (
  "ID" integer PRIMARY KEY,
  "StreetType" varchar(10) UNIQUE NOT NULL,
  "StreetTypeFull" varchar(50) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."Store" (
  "ID" integer PRIMARY KEY,
  "StoreName" varchar(255) UNIQUE NOT NULL,
  "Organization" varchar(255) NOT NULL,
  "INN" varchar(12) NOT NULL,
  "AddressId" integer NOT NULL,
  "StartTime" time NOT NULL,
  "EndTime" time NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."Terminal" (
  "ID" integer PRIMARY KEY,
  "TerminalName" varchar(255) NOT NULL,
  "StoreId" integer NOT NULL,
  "ZNKKT" varchar(50) NOT NULL,
  "FNKKT" bigint
);
CREATE TABLE IF NOT EXISTS "dic"."Cashier" (
  "ID" integer PRIMARY KEY,
  "FirstName" varchar(255) NOT NULL,
  "LastName" varchar(255) NOT NULL,
  "PatronymicName" varchar(255),
  "Hiring" date NOT NULL,
  "Firing" date,
  "RoleId" integer NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."Role" (
  "ID" integer PRIMARY KEY,
  "RoleName" varchar(255) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."Products" (
  "ID" integer PRIMARY KEY,
  "ProductName" varchar(255) UNIQUE NOT NULL,
  "ProductUnitId" integer NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."ProductUnit" (
  "ID" integer PRIMARY KEY,
  "UnitName" varchar(255) UNIQUE NOT NULL,
  "UnitType" varchar(255) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."ProductCategory" (
  "ID" integer PRIMARY KEY,
  "CategoryName" varchar(255) NOT NULL,
  "ParentCategory" integer
);
CREATE TABLE IF NOT EXISTS "dic"."ProductsProductCategory" (
  "ProductsId" integer NOT NULL,
  "ProductCategoryId" integer NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."PaymentType" (
  "ID" integer PRIMARY KEY,
  "PaymentName" varchar(255) UNIQUE NOT NULL,
  "Cashless" bool NOT NULL
);
CREATE TABLE IF NOT EXISTS "dic"."Price" (
  "ID" bigint PRIMARY KEY,
  "ProductId" integer NOT NULL,
  "Price" real NOT NULL,
  "StartDate" Date NOT NULL,
  "EndDate" date
);
CREATE TABLE IF NOT EXISTS "data"."Shift" (
  "ID" bigint PRIMARY KEY,
  "TerminalId" integer NOT NULL,
  "ShiftDate" date NOT NULL,
  "ShiftStart" timestamp NOT NULL,
  "ShiftEnd" timestamp,
  "ZNKKT" varchar NOT NULL,
  "FNKKT" bigint
);
CREATE TABLE IF NOT EXISTS "data"."Cheque" (
  "ID" bigint PRIMARY KEY,
  "ShiftId" integer NOT NULL,
  "CashierId" integer NOT NULL,
  "ChequeStart" timestamp NOT NULL,
  "ChequeEnd" timestamp,
  "ChequeTypeId" integer NOT NULL,
  "Discount" varchar,
  "FDKKT" bigint
);
CREATE TABLE IF NOT EXISTS "data"."ChequeType" (
  "ID" bigint PRIMARY KEY,
  "ChequeType" varchar(255) UNIQUE NOT NULL
);
CREATE TABLE IF NOT EXISTS "data"."ChequePositions" (
  "ID" bigint PRIMARY KEY,
  "ChequeId" integer NOT NULL,
  "ProductId" integer NOT NULL,
  "Amount" real NOT NULL,
  "PriceId" bigint NOT NULL,
  "Price" real NOT NULL,
  "Discount" varchar(255)
);
CREATE TABLE IF NOT EXISTS "data"."ChequePayment" (
  "ID" bigint PRIMARY KEY,
  "ChequeId" integer,
  "PaymentTypeId" integer NOT NULL,
  "Discount" varchar,
  "Amount" real NOT NULL,
  "Change" real
);
CREATE INDEX "idx_PostalCode" ON "dic"."Address" ("PostalCode") TABLESPACE db_indexes;
CREATE INDEX "idx_City" ON "dic"."Address" ("City")TABLESPACE db_indexes;
CREATE INDEX "idx_Settelment" ON "dic"."Address" ("Settelment")TABLESPACE db_indexes;
CREATE INDEX "idx_Street" ON "dic"."Address" ("Street")TABLESPACE db_indexes;
CREATE INDEX "idx_House" ON "dic"."Address" ("House")TABLESPACE db_indexes;
CREATE INDEX "idx_City_Settelment_Street_House" ON "dic"."Address" ("City", "Settelment", "Street", "House")TABLESPACE db_indexes;
CREATE INDEX "idx_StoreName" ON "dic"."Store" ("StoreName")TABLESPACE db_indexes;
CREATE INDEX "idx_Organization" ON "dic"."Store" ("Organization")TABLESPACE db_indexes;
CREATE INDEX "idx_INN" ON "dic"."Store" ("INN")TABLESPACE db_indexes;
CREATE INDEX "idx_AddressId" ON "dic"."Store" ("AddressId")TABLESPACE db_indexes;
CREATE INDEX "idx_StoreId" ON "dic"."Terminal" ("StoreId")TABLESPACE db_indexes;
CREATE INDEX "idx_ZNKKT_Terminal" ON "dic"."Terminal" ("ZNKKT")TABLESPACE db_indexes;
CREATE INDEX "idx_FNKKT_Terminal" ON "dic"."Terminal" ("FNKKT")TABLESPACE db_indexes;
CREATE INDEX "idx_FirstName_LastName_PatronymicName" ON "dic"."Cashier" ("FirstName", "LastName", "PatronymicName")TABLESPACE db_indexes;
CREATE INDEX "idx_Hiring" ON "dic"."Cashier" ("Hiring")TABLESPACE db_indexes;
CREATE INDEX "idx_Firing" ON "dic"."Cashier" ("Firing")TABLESPACE db_indexes;
CREATE INDEX "idx_ProductName" ON "dic"."Products" ("ProductName")TABLESPACE db_indexes;
CREATE INDEX "idx_CategoryName" ON "dic"."ProductCategory" ("CategoryName")TABLESPACE db_indexes;
CREATE INDEX "idx_ProductsId_ProductCategoryId" ON "dic"."ProductsProductCategory" ("ProductsId", "ProductCategoryId")TABLESPACE db_indexes;
CREATE INDEX "idx_ProductId_Price" ON "dic"."Price" ("ProductId")TABLESPACE db_indexes;
CREATE INDEX "idx_Price_Price" ON "dic"."Price" ("Price")TABLESPACE db_indexes;
CREATE INDEX "idx_TerminalId" ON "data"."Shift" ("TerminalId")TABLESPACE db_indexes;
CREATE INDEX "idx_ShiftDate" ON "data"."Shift" ("ShiftDate")TABLESPACE db_indexes;
CREATE INDEX "idx_ShiftStart" ON "data"."Shift" ("ShiftStart")TABLESPACE db_indexes;
CREATE INDEX "ShiftStart" ON "data"."Shift" ("ShiftEnd")TABLESPACE db_indexes;
CREATE INDEX "idx_ZNKKT_Shift" ON "data"."Shift" ("ZNKKT")TABLESPACE db_indexes;
CREATE INDEX "idx_FNKKT_Shift" ON "data"."Shift" ("FNKKT")TABLESPACE db_indexes;
CREATE INDEX "idx_ShiftId" ON "data"."Cheque" ("ShiftId")TABLESPACE db_indexes;
CREATE INDEX "idx_CashierId" ON "data"."Cheque" ("CashierId")TABLESPACE db_indexes;
CREATE INDEX "idx_ChequeStart" ON "data"."Cheque" ("ChequeStart")TABLESPACE db_indexes;
CREATE INDEX "idx_ChequeEnd" ON "data"."Cheque" ("ChequeEnd")TABLESPACE db_indexes;
CREATE INDEX "idx_FDKKT" ON "data"."Cheque" ("FDKKT")TABLESPACE db_indexes;
CREATE INDEX "idx_ChequeId_ChequePositions" ON "data"."ChequePositions" ("ChequeId")TABLESPACE db_indexes;
CREATE INDEX "idx_ProductId_ChequePositions" ON "data"."ChequePositions" ("ProductId")TABLESPACE db_indexes;
CREATE INDEX "idx_Amount_ChequePositions" ON "data"."ChequePositions" ("Amount")TABLESPACE db_indexes;
CREATE INDEX "idx_PriceId" ON "data"."ChequePositions" ("PriceId")TABLESPACE db_indexes;
CREATE INDEX "idx_Price_ChequePositions" ON "data"."ChequePositions" ("Price")TABLESPACE db_indexes;
CREATE INDEX "idx_ChequeId_ChequePayment" ON "data"."ChequePayment" ("ChequeId")TABLESPACE db_indexes;
CREATE INDEX "idx_Amount_ChequePayment" ON "data"."ChequePayment" ("Amount")TABLESPACE db_indexes;
ALTER TABLE "dic"."Region" ADD FOREIGN KEY ("RegionTypeId") REFERENCES "dic"."RegionType" ("ID");
ALTER TABLE "dic"."Address" ADD FOREIGN KEY ("RegionId") REFERENCES "dic"."Region" ("ID");
ALTER TABLE "dic"."Address" ADD FOREIGN KEY ("CityTypeId") REFERENCES "dic"."CityType" ("ID");
ALTER TABLE "dic"."Address" ADD FOREIGN KEY ("SettelmentTypeId") REFERENCES "dic"."SettelmentType" ("ID");
ALTER TABLE "dic"."Address" ADD FOREIGN KEY ("StreetTypeId") REFERENCES "dic"."StreetType" ("ID");
ALTER TABLE "dic"."Store" ADD FOREIGN KEY ("AddressId") REFERENCES "dic"."Address" ("ID");
ALTER TABLE "dic"."Terminal" ADD FOREIGN KEY ("StoreId") REFERENCES "dic"."Store" ("ID");
ALTER TABLE "dic"."Cashier" ADD FOREIGN KEY ("RoleId") REFERENCES "dic"."Role" ("ID");
ALTER TABLE "data"."Shift" ADD FOREIGN KEY ("TerminalId") REFERENCES "dic"."Terminal" ("ID");
ALTER TABLE "data"."Cheque" ADD FOREIGN KEY ("ShiftId") REFERENCES "data"."Shift" ("ID");
ALTER TABLE "data"."Cheque" ADD FOREIGN KEY ("CashierId") REFERENCES "dic"."Cashier" ("ID");
ALTER TABLE "data"."Cheque" ADD FOREIGN KEY ("ChequeTypeId") REFERENCES "data"."ChequeType" ("ID");
ALTER TABLE "data"."ChequePositions" ADD FOREIGN KEY ("ChequeId") REFERENCES "data"."Cheque" ("ID");
ALTER TABLE "data"."ChequePositions" ADD FOREIGN KEY ("ProductId") REFERENCES "dic"."Products" ("ID");
ALTER TABLE "data"."ChequePositions" ADD FOREIGN KEY ("PriceId") REFERENCES "dic"."Price" ("ID");
ALTER TABLE "dic"."Products" ADD FOREIGN KEY ("ProductUnitId") REFERENCES "dic"."ProductUnit" ("ID");
ALTER TABLE "dic"."ProductCategory" ADD FOREIGN KEY ("ParentCategory") REFERENCES "dic"."ProductCategory" ("ID");
ALTER TABLE "dic"."ProductsProductCategory" ADD FOREIGN KEY ("ProductsId") REFERENCES "dic"."Products" ("ID");
ALTER TABLE "dic"."ProductsProductCategory" ADD FOREIGN KEY ("ProductCategoryId") REFERENCES "dic"."ProductCategory" ("ID");
ALTER TABLE "data"."ChequePayment" ADD FOREIGN KEY ("ChequeId") REFERENCES "data"."Cheque" ("ID");
ALTER TABLE "data"."ChequePayment" ADD FOREIGN KEY ("PaymentTypeId") REFERENCES "dic"."PaymentType" ("ID");
ALTER TABLE "dic"."Price" ADD FOREIGN KEY ("ProductId") REFERENCES "dic"."Products" ("ID");