show databases;

use classicmodels;
show tables;

select * from employees;
 select * from customers;
 select * from orderdetails;
 select * from orders;
 select * from products;
 select * FROM productlines;
/*As you can see, the GROUP BY clause returns unique occurrences of status values. It works like the DISTINCT operator as shown in the following query:*/

select status
from 
  orders
  group by status;
  
  select status, count(*)
    from 
  orders
  group by status;
  
  select status , sum( quantityOrdered * priceEach) as amount
  from
  orders
  Inner join orderdetails
  using (orderNumber)
  group by 
  status;
  
  select orderNumber, sum(quantityOrdered * priceEach) as total
  from
  orderdetails
  group by orderNumber;
  
  /*MySQL GROUP BY with expression example*/
  
  select year(orderDate) as year,  #year are function date coloumn
    sum(quantityOrdered * priceEach) as total
    from
    orders
    inner join orderdetails
    using(orderNumber)
    where
    status = 'shipped'
    group by
    year(orderDate);
  
  /* The following query uses the HAVING clause to select the total sales of the years after 2003.*/
  
  select year(orderDate) as year,  #year are function date coloumn
    sum(quantityOrdered * priceEach) as total
    from
    orders
    inner join orderdetails
    using(orderNumber)
    where
    status = 'shipped'
    group by
    year(orderDate)
  having 
  year > 2003;
  
  /*the following query extracts the year from the order date. It first uses year as an alias of the expression YEAR(orderDate) and then uses the year alias in the GROUP BY clause. This query is not valid in standard SQL.*/

select year(orderDate) as year, count(orderNumber) 
from
orders
group by
year;  

select status, count(*) from
orders group by status desc;
  
  
  
  #having
  
  /*The  HAVING clause is used in the SELECT statement to specify filter conditions for a group of rows or aggregates.*/
  
  select ordernumber, sum(quantityordered ) as itemcount,
  sum(priceEach * quantityOrdered ) as total
  from
  orderdetails
  group by ordernumber
  having
  total > 1000 and itemcount > 600;
  
select a.ordernumber,
status,
sum(priceeach*quantityordered) total
from
orderdetails a
inner join orders b
on b.ordernumber = a.ordernumber
group by
ordernumber,status
having
status = 'shipped' and total > 1500;

#ROLLUP

/*The following statement creates a new table named sales that stores the order values summarized by product lines and years. The data comes from the products, orders, and orderDetails tables in the sample database.*/

create table sales 
select productLine,
year(orderDate) orderYear,
sum(quantityOrdered * priceEach) orderValue
from 
orderDetails
Inner join
orders using(orderNumber)
inner join products using (productCode)
group by 
productLine ,
year(orderDate);

select * from sales;

/*If you want to generate two or more grouping sets together in one query, you may use the UNION ALL operator as follows*/

select productline,
sum(orderValue) totalOrderValue
from sales
group by productline
union all
select 
null,sum(orderValue) totalOrderedValue
from sales;

/*Because the UNION ALL requires all queries to have the same number of columns, we added NULL in the select list of the second query to fullfil this requirement.

The NULL in the productLine column identifies the grand total super-aggregate line.*/

/*1.1he query is quite lengthy.
2.The performance of the query may not be good since the database engine has to internally execute two separate queries and combine the result sets into one.*/

/*To solve those issues, you can use the ROLLUP clause*/

/*The ROLLUP generates multiple grouping sets based on the columns or expression specified in the GROUP BY clause.*/

select productline,
sum(orderValue) totalOrder
from sales
group by
productline with rollup;  
  
  /*As clearly shown in the output, the ROLLUP clause generates not only the subtotals but also the grand total of the order values.*/
  /*If you have more than one column specified in the GROUP BY clause, the ROLLUP clause assumes a hierarchy among the input columns.*/
  
  select productline,
  orderYear,
  sum(orderValue) totalOrder
  from sales
  group by 
  productline,
  orderYear with rollup;
  
  #set it year wise
  select orderYear, productline,
  
  sum(orderValue) totalOrder
  from sales
  group by 
  orderYear,
   productline with rollup;
   
   /*GROUPING() function
To check whether NULL in the result set represents the subtotals or grand totals, you use the GROUPING() function.

The GROUPING() function returns 1 when NULL occurs in a supper-aggregate row, otherwise, it returns 0.

The GROUPING() function can be used in the select list, HAVING clause, and (as of MySQL 8.0.12 ) ORDER BY clause.*/

SELECT 
    IF(GROUPING(orderYear),
        'All Years',
        orderYear) orderYear,
    IF(GROUPING(productLine),
        'All Product Lines',
        productLine) productLine,
    SUM(orderValue) totalOrderValue
FROM
    sales
GROUP BY 
    orderYear , 
    productline 
WITH ROLLUP;  

/*The following example shows how to combine the IF() function with the GROUPING() function to substitute labels for the super-aggregate NULL values in orderYear and productLine columns:*/
  
  
  