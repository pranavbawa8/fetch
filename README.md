# Fetch Data Warehouse Design Project

## Overview
This repository contains a data engineering solution for transforming unstructured JSON data into a structured relational data warehouse model. The project analyzes receipt rewards data and demonstrates the complete workflow from data exploration to business insights.

## Repository Contents

### `data_exploration.ipynb`
Jupyter notebook with comprehensive analysis of the three JSON datasets:
- Detailed assessment of brands, receipts, and users data
- Data quality checks and visualizations
- Transformation logic for creating dimensional model

### `erd_fetch.png`
Entity-Relationship Diagram showing the simplified relational data model with:
- Four core tables (Brands, Users, Receipts, Receipt Items)
- Carefully selected attributes for each entity
- Relationship mappings between entities

### `fetch.sql`
SQL queries (PostgreSQL dialect) designed to answer business questions:
- Top brands by receipt volume for recent months
- Month-over-month brand performance comparisons
- Analysis of spending patterns by receipt status
- Brand popularity among recently created users

### `stakeholder_communication.docx`
Business-focused document containing:
- Summary of the proposed data model
- Key data quality findings
- Recommendations for implementation
- Questions requiring business input

## Key Findings

### Data Quality Issues
- 283 duplicate user records (57% of user dataset)
- Missing values in critical fields (20% of brands missing brand codes)
- Complex nested JSON structures requiring transformation
- Date fields stored in non-standard format
- Significant outliers in transaction values

### Data Model Design
The simplified relational model balances analytical power with maintainability by:
- Normalizing redundant data
- Preserving key relationships for business queries
- Structuring data for efficient time-series analysis
- Supporting future expansion with minimal schema changes

## Next Steps
- Implement ETL pipeline for data transformation
- Create data quality monitoring framework
- Build incremental loading process to minimize processing time
- Establish master data management for brands and categories
