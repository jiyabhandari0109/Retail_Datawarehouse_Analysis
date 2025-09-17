/*
====================================================================================================
PRODUCT REPORT
====================================================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
====================================================================================================
*/

CREATE VIEW report_products AS
WITH base_query AS
(
SELECT sales.order_number,
       sales.order_date,
       sales.customer_key,
       sales.sales_amount,
       sales.quantity,
       products.product_key,
       products.product_name,
       products.category,
       products.subcategory,
       products.cost
	FROM sales
    LEFT JOIN products
ON sales.product_key = products.product_key
WHERE order_date IS NOT NULL
),
product_aggregations AS
(
SELECT product_key,
       product_name,
       category,
       subcategory,
       cost,
       COUNT(DISTINCT order_number) AS total_orders,
       SUM(sales_amount) AS total_sales,
       SUM(quantity) AS total_quantity,
       COUNT(customer_key) AS total_customers,
       TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan_in_months,
       MAX(order_date) AS last_sale_date,
       ROUND(AVG(sales_amount / NULLIF(quantity, 0)),2) AS avg_selling_price
	FROM base_query
    GROUP BY 1, 2, 3, 4, 5
)
SELECT product_key,
       product_name,
       category,
       subcategory,
       cost,
       last_sale_date,
       TIMESTAMPDIFF(month, last_sale_date, CURDATE()) AS recency_in_months,
       CASE WHEN total_sales > 50000 THEN 'High-performer'
            WHEN total_sales >=10000 THEN 'Mid-range'
            ELSE 'Low-performer' END AS product_segment,
       total_orders,
       total_sales,
       total_quantity,
       total_customers,
       avg_selling_price,
       -- Average order revenue
       CASE WHEN total_sales = 0 THEN 0
            ELSE ROUND((total_sales / total_orders), 2) END AS avg_order_revenue,
            
	   -- Average monthly revenue
       CASE WHEN total_sales = 0 THEN 0
            ELSE ROUND((total_sales / lifespan_in_months), 2) END AS avg_monthly_revenue
	FROM product_aggregations
ORDER BY 1, 2, 3, 4, 5;