DROP TABLE IF EXISTS "DimCustomer" CASCADE;
CREATE TABLE "DimCustomer" (
    "CustomerID" INT PRIMARY KEY,
    "FullName" VARCHAR(100),
    "DOB" DATE,
    "Gender" VARCHAR(10),
    "Region" VARCHAR(50),
    "Email" VARCHAR(100),
    "Status" VARCHAR(20),
    "JoinDate" DATE
);

DROP TABLE IF EXISTS "DimAccount" CASCADE;
CREATE TABLE "DimAccount" (
    "AccountID" INT PRIMARY KEY,
    "CustomerID" INT,
    "AccountType" VARCHAR(50),
    "OpenDate" DATE,
    "ClosedDate" DATE,
    "Status" VARCHAR(20),
    "RegistrationID" INT,
    "Balance" NUMERIC(15, 2)
);

DROP TABLE IF EXISTS "DimProductCategory" CASCADE;
CREATE TABLE "DimProductCategory" (
    "ProductCategoryID" INT PRIMARY KEY,
    "ProductCategoryName" VARCHAR(50));

DROP TABLE IF EXISTS "DimProductSubCategory" CASCADE;
CREATE TABLE "DimProductSubCategory" (
    "ProductSubCategoryID" INT PRIMARY KEY,
    "ProductCategoryID" INT,
    "ProductSubCategoryName" VARCHAR(50)
);

DROP TABLE IF EXISTS "DimProduct" CASCADE;
CREATE TABLE "DimProduct" (
    "ProductID" INT PRIMARY KEY,
    "ProductSubCategoryID" INT,
    "ProductName" VARCHAR(50)
);

DROP TABLE IF EXISTS "FactTransaction" CASCADE;
CREATE TABLE "FactTransaction" (
    "TransactionID" INT PRIMARY KEY,
    "AccountID" INT,
    "TransactionDate" TIMESTAMP,
    "TransactionAmount" NUMERIC(15, 2),
    "TransactionType" VARCHAR(20),
    "TransactionChannel" VARCHAR(20),
    "ProductID" INT,
    "Status" VARCHAR(20)
);

