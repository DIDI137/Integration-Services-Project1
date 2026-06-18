USE [master];

CREATE DATABASE [TDC_Staging];

USE [TDC_Staging];

GO

CREATE TABLE [employee_stg] (
    [EMPLOYEE_ID] varchar(50),
    [FULL_NAME] varchar(50),
    [CATEGORY] varchar(50),
    [EMPLOYMENT_DATE] varchar(50),
    [BIRTH_DATE] varchar(50),
    [EDUCATION_LEVEL] varchar(50),
    [GENDER] varchar(50)
);

CREATE TABLE [holidays_stg] (
    [DATE] varchar(50),
    [HOLIDAY] varchar(50)
);

CREATE TABLE [holidays_2_stg] (
    [Date] varchar(50),
    [Holiday] varchar(50),
    [WeekDay] varchar(50),
    [Month] varchar(50),
    [Day] varchar(50),
    [Year] varchar(50)
);

CREATE TABLE [TDCsales_stg] (
    [id] int,
    [billing_id] int,
    [date] datetime,
    [customer_id] int,
    [employee_id] int,
    [product_id] int,
    [quantity] int,
    [region] varchar(45)
);

CREATE TABLE [billing_stg] (
    [BILLING_ID] int,
    [REGION] nvarchar(45),
    [BRANCH_ID] int,
    [DATE] datetime,
    [CUSTOMER_ID] smallint,
    [EMPLOYEE_ID] smallint
);

CREATE TABLE [billing_details_stg] (
    [BILLING_ID] int,
    [PRODUCT_ID] smallint,
    [QUANTITY] smallint
);

CREATE TABLE [discounts_stg] (
    [DISCOUNT_ID] int,
    [DATE_FROM] datetime,
    [DATE_UNTIL] datetime,
    [TOTAL_BILLING] float,
    [PERCENTAGE] smallint
);

CREATE TABLE [prices_stg] (
    [PRODUCT_ID] int,
    [DATE] datetime,
    [PRICE] float
);

CREATE TABLE [products_stg] (
    [producto_id] varchar(50),
    [detalle] varchar(50),
    [volumen] varchar(50)
);

CREATE TABLE [stock_stg] (
    [producto_id] varchar(50),
    [fecha] varchar(50),
    [variacion] varchar(50)
);

CREATE TABLE [regions_stg] (
    [region] varchar(50),
    [estado] varchar(50),
    [ciudad] varchar(50),
    [codigo_postal] varchar(50)
);

CREATE TABLE [customer_r_stg] (
    [CUSTOMER_ID] int,
    [FULL_NAME] nvarchar(255),
    [BIRTH_DATE] nvarchar(255),
    [CITY] nvarchar(255),
    [STATE] nvarchar(255),
    [ZIPCODE] bigint
);

CREATE TABLE [customer_w_stg] (
    [CUSTOMER_ID] int,
    [FULL_NAME] nvarchar(255),
    [BIRTH_DATE] nvarchar(255),
    [CITY] nvarchar(255),
    [STATE] nvarchar(255),
    [ZIPCODE] bigint
);

GO