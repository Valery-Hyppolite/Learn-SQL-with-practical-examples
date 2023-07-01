USE sql_store;

-- SELECT ALL FROM A TABLE
SELECT * 
FROM customers;

-- SELECT SPECIFIC COLUMNS FROM A TABLE
SELECT last_name, first_name, points
FROM customers;

-- SELECT SPECIFIC COLUMNS FROM A TABLE AND ADD A NEW COLUMN NAME "DISCOOUNT FACTOR" TO THE TABLE BY USING THE "AS" KEY WORD
SELECT last_name, first_name, points, (points + 10) * 50 AS "discount factor"
FROM customers;

-- RETURN ALL PRODUCTS NAME, UNIT PRICE AND NEW PRICE (UNIT PRICE. * 1.1)
SELECT name, unit_price, (unit_price * 0.5) AS new_price
FROM products;
-- ------------------------------------------------


-- USE THE SELECT CLAUSE WITH THE WHERE CLAUSE FOR CONDITIONS STATEMENTS

-- SELECT ALL CUSTOMERS LOCATED IN VA
SELECT * 
FROM Customers
WHERE state = "VA";

-- SELECT ALL CUSTOMERS NOT LOCATED IN VA
SELECT * 
FROM Customers
WHERE state != "VA";

-- SELECT ALL CUSTOMERS born before 1990
SELECT * 
FROM Customers
WHERE birth_date > "1990-01-01";

-- SELECT ALL ORDERS PLACE IN THE YEAR OF 2017
SELECT * 
FROM orders
WHERE order_date >= "2019-01-01";
-- --------------------------------------

-- USE THE SELECT WITH THE AND, OR, AND NOT OPERATORS TO FILTER RESULTS

-- SELECT ALL CUSTOMERS born before 1990 AND WHO HAVE POINTS GREATER THAN 1000
SELECT * 
FROM Customers
WHERE birth_date > "1990-01-01" AND points > 1000;

-- SELECT ALL CUSTOMERS born before 1990 OR WHO HAVE POINTS GREATER THAN 1000
SELECT * 
FROM Customers
WHERE birth_date > "1990-01-01" OR points > 1000;

-- SELECT ALL CUSTOMERS born before 1990 OR WHO HAVE POINTS GREATER THAN 1000 AND WHO LIVES IN VA
-- NOTES:Tthe AND  operator has higher precident, meaning it will be evaluated first. 
SELECT * 
FROM Customers
WHERE birth_date > "1990-01-01" OR (points > 1000 AND state = "VA");

-- SELECT CUSTOMERS WHO ARE NOT BORN BEFORE 1990 AND WHO'S POINT ARE NOT > 1000
SELECT * 
FROM Customers
WHERE NOT (birth_date > "1990-01-01" AND points > 1000);

-- FROM THE ORDER_ITEMS TABLE, GET THE ITEMS FOR ORDER #6 WHERE THE TOTAL PRICE IS > 30
SELECT * FROM
order_items
WHERE order_id = 6 AND (quantity  * unit_price) > 30;
-- -----------------------------

-- USE THE SELECT WITH THE IN OPERATORS TO FILTER RESULTS
-- USE THE IN OPERATOR WHEN YOU WANT TO COMPARE AND ATTRIBUTE WITH A LIST OF VALUES

-- SELECT ALL CUSTOMERS LOCATED IN VA, FL AND CO
SELECT * 
FROM Customers
WHERE state IN ( "VA", "FL", "CO");

-- SELECT ALL CUSTOMERS NOT LOCATED IN VA, FL OR CO
SELECT * 
FROM Customers
WHERE state NOT IN ( "VA", "FL", "CO");

-- SELECT ALL PROODUCTS WHERE QUANTITY =  69,38,OR 72
SELECT * 
FROM products
WHERE quantity_in_stock IN ( 26, 38, 72,90);
-- ----------------------------------

-- USE THE SELECT WITH THE "BETWEEN" OPERATORS TO FILTER RESULTS

-- SELECT ALL CUSTOMERS WITH POINTS >= 1000 AND 300
SELECT * 
FROM Customers
WHERE points BETWEEN 1000 and 3000;

-- SELECT CUSTOMERS BORN BETWWEEN 1990 AND 2020
SELECT * 
FROM Customers
WHERE birth_date BETWEEN "1990-01-01" and "2000-01-01";
-- -----------------------------

-- USE THE SELECT WITH THE "LIKE" OPERATORS TO FILTER RESULTS.
-- THE OPERATOR IS NOT CASE  SENSITIVE, THE LETTERS CAN BE A CAPITAL OR LOWER CASE,  SAME RESULT WILL BE DISPLAYED
-- %  REPRESENTS ANY  NUMBER OF CHARACTERS.
--  _ REPRESENTS.  A. SINGLE. CAHARACTER

-- SELECT ALL CUSTOMERS WITH LAST_NAME START WITH "b"
SELECT * 
FROM Customers
WHERE last_name LIKE 'b%';

-- SELECT ALL CUSTOMERS WITH LAST_NAME CONTAINS "b"
SELECT * 
FROM Customers
WHERE last_name LIKE '%b%';

-- SELECT ALL CUSTOMERS WITH LAST_NAME ENDS WITH  "Y"
SELECT * 
FROM Customers
WHERE last_name LIKE '%Y';

-- SELECT ALL CUSTOMERS WITH LAST_NAME IS EXACLY 5 CHARACTTERS LONG AND END WITH A "Y". THE UNDERSCORES REPRESENT  THE NUMBER OF CAHARACTERS DESIRED."
-- THIS SPECIFIC EXAMPLE CONTAINS 5 UNDERSCORES _____Y
SELECT * 
FROM Customers
WHERE last_name LIKE '_____Y';

-- SELECT ALL CUSTOMERS WITH LAST_NAME CONTAINS EXACLY5 CHARACTERS LONG THAT STARTS  WITH "B" AND END WITH A "Y". THE UNDERSCORES REPRESENT  THE NUMBER OF CAHARACTERS DESIRED."
-- THIS SPECIFIC EXAMPLE CONTAINS 5 UNDERSCORES B____Y
SELECT * 
FROM Customers
WHERE last_name LIKE 'B____Y';

SELECT *
FROM customers
WHERE address LIKE '%TRAIL%' or '%AVENUE%';

SELECT *
FROM customers
WHERE phone LIKE '%9';

SELECT *
FROM customers
WHERE phone NOT LIKE '%9';
--  -------------------------

-- USE THE SELECT WITH THE "REGEXP" OPERATORS TO FILTER RESULTS.
--  ^ BEGINNING
-- 	•	$ END. 
-- 	•	| LOGICAL OR
-- 	•	[ABC] BEFOR
--      [A-T]

-- SELECT ALL CUSTOMERS WHERE THEIR LAST NAME HAS THE WORD "FILED" IN IT
SELECT *
FROM customers
WHERE last_name  REGEXP 'field';

-- -- SELECT ALL CUSTOMERS WHERE THEIR LAST NAME HAS THE WORD "FILED" IN IT
SELECT *
FROM customers
WHERE last_name  REGEXP '^field%$';

-- SELECT ALL CUSTOMERS WHERE THEIR LAST NAME HAS THE WORD "FIELD OR MAC" IN IT

SELECT *
FROM customers
WHERE last_name  REGEXP 'field|mac';

SELECT *
FROM customers
WHERE last_name  REGEXP 'field|mac|’row';

-- SELECT ALL CUSTOMERS. THAT HAS "GE,IE OR ME"  IN THIER LAST_NAME
SELECT *
FROM customers
WHERE last_name  REGEXP '[gim]e';

-- GET THE CUSTOMERS WHOS LAST NAMES ARE ELKA OR AMBUR
SELECT *
FROM customers
WHERE first_name  REGEXP 'elka|ambur';

-- GET THE CUSTOMERS WHOS LAST NAME END WITH "EY" OR "ON"
SELECT *
FROM customers
WHERE last_name  REGEXP 'ey$|on$';

-- GET THE CUSTOMERS WHOS LAST NAMES START WITH "MY" OR CONTAINS "SE"
SELECT *
FROM customers
WHERE last_name  REGEXP '^my|se';

-- GET THE CUSTOMERS WHOS LAST NAMES CONTAINS "B" FOLLOW BY "R" OR "U"
SELECT *
FROM customers
WHERE last_name  REGEXP 'b[r|u]';
-- -------------------------------------

-- USE THE SELECT WITH THE "IS" OPERATORS TO FILTER RESULTS.
SELECT * 
FROM customers
WHERE phone is NULL;

SELECT * 
FROM customers
WHERE phone is NOT NULL;

SELECT *
FROM orders
WHERE shipper_id IS NULL;
--  --------------------------

-- USE THE SELECT WITH THE "ORDER BY, DESC, ASC, LIMIT " CLAUSE TO SORT YOUR QUERY.
-- WHEN ORDER BY CLAUSE CAN BE USE WITH ALIAS, MATHMATICAL EXPRESSIONS, COLMNS EXT..
SELECT *
FROM order_items
WHERE order_id = 2
ORDER BY quantity * unit_price DESC;

SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC;

SELECT * 
FROM customers
WHERE phone is NOT NULL
LIMIT 6 ;

SELECT * 
FROM customers
LIMIT 10 ;

-- SELECT ALL CUSTOMERS FROM 7-9
SELECT * 
FROM customers
LIMIT 6, 3 ;

-- Clause orders
-- SELECT
-- FROM
-- WHERE
-- ORDER BY
-- LIMIT