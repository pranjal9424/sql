#interview all basic query

#prepare data for practice
CREATE DATABASE ORG;
SHOW DATABASES;
USE ORG;

CREATE TABLE Worker (
	WORKER_ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	FIRST_NAME CHAR(25),
	LAST_NAME CHAR(25),
	SALARY INT(15),
	JOINING_DATE DATETIME,
	DEPARTMENT CHAR(25)
);

INSERT INTO Worker 
	(WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
		(001, 'Monika', 'Arora', 100000, '14-02-20 09.00.00', 'HR'),
		(002, 'Niharika', 'Verma', 80000, '14-06-11 09.00.00', 'Admin'),
		(003, 'Vishal', 'Singhal', 300000, '14-02-20 09.00.00', 'HR'),
		(004, 'Amitabh', 'Singh', 500000, '14-02-20 09.00.00', 'Admin'),
		(005, 'Vivek', 'Bhati', 500000, '14-06-11 09.00.00', 'Admin'),
		(006, 'Vipul', 'Diwan', 200000, '14-06-11 09.00.00', 'Account'),
		(007, 'Satish', 'Kumar', 75000, '14-01-20 09.00.00', 'Account'),
		(008, 'Geetika', 'Chauhan', 90000, '14-04-11 09.00.00', 'Admin');

CREATE TABLE Bonus (
	WORKER_REF_ID INT,
	BONUS_AMOUNT INT(10),
	BONUS_DATE DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
	(WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
		(001, 5000, '16-02-20'),
		(002, 3000, '16-06-11'),
		(003, 4000, '16-02-20'),
		(001, 4500, '16-02-20'),
		(002, 3500, '16-06-11');

CREATE TABLE Title (
	WORKER_REF_ID INT,
	WORKER_TITLE CHAR(25),
	AFFECTED_FROM DATETIME,
	FOREIGN KEY (WORKER_REF_ID)
		REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Title 
	(WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
 (001, 'Manager', '2016-02-20 00:00:00'),
 (002, 'Executive', '2016-06-11 00:00:00'),
 (008, 'Executive', '2016-06-11 00:00:00'),
 (005, 'Manager', '2016-06-11 00:00:00'),
 (004, 'Asst. Manager', '2016-06-11 00:00:00'),
 (007, 'Executive', '2016-06-11 00:00:00'),
 (006, 'Lead', '2016-06-11 00:00:00'),
 (003, 'Lead', '2016-06-11 00:00:00');

#---------------------------------------------------------------------------------------------------------------------------------------------------------
#Q-1. Write an SQL query to fetch “FIRST_NAME” from Worker table using the alias name as <WORKER_NAME>.

select FIRST_NAME AS worker_name from Worker;

#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Q-2. Write an SQL query to fetch “FIRST_NAME” from Worker table in upper case.

select upper(FIRST_NAME) from Worker;
#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Q-3. Write an SQL query to fetch unique values of DEPARTMENT from Worker table.

select distinct DEPARTMENT from Worker;
#---------------------------------------------------------------------------------------------------------------------------------------------------------
#Q-4. Write an SQL query to print the first three characters of  FIRST_NAME from Worker table.

select substring(FIRST_NAME,1,3) from Worker;
#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Q-5. Write an SQL query to find the position of the alphabet (‘a’) in the first name column ‘Amitabh’ from Worker table.

Select INSTR(FIRST_NAME, BINARY'a') from Worker where FIRST_NAME = 'Amitabh';
#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Q-6. Write an SQL query to print the FIRST_NAME from Worker table after removing white spaces from the right side.

select rtrim(FIRST_NAME) FROM Worker;
#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Write an SQL query to print the DEPARTMENT from Worker table after removing white spaces from the left side.

Select LTRIM(DEPARTMENT) from Worker;
#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Q-8. Write an SQL query that fetches the unique values of DEPARTMENT from Worker table and prints its length.

select distinct length(DEPARTMENT) from Worker;
#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Q-9. Write an SQL query to print the FIRST_NAME from Worker table after replacing ‘a’ with ‘A’.

Select REPLACE(FIRST_NAME,'a','A') from Worker;
#---------------------------------------------------------------------------------------------------------------------------------------------------------

#Q-10. Write an SQL query to print the FIRST_NAME and LAST_NAME from Worker table into a single column COMPLETE_NAME. A space char should separate them.

select concat(FIRST_NAME,' ',LAST_NAME) AS 'COMPLETE_NAME' FROM Worker;
#---------------------------------------------------------------------------------------------------------------------------------------------------------



