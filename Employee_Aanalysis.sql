
-- EMPLOYEE DEPARTMENT ANALYSIS

drop database Employee_analysis  ; 

create database Employee_analysis  ; 
use Employee_analysis  ; 

# DROP TABLE emp_info ; 

# 1.Employee Table

CREATE TABLE emp_info (
    Empno int NOT NULL unique,
    Ename VARCHAR(50) NOT NULL,
    Job VARCHAR(50) NOT NULL DEFAULT 'CLERK',
    Mgr int,
    HIREDATE DATE NOT NULL,
    Salary DECIMAL(10, 2) CHECK (Salary > 0),
    Comm int,
    Deptno INT,
    PRIMARY KEY (Empno),
    FOREIGN KEY (deptno) REFERENCES department (deptno)
);

insert  into `emp_info`(`Empno`,`Ename`,`Job`,`Mgr`,`HIREDATE`,`Salary`,`Comm`,`Deptno`) values 
(7369,'SMITH',default,7902,'1890-12-17',800.00,NULL,20),
(7499,'ALLEN','SALESMAN',7698,'1981-02-20',1600.00,300.00,30),
(7521,'WARD','SALESMAN',7698,'1981-02-22',1250.00,500.00,30),
(7566,'JONES','MANAGER',7839,'1981-04-02',2975.00,null,20),
(7654,'MARTIN','SALESMAN',7698,'1981-09-28',1250.00,1400.00,30),
(7698,'BLAKE','MANAGER',7839,'1981-05-01',2850.00,null,30),
(7782,'CLARK','MANAGER',7839,'1981-06-09',2450.00,null,10),
(7788,'SCOTT','ANALYST',7566,'1987-04-19',3000.00,null,20),
(7839,'KING','PRESIDENT',null,'1981-11-17',5000.00,null,10),
(7844,'TURNER','SALESMAN',7698,'1981-09-08',1500.00,0.00,30),
(7876,'ADAMS',default,7788,'1987-05-23',1100.00,null,20),
(7900,'JAMES',default,7698,'1981-12-03',950.00,null,30),
(7902,'FORD','ANALYST',7566,'1981-12-03',3000.00,null,20),
(7934,'MILLER',default,7782,'1982-01-23',1300.00,null,10);

select*from emp_info ;

describe emp_info ;

# 2. Dept Table

CREATE TABLE department (
    deptno INT PRIMARY KEY,
    dname VARCHAR(50),
    loc VARCHAR(50)
);

INSERT INTO department (deptno, dname, loc) VALUES 
(10,'OPERATIONS','BOSTON'),
(20,'RESEARCH','DALLAS'),
(30,'SALES','CHICAGO'),
(40,'ACCOUNTING','NEWYORK');

select*from department ;

# 3. List the Names and salary of the employee whose salary is greater than 1000
SELECT Ename, Salary
FROM emp_info
WHERE Salary > 1000;

# 4. List the details of the employees who have joined before end of September 81.
SELECT *
FROM emp_info
WHERE HIREDATE <= '1981-09-30';

# 5.List Employee Names having I as second character.
SELECT Ename
FROM emp_info
WHERE Ename LIKE '_I%';

# 6.List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns
SELECT 
    Ename AS "Employee Name",
    Salary AS "Salary",
    Salary * 0.40 AS "Allowances",
    Salary * 0.10 AS "P.F.",
    Salary + (Salary * 0.40) - (Salary * 0.10) AS "Net Salary"
FROM emp_info;

# 7. List Employee Names with designations who does not report to anybody
select Ename , Job
from emp_info
where mgr IS NULL;

# 8.List Empno, Ename and Salary in the ascending order of salary.
select Empno, Ename, Salary 
from emp_info 
order by Salary  asc  ;  

# 9.How many jobs are available in the Organization ?
SELECT COUNT(DISTINCT Job) AS "Total Jobs Available"
FROM emp_info;

# 10.Determine total payable salary of salesman category
SELECT 
    SUM(Salary + COALESCE(Comm, 0)) AS "Total Payable Salary (SALESMAN)"
FROM emp_info
WHERE Job = 'SALESMAN';

# 11.List average monthly salary for each job within each department   
SELECT 
    deptno AS 'Department No',
    job AS 'Job Title',
    ROUND(AVG(Salary), 2) AS 'Average Monthly Salary'
FROM
    emp_info
GROUP BY deptno , Job
ORDER BY deptno , Job; 

select *from emp_info ;
select *from department ;

# 12.Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.
SELECT 
    Ename AS EMPNAME, 
    Salary AS SALARY, 
    dname AS DEPTNAME
FROM 
    emp_info 
JOIN 
    department ON emp_info.Deptno = department.Deptno;

# 13.  Job Grades Table
CREATE TABLE Job_Grades (
    Grade varchar(20) ,
    lowest_sal int ,
    highest_sal int
);

INSERT INTO Job_Grades (Grade, lowest_sal, highest_sal) VALUES 
	('A',0,999),
	('B',1000,1999),
	('C',2000,2999),
	('D',3000,3999),
	('E',4000,5000) ;


# 14.Display the last name, salary and  Corresponding Grade.
SELECT 
    Ename AS EMPNAME, 
    Salary AS SALARY, 
    GRADE AS GRADE
FROM 
       emp_info
JOIN 
	   Job_Grades G
    ON Salary BETWEEN G.lowest_sal AND G.highest_sal;
    
# 15.Display the Emp name and the Manager name under whom the Employee works in the below format .
   -- Emp Report to Mgr.    
SELECT 
    emp_info.Ename || ' reports to ' || emp_info.Ename AS "Emp Report to Mgr"
FROM 
    emp_info 
self JOIN 
    emp_info ON emp_info.Mgr = emp_info.Empno;
    
# 16.Display Empname and Total sal where Total Sal (sal + Comm)
SELECT 
    Ename AS EmpName,
    Salary + COALESCE(Comm, 0) AS Total_Sal
FROM 
    emp_info;

# 17.Display Empname and Sal whose empno is a odd number
SELECT 
    Ename AS EmpName, 
    Salary 
FROM 
    emp_info 
WHERE 
    MOD(Empno, 2) = 1;

# 18.Display Empname , Rank of sal in Organisation , Rank of Sal in their department
SELECT 
    Ename AS EmpName,
    Salary,
    
    RANK() OVER (ORDER BY Salary DESC) AS Org_Salary_Rank,
    
    RANK() OVER (PARTITION BY Deptno ORDER BY Salary DESC) AS Dept_Salary_Rank

FROM 
    emp_info;

# 19.Display Top 3 Empnames based on their Salary
SELECT EmpName, Salary
FROM (
    SELECT 
        Ename AS EmpName,
        Salary,
        RANK() OVER (ORDER BY Salary DESC) AS sal_rank
    FROM 
        emp_info
) Ranked
WHERE sal_rank <= 3;

# 20. Display Empname who has highest Salary in Each Department.
SELECT EmpName, DeptNo, Salary
FROM (
    SELECT 
        Ename AS EmpName,
        DeptNo,
        Salary,
        RANK() OVER (PARTITION BY DeptNo ORDER BY Salary DESC) AS sal_rank
    FROM 
        emp_info
) Ranked
WHERE sal_rank = 1;







    
