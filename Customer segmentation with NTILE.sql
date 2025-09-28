-- Customer Segmentation using NTILE for Marketing Campaigns
-- Use case: Divide customers into spending quartiles for targeted marketing
-- Window Function: NTILE(4) to create equal-sized customer segments

SELECT 
    c.customer_name,
    c.region,
    SUM(t.total_amount) as total_spent,
    COUNT(t.transaction_id) as transaction_count,
    NTILE(4) OVER (ORDER BY SUM(t.total_amount)) as spending_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY SUM(t.total_amount)) = 4 THEN 'Premium Customer'
        WHEN NTILE(4) OVER (ORDER BY SUM(t.total_amount)) = 3 THEN 'High Value'
        WHEN NTILE(4) OVER (ORDER BY SUM(t.total_amount)) = 2 THEN 'Medium Value'
        ELSE 'Entry Level'
    END as customer_segment
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name, c.region
ORDER BY total_spent DESC;