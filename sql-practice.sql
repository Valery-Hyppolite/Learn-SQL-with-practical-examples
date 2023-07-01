

-- SUBQUERIES, CREATING/UPDATE.DELETE VIEWS,UNION
USE sqL_invoicing;

SELECT  

	'first half. of 20219' AS date_range,
	SUM(payment_total) AS sum_total, 
	SUM(invoice_total) AS total_sales, 
    SUM(invoice_total - payment_total) AS  'what we expext'
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT  
	'second half. of 20219' AS date_range,
	SUM(payment_total) AS sum_total, 
	SUM(invoice_total) AS total_sales, 
    SUM(invoice_total - payment_total) AS  'what we expext'
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT  

	'first half. of 20219' AS date_range,
	SUM(payment_total) AS sum_total, 
	SUM(invoice_total) AS total_sales, 
    SUM(invoice_total - payment_total) AS  'what we expext'
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT  

	'TOTAL' AS date_range,
	SUM(payment_total) AS sum_total, 
	SUM(invoice_total) AS total_sales, 
    SUM(invoice_total - payment_total) AS  'what we expext'
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31';


-- SELECT date, SUM(amount) AS total_payment, pm.name AS payment_method
-- FROM payments p
-- JOIN payment_methods pm
-- 	ON p.payment_id = pm.payment_method_id
-- GROUP BY date, payment_method;

-- CREATE VIEW sales_by_client AS
-- SELECT c.client_id, c.name, SUM(invoice_total) AS totalsales
-- FROM clients c
-- JOIN invoices isales_by_client
-- 	USING(client_id)
-- GROUP BY client_id, name;

CREATE VIEW client_balance AS
SELECT c.client_id, c.name, SUM(i.invoice_total - i.payment_total) AS balnace
FROM clients c
JOIN invoices i
	USING(client_id)
GROUP BY client_id, name;

-- DROP VIEW client_balance
-- CREATE OR REPLACE VIEW -- ALLOW YOU TO EDIT THE VIEW WITHOUT HAVING TO DROP IT. 
-- If a view does not have and Aggregate functions, not Union, this view can be updated. 
CREATE OR REPLACE VIEW invoice_balance AS
SELECT invoice_id, number, 
client_id, invoice_total, 
payment_total, 
(invoice_total - payment_total) AS invoice_balance,
invoice_date, Due_date, payment_date
FROM sql_invoicing.invoices
WHERE (invoice_total - payment_total) > 0
WITH CHECK OPTION;

CREATE OR REPLACE VIEW invoice_balance1 AS
SELECT invoice_id, number, 
client_id, invoice_total, 
payment_total, 
(invoice_total - payment_total) AS invoice_balance,
invoice_date, Due_date, payment_date
FROM sql_invoicing.invoices;
-- WHERE (invoice_total - payment_total) > 0
-- WITH CHECK OPTION;

-- WITH THE "CHECK OPTION" PREVENT THE VIEW FROM DELETING A ROW WHEN UPDATING IT.

-- THEN WE CAN DELETE/ UPDATE THIS TABLE
DELETE FROM invoice_balance
WHERE invoice_id = 1;

UPDATE invoice_balance
SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
WHERE invoice_id = 2;

UPDATE invoice_balance1
SET payment_total = invoice_total
WHERE invoice_id = 2;

-- VIEW ARE A GREATE WAY TO MODIFY YOUR DATA WITHOUT HAVING TO CHANGE YOUR DATABASE.
--  OR TO MAKE CHANGE TO  A  DATABASE TABLE WHEN  YOU HAVE NO  PERMISSIONS.
-- use view for data security, remove impact from the underline table, and too  simplify your query




-- ANY, SOME, ALL

SELECT *
FROM invoices
WHERE invoice_total > ALL (
	SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
);
-- BOTH ARE THE SAME, JUST DIFFERENT WAY OF DOING IT.
SELECT *
FROM invoices
WHERE invoice_total > (
	SELECT MAX(invoice_total)
    FROM invoices
    WHERE client_id = 3
);

SELECT *
FROM clients
WHERE client_id IN (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) >= 2
);

-- SAME AS ABOVE, IN OR ANY, BOTH WAY ARE THE SAME, DIFFERENT APPROACH

SELECT *
FROM clients
WHERE client_id = ANY (
	SELECT client_id
	FROM invoices
	GROUP BY client_id
	HAVING COUNT(*) >= 2
);

SELECT * 
FROM sql_invoicing.clients c
WHERE EXISTs (
	SELECT client_id
    FROM sql_invoicing.invoices
    WHERE client_id = c.client_id
    );
    -- same as above. better to use the exit keywork when having a large set of data
-- SELECT * 
-- FROM sql_invoicing.clients c
-- WHERE clientt_id IN (
-- 	SELECT client_id
--     FROM sql_invoicing.invoices
--     WHERE client_id = c.client_id
--     );
    
SELECT * 
FROM sql_store.products p
WHERE NOT EXISTS (
	SELECT product_id
    FROM sql_store.order_items
    WHERE product_id = p.product_id
    )
    
    
    
    
    
    









