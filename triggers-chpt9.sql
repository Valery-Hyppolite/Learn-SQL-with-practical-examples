-- TRIGGERS is a block of code that get executed before or after an insert, update, delete statement.
DELIMITER $$
DROP TRIGGER IF EXISTS payment_after_insert;

CREATE TRIGGER payment_after_insert
	AFTER INSERT ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total + NEW.amount
    WHERE invoice_id = NEW.invoice_id;
    INSERT INTO payments_audithost_summary_by_statement_type
    VALUES(NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW() );

END $$
DELIMITER ;

INSERT INTO payments
VALUES (DEFAULT, 3, 11,'2019-01-01',30,1);
-- ===========================

DELIMITER $$
DROP TRIGGER IF EXISTS payment_after_delete;
CREATE TRIGGER payment_after_delete
	AFTER DELETE ON payments
    FOR EACH ROW
BEGIN
	UPDATE invoices
    SET payment_total = payment_total - OLD.amount
    WHERE invoice_id = OLD.invoice_id;
    
    INSERT INTO payments_audit
    VALUES(OLD.client_id, OLD.date, OLD.amount, 'Delete', NOW() );

END $$
DELIMITER ;

DELETE 
FROM payments
WHERE payment_id = 10;

-- SEE TRIGGERS CREATED
SHOW TRIGGERS ;
-- LIKE 'PAYMENTS%';

-- 
DROP TRIGGER IF EXISTS paymeny_after_delete;

-- ==================create an audit table to keep record of changes====
CREATE TABLE payments_audit 
(
	client_id         INT            NOT NULL,
    date              DATE           NOT NULL,
    amount            DECIMAL(9,2)   NOT NULL,
    action_type       VARCHAR(50)    NOT NULL,
    action_date       DATETIME       NOT NULL
);

-- ----============EVENTS-CODE THAT GET EXECUTED ON A SCHEDULE=========
SHOW VARIABLES LIKE 'event%';
-- if not on set it to one
SET GLOBAL event_scheduler = OFF;

DELIMITER $$ 
CREATE EVENT monthly_delete_audit
ON SCHEDULE
	-- AT '2021-02-22' IF YOU TO RUN THIS EVEN ONCE
    EVERY 1 MONTH STARTS '2023-05-01' ENDS '2023-12-31'
DO BEGIN
	DELETE FROM payment_audit
    WHERE action_date < NOW() - INTERVAL 1 MONTH;
END $$
DELIMITER ;


-- ========ALTER NN EVEN WITHOUT DROPPING IT
DELIMITER $$ 
ALTER EVENT monthly_delete_audit
ON SCHEDULE
	-- AT '2021-02-22' IF YOU TO RUN THIS EVEN ONCE
    EVERY 1 MONTH STARTS '2023-05-01' ENDS '2023-12-31'
DO BEGIN
	DELETE FROM payment_audit
    WHERE action_date < NOW() - INTERVAL 1 MONTH;
END $$
DELIMITER ;

SHOW EVENTS;
DROP EVENT IF EXISTS montly_delete_audit;
-- WE CAN ALSO ALTER IT TO DEIABLE THE EVEN
ALTER EVENT monthly_delete_audit DISABLE -- OR EBNABLE

