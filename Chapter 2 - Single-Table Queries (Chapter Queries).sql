-- Elements of the SELECT statement  --
-- Query to filter orders placed by Customer 71, grouped by employee & year, and then filter only groups of employees and years that have more than one order
USE TSQLV6;

SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

-- Query rearranged in logical processing order (NOT correct syntax)
/*
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
ORDER BY empid, orderyear

Explanation:
1. Queries the rows from the Sales.Orders table
2. Filters only orders where the customer ID is equal to 71
3. Groups the orders by employee ID and order year
4. Filters only groups (employee ID and order year) having more than one order
5. Selects (returns) for each group the employee ID, order year, and number of orders
   - COUNT(*) counts all the rows in the result set, regardless of the values in any particular column.
6. Orders (sorts) the rows in the output by employee ID and order year
*/


-- The FROM clause --
-- Query to get all rows from the Orders table in the Sales schema, selecting the attributes: 'orderid', 'custid', 'empid', 'orderdate', and 'freight'
SELECT orderid, custid, empid, orderdate, freight
FROM Sales.Orders;


-- The WHERE clause  --
-- Query to visualize the WHERE phase
SELECT orderid, empid, orderdate, freight
FROM Sales.Orders
WHERE custid = 71;


-- The GROUP BY clause -- 
-- Query to return 16 rows for the 16 groups of employee-ID and order-year values
SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

-- Query to return the total freight and number of orders per employee and order year
SELECT
 empid,
 YEAR(orderdate) AS orderyear,
 SUM(freight) AS totalfreight,
 COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate);

-- Query to return the number of distinct customers handled by each employee in each order year
SELECT
 empid,
 YEAR(orderdate) AS orderyear,
 COUNT(DISTINCT custid) AS numcusts
FROM Sales.Orders
GROUP BY empid, YEAR(orderdate);


-- The HAVING clause -- 
-- Query to return the 9 groups created by the GROUP BY phase to only show rows with more than 1 order
SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;


-- The SELECT clause -- 
-- Query to return the 9 rows (one for each group) with the aggregate function the SELECT clause
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

-- Query returning duplicate rows
SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71;

-- Query to limit the multiset query above to remove duplicates
SELECT DISTINCT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71;


-- The ORDER BY Clause
-- Query demonstrating the ORDER BY clause, sorted by employee ID and order year
SELECT empid, YEAR(orderdate) AS orderyear, COUNT(*) AS numorders
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1
ORDER BY empid, orderyear;

-- Query to sort the employee rows by hire date WITHOUT returning the 'hiredate' attribute
SELECT empid, firstname, lastname, country
FROM HR.Employees
ORDER BY hiredate;


-- The TOP and OFFSET-FETCH filters
-- The TOP filter
-- Query to return Top 5 most recent orders from the Orders table
SELECT TOP(5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

-- Query to request the top 1 percent of the most recent orders
SELECT TOP(1) PERCENT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

-- Query demonstrating TOP with unique ORDER BY list to be deterministic so the row with the greater 'orderid' value will be preferred in the result
SELECT TOP(5) orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC, orderid DESC;

-- Query requesting all ties/rows from the table be returned that have the same sort value (orderdate) as the last one found
SELECT TOP(5) WITH TIES orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate DESC;

-- The OFFSET-FETCH filter
-- Query ordering rows from the Orders table based on the 'orderdate' and 'orderid' attributes from least recent > most recent with 'orderid' as the tiebreaker
-- The OFFSET clause skips the first 50 rows and the FETCH clause filters the next 25 rows only
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
ORDER BY orderdate, orderid
OFFSET 50 ROWS FETCH NEXT 25 ROWS ONLY;


-- Window Functions (quick look)
-- Query to visualize row numbers, creating a separate partition for each distinct 'custid' value.
SELECT orderid, custid, val,
	ROW_NUMBER() OVER(PARTITION BY custid
										ORDER BY val) AS rownum
FROM Sales.OrderValues
ORDER BY custid, val;

/* The LOGICAL ORDER in which all clauses discussed above are processed:
- FROM
- WHERE
- GROUP BY
- HAVING
- SELECT
   - Expressions
   - DISTINCT
- ORDER BY
   - TOP/OFFSET-FETCH
*/


-- Predicates and Operators --
-- **Data Types, Precedence, and Related Information: https://learn.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver16**

-- Query to return orders in which the order ID is equal to 10248, 10249, or 10250 (IN predicate)
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid IN(10248, 10249, 10250);

-- Query to return all orders in the inclusive range 10300 through 10310 (BETWEEN predicate)
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderid BETWEEN 10300 AND 10310;

-- Query to return employees whose last names tart with the letter D (LIKE predicate)
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE N'D%';

-- Query to return all orders place on or after January 1, 2022 (comparison operators)
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20220101';

-- Query to return all orders placed on or after January 1, 2022 that were handled by an employee whose ID is other than 1, 3, and 5 (logical expression combination)
SELECT orderid, empid, orderdate
FROM Sales.Orders
WHERE orderdate >= '20220101'
	AND empid NOT IN(1, 3, 5);

-- Query to calculate the net value as a result of arithmetic manipulation of the 'quantity', 'unitprice', and 'discount' attributes. (arithmetic operators)
SELECT orderid, productid, qty, unitprice, discount,
	qty * unitprice * (1 - discount) AS val
FROM Sales.OrderDetails;


/* Operator Evaluation Precedence Rules (Highest -> Lowest)

1. () [Parentheses]
2. * [Multiplication], / [Division], % [Modulo]
3. + [Positive], - [Negative], + [Addition], + [Concatenation], – [Subtraction]
4. =, >, <, >=, <=, <>, !=, !>, !< [Comparison Operators]
5. NOT
6. AND
7. BETWEEN, IN, LIKE, OR
8. = [Assignment]
*/

-- Query to return orders that were either "placed by customer 1 and handled by employees 1, 3, or 5" OR "placed by customer 85 and handled by employees 2, 4, 6" (AND has precedence over OR)
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
				custid = 1
		AND empid IN(1, 3, 5)
		OR custid = 85
		AND empid IN(2, 4, 6);

-- Query using parentheses to force precedence with logical operators (same as above - better readability)
SELECT orderid, custid, empid, orderdate
FROM Sales.Orders
WHERE
			(			custid = 1
				AND empid IN(1, 3, 5) )
		OR
			(			custid = 85
				AND empid IN(2, 4, 6) );


-- CASE Expressions --