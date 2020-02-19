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
 