-- Sample Data Insertion for Celine Baby Shop Database
-- Purpose: Insert realistic sample data into all tables for testing and analysis
-- Order: customers first, then products, then transactions (due to foreign key constraints)

-- Insert sample customers across different regions in Rwanda
INSERT INTO customers (customer_id, customer_name, phone, region, registration_date, baby_age_months) VALUES
(1001, 'Umukamisha', '0788123456', 'Kigali', '2024-01-15', 8),
(1002, 'Uwizeye', '0788234567', 'Huye', '2024-02-10', 3),
(1003, 'Igiraneza', '0788345678', 'Musanze', '2024-01-20', 12);

-- Insert sample baby products with different categories and price ranges
INSERT INTO products (product_id, product_name, category, brand, unit_price, age_group) VALUES
(2001, 'Baby Onesie Set', 'Clothing', 'Carters', 15000, '0-6months'),
(2002, 'Soft Plush Toy', 'Toys', 'Fisher-Price', 8000, '6-12months'),
(2003, 'Baby Formula', 'Feeding', 'Similac', 25000, 'Newborn');

-- Insert sample transactions linking customers and products
INSERT INTO transactions (transaction_id, customer_id, product_id, sale_date, quantity, total_amount, store_location) VALUES
(3001, 1001, 2001, '2024-03-10', 2, 30000, 'Kigali Downtown'),
(3002, 1002, 2003, '2024-03-15', 1, 25000, 'Huye Center'),
(3003, 1003, 2002, '2024-04-05', 3, 24000, 'Musanze Golfco Plaza');