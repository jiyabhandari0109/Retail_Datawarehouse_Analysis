/*
====================================================================================================
CUSTOMER REPORT
====================================================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
====================================================================================================
*/

CREATE VIEW report_customers AS
WITH base_query AS 
(
SELECT sales.order_number,
       sales.product_key,
       sales.order_date,
       sales.sales_amount,
       sales.quantity,
       customers.customer_key,
       customers.customer_number,
       CONCAT(customers.first_name, ' ', customers.last_name) AS customer_name,
       TIMESTAMPDIFF(year, customers.birthdate, CURDATE()) AS age
	FROM sales 
    LEFT JOIN customers
ON sales.customer_key = customers.customer_key
WHERE order_date IS NOT NULL
),
customer_aggregation AS
(
SELECT customer_key,
       customer_number,
       customer_name,
       age,
       COUNT(DISTINCT order_number) AS total_orders,
       SUM(sales_amount) AS total_sales,
       SUM(quantity) AS total_quantity,
       COUNT(DISTINCT product_key) AS total_products,
       MAX(order_date) AS last_order_date,
       TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_in_months
	FROM base_query
    GROUP BY 1, 2, 3, 4
)
SELECT customer_key,
       customer_number,
       customer_name,
       age,
       CASE WHEN age < 20 THEN 'Below 20'
            WHEN age BETWEEN 20 AND 29 THEN '20-29'
            WHEN age BETWEEN 30 AND 39 THEN '30-39'
            WHEN age BETWEEN 40 AND 49 THEN '40-49'
            ELSE '50 and above' END AS age_group,
       CASE WHEN lifespan_in_months >= 12 AND total_sales > 5000 THEN 'VIP'
            WHEN lifespan_in_months >= 12 AND total_sales <= 5000 THEN 'Regular'
            ELSE 'New' END AS customer_segment,
       last_order_date,
       TIMESTAMPDIFF(month, last_order_date, CURDATE()) AS recency_in_months,
	   total_orders,
       total_sales,
       total_quantity,
       total_products,
       lifespan_in_months,
       -- Compute average order value
       CASE WHEN total_orders = 0 THEN 0
            ELSE total_sales / total_orders END AS avg_order_value,
            
	   -- Compute average monthly spend
       CASE WHEN lifespan_in_months = 0 THEN total_sales
            ELSE total_sales/lifespan_in_months END AS avg_monthly_spend            
	FROM customer_aggregation;
       


   