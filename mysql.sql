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
 
 
 /* 
 to sort a result set use the MySQL ORDER BY clause.
 he ORDER BY clause is always evaluated after the FROM and SELECT clause.
 By default, the ORDER BY clause uses ASC
 */

 
 select customerNumber 
 from customers
 order by customerNumber;
 
 
 select customerNumber
 from customers
 order by customerNumber asc;

 
 select customerNumber,customerName,contactFirstName,city
 from customers
 order by customerName asc,contactFirstName desc;
 
 select orderNumber, orderlinenumber,quantityOrdered * priceEach As subtotal
 from orderdetails
 order by subtotal Desc;

 
 select orderNumber,status
 from orders
 order by
 field(status,'In Process','on hold','Cancelled','Resolved','Dispached','Shipped');
 
 
/* 
The WHERE clause allows you to specify a search condition for the rows returned by a query
Besides the SELECT statement, you can use the WHERE clause in the UPDATE or DELETE statement to specify which rows to update or delete.
the WHERE clause is evaluated after the FROM clause and before the SELECT clause.
or,and,like,between,in,limit
MySQL always evaluates the OR operators after the AND operators. To change the order of evaluation,  use the parentheses
When evaluating an expression that has the AND operator, MySQL stops evaluating the remaining parts of the expression 
whenever it can determine the result. This function is called short-circuit evaluation
expr [NOT] BETWEEN begin_expr AND end_expr;
 All three expressions:  expr,  begin_expr, and  end_expr must have the same data type.
 The BETWEEN operator returns true if the value of the  expr is greater than or equal to (>=) the value of  
 begin_expr and less than or equal to (<= ) the value of the  end_expr, otherwise, it returns zero
 The NOT BETWEEN returns true if the value of  expr is less than (<) the value of the  begin_expr or greater than the value of 
 the value of  end_expr, otherwise, it returns 0.
 If any expression is NULL, the BETWEEN operator returns  NULL .
 
 The IN  operator allows you to determine if a specified value matches any value in a set of values or returned by a subquery.
 */


 select *
from employees
where officeCode <> '1';


 select *
from employees
where reportsTo is null;


 select *
from employees
where officeCode  between 1 and 3;


 select *
from employees
where jobTitle = 'Sales Rep' Or officeCode = '1'
order by officeCode,jobTitle;


select * from orders
where requireddate between cast('2003-01-01' as date) and cast('2003-01-31' as date);

select * from employees
WHERE lastName NOT LIKE 'B%';

select productCode from products
where productCode like '%\_20%';   #escape character

select * from employees
where lastname like '%son' and officeCode in(1,2,3,4);
select * from orders where orderNumber
in(
select orderNumber
from orderDetails
group by orderNumber
having sum(quantityOrdered * priceEach) > 60000
);

select lastname from employees order by lastname;
select distinct lastname from employees order by lastname;

select count(distinct state)
from customers
where country = 'USA';

select distinct state , city
from customers
where state is not null
order by state ,city;

/* 
If you use the GROUP BY clause in the SELECT statement without using aggregate functions, the GROUP BY clause behaves like the DISTINCT clause.
The GROUP BY clause groups a set of rows into a set of summary rows 
the GROUP BY clause returns unique occurrences of values.
To filter the groups returned by GROUP BY clause, you use a  HAVING clause.
 */    
 
 select status from orders
 group by status;
 
 select * , count(*) as total
 from orders
 group by status order by total;
 
select year(orderDate) as year, sum(quantityOrdered * priceEach) as total
from orders Inner join orderdetails using (orderNumber)
where status = 'Shipped'
group by year
having year > 2003; 

 /* 
 MySQL hasn’t supported the FULL OUTER JOIN yet.
 The self join is often used to query hierarchical data or to compare a row with other rows within the same table.
 The CROSS JOIN clause returns the Cartesian product of rows from the joined tables.
 
 left,right,inner
 */

select t1.productCode,t1.productName,t2.textDescription
from products t1 inner join productlines t2 on t1.productLine=t2.productLine; #on using for campare 

select t1.productCode,t1.productName,t2.textDescription
from products t1 inner join productlines t2 using(productLine);

select status ,sum(quantityOrdered * priceEach) as amount
from orders Inner join  orderdetails using(ordernumber)
group by status;

select orderNumber,orderDate,orderLineNumber,productName,quantityOrdered,priceEach
from orders inner join orderdetails using(ordernumber) inner join products using (productCode)
order by orderNumber,orderLineNumber;

#self join
select
      concat(m.lastName,',',m.firstName) as manager,
      concat(e.lastName,',',e.firstname) as 'direct report'
      from
      employees e
      inner join employees m on
      m.employeeNumber = e.reportsTo
      order by manager;

    

SELECT 
    IFNULL(CONCAT(m.lastname, ', ', m.firstname),'Top Manager') AS 'Manager',
    CONCAT(e.lastname, ', ', e.firstname) AS 'Direct report'
FROM
    employees e
LEFT JOIN employees m ON 
    m.employeeNumber = e.reportsto
ORDER BY 
    manager DESC;
    

SELECT * FROM orders
CROSS JOIN orderdetails;

