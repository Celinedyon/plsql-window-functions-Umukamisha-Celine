-- Regional MIN and MAX Analysis with Window Functions
-- Use case: Track minimum and maximum transaction amounts within each region over time
-- Window Functions: MIN() and MAX() with PARTITION BY for regional analysis

SELECT 
    t.sale_date,
    t.total_amount,
    c.region,
    -- Minimum transaction amount within each region so far (cumulative)
    MIN(t.total_amount) OVER (
        PARTITION BY c.region 
        ORDER BY t.sale_date
        ROWS UNBOUNDED PRECEDING
    ) as regional_min_so_far,
    -- Maximum transaction amount within each region so far (cumulative)
    MAX(t.total_amount) OVER (
        PARTITION BY c.region 
        ORDER BY t.sale_date
        ROWS UNBOUNDED PRECEDING
    ) as regional_max_so_far
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
ORDER BY c.region, t.sale_date;