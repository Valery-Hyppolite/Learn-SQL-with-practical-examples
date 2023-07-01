-- store and organized sql, data security, faster execution, LIKE FUNCTIONS
DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT * FROM clients;
END$$
DELIMITER ;

-- used the CALL action to execute the function or procedure
-- CALL get_clients

DELIMITER $$
CREATE PROCEDURE get_balance()
BEGIN
	SELECT * FROM invoice_balance
    WHERE payment_total > 0;
END$$
DELIMITER ;
CALL get_balance;

DROP PROCEDURE IF EXISTS get_clients;

-- ADD PARAMETERS TO STORE PROCEDURE
DELIMITER $$
CREATE PROCEDURE get_client_by_state( state CHAR(2))
BEGIN
	
    -- create a default value by using the if statement
	IF state IS NULL THEN
    SET state = 'TX';
    END IF;
	SELECT * FROM clients c
    WHERE c.state = state;
END$$
DELIMITER ;
CALL get_client_by_state(NULL);

-- OR WE CAN RETURN ALL STATE AS A CONDITION IF THE PARAM DOES NOT MATCH 
DELIMITER $$
CREATE PROCEDURE get_client_by_state( state CHAR(2))
BEGIN
	-- create a default value by using the if statement
	IF state IS NULL THEN
		SELECT * FROM clients;
	ELSE
		SELECT * FROM clients c
		WHERE c.state = state;
	END IF;
END$$
DELIMITER ;
CALL get_client_by_state(NULL);


DELIMITER $$
CREATE PROCEDURE get_client_invoice( clientID INT )
BEGIN
	SELECT * FROM invoices
    WHERE  client_id = clientID;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS get_client_by_state;
CALL get_client_invoice(3);

DELIMITER $$
CREATE PROCEDURE get_payment( clientID INT, payment_methodID TINYINT )
-- this IFNULL option below act the same way as the if statement above with the get-CLIENT_INVOICE
-- that method is less verbose and more clean, but botH do essentially the same thing. same result.
BEGIN
	SELECT * FROM sql_invoicing.payments pay
    WHERE  pay.client_id = IFNULL(clientID, client_id) AND 
    pay.payment_method = IFNULL(payment_methodID, payment_method);
END$$
DELIMITER ;
CALL get_payment(3,NULL)

DELIMITER $$
CREATE PROCEDURE update_payment( 
	invoice_id INT, 
	payment_amount DECIMAL(9,2), 
	payment_date DATE
)
BEGIN
	IF payment_amount <= 0 THEN
		SIGNAL SQLSTATE '22003' 
		SET MESSAGE_TEXT = 'No NEGATIVE number allowed';
	END IF;
    
	UPDATE invoices i
    SET i.payment_total = (i.payment_total + payment_amount),i.payment_date = payment_date
	WHERE i.invoice_id = invoice_id;
END$$
DELIMITER ;
CALL update__payment(11, 20, '2020-02-05')

DELIMITER $$
CREATE PROCEDURE get_unpaid_invouces( client_id INT, OUT invoice_count INT, OUT invoice_total DECIMAL)
BEGIN
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoice_count, invoice_total
    FROM invoices i
    WHERE i.lient_id = client_id and 
		payment_total = 0;
	
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE get_risk_factor()
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoice_count DECIMAL(9,2);
    DECLARE invoice_total INT;
    
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoice_count, invoice_total
    FROM invoices;
    
    SET risk_factor = invoice_total / invoice_count * 5;
    
    SELECT risk_factor;
END$$
DELIMITER ;

-- user or session variable. define variable in sql
-- SET @invoice_count = 0

-- CREATE YOUR OWN FUNCTIONS, THESE FUNCTIONS ONY RETURN 1 ROW, @**COME BACK TO THIS, NOT WORKING 
DELIMITER $$
CREATE FUNCTION get_risk_factor_for_client(clientID INT)
RETURNS INTEGER
READS SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoice_count DECIMAL(9,2);
    DECLARE invoice_total INT;
    
	SELECT COUNT(*), SUM(invoice_total)
    INTO invoice_count, invoice_total
    FROM invoices i
    WHERE i.client_id = clientID;
    
    SET risk_factor = invoice_total / invoice_count * 5;
    
    RETURN risk_factor;
END$$
DELIMITER ;

SELECT client_id, name, get_risk_factor_for_clien(client_id)
FROM clients;



DELIMITER $$
DROP PROCEDURE IF EXISTS add_new_user;
CREATE PROCEDURE add_new_user(first_name VARCHAR(50), 
last_name VARCHAR(50), 
address VARCHAR(50), 
city VARCHAR(50),
state VARCHAR(2),
points INT
)
BEGIN
INSERT INTO sql_store.customers(first_name, last_name, address, city, state, points)
VALUES (NEW.first_name, NEW.last_name, NEW.address, NEW.city, NEW.state, NEW.points);
-- VALUES ('valery', 'HYPP', '8670 nw 25st', 'sun', 'NY', 50);
SELECT LAST_INSERT_ID();

END$$
DELIMITER ;
CALL add_new_user('val', 'varchar', '7675 nw 3st', 'sun', 'NY', 67)

-- DELIMITER $$
-- CREATE PROCEDURE create_user()
-- BEGIN
-- 	INSERT INTO clients(name, address, city, state)
--     VALUES('Valery', 'Hyppolite', '1031 ne, 196st', 'Miami', 'FL')
--     SELECT LAST_INSERT_ID();
-- END$$
-- DELIMITER ;








