-- Regional Performance Summary with Multiple Window Functions
-- Use case: Comprehensive regional analysis combining customer count, revenue, ranking and percentiles
-- Window Functions: COUNT(DISTINCT), SUM(), RANK(), NTILE(3), CUME_DIST() for complete regional insights

SELECT 
    c.region,
    COUNT(DISTINCT c.customer_id) as customers,
    COUNT(t.transaction_id) as transactions,
    SUM(t.total_amount) as total_revenue,
    -- Rank regions by total revenue (1 = highest revenue)
    RANK() OVER (ORDER BY SUM(t.total_amount) DESC) as revenue_rank,
    -- Cumulative revenue running total across all regions
    SUM(SUM(t.total_amount)) OVER (
        ORDER BY SUM(t.total_amount) DESC
        ROWS UNBOUNDED PRECEDING
    ) as cumulative_revenue,
    -- Divide regions into performance tiers (1=top, 3=bottom)
    NTILE(3) OVER (ORDER BY SUM(t.total_amount)) as performance_tier,
    -- Calculate percentile position of each region
    ROUND(CUME_DIST() OVER (ORDER BY SUM(t.total_amount))::numeric, 3) as percentile
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
GROUP BY c.region
ORDER BY total_revenue DESC;