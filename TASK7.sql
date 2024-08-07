select * from sales

select * from customer

select * from sales_customer

-- 1) create a report of all state sales, quantity, discount , profit  with following aggregation ,
-- sum , avg, min , max, count	


SELECT sc.customer_id,s.state,SUM(s.sales) AS total_sales,AVG(s.sales) AS average_sales, MIN(s.quantity) AS min_quantity, MAX(s.discount) AS max_discount, COUNT(s.profit) AS profit_count
FROM sales s
INNER JOIN sales_customers sc
    ON s.sale_id = sc.sale_id
INNER JOIN customers c
    ON sc.customer_id = c.customer_id
GROUP BY sc.customer_id, s.state;


--2) get data of all state & city's average customer age 

SELECT s.state,s.city,AVG(c.age) AS average_age FROM sales s
INNER JOIN customers c
    ON s.state = c.state
    AND s.city = c.city
GROUP BY s.state, s.city;


--3) get data of 2017 and 2018 with product name & sales per quantity

SELECT
    s.product_name,
    SUM(s.quantity) AS total_quantity,
    SUM(s.sales) AS total_sales,
    SUM(s.sales) / SUM(s.quantity) AS sales_per_quantity
FROM sales s
WHERE s.sale_date BETWEEN '2017-01-01' AND '2018-12-31'
GROUP BY s.product_name;
