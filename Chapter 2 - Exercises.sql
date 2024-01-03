-- Exercise 1 --
-- Return orders placed in June 2021
-- Tables involved: TSQLV6 database, Sales.Orders table

-- Query:
USE TSQLV6;

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate >= '20210601'
	AND orderdate < '20210701';

-- Output:
orderid     orderdate  custid      empid
----------- ---------- ----------- -----------
10555       2021-06-02 71          6
10556       2021-06-03 73          2
10557       2021-06-03 44          9
10558       2021-06-04 4           1
10559       2021-06-05 7           6
10560       2021-06-06 25          8
10561       2021-06-06 24          2
10562       2021-06-09 66          1
10563       2021-06-10 67          2
10564       2021-06-10 65          4
...
(30 rows affected)


-- Exercise 2 --
-- Return orders placed on the day before the last day of the month
-- Tables involved: Sales.Orders table

-- Query:
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = DATEADD(day, -1, EOMONTH(orderdate));

-- Output:
orderid     orderdate  custid      empid
----------- ---------- ----------- -----------
10268       2020-07-30 33          8
10294       2020-08-30 65          4
10342       2020-10-30 25          4
10368       2020-11-29 20          2
10398       2020-12-30 71          2
10430       2021-01-30 20          4
10431       2021-01-30 10          4
10459       2021-02-27 84          4
10520       2021-04-29 70          7
10521       2021-04-29 12          8
...
(30 rows affected)


-- Exercise 3 --
-- Return employees with last name containing the letter 'e' twice or more
-- Tables involved: HR.Employees table

-- Query:
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE '%e%e%';

-- Output:
empid       firstname  lastname
----------- ---------- --------------------
4           Yael       Peled
5           Sven       Mortensen
(2 rows affected)