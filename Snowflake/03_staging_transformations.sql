--THIS SCRIPT IS WRITTEN TO CREATE THE STAGING TABLES ALONG WITH THE TRANSFORMATIONS

--ACCOUNTS

CREATE OR REPLACE TABLE STAGING.STG_ACCOUNTS AS
SELECT
    TRIM(ACCOUNT_ID) AS ACCOUNT_ID,
    TRIM(ACCOUNT_NAME) AS ACCOUNT_NAME,
    INITCAP(INDUSTRY) AS INDUSTRY,
    INITCAP(SEGMENT) AS SEGMENT,
    INITCAP(COUNTRY) AS COUNTRY,
    CREATED_DATE
FROM RAW.ACCOUNTS;

/*TRANSFORMATIONS MADE:
Remove spaces
Standardize casing
*/

--AGENTS

CREATE OR REPLACE TABLE STAGING.STG_AGENTS AS
SELECT
    TRIM(AGENT_ID) AS AGENT_ID,
    TRIM(AGENT_NAME) AS AGENT_NAME,
    INITCAP(TEAM) AS TEAM,
    INITCAP(MANAGER) AS MANAGER,
    INITCAP(LOCATION) AS LOCATION,
    HIRE_DATE
FROM RAW.AGENTS;


/*TRANSFORMATIONS:
Standardize text fields
*/

--PRODUCTS

CREATE OR REPLACE TABLE STAGING.STG_PRODUCTS AS
SELECT
    TRIM(PRODUCT_ID) AS PRODUCT_ID,
    TRIM(PRODUCT_NAME) AS PRODUCT_NAME,
    INITCAP(PRODUCT_CATEGORY) AS PRODUCT_CATEGORY
FROM RAW.PRODUCTS;

/*TRANSFORMATION:
Standardize categories
*/

--REGIONS

--DATA CLEANSING

CREATE OR REPLACE TABLE STAGING.STG_REGIONS AS
SELECT
    TRIM(REGION_ID) AS REGION_ID,
    TRIM(REGION_NAME) AS REGION_NAME
FROM RAW.REGIONS;

--SLA TARGETS

--STANDARDISE PRIORITY

CREATE OR REPLACE TABLE STAGING.STG_SLA_TARGETS AS
SELECT
    UPPER(PRIORITY) AS PRIORITY,
    SLA_HOURS
FROM RAW.SLA_TARGETS;

--CASES

/*

Transformations Performed:
1. Standardized Priority and Status values using UPPER() and INITCAP().
2. Calculated Resolution Hours using Created Date and Resolved Date.
3. Derived SLA Compliance Flag based on Resolution Hours and SLA Targets.
4. Categorized cases into Resolution Time Buckets for reporting.
5. Created Priority Rank to enable business-driven sorting.
6. Grouped complaint categories into broader Issue Groups.
7. Derived Reporting Month for trend and time-series analysis.
8. Prepared cleansed and enriched case data for downstream fact table creation.
*/

CREATE OR REPLACE TABLE STAGING.STG_CASES AS
SELECT
    TRIM(CASE_ID) AS CASE_ID,
    TRIM(ACCOUNT_ID) AS ACCOUNT_ID,
    TRIM(AGENT_ID) AS AGENT_ID,
    TRIM(PRODUCT_ID) AS PRODUCT_ID,
    TRIM(REGION_ID) AS REGION_ID,

    CREATED_DATE,
    RESOLVED_DATE,

    UPPER(PRIORITY) AS PRIORITY,

    INITCAP(STATUS) AS STATUS,

    COMPLAINT_CATEGORY,

    DATEDIFF(
        HOUR,
        CREATED_DATE,
        RESOLVED_DATE
    ) AS CALCULATED_RESOLUTION_HOURS,

    CASE
        WHEN DATEDIFF(
                HOUR,
                CREATED_DATE,
                RESOLVED_DATE
             ) <= SLA_HOURS
        THEN 'Y'
        ELSE 'N'
    END AS SLA_MET_FLAG,

    CASE
        WHEN DATEDIFF(HOUR, CREATED_DATE, RESOLVED_DATE) < 8
            THEN '<8 Hours'
        WHEN DATEDIFF(HOUR, CREATED_DATE, RESOLVED_DATE) < 24
            THEN '8-24 Hours'
        WHEN DATEDIFF(HOUR, CREATED_DATE, RESOLVED_DATE) < 48
            THEN '24-48 Hours'
        ELSE '48+ Hours'
    END AS RESOLUTION_BUCKET,

    CASE
        WHEN UPPER(PRIORITY)='CRITICAL' THEN 1
        WHEN UPPER(PRIORITY)='HIGH' THEN 2
        WHEN UPPER(PRIORITY)='MEDIUM' THEN 3
        ELSE 4
    END AS PRIORITY_RANK,

    CASE
        WHEN COMPLAINT_CATEGORY IN
        ('Login Issue','API Error','Integration Failure')
        THEN 'Technical'

        WHEN COMPLAINT_CATEGORY='Billing'
        THEN 'Financial'

        ELSE 'Other'
    END AS ISSUE_GROUP,

    TO_CHAR(
        CREATED_DATE,
        'YYYY-MM'
    ) AS REPORTING_MONTH,

    REOPEN_FLAG,
    ESCALATION_FLAG

FROM RAW.CASES;


--FEEDBACK

/*

Transformations Performed:
1. Categorized customer ratings into Satisfaction Buckets
   (Satisfied, Neutral, Dissatisfied).
2. Created Positive CSAT Flag for KPI calculations.
3. Standardized customer feedback data for analytical reporting.
4. Prepared reusable customer satisfaction metrics for Tableau dashboards.
*/

CREATE OR REPLACE TABLE STAGING.STG_FEEDBACK AS
SELECT
    FEEDBACK_ID,
    CASE_ID,
    RATING,

    CASE
        WHEN RATING >= 4 THEN 'Satisfied'
        WHEN RATING = 3 THEN 'Neutral'
        ELSE 'Dissatisfied'
    END AS SATISFACTION_BUCKET,

    CASE
        WHEN RATING >= 4 THEN 1
        ELSE 0
    END AS POSITIVE_CSAT_FLAG

FROM RAW.CUSTOMER_FEEDBACK;

--ACTIVITY

/*

Transformations Performed:
1. Aggregated activity-level records to case-level metrics.
2. Calculated Total Activities performed on each case.
3. Calculated Email Count per case.
4. Calculated Escalation Count per case.
5. Calculated Reopen Count per case.
6. Reduced reporting complexity by pre-aggregating activity metrics.
7. Prepared operational support KPIs for downstream fact table creation.
*/

CREATE OR REPLACE TABLE STAGING.STG_CASE_ACTIVITY_SUMMARY AS
SELECT
    CASE_ID,

    COUNT(*) AS TOTAL_ACTIVITIES,

    COUNT_IF(
        ACTIVITY_TYPE='Email Sent'
    ) AS EMAIL_COUNT,

    COUNT_IF(
        ACTIVITY_TYPE='Escalation'
    ) AS ESCALATION_COUNT,

    COUNT_IF(
        ACTIVITY_TYPE='Case Reopened'
    ) AS REOPEN_COUNT

FROM RAW.CASE_ACTIVITIES
GROUP BY CASE_ID;

SHOW TABLES IN SCHEMA STAGING;