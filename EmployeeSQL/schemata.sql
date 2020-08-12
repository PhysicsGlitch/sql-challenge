-- Create Tables and Import CSVs with primary and foreign key constraints

CREATE TABLE departments (
	dept_no VARCHAR(4),
	dept_name VARCHAR,
	PRIMARY KEY (dept_no)
);

CREATE TABLE titles (
  	title_id VARCHAR(5),
	title_name VARCHAR,
	PRIMARY KEY (title_id)
);

-- In retrospect, I realized I forgot to put date as date format. I also added the primary key for emp_no after as well. It was a good exercise in learning
-- how to alter data or keys after a database, but would have made it more efficient the first time if I had to do it again. 

CREATE TABLE employees (
  	emp_no INT,
	emp_title_id VARCHAR(5),
	birth_date VARCHAR,
	first_name VARCHAR,
	last_name VARCHAR,
	sex VARCHAR(1),
	hire_date VARCHAR,
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

-- The departments and titles tables are easy to check for unique values for the primary keys. However, to maintain data integrity we need to check
-- for unique values of emp_no in employees table. After creating and importing the csv we can then run a simple query. This was an elegant method
-- I found on stack after I tried it a few different ways. I just count distinct the column and then do a regural count to see fi the numbers are the
-- same which they are so we know emp_no can be a unique constraint. https://stackoverflow.com/questions/26199765/sql-query-to-determine-that-values-in-a-column-are-unique#
-- :~:text=select%20count(distinct%20column_name)%2C,then%20all%20values%20are%20unique.&text=If%20you%20want%20to%20list,inner%20query%20and%20run%20it.

SELECT COUNT (distinct emp_no), count(emp_no)
FROM employees;

-- This code could be repeated for any other key which we want to include in a composite primary key, if it seemed appropriate. I could have checked for uniqueness of 
-- last_name, first_name, but already know by scanning the csvs this is not the case. 

-- For practice instead of just recreating the database after checking, I altered the table to add the primary key after checking for unique values. Also I know I could add
-- last_name, first_name after emp_no as additional constraints for a composite key, but because I checked for uniqueness and also because this won't be a live database
-- and just for diagnostic purposes it seemed like an inefficient step. But I could ADD PRIMARY KEY (emp_no, last_name, first_name) although it appears best practice is to 
-- name the primary constraint such as CONSTRAINT PK_employees PRIMARY KEY NONCLUSTERED ([emp_no], [last_name], [first_name]). NONCLUSTERED is appropriate here because the
-- data is unsorted. 

-- This code adds the primary key to employees.
ALTER TABLE employees ADD PRIMARY KEY (emp_no);


-- Create the dept_emp table with foreign key constraints to the previous tables. One thing to note about this table is that there are several emp_nos that map to multiple
-- departments. I ran a count belew of unique employee numbers as before which is 300,024. But the total count of the dept_emp table is 331,603. So there are 31,579 extra rows
-- which either arise from employees listed in two or more unique departments. 

CREATE TABLE dept_emp (
  	emp_no INT,
	dept_no VARCHAR(4),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

SELECT COUNT (distinct emp_no), count(emp_no)
FROM dept_emp;

-- Same steps as the dept_emp table with foreign key constraints to the previous tables.

CREATE TABLE dept_manager (
  	dept_no VARCHAR(4),
	emp_no INT,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

-- final table of salaries linked with a foreign key to the employees table. 

CREATE TABLE salaries (
  	emp_no INT,
	salary INT,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);