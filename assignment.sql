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

-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
SET SCHEMA 'chinook';

-- Task – create a function that returns the length of a mediatype from the mediatype table
SET SCHEMA 'chinook';


-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
SET SCHEMA 'chinook';

-- Task – Create a function that returns the most expensive track
SET SCHEMA 'chinook';


-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
SET SCHEMA 'chinook';


-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
SET SCHEMA 'chinook';


-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.

-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
SET SCHEMA 'chinook';


-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
SET SCHEMA 'chinook';

-- Task – Create a stored procedure that returns the managers of an employee.
SET SCHEMA 'chinook';


-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
SET SCHEMA 'chinook';


-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
SET SCHEMA 'chinook';

-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
SET SCHEMA 'chinook';


-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.

-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
SET SCHEMA 'chinook';

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
SET SCHEMA 'chinook';

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
SET SCHEMA 'chinook';


-- 6.2 Before
-- Task – Create a before trigger that restricts the deletion of any invoice that is priced over 50 dollars.
SET SCHEMA 'chinook';


-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.

-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SET SCHEMA 'chinook';


-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SET SCHEMA 'chinook';


-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SET SCHEMA 'chinook';


-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SET SCHEMA 'chinook';


-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SET SCHEMA 'chinook';









