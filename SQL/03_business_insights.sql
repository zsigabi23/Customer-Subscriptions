-- Business & Strategic Insights
-- Define high-risk profile (Low NPS + Low Sessions + High Tickets) and measure it
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN nps_score <= 6 AND monthly_sessions < 10 AND support_tickets_last_90d >= 3 THEN 1 ELSE 0 END) AS high_risk_customers,
    CAST(100.0 * SUM(CASE WHEN nps_score <= 6 AND monthly_sessions < 10 AND support_tickets_last_90d >= 3 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(10,2)) AS high_risk_pct
FROM customer_subscriptions_clean;

-- What % of revenue comes from high-risk customers?
SELECT
    CAST(SUM(net_mrr) AS DECIMAL(18,2)) AS total_net_mrr,
    CAST(SUM(CASE WHEN nps_score <= 6 AND monthly_sessions < 10 AND support_tickets_last_90d >= 3 THEN net_mrr ELSE 0 END) AS DECIMAL(18,2)) AS high_risk_net_mrr,
    CAST(
        100.0 * SUM(CASE WHEN nps_score <= 6 AND monthly_sessions < 10 AND support_tickets_last_90d >= 3 THEN net_mrr ELSE 0 END)
        / NULLIF(SUM(net_mrr),0)
    AS DECIMAL(10,2)) AS pct_revenue_high_risk
FROM customer_subscriptions_clean;

-- If churn reduced by 5%, how much net MRR is saved? (simple proxy)
SELECT
    CAST(SUM(CASE WHEN is_churned = 1 THEN net_mrr ELSE 0 END) AS DECIMAL(18,2)) AS churned_net_mrr,
    CAST(0.05 * SUM(CASE WHEN is_churned = 1 THEN net_mrr ELSE 0 END) AS DECIMAL(18,2)) AS mrr_saved_if_churn_reduced_5pct
FROM customer_subscriptions_clean;

-- Are churn rates improving over signup months?
SELECT
    DATEFROMPARTS(YEAR(signup_date), MONTH(signup_date), 1) AS signup_month,
    COUNT(*) AS customers,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct,
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS avg_net_mrr
FROM customer_subscriptions_clean
GROUP BY DATEFROMPARTS(YEAR(signup_date), MONTH(signup_date), 1)
ORDER BY signup_month;

-- Do newer customers behave differently? (recent vs older signups)
SELECT
    CASE
        WHEN signup_date >= DATEADD(MONTH, -6, GETDATE()) THEN 'Last 6 months'
        ELSE 'Older than 6 months'
    END AS cohort_group,
    COUNT(*) AS customers,
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS avg_net_mrr,
    CAST(AVG(CAST(monthly_sessions AS FLOAT)) AS DECIMAL(10,2)) AS avg_sessions,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY
    CASE
        WHEN signup_date >= DATEADD(MONTH, -6, GETDATE()) THEN 'Last 6 months'
        ELSE 'Older than 6 months'
    END;

-- Which acquisition channels bring highest-quality customers? (low churn + high NPS + high MRR)
SELECT
    acquisition_channel,
    COUNT(*) AS customers,
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS avg_net_mrr,
    CAST(AVG(CAST(nps_score AS FLOAT)) AS DECIMAL(10,2)) AS avg_nps,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY acquisition_channel
ORDER BY churn_rate_pct ASC, avg_nps DESC, avg_net_mrr DESC;

-- Where should we invest (product vs marketing)? (channels with high churn + high discount)
SELECT
    acquisition_channel,
    COUNT(*) AS customers,
    CAST(AVG(discount_rate) AS DECIMAL(10,3)) AS avg_discount_rate,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY acquisition_channel
ORDER BY churn_rate_pct DESC, avg_discount_rate DESC;

-- Should we reduce discounts? (compare churn and NPS by discount band)
SELECT
    CASE
        WHEN discount_rate = 0 THEN '0%'
        WHEN discount_rate > 0 AND discount_rate <= 0.10 THEN '0-10%'
        WHEN discount_rate > 0.10 AND discount_rate <= 0.20 THEN '10-20%'
        ELSE '20%+'
    END AS discount_band,
    COUNT(*) AS customers,
    CAST(AVG(net_mrr) AS DECIMAL(10,2)) AS avg_net_mrr,
    CAST(AVG(CAST(nps_score AS FLOAT)) AS DECIMAL(10,2)) AS avg_nps,
    CAST(100.0 * AVG(CAST(is_churned AS FLOAT)) AS DECIMAL(10,2)) AS churn_rate_pct
FROM customer_subscriptions_clean
GROUP BY
    CASE
        WHEN discount_rate = 0 THEN '0%'
        WHEN discount_rate > 0 AND discount_rate <= 0.10 THEN '0-10%'
        WHEN discount_rate > 0.10 AND discount_rate <= 0.20 THEN '10-20%'
        ELSE '20%+'
    END
ORDER BY churn_rate_pct DESC;