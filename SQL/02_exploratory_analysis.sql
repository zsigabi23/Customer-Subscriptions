-- Analysis Driven Questions
-- Overall Churn Rate
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean;

-- Average net MRR per customer
SELECT
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS avg_net_mrr
FROM customer_subscriptions_clean;

-- Average NPS score
SELECT
    CAST(AVG(CAST(nps_score AS FLOAT)) AS DECIMAL(10,2)) AS avg_nps
FROM customer_subscriptions_clean;

-- Average Monthly Engagement (sessions)
SELECT
    CAST(AVG(CAST(monthly_sessions AS FLOAT)) AS DECIMAL(10,2)) AS avg_monthly_sessions
FROM customer_subscriptions_clean;

-- Revenue Distribution(low vs high)
SELECT DISTINCT
    MIN(net_mrr) OVER() AS min_net_mrr,
    CAST(AVG(net_mrr) OVER() AS DECIMAL(10,2)) AS avg_net_mrr,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY net_mrr) OVER() AS median_net_mrr,
    MAX(net_mrr) OVER() AS max_net_mrr
FROM customer_subscriptions_clean;

-- Engagement skew check (basic)
SELECT DISTINCT
    MIN(monthly_sessions) OVER() AS min_sessions,
    CAST(AVG(CAST(monthly_sessions AS FLOAT)) OVER() AS DECIMAL(10,2)) AS avg_sessions,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY monthly_sessions) OVER() AS median_sessions,
    MAX(monthly_sessions) OVER() AS max_sessions
FROM customer_subscriptions_clean;

-- NPS distribution check
SELECT
    nps_score,
    COUNT(*) AS customers
FROM customer_subscriptions_clean
GROUP BY nps_score
ORDER BY nps_score;

-- Which Plan Generates The Highest Total Revenue
SELECT
    [plan],
    CAST(SUM(net_mrr) AS DECIMAL(18,2)) AS total_net_mrr,
    COUNT(*) AS customers
FROM customer_subscriptions_clean
GROUP BY [plan]
ORDER BY total_net_mrr DESC;

-- Which plan has highest ARPU(Avg net mrr)
SELECT
    [plan],
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS arpu_net_mrr,
    COUNT(*) AS customers
FROM customer_subscriptions_clean
GROUP BY [plan]
ORDER BY arpu_net_mrr DESC;

-- Which Plan has the highest churn rate?
SELECT
    [plan],
    COUNT(*) AS customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(100.0 * SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY [plan]
ORDER BY churn_rate_pct DESC;

-- Do Premium Customers Churn Less?
SELECT
    [plan],
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY [plan]
ORDER BY churn_rate_pct;

-- Are Higher Discounts Associated With higher Churn
SELECT
    CASE
        WHEN discount_rate = 0 THEN '0%'
        WHEN discount_rate > 0 AND discount_rate <= 0.10 THEN '0-10%'
        WHEN discount_rate > 0.10 AND discount_rate <= 0.20 THEN '10-20%'
        ELSE '20%+'
    END AS discount_band,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct,
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS avg_net_mrr
FROM customer_subscriptions_clean
GROUP BY
    CASE
        WHEN discount_rate = 0 THEN '0%'
        WHEN discount_rate > 0 AND discount_rate <= 0.10 THEN '0-10%'
        WHEN discount_rate > 0.10 AND discount_rate <= 0.20 THEN '10-20%'
        ELSE '20%+'
    END
ORDER BY churn_rate_pct DESC;

-- Do discounted customers generate lower lifetime revenue?
SELECT
    CASE WHEN discount_rate > 0 THEN 'Discounted' ELSE 'Not Discounted' END AS discount_flag,
    COUNT(*) AS customers,
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS avg_net_mrr,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY CASE WHEN discount_rate > 0 THEN 'Discounted' ELSE 'Not Discounted' END
ORDER BY churn_rate_pct DESC;

-- Are certain acquisition channels driving heavy discount usage?
SELECT
    acquisition_channel,
    COUNT(*) AS customers,
    CAST(AVG(discount_rate) AS DECIMAL(10,3)) AS avg_discount_rate,
    CAST(100.0 * AVG(CASE WHEN discount_rate >= 0.20 THEN 1.0 ELSE 0.0 END) AS DECIMAL(10,2)) AS pct_high_discount_20_plus
FROM customer_subscriptions_clean
GROUP BY acquisition_channel
ORDER BY avg_discount_rate DESC;

-- Do churned customers have lower NPS / fewer sessions / more tickets?
SELECT
    is_churned,
    COUNT(*) AS customers,
    CAST(AVG(CAST(nps_score AS FLOAT)) AS DECIMAL(10,2)) AS avg_nps,
    CAST(AVG(CAST(monthly_sessions AS FLOAT)) AS DECIMAL(10,2)) AS avg_sessions,
    CAST(AVG(CAST(support_tickets_last_90d AS FLOAT)) AS DECIMAL(10,2)) AS avg_tickets
FROM customer_subscriptions_clean
GROUP BY is_churned
ORDER BY is_churned DESC;

-- Is churn concentrated in a specific country?
SELECT
    country,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY country
ORDER BY churn_rate_pct DESC;

-- Is churn concentrated in a specific device?
SELECT
    device,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY device
ORDER BY churn_rate_pct DESC;

-- Which acquisition channel has the highest churn?
SELECT
    acquisition_channel,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY acquisition_channel
ORDER BY churn_rate_pct DESC;

-- Are paid users more likely to churn than organic?
SELECT
    CASE
        WHEN acquisition_channel IN ('Paid Search','Paid Social','Partner') THEN 'Paid'
        WHEN acquisition_channel = 'Organic' THEN 'Organic'
        ELSE 'Non-Paid'
    END AS channel_group,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY
    CASE
        WHEN acquisition_channel IN ('Paid Search','Paid Social','Partner') THEN 'Paid'
        WHEN acquisition_channel = 'Organic' THEN 'Organic'
        ELSE 'Non-Paid'
    END
ORDER BY churn_rate_pct DESC;

-- Average tenure before churn (days)
SELECT
    CAST(AVG(CAST(DATEDIFF(DAY, signup_date, churn_date) AS FLOAT)) AS DECIMAL(10,2)) AS avg_tenure_days_before_churn
FROM customer_subscriptions_clean
WHERE is_churned = 1
AND churn_date IS NOT NULL;

-- Early vs late churn (first 90 days)
SELECT
    CASE
        WHEN DATEDIFF(DAY, signup_date, churn_date) <= 90 THEN 'Early (<=90 days)'
        ELSE 'Late (>90 days)'
    END AS churn_timing,
    COUNT(*) AS churned_customers,
    CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER() AS DECIMAL(10,2)) AS pct_of_churned
FROM customer_subscriptions_clean
WHERE is_churned = 1
AND churn_date IS NOT NULL
GROUP BY
    CASE
        WHEN DATEDIFF(DAY, signup_date, churn_date) <= 90 THEN 'Early (<=90 days)'
        ELSE 'Late (>90 days)'
    END
ORDER BY churned_customers DESC;

-- Signup cohort month churn rate
SELECT
    DATEFROMPARTS(YEAR(signup_date), MONTH(signup_date), 1) AS signup_month,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct,
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS avg_net_mrr
FROM customer_subscriptions_clean
GROUP BY DATEFROMPARTS(YEAR(signup_date), MONTH(signup_date), 1)
ORDER BY signup_month;

-- Do high-session users churn less? (sessions bands)
SELECT
    CASE
        WHEN monthly_sessions < 10 THEN 'Low (<10)'
        WHEN monthly_sessions BETWEEN 10 AND 25 THEN 'Medium (10-25)'
        ELSE 'High (26+)'
    END AS sessions_band,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct,
    CAST(AVG(nps_score) AS DECIMAL(10,2)) AS avg_nps
FROM customer_subscriptions_clean
GROUP BY
    CASE
        WHEN monthly_sessions < 10 THEN 'Low (<10)'
        WHEN monthly_sessions BETWEEN 10 AND 25 THEN 'Medium (10-25)'
        ELSE 'High (26+)'
    END
ORDER BY churn_rate_pct DESC;

-- Support tickets risk threshold (tickets bands)
SELECT
    CASE
        WHEN support_tickets_last_90d = 0 THEN '0'
        WHEN support_tickets_last_90d BETWEEN 1 AND 2 THEN '1-2'
        WHEN support_tickets_last_90d BETWEEN 3 AND 5 THEN '3-5'
        ELSE '6+'
    END AS tickets_band,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct,
    CAST(AVG(nps_score) AS DECIMAL(10,2)) AS avg_nps
FROM customer_subscriptions_clean
GROUP BY
    CASE
        WHEN support_tickets_last_90d = 0 THEN '0'
        WHEN support_tickets_last_90d BETWEEN 1 AND 2 THEN '1-2'
        WHEN support_tickets_last_90d BETWEEN 3 AND 5 THEN '3-5'
        ELSE '6+'
    END
ORDER BY churn_rate_pct DESC;

-- Are high-NPS customers raising fewer tickets?
SELECT
    CASE
        WHEN nps_score BETWEEN 0 AND 6 THEN 'Detractors (0-6)'
        WHEN nps_score BETWEEN 7 AND 8 THEN 'Passives (7-8)'
        ELSE 'Promoters (9-10)'
    END AS nps_band,
    COUNT(*) AS customers,
    CAST(AVG(CAST(support_tickets_last_90d AS FLOAT)) AS DECIMAL(10,2)) AS avg_tickets,
    CAST(AVG(CAST(monthly_sessions AS FLOAT)) AS DECIMAL(10,2)) AS avg_sessions
FROM customer_subscriptions_clean
GROUP BY
    CASE
        WHEN nps_score BETWEEN 0 AND 6 THEN 'Detractors (0-6)'
        WHEN nps_score BETWEEN 7 AND 8 THEN 'Passives (7-8)'
        ELSE 'Promoters (9-10)'
    END
ORDER BY avg_tickets DESC;

-- Churn rate by NPS band (06, 78, 910)
SELECT
    CASE
        WHEN nps_score BETWEEN 0 AND 6 THEN '0-6'
        WHEN nps_score BETWEEN 7 AND 8 THEN '7-8'
        ELSE '9-10'
    END AS nps_band,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY
    CASE
        WHEN nps_score BETWEEN 0 AND 6 THEN '0-6'
        WHEN nps_score BETWEEN 7 AND 8 THEN '7-8'
        ELSE '9-10'
    END
ORDER BY churn_rate_pct DESC;

-- Does NPS vary by plan?
SELECT
    [plan],
    COUNT(*) AS customers,
    CAST(AVG(CAST(nps_score AS FLOAT)) AS DECIMAL(10,2)) AS avg_nps
FROM customer_subscriptions_clean
GROUP BY [plan]
ORDER BY avg_nps DESC;

-- Does NPS vary by acquisition channel?
SELECT
    acquisition_channel,
    COUNT(*) AS customers,
    CAST(AVG(CAST(nps_score AS FLOAT)) AS DECIMAL(10,2)) AS avg_nps
FROM customer_subscriptions_clean
GROUP BY acquisition_channel
ORDER BY avg_nps DESC;

-- Which country has the highest churn?
SELECT TOP 10
    country,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY country
ORDER BY churn_rate_pct DESC;

-- Which country generates the most revenue?
SELECT TOP 10
    country,
    CAST(SUM(net_mrr) AS DECIMAL(18,2)) AS total_net_mrr,
    COUNT(*) AS customers
FROM customer_subscriptions_clean
GROUP BY country
ORDER BY total_net_mrr DESC;

-- Do mobile users churn more?
SELECT
    device,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY device
ORDER BY churn_rate_pct DESC;

-- Correlation: churn vs NPS
SELECT
    CAST(
        (AVG(CAST(is_churned AS FLOAT) * CAST(nps_score AS FLOAT)) 
        - AVG(CAST(is_churned AS FLOAT)) * AVG(CAST(nps_score AS FLOAT)))
        /
        NULLIF(
            (STDEV(CAST(is_churned AS FLOAT)) * STDEV(CAST(nps_score AS FLOAT)))
        ,0)
    AS DECIMAL(10,4)) AS corr_churn_nps
FROM customer_subscriptions_clean;

-- Correlation: churn vs sessions
SELECT
    CAST(
        (AVG(CAST(is_churned AS FLOAT) * CAST(monthly_sessions AS FLOAT)) 
        - AVG(CAST(is_churned AS FLOAT)) * AVG(CAST(monthly_sessions AS FLOAT)))
        /
        NULLIF(
            (STDEV(CAST(is_churned AS FLOAT)) * STDEV(CAST(monthly_sessions AS FLOAT)))
        ,0)
    AS DECIMAL(10,4)) AS corr_churn_sessions
FROM customer_subscriptions_clean;

-- Correlation: discount vs tickets
SELECT
    CAST(
        (AVG(CAST(discount_rate AS FLOAT) * CAST(support_tickets_last_90d AS FLOAT)) 
        - AVG(CAST(discount_rate AS FLOAT)) * AVG(CAST(support_tickets_last_90d AS FLOAT)))
        /
        NULLIF(
            (STDEV(CAST(discount_rate AS FLOAT)) * STDEV(CAST(support_tickets_last_90d AS FLOAT)))
        ,0)
    AS DECIMAL(10,4)) AS corr_discount_tickets
FROM customer_subscriptions_clean;