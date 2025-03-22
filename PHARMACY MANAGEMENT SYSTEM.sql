CREATE DATABASE pharmacy_management_system;
USE pharmacy_management_system;
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL, -- Pharmacist, Admin, etc.
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE ProductCategories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) UNIQUE NOT NULL
);
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT NOT NULL,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES ProductCategories(category_id)
);
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    phone_number VARCHAR(15),
    email VARCHAR(255) UNIQUE,
    address TEXT
);
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    total_price DECIMAL(10, 2) AS (quantity * unit_price) STORED,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
INSERT INTO ProductCategories (category_name)
VALUES ('Antibiotics'), 
       ('Painkillers'), 
       ('Vitamins'), 
       ('Antihistamines'), 
       ('Antacids');
 INSERT INTO Products (name, description, price, stock_quantity, category_id)
VALUES ('Paracetamol', 'Pain relief medication', 5.99, 100, 2),
       ('Aspirin', 'Anti-inflammatory drug', 7.49, 50, 2),
       ('Vitamin C', 'Vitamin supplement', 2.99, 200, 3),
       ('Amoxicillin', 'Antibiotic', 12.99, 80, 1),
       ('Loratadine', 'Antihistamine', 10.99, 120, 4);      
 INSERT INTO Customers (first_name, last_name, phone_number, email, address)
VALUES ('John', 'Doe', '1234567890', 'john.doe@example.com', '123 Main St'),
       ('Jane', 'Smith', '0987654321', 'jane.smith@example.com', '456 Elm St');    
 INSERT INTO Orders (customer_id, order_date, status, total_amount)
VALUES (1, '2025-03-22 10:00:00', 'Completed', 30.97),
       (2, '2025-03-22 11:00:00', 'Pending', 22.98);      
 INSERT INTO OrderItems (order_id, product_id, quantity, unit_price)
VALUES (1, 1, 2, 5.99),  -- Paracetamol
       (1, 4, 1, 12.99), -- Amoxicillin
       (2, 2, 1, 7.49),  -- Aspirin
       (2, 3, 3, 2.99);  -- Vitamin C      
INSERT INTO Payments (order_id, payment_amount, payment_method, payment_status)
VALUES (1, 30.97, 'Credit Card', 'Completed'),
       (2, 22.98, 'Cash', 'Pending');      
SELECT p.name AS product_name, SUM(oi.quantity) AS total_sold
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC
LIMIT 5;       
 SELECT p.name AS product_name,
       SUM(oi.quantity) AS quantity_sold,
       p.stock_quantity AS current_inventory,
       (SUM(oi.quantity) / p.stock_quantity) AS turnover_rate
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_id;      

