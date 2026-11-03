-- Relational schema: Retail Sales & Inventory (MySQL)
CREATE TABLE IF NOT EXISTS categories (
    category_id  INT PRIMARY KEY,
    name         VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS products (
    product_id     INT PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    category_id    INT NOT NULL,
    unit_price     DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_qty      INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    reorder_level  INT NOT NULL DEFAULT 10,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id  INT PRIMARY KEY,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(120) UNIQUE,
    city         VARCHAR(60),
    joined_on    DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT NOT NULL,
    order_date   DATE NOT NULL,
    status       ENUM('pending','paid','shipped','cancelled') NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_orders_customer (customer_id),
    INDEX idx_orders_date (order_date)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id    INT NOT NULL,
    product_id  INT NOT NULL,
    quantity    INT NOT NULL CHECK (quantity > 0),
    unit_price  DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    INDEX idx_items_product (product_id)
);
