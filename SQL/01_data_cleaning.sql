-- Quick Look At The Data
SELECT TOP 10 * FROM customer_subscriptions;

-- Count The Rows
SELECT COUNT(*) AS Total_rows
FROM customer_subscriptions;

-- Altering Some Columns For the right 
ALTER TABLE customer_subscriptions ALTER COLUMN signup_date DATE;
ALTER TABLE customer_subscriptions ALTER COLUMN gross_mrr FLOAT;
ALTER TABLE customer_subscriptions ALTER COLUMN discount_rate FLOAT;
ALTER TABLE customer_subscriptions ALTER COLUMN net_mrr FLOAT;
ALTER TABLE customer_subscriptions ALTER COLUMN monthly_sessions INT;
ALTER TABLE customer_subscriptions ALTER COLUMN support_tickets_last_90d INT;
ALTER TABLE customer_subscriptions ALTER COLUMN nps_score INT;
ALTER TABLE customer_subscriptions ALTER COLUMN is_churned BIT;
ALTER TABLE customer_subscriptions ALTER COLUMN churn_date DATE;

-- Checking For Duplicates Using CTE
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY customer_id, signup_date, country, device, acquisition_channel, [plan],
gross_mrr, net_mrr, monthly_sessions,
support_tickets_last_90d, nps_score, is_churned, churn_date
ORDER BY customer_id) AS row_num
FROM customer_subscriptions
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT * FROM customer_subscriptions;

-- Creating a new Table to work On
SELECT *
INTO customer_subscriptions_clean
FROM customer_subscriptions;

-- Confirming If everything worked.
SELECT * FROM customer_subscriptions_clean;

-- Checking NULL Values
SELECT *
FROM customer_subscriptions_clean
WHERE customer_id IS NULL
OR signup_date IS NULL
OR [plan] IS NULL
OR net_mrr IS NULL
OR is_churned IS NULL;

-- Churn Logic Validation
SELECT *
FROM customer_subscriptions_clean
WHERE (is_churned = 1 AND churn_date IS NULL)
OR (is_churned = 0 AND churn_date IS NOT NULL);

SELECT *
FROM customer_subscriptions_clean;

-- Value Range Validation

-- NPS Score
SELECT *
FROM customer_subscriptions_clean
WHERE nps_score > 10
OR nps_score < 0;

-- Discount Rate
SELECT *
FROM customer_subscriptions_clean
WHERE discount_rate > 1
OR discount_rate < 0;

-- Revenue Fields
SELECT *
FROM customer_subscriptions_clean
WHERE gross_mrr <= 0
OR net_mrr <= 0
OR net_mrr > gross_mrr;

-- Engagement Metrics
SELECT *
FROM customer_subscriptions_clean
WHERE monthly_sessions < 0
OR support_tickets_last_90d < 0;

-- Standardization

-- Checking Consistency
SELECT DISTINCT LTRIM(RTRIM([plan]))
FROM customer_subscriptions_clean
ORDER BY 1;

SELECT DISTINCT LTRIM(RTRIM(country))
FROM customer_subscriptions_clean
ORDER BY 1;

SELECT DISTINCT LTRIM(RTRIM(device))
FROM customer_subscriptions_clean
ORDER BY 1;

-- Logical Date Validation

SELECT *
FROM customer_subscriptions_clean
WHERE churn_date < signup_date;

SELECT *
FROM customer_subscriptions_clean
WHERE signup_date > GETDATE();