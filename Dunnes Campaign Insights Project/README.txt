Dunnes Stores – Customer Insights & Campaign Response Analysis
A SQL + Tableau Customer Analytics Portfolio Project

------------------------------------------------------------
PROJECT OVERVIEW
------------------------------------------------------------
This project is a complete end-to-end customer insights analysis inspired by Dunnes Stores,
one of Ireland’s largest retail chains. The goal was to understand customer behaviour across
spending, engagement, and marketing campaign response using:

- SQL → Data cleaning, validation, feature engineering & segmentation
- Tableau → Visual exploration & interactive dashboards
- Maven Analytics dataset → Customer demographics, purchases, and campaign history

This project reflects real-world analytics work: cleaning imperfect data, building clear
transformation logic, segmenting customers, and presenting insights through dashboards and
a written case study.

------------------------------------------------------------
BUSINESS GOAL
------------------------------------------------------------
Retailers frequently run promotional campaigns, but it’s not always clear who is responding
or what drives engagement. For Dunnes Stores, the challenges include:

- Limited visibility on high- vs low-engagement customers
- Understanding how spending relates to demographics and tenure
- Improving campaign targeting
- Reducing marketing wastage
- Identifying high-value, responsive customer segments

This project answers these questions using a structured analytics workflow.

------------------------------------------------------------
PROJECT OBJECTIVES
------------------------------------------------------------
1. Build a clean, reliable customer dataset
2. Engineer behavioural features (spend, purchases, tenure, recency)
3. Segment customers based on activity and engagement
4. Analyse campaign response patterns
5. Deliver insights through dashboards & a case study

------------------------------------------------------------
TOOLS USED
------------------------------------------------------------
- SQL (MySQL) – Data validation, cleaning, feature engineering, segmentation
- Tableau – Interactive dashboards & insight exploration
- Excel / Word – Documentation & visualisation planning
- GitHub – Version control & portfolio presentation

------------------------------------------------------------
MY APPROACH
------------------------------------------------------------
1. Audited raw data for missing values, invalid categories, and unrealistic ages/incomes.  
2. Built a cleaned customer table with realistic ages (18–90) and income range (€5k–€250k).  
3. Engineered features such as total spend, total purchases, tenure, and household size.  
4. Created segmentation (Recency buckets, Responder types, Ever-Accepted flag).  
5. Wrote analytical SQL queries to summarise behaviour and campaign performance.  
6. Connected the enriched dataset to Tableau and designed three dashboards.  
7. Consolidated findings into business insights and actionable recommendations.

------------------------------------------------------------
TABLEAU DASHBOARDS
------------------------------------------------------------
1. Customer Overview Dashboard 
   - Spending, demographics, tenure, household profile

2. Behaviour & Engagement Dashboard
   - Purchases, web interactions, and recency segments

3. Campaign Response Dashboard
   - Responder types, acceptance trends, high-value segments

------------------------------------------------------------
DATA USED
------------------------------------------------------------
The dataset comes from Maven Analytics and includes:

- Customer demographics
- Household structure
- Spending across six product categories
- Store, web, and catalogue purchases
- Tenure and recency
- Campaign engagement (5 historical + 1 latest)

Files included in this repository:
- data/marketing_data.csv
- data/marketing_data_dictionary.csv

------------------------------------------------------------
SQL PIPELINE
------------------------------------------------------------
The SQL workflow includes:

- Raw data inspection
- Missing value checks
- Cleaning and standardising categories
- Feature engineering
- Segmentation logic
- Analytical summaries used in Tableau

Full SQL script:
sql/dunnes_customer_analysis.sql

------------------------------------------------------------
REPOSITORY STRUCTURE
------------------------------------------------------------
dunnes-customer-insights-case-study/
│
├── README.md
├── data/
│   ├── marketing_data.csv
│   └── marketing_data_dictionary.csv
├── sql/
│   └── dunnes_customer_analysis.sql
├── dashboards/
│   ├── Customer Overview Dashboard.png
│   ├── Behaviour & Engagement Dashboard.png
│   ├── Campaign Response Dashboard.png
│   └── dunnes_dashboard.twbx
├── documentation/
│   ├── Final_Case_Study_DunnesStores.pdf
│   └── Final_Case_Study_DunnesStores.docx
└── assets/
    └── dunnes_logo.png

------------------------------------------------------------
KEY INSIGHTS
------------------------------------------------------------
- Married & highly educated customers spend the most
- Portugal shows the highest campaign acceptance
- Active customers (Recency ≤ 30) spend significantly more
- Repeat Responders are the most valuable high-engagement group
- Dormant customers represent a reactivation opportunity
- New Responders are a promising emerging segment

------------------------------------------------------------
RECOMMENDATIONS
------------------------------------------------------------
- Prioritise highly educated, long-tenure customers for premium and loyalty campaigns.  
- Launch a reactivation programme for Dormant customers who still show above-average spend.  
- Focus cross-sell and upsell offers on Active customers (highest response rate and spend).  
- Localise campaigns for high-performing regions (e.g. Portugal / other top countries in your data).  
- Use campaign response + recency + tenure to build a simple “Customer Value Score” for targeting.

------------------------------------------------------------
FULL CASE STUDY DOCUMENT
------------------------------------------------------------
Available in:
documentation/Final_Case_Study_DunnesStores.pdf

------------------------------------------------------------
HOW TO RUN THIS PROJECT
------------------------------------------------------------
1. Run SQL pipeline (MySQL / compatible DBMS)
   → sql/dunnes_customer_analysis.sql

2. Import cleaned tables into Tableau
   → customers_cleaned and customers_enriched

3. Open the Tableau workbook
   → dashboards/dunnes_dashboard.twbx

------------------------------------------------------------
ABOUT ME
------------------------------------------------------------
I'm Amruth Raj, a Data Analyst with experience in product and marketing analytics.
This project is part of my portfolio as I apply for Data Analyst roles in Ireland.

------------------------------------------------------------
CREDITS
------------------------------------------------------------
Dataset provided by Maven Analytics.
Project inspired by real Irish retail analysis, contextualised for Dunnes Stores.



