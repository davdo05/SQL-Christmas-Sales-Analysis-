/* -- Capstone Project: Xmas Gift Sales Analysis
Student: Do Long Anh
Data Source: FP20Analytics Challenge 12
-- */

USE fp20c12
GO

/* -----------------------------------------------------------------------------------------------------------------
Question 1: Retrieve sales information including revenue, quantity of products sold, cost, and profit for each Christmas season.
- Exclude data from the 2017-2018 Christmas season due to less than 3 months of data
- Round revenue, cost, and profit to millions of $ (2 decimal places)
- Round quantity to thousands (1 decimal place)
*/
SELECT CAST(date AS DATE) as date, time, total_sales, quantity as prdouct_quantity, cost, profit 
FROM xmas_sales
WHERE YEAR([date])>2018 -- Since we are only excluding the instance of 2017-2018, we could say this specifically to exclude 2018

/* -----------------------------------------------------------------------------------------------------------------
Question 2: Calculate the percentage growth of revenue, units sold, and profit for the most recent Christmas season compared to the previous year
*/
SELECT CAST(date as DATE) as date, total_sales, 
       LAG(total_sales) OVER (ORDER BY YEAR([date])) as last_year_sales, 
       ROUND(((total_sales -  LAG(total_sales) OVER (ORDER BY YEAR([date]))) /  
              LAG(total_sales) OVER (ORDER BY YEAR([date]))) * 100, 2) as percent_increase,
       quantity 
FROM xmas_sales 
ORDER BY date DESC
/* -----------------------------------------------------------------------------------------------------------------
Question 3: Revenue and percentage contribution of each purchase channel (purchase_type) for each Christmas season
*/
SELECT 
  purchase_type, 
  ROUND(SUM(total_sales), 2) AS total_sales_by_type, 
  ROUND(SUM(total_sales)*100.0/ SUM(SUM(total_sales)) OVER (), 2) as purchase_type_percentage
FROM xmas_sales
GROUP BY purchase_type;

/* -----------------------------------------------------------------------------------------------------------------
Question 4: Revenue statistics by country (and city). Sort in descending order of revenue.
*/
-- Revenue by country
SELECT ROUND(SUM(total_sales),2) as total_sales, country 
FROM xmas_sales 
GROUP BY country 
ORDER BY SUM(total_sales) DESC

-- Revenue by city
SELECT ROUND(SUM(total_sales), 2) as total_sales, city 
FROM xmas_sales 
GROUP BY city 
ORDER BY SUM(total_sales) DESC

/* -----------------------------------------------------------------------------------------------------------------
Question 4.6: Rank countries by highest revenue (or highest revenue growth percentage) for the most recent Christmas season
*/
SELECT ROUND(SUM(total_sales),2) as total_sales, country 
FROM xmas_sales 
GROUP BY country 
ORDER BY SUM(total_sales) DESC

/* -----------------------------------------------------------------------------------------------------------------
Question 4.7:
Calculate revenue proportion by age group
Calculate revenue proportion by gender
Calculate revenue proportion by purchase channel
*/
-- By age group
SELECT 
	customer_age_tange as age_range, 
	ROUND(SUM(total_sales),2) as total_sales, 
	ROUND(SUM(total_sales) / SUM(SUM(total_sales)) OVER (),2) as proportion
FROM xmas_sales
GROUP BY customer_age_tange

-- By gender
SELECT 
	gender, 
	ROUND(SUM(total_sales),2) as total_sales, 
	ROUND(SUM(total_sales) / SUM(SUM(total_sales)) OVER (),2) as proportion
FROM xmas_sales
GROUP BY gender

-- By purchase channel
SELECT 
  purchase_type, 
  ROUND(SUM(total_sales), 2) AS total_sales_by_type, 
  ROUND(SUM(total_sales)*100.0/ SUM(SUM(total_sales)) OVER (), 2) as purchase_type_percentage
FROM xmas_sales
GROUP BY purchase_type;

/* -----------------------------------------------------------------------------------------------------------------
Question 4.8: 
Calculate revenue proportion by purchase channel for each age group
Calculate revenue proportion by payment method for each age group
*/
-- By purchase channel for each age group
SELECT purchase_type, customer_age_tange, 
	ROUND(SUM(total_sales),2) as total_sales, 
	ROUND(SUM(total_sales)*100.0/SUM(SUM(total_sales)) OVER (),2) AS proportion
FROM xmas_sales
GROUP BY customer_age_tange, purchase_type
ORDER BY customer_age_tange DESC

-- By payment method for each age group
SELECT payment_method, customer_age_tange, 
	ROUND(SUM(total_sales),2) as total_sales, 
	ROUND(SUM(total_sales)*100.0/SUM(SUM(total_sales)) OVER (),2) AS proportion
FROM xmas_sales
GROUP BY customer_age_tange, payment_method
ORDER BY customer_age_tange DESC

/* -----------------------------------------------------------------------------------------------------------------
Question 4.9: Analyze sales information by category (product)
*/
-- By category
SELECT product_category,  
       SUM(total_sales) as total_sales, 
       AVG(total_sales) as avg_sales, 
       AVG(unit_price) as avg_price, 
       AVG(unit_cost) as avg_cost, 
       SUM(profit) as total_profit
FROM xmas_sales
GROUP BY product_category

-- By product
SELECT product_name,  
       SUM(total_sales) as total_sales, 
       AVG(total_sales) as avg_sales, 
       AVG(unit_price) as avg_price, 
       AVG(unit_cost) as avg_cost, 
       SUM(profit) as total_profit
FROM xmas_sales
GROUP BY product_name

/* ----------------------------------------------------------------------------------------------------------------- 
Question 4.10: 
Do male/female customers tend to shop more on certain days of the week?
What times of day do customers shop most often?
*/
-- What day of the week
SELECT gender,  
       DATENAME(WEEKDAY, [date]) as weekday, 
       SUM(total_sales) as total_sales
FROM xmas_sales
GROUP BY DATENAME(WEEKDAY, [date]), gender
ORDER BY SUM(total_sales) DESC

-- What time of the day
SELECT gender, time, 
       SUM(total_sales) as total_sales
FROM xmas_sales
GROUP BY gender, time
ORDER BY SUM(total_sales) DESC

-- Creates a new table called product_profit where products are ranked by profit. We then take the top 3 products per category
WITH product_profit AS (
	SELECT
		product_name, 
		product_category, 
		SUM(profit) AS total_profit, 
		RANK() OVER (PARTITION BY product_category ORDER BY SUM(profit) DESC) AS category_rank 
	FROM xmas_sales 
	GROUP BY product_name, product_category 
) 
SELECT * 
FROM product_profit 
WHERE category_rank < 4

-- Segmenting customers by spending behavior
WITH customer_spending AS (
	SELECT 
		gender, 
		customer_age_tange, 
		xmas_budget, 
		SUM(total_sales) as total_spent
	FROM xmas_sales 
	GROUP BY gender, customer_age_tange, xmas_budget
) 
SELECT *, 
       CASE 
		WHEN total_spent >= 1650000 THEN 'High Value'
		WHEN total_spent >= 1450000 THEN 'Medium Value' 
		ELSE 'Low Value' 
       END AS customer_segment 
FROM customer_spending; 

-- Identifying low-performing products with high unit costs 
SELECT 
	product_name, 
	product_category, 
	SUM(quantity) AS units_sold, 
	ROUND(AVG(unit_cost), 2) AS avg_cost, 
	ROUND(AVG(unit_price), 2) AS unit_price
FROM xmas_sales
GROUP BY product_name, product_category 
ORDER BY units_sold ASC; 

-- Filter products that outsell the overall average 
SELECT
	product_name, 
	SUM(total_sales) AS total_sales
FROM xmas_sales
GROUP BY product_name
HAVING SUM(total_sales) > ( 
	SELECT AVG(total_sales) FROM xmas_sales
); 

-- Find cities with above average total sales 
SELECT 
	city, 
	ROUND(SUM(total_sales),2) AS total_sales, 
	RANK() OVER (ORDER BY SUM(profit) DESC) AS city_rank
FROM xmas_sales 
GROUP BY city 
HAVING SUM(total_sales) > ( 
	SELECT AVG(total_sales) FROM xmas_sales
);  

