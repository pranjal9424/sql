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
 
 
 #_________________________________________________________________________________________________________________________________________________________________________________
 
 #MySQL transaction statements
/*MySQL provides us with the following important statement to control transactions:

To start a transaction, you use the START TRANSACTION  statement. The BEGIN or  BEGIN WORK are the aliases of the START TRANSACTION.
To commit the current transaction and make its changes permanent,  you use the COMMIT statement.
To roll back the current transaction and cancel its changes, you use the ROLLBACK statement.
To disable or enable the auto-commit mode for the current transaction, you use the SET autocommit statement.*/

start transaction;
select
@orderNumber:= max(orderNumber)+1
FROM
orders;
INSERT INTO orders(orderNumber,
                   orderDate,
                   requiredDate,
                   shippedDate,
                   status,
                   customerNumber)
values(@orderNumber,
	   '2005-05-31',
       '2005-06-10',
       '2005-06-11',
       'In Process',
        145);
INSERT INTO orderdetails(orderNumber,
                         productCode,
                         quantityOrdered,
                         priceEach,
                         orderLineNumber)
VALUES(@orderNumber,'S18_1749', 30, '136', 1),
      (@orderNumber,'S18_2248', 50, '55.09', 2);
      commit;
      
      
      /*To get the newly created sales order, you use the following query:*/
      
      SELECT 
    a.orderNumber,
    orderDate,
    requiredDate,
    shippedDate,
    status,
    comments,
    customerNumber,
    orderLineNumber,
    productCode,
    quantityOrdered,
    priceEach
FROM
    orders a
        INNER JOIN
    orderdetails b USING (orderNumber)
WHERE
    a.ordernumber = 10426;
    
    
    #__________________________________________________________________________________________________________________________________________________________________
    
    #ROLLBACK example
/*First, log in to the MySQL database server and delete data from the orders table:*/
      
      
      start transaction;
      
      delete from orders;
      
      
      /*As you can see from the output, MySQL confirmed that all the rows from the orders table were deleted.

Second, log in to the MySQL database server in a separate session and query data from the orders table:*/
      
      select * from orders;
      
      /*In this second session, we still can see the data from the orders table.

We have made the changes in the first session. However, the changes are not permanent. In the first session, we can either commit or roll back the changes.

For the demonstration purpose, we will roll back the changes in the first session.*/

      rollback;
      
      /*in  the first session, we will also verify the contents of the orders table:*/
      select * from orders;
      
      
#______________________________________________________________________________________________________________________________________________________________________________

#MySQL Table Locking

/*A lock is a flag associated with a table. MySQL allows a client session to explicitly acquire a table lock for preventing other sessions from accessing the same table during a specific period.*/

create table message(
       id int not null auto_increment,
       message varchar(100) not null,
       primary key(id)
);

#In the first session, first, connect to the database and use the CONNECTION_ID() function to get the current connection id as follows:

select connection_id();

#then insert a new row in the message table

insert into message(message)
values ('hello');

#Next, query the data the messages table

select * from message;

#After that, acquire a lock using the LOCK TABLE statement.

lock table message read;

#Finally, try to insert a new row into the messages table

INSERT INTO message(message) 
VALUES('Hii');

#MySQL issued the following error:


# impo:-  So once the READ lock is acquired, you cannot write data to the table within the same session.

/*Let’s check the READ lock from a different session.

First, connect to the database and check the connection id:*/

select connection_id();

#Next, query data from the messages  table:

SELECT * FROM message;

#Then, insert a new row into the messages table:

INSERT INTO messages(message) 
VALUES('Bye');


/*The insert operation from the second session is in the waiting state because a READ lock is already acquired on the messages table by the first session and it has not released yet.

From the first session, use the SHOW PROCESSLIST statement to show detailed information:*/

show processlist;

unlock table ;

#Write Locks
/*A WRITE lock has the following features:

The only session that holds the lock of a table can read and write data from the table.
Other sessions cannot read data from and write data to the table until the WRITE lock is released.*/


#First, acquire a WRITE lock from the first session.

lock table message write;

#Then, insert a new row into the messages table.

INSERT INTO message(message) 
VALUES('Good Moring');

#Next, query data from the messages table.

select * from message; 

#After that, from the second session, attempt to write and read data:

insert into message(message)
values ('bye bye');

select * from message;

#MySQL puts these operations into a waiting state. You can check it using the SHOW PROCESSLIST statement.

show processlist;

#Finally, release the lock from the first session.

unlock tables;


/*Read vs. Write locks
Read locks are “shared” locks which prevent a write lock is being acquired but not other read locks.
Write locks are “exclusive ” locks that prevent any other lock of any kind*/





      

        
        
        
        
        
        
        
        
        
        
        
        
                   