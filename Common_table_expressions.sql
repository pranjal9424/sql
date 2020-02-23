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
 
 /*A common table expression is a named temporary result set that exists only within the execution scope of a single SQL statement e.g.,SELECT, INSERT, UPDATE, or DELETE.*/
 
 with customers_in_USA as (
 select customerName,state
 from
 customers
 where Country='USA'
 )
 select customerName
 from
 customers_in_USA
 where state='CA'
 order by customerName;

with topsales2003 as (
select 
    salesRepEmployeeNumber employeeNumber,
    sum(quantityOrdered * priceEach) sales
    from
      orders
        inner join
        orderdetails using (ordernumber)
        inner join
        customers using (customerNumber)
        where
        year(shippedDate) = 2003
          and status = 'Shipped'
          group by salesRepEmployeeNumber
          order by sales desc
          limit 5
 )
 select employeeNumber,
 firstName,
 lastName,
 sales
 from
 employees
 join
 topsales2003 using (employeeNumber);
 
 
 WITH salesrep AS (
    SELECT 
        employeeNumber,
        CONCAT(firstName, ' ', lastName) AS salesrepName
    FROM
        employees
    WHERE
        jobTitle = 'Sales Rep'
),
customer_salesrep AS (
    SELECT 
        customerName, salesrepName
    FROM
        customers
            INNER JOIN
        salesrep ON employeeNumber = salesrepEmployeeNumber
)
SELECT 
    *
FROM
    customer_salesrep
ORDER BY customerName;

#___________________________________________________________________________________________________________________________________________
 #    MySQL Recursive CTE
 
/*A recursive CTE consists of three main parts:

An initial query that forms the base result set of the CTE structure. The initial query part is referred to as an anchor member.
A recursive query part is a query that references to the CTE name, therefore, it is called a recursive member. The recursive member is joined with the anchor member by aUNION ALL or UNION DISTINCT operator.
A termination condition that ensures the recursion stops when the recursive member returns no row.
The execution order of a recursive CTE is as follows:

First, separate the members into two: anchor and recursive members.
Next, execute the anchor member to form the base result set ( R0) and use this base result set for the next iteration.
Then, execute the recursive member with Ri result set as an input and make Ri+1 as an output.
After that, repeat the third step until the recursive member returns an empty result set, in other words, the termination condition is met.
Finally, combine result sets from R0 to Rn using UNION ALL operator*/


WITH RECURSIVE cte_count (n) 
AS (
      SELECT 1
      UNION ALL
      SELECT n + 1 
      FROM cte_count 
      WHERE n < 3
    )
SELECT n 
FROM cte_count;


#Using MySQL recursive CTE to traverse the hierarchical data

WITH RECURSIVE employee_paths AS
  ( SELECT employeeNumber,
           reportsTo managerNumber,
           officeCode, 
           1 lvl
   FROM employees
   WHERE reportsTo IS NULL
     UNION ALL
     SELECT e.employeeNumber,
            e.reportsTo,
            e.officeCode,
            lvl+1
     FROM employees e
     INNER JOIN employee_paths ep ON ep.employeeNumber = e.reportsTo )
SELECT employeeNumber,
       managerNumber,
       lvl,
       city
FROM employee_paths ep
INNER JOIN offices o USING (officeCode)
ORDER BY lvl, city;
 
 
 
 
 
 