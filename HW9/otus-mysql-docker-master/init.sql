CREATE DATABASE IF NOT EXISTS otus;
USE otus;

CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY '123456789';
GRANT ALL PRIVILEGES ON otus.* TO 'admin'@'%';
FLUSH PRIVILEGES;


CREATE TABLE IF NOT EXISTS `Region` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `RegionName` varchar(150) UNIQUE NOT NULL,
  `RegionTypeId` INT NOT NULL,
  `FederalDistrict` varchar(20) NOT NULL,
  `TimeZone` varchar(255) NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `RegionType` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `RegionType` varchar(10) UNIQUE NOT NULL,
  `Description` varchar(50) UNIQUE NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `PostalCode` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PostalCode` varchar(10) NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Address` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `RegionId` INT NOT NULL,
  `PostalCodeId` INT NOT NULL,
  `City` varchar(150) NOT NULL,
  `CityTypeId` INT NOT NULL,
  `Settelment` varchar(150) NOT NULL,
  `SettelmentTypeId` INT NOT NULL,
  `Street` varchar(150) NOT NULL,
  `StreetTypeId` INT NOT NULL,
  `House` varchar(150),
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `SettelmentType` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `SettelmentType` varchar(10) UNIQUE NOT NULL,
  `Description` varchar(50) UNIQUE NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `CityType` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CityType` varchar(10) UNIQUE NOT NULL,
  `Description` varchar(50) UNIQUE NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `StreetType` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `StreetType` varchar(10) UNIQUE NOT NULL,
  `Description` varchar(50) UNIQUE NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Store` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `StoreName` varchar(255) UNIQUE NOT NULL,
  `Organization` varchar(255) NOT NULL,
  `INN` varchar(12) NOT NULL,
  `AddressId` INT NOT NULL,
  `StartTime` time NOT NULL,
  `EndTime` time NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Terminal` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TerminalName` varchar(255) NOT NULL,
  `StoreId` INT NOT NULL,
  `ZNKKT` varchar(50) NOT NULL,
  `FNKKT` bigint,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Cashier` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) NOT NULL,
  `PatronymicName` varchar(255),
  `Hiring` date NOT NULL,
  `Firing` date,
  `RoleId` INT NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Role` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `RoleName` varchar(255) UNIQUE NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Products` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ProductName` varchar(255) UNIQUE NOT NULL,
  `ProductUnitId` INT NOT NULL,
  `EAN` varchar(255) UNIQUE NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `ProductUnit` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `UnitName` varchar(255) UNIQUE NOT NULL,
  `UnitType` varchar(255) UNIQUE NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `ProductCategory` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `CategoryName` varchar(255) NOT NULL,
  `ParentCategory` INT,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `ProductsProductCategory` (
  `ProductsId` INT NOT NULL,
  `ProductCategoryId` INT NOT NULL
);

CREATE TABLE IF NOT EXISTS `PaymentType` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PaymentName` varchar(255) UNIQUE NOT NULL,
  `Cashless` bool NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `PriceList` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `StartDate` Date NOT NULL,
  `EndDate` date,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Price` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `PriceListId` INT,
  `ProductId` INT NOT NULL,
  `Price` real NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Shift` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `TerminalId` INT NOT NULL,
  `ShiftDate` date NOT NULL,
  `ShiftStart` timestamp NOT NULL,
  `ShiftEnd` timestamp,
  `ZNKKT` varchar(255) NOT NULL,
  `FNKKT` bigint,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `Cheque` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ShiftId` INT NOT NULL,
  `CashierId` INT NOT NULL,
  `ChequeStart` timestamp NOT NULL,
  `ChequeEnd` timestamp,
  `ChequeTypeId` INT NOT NULL,
  `Discount` varchar(255),
  `FDKKT` bigint,
  `PriceListId` INT NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `ChequeType` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ChequeType` varchar(255) UNIQUE NOT NULL,
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `ChequePositions` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ChequeId` INT NOT NULL,
  `ProductId` INT NOT NULL,
  `Amount` real NOT NULL,
  `PriceId` bigint NOT NULL,
  `Price` real NOT NULL,
  `Discount` varchar(255),
  PRIMARY KEY (`ID`)
);

CREATE TABLE IF NOT EXISTS `ChequePayment` (
  `ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `ChequeId` INT,
  `PaymentTypeId` INT NOT NULL,
  `Discount` varchar(255),
  `Amount` real NOT NULL,
  `Change` real,
  PRIMARY KEY (`ID`)
);
