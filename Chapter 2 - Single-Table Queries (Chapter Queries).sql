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
-- Query using a simple CASE expression to compute the product count parity (whether the count is odd or even) per category
SELECT supplierid, COUNT(*) AS numproducts,
	CASE COUNT(*) % 2
		WHEN 0 THEN 'Even'
		WHEN 1 THEN 'Odd'
		ELSE 'Unknown'
	END AS countparity
FROM Production.Products
GROUP BY supplierid;

-- Query using another simple CASE expression to produce a value category description based on whether the 'val' attribute is less than 1,000, between 1,000 and 3,000, or greater than 3,000
SELECT orderid, custid, val,
	CASE
		WHEN val < 1000.00  THEN 'Less than 1000'
		WHEN val <= 3000.00 THEN 'Between 1000 and 3000'
		WHEN val > 3000.00  THEN 'More than 3000'
		ELSE 'Unknown'
	END AS valuecategory
FROM Sales.OrderValues;

/*
T-SQL supports some functions that can be considered abbreviations of the CASE expression: ISNULL, COALESCE, IIF, and CHOOSE (only COALESCE is standard)

The ISNULL function accepts two arguments as input and returns the first that is not NULL, or NULL if both are NULL.
	- i.e. ISNULL(col1,'') returns the col1 value if it isn't NULL and an empty string if it is NULL.

The COALESCE function is similar, only it supports two or more arguments and returns the first that isn't NULL, or NULL if all are NULL.
	- Should you use ISNULL or COALESCE? Article: https://www.itprotoday.com/sql-server/coalesce-vs-isnull

The nonstandard IIF and CHOOSE functions were added to T-SQL to support easier migrations from Microsoft Access:
	- The function IIF(<logical_expression>, <expr1>, <expr2>) returns expr1 if logical_expressions is TRUE, and it returns expr2 otherwise.
  		- i.e. IIF(col 1 <> 0, col2/col1, NULL) returns the result of col2/col1 if col1 is not zero; otherwise it returns a NULL.
	
	- The function CHOOSE(<index>, <expr1>, <expr2>, ..., <exprn>) returns the expression from the list in the specified index.
		- i.e. CHOOSE(3, col1, col2, col3) returns the value of col3.
*/


-- NULLs --
/*
SQL supports the NULL marker to represent missing values and uses three-valued predicate logic: TRUE, FALSE or UNKNOWN.
- A logical expression involving only non-NULL values evaluates to either TRUE or FALSE. When the logical expression involves a NULL, it evaluates to UNKNOWN:
	- i.e. salary > 0. When salary is equal to 1,000, the expression evaluates to TRUE. When salary is equal to -1,000, the expression evaluates to FALSE. When 
	  salary is NULL, the expression evaluates to UNKNOWN.

SQL treats TRUE and FALSE in an intuitive and probably expected manner:
	- i.e. If salary > 0 appears in a query filter (such as in a WHERE or HAVING clause), rows or groups for which the expression evaluates to TRUE are returned,
	  whereas those for which the expression evaluates to FALSE are discarded.
	- Similarly, if salary > 0 appears in a CHECK constraint in a table, INSERT or UPDATE statements for which the expression evaluates to TRUE for all rows are accepted,
	  whereas those for which the expression evaluates to FALSE for any row are rejected.

SQL has different treatments for UNKNOWN in different language elements. The treatment SQL has for query filters is "accept TRUE", meaning that both FALSE and UNKNOWN are 
discarded. Conversely, the definition of the treatment SQL has for CHECK constraints is "reject FALSE", meaning that both TRUE and UNKNOWN are accepted. Had SQL used two-valued 
predicate logic, there wouldn't have been a difference between the definitions "accept TRUE" and "reject FALSE". But with three-valued predicate logic, "accept TRUE" rejects 
UNKNOWN, whereas "reject FALSE" accepts it.
	- i.e. salary > 0 from the previous example, a NULL salary would cause the expression to evaluate to UNKNOWN. If this predicate appears in a query's WHERE clause, a row with 
	  a NULL salary will be discarded. If this predicate appears in a CHECK constraint in a table, a row with a NULL salary will be accepted.

One of the tricky aspects of the truth value UNKNOWN is that when you negate it, you still get UNKNOWN
	- i.e. NOT (salary > 0) when salary is NULL, salary > 0 evaluates to UNKNOWN, and NOT UNKNOWN remains UNKNOWN.

An expression comparing two NULLs (NULL = NULL) evaluates to UNKNOWN. The reasoning for this from SQL's perspective is that a  NULL represents a missing value, and you can't really
tell whether one missing value is equal to another. Therefore, SQL provides you with the predicates IS NULL and IS NOT NULL, which you should use instead of = NULL and <> NULL.

SQL Server 2022 introduced support for the standard distinct predicate, which uses two-valued logic when comparing elements, essentially treating NULLS like non-NULL values:
	- comparand1 IS [NOT] DISTINCT FROM comprand2
		- The IS NOT DISTINCT FROM predicate is similar to the equality (=) operator, only it evaluates to TRUE when comparing two NULLs, and to FALSE when comparing a NULL with a non-NULL
		  value. The IS DISTINCT FROM predicate is similar to the different than (<>) operator, only it evaluates to FALSE when comparing two NULLS, and to TRUE when comparing a NULL with a
		  non-NULL value. 
		- Essentially, this predicate uses negative form (with a NOT) to apply positive comparison and a positive form (without a NOT) to apply negative comparison, similar to how we speak in 
		  English when describing distinctness.

*Using the distinct predicate as an alternative to the equality operator becomes important when you compare two columns, or a column with a variable, or an input parameter that you pass to a stored
procedure or a user-defined function.*

More information on NULLs including optimization considerations:
- “NULL complexities – Part 1” - https://sqlperformance.com/2019/12/t-sql-queries/null-complexities-part-1
- “NULL Complexities – Part 2” - https://sqlperformance.com/2020/01/t-sql-queries/null-complexities-part-2
- “NULL complexities – Part 3, Missing standard features and T-SQL alternatives” - https://sqlperformance.com/2020/02/t-sql-queries/null-complexities-part-3-missing-standard-features-and-t-sql-alternatives
- “NULL complexities – Part 4, Missing standard unique constraint” - https://sqlperformance.com/2020/03/t-sql-queries/null-complexities-part-4-missing-standard-unique-constraint
*/

-- Query which attempts to return all customers where the region is equal to 'WA'
SELECT custid, country, region, city
FROM Sales.Customers
WHERE region = N'WA';

-- Query demonstrating the IS NOT DISTINCT predicate, returning the same result
SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS NOT DISTINCT FROM N'WA';

-- Query attempting to return all customers for whom the region is different than WA
SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA';

-- Query that will return results where 'region' is NULL
SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS NULL;

-- Query that will return all rows for which the 'region' attribute is different than WA, including those in which the value is missing (NULL)
SELECT custid, country, region, city
FROM Sales.Customers
WHERE region <> N'WA'
	OR region IS NULL;

-- Query that is less verbose than above, returning the same result
SELECT custid, country, region, city
FROM Sales.Customers
WHERE region IS DISTINCT FROM N'WA';


-- The GREATEST and LEAST Functions -- 