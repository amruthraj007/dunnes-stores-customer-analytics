/* ============================================================
   RAW DATA UNDERSTANDING
   Inspect structure, row counts, and category integrity.
   ============================================================ */


-- Preview sample of raw data
SELECT *
FROM customers
LIMIT 10;



-- Total row count in the raw dataset
SELECT COUNT(*) AS total_rows_raw
FROM customers;



-- Inspect schema and data types
DESCRIBE customers;



-- Distinct category checks
SELECT DISTINCT Education       AS distinct_education FROM customers;
SELECT DISTINCT Marital_Status  AS distinct_marital_status FROM customers;
SELECT DISTINCT Country         AS distinct_country FROM customers;





/* ============================================================
   DATA QUALITY VALIDATION
   Missing values, duplicates, ranges, binary integrity checks.
   ============================================================ */


-- Missing value scan for critical variables
SELECT
    SUM(Year_Birth IS NULL)                   AS missing_year_birth,
    SUM(Education IS NULL)                    AS missing_education,
    SUM(Income IS NULL OR Income = 0)         AS missing_income,
    SUM(Dt_Customer IS NULL)                  AS missing_customer_date
FROM customers;



-- Duplicate ID check
SELECT 
    ID,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY ID
HAVING COUNT(*) > 1;



-- Range validation for Year_Birth and Income
SELECT
    MIN(Year_Birth)    AS min_year_birth,
    MAX(Year_Birth)    AS max_year_birth,
    MIN(Income)        AS min_income,
    MAX(Income)        AS max_income
FROM customers;



-- Recency statistics & complaints summary
SELECT
    COUNT(DISTINCT Country)           AS country_count,
    MIN(Recency)                      AS min_recency,
    MAX(Recency)                      AS max_recency,
    SUM(Complain = 1)                 AS total_complaints,
    ROUND(AVG(Response) * 100, 2)     AS latest_campaign_response_rate
FROM customers;



-- Binary integrity check for campaign fields
SELECT
    SUM(AcceptedCmp1 NOT IN (0,1)) AS invalid_cmp1,
    SUM(AcceptedCmp2 NOT IN (0,1)) AS invalid_cmp2,
    SUM(AcceptedCmp3 NOT IN (0,1)) AS invalid_cmp3,
    SUM(AcceptedCmp4 NOT IN (0,1)) AS invalid_cmp4,
    SUM(AcceptedCmp5 NOT IN (0,1)) AS invalid_cmp5,
    SUM(Response    NOT IN (0,1))  AS invalid_response
FROM customers;





/* ============================================================
   DATA CLEANING
   Remove unrealistic ages/incomes, standardise categories.
   ============================================================ */


DROP TABLE IF EXISTS customers_cleaned;



CREATE TABLE customers_cleaned AS
SELECT
    ID,
    Year_Birth,

    -- Age as of project year (2025)
    YEAR(CURDATE()) - Year_Birth AS Age,

    Education,

    -- Standardised marital status groups
    CASE 
        WHEN Marital_Status IN ('Alone', 'YOLO', 'Absurd')
            THEN 'Other'
        ELSE Marital_Status
    END AS Marital_Status,

    Income,
    Kidhome,
    Teenhome,

    -- Household size
    (Kidhome + Teenhome) AS Total_Kids,

    Dt_Customer,

    -- Tenure in years since joining
    TIMESTAMPDIFF(YEAR, Dt_Customer, CURDATE()) AS Tenure_Years,

    Recency,

    -- Total spend across product categories
    ( MntWines
    + MntFruits
    + MntMeatProducts
    + MntFishProducts
    + MntSweetProducts
    + MntGoldProds ) AS Total_Spend,

    -- Total purchases across channels
    ( NumWebPurchases
    + NumCatalogPurchases
    + NumStorePurchases ) AS Total_Purchases,

    NumDealsPurchases,
    NumWebPurchases,
    NumCatalogPurchases,
    NumStorePurchases,
    NumWebVisitsMonth,

    -- Historical campaign engagement
    AcceptedCmp1,
    AcceptedCmp2,
    AcceptedCmp3,
    AcceptedCmp4,
    AcceptedCmp5,
    ( AcceptedCmp1
    + AcceptedCmp2
    + AcceptedCmp3
    + AcceptedCmp4
    + AcceptedCmp5 ) AS Total_Accepted_Campaigns,

    Response,
    Complain,
    Country

FROM customers
WHERE
      YEAR(CURDATE()) - Year_Birth BETWEEN 18 AND 90      -- realistic ages
  AND Income BETWEEN 5000 AND 250000;                      -- plausible incomes



-- Post-cleaning sanity check
SELECT COUNT(*) AS cleaned_row_count
FROM customers_cleaned;





/* ============================================================
   FEATURE ENGINEERING
   Create derived fields needed for segmentation & dashboards.
   ============================================================ */


DROP VIEW IF EXISTS vw_customers_features;



CREATE VIEW vw_customers_features AS
SELECT
    ID,
    Age,
    Education,
    Marital_Status,
    Income,
    Total_Kids,
    Tenure_Years,
    Recency,
    Total_Spend,
    Total_Purchases,
    Total_Accepted_Campaigns,
    NumWebVisitsMonth,
    Country
FROM customers_cleaned;





/* ============================================================
   SEGMENTATION MODEL
   Recency buckets, responder flags, campaign response type.
   ============================================================ */


DROP TABLE IF EXISTS customers_enriched;



CREATE TABLE customers_enriched AS
SELECT
    c.*,

    -- Ever accepted ANY previous campaign?
    CASE 
        WHEN Total_Accepted_Campaigns > 0 THEN 1
        ELSE 0
    END AS Ever_Accepted,

    -- Recency-based engagement segments
    CASE 
        WHEN Recency <= 30 THEN 'Active'
        WHEN Recency BETWEEN 31 AND 90 THEN 'Warm'
        ELSE 'Dormant'
    END AS Recency_Bucket,

    -- Latest campaign responder vs non-responder
    CASE
        WHEN Response = 1 THEN 'Responder'
        ELSE 'Non-Responder'
    END AS Is_Responder,

    -- Combined historical + latest response behaviour
    CASE
        WHEN Total_Accepted_Campaigns > 0 AND Response = 1
            THEN 'Repeat Responder'
        WHEN Total_Accepted_Campaigns = 0 AND Response = 1
            THEN 'New Responder'
        WHEN Total_Accepted_Campaigns > 0 AND Response = 0
            THEN 'Previously Engaged'
        ELSE
            'Never Engaged'
    END AS Campaign_Response_Type

FROM customers_cleaned c;



-- Enriched dataset count check
SELECT COUNT(*) AS enriched_row_count
FROM customers_enriched;





/* ============================================================
   ANALYTICAL QUERIES
   Feed into dashboards: demographics, spending, engagement.
   ============================================================ */


-- Education summary
SELECT 
    Education,
    COUNT(*)              AS customer_count,
    ROUND(AVG(Age), 2)    AS avg_age,
    ROUND(AVG(Income), 2) AS avg_income
FROM customers_enriched
GROUP BY Education
ORDER BY customer_count DESC;



-- Marital status summary
SELECT
    Marital_Status,
    COUNT(*)              AS customer_count,
    ROUND(AVG(Age), 2)    AS avg_age,
    ROUND(AVG(Income), 2) AS avg_income
FROM customers_enriched
GROUP BY Marital_Status
ORDER BY customer_count DESC;



-- Country distribution
SELECT 
    Country,
    COUNT(*) AS customer_count
FROM customers_enriched
GROUP BY Country
ORDER BY customer_count DESC;



-- Spend by education
SELECT
    Education,
    ROUND(AVG(Total_Spend), 2) AS avg_spend
FROM customers_enriched
GROUP BY Education
ORDER BY avg_spend DESC;



-- Spend & engagement by country
SELECT
    Country,
    ROUND(AVG(Total_Spend), 2)             AS avg_spend,
    ROUND(AVG(Total_Accepted_Campaigns),2) AS avg_engagement
FROM customers_enriched
GROUP BY Country
ORDER BY avg_spend DESC, avg_engagement DESC;



-- Spend by recency bucket
SELECT
    Recency_Bucket,
    ROUND(AVG(Total_Spend), 2) AS avg_spend
FROM customers_enriched
GROUP BY Recency_Bucket
ORDER BY
    CASE Recency_Bucket
        WHEN 'Active'  THEN 1
        WHEN 'Warm'    THEN 2
        WHEN 'Dormant' THEN 3
    END;



-- Tenure-based spending & purchases
SELECT
    Tenure_Years,
    ROUND(AVG(Total_Purchases), 2) AS avg_total_purchases,
    ROUND(AVG(Total_Spend), 2)     AS avg_total_spend
FROM customers_enriched
GROUP BY Tenure_Years
ORDER BY Tenure_Years;



-- Responder distribution
SELECT
    Is_Responder,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers_enriched), 2) AS pct_of_customers
FROM customers_enriched
GROUP BY Is_Responder;



-- Response rate by education
SELECT
    Education,
    COUNT(*)              AS total_customers,
    SUM(Response)         AS responders,
    ROUND(SUM(Response) * 100.0 / COUNT(*), 2) AS response_rate
FROM customers_enriched
GROUP BY Education
ORDER BY response_rate DESC;



-- Response rate by marital status
SELECT
    Marital_Status,
    COUNT(*)              AS total_customers,
    SUM(Response)         AS responders,
    ROUND(SUM(Response) * 100.0 / COUNT(*), 2) AS response_rate
FROM customers_enriched
GROUP BY Marital_Status
ORDER BY response_rate DESC;



-- Response rate by country
SELECT
    Country,
    COUNT(*)              AS total_customers,
    SUM(Response)         AS responders,
    ROUND(SUM(Response) * 100.0 / COUNT(*), 2) AS response_rate
FROM customers_enriched
GROUP BY Country
ORDER BY response_rate DESC;



-- Campaign response type distribution
SELECT
    Campaign_Response_Type,
    COUNT(*) AS customer_count
FROM customers_enriched
GROUP BY Campaign_Response_Type
ORDER BY customer_count DESC;



-- Behavioural differences: responders vs non-responders
SELECT
    Is_Responder,
    COUNT(*)                   AS customer_count,
    ROUND(AVG(Total_Spend),2)  AS avg_spend,
    ROUND(AVG(Income),2)       AS avg_income,
    ROUND(AVG(Recency),2)      AS avg_recency,
    ROUND(AVG(Tenure_Years),2) AS avg_tenure_years
FROM customers_enriched;
