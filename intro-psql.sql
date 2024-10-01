--! QUERIES TO PSQL ONLY GET OPERATIONS No full CRUD (POSTGRESQL Explorer)
--! Does not have full crud operations only GET! (READ)
/***** PSQL QUERIES LESSONS *****/
-- Server connection to PSQL --
--HOST: 32.74.232.247
--Database: company_data
--Username: student
--Password: noble-student
--! Lesson (DAY 1)
--! 1. Write a SQL query to view the entire 'users' table.
SELECT *
FROM users;

--! 2. View the first 5 rows of the 'users' table. 
-- PostgreSQL:
SELECT *
FROM users
LIMIT
  5;

-- SQL Server:
SELECT TOP (5) *
FROM users;

--! 3. View the 'users' table, ordered by when the users were created (FROM newest to oldest).
SELECT *
FROM users
ORDER BY
  created_at DESC;

--! 4. View the entire 'orders' table.
SELECT *
FROM orders;

--! 5. View the name and state columns of the 'orders' table.
SELECT ship_name,
  ship_state
FROM orders;

--! 6. View the 10 most recent orders.
-- PostgreSQL:
SELECT *
FROM orders ORDER BYcreated_at DESC
LIMIT
  10;

-- SQL Server:
SELECT TOP (10) *
FROM orders
ORDER BY
  created_at DESC;

--! 7. Use DISTINCT to see which states people (users) are FROM (not WHERE the orders were shipped).
SELECT DISTINCT
  user_state
FROM users;

-- EXTRA CREDIT: If you finish early.
--! 1. You can use DISTINCT (to remove duplicate rows) even when showing multiple columns.
--    Use DISTINCT ON the orders table to see which states each user has shipped orders to.
SELECT DISTINCT
  user_id,
  ship_state
FROM orders;

--! 2. SQL Server orders the results automatically, but Postgres does not.
--    Postgres Only: Modify the query above to ORDER BY user_id and then ship state.
SELECT DISTINCT
  user_id,
  ship_state
FROM orders
ORDER BY
  user_id,
  ship_state;


/* LIKE and Wildcards */
--! 1. Find all the users with a gmail email address.
SELECT *
FROM users
WHERE email LIKE '%@gmail.com';

--! 2. Find all the orders shipped to Florida (FL) or Texas (TX).
--    Below are 2 solutions that both work:
SELECT *
FROM orders
WHERE ship_state = 'FL'
  OR ship_state = 'TX';

-- or
SELECT *
FROM orders
WHERE ship_state IN ('FL', 'TX');

--    Bonus: Order the results by the state.
SELECT *
FROM orders
WHERE ship_state IN ('FL', 'TX')
ORDER BY
  ship_state;

--! 3. Find the 5 most recent orders shipped to New York (NY).
-- PostgreSQL:
SELECT *
FROM orders
WHERE ship_state = 'NY'
ORDER BY
  created_at DESC
LIMIT
  5;

-- SQL Server:
SELECT TOP (5) *
FROM orders
WHERE ship_state = 'NY'
ORDER BY
  created_at DESC;

--! 4. Select all the products that include the word 'plate' and cost more than $20.
-- PostgreSQL:
SELECT *
FROM products
WHERE title ILIKE '%plate%'
  AND price > 20;

-- SQL Server:
SELECT *
FROM products
WHERE title LIKE '%plate%'
  AND price > 20;

--! 5. Find all the products that do NOT contain 'rubber' in the title.
-- PostgreSQL:
SELECT *
FROM products
WHERE NOT title ILIKE '%rubber%';

-- SQL Server:
SELECT *
FROM products
WHERE NOT title LIKE '%rubber%';

--! 6. Find all the products that are tagged 'grey' or 'gray'
--    (notice the different spellings: one is 'e' and other 'a')
-- PostgreSQL:
SELECT *
FROM products
WHERE tags ILIKE '%grey%'
  OR tags ILIKE '%gray%';

-- SQL Server:
SELECT *
FROM products
WHERE tags LIKE '%grey%'
  OR tags LIKE '%gray%';

--! 7. Find only the line_items with a status of 'returned'
SELECT *
FROM line_items
WHERE status = 'returned';

--! 8. Building ON the query above, let's find the most expensive returns:
--    Add a column for price multiplied by quantity 
--    The new column won't have a column name, so give it an alias.
--    ORDER BY that column so the most expensive returns are at the top.
SELECT *,
  price * quantity AS total_value
FROM line_items
WHERE status = 'returned'
ORDER BY
  total_value DESC;

/* The Below is the class ON the joining the tables */
--! 1. Select everything FROM the line_items table.
-- In the results, notice it contains the price and quantity, but not who ordered it.
SELECT *
FROM line_items;

--! 2. Join the line_items table to the orders table (ON the order_id column)
-- In the results, notice you can NOW see price, quantity, and user_id.
-- Without Aliases
SELECT *
FROM line_items
  JOIN orders ON line_items.order_id = orders.order_id;

-- With Aliases
SELECT *
FROM line_items li
  JOIN orders o ON li.order_id = o.order_id;

--! 3. We want to get the user's name, so continuing with the previous query,
-- also JOIN in the users table (ON the user_id column).
-- In the results, notice you can NOW see the price, quantity, and name of the user.
SELECT *
FROM line_items li
  JOIN orders o ON li.order_id = o.order_id
  JOIN users u ON u.user_id = o.user_id;

--! 4. Continuing with the previous query, filter the results to show 
-- just the name and email of people who had a line_item of $700 or more.
-- Don't forget that involves math for quantity times price.
SELECT name,
  email
FROM line_items li
  JOIN orders o ON li.order_id = o.order_id
  JOIN users u ON u.user_id = o.user_id
WHERE li.price * li.quantity >= 700;

--! Lesson (DAY 2)
--  Outer Join and NULL
-------------------------------------------------------------------
-- WARMUPS & REFERENCE
-------------------------------------------------------------------
-- 1. Finding NULLS:
--    Find all employees who do NOT have a dept_id assigned:
--    SELECT * FROM employees
--    WHERE dept_id IS NULL;
SELECT *
FROM employees
WHERE dept_id is NULL;

--    Find all employees who have a dept_id assigned:
--    SELECT * FROM employees
--    WHERE dept_id IS NOT NULL;
SELECT *
FROM employees
WHERE dept_id IS NOT NULL;

-- 2. Empty strings vs NULL. Sometimes empty values can be stored either way!
--    Find all users who do NOT have a password because it's NULL):
--    SELECT * FROM users
--    WHERE password IS NULL;
SELECT *
FROM users
WHERE password IS NULL;

--    Find all users who do NOT have a password because it's an empty string:
--    SELECT * FROM users
--    WHERE password = '';
SELECT *
FROM users
WHERE password = '';

--    Look for both empty strings and NULLs:
--    SELECT * FROM users
--    WHERE password = '' OR password IS NULL;
SELECT *
FROM users
WHERE password = ''
  OR password IS NULL;

-- 3. Inner Join (or simply JOIN, gives matching data):
--    SELECT * FROM employees e
--    JOIN departments d
--    ON e.dept_id = d.dept_id; 
SELECT *
FROM employees e
  JOIN departments d ON e.dept_id = d.dept_id;

-- 4. Left (Outer) Join (gives matching & non-matching data):
--    SELECT * FROM employees e
--    LEFT JOIN departments d 
--    ON e.dept_id = d.dept_id; 
SELECT *
FROM employees e
  LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- 5. Right (Outer) Join (same as left, but order of tables is swapped):
--    SELECT * FROM departments d
--    RIGHT JOIN employees e
--    ON e.dept_id = d.dept_id;
--!/* you can use lower case also to write psql commands and reserved words BUT THE CONVENTION IS TO USE UPPERCASE FOR KEY WORDS */
SELECT *
FROM departments d
  RIGHT JOIN employees e ON e.dept_id = d.dept_id;

-- 6. Full (Outer) Join:
--    SELECT * FROM employees e
--    FULL JOIN departments d
--    ON e.dept_id = d.dept_id;
SELECT *
FROM employees e
  full JOIN departments d ON e.dept_id = d.dept_id;

--    Find departments that do not have employees in them:
--    SELECT * FROM employees e
--    FULL JOIN departments d
--    ON e.dept_id = d.dept_id
--    WHERE e.emp_id IS NULL;
SELECT *
FROM employees e
  full JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;

--------------------------------------------------------
-- EXERCISES: Answer using the techniques FROM above.
--------------------------------------------------------
-- 1. Join the products table to the line_items table.
--    Choose a JOIN that will KEEP products even if they don't have any associated line_items.
SELECT *
FROM products d
  LEFT JOIN line_items li ON d.product_id = li.product_id;

-- 2. Were there any products with no orders? 
--    Query the joined table for rows with NULL quantity. 
SELECT d.*
FROM products d
  LEFT JOIN line_items li ON d.product_id = li.product_id
WHERE li.quantity IS NULL
  ----------------------------------------
  -- EXTRA CREDIT: If you finish early.
  ----------------------------------------
  -- 1. Let's find the names of people who ordered something in a quantity of 5 or greater: 
  --    A. First, JOIN the tables.
  --       Which kind of JOIN is appropriate and which tables are you joining?
SELECT u.name,
  u.email,
  li.quantity
FROM users u
  INNER JOIN orders o ON u.user_id = o.user_id
  INNER JOIN line_items li ON o.order_id = li.order_id
WHERE li.quantity >= 5
ORDER BY
  li.quantity DESC,
  u.name ASC;

--    B. Second, only show people who ordered something in a quantity of 5 or greater.
--       In the results, only display the name, email, and quantity
--       with the highest quantity at the top (also put the names in alphabetical order).
SELECT u.name,
  u.email,
  li.quantity
FROM users u
  INNER JOIN orders o ON u.user_id = o.user_id
  INNER JOIN line_items li ON o.order_id = li.order_id
WHERE li.quantity >= 5
ORDER BY
  li.quantity DESC,
  u.name ASC;

--! CAST
-------------------------------------------------------------------
-- WARMUPS & REFERENCE
-------------------------------------------------------------------
-- 1. CAST: Convert to whole number 
--    NOTE: SQL Server does not round up/down, it just deletes the decimal part
--    SELECT CAST(2.6 AS INT);
SELECT CAST(2.6 AS INT);

-- Result: 2
-- 2. CAST: Convert to a decimal
--    The decimal number below can be up to 9 total digits 
--    (including left and right side of decimal point),
--    with 2 digits to the right of the decimal place.
--    SELECT CAST('2.5897' AS DECIMAL(9,2));
SELECT CAST('2.5897' AS DECIMAL(9, 2));

-- Result: 2.59
--    Because SQL Server's CAST as INT does not round up/down, 
--    we can use a decimal data type, but with no decimal places.
--    SELECT CAST('2.5897' AS DECIMAL(9,0));
SELECT CAST('2.5897' AS DECIMAL(9, 0));

-- Result: 3
-- 3. CAST: Convert string to number
--    The show_number column is stored as a string.
--    Trying to do math with a string works in SQL Server, 
--    but in PostgreSQL results in an error:
--    PostgreSQL (You must choose the game_shows database before running this query):
--    SELECT show_number + 1
--    FROM jeopardy;
SELECT CAST(show_number AS INT) + 1
FROM jeopardy;

--    SQL Server:
--    SELECT TOP(200) show_number + 1
--    FROM game_shows.dbo.jeopardy;
--    For PostgreSQL we need to convert the string 
--    into a whole number in order to do the math:
--    SELECT CAST(show_number AS INT) + 1
--    FROM jeopardy;
SELECT CAST(show_number AS INT) + 1
FROM jeopardy;

--! Aggregate Functions and ROUND
-------------------------------------------------------------------
-- WARMUPS & REFERENCE
-------------------------------------------------------------------
-- 1. Using MAX and MIN:
--    SELECT MAX(price) FROM products;
--    SELECT MIN(price) FROM products;
SELECT MAX(price)
FROM products;

SELECT MIN(price)
FROM products;

--    SELECT MIN(price) FROM products;
-- 2. Using COUNT:
--    SELECT COUNT(*) FROM users;
SELECT count(*)
FROM users u
SELECT *
FROM users
  --    NULL values are not counted:
  --    SELECT COUNT(password) FROM users;
SELECT count(password)
FROM users;

-- the below is more reliable
SELECT *
FROM users
WHERE password is null
  --    Count distinct values:
  --    SELECT COUNT(DISTINCT user_state) FROM users;
SELECT count(distinct user_state)
FROM users;

-- 3. Using SUM:
--    SELECT SUM(price) FROM line_items;
SELECT sum(price),
  sum(price * quantity)
FROM line_items;

-- 4. Using AVG:
--    SELECT AVG(price) FROM line_items;
SELECT avg(price)
FROM line_items;

--
SELECT avg(price)
FROM products;

-- 5. Using an alias to name the column:
--    SELECT AVG(price) AS "average price"
--    FROM line_items;
SELECT avg(price) as "average price"
FROM line_items li;

-- 6. Rounding to a whole number:
--    PostgreSQL:
--    SELECT AVG(price), ROUND( AVG(price) ) FROM line_items;
SELECT avg(price),
  round(avg(price))
FROM line_items li
  --    SQL Server: This rounds to a whole number, but you get trailing zeros:
  --    SELECT AVG(price), ROUND( AVG(price), 0 ) FROM line_items;
  --    SQL Server: This converts to a decimal number with no decimal places
  --    (so it rounds up or down) to remove the trailing zeros:
  --    SELECT AVG(price), CAST( AVG(price) AS DECIMAL(9,0) ) FROM line_items;
  --    NOTE: DECIMAL(9,0) means the number can be up to 9 total digits 
  --    (including left and right side of decimal point),
  --    with 0 digits to the right of the decimal place.
  -- 7. Rounding to 2 decimal places:
  --    PostgreSQL:
  --    SELECT AVG(price), ROUND( AVG(price), 2 ) FROM line_items;
  --    SELECT AVG(price), CAST( AVG(price) AS MONEY ) FROM line_items;
SELECT avg(price),
  round(avg(price), 2)
FROM line_items li;

--! the currency format below
SELECT avg(price),
  cast(avg(price) as money)
FROM line_items li;

--    SELECT AVG(price), ROUND( AVG(price), 2 ) FROM line_items;
--    SELECT AVG(price), CAST( AVG(price) AS DECIMAL(9,2) ) FROM line_items;
-- 8. Rounding Up & Down:
--    Round Down:
--    SELECT AVG(price), FLOOR( AVG(price) ) FROM line_items;
SELECT avg(price),
  floor(avg(price))
FROM line_items li;

--    Round Up:
--    SELECT AVG(price), CEILING( AVG(price) ) FROM line_items;
SELECT avg(price),
  CEILING(avg(price))
FROM line_items li;

-- 9. Round Down to 2 Decimal Places:
--    SELECT AVG(price), FLOOR( AVG(price * 100) ) / 100 FROM line_items;
SELECT avg(price),
  floor(avg(price * 100)) / 100
FROM line_items li;

--------------------------------------------------------
--! EXERCISES: Answer using the techniques FROM above.
--------------------------------------------------------
-- 1. Find the total number of orders.
SELECT COUNT(*) AS total_orders
FROM orders;

-- 2. Find the average product price.
SELECT avg(price) as average_price
FROM products;

-- 3. Find the maximum product price that's NOT a lamp.
SELECT MAX(price) AS max_price
FROM products
WHERE title NOT ILIKE '%lamp%';

-- 4. Find the number of users with a gmail email address.
SELECT COUNT(*) AS gmail_users
FROM users
WHERE email ILIKE '%@gmail.com';

-- 5. Using the line_items table, find the total dollar value 
--    of all items with status 'returned'.
SELECT CAST(SUM(quantity * price) AS money)
FROM line_items li
WHERE status = 'returned';

-- 6. Find the average price of all products containing the word 'hat' in their title.
SELECT AVG(price) AS average_hat_price
FROM products
WHERE title ILIKE '%hat%';

----------------------------------------
-- EXTRA CREDIT: If you finish early.
----------------------------------------
-- 1. You can may use multiple aggregation functions in one SELECT.
--    Using only one query, find the MIN(), MAX(), and AVG() 
--    of the prices in the product table.
SELECT MIN(price) AS min_price,
  MAX(price) AS max_price,
  ROUND(AVG(price), 2) AS avg_price
FROM products;

-- 2. In one query, find the difference between the 
--    price of the most expensive and least expensive product.
SELECT MAX(price) - MIN(price) AS price_difference
FROM products;

--! Date Functions
-------------------------------------------------------------------
-- WARMUPS & REFERENCE
-------------------------------------------------------------------
-- 1. Using DATE PART:
--    In PostgreSQL:
--    SELECT created_at, DATE_PART('hour', created_at) FROM orders;
--    SELECT created_at, DATE_PART('day', created_at) FROM orders;
--    SELECT created_at, DATE_PART('month', created_at) FROM orders;
--    SELECT created_at, DATE_PART('year', created_at) FROM orders;
--    SELECT created_at, DATE_PART('dow', created_at) FROM orders;
--    NOTE: In PostgreSQL Sunday = 0 Monday = 1 through Saturday = 6
SELECT created_at,
  DATE_PART('hour', created_at)
FROM orders;

SELECT created_at,
  DATE_PART('day', created_at)
FROM orders;

SELECT created_at,
  DATE_PART('month', created_at)
FROM orders;

SELECT created_at,
  DATE_PART('year', created_at)
FROM orders;

SELECT created_at,
  DATE_PART('dow', created_at)
FROM orders;

-- 2. Getting the name of the month and day:
--    In PostgreSQL:
--    SELECT created_at, TO_CHAR(created_at, 'Month') FROM orders;
--    SELECT created_at, TO_CHAR(created_at, 'Day') FROM orders;
--    SELECT created_at, TO_CHAR(created_at, 'Dy') FROM orders;
--    SELECT created_at, TO_CHAR(created_at, 'DD') FROM orders;
--    SELECT created_at, TO_CHAR(created_at, 'YYYY') FROM orders;
--    Learn more about TO_CHAR:
--!    https://www.postgresql.org/docs/current/functions-formatting.html
-- for TO_CHAR the field argument comes first.
SELECT created_at,
  TO_CHAR(created_at, 'Month')
FROM orders;

SELECT created_at,
  TO_CHAR(created_at, 'Day')
FROM orders;

SELECT created_at,
  TO_CHAR(created_at, 'Dy')
FROM orders;

SELECT created_at,
  TO_CHAR(created_at, 'DD')
FROM orders;

SELECT created_at,
  TO_CHAR(created_at, 'YYYY')
FROM orders;

-- 3. Get weekend orders:
--!    In PostgreSQL: Sunday = 0 Monday = 1 through Saturday = 6
--    SELECT * FROM orders
--    WHERE DATE_PART('dow', created_at) IN (0, 6); 
SELECT *
FROM orders
WHERE DATE_PART('dow', created_at) in (0, 6);

-- 4. Calculate the difference between 2 dates:
--    In PostgreSQL:
--    SELECT DATE_PART( 'year', NOW() ) - DATE_PART( 'year', created_at ) FROM orders;
SELECT DATE_PART('year', NOW()) - DATE_PART('year', created_at)
FROM orders;

-- 5. Getting a DATE range:
--    SELECT COUNT(*) FROM orders
--    WHERE created_at BETWEEN '2021-01-01' AND '2022-02-01';
SELECT COUNT(*)
FROM orders
WHERE created_at BETWEEN '2021-01-01' AND '2022-02-01';

--!    PROBLEM: If your column contains DATETIME and you do not specify hours when specifying the DATE,
--    the hours default to 00:00:00 so it does not go through the end of the last day!
--!    SOLUTION: Convert to a DATE (instead of datetime which includes the time)
--    so you get the entire final day:
--    SELECT COUNT(*) FROM orders
--    WHERE CAST(created_at AS DATE) BETWEEN '2021-01-01' AND '2022-02-01';
SELECT COUNT(*)
FROM orders
WHERE CAST(created_at AS DATE) BETWEEN '2021-01-01' AND '2022-02-01';

--------------------------------------------------------
-- EXERCISES: Answer using the techniques FROM above.
--------------------------------------------------------
-- 1. How many years old, is the oldest user account?
SELECT EXTRACT(
    year
    FROM AGE (MIN(created_at))
  ) AS oldest_account_years
FROM users;

-- 2. During which years were user accounts created?
SELECT DISTINCT
  EXTRACT(
    year
    FROM created_at
  ) AS creation_year
FROM users
ORDER BY
  creation_year;

-- 3. How many user accounts were created ON a weekend?
--!function declaration similar to js but not the same
SELECT COUNT(*) AS weekend_accounts
FROM users
WHERE EXTRACT(
    dow
    FROM created_at
  ) IN (0, 6);

-- 4. During which months in the first third of the year were user accounts created?
SELECT DISTINCT
  EXTRACT(
    MONTH
    FROM created_at
  ) AS creation_month,
  TO_CHAR(created_at, 'Month') AS month_name
FROM users
WHERE EXTRACT(
    MONTH
    FROM created_at
  ) BETWEEN 1 AND 4
ORDER BY
  creation_month;

-- 5. How many user accounts were created September 21, 2020 to December 20, 2020?
SELECT COUNT(*) AS accounts_created
FROM users
WHERE created_at BETWEEN '2020-09-21' AND '2020-12-20';

--! GROUP BY
-------------------------------------------------------------------
-- WARMUPS & REFERENCE
-------------------------------------------------------------------
-- 1. Grouping by one column: 
--    SELECT ship_state, COUNT(*) 
--    FROM orders
--    GROUP BY ship_state;
SELECT ship_state,
  COUNT(*)
FROM orders
GROUP BY
  ship_state;

-- 2. Grouping by multiple columns:
--    SELECT ship_state, ship_zipcode, COUNT(*)
--    FROM orders
--    GROUP BY ship_state, ship_zipcode
--    ORDER BY ship_state;
SELECT ship_state,
  ship_zipcode,
  COUNT(*)
FROM orders
GROUP BY
  ship_state,
  ship_zipcode
ORDER BY
  ship_state;

-- 3. Grouping by multiple columns, only using the first 5 digits in zipcode:
--    LEFT() accepts 2 parameters: the string, how many characters you want
--    SELECT ship_state, LEFT(ship_zipcode,5), COUNT(*)
--    FROM orders
--    GROUP BY ship_state, LEFT(ship_zipcode,5)
--    ORDER BY ship_state;
SELECT ship_state,
  LEFT(ship_zipcode, 5),
  COUNT(*)
FROM orders
GROUP BY
  ship_state,
  LEFT(ship_zipcode, 5)
ORDER BY
  ship_state;

--------------------------------------------------------
--! EXERCISES: Answer using the techniques FROM above.
--------------------------------------------------------
-- 1. When was the most recent order made in each state?
SELECT ship_state,
  MAX(created_at) AS most_recent_order
FROM orders
GROUP BY
  ship_state
ORDER BY
  ship_state;

-- 2. Use the line_items table to find the total number of each product_id sold.
--    Make sure you exclude returned and canceled FROM your results.
SELECT product_id,
  COALESCE(SUM(quantity), 0) AS total_sold,
  MIN(price) AS min_price,
  MAX(price) AS max_price,
  COUNT(*) AS total_orders
FROM line_items
WHERE COALESCE(status, '') NOT IN ('returned', 'canceled')
GROUP BY
  product_id
HAVING
  COALESCE(SUM(quantity), 0) > 0;

-- 3. Use the line_items table to see the total dollar amount of items in each status (returned, shipped, etc.)
SELECT status,
  SUM(price * quantity) AS total_amount
FROM line_items
GROUP BY
  status;

-- 4. In the products table, find how many products are under each set of tags.
SELECT tags,
  count(tags) as total_count
FROM products p
GROUP BY
  tags
ORDER BY
  tags;

-- 5. Modify the previous query to find how many products over $70 are under each set of tags.
SELECT tags,
  count(tags) as total_count
FROM products
WHERE price >= 70
GROUP BY
  tags
ORDER BY
  total_count DESC;

-- 6. Use the orders table to find out how many orders each user made.
SELECT user_id,
  COUNT(*) AS total_orders
FROM orders
GROUP BY
  user_id
Order by
  total_orders desc;

-- 7. When was the first order made in each state, in each zipcode?
--    Zipcodes do not repeat between states, but write your query to show both
--    the zipcode and state because it's nice to see the state for context.
SELECT ship_zipcode,
  ship_state,
  min(created_at) first_order
FROM orders o
GROUP BY
  ship_zipcode,
  ship_state
ORDER BY
  first_order;

----------------------------------------
--! EXTRA CREDIT: If you finish early.
----------------------------------------
-- REMINDER: Use DATE_PART() in PostgreSQL or DATEPART() in SQL Server
-- 1. Use DATE PART to EXTRACT which calendar month each user was created in.
SELECT user_id,
  DATE_PART('month', created_at) AS created_month,
  TO_CHAR(created_at, 'Month') AS month_name
FROM users;

-- 2. Use DATE PART and a GROUP BY statement to count how many users were created in each calendar month.
SELECT DATE_PART('month', created_at) AS created_month,
  COUNT(*) AS total_users
FROM users
GROUP BY
  created_month
ORDER BY
  created_month;

-- 3. Use DATE PART to find the number of users created during each day of the week.
--! the below is better since PSQL counts FROM Sunday = 0, which must be taken account of when creatig queries.
SELECT CASE
    WHEN DATE_PART('dow', created_at) = 0 THEN 7
    ELSE DATE_PART('dow', created_at)
  END AS day_of_week,
  TO_CHAR(created_at, 'Day') AS day_name,
  COUNT(*) AS total_users
FROM users
GROUP BY
  day_of_week,
  day_name
ORDER BY
  day_of_week;

--! GROUP BY with HAVING
-------------------------------------------------------------------
-- WARMUPS & REFERENCE
-------------------------------------------------------------------
-- 1. Group by using a HAVING filter:
--    Find states that have 10 or more orders:
--    SELECT ship_state, COUNT(*)
--    FROM orders 
--    GROUP BY ship_state 
--    HAVING COUNT(*) >= 10;
SELECT ship_state,
  COUNT(*)
FROM orders
GROUP BY
  ship_state
HAVING
  COUNT(*) >= 10;

--------------------------------------------------------
-- EXERCISES: Answer using the techniques FROM above.
-- These use the jeopardy table in the game_shows database.
-- Remember to choose the game_shows database (or specify it in SQL Server)
--------------------------------------------------------
-- 1. Find the combined value of all questions for each air_date.
SELECT air_date,
  SUM(value) AS total_value
FROM jeopardy
GROUP BY
  air_date;

-- 2. Add a HAVING clause to the last query to find the dates 
--    when all the questions had a combined value < 10,000
SELECT air_date,
  SUM(value) AS total_value
FROM jeopardy
GROUP BY
  air_date
HAVING
  SUM(value) < 10000;

-- 3. Find the value of the highest-value question for each show_number.
SELECT show_number,
  MAX(value) AS highest_value
FROM jeopardy
GROUP BY
  show_number;

-- 4. Which shows had a question worth more than $2000?
SELECT show_number,
  MAX(value) AS highest_value
FROM jeopardy
GROUP BY
  show_number
HAVING
  MAX(value) > 2000;

----------------------------------------
-- EXTRA CREDIT: If you finish early.
----------------------------------------
--    To get the number of characters in a string:
--    In PostgreSQL: SELECT LENGTH(question) FROM jeopardy;
--    In SQL Server: SELECT LEN(question) FROM game_shows.dbo.jeopardy;
-- 1. Display the air_date and "average" question length (number of characters)
--    ordered FROM longest (ON top) to shortest.
SELECT air_date,
  AVG(LENGTH(question)) AS avg_question_length
FROM jeopardy
GROUP BY
  air_date
ORDER BY
  avg_question_length DESC;

--! Lesson (DAY 3)