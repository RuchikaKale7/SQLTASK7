CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    region_code VARCHAR(50),
    state_id INT,
    product_id INT,
    item_quantity INT,
    item_discount DECIMAL(5, 2),
    order_profit DECIMAL(10, 2),
    order_revenue DECIMAL(10, 2),
    order_date DATE
);


-- Create the regions table
CREATE TABLE regions (
    region_code VARCHAR(50) PRIMARY KEY,
    region_name VARCHAR(100)
);

-- Create the products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_title VARCHAR(255)
);

-- Create the states table
CREATE TABLE states (
    state_id SERIAL PRIMARY KEY,
    state_name VARCHAR(100)
);

-- Create the customers table
CREATE TABLE customers (
    cust_id SERIAL PRIMARY KEY,
    cust_name VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100),
    age INT
);

-- Create the order_customers table
CREATE TABLE order_customers (
    order_id INT,
    cust_id INT,
    PRIMARY KEY (order_id, cust_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
);
------ What is the total revenue and average order discount for each region for the year 2019?


--orders: order_id, region_code, item_quantity, item_discount, order_profit, order_revenue, order_date
--regions: region_code, region_name
select * from orders as s
SELECT
    r.region_name,
    SUM(o.order_revenue) AS total_revenue,
    AVG(o.item_discount) AS average_order_discount
FROM orders o
INNER JOIN regions r
    ON o.region_code = r.region_code
WHERE o.order_date BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY r.region_name;

-----Find the top 3 products with the highest total revenue in each state for the year 2020.


--orders: order_id, state_id, product_id, item_quantity, item_discount, order_profit, order_revenue, order_date
--products: product_id, product_title
--states: state_id, state_name

SELECT
    st.state_name,
    p.product_title,
    SUM(o.order_revenue) AS total_revenue
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id
INNER JOIN states st
    ON o.state_id = st.state_id
WHERE o.order_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY st.state_name, p.product_title
ORDER BY st.state_name, total_revenue DESC
LIMIT 3;

----- Calculate the average number of items sold and total profit generated per customer in the year 2021.


--orders: order_id, item_quantity, item_discount, order_profit, order_revenue, order_date
--customers: cust_id, cust_name, state, city, age
--order_customers: order_id, cust_id

SELECT
    c.cust_name,
    AVG(o.item_quantity) AS average_items_sold,
    SUM(o.order_profit) AS total_profit
FROM orders o
INNER JOIN order_customers oc
    ON o.order_id = oc.order_id
INNER JOIN customers c
    ON oc.cust_id = c.cust_id
WHERE o.order_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY c.cust_name;


-----List the product titles and their total quantity sold for each customer age group (grouped by age range) for the year 2019.

--orders: order_id, product_id, item_quantity, item_discount, order_profit, order_revenue, order_date
--customers: cust_id, cust_name, state, city, age
--order_customers: order_id, cust_id
--products: product_id, product_title

SELECT
    p.product_title,
    CASE 
        WHEN c.age BETWEEN 18 AND 25 THEN '18-25'
        WHEN c.age BETWEEN 26 AND 35 THEN '26-35'
        WHEN c.age BETWEEN 36 AND 45 THEN '36-45'
        WHEN c.age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
    SUM(o.item_quantity) AS total_quantity
FROM orders o
INNER JOIN order_customers oc
    ON o.order_id = oc.order_id
INNER JOIN customers c
    ON oc.cust_id = c.cust_id
INNER JOIN products p
    ON o.product_id = p.product_id
WHERE o.order_date BETWEEN '2019-01-01' AND '2019-12-31'
GROUP BY p.product_title, age_group;