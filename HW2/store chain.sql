CREATE TABLE "Region" (
  "ID" integer PRIMARY KEY,
  "RegionName" varchar(150) UNIQUE NOT NULL,
  "RegionTypeId" integer NOT NULL,
  "FederalDistrict" varchar(20) NOT NULL,
  "TimeZone" varchar NOT NULL
);
CREATE TABLE "RegionType" (
  "ID" integer PRIMARY KEY,
  "RegionType" varchar(10) UNIQUE NOT NULL,
  "RegionTypeFull" varchar(50) UNIQUE NOT NULL
);
CREATE TABLE "Address" (
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
CREATE TABLE "SettelmentType" (
  "ID" integer PRIMARY KEY,
  "SettelmentType" varchar(10) UNIQUE NOT NULL,
  "SettelmentTypeFull" varchar(50) UNIQUE NOT NULL
);
CREATE TABLE "CityType" (
  "ID" integer PRIMARY KEY,
  "CityType" varchar(10) UNIQUE NOT NULL,
  "CityTypeFull" varchar(50) UNIQUE NOT NULL
);
CREATE TABLE "StreetType" (
  "ID" integer PRIMARY KEY,
  "StreetType" varchar(10) UNIQUE NOT NULL,
  "StreetTypeFull" varchar(50) UNIQUE NOT NULL
);
CREATE TABLE "Store" (
  "ID" integer PRIMARY KEY,
  "StoreName" varchar(255) UNIQUE NOT NULL,
  "Organization" varchar(255) NOT NULL,
  "INN" varchar(12) NOT NULL,
  "AddressId" integer NOT NULL,
  "StartTime" time NOT NULL,
  "EndTime" time NOT NULL
);
CREATE TABLE "Terminal" (
  "ID" integer PRIMARY KEY,
  "TerminalName" varchar(255) NOT NULL,
  "StoreId" integer NOT NULL,
  "ZNKKT" varchar(50) NOT NULL,
  "FNKKT" bigint
);
CREATE TABLE "Cashier" (
  "ID" integer PRIMARY KEY,
  "FirstName" varchar(255) NOT NULL,
  "LastName" varchar(255) NOT NULL,
  "PatronymicName" varchar(255),
  "Hiring" date NOT NULL,
  "Firing" date,
  "RoleId" integer NOT NULL
);
CREATE TABLE "Role" (
  "ID" integer PRIMARY KEY,
  "RoleName" varchar(255) UNIQUE NOT NULL
);
CREATE TABLE "Shift" (
  "ID" bigint PRIMARY KEY,
  "TerminalId" integer NOT NULL,
  "ShiftDate" date NOT NULL,
  "ShiftStart" timestamp NOT NULL,
  "ShiftEnd" timestamp,
  "ZNKKT" varchar NOT NULL,
  "FNKKT" bigint
);
CREATE TABLE "Cheque" (
  "ID" bigint PRIMARY KEY,
  "ShiftId" integer NOT NULL,
  "CashierId" integer NOT NULL,
  "ChequeStart" timestamp NOT NULL,
  "ChequeEnd" timestamp,
  "ChequeTypeId" integer NOT NULL,
  "Discount" varchar,
  "FDKKT" bigint
);
CREATE TABLE "ChequeType" (
  "ID" bigint PRIMARY KEY,
  "ChequeType" varchar(255) UNIQUE NOT NULL
);
CREATE TABLE "ChequePositions" (
  "ID" bigint PRIMARY KEY,
  "ChequeId" integer NOT NULL,
  "ProductId" integer NOT NULL,
  "Amount" real NOT NULL,
  "PriceId" real NOT NULL,
  "Price" real NOT NULL,
  "Discount" varchar(255)
);
CREATE TABLE "Products" (
  "ID" integer PRIMARY KEY,
  "ProductName" varchar(255) UNIQUE NOT NULL,
  "ProductUnitId" integer NOT NULL
);
CREATE TABLE "ProductUnit" (
  "ID" integer PRIMARY KEY,
  "UnitName" varchar(255) UNIQUE NOT NULL,
  "UnitType" varchar(255) UNIQUE NOT NULL
);
CREATE TABLE "ProductCategory" (
  "ID" integer PRIMARY KEY,
  "CategoryName" varchar(255) NOT NULL,
  "ParentCategory" integer
);
CREATE TABLE "ProductsProductCategory" (
  "ProductsId" integer NOT NULL,
  "ProductCategoryId" integer NOT NULL
);
CREATE TABLE "ChequePayment" (
  "ID" bigint PRIMARY KEY,
  "ChequeId" integer,
  "PaymentTypeId" integer NOT NULL,
  "Discount" varchar,
  "Amount" real NOT NULL,
  "Change" real
);
CREATE TABLE "PaymentType" (
  "ID" integer PRIMARY KEY,
  "PaymentName" varchar(255) UNIQUE NOT NULL,
  "Cashless" bool NOT NULL
);
CREATE TABLE "Price" (
  "ID" bigint PRIMARY KEY,
  "ProductId" integer NOT NULL,
  "Price" real NOT NULL,
  "StartDate" Date NOT NULL,
  "EndDate" date
);
CREATE INDEX "idx_PostalCode" ON "Address" ("PostalCode");
CREATE INDEX "idx_City" ON "Address" ("City");
CREATE INDEX "idx_Settelment" ON "Address" ("Settelment");
CREATE INDEX "idx_Street" ON "Address" ("Street");
CREATE INDEX "idx_House" ON "Address" ("House");
CREATE INDEX "idx_City_Settelment_Street_House" ON "Address" ("City", "Settelment", "Street", "House");
CREATE INDEX "idx_StoreName" ON "Store" ("StoreName");
CREATE INDEX "idx_Organization" ON "Store" ("Organization");
CREATE INDEX "idx_INN" ON "Store" ("INN");
CREATE INDEX "idx_AddressId" ON "Store" ("AddressId");
CREATE INDEX "idx_StoreId" ON "Terminal" ("StoreId");
CREATE INDEX "idx_ZNKKT" ON "Terminal" ("ZNKKT");
CREATE INDEX "idx_FNKKT" ON "Terminal" ("FNKKT");
CREATE INDEX "idx_FirstName_LastName_PatronymicName" ON "Cashier" ("FirstName", "LastName", "PatronymicName");
CREATE INDEX "idx_Hiring" ON "Cashier" ("Hiring");
CREATE INDEX "Firing" ON "Cashier" ("Firing");
CREATE INDEX "idx_TerminalId" ON "Shift" ("TerminalId");
CREATE INDEX "idx_ShiftDate" ON "Shift" ("ShiftDate");
CREATE INDEX "idx_ShiftStart" ON "Shift" ("ShiftStart");
CREATE INDEX "ShiftStart" ON "Shift" ("ShiftEnd");
CREATE INDEX "idx_ZNKKT" ON "Shift" ("ZNKKT");
CREATE INDEX "FNKKT" ON "Shift" ("FNKKT");
CREATE INDEX "idx_ShiftId" ON "Cheque" ("ShiftId");
CREATE INDEX "idx_CashierId" ON "Cheque" ("CashierId");
CREATE INDEX "idx_ChequeStart" ON "Cheque" ("ChequeStart");
CREATE INDEX "idx_ChequeEnd" ON "Cheque" ("ChequeEnd");
CREATE INDEX "idx_FDKKT" ON "Cheque" ("FDKKT");
CREATE INDEX "idx_ChequeId" ON "ChequePositions" ("ChequeId");
CREATE INDEX "idx_ProductId" ON "ChequePositions" ("ProductId");
CREATE INDEX "idx_Amount" ON "ChequePositions" ("Amount");
CREATE INDEX "idx_PriceId" ON "ChequePositions" ("PriceId");
CREATE INDEX "idx_Price" ON "ChequePositions" ("Price");
CREATE INDEX "idx_ProductName" ON "Products" ("ProductName");
CREATE INDEX "idx_CategoryName" ON "ProductCategory" ("CategoryName");
CREATE INDEX "idx_ProductsId_ProductCategoryId" ON "ProductsProductCategory" ("ProductsId", "ProductCategoryId");
CREATE INDEX "idx_ChequeId" ON "ChequePayment" ("ChequeId");
CREATE INDEX "idx_Amount" ON "ChequePayment" ("Amount");
CREATE INDEX "idx_ProductId" ON "Price" ("ProductId");
CREATE INDEX "idx_Price" ON "Price" ("Price");
ALTER TABLE "Region" ADD FOREIGN KEY ("RegionTypeId") REFERENCES "RegionType" ("ID");
ALTER TABLE "Address" ADD FOREIGN KEY ("RegionId") REFERENCES "Region" ("ID");
ALTER TABLE "Address" ADD FOREIGN KEY ("CityTypeId") REFERENCES "CityType" ("ID");
ALTER TABLE "Address" ADD FOREIGN KEY ("SettelmentTypeId") REFERENCES "SettelmentType" ("ID");
ALTER TABLE "Address" ADD FOREIGN KEY ("StreetTypeId") REFERENCES "StreetType" ("ID");
ALTER TABLE "Store" ADD FOREIGN KEY ("AddressId") REFERENCES "Address" ("ID");
ALTER TABLE "Terminal" ADD FOREIGN KEY ("StoreId") REFERENCES "Store" ("ID");
ALTER TABLE "Cashier" ADD FOREIGN KEY ("RoleId") REFERENCES "Role" ("ID");
ALTER TABLE "Shift" ADD FOREIGN KEY ("TerminalId") REFERENCES "Terminal" ("ID");
ALTER TABLE "Cheque" ADD FOREIGN KEY ("ShiftId") REFERENCES "Shift" ("ID");
ALTER TABLE "Cheque" ADD FOREIGN KEY ("CashierId") REFERENCES "Cashier" ("ID");
ALTER TABLE "Cheque" ADD FOREIGN KEY ("ChequeTypeId") REFERENCES "ChequeType" ("ID");
ALTER TABLE "ChequePositions" ADD FOREIGN KEY ("ChequeId") REFERENCES "Cheque" ("ID");
ALTER TABLE "ChequePositions" ADD FOREIGN KEY ("ProductId") REFERENCES "Products" ("ID");
ALTER TABLE "ChequePositions" ADD FOREIGN KEY ("PriceId") REFERENCES "Price" ("ID");
ALTER TABLE "Products" ADD FOREIGN KEY ("ProductUnitId") REFERENCES "ProductUnit" ("ID");
ALTER TABLE "ProductCategory" ADD FOREIGN KEY ("ParentCategory") REFERENCES "ProductCategory" ("ID");
ALTER TABLE "ProductsProductCategory" ADD FOREIGN KEY ("ProductsId") REFERENCES "Products" ("ID");
ALTER TABLE "ProductsProductCategory" ADD FOREIGN KEY ("ProductCategoryId") REFERENCES "ProductCategory" ("ID");
ALTER TABLE "ChequePayment" ADD FOREIGN KEY ("ChequeId") REFERENCES "Cheque" ("ID");
ALTER TABLE "ChequePayment" ADD FOREIGN KEY ("PaymentTypeId") REFERENCES "PaymentType" ("ID");
ALTER TABLE "Price" ADD FOREIGN KEY ("ProductId") REFERENCES "Products" ("ID");