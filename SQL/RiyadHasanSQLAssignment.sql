use employees;

select employees.emp_no, employees.first_name, employees.last_name, titles.title
from employees
inner join titles
on employees.emp_no = titles.emp_no
limit 10
;

-- total employees
select count(employees.emp_no) AS TotalEmployees
from employees
;

-- avg salary by dept
select departments.dept_no, departments.dept_name, avg(salaries.salary) AS AvgSalary
from salaries
inner join employees
on salaries.emp_no = employees.emp_no
inner join dept_emp
on employees.emp_no = dept_emp.emp_no
inner join departments
on dept_emp.dept_no = departments.dept_no
group by departments.dept_name
order by AvgSalary desc
;

-- top 10 highest paid employees
select employees.emp_no, employees.first_name, employees.last_name, salaries.salary
from employees
inner join salaries
on employees.emp_no = salaries.emp_no
order by salaries.salary desc
limit 10
;

-- employees count by dept
select departments.dept_name, count(distinct(employees.emp_no)) AS TotalEmployees
from employees
inner join dept_emp
on employees.emp_no = dept_emp.emp_no
inner join departments
on dept_emp.dept_no = departments.dept_no
group by departments.dept_name
order by TotalEmployees desc
;
-- employees count by title
select titles.title, count(distinct(employees.emp_no)) AS TotalEmployees
from employees
inner join titles
on employees.emp_no = titles.emp_no
group by titles.title
order by TotalEmployees desc
;

-- salary trend over time (yearly trend)
select YEAR(to_date) AS year, avg(salary) AS AvgSalary
from salaries
group by year
having year != 9999
order by year asc
;

select avg(salary), year(to_date) from salaries
limit 10
;

-- gender distribution by department
select 
departments.dept_name,
-- sum(case when employees.gender = "M" then 1 else 0 END) * 100 / (select count(*) from employees group by dept_name) as PercentMales,
-- sum(case when employees.gender = "F" then 1 else 0 END) * 100 / (select count(*) from employees group by dept_name) as PercentFemales,
sum(case when employees.gender = "M" then 1 else 0 END) as Males,
sum(case when employees.gender = "F" then 1 else 0 END) as Females,
count(*) AS Total
from employees
inner join dept_emp
on employees.emp_no = dept_emp.emp_no
inner join departments
on dept_emp.dept_no = departments.dept_no
group by departments.dept_name
order by Total desc
;

-- employee retention by dept
select
departments.dept_name, 
avg(ABS(DATEDIFF(to_date, from_date))) AS Tenure
from dept_emp
inner join departments
on dept_emp.dept_no = departments.dept_no
where to_date != '9999-01-01'
group by departments.dept_name
order by Tenure desc
;

-- salary progression

-- gender pay gap
select
departments.dept_name,
avg(case when employees.gender = "M" then salary END) as MaleAvgSalary,
avg(case when employees.gender = "F" then salary END) as FemaleAvgSalary,
avg(salary) as AvgSalary
from employees
inner join salaries
on employees.emp_no = salaries.emp_no
inner join dept_emp
on salaries.emp_no = dept_emp.emp_no
inner join departments
on dept_emp.dept_no = departments.dept_no
group by departments.dept_name
;

-- promotion rate

-- manager performance

-- hiring trends for each dept
select YEAR(dept_emp.from_date) AS year,
sum(case when dept_no = "d001" then 1 END) as Marketing,
sum(case when dept_no = "d002" then 1 END) as Finance,
sum(case when dept_no = "d003" then 1 END) as HumanResources,
sum(case when dept_no = "d004" then 1 END) as Production,
sum(case when dept_no = "d005" then 1 END) as Development,
sum(case when dept_no = "d006" then 1 END) as QualityManagement,
sum(case when dept_no = "d007" then 1 END) as Sales,
sum(case when dept_no = "d008" then 1 END) as Research,
sum(case when dept_no = "d009" then 1 END) as CustomerService
from employees
inner join dept_emp
on dept_emp.emp_no = employees.emp_no
group by year
having year != 9999
order by year asc
; 

-- Employee Age Distribution

-- resets columns to default
ALTER TABLE employees
DROP COLUMN emp_age
;
-- Add Age column for age dist question. date used is current date as of today: 10 Aug 2024 
ALTER TABLE employees
ADD emp_age INT 
	AS (TIMESTAMPDIFF(YEAR, employees.birth_date, "2024-08-10"))
;

select 
departments.dept_name,
count(case when emp_age between 59 and 60 THEN 1 END) AS "59-60",
count(case when emp_age between 61 and 62 THEN 1 END) AS "61-62",
count(case when emp_age between 63 and 64 THEN 1 END) AS "63-64",
count(case when emp_age between 65 and 66 THEN 1 END) AS "65-66",
count(case when emp_age between 67 and 68 THEN 1 END) AS "67-68",
count(case when emp_age between 69 and 70 THEN 1 END) AS "69-70",
count(case when emp_age >= 71 THEN 1 END) AS "71+",
count(*) AS total
from employees
inner join dept_emp
on dept_emp.emp_no = employees.emp_no
inner join departments
on dept_emp.dept_no = departments.dept_no
group by departments.dept_name
;

-- performance (avg salary) of each department over time
select YEAR(salaries.from_date) AS year,
ROUND(avg(case when dept_no = "d001" then salary END),2) as Marketing,
ROUND(avg(case when dept_no = "d002" then salary END),2) as Finance,
ROUND(avg(case when dept_no = "d003" then salary END),2) as HumanResources,
ROUND(avg(case when dept_no = "d004" then salary END),2) as Production,
ROUND(avg(case when dept_no = "d005" then salary END),2) as Development,
ROUND(avg(case when dept_no = "d006" then salary END),2) as QualityManagement,
ROUND(avg(case when dept_no = "d007" then salary END),2) as Sales,
ROUND(avg(case when dept_no = "d008" then salary END),2) as Research,
ROUND(avg(case when dept_no = "d009" then salary END),2) as CustomerService
from salaries
inner join dept_emp
on dept_emp.emp_no = salaries.emp_no
group by year
having year != 9999
order by year asc
; 

select
MIN(from_date)
from dept_emp
;
-- turnover rate
-- finding the start date
select
MIN(from_date)
from dept_emp
;
-- full query
select
departments.dept_name,
(sum(case when dept_emp.to_date != "9999-01-01" then 1 END) / 
    (sum(case when dept_emp.to_date = "9999-01-01" then 1 END) +
    sum(case when dept_emp.from_date = "1985-01-01" then 1 END)
	) / 2
) * 100 AS TurnoverRate
from dept_emp
inner join departments
on dept_emp.dept_no = departments.dept_no
group by departments.dept_name
order by TurnoverRate asc
;

