drop table if exists title;
drop table if exists employee;
drop table if exists department;
drop table if exists salary;
drop table if exists department_employee;
drop table if exists manager;

create table title(
	title_id varchar not null,
	title varchar,
	primary key(title_id)
);

create table employee(
	employee_id integer not null,
	t_title_id varchar,
	foreign key (t_title_id) references title(title_id),
	birth_date date,
	first_name varchar(30),
	last_name varchar(30),
	sex varchar(1),
	hire_date date,
	primary key(employee_id)
);

create table department(
	department_id varchar not null,
	department_name varchar(30),
	primary key (department_id)
);

create table salary(
	s_employee_id integer not null,
	foreign key (s_employee_id) references employee(employee_id),
	salary integer,
	primary key(s_employee_id)
);

create table department_employee(
	e_employee_id int,
	foreign key (e_employee_id) references employee(employee_id),
	e_department_id varchar,
	foreign key (e_department_id) references department(department_id),
	primary key (e_employee_id, e_department_id)
);

create table manager(
	m_department_id varchar not null,
	foreign key (m_department_id) references department(department_id),
	m_employee_id integer not null,
	foreign key (m_employee_id) references employee(employee_id),
	primary key (m_department_id, m_employee_id)
);

select * from department_employee;

select e.employee_id, e.last_name as "Last Name", e.first_name as "First Name", s.salary
from employee e
join salary s on e.employee_id = s.s_employee_id;

select first_name as "First Name", last_name as "Last Name", hire_date as "Hire Date"
from employee
where hire_date between '1986-01-01' and '1986-12-31'
order by hire_date asc;

select m.m_department_id, d.department_name, m.m_employee_id, e.last_name, e.first_name
from manager m
join employee e on m.m_employee_id = e.employee_id
left join department d on m.m_department_id = d.department_id;

select dp.department_name as "Department", e.employee_id as "Employee ID", e.last_name as "Last Name", e.first_name as "First Name"
from employee e
join department_employee de on e.employee_id = de.e_employee_id
left join department dp on de.e_department_id = dp.department_id
order by dp.department_name asc;

select first_name as "First Name", last_name as "Last Name", sex as "Gender"
from employee
where first_name = 'Hercules'
and last_name like 'B%';

select e.employee_id as "Employee ID", e.first_name as "First Name", e.last_name as "Last Name",  d.department_name as "Department"
from employee e
join department_employee de on e.employee_id = de.e_employee_id
left join department d on de.e_department_id = d.department_id
where d.department_name = 'Sales';

select employee_id as "Employee ID", last_name as "Last Name", first_name as "First Name", (
	select department.department_name
	from department
	where department.department_name = 'Sales')
from employee
where employee_id in
(
	select e_employee_id
	from department_employee
	where e_department_id in (
		select department_id
		from department
		where department_name = 'Sales')
);

select d.department_name as "Department", e.employee_id as "Employee ID", e.last_name as "Last Name", e.first_name as "First Name"
from employee e
join department_employee de on e.employee_id = de.e_employee_id
left join department d on de.e_department_id = d.department_id
where d.department_name = 'Sales'
or d.department_name = 'Development'
order by d.department_name asc;

select last_name as "Last Name", count(last_name) as "Total employees with same last name"
from employee
group by last_name
order by last_name desc;
