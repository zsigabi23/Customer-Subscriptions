# 📊 Customer Subscription Analytics  
### End-to-End Churn & Revenue Intelligence Project

---

## 🚀 Project Overview

This project analyzes customer subscription data to uncover churn behavior, revenue performance, engagement trends, and customer quality across acquisition channels.

The objective was to move beyond simple descriptive reporting and identify **early warning signals of churn risk**, revenue concentration patterns, and plan-level stability.

Using **SQL Server for data validation and transformation** and **Power BI for visualization and storytelling**, this project demonstrates a complete analytics workflow — from raw subscription data to actionable business insights.

---

## 🎯 Business Problem

Subscription-based businesses depend on predictable recurring revenue and strong customer retention.

However, churn, aggressive discounting, and low engagement can silently erode profitability.

This project answers critical business questions:

- What is the overall churn rate?
- Which subscription plans are most profitable — and which are most unstable?
- Are discounted customers higher churn risk?
- What behavioral signals predict churn?
- Which acquisition channels attract high-quality customers?

---

## 🛠 Tools & Technologies

**SQL Server**
- Data cleaning & validation
- Duplicate detection (ROW_NUMBER)
- Data type correction
- Logical consistency checks
- Business rule validation

**Power BI**
- Data modeling
- KPI development (DAX)
- Interactive dashboard design
- Risk segmentation analysis

**Dataset**
- CSV subscription-level data

---

## 📊 Dataset Summary

Each row represents a unique subscription and includes:

- Plan Type (Basic, Standard, Premium)
- Net Monthly Recurring Revenue (MRR)
- Discount Rate
- Monthly Sessions (Engagement)
- Support Tickets (Last 90 Days)
- NPS Score
- Acquisition Channel
- Device Type
- Country
- Churn Status & Churn Date

---

## 🧹 Data Preparation Process (SQL)

Before analysis, the dataset was validated to ensure accuracy and reliability.

Steps included:

- Data type corrections (Date, Numeric, Boolean)
- Duplicate detection using window functions
- Null value validation on critical fields
- Logical churn validation:
  - Churn date consistency
  - No churn before signup
- Value range validation:
  - NPS between 0–10
  - Discount between 0–1
  - Net MRR ≤ Gross MRR
  - No negative engagement values
- Standardization of categorical fields

This ensured the dataset was analysis-ready and decision-support reliable.

---

## 📈 Key Analysis Areas

### 1️⃣ Business Health Overview

- Overall churn rate
- Average Net MRR
- Average NPS score
- Average monthly engagement

Provides a snapshot of subscription stability and customer satisfaction.

---

### 2️⃣ Revenue & Plan Performance

- Revenue contribution by plan
- ARPU (Average Revenue Per User)
- Churn rate comparison by plan

Helps identify which tiers drive sustainable revenue.

---

### 3️⃣ Churn Drivers

- Churn vs Engagement (Sessions)
- Churn vs Support Tickets
- Churn vs NPS
- Churn comparison by acquisition channel

Highlights behavioral and satisfaction-based churn indicators.

---

### 4️⃣ High-Risk Customer Segmentation

A **High Risk** segment was defined using combined behavioral signals:

- NPS ≤ 6
- Monthly Sessions < 10
- Support Tickets ≥ 3

This segmentation enabled identification of revenue exposure and unstable customer groups.

---

## 📊 Dashboard Overview (Power BI)

The interactive Power BI dashboard includes:

- Executive KPI Summary
- Revenue by Plan
- Churn Analysis by Plan & Channel
- Geographic Revenue Distribution (Map)
- Engagement & Satisfaction Impact Analysis
- High-Risk Customer Segmentation
- Cohort-Based Trend Analysis

Interactive slicers allow filtering by:

- Plan
- Country
- Acquisition Channel
- Device
- Signup Month

---

## 📌 Strategic Insights

- Higher engagement is strongly associated with lower churn probability.
- Customers generating frequent support tickets demonstrate elevated churn risk.
- Discount-heavy acquisition channels may drive lower-quality subscriptions.
- Premium plan users show more stable retention patterns.

---

## 💡 Business Recommendations

- Strengthen onboarding to reduce early-stage churn.
- Investigate recurring support issues impacting satisfaction.
- Reassess aggressive discount strategies in high-churn channels.
- Prioritize retention initiatives for high-ARPU segments.

---

## 🧠 Skills Demonstrated

- Data Cleaning & Validation (SQL)
- Exploratory Data Analysis
- KPI & Business Metric Design
- Risk Segmentation Modeling
- Power BI Dashboard Development
- Data Storytelling & Insight Communication

---

## 👩🏽‍💻 Author

**Zolile Sigabi**  
Aspiring Data Analyst  
SQL | Power BI | Data Analysis | Business Intelligence  

---

## ⭐ Why This Project Matters

This project demonstrates the ability to:

- Transform raw subscription data into actionable business insights
- Identify churn risk signals using behavioral indicators
- Build interactive dashboards for executive decision-making
- Bridge technical analysis with strategic recommendations

It reflects applied business analytics rather than simple data visualization.
