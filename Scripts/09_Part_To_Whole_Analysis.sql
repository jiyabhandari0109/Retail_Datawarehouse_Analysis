/* PART-TO-WHOLE ANALYSIS */

-- Which categories contribute the most to the overall sales?

WITH category_sales AS
(
SELECT products.category,
       SUM(sales.sales_amount) AS total_sales
	FROM products
    LEFT JOIN sales
ON products.product_key = sales.product_key
WHERE sales_amount IS NOT NULL
GROUP BY 1
)
SELECT category,
       CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100, 2), '%') AS sales_contribution_percentage
	FROM category_sales
ORDER BY 2 DESC;