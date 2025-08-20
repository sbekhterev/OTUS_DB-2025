CREATE TABLE "Region" (
  "ID" integer PRIMARY KEY,
  "RegionName" varchar NOT NULL,
  "TimeZone" varchar NOT NULL
);

CREATE TABLE "Store" (
  "ID" integer PRIMARY KEY,
  "StoreName" varchar NOT NULL,
  "StoreAddress" varchar,
  "RegionId" integer NOT NULL,
  "StartTime" time NOT NULL,
  "EndTime" time NOT NULL,
  "AddressId" integer NOT NULL
);

CREATE TABLE "Address" (
  "ID" integer PRIMARY KEY,
  "postal_code" varchar,
  "federal_district" varchar,
  "region_with_type" varchar,
  "city_with_type" varchar,
  "settlement_with_type" varchar,
  "street_with_type" varchar,
  "house" varchar
);

CREATE TABLE "Terminal" (
  "ID" integer PRIMARY KEY,
  "TerminalName" varchar NOT NULL,
  "StoreId" integer NOT NULL
);

CREATE TABLE "Cashier" (
  "ID" integer PRIMARY KEY,
  "FirstName" varchar NOT NULL,
  "LastName" varchar NOT NULL,
  "PatronymicName" varchar,
  "Hiring" date NOT NULL,
  "Firing" date,
  "RoleId" integer NOT NULL
);

CREATE TABLE "Role" (
  "ID" integer PRIMARY KEY,
  "RoleName" varchar NOT NULL
);

CREATE TABLE "Shift" (
  "ID" integer PRIMARY KEY,
  "TerminalId" integer NOT NULL,
  "ShiftDate" date NOT NULL,
  "ShiftStart" timestamp NOT NULL,
  "ShiftEnd" timestamp,
  "ZNKKT" varchar NOT NULL,
  "FNKKT" bigint
);

CREATE TABLE "Cheque" (
  "ID" integer PRIMARY KEY,
  "ShiftId" integer NOT NULL,
  "CashierId" integer NOT NULL,
  "ChequeStart" timestamp NOT NULL,
  "ChequeEnd" timestamp,
  "ChequeTypeId" integer NOT NULL,
  "FDKKT" bigint
);

CREATE TABLE "ChequeType" (
  "ID" integer PRIMARY KEY,
  "ChequeType" varchar NOT NULL
);

CREATE TABLE "ChequePositions" (
  "ID" integer PRIMARY KEY,
  "ChequeId" integer NOT NULL,
  "ProductId" integer NOT NULL,
  "Amount" real NOT NULL,
  "Price" real NOT NULL
);

CREATE TABLE "Products" (
  "ID" integer PRIMARY KEY,
  "ProductName" varchar NOT NULL,
  "ProductUnitId" integer NOT NULL,
  "ProductCategoryId" integer NOT NULL
);

CREATE TABLE "ProductUnit" (
  "ID" integer PRIMARY KEY,
  "UnitName" varchar NOT NULL,
  "UnitType" varchar NOT NULL
);

CREATE TABLE "ProductCategory" (
  "ID" integer PRIMARY KEY,
  "CategoryName" varchar NOT NULL,
  "ParentCategory" integer
);

CREATE TABLE "ChequePayment" (
  "ID" integer PRIMARY KEY,
  "ChequeId" integer,
  "PaymentTypeId" integer NOT NULL,
  "Discount" varchar,
  "Amount" real NOT NULL,
  "Change" real
);

CREATE TABLE "PaymentType" (
  "ID" integer PRIMARY KEY,
  "PaymentName" varchar NOT NULL,
  "Cashless" bool NOT NULL
);

ALTER TABLE "Store" ADD FOREIGN KEY ("RegionId") REFERENCES "Region" ("ID");

ALTER TABLE "Store" ADD FOREIGN KEY ("AddressId") REFERENCES "Address" ("ID");

ALTER TABLE "Terminal" ADD FOREIGN KEY ("StoreId") REFERENCES "Store" ("ID");

ALTER TABLE "Cashier" ADD FOREIGN KEY ("RoleId") REFERENCES "Role" ("ID");

ALTER TABLE "Shift" ADD FOREIGN KEY ("TerminalId") REFERENCES "Terminal" ("ID");

ALTER TABLE "Cheque" ADD FOREIGN KEY ("ShiftId") REFERENCES "Shift" ("ID");

ALTER TABLE "Cheque" ADD FOREIGN KEY ("CashierId") REFERENCES "Cashier" ("ID");

ALTER TABLE "Cheque" ADD FOREIGN KEY ("ChequeTypeId") REFERENCES "ChequeType" ("ID");

ALTER TABLE "ChequePositions" ADD FOREIGN KEY ("ChequeId") REFERENCES "Cheque" ("ID");

ALTER TABLE "ChequePositions" ADD FOREIGN KEY ("ProductId") REFERENCES "Products" ("ID");

ALTER TABLE "Products" ADD FOREIGN KEY ("ProductUnitId") REFERENCES "ProductUnit" ("ID");

ALTER TABLE "Products" ADD FOREIGN KEY ("ProductCategoryId") REFERENCES "ProductCategory" ("ID");

ALTER TABLE "ProductCategory" ADD FOREIGN KEY ("ParentCategory") REFERENCES "ProductCategory" ("ID");

ALTER TABLE "ChequePayment" ADD FOREIGN KEY ("ChequeId") REFERENCES "Cheque" ("ID");

ALTER TABLE "ChequePayment" ADD FOREIGN KEY ("PaymentTypeId") REFERENCES "PaymentType" ("ID");
