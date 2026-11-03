INSERT IGNORE INTO categories VALUES (1,'Stationery'),(2,'Electronics'),(3,'Books');

INSERT IGNORE INTO products VALUES
 (1,'A4 Notebook',1,25.00,120,20),
 (2,'Ballpoint Pens (10)',1,30.00,8,15),
 (3,'USB Flash Drive 32GB',2,120.00,45,10),
 (4,'Scientific Calculator',2,260.00,6,8),
 (5,'SQL Fundamentals',3,350.00,18,5),
 (6,'Python for Beginners',3,320.00,25,5);

INSERT IGNORE INTO customers VALUES
 (1,'Thabo Mokoena','thabo@example.com','Cape Town','2025-11-02'),
 (2,'Ayesha Davids','ayesha@example.com','Johannesburg','2025-12-15'),
 (3,'Sipho Ndlovu','sipho@example.com','Durban','2026-01-20'),
 (4,'Lerato Khumalo','lerato@example.com','Cape Town','2026-02-08');

INSERT IGNORE INTO orders VALUES
 (1,1,'2026-01-05','shipped'),
 (2,2,'2026-01-18','shipped'),
 (3,1,'2026-02-02','paid'),
 (4,3,'2026-02-14','shipped'),
 (5,4,'2026-03-01','pending'),
 (6,2,'2026-03-09','cancelled');

INSERT IGNORE INTO order_items VALUES
 (1,1,10,25.00),(1,2,5,30.00),
 (2,5,1,350.00),(2,3,2,120.00),
 (3,4,1,260.00),(3,6,2,320.00),
 (4,3,3,120.00),(4,1,20,25.00),
 (5,5,2,350.00),
 (6,4,1,260.00);
