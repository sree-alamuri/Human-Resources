CREATE DATABASE human_resources;
USE human_resources;
SELECT * FROM hr;

ALTER TABLE hr
CHANGE COLUMN ï»¿id empID VARCHAR(20) NULL;

-- to see the datatypes of all columns --
DESCRIBE hr;

-- to update we need to turn off the safe mode--
SET sql_safe_updates = 0;

-- update birthdate from texts to date--
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- change the type to DATE --
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;
-- Again see the structure to see the change that birthdate is now date datatype--

UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

-- when the termdate is not null and empty,change the date format and remove timestamp--
UPDATE hr
SET termdate = IF(termdate IS NOT NULL AND termdate != '', date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC')), '0000-00-00')
WHERE true;

SELECT termdate 
FROM hr;

SET sql_mode = 'ALLOW_INVALID_DATES';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;


-- add a column called age--
ALTER TABLE hr 
ADD COLUMN age INT;



-- the difference between current date and birthdate gives age--
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

SELECT 
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

-- few employees are below 18 years, we can exclude them for our analysis--
SELECT count(*) FROM hr WHERE age < 18;

SELECT COUNT(*) FROM hr WHERE termdate > CURDATE();

