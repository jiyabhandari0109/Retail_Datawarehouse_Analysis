/* DATA SEGMENTATION */

/*Segment products into cost ranges and 
count how many products fall into each segment*/

WITH product_segments AS
(
SELECT product_id,
	   product_name,
       cost,
       CASE WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000' END AS cost_range
	FROM products
    WHERE cost IS NOT NULL
)
SELECT cost_range,
       COUNT(product_id) AS total_products
	FROM product_segments
GROUP BY 1
ORDER BY 2 DESC;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than 5,000
	- Regular: Customers with at least 12 months of history but spending 5,000 or less
	- New: Customers with a lifespan less than 12 months
And find the total number of customers by each group
*/

WITH customer_spending AS
(
SELECT customers.customer_key,
       SUM(sales.sales_amount) AS total_spending,
       MIN(sales.order_date) AS first_order,
       MAX(sales.order_date) AS last_order,
       TIMESTAMPDIFF(month, MIN(sales.order_date), MAX(sales.order_date)) AS lifespan
	FROM sales
    LEFT JOIN customers
ON sales.customer_key = customers.customer_key
GROUP BY 1
)
SELECT customer_segment,
       COUNT(customer_key) AS total_customers
	FROM
(
SELECT customer_key,
       CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New' END AS customer_segment
	FROM customer_spending
) sub
GROUP BY 1
ORDER BY 2;
