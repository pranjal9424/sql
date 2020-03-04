show databases;

use classicmodels;
show tables;

select * from employees;
select * from payments;
 select * from customers;
 select * from offices;
 select * from orderdetails;
 select * from orders;
 select * from products;
 select * FROM productlines;
 
 #_____________________________________________________________________________________________________________________________________________________________
 
 #Introduction to the MySQL INSERT statement
/*The INSERT statement allows you to insert one or more rows into a table. The following illustrates the syntax of the INSERT statement:*/

CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    priority TINYINT NOT NULL DEFAULT 3,
    description TEXT,
    PRIMARY KEY (task_id)
);

insert INTO tasks(title,priority)
values ('Learn mysql insert statement' ,1); 

select * from tasks;

#2) MySQL INSERT – Inserting rows using default value example
/*If you want to insert a default value into a column, you have two ways:

Ignore both the column name and value in the INSERT statement.
Specify the column name in the INSERT INTO clause and use the DEFAULT keyword in the VALUES clause.*/


/*In this example, we specified the priority column and the  DEFAULT keyword.

Because the default value for the column priority is 3 as declared in the table definition:*/
insert into tasks(title,priority)
values ('understanding defualt',default);

#3) MySQL INSERT – Inserting dates into the table example
/*To insert a literal date value into a column, you use the following format:*/

INSERT INTO tasks(title, start_date, due_date)
VALUES('Insert date into table','2018-01-09','2018-09-15');

#4) MySQL INSERT – Inserting multiple rows example
/*The following statement inserts three rows into the tasks table:*/

INSERT INTO tasks(title, priority)
VALUES
    ('My first task', 1),
    ('It is the second task',2),
    ('This is the third task of the week',3);
    
#MySQL INSERT multiple rows limit
/*In theory, you can insert any number of rows using a single INSERT statement. However, when MySQL server receives the INSERT statement whose size is bigger than max_allowed_packet, it will issue a packet too large error and terminates the connection.*/
/*The number is the Value column is the number of bytes.*/

    SHOW VARIABLES LIKE 'max_allowed_packt';

/*where size is an integer that represents the number the maximum allowed packet size in bytes.

Note that the max_allowed_packet has no influence on the INSERT INTO .. SELECT statement. The INSERT INTO .. SELECT statement can insert as many rows as you want.*/


#_____________________________________________________________________________________________________________________________________________________________________________

#MySQL INSERT INTO SELECT Overview
/*Besides using row values in the VALUES clause, you can use the result of a SELECT statement as the data source for the INSERT statement.*/
	

CREATE TABLE suppliers (
    supplierNumber INT AUTO_INCREMENT,
    supplierName VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    addressLine1 VARCHAR(50),
    addressLine2 VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(50),
    country VARCHAR(50),
    customerNumber INT,
    PRIMARY KEY (supplierNumber)
);


INSERT INTO suppliers (
    supplierName, 
    addressLine1,
    city,
    postalCode,
    country
)
SELECT 
    customersName,
    Address,

    city,
    postalCode,
    country
FROM 
    customers;
    
    
    SELECT * FROM suppliers;
    
    
#Using SELECT statement in the VALUES list
/*First, create a new table called stats:*/

create table stats(
totalProduct int ,
totalCustomer int,
totalOrder int);


insert into stats(totalProduct,totalCustomer,totalOrder)
values (
(select count(*) from products),
(select count(*) from customers),
(select count(*) from orders)
);

SELECT * FROM stats;


#_____________________________________________________________________________________________________________________________________________________________________________

#Introduction to MySQL INSERT IGNORE statement
/*However, if you use the INSERT IGNORE statement, the rows with invalid data that cause the error are ignored and the rows with valid data are inserted into the table.*/

CREATE TABLE subscribers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(50) NOT NULL unique
);

INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com');


INSERT INTO subscribers(email)
VALUES('john.doe@gmail.com'), 
      ('jane.smith@ibm.com');
      
INSERT IGNORE INTO subscribers(email)
VALUES('john.doe@gmail.com'), 
      ('jane.smith@ibm.com');
      
      SHOW WARNINGS;
      
      SELECT * from subscribers;
      
      #_________________________________________________________________________________________________________________________________________________________________________
      
      #Introduction to MySQL UPDATE statement

/*First, specify the name of the table that you want to update data after the UPDATE keyword.
Second, specify which column you want to update and the new value in the SET clause. To update values in multiple columns, you use a list of comma-separated assignments by supplying a value in each column’s assignment in the form of a literal value, an expression, or a subquery.
Third, specify which rows to be updated using a condition in the WHERE clause. The WHERE clause is optional. If you omit it, the UPDATE statement will update all rows in the table.*/
      
/*Notice that the WHERE clause is so important that you should not forget. Sometimes, you may want to update just one row; However, you may forget the WHERE clause and accidentally update all rows of the table.*/
    
#MySQL supports two modifiers in the UPDATE statement.

/*The LOW_PRIORITY modifier instructs the UPDATE statement to delay the update until there is no connection reading data from the table. The LOW_PRIORITY takes effect for the storage engines that use table-level locking only such as MyISAM, MERGE, and MEMORY.
The IGNORE modifier enables the UPDATE statement to continue updating rows even if errors occurred. The rows that cause errors such as duplicate-key conflicts are not updated.*/    

#First, find Mary’s email from the employees table using the following SELECT statement:

select 
firstname,
lastname,
email
from
employees
where 
employeeNumber = 1056;

#Second, update the email address of Mary to the new email pranjalgupta9424@gmail.com :

update employees
set
email='pranjalgupta9424@gmail.com'
where
employeeNumber = 1056;

select * from  employees where employeeNumber = 1056; 

#2) Using MySQL UPDATE to modify values in multiple columns
/*To update values in the multiple columns, you need to specify the assignments in the SET clause. For example, the following statement updates both last name and email columns of employee number 1056:*/

UPDATE employees 
SET 
    lastname = 'Hill',
    email = 'mary.hill@classicmodelcars.com'
WHERE
    employeeNumber = 1056;
    
    
#3) Using MySQL UPDATE to replace string example
/*The following example updates the domain parts of emails of all Sales Reps with office code 6:*/


UPDATE employees
SET email = REPLACE(email,'@classicmodelcars.com','@mysqltutorial.org')
WHERE
   jobTitle = 'Sales Rep' AND
   officeCode = 6;
   
#4) Using MySQL UPDATE to update rows returned by a SELECT statement example
/*You can supply the values for the SET clause from a SELECT statement that queries data from other tables.*/

SELECT 
    customername, 
    salesRepEmployeeNumber
FROM
    customers
WHERE
    salesRepEmployeeNumber IS NULL;
    
SELECT 
    employeeNumber
FROM
    employees
WHERE
    jobtitle = 'Sales Rep'
ORDER BY RAND()
LIMIT 1;

UPDATE customers 
SET 
    salesRepEmployeeNumber = (SELECT 
            employeeNumber
        FROM
            employees
        WHERE
            jobtitle = 'Sales Rep'
        ORDER BY RAND()
        LIMIT 1)
WHERE
    salesRepEmployeeNumber IS NULL;
    
    
    
    
    
    SELECT 
     salesRepEmployeeNumber
FROM
    customers 
WHERE
    salesRepEmployeeNumber IS NOT NULL;
    
    #update join
    /*You often use joins to query rows from a table that have (in the case of INNER JOIN) or 
    may not have (in the case of LEFT JOIN) matching rows in another table. In MySQL, you can use the JOIN clauses in the UPDATE statement to perform the cross-table update.*/
    
    /*MySQL UPDATE JOIN examples
We are going to use a new sample database named empdb in for demonstration. This sample database consists of two tables:

The  employees table stores employee data with employee id, name, performance, and salary.
The merits table stores employee performance and merit’s percentage.*/

CREATE DATABASE IF NOT EXISTS empdb;
 
USE empdb;
 
-- create tables
CREATE TABLE merits (
    performance INT(11) NOT NULL,
    percentage FLOAT NOT NULL,
    PRIMARY KEY (performance)
);
 
CREATE TABLE employees (
    emp_id INT(11) NOT NULL AUTO_INCREMENT,
    emp_name VARCHAR(255) NOT NULL,
    performance INT(11) DEFAULT NULL,
    salary FLOAT DEFAULT NULL,
    PRIMARY KEY (emp_id),
    CONSTRAINT fk_performance FOREIGN KEY (performance)
        REFERENCES merits (performance)
);
-- insert data for merits table
INSERT INTO merits(performance,percentage)
VALUES(1,0),
      (2,0.01),
      (3,0.03),
      (4,0.05),
      (5,0.08);
-- insert data for employees table
INSERT INTO employees(emp_name,performance,salary)      
VALUES('Mary Doe', 1, 50000),
      ('Cindy Smith', 3, 65000),
      ('Sue Greenspan', 4, 75000),
      ('Grace Dell', 5, 125000),
      ('Nancy Johnson', 3, 85000),
      ('John Doe', 2, 45000),
      ('Lily Bush', 3, 55000);
      
      
select * from employees;
select * from merits;
    
    
    UPDATE employees
        INNER JOIN
    merits ON employees.performance = merits.performance 
SET 
    salary = salary + salary * percentage;
    
    #MySQL UPDATE JOIN example with LEFT JOIN
/*Suppose the company hires two more employees:*/

INSERT INTO employees(emp_name,performance,salary)
VALUES('Jack William',NULL,43000),
      ('Ricky Bond',NULL,52000);
      
      
      /*To increase the salary for new hires, you cannot use the UPDATE INNER JOIN  statement because their performance data is not available in the merit  table. This is why the UPDATE LEFT JOIN  comes to the rescue.

The UPDATE LEFT JOIN  statement basically updates a row in a table when it does not have a corresponding row in another table.*/

update employees
     left join
     merits on employees.performance = merits.performance
     set 
        salary = salary + salary * 0.015
        where
          merits.percentage is null;
     
     select * from employees;
     
     #_____________________________________________________________________________________________________________________________________________________________________________

#Introduction to MySQL DELETE statement
/*To delete data from a table, you use the MySQL DELETE statement. The following illustrates the syntax of the DELETE statement:*/
    
    
    DELETE FROM employees 
WHERE
    emp_id = 9;
    
    #MySQL DELETE and LIMIT clause
/*If you want to limit the number of rows to be deleted, you use the LIMIT clause as follows:*/
    


DELETE FROM employees
ORDER BY emp_name 
LIMIT 5;

#MySQL ON DELETE CASCADE example
/*In the previous tutorial, you learned how to delete data from multiple related tables using a single DELETE statement.
 However, MySQL provides a more effective way called ON DELETE CASCADE referential action for a foreign key
 that allows you to delete data from child tables automatically when you delete the data from the parent table.*/
 
 /*Step 1. Create the buildings table:*/
 
 CREATE TABLE buildings (
    building_no INT PRIMARY KEY AUTO_INCREMENT,
    building_name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

/*Step 2. Create the rooms table:*/

CREATE TABLE rooms (
    room_no INT PRIMARY KEY AUTO_INCREMENT,
    room_name VARCHAR(255) NOT NULL,
    building_no INT NOT NULL,
    FOREIGN KEY (building_no)
        REFERENCES buildings (building_no)
        ON DELETE CASCADE
);

/*Step 3. Insert rows into the buildings table:*/

INSERT INTO buildings(building_name,address)
VALUES('ACME Headquaters','3950 North 1st Street CA 95134'),
      ('ACME Sales','5000 North 1st Street CA 95134');
      
/*Step 4. Query data from the buildings table:*/

SELECT * FROM buildings;

/*Step 5. Insert rows into the rooms table:*/

INSERT INTO rooms(room_name,building_no)
VALUES('Amazon',1),
      ('War Room',1),
      ('Office of CEO',1),
      ('Marketing',2),
      ('Showroom',2);
      
/*Step 6. Query data from the rooms table:*/

	
SELECT * FROM rooms;

/*Step 7. Delete the building with building no. 2:*/

DELETE FROM buildings 
WHERE building_no = 2;

/*Step 8. Query data from rooms table:*/

SELECT * FROM rooms;
SELECT * FROM buildings;

/*Tips to find tables affected by MySQL ON DELETE CASCADE action
Sometimes, it is useful to know which table is affected by the ON DELETE CASCADE  referential action when you delete data from a table. You can query this data from the referential_constraints in the information_schema  database as follows:*/

USE information_schema;
 
SELECT 
    table_name
FROM
    referential_constraints
WHERE
    constraint_schema = 'classicmodels'
        AND referenced_table_name = 'buildings'
        AND delete_rule = 'CASCADE'
        
#____________________________________________________________________________________________________________________________________________________________________________________

#MySQL DELETE JOIN with INNER JOIN
/*MySQL also allows you to use the INNER JOIN clause in the DELETE statement to delete rows from a table and the matching rows in another table.*/

DROP TABLE IF EXISTS t1, t2;
 
CREATE TABLE t1 (
    id INT PRIMARY KEY AUTO_INCREMENT
);
 
CREATE TABLE t2 (
    id VARCHAR(20) PRIMARY KEY,
    ref INT NOT NULL
);
 
INSERT INTO t1 VALUES (1),(2),(3);
 
INSERT INTO t2(id,ref) VALUES('A',1),('B',2),('C',3);

SELECT 
    c.customerNumber, 
    c.customerName, 
    orderNumber
FROM
    customers c
        LEFT JOIN
    orders o ON c.customerNumber = o.customerNumber
WHERE
    orderNumber IS NULL;
    
#_________________________________________________________________________________________________________________________________________________________________________________


#Introduction to MySQL REPLACE statement
/*The MySQL REPLACE statement is an extension to the SQL Standard. The MySQL REPLACE statement works as follows:

Step 1. Insert a new row into the table, if a duplicate key error occurs.

Step 2. If the insertion fails due to a duplicate-key error occurs:

Delete the conflicting row that causes the duplicate key error from the table.
Insert the new row into the table again.*/

CREATE TABLE cities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    population INT NOT NULL
);

INSERT INTO cities(name,population)
VALUES('New York',8008278),
      ('Los Angeles',3694825),
      ('San Diego',1223405);
      
      SELECT * FROM cities;
      
REPLACE INTO cities(id,population)
VALUES(2,3696820);

	
SELECT * FROM cities;

/*Using MySQL REPLACE statement to update a row
The following illustrates how to use the REPLACE statement to update data:*/

REPLACE INTO cities
SET id = 4,
    name = 'Phoenix',
    population = 1768980;
    
    	
SELECT * FROM cities;


#Using MySQL REPLACE to insert data from a SELECT statement
/*The following illustrates the REPLACE statement that inserts data into a table with the data come from a query.*/

REPLACE INTO 
    cities(name,population)
SELECT 
    name,
    population 
FROM 
   cities 
WHERE id = 1;

#_________________________________________________________________________________________________________________________________________________________________________________

#MySQL prepared statement usage
/*In order to use MySQL prepared statement, you use three following statements:

PREPARE – prepare a statement for execution.
EXECUTE – execute a prepared statement prepared by the PREPARE statement.
DEALLOCATE PREPARE – release a prepared statement.*/

PREPARE stmt1 FROM 
    'SELECT 
           productCode, 
            productName 
    FROM products
        WHERE productCode = ?';
        
        SET @pc = 'S10_1678';
        
        EXECUTE stmt1 USING @pc;
        
        SET @pc = 'S12_1099';
        
        EXECUTE stmt1 USING @pc;
        
        	
DEALLOCATE PREPARE stmt1;



 




 