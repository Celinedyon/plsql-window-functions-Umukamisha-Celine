-- Product Ranking Analysis using RANK and DENSE_RANK Functions
-- Use case: Rank products by sales volume handling ties appropriately for inventory decisions
-- Window Functions: RANK() skips ranks after ties, DENSE_RANK() maintains consecutive ranking

SELECT 
    p.product_name,
    p.category,
    SUM(t.quantity) as total_sold,
    -- RANK() gives same rank to tied values and skips subsequent ranks
    RANK() OVER (ORDER BY SUM(t.quantity) DESC) as product_rank,
    -- DENSE_RANK() gives same rank to tied values but doesn't skip ranks
    DENSE_RANK() OVER (ORDER BY SUM(t.quantity) DESC) as dense_rank
FROM products p
JOIN transactions t ON p.product_id = t.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_sold DESC;