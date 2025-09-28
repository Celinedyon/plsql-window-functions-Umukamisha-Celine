-- Customer Metrics Analysis with Distribution Functions
-- Use case: Comprehensive customer segmentation using NTILE and CUME_DIST
-- Window Functions: NTILE(4), CUME_DIST(), aggregation with OVER()

WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        c.region,
        c.baby_age_months,
        SUM(t.total_amount) as total_spent,
        COUNT(t.transaction_id) as frequency,
        AVG(t.total_amount) as avg_transaction
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    GROUP BY c.customer_id, c.customer_name, c.region, c.baby_age_months
)
SELECT 
    customer_name,
    region,
    baby_age_months,
    frequency,
    ROUND(avg_transaction::numeric, 2) as avg_transaction,
    NTILE(4) OVER (ORDER BY total_spent) as spending_quartile,
    NTILE(4) OVER (ORDER BY frequency) as frequency_quartile,
    ROUND(CUME_DIST() OVER (ORDER BY total_spent)::numeric, 3) as spending_percentile,
    ROUND(CUME_DIST() OVER (ORDER BY frequency)::numeric, 3) as frequency_percentile
FROM customer_metrics
ORDER BY total_spent DESC;