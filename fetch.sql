-- Using PostgreSQL dialect

-- 1. What are the top 5 brands by receipts scanned for most recent month?
WITH recent_month AS (
    SELECT 
        DATE_TRUNC('month', MAX(date_scanned)) AS max_month
    FROM receipts
)
SELECT 
    b.name AS brand_name,
    COUNT(DISTINCT r.receipt_id) AS receipt_count
FROM receipt_items ri
JOIN receipts r ON ri.receipt_id = r.receipt_id
JOIN brands b ON ri.brand_id = b.brand_id
WHERE DATE_TRUNC('month', r.date_scanned) = (SELECT max_month FROM recent_month)
GROUP BY b.name
ORDER BY receipt_count DESC
LIMIT 5;

-- 2. How does the ranking of the top 5 brands by receipts scanned for the recent month 
-- compare to the ranking for the previous month?
WITH months AS (
    SELECT 
        DATE_TRUNC('month', MAX(date_scanned)) AS recent_month,
        DATE_TRUNC('month', MAX(date_scanned) - INTERVAL '1 month') AS previous_month
    FROM receipts
),
recent_month_data AS (
    SELECT 
        b.name AS brand_name,
        COUNT(DISTINCT r.receipt_id) AS receipt_count,
        RANK() OVER (ORDER BY COUNT(DISTINCT r.receipt_id) DESC) AS rank
    FROM receipt_items ri
    JOIN receipts r ON ri.receipt_id = r.receipt_id
    JOIN brands b ON ri.brand_id = b.brand_id
    WHERE DATE_TRUNC('month', r.date_scanned) = (SELECT recent_month FROM months)
    GROUP BY b.name
),
previous_month_data AS (
    SELECT 
        b.name AS brand_name,
        COUNT(DISTINCT r.receipt_id) AS receipt_count,
        RANK() OVER (ORDER BY COUNT(DISTINCT r.receipt_id) DESC) AS rank
    FROM receipt_items ri
    JOIN receipts r ON ri.receipt_id = r.receipt_id
    JOIN brands b ON ri.brand_id = b.brand_id
    WHERE DATE_TRUNC('month', r.date_scanned) = (SELECT previous_month FROM months)
    GROUP BY b.name
)
SELECT 
    r.brand_name,
    r.receipt_count AS recent_month_count,
    r.rank AS recent_month_rank,
    p.receipt_count AS previous_month_count,
    p.rank AS previous_month_rank,
    p.rank - r.rank AS rank_change
FROM recent_month_data r
LEFT JOIN previous_month_data p ON r.brand_name = p.brand_name
WHERE r.rank <= 5
ORDER BY r.rank;

-- 3. When considering average spend from receipts with 'rewardsReceiptStatus' of 'Accepted' or 'Rejected', which is greater?
SELECT 
    status,
    AVG(total_spent) AS average_spend
FROM receipts
WHERE status IN ('Accepted', 'Rejected')
GROUP BY status
ORDER BY average_spend DESC;

-- 4. When considering total number of items purchased from receipts with 'rewardsReceiptStatus' of 'Accepted' or 'Rejected', which is greater?
SELECT 
    status,
    SUM(purchased_item_count) AS total_items_purchased
FROM receipts
WHERE status IN ('Accepted', 'Rejected')
GROUP BY status
ORDER BY total_items_purchased DESC;

-- 5. Which brand has the most spend among users who were created within the past 6 months?
WITH recent_users AS (
    SELECT user_id
    FROM users
    WHERE created_date >= CURRENT_DATE - INTERVAL '6 months'
)
SELECT 
    b.name AS brand_name,
    SUM(ri.price * ri.quantity) AS total_spend
FROM receipt_items ri
JOIN receipts r ON ri.receipt_id = r.receipt_id
JOIN brands b ON ri.brand_id = b.brand_id
WHERE r.user_id IN (SELECT user_id FROM recent_users)
GROUP BY b.name
ORDER BY total_spend DESC
LIMIT 1;

-- 6. Which brand has the most transactions among users who were created within the past 6 months?
WITH recent_users AS (
    SELECT user_id
    FROM users
    WHERE created_date >= CURRENT_DATE - INTERVAL '6 months'
)
SELECT 
    b.name AS brand_name,
    COUNT(DISTINCT r.receipt_id) AS transaction_count
FROM receipt_items ri
JOIN receipts r ON ri.receipt_id = r.receipt_id
JOIN brands b ON ri.brand_id = b.brand_id
WHERE r.user_id IN (SELECT user_id FROM recent_users)
GROUP BY b.name
ORDER BY transaction_count DESC
LIMIT 1;