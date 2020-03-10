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
 
 
 
 #___________________________________________________________________________________________________________________________________________________________________________________________
 
 #insert into select statement
 
 /*n this syntax, instead of using the VALUES clause, you can use a SELECT statement. The SELECT statement can retrieve data from one or more tables.

The INSERT INTO SELECT statement is very useful when you want to copy data from other tables to a table or to summary data from multiple tables into a table*/

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
)


SELECT 
    customerNumber,
    customerName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country
FROM
    customers
WHERE
    country = 'USA' AND 
    state = 'CA';
    
    
    INSERT INTO suppliers (
    supplierName, 
    phone, 
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    customerNumber
)
SELECT 
    customerName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state ,
    postalCode,
    country,
    customerNumber
FROM 
    customers
WHERE 
    country = 'USA' AND 
    state = 'CA';
    
    SELECT * FROM suppliers;
    
    
#use select option with multiple
    
INSERT INTO stats(totalProduct, totalCustomer, totalOrder)
VALUES(
    (SELECT COUNT(*) FROM products),
    (SELECT COUNT(*) FROM customers),
    (SELECT COUNT(*) FROM orders)
);

SELECT * FROM stats;

#__________________________________________________________________________________________________________________________________________________________________________

#Creating Databases
/*Before doing anything else with the data, you need to create a database. A database is a container of data. It stores contacts, vendors, customers or any kind of data that you can think of.*/

CREATE DATABASE IF NOT EXISTS prrrrrrrr;


show databases;


/*type of database

#  MyISAM
#  InnoDB
#  MERGE
#  MEMORY (HEAP)
#  ARCHIVE
#  CSV
#  FEDERATED


#MyISAM
/*The size of the MyISAM table can be up to 256TB, which is huge. In addition, MyISAM tables can be compressed into read-only tables to save spaces. At startup, MySQL checks MyISAM tables for corruption and even repairs them in a case of errors. The MyISAM tables are not transaction-safe.*/

#InnoDB
/* They are also optimal for performance. InnoDB table supports foreign keys, commit, rollback, roll-forward operations. The size of an InnoDB table can be up to 64TB.*/

# MEREGE
/*Using MERGE table, you can speed up performance when joining multiple tables. MySQL only allows you to perform SELECT, DELETE, UPDATE and INSERT operations on the MERGE tables. If you use DROP TABLE statement on a MERGE table, only MERGE specification is removed. The underlying tables will not be affected.*/

#Archive
/*The archive storage engine allows you to store a large number of records, which for archiving purpose, into a compressed format to save disk space. The archive storage engine compresses a record when it is inserted and decompress it using the zlib library as it is read.*/

#CSV
/*The CSV storage engine stores data in comma-separated values (CSV) file format. A CSV table brings a convenient way to migrate data into non-SQL applications such as spreadsheet software*/

#FEDERATED
/*The FEDERATED storage engine allows you to manage data from a remote MySQL server without using the cluster or replication technology. The local federated table stores no data. When you query data from a local federated table, the data is pulled automatically from the remote federated tables.*/
      

describe SUPPLIERS;


#CREATE TABLE 

CREATE TABLE IF NOT EXISTS tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    start_date DATE,
    due_date DATE,
    status TINYINT NOT NULL,
    priority TINYINT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)  ENGINE=INNODB;

# MySQL CREATE TABLE with a foreign key primary key example
/*Suppose each task has a checklist or to-do list. To store checklists of tasks, you can create a new table named checklists as follows:*/


create table if not exists checklists(
todo_id int auto_increment,
task_id int,
todo varchar(255) not null,
is_completed boolean not null default false,
primary key (todo_id,task_id),
foreign key (task_id)
references tasks (task_id)
on update restrict on delete cascade
); 


#____________________________________________________________#____________________________________________________________#____________________________________________________________

#MySQL ALTER TABLE
/*MySQL ALTER TABLE statement to add a column, alter a column, rename a column, drop a column and rename a table.*/


/*Let’s create a table named vehicles for the demonstration:*/

CREATE TABLE vehicles (
    vehicleId INT,
    year INT NOT NULL,
    make VARCHAR(100) NOT NULL,
    PRIMARY KEY(vehicleId)
);

describe vehicles;

alter table vehicles add exp int not null ;

#modification

alter table vehicles modify exp int ;

#Rename coloumn

alter table vehicles
change column make cond varchar(100) not null; 

#drop column

alter table vehicles
drop column exp;

#new table name

alter table vehicles
rename to cars;

#_____________________________________________________________________________________________________________________#_____________________________________________________________________________________________________________________

#Introduction to MySQL RENAME TABLE statement


#First, we create a new database named hr that consists of two tables: employees and departments for the demonstration.

create database if not exists hr;
use hr;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100)
);
 
CREATE TABLE employees (
    id int AUTO_INCREMENT primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    department_id int not null,
    FOREIGN KEY (department_id)
        REFERENCES departments (department_id)
);

#Second, we insert sample data into both employees and departments tables:

INSERT INTO departments(dept_name)
VALUES('Sales'),('Markting'),('Finance'),('Accounting'),('Warehouses'),('Production');

INSERT INTO employees(first_name,last_name,department_id) 
VALUES('John','Doe',1),
        ('Bush','Lily',2),
        ('David','Dave',3),
        ('Mary','Jane',4),
        ('Jonatha','Josh',5),
        ('Mateo','More',1);
        
#Third, we review our data in the departments and employees tables:

select 
     department_id, dept_name
from 
    departments;     
    
    SELECT 
    id, first_name, last_name, department_id
FROM
    employees;
    
    /*Renaming a table referenced by a view
/*If the table that you are going to rename is referenced by a view, the view will become invalid if you rename the table, and you have to adjust the view manually.*/

create view v_employee_info as 
     select 
         id,first_name,last_name,dept_name
     from
         employees
             inner join
	     departments using (department_id);
         
#The following SELECT statement returns all data from the v_employee_info view.

select * from v_employee_info;

#Now we rename the employees to people table and query data from the v_employee_info view again.

rename table employees to people;

SELECT 
    *
FROM
    v_employee_info;
    
# show error because we use employee table to create view but we change the name to people

#We can use the CHECK TABLE statement to check the status of the v_employee_info view as follows:

check table v_employee_info;

#Renaming a table that referenced by a stored procedure

RENAME TABLE people TO employees;

#Then, create a new stored procedure named get_employee that refers to the employees table.

DELIMITER $$

create procedure get_employee(IN p_id int)

begin
    select first_name,
		   last_name,
           dept_name
    from employees
    inner join departments using (department_id)
    where id = p_id;
end $$
DELIMITER ;

#Next, we execute the get_employee table to get the data of the employee with id 1 as follows:

call get_employee(3);

#After that, we rename the employees to the people table again.

rename table employees to people;

#Finally, we call the get_employee stored procedure to get the information of employee with id 2:

CALL get_employee(2);

#Renaming a table that has foreign keys referenced to

/*If we rename the departments table, all the foreign keys that point to the departments table will not be automatically updated. In such cases, we must drop and recreate the foreign keys manually.*/

rename table departments to depts;

/*We delete a department with id 1, because of the foreign key constraint, all rows in the people table should be also deleted. However, we renamed the departments table to the depts table without updating the foreign key manually, MySQL returns an error as illustrated below:*/

delete from depts
where
    department_id = 1;
    
#Renaming multiple tables
/*We can also use the RENAME TABLE statement to rename multiple tables at a time. See the following statement:*/

rename table depts to departments,people to employees;

#Renaming temporary table example
/*First, we create a temporary table that contains all unique last names which come from the last_name column of the employees table:*/

create temporary table lastnames
select distinct last_name from employees;

#Second, we use the RENAME TABLE to rename the lastnames table:

rename table lastnames to unique_lastname;


#_______________________________________________________________________________________________________________________________________________________________________________

#removing column from table

#MySQL DROP COLUMN examples
/*First,  create a table named posts for the demonstration.*/

create table posts(
   id int auto_increment primary key,
   title varchar(255) not null,
   exerpt varchar(255),
   content text,
   create_at datetime,
   update_at datetime
   );
   
   #Next, use the ALTER TABLE DROP COLUMN statement to remove the excerpt column
   
   alter table posts
   drop column exerpt;
   
   
   describe posts;
   
   #MySQL drop a column which is a foreign key example
/*If you remove the column that is a foreign key, MySQL will issue an error. Consider the following example.*/

create table categories(
   id int auto_increment primary key,
   name varchar(255)
   );
   
#Second, add a column named category_id to the posts table.

alter table posts
add column category_id int not null;

#Third, make the category_id column as a foreign key column of that references to the id column of the categories table.

alter table posts 
add constraint fk_cat
foreign key (category_id)
references categories(id);

#Fourth, drop the category_id column from the posts table

alter table posts
drop column category_id;

################### imp :- To avoid this error, you must remove the foreign key constraint before dropping the column. ##############################



#_______________________________________________________________________________________________________________________________________________________________________________

#add column to table

#MySQL ADD COLUMN examples
/*First, we create a table named vendors for the demonstration purpose using the following statement:*/

create table if not exists vendors (
   id int auto_increment primary key,
   name varchar(255)
   );
       
alter table vendors
add column phone varchar(255) after name;

#chech table

SELECT 
    id, name, phone
FROM
    vendors;
    
#add two more columns email and hourly_rate to the vendors table at the same time.

alter table vendors
add column email varchar(100) not null,
add column hourl_charge decimal(10,2) not null;

insert into vendors(name,phone,email)
values ('pranjal',9792950661,'pranjalgupta@gmail.com');

SELECT 
    id, name, phone,  email, hourl_charge
FROM
    vendors;
    
#_________________________________________________________________________________________________________________________________________________________________________

#sing MySQL DROP TABLE to drop multiple tables
/*First, create two tables named CarAccessories and CarGadgets:*/

CREATE TABLE CarAccessories (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id)
);
 
CREATE TABLE CarGadgets (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DEC(10 , 2 ) NOT NULL,
    PRIMARY KEY(id)
);

#Second, use the DROP TABLE statement to drop the two tables:

drop table CarAccessories, CarGadgets;

#Using MySQL DROP TABLE to drop a non-existing table
/*This statement attempts to drop a non-existing table:*/


DROP TABLE aliens;

#use if exists

DROP TABLE IF EXISTS aliens;

#   MySQL DROP TABLE based on a pattern

/*#irst, create three tables test1,test2, test4 for demonstration:*/

CREATE TABLE test1(
  id INT AUTO_INCREMENT,
  PRIMARY KEY(id)
);
 
CREATE TABLE IF NOT EXISTS test2 LIKE test1;
CREATE TABLE IF NOT EXISTS test3 LIKE test1;

/*Suppose you that want to remove all test* tables.

Second, declare two variables that accept database schema and a pattern that you want to the tables to match:*/

set @schema = 'classicmodels';
set @pattern = 'test';

/*Third, construct a dynamic DROP TABLE statement:*/

select concat('DROP TABLE',Group_concat(concat(@schema,'.',table_name)),';')
into
    @droplike
from information_schema.tables
where @schema = database()
and table_name like @pattern;

SELECT CONCAT('DROP TABLE ',GROUP_CONCAT(CONCAT(@schema,'.',table_name)),';')
INTO @droplike
FROM information_schema.tables
WHERE @schema = database()
AND table_name LIKE @pattern;

/*Basically, the query instructs MySQL to go to the information_schema  table, which contains information on all tables in all databases, and to concatenate all tables in the database @schema ( classicmodels ) that matches the pattern @pattern ( test% ) with the prefix DROP TABLE . The GROUP_CONCAT function creates a comma-separated list of tables.*/

#Fourth, display the dynamic SQL to verify if it works correctly:

select @droplike;

#Fifth, execute the statement using a prepared statement  as shown in the following query:


PREPARE stmt FROM @droplike;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- set table schema and pattern matching for tables
SET @schema = 'classicmodels';
SET @pattern = 'test%';
 
-- build dynamic sql (DROP TABLE tbl1, tbl2...;)
SELECT CONCAT('DROP TABLE ',GROUP_CONCAT(CONCAT(@schema,'.',table_name)),';')
INTO @droplike
FROM information_schema.tables
WHERE @schema = database()
AND table_name LIKE @pattern;
 
-- display the dynamic sql statement
SELECT @droplike;
 
-- execute dynamic sql
PREPARE stmt FROM @droplike;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

/*So if you want to drop multiple tables that have a specific pattern in a database, you just use the script above to save time. All you need to do is replacing the pattern and the database schema in @pattern and @schema variables. If you often have to deal with this task, you can develop a stored procedure based on the script and reuse this stored procedure.*/

#_____________________________________________________________________________________________________________________________________________________________________________________

#MySQL CREATE TEMPORARY TABLE statement

/*Creating a temporary table example
First, create a new temporary table called credits that stores customers’ credits:*/

create temporary table credits(
customerNumber int primary key,
creditLimit dec(10,2)
);

select * from credits;
#Then, insert rows from the customers table into the temporary table credits:

insert into credits(customerNumber,creditLimit)
select customerNumber,creditLimit
from customers
where creditLimit > 0;

#Creating a temporary table whose structure based on a query example
/*The following example creates a temporary table that stores the top 10 customers by revenue. The structure of the temporary table is derived from a SELECT statement:*/
  

create temporary table top_customers
select p.customerNumber,
       c.customerName,
       round(sum(p.amount),2)sales
       from payments p
inner join customers c on c.customerNumber = p.customerNumber
group by p.customerNumber
order by sales desc
limit 10;

#Now, you can query data from the top_customers temporary table like querying from a permanent table:

select 
    customerNumber, 
    customerName, 
    sales
from
    top_customers
order by sales;

#Checking if a temporary table exists
/*MySQL does not provide a function or statement to directly check if a temporary table exists. However, we can create a stored procedure that checks if a temporary table exists or not as follows:*/


DELIMITER //
CREATE PROCEDURE check_table_exists(table_name VARCHAR(100)) 
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @err = 1;
    SET @err = 0;
    SET @table_name = table_name;
    SET @sql_query = CONCAT('SELECT 1 FROM ',@table_name);
    PREPARE stmt1 FROM @sql_query;
    IF (@err = 1) THEN
        SET @table_exists = 0;
    ELSE
        SET @table_exists = 1;
        DEALLOCATE PREPARE stmt1;
    END IF;
END //
DELIMITER 


CALL check_table_exists('credits');
SELECT @table_exists;

#____________________________________________________________________________________________________________________________________________________________

#truncate table

#MySQL TRUNCATE TABLE example

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL
)  ENGINE=INNODB;


insert into books(title)
values ('pranjal'),('mayank');

SELECT * FROM books;

TRUNCATE TABLE books;

#_________________________________________________________________________________________________________________________________________________________________________________

#introduction to MySQL generated column

/*MySQL 5.7 introduced a new feature called the generated column. Columns are generated because the data in these columns are computed based on predefined expressions.*/

#By using the MySQL generated column, you can recreate the contacts table as follows:

DROP table if exists contacts;

create table contact(
      id int auto_increment primary key,
      first_name varchar(255) not null,
      last_name varchar(255) not null,
      fullname varchar(255) generated  always as (concat(first_name,' ',last_name)),
      email varchar(255) not null
      );
      
      #To test the fullname column, you insert a row into the contacts table.
      
	
INSERT INTO contact(first_name,last_name, email)
VALUES('john','doe','john.doe@mysqltutorial.org');

select * from contact;






        
        
        