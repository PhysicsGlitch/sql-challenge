-- Homework query tasks are numbered below with comments on the code. 


-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary. I know there are several ways to do this. I did it based on PK
-- in most examples, but just tried a join here to practice different ways of doing the task. The first query joins salaries on the emp_no. Normally I probably
-- wouldn't join unless I wanted to alter the table because there are different ways to select that don't need a join and are cleaner. Also, I know in the HW they taught us the
-- union function. I need to ask the TAs a follow-up, but I found it more intuitive to just select the columns and identify the keys. I'm not quite sure what is best practice,
-- but put it in my notes to ask. 

SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
LEFT JOIN salaries ON employees.emp_no=salaries.emp_no;

-- 2. List first name, last name, and hire date for employees who were hired in 1986. 
-- The first line is the code I ran where I just treated date as a string and retrieve. I tried a few ways to alter the date type without suggest.
-- A few people suggested that postgres had some oddities. But select convert, cast, alter column were tricky. So I was able to filter the numbers
-- and get the correct data. I put the code to query by year if the column was in proper date format below the original query. 

SELECT first_name, last_name, hire_date 
FROM employees 
WHERE hire_date LIKE '%1986';

SELECT first_name, last_name, hire_date 
FROM employees
WHERE year(hire_date) = 1986;

-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name. Here
-- I just selected the appropriate columns from the three tables annd the specified the keys which link the tables. No real trick, just need to properly link the keys. 

SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager, departments, employees
WHERE dept_manager.emp_no = employees.emp_no AND dept_manager.dept_no = departments.dept_no;

-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name. As noted in the schema table,
-- there are 31,579 extra rose arising from employees being assigned to multiple departments. The HW did say much about what to do with this. I could have amended the table
-- to create a "secondary" department. Although there was no information about a secondary or primary. The main point here is simply that since emp_no is the main PK of the
-- database that care would be needed if someone tried to take the emp_no of dept_emp to reference to salary or another table. I think adding a primary and secondary
-- department would be good db architecture to avoid redundancy and confusion. Just something to note. 

SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees, departments, dept_emp
WHERE employees.emp_no = dept_emp.emp_no AND departments.dept_no = dept_emp.dept_no;

-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B." I used this stack overflow
-- to discover the like method: https://stackoverflow.com/questions/10156965/select-all-where-first-letter-starts-with-b/10156984

SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' and last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name. I know I probably could do a 
-- subquery or filter here. But because it is just one value, a very easy way to write this syntax is just to add an additional condition for departments.dept_name = 'Sales' 
-- which will properly filter the data to give all of the employees in the Sales department. 

SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees, departments, dept_emp
WHERE employees.emp_no = dept_emp.emp_no AND departments.dept_no = dept_emp.dept_no and departments.dept_name = 'Sales';

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name. Once again, a subquery
-- could also be used, but the IN statement functions like a pseudo sub-query because I can specify the two values there and collect all the values needed in one line. I'll
-- have to follow up with the TAs about best practices and the most efficient methods to become a more skilled programmer. 

SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees, departments, dept_emp
WHERE employees.emp_no = dept_emp.emp_no AND departments.dept_no = dept_emp.dept_no and departments.dept_name IN ('Sales', 'Development'); 


-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name. This last query is really simple. I just specify
-- a select of last_name and COUNT(*). Then I just order the count(*) by desc to get the last_names and values. Foolsday is a nice
-- Easter Egg at the bottom. 

SELECT last_name, COUNT(*) 
FROM employees 
GROUP BY last_name
ORDER BY COUNT(*) DESC;