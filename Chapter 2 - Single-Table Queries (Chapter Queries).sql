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