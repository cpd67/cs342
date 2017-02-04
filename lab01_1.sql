-- CS-342 Lab 01: Introduction
-- Date: 02/03/2017
-- Chris Dilley (cpd5)
-- The book for this class, Fundamentals of Database Systems, was very helpful in learning about SQL syntax.

-- A. 
SELECT * FROM DEPARTMENTS;

-- B. 
SELECT COUNT(employee_id) FROM EMPLOYEES;

--  C: i.
SELECT * FROM EMPLOYEES WHERE salary > 15000;
-- C: ii.
SELECT * FROM EMPLOYEES WHERE (hire_date BETWEEN DATE '2002-01-01' AND DATE '2004-12-31');
-- C: iii.
SELECT * FROM EMPLOYEES WHERE phone_number NOT LIKE '%515%';

-- D.
-- http://www.w3schools.com/sql/sql_join.asp (For learning how to do a join between tables)
-- This does a join between the Employees and Departments tables in order to get the list of employees in the finance department 
SELECT first_name || ' ' || last_name 
	FROM EMPLOYEES, DEPARTMENTS 
	WHERE DEPARTMENTS.department_id = EMPLOYEES.department_id AND DEPARTMENTS.department_name LIKE 'Finance' ORDER BY first_name ASC; 

-- E.
-- This does a join between the Locations, Countries, and Regions tables in order to get the list of city, state, and country names for all
-- locations in the Asian region.
SELECT city, state_province, country_name 
	FROM LOCATIONS, COUNTRIES, REGIONS 
	WHERE COUNTRIES.country_id = LOCATIONS.country_id AND REGIONS.region_id = COUNTRIES.region_id AND REGIONS.region_name LIKE 'Asia';

-- F.
-- http://www.w3schools.com/sql/sql_null_values.asp (For usage of IS NULL)
SELECT * FROM LOCATIONS WHERE state_province IS NULL; 
