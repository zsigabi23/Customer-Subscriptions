**Customer Subscription Analytics Project**

**Project Overview**

This project analyzes customer subscription data to understand churn behavior, revenue performance, and engagement patterns.

The goal was to move beyond basic descriptive reporting and identify early indicators of churn risk, revenue concentration, and customer quality across acquisition channels, plans, and regions.

Using SQL for data validation and transformation, and Power BI for visualization, this project demonstrates an end-to-end analytics workflow from raw data to actionable business insights.

---

**Business Problem**

Subscription-based businesses rely heavily on customer retention and recurring revenue stability.

Key business questions addressed in this project:

What is the current churn rate?

Which subscription plans are most profitable and most unstable?

Are discounted customers higher risk?

What behaviors signal potential churn?

Which acquisition channels bring high-quality customers?

---

**Tools Used**

SQL Server – Data Cleaning & Validation
Power BI – Dashboard Development & Data Visualization
CSV Dataset – Subscription-Level Data

---

**Dataset Summary**

The dataset contains customer-level subscription data including:

Plan Type (Basic, Standard, Premium)
Net Monthly Recurring Revenue (MRR)
Discount Rate
Monthly Engagement (Sessions)
Support Tickets (Last 90 Days)
NPS Score
Acquisition Channel
Device Type
Country
Churn Status & Dates
Each row represents a unique subscription.

---

**Data Preparation Process**

Before analysis, the dataset was validated and cleaned to ensure reliability.
Steps included:
Data type corrections (Date, Numeric, Boolean)
Duplicate detection using window functions
Null value validation on critical fields
Logical churn validation (churn date consistency)
Value range validation:
NPS between 0–10
Discount between 0–1
Net MRR ≤ Gross MRR
No negative engagement metrics
Standardization of categorical fields
This ensured the dataset was analysis-ready and decision-support reliable.

---

**Key Analysis Areas**
**1. Business Health Overview**

Overall churn rate
Average Net MRR
Average NPS score
Average monthly engagement
This provides a snapshot of subscription stability and customer satisfaction.

---

**2. Revenue & Plan Performance**

Revenue contribution by subscription tier
ARPU (Average Revenue Per User)
Churn rate comparison by plan
This helps identify which plans drive sustainable revenue.

---

**3. Churn Drivers**

Churn vs Engagement (Sessions)
Churn vs Support Tickets
Churn vs NPS
Channel-level churn comparison
These analyses highlight behavioral and satisfaction-based churn indicators.

---

**4. High-Risk Customer Segmentation**

A “High Risk” segment was defined using combined behavioral signals:
NPS ≤ 6
Monthly Sessions < 10
Support Tickets ≥ 3
This allowed identification of revenue exposure and unstable customer groups.

---

**Dashboard Overview**

The Power BI dashboard includes:
Executive KPI summary
Revenue by plan
Churn analysis by plan and channel
Geographic revenue distribution
Engagement and satisfaction impact analysis
High-risk customer segmentation
Cohort-based trend view

---

**Interactive slicers allow filtering by:**

Plan
Country
Acquisition Channel
Device
Signup Month
Strategic Insights (Example Structure)
Higher engagement is strongly associated with lower churn probability.
Customers with frequent support tickets show elevated churn risk.
Discount-heavy acquisition channels may drive lower-quality subscriptions.
Premium users demonstrate more stable retention patterns.
Business Recommendations
Strengthen onboarding to reduce early-stage churn.
Investigate recurring support issues driving dissatisfaction.
Reassess aggressive discount strategies in high-churn channels.
Prioritize retention strategies for high-ARPU segments.

---

**Project Structure**

/data – Subscription dataset
/sql – Cleaning & analysis scripts
/powerbi – Dashboard file & screenshot
/docs – Supporting documentation

---

**About Me**

Zolile Sigabi
Aspiring Data Analyst
SQL | Power BI | Data Analysis | Business Insight Development
