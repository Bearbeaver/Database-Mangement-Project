-- 1. Monthly revenue (excludes cancelled orders)
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS month,
       COUNT(DISTINCT o.order_id)         AS orders,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status <> 'cancelled'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

-- 2. Revenue by product category
SELECT c.name AS category,
       SUM(oi.quantity)                           AS units_sold,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM order_items oi
JOIN orders o     ON o.order_id = oi.order_id AND o.status <> 'cancelled'
JOIN products p   ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id
GROUP BY c.category_id, c.name
ORDER BY revenue DESC;

-- 3. Top 3 customers by lifetime spend
SELECT cu.full_name, cu.city,
       ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spent
FROM customers cu
JOIN orders o       ON o.customer_id = cu.customer_id AND o.status <> 'cancelled'
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY cu.customer_id, cu.full_name, cu.city
ORDER BY total_spent DESC
LIMIT 3;

-- 4. Best-selling products (ranked)
SELECT RANK() OVER (ORDER BY SUM(oi.quantity) DESC) AS ranking,
       p.name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN orders o   ON o.order_id = oi.order_id AND o.status <> 'cancelled'
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY ranking;
