-- Running Totals Analysis using ROWS vs RANGE Frame Specifications  
-- Use case: Compare cumulative sales using different frame types for cash flow monitoring
-- Window Functions: SUM() with ROWS and RANGE frames to show different accumulation methods

SELECT 
    t.sale_date,
    t.total_amount,
    -- Running total using ROWS frame (accumulates individual records sequentially)
    SUM(t.total_amount) OVER (
        ORDER BY t.sale_date
        ROWS UNBOUNDED PRECEDING
    ) as running_total_rows,
    -- Running total using RANGE frame (accumulates based on date values, handles ties)
    SUM(t.total_amount) OVER (
        ORDER BY t.sale_date
        RANGE UNBOUNDED PRECEDING
    ) as running_total_range
FROM transactions t
ORDER BY t.sale_date;