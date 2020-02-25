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




 