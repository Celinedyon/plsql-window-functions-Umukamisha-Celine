-- Customer Purchase Pattern Analysis using LAG and LEAD
-- Use case: Analyze customer purchase frequency and intervals for retention strategies
-- Window Functions: LAG() and LEAD() to calculate days between purchases

SELECT 
    c.customer_name,
    c.region,
    t.sale_date,
    t.total_amount,
    -- Get previous purchase date for each customer
    LAG(t.sale_date, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.sale_date
    ) as previous_purchase,
    -- Get next purchase date for each customer
    LEAD(t.sale_date, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.sale_date
    ) as next_purchase,
    -- Calculate days since last purchase
    t.sale_date - LAG(t.sale_date, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.sale_date
    ) as days_since_last,
    -- Calculate days until next purchase
    LEAD(t.sale_date, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.sale_date
    ) - t.sale_date as days_until_next
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
ORDER BY c.customer_name, t.sale_date;