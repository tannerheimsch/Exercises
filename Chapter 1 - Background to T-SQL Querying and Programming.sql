-- This section describes the fundamentals of creating tables and defining data integrity using T-SQL

-- EMPLOYEES TABLE --
-- Set current database context to TSQLV6
USE TSQLV6;

DROP TABLE IF EXISTS dbo.Employees;

-- Create new table in the dbo schema with selected column names and data types
CREATE TABLE dbo.Employees
(
 empid		INT			NOT NULL,
 firstname	VARCHAR(30)	NOT NULL,
 lastname	VARCHAR(30)	NOT NULL,
 hiredate	DATE		NOT NULL,
 mgrid		INT			NULL,
 ssn		VARCHAR(20)	NOT NULL,
 salary		MONEY		NOT NULL
);

-- Modify Employees table to define the primary key as 'empid' and create a constraint
ALTER TABLE dbo.Employees
	ADD CONSTRAINT PK_Employees
	PRIMARY KEY(empid);

-- Modify Employees table to define a UNIQUE constraint on the 'ssn' column'
ALTER TABLE dbo.Employees
	ADD CONSTRAINT UNQ_Employees_ssn
	UNIQUE(ssn);

-- Modify Employees table to restrict values supported by the 'mgrid' column in the Employees table to the values that already exist in the 'empid' column of the same table.
ALTER TABLE dbo.Employees
  ADD CONSTRAINT FK_Employees_Employees
  FOREIGN KEY(mgrid)
  REFERENCES dbo.Employees(empid);

-- Modify Employees table to ensure the 'salary' column in the Employees table only supports positive values
ALTER TABLE dbo.Employees
  ADD CONSTRAINT CHK_Employees_salary
  CHECK(salary > 0.00);

-- Create a unique index named 'idx_ssn_notnull' on the 'ssn' column of the 'Employees' table in the 'dbo' schema to prevent duplicates in the SSN column
CREATE UNIQUE INDEX idx_ssn_notnull ON dbo.Employees(ssn) WHERE ssn IS NOT NULL;


-- ORDERS TABLE --
-- Create Orders table with 'orderid' column defined as the PK
DROP TABLE IF EXISTS dbo.Orders;

CREATE TABLE dbo.Orders
(
 orderid  INT		  NOT NULL,
 empid	  INT		  NOT NULL,
 custid	  VARCHAR(10) NOT NULL,
 orderts  DATETIME2	  NOT NULL,
 qty	  INT		  NOT NULL,
 CONSTRAINT PK_Orders
	PRIMARY KEY(orderid)
);

-- Modify Orders table to define 'empid' from the Employees table as the FK
ALTER TABLE dbo.Orders
  ADD CONSTRAINT FK_Orders_Employees
  FOREIGN KEY(empid)
  REFERENCES dbo.Employees(empid);

-- Modify Orders table to set the value in the 'orderts' column to date/time the record was entered if one isn't specified
ALTER TABLE dbo.Orders
  ADD CONSTRAINT DFT_Orders_orderts
  DEFAULT(SYSDATETIME()) FOR orderts;