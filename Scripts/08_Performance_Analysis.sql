/* PERFORMANCE ANALYSIS */

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

WITH yearly_product_sales AS
(
SELECT YEAR(sales.order_date) AS order_year,
       products.product_name,
       SUM(sales.sales_amount) AS current_sales
	FROM sales
	LEFT JOIN products
ON sales.product_key = products.product_key
WHERE sales.order_date IS NOT NULL
GROUP BY 1, 2
)
SELECT order_year,
       product_name,
       current_sales,
       AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
	   current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales_diff,
       CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above avg'
            WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below avg'
            ELSE 'avg' END AS avg_change,
	   LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales,
       current_sales -LAG (current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS py_sales_diff,
       CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Incraese'
            WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
            ELSE 'no change' END AS change_from_py
	FROM yearly_product_sales
ORDER BY 2, 1; 