-- 1. Order history for customer 1 (change the id as needed)
SELECT o.order_id, o.order_date, o.status, p.name AS product,
       oi.quantity, oi.unit_price, oi.quantity * oi.unit_price AS line_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p     ON p.product_id = oi.product_id
WHERE o.customer_id = 1
ORDER BY o.order_date;

-- 2. Products that need restocking
SELECT name, stock_qty, reorder_level
FROM products
WHERE stock_qty <= reorder_level
ORDER BY stock_qty;

-- 3. Customers who have never placed an order
SELECT cu.customer_id, cu.full_name
FROM customers cu
LEFT JOIN orders o ON o.customer_id = cu.customer_id
WHERE o.order_id IS NULL;

-- 4. Customers in Cape Town with their order count
SELECT cu.full_name, COUNT(o.order_id) AS orders
FROM customers cu
LEFT JOIN orders o ON o.customer_id = cu.customer_id
WHERE cu.city = 'Cape Town'
GROUP BY cu.customer_id, cu.full_name;
