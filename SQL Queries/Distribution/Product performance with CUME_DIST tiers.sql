-- Product Performance Analysis using CUME_DIST
-- Use case: Identify top performing products by revenue and quantity percentiles
-- Window Function: CUME_DIST() for percentile ranking and performance tiers

SELECT 
    p.product_name,
    p.category,
    SUM(t.total_amount) as total_revenue,
    SUM(t.quantity) as total_quantity,
    CUME_DIST() OVER (ORDER BY SUM(t.total_amount)) as revenue_percentile,
    CUME_DIST() OVER (ORDER BY SUM(t.quantity)) as quantity_percentile,
    CASE 
        WHEN CUME_DIST() OVER (ORDER BY SUM(t.total_amount)) >= 0.8 THEN 'Top 20%'
        WHEN CUME_DIST() OVER (ORDER BY SUM(t.total_amount)) >= 0.6 THEN 'Top 40%' 
        WHEN CUME_DIST() OVER (ORDER BY SUM(t.total_amount)) >= 0.4 THEN 'Middle 40%'
        ELSE 'Bottom 40%'
    END as performance_tier
FROM products p
JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;