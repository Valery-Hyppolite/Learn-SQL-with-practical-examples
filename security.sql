
-- create a user with a specific ip address they can connect to.
CREATE USER  john@127.0.0.1;
-- allow user to connect to domain and any subdomain;
CREATE USER  john@'%.domain name of cooporation';

-- create user with pssword. john can connect from anywhere
CREATE USER  john IDENTIFIED BY 'Passw@rd123';

-- set or change user passord
SET PASSWORD FOR john = '1234';

-- to change the password of the current login user
SET password = '1234';

-- delete or drop a user
DROP USER john;

SELECT * FROM mysql.user;

-- CREATE USER WITH PERMISION PRIVILEDGE
CREATE USER valery IDENTIFIED BY 'V@lery2023.';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, CREATE VIEW
ON sql_store.*
TO valery;

-- give user all priviledge to all table and database. check out the mysql priviledge doc
	GRANT ALL
    ON *.*
    TO john;
    
-- REVOKE PRIVILEDGES
REVOKE CREATE VIEW 
ON sql_store.*
FROM valery;
-- HOW TO VIEW PERMISIONs FOR A USER
SHOW GRANTS FOR valery;
