# Snowflake Salesforce CRM Analytics

An end-to-end Data Engineering and Analytics project that demonstrates how raw CRM support data can be transformed into business-ready insights using **Snowflake** and **Tableau**.

The project implements a modern multi-layer data warehouse architecture, performs SQL-based data transformations, and visualizes key customer support metrics through interactive dashboards.

---

## Architecture

```
                    Python
          (Synthetic CRM Data Generation)
                      │
                      ▼
                 AWS S3 Storage
                      │
                      ▼
              Snowflake Data Warehouse
      ┌─────────────────────────────────┐
      │          RAW Layer              │
      │                ↓                │
      │        STAGING Layer            │
      │                ↓                │
      │         MART Layer              │
      └─────────────────────────────────┘
                      │
                      ▼
            Tableau Dashboards
```

---

## Tech Stack

- Snowflake
- SQL
- Tableau
- Python
- AWS S3
- Git & GitHub

---

## Project Structure

```
snowflake-salesforce-crm-analytics
│
├── Data Generation
│   └── generate_crm_data.py
│
├── Data
│   └── Sample CRM datasets
│
├── Snowflake
│   ├── 01_database_setup.sql
│   ├── 02_load_raw_data.sql
│   ├── 03_staging_transformations.sql
│   ├── 04_mart_tables.sql
│   └── 05_validation_queries.sql
│
├── Tableau
│   ├── CRM Support Analytics Dashboard
│   └── Dashboard Screenshots
│
└── README.md
```

---

## Dataset

The project uses a **synthetically generated Salesforce CRM support dataset** created using Python.

The dataset includes:

- Accounts
- Cases
- Agents
- Products
- Regions
- Case Activities
- Customer Feedback
- SLA Targets

---

## Snowflake Data Pipeline

### Raw Layer

- Creates landing tables
- Loads CSV files from AWS S3
- Preserves source data without modification

### Staging Layer

- Cleans and standardizes data
- Removes inconsistencies
- Applies SQL transformations
- Prepares data for analytics

### Mart Layer

Builds analytics-ready data models including:

- Fact tables
- Dimension tables
- Business reporting views

---

## Tableau Dashboards

The dashboards provide insights into CRM support operations including:

- Executive Overview
- Case Volume Trends
- Agent Performance
- SLA Compliance
- Resolution Time Analysis
- Customer Satisfaction
- Product-wise Support Analysis
- Regional Performance

---

## Key Features

- End-to-end data warehouse implementation
- Multi-layer Snowflake architecture
- SQL-based ETL transformations
- Dimensional data modeling
- Interactive Tableau dashboards
- KPI reporting for business analytics
- Synthetic CRM data generation using Python

---

## Skills Demonstrated

- Snowflake Data Warehousing
- SQL
- Data Modeling
- ETL Pipeline Development
- Data Transformation
- Tableau Dashboard Development
- Business Intelligence
- Python Data Generation
- AWS S3 Integration
- Git Version Control

---

## Future Enhancements

- Implement Snowflake Streams & Tasks for incremental loading
- Automate pipeline orchestration
- Integrate dbt for transformation management
- Add data quality validation checks
- Deploy dashboards with scheduled refreshes

---

## Repository Purpose

This project was built as a portfolio project to demonstrate practical experience in designing and implementing an end-to-end analytics solution using modern data engineering tools and best practices.
