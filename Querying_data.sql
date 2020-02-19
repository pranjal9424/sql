show databases;

use classicmodels;
show tables;

/* 
SELECT statement that allows you to query data from a single table.
If you have two or more statements, you use the semicolon ( ;) to separate them so that MySQL will execute each statement individually.
MySQL evaluates the FROM clause first and then the SELECT clause:
 */
 
 select * from employees;
 select * from customers;
 select * from orderdetails;
 select * from orders;
 select * from products;
 select * FROM productlines;

 
 select firstName,jobTitle from employees;
 
