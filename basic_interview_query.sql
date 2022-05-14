create database interview;

use interview;

create table emp
(
  Empid int(20) ,
  fullname varchar(255),
  Managerid varchar(255),
  dateofJoining date ,
  city varchar(255)
);

create table dep
(
  Empid int ,
  Project varchar(255),
  salary int,
variable int
);

INSERT INTO emp
VALUES ('121', 'John', '321', '2014-01-31', 'Rewa'),
		('321', 'Walter', '986', '2015-01-30', 'Mirzapr'),
        ('421', 'Kuldeep', '876', '2016-11-27', 'satna');
        
INSERT INTO dep
VALUES ('139', null, '8090', '200'),
		('321', 'p2',  '10000', '1000'),
        ('421', 'p1',  '12000', '0');
        
truncate empsal;
SELECT * FROM empsal;

SELECT empid,fullname FROM emp where managerid=986; 

SELECT DISTINCT(project) FROM empsal; 

SELECT count(*) FROM empsal where project='p1'; 

SELECT * FROM empsal where salary between 9000 and 15000; 


SELECT * FROM emp where city='mirzapur' or managerid='321'; 

SELECT * FROM empsal where not project='p2'; 

select empid,salary+variable as total from empsal;

SELECT empid,fullname FROM emp where fullname like '__hn%'; 


select empid from emp
union
select empid from empsal ;

select * from empsal where empid not in (select empid from emp); 

select * from empsal es left join emp e on es.empid=e.empid; 

select concat(fullname,city) as descrip from emp;

update dep
set empid='123'
where project='p2';

select * from empsal where project is null;

SELECT * FROM empsal where salary between 9000 and 15000; 

select * from emp where empid in (select empid from empsal where salary between 5000 and 10000);

select now();

SELECT * FROM emp where year(dateofjoining)='2015';

select * from emp es join empsal e on es.empid=e.empid;

select * from emp es where exists (select * from  empsal e where es.empid=e.empid); 

select fullname,city from emp e
join empsal es on
e.empid=es.empid
join dep d on
e.empid=d.empid;

create table pranjal2
select * from empsal where 1=0;

select * from empsal es1
where 3=(select count(distinct(salary)) from empsal es2 where es2.salary>=es1.salary);

SELECT * FROM empsal where salary between 9000 and 15000; 

