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
