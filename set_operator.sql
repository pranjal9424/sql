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
 
 /*MySQL UNION operator allows you to combine two or more result sets of queries into a single result set. The following illustrates the syntax of the UNION operator:*/
 
 /*To combine result set of two or more queries using the UNION operator, these are the basic rules that you must follow:

First, the number and the orders of columns that appear in all SELECT statements must be the same.
Second, the data types of columns must be the same or compatible.
By default, the UNION operator removes duplicate rows even if you don’t specify the DISTINCT operator explicitly.*/

drop table if exists t1;
drop table if exists t2;

create table t1 (
id int primary key
);
create table t2 (
id int primary key
);

insert into t1 values (1),(2),(3);
insert into t2 values (2),(3),(4);


#start
select id from t1 union all select id from t2;

/*Because the rows with value 2 and 3 are duplicates, the UNION removed them and kept only unique values.*/


#import
/*UNION vs. JOIN
A JOIN combines result sets horizontally, a UNION appends result set vertically. The following picture illustrates the difference between UNION and JOIN:*/


select 
firstName ,
lastName
from
employees
union all 
select
contactFirstName,
contactLastName
from
customers;

select 
concat(firstName ,' ',lastName) as fullName

from
employees
union
select
concat(contactFirstName,' ',contactLastName)
from
customers
order by fullName;

/*Notice that if you place the ORDER BY clause in each SELECT statement, it will not affect the order of the rows in the final result set*/

select 
concat(firstName ,' ',lastName) as fullName,
'pranjal' as contactType
from
employees
union
select
concat(contactFirstName,' ',contactLastName),
'harsh' as contactType
from
customers
order by fullName;

/*MySQL also provides you with an alternative option to sort a result set based on column position using ORDER BY clause as follows:*/

SELECT 
    CONCAT(firstName,' ',lastName) fullname
FROM
    employees 
UNION SELECT 
    CONCAT(contactFirstName,' ',contactLastName)
FROM
    customers
ORDER BY 1;


#________________________________________________________________________________________________________________________
#Introduction to the INTERSECT operator
/*The INTERSECT operator is a set operator that returns only distinct rows of two queries or more queries.*/


/*The INTERSECT operator compares the result sets of two queries and returns the distinct rows that are output by both queries.

To use the INTERSECT operator for two queries, you follow these rules:

The order and the number of columns in the select list of the queries must be the same.
The data types of the corresponding columns must be compatible.*/


/*1) Emulate INTERSECT using DISTINCT and INNER JOIN clause
The following statement uses DISTINCT operator and INNER JOIN clause to return the distinct rows in both tables:*/

select distinct
id
from
t1
inner join t2 using(id);

/*2) Emulate INTERSECT using IN and subquery
The following statement uses the IN operator and a subquery to return the intersection of the two result sets.*/

select distinct id
from t1
where id in (select id from t2);

#_____________________________________________________________________________________________________________________________________________________

#Introduction to SQL MINUS operator
/*The MINUS compares the results of two queries and returns distinct rows from the result set of the first query that does not appear in the result set of the second query.*/

# imp 
/*MySQL MINUS operator emulation
Unfortunately, MySQL does not support MINUS operator. However, you can use join to emulate it.*/

SELECT 
    id
FROM
    t1
LEFT JOIN
    t2 USING (id)
WHERE
    t2.id IS NULL;

 
 
 
 
 
 
 
 
 
 