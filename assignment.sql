-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT

-- Task – Select all records from the Employee table.
SET SCHEMA 'chinook';
SELECT * FROM employee;

-- Task – Select all records from the Employee table where last name is King.
SET SCHEMA 'chinook';
SELECT * FROM employee
where employee.lastname = 'King';

-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SET SCHEMA 'chinook';
SELECT * FROM employee
where employee.firstname = 'Andrew'
and employee.reportsto IS NULL;

-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SET SCHEMA 'chinook';
SELECT * FROM album
ORDER BY title DESC
-- Task – Select first name from Customer and sort result set in ascending order by city
SET SCHEMA 'chinook';
SELECT customer.firstname FROM customer
ORDER BY firstname ASC

-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
SET SCHEMA 'chinook';
INSERT INTO genre(genreid, name) VALUES(26, 'Electric Guitar');
INSERT INTO genre(genreid, name) VALUES(27, 'Video Game');
-- Task – Insert two new records into Employee table
SET SCHEMA 'chinook';
INSERT INTO employee(employeeid, lastname, firstname, title) VALUES(9, 'Fabres', 'Daniel', 'Programmer');
INSERT INTO employee(employeeid, lastname, firstname, title) VALUES(10, 'Yes', 'Yes', 'Yes');
-- Task – Insert two new records into Customer table
SET SCHEMA 'chinook';
INSERT INTO customer(customerid, firstname, lastname, email, supportrepid) VALUES (60, 'Daniel', 'Fabres', 'possible', 3);
INSERT INTO customer(customerid, firstname, lastname, email, supportrepid) VALUES (61, 'Paul', 'yes','maybe', 4);

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
SET SCHEMA 'chinook';
UPDATE customer
SET firstname = 'Robert', lastname = 'Walter'
WHERE firstname = 'Aaron' AND lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
SET SCHEMA 'chinook';
UPDATE artist
SET name = 'CCR'
WHERE name = 'Creedence Clearwater Revival';

-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
SET SCHEMA 'chinook';
SELECT * FROM invoice
WHERE billingaddress LIKE 'T%'

-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
SET SCHEMA 'chinook';
SELECT * FROM invoice
WHERE total BETWEEN 15 AND 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SET SCHEMA 'chinook';
SELECT * FROM employee
WHERE hiredate BETWEEN '2003-06-01 00:00:00' AND '2004-03-01 00:00:00';

-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
SET SCHEMA 'chinook';

DELETE FROM invoiceline
WHERE invoiceid IN (
	SELECT invoiceid from invoice
	WHERE customerid = (
		SELECT customerid from customer
		WHERE firstname = 'Robert' AND lastname = 'Walter')
);

DELETE FROM invoice
WHERE customerid = (
	SELECT customerid from customer
	WHERE firstname = 'Robert' AND lastname = 'Walter');

DELETE FROM customer
WHERE firstname = 'Robert' AND lastname = 'Walter';


-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- Make functions?

-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.

SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION cur_time()
RETURNS text AS $$ -- Delimiter
	BEGIN -- starts a transaction
		RETURN CURRENT_TIME;
	END;
$$ LANGUAGE plpgsql;
-- SELECT cur_time();

-- Task – create a function that returns the length of a mediatype from the mediatype tagble
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION media_len(media integer)
RETURNS text AS $$ -- Delimiter
	DECLARE 
		xy TEXT;
	BEGIN -- starts a transaction
		SELECT name INTO xy 
		FROM mediatype
		WHERE mediatypeid = media;
		return length(xy);
	END;
$$ LANGUAGE plpgsql;

-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION avg_num()
RETURNS text AS $$ -- Delimiter
	DECLARE 
		xy INTEGER;
	BEGIN -- starts a transaction
		SELECT AVG(total) INTO xy 
		FROM invoice;
		return xy;
	END;
$$ LANGUAGE plpgsql;
--huh???????

-- Task – Create a function that returns the most expensive track
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION max_track()
RETURNS text AS $$ -- Delimiter
	DECLARE 
		xy INTEGER;
	BEGIN -- starts a transaction
		SELECT MAX(unitprice) INTO xy 
		FROM track;
		return xy;
	END;
$$ LANGUAGE plpgsql

-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION avg_price()
RETURNS text AS $$ -- Delimiter
	DECLARE 
		xy INTEGER;
	BEGIN -- starts a transaction
		SELECT AVG(unitprice) INTO xy 
		FROM invoiceline;
		return xy;
	END;
$$ LANGUAGE plpgsql;

-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION avg_price()
RETURNS table(
	employee_fname varchar(20),
	employee_lname varchar(20),
	employee_bdate timestamp
) AS $$ -- Delimiter
	BEGIN -- starts a transaction
		RETURN QUERY
			SELECT employee.firstname as employee_fname, employee.lastname as employee_lname, employee.birthdate as employee_bdate
			FROM employee
			WHERE employee.birthdate >= '1969-01-01 00:00:00';
	END;
$$ LANGUAGE plpgsql;

-- 4.0 Stored Procedures
-- In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.
-- make fns?

-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION emp_name()
RETURNS table(
	employee_fname varchar(20),
	employee_lname varchar(20)
) AS $$ -- Delimiter
	BEGIN -- starts a transaction
		RETURN QUERY
			SELECT employee.firstname as employee_fname, employee.lastname as employee_lname
			FROM employee;
	END;
$$ LANGUAGE plpgsql;


-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION emp_update(emp_id integer, emp_fname varchar(20), emp_lname varchar(20))
RETURNS void
 AS $$ -- Delimiter
	BEGIN -- starts a transaction
			UPDATE employee
			SET firstname = emp_fname, lastname = emp_lname
			WHERE employeeid = emp_id;
	END;
$$ LANGUAGE plpgsql;

-- Task – Create a stored procedure that returns the managers of an employee.
SET SCHEMA 'chinook';

--subqueries
-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION cust_comp(cust_id Integer)
RETURNS table(
	cust_fname varchar(40),
	cust_lname varchar(20),
	cust_company varchar(80)
) AS $$ -- Delimiter
	BEGIN -- starts a transaction
		RETURN QUERY
			SELECT customer.firstname as cust_fname, customer.lastname as cust_lname, customer.company as cust_company
			FROM customer
			WHERE customerid = cust_id;
	END;
$$ LANGUAGE plpgsql;

-- 5.0 Transactions
-- just write the code
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
SET SCHEMA 'chinook';
DELETE FROM invoiceline
WHERE invoiceid IN (
	SELECT invoiceid from invoice
	WHERE invoiceid = 1);
	
DELETE FROM invoice
WHERE invoiceid = 1;

-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION cust_new(cust_id integer, cust_fname varchar(20), cust_lname varchar(20), cust_email varchar(60))
RETURNS void
 AS $$ -- Delimiter
	BEGIN -- starts a transaction
			INSERT INTO customer(customerid, firstname, lastname, email)
			VALUES(cust_id, cust_fname, cust_lname, cust_email);
	END;
$$ LANGUAGE plpgsql;

-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.

-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION trig_function()
RETURNS TRIGGER AS $$
BEGIN
	IF(TG_OP = 'INSERT') THEN
		SELECT * FROM employee;
 		END IF;
 	RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER emp_trig
BEFORE INSERT ON employee
EXECUTE PROCEDURE trig_function();

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION trig_function()
RETURNS TRIGGER AS $$
BEGIN
	IF(TG_OP = 'INSERT') THEN
		SELECT * FROM album;
 		END IF;
 	RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER emp_trig
BEFORE INSERT ON album
EXECUTE PROCEDURE trig_function();

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
SET SCHEMA 'chinook';
CREATE OR REPLACE FUNCTION trig_function()
RETURNS TRIGGER AS $$
BEGIN
	IF(TG_OP = 'DELETE') THEN
		SELECT * FROM customer;
 		END IF;
 	RETURN NEW; -- return new so that it will put the data into the users table still
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER emp_trig
BEFORE DELETE ON customer
EXECUTE PROCEDURE trig_function();

-- 6.2 Before
-- Task – Create a before trigger that restricts the deletion of any invoice that is priced over 50 dollars.
SET SCHEMA 'chinook';


-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.

-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SET SCHEMA 'chinook';
SELECT customer.firstname, customer.lastname, invoice.invoiceid 
FROM customer
INNER JOIN invoice on customer.customerid = invoice.customerid

-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SET SCHEMA 'chinook';
SELECT customer.customerid, customer.firstname, customer.lastname, invoice.invoiceid, invoice.total
FROM customer
FULL OUTER JOIN invoice on customer.customerid = invoice.customerid

-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SET SCHEMA 'chinook';
SELECT artist.name, album.title
FROM album
RIGHT JOIN artist ON artist.artistid = album.artistid

-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SET SCHEMA 'chinook';
SELECT artist.name, album.title
FROM album
CROSS JOIN artist ORDER BY artist.name ASC

-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SET SCHEMA 'chinook';
SELECT one.firstname, one.lastname, two.firstname, two.lastname
FROM employee one
INNER JOIN employee two ON one.reportsto = two.reportsto








