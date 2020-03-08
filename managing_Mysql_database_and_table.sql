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