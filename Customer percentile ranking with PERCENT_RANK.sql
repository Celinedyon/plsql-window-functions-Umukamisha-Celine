-- Customer Percentile Ranking using PERCENT_RANK
-- Use case: Create precise percentile-based customer segments for marketing campaigns
-- Window Function: PERCENT_RANK() to calculate relative position (0 to 1) within customer base

SELECT 
    c.customer_name,
    c.region,
    SUM(t.total_amount) as total_spent,
    -- Calculate percentile rank (0 = lowest, 1 = highest)
    PERCENT_RANK() OVER (ORDER BY SUM(t.total_amount) DESC) as percentile_rank,
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY SUM(t.total_amount) DESC) <= 0.25 THEN 'Top 25%'
        WHEN PERCENT_RANK() OVER (ORDER BY SUM(t.total_amount) DESC) <= 0.50 THEN 'Top 50%' 
        WHEN PERCENT_RANK() OVER (ORDER BY SUM(t.total_amount) DESC) <= 0.75 THEN 'Top 75%'
        ELSE 'Bottom 25%'
    END as customer_segment
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.customer_id, c.customer_name, c.region
ORDER BY total_spent DESC;