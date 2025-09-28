-- Customer Next Purchase Analysis using LEAD Function
-- Use case: Forward-looking analysis to predict customer purchase timing
-- Window Function: LEAD() to identify next purchase date and calculate intervals

SELECT 
    c.customer_name,
    t.sale_date,
    t.total_amount,
    -- Get next purchase date for each customer
    LEAD(t.sale_date, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.sale_date
    ) as next_purchase_date,
    -- Calculate days until next purchase
    LEAD(t.sale_date, 1) OVER (
        PARTITION BY c.customer_id 
        ORDER BY t.sale_date
    ) - t.sale_date as days_until_next_purchase
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
ORDER BY c.customer_name, t.sale_date;