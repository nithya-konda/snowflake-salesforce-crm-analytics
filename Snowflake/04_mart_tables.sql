/*
Dimension: DIM_CUSTOMER

Purpose:
Stores customer/account attributes used for slicing and filtering case metrics across industry, segment, and geography.
*/

CREATE OR REPLACE TABLE MART.DIM_CUSTOMER AS
SELECT
    ACCOUNT_ID AS CUSTOMER_KEY,
    ACCOUNT_NAME,
    INDUSTRY,
    SEGMENT,
    COUNTRY
FROM STAGING.STG_ACCOUNTS;

/*
Dimension: DIM_AGENT

Purpose:
Stores support agent attributes for workforce performance and productivity reporting.
*/

CREATE OR REPLACE TABLE MART.DIM_AGENT AS
SELECT
    AGENT_ID AS AGENT_KEY,
    AGENT_NAME,
    TEAM,
    MANAGER,
    LOCATION
FROM STAGING.STG_AGENTS;

/*
Dimension: DIM_PRODUCT

Purpose:
Stores product information used for support trend and product performance analysis.
*/

CREATE OR REPLACE TABLE MART.DIM_PRODUCT AS
SELECT
    PRODUCT_ID AS PRODUCT_KEY,
    PRODUCT_NAME,
    PRODUCT_CATEGORY
FROM STAGING.STG_PRODUCTS;

/*
Dimension: DIM_REGION

Purpose:
Stores regional hierarchy used for geographical reporting and KPI analysis.
*/

CREATE OR REPLACE TABLE MART.DIM_REGION AS
SELECT
    REGION_ID AS REGION_KEY,
    REGION_NAME
FROM STAGING.STG_REGIONS;

/*
Dimension: DIM_DATE

Purpose:
Provides calendar attributes for time-series reporting and trend analysis.
*/

CREATE OR REPLACE TABLE MART.DIM_DATE AS
SELECT DISTINCT

    CREATED_DATE::DATE AS DATE_KEY,

    YEAR(CREATED_DATE) AS YEAR,

    QUARTER(CREATED_DATE) AS QUARTER,

    MONTH(CREATED_DATE) AS MONTH,

    MONTHNAME(CREATED_DATE) AS MONTH_NAME,

    DAY(CREATED_DATE) AS DAY_OF_MONTH,

    DAYNAME(CREATED_DATE) AS DAY_NAME,

    WEEKOFYEAR(CREATED_DATE) AS WEEK_NUMBER

FROM STAGING.STG_CASES;

/*
Fact Table: FACT_CASE

Purpose:
Central fact table containing case-level metrics used for operational reporting, SLA monitoring, agent performance analysis,
customer satisfaction reporting, and executive dashboards.

Data Sources:
1. STG_CASES
2. STG_CASE_ACTIVITY_SUMMARY
3. STG_FEEDBACK

Metrics Included:
- Resolution Hours
- SLA Compliance
- Email Count
- Escalation Count
- Reopen Count
- CSAT Rating
- Positive CSAT Indicator

Grain:
One record per Case.
*/

CREATE OR REPLACE TABLE MART.FACT_CASE AS

SELECT

    C.CASE_ID,

    C.ACCOUNT_ID AS CUSTOMER_KEY,

    C.AGENT_ID AS AGENT_KEY,

    C.PRODUCT_ID AS PRODUCT_KEY,

    C.REGION_ID AS REGION_KEY,

    C.CREATED_DATE::DATE AS DATE_KEY,

    C.PRIORITY,

    C.STATUS,

    C.COMPLAINT_CATEGORY,

    C.ISSUE_GROUP,

    C.CALCULATED_RESOLUTION_HOURS,

    C.SLA_MET_FLAG,

    COALESCE(A.EMAIL_COUNT,0) AS EMAIL_COUNT,

    COALESCE(A.ESCALATION_COUNT,0) AS ESCALATION_COUNT,

    COALESCE(A.REOPEN_COUNT,0) AS REOPEN_COUNT,

    F.RATING,

    F.SATISFACTION_BUCKET,

    F.POSITIVE_CSAT_FLAG

FROM STAGING.STG_CASES C

LEFT JOIN STAGING.STG_CASE_ACTIVITY_SUMMARY A
    ON C.CASE_ID = A.CASE_ID

LEFT JOIN STAGING.STG_FEEDBACK F
    ON C.CASE_ID = F.CASE_ID;



--SLA PERCENTAGE
SELECT SLA_MET_FLAG, COUNT(*)
FROM MART.FACT_CASE
GROUP BY SLA_MET_FLAG;

--AVERAGE RESOLUTION TIME
SELECT AVG(CALCULATED_RESOLUTION_HOURS) FROM MART.FACT_CASE;

--AVERAGE CSAT
SELECT AVG(RATING) FROM MART.FACT_CASE;

/*
Object: CASES_STREAM

Purpose:
Captures incremental changes from RAW.CASES to support change data capture (CDC) and incremental ELT processing.
*/

CREATE OR REPLACE STREAM STAGING.CASES_STREAM
ON TABLE RAW.CASES;

/*
Table: STG_CASES_INCREMENTAL

Purpose:
Stores newly arrived or modified case records identified through Snowflake Streams for incremental processing.
*/

CREATE OR REPLACE TABLE STAGING.STG_CASES_INCREMENTAL AS
SELECT *
FROM STAGING.STG_CASES
WHERE 1=0;

/*
Task: LOAD_INCREMENTAL_CASES

Purpose:
Automates hourly ingestion of incremental case records captured through Snowflake Streams.
*/

CREATE OR REPLACE TASK STAGING.LOAD_INCREMENTAL_CASES
WAREHOUSE = COMPUTE_WH
SCHEDULE = 'USING CRON 0 * * * * UTC'
AS

INSERT INTO STAGING.STG_CASES_INCREMENTAL

SELECT
    *
FROM STAGING.CASES_STREAM;

ALTER TASK STAGING.LOAD_INCREMENTAL_CASES RESUME;

USE DATABASE SUPPORT_ANALYTICS_DB;
USE SCHEMA STAGING;

SHOW TASKS;
SHOW STREAMS;

