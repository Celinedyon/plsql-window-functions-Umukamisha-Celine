-- Moving Averages Analysis using ROWS vs RANGE Frame Specifications
-- Use case: Smooth out daily transaction volatility with 3-transaction and date-based averages
-- Window Functions: AVG() with ROWS BETWEEN and RANGE BETWEEN for different frame types

SELECT 
    t.sale_date,
    t.total_amount,
    -- 3-transaction moving average using ROWS frame (processes fixed number of records)
    AVG(t.total_amount) OVER (
        ORDER BY t.sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as three_transaction_avg,
    -- Date-based moving average using RANGE frame (processes based on date values)
    AVG(t.total_amount) OVER (
        ORDER BY t.sale_date
        RANGE BETWEEN INTERVAL '2' DAY PRECEDING AND CURRENT ROW
    ) as three_day_avg
FROM transactions t
ORDER BY t.sale_date;