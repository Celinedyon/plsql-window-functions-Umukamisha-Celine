-- Top Customers by Revenue using ROW_NUMBER Function
-- Use case: Identify top N customers by total revenue for VIP program enrollment
-- Window Function: ROW_NUMBER() assigns unique sequential ranks without ties

SELECT 
    c.customer_name,
    c.region,
    SUM(t.total_amount) as total_revenue,
    -- ROW_NUMBER() assigns unique sequential numbers (1, 2, 3...) even for tied values
    ROW_NUMBER() OVER (ORDER BY SUM(t.total_amount) DESC) as customer_rank
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name, c.region
ORDER BY customer_rank
LIMIT 10;