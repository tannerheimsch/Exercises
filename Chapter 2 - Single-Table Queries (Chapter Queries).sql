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

-- Query to get all rows from the Orders table in the Sales schema, selecting the attributes: 'orderid', 'custid', 'empid', 'orderdate', and 'freight'
SELECT orderid, custid, empid, orderdate, freight
FROM Sales.Orders;

-- Query to visualize the WHERE phase
SELECT orderid, empid, orderdate, freight
FROM Sales.Orders
WHERE custid = 71;

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

-- Query to return the 9 groups created by the GROUP BY phase to only show rows with more than 1 order
SELECT empid, YEAR(orderdate) AS orderyear
FROM Sales.Orders
WHERE custid = 71
GROUP BY empid, YEAR(orderdate)
HAVING COUNT(*) > 1;

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