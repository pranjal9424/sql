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
 
 /*A MySQL subquery is called an inner query while the query that contains the subquery is called an outer query. A subquery can be used anywhere that expression is used and must be closed in parentheses.*/
 
 select lastName,firstName
 from
 employees
 where
 officeCode in (select officecode from offices where country = 'USA');
 
 #greater one
 select customerNumber, 
    checkNumber, 
    amount
    FROM payments
    where
    amount = (select max(amount) from payments);
    
    #greater than avereage
    select customerNumber, 
    checkNumber, 
    amount
    FROM payments
    where
    amount < (select avg(amount) from payments);
    
    
    #NOT IN OPERATOR
    select customerName
    from 
       customers
       where
       customerNumber not in (select distinct customerNumber from orders);
 
 #MySQL subquery in the FROM clause
/*When you use a subquery in the FROM clause, the result set returned from a subquery is used as a temporary table. This table is referred to as a derived table or materialized subquery.*/

select 
max(items),
min(items),
floor(avg(items))
from
(select orderNumber,count(orderNumber) as items
from
orderdetails
group by orderNumber) as lineitems;


#MySQL correlated subquery
/*Unlike a standalone subquery, a correlated subquery is a subquery that uses the data from the outer query. In other words, a correlated subquery depends on the outer query. A correlated subquery is evaluated once for each row in the outer query.*/
 
 select productname,buyprice
 from
 products p1
 where
 buyprice > (select avg(buyprice)
 from products where
 productline= p1.productline);
 
 #MySQL subquery with EXISTS and NOT EXISTS
/*When a subquery is used with the EXISTS or NOT EXISTS operator, a subquery returns a Boolean value of TRUE or FALSE.  The following query illustrates a subquery used with the EXISTS operator:*/

select
customerNumber,
customerName
from 
customers
where
Exists(select orderNumber,sum(priceEach * quantityOrdered)
from
orderdetails
inner join
orders using(orderNumber)
where
customerNumber = customers.customerNumber
group by 
orderNumber
having sum(priceEach * quantityOrdered) > 60000); 

#______________________________________________________________________________________________________________________
#Introduction to MySQL derived table
/*A derived table is a virtual table returned from a SELECT statement. A derived table is similar to a temporary table, but using a derived table in the SELECT statement is much simpler than a temporary table because it does not require steps of creating the temporary table.

The term derived table and subquery is often used interchangeably. When a stand-alone subquery is used in the FROM clause of a SELECT statement, we call it a derived table.*/
SELECT 
    productName, sales
FROM
    (SELECT 
        productCode, 
        ROUND(SUM(quantityOrdered * priceEach)) sales
    FROM
    orderdetails
    INNER JOIN orders USING (orderNumber)
    WHERE
        YEAR(shippedDate) = 2003
    GROUP BY productCode
    ORDER BY sales DESC
    LIMIT 5) top5products2003
INNER JOIN
    products USING (productCode);
    
    #A more complex MySQL derived table example
    
    /*QUES:-   Suppose you have to classify the customers in the year of 2003 into 3 groups: platinum, gold, and silver. In addition, you need to know the number of customers in each group with the following conditions:

Platinum customers who have orders with the volume greater than 100K
Gold customers who have orders with the volume between 10K and 100K
Silver customers who have orders with the volume less than 10K*/
/*    To construct this query, first, you need to put each customer into the respective group using CASE expression and GROUP BY clause as follows:*/
  
  select customerNumber,
  round(SUM(quantityOrdered * priceEach)) sales,
  (case
  when sum(quantityOrdered * priceEach) < 10000 then 'silver'
  when sum(quantityOrdered * priceEach) between 10000 and 100000 then 'gold'
  when sum(quantityOrdered * priceEach) > 100000 then 'platinum'
  end) customergroup
from
orderdetails
inner join
orders using (orderNumber)
where 
year(shippedDate) = 2003
group by customerNumber;
 
/*Then, you can use this query as the derived table and perform grouping as follows:*/

select 
customerGroup,
count(cg.customerGroup) as groupCount
from
(
  select customerNumber,
  round(SUM(quantityOrdered * priceEach)) sales,
  (case
  when sum(quantityOrdered * priceEach) < 10000 then 'silver'
  when sum(quantityOrdered * priceEach) between 10000 and 100000 then 'gold'
  when sum(quantityOrdered * priceEach) > 100000 then 'platinum'
  end) customergroup
from
orderdetails
inner join
orders using (orderNumber)
where 
year(shippedDate) = 2003
group by customerNumber) cg
group by cg.customerGroup; 

#________________________________________________________________________________________________________________________________________________
#Introduction to MySQL EXISTS operator
/*The EXISTS operator is a Boolean operator that returns either true or false. The EXISTS operator is often used to test for the existence of rows returned by the subquery.*/

select 
customerNumber,
customerName
from
customers 
where 
not exists(
select 1 from orders where
   orders.customernumber=customers.customernumber);
   
   #MySQL UPDATE EXISTS examples
/*Suppose that you have to update the phone’s extensions of the employees who work at the office in San Francisco.*/

SELECT 
    employeenumber, 
    firstname, 
    lastname, 
    extension
FROM
    employees
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            offices
        WHERE
            city = 'San Francisco' AND 
           offices.officeCode = employees.officeCode);
           
           

UPDATE employees 
SET 
    extension = CONCAT(extension, '1')
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            offices
        WHERE
            city = 'San Francisco'
                AND offices.officeCode = employees.officeCode);


#MySQL INSERT EXISTS example
/*Suppose that you want to archive customers who don’t have any sales order in a separate table. To do this, you use these steps:*/
 
CREATE TABLE customers_archive 
LIKE customers;

INSERT INTO customers_archive
SELECT * 
FROM customers
WHERE NOT EXISTS( 
   SELECT 1
   FROM
       orders
   WHERE
       orders.customernumber = customers.customernumber
);

SELECT * FROM customers_archive;

#MySQL DELETE EXISTS example
/*One final task in archiving the customer data is to delete the customers that exist in the customers_archive table from the customers table.*/
 
 DELETE FROM customers
WHERE EXISTS( 
    SELECT 
        1
    FROM
        customers_archive a
    
    WHERE
        a.customernumber = customers.customerNumber);
        
        SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    customerNumber IN (
        SELECT 
            customerNumber
        FROM
            orders);
 
 
 
 #MySQL EXISTS operator vs. IN operator
 /*
To find the customer who has placed at least one order, you can use the IN operator as
 
 
 The query that uses the EXISTS operator is much faster than the one that uses the IN operator.

The reason is that the EXISTS operator works based on the “at least found” principle. The EXISTS stops scanning the table when a matching row found.

On the other hands, when the IN operator is combined with a subquery, MySQL must process the subquery first and then uses the result of the subquery to process the whole query.

The general rule of thumb is that if the subquery contains a large volume of data, the EXISTS operator provides better performance.

However, the query that uses the IN operator will perform faster if the result set returned from the subquery is very small.-*