/* CUMULATIVE ANALYSIS */

-- What is the running total of sales over months?

SELECT order_month,
       total_sales,
       SUM(total_sales) OVER(ORDER BY order_month) AS running_total_sales
FROM
(
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
       SUM(sales_amount) AS total_sales
	FROM sales
GROUP BY 1
HAVING order_month IS NOT NULL
ORDER BY 1
) sub;

-- What is the running total of sales over months by year?

SELECT order_year,
       order_month,
       total_sales,
       SUM(total_sales) OVER(PARTITION BY order_year ORDER BY order_month) AS running_total_sales
	FROM
(
  SELECT
    DATE_FORMAT(order_date, '%Y') AS order_year,
    DATE_FORMAT(order_date, '%m') AS order_month,
    SUM(sales_amount) AS total_sales,
    AVG(price) AS avg_price
  FROM sales
  GROUP BY 1, 2
  HAVING order_month IS NOT NULL
) sub
ORDER BY 1,2;
