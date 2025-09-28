-- Monthly Sales Growth Analysis using LAG Function
-- Use case: Calculate month-over-month growth percentages for trend analysis
-- Window Function: LAG() to access previous month's revenue for growth calculation

WITH monthly_sales AS (
    SELECT 
        DATE_TRUNC('month', sale_date) as month,
        SUM(total_amount) as monthly_revenue
    FROM transactions
    GROUP BY DATE_TRUNC('month', sale_date)
)
SELECT 
    month,
    monthly_revenue,
    LAG(monthly_revenue, 1) OVER (ORDER BY month) as previous_month,
    CASE 
        WHEN LAG(monthly_revenue, 1) OVER (ORDER BY month) IS NOT NULL
        THEN ROUND(
            ((monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY month)) * 100.0 / 
             LAG(monthly_revenue, 1) OVER (ORDER BY month)), 2
        )
        ELSE NULL
    END as mom_growth_percent
FROM monthly_sales
ORDER BY month;