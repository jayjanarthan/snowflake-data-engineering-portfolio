-- 01_setup.sql
-- Run with a role authorized to create databases and schemas.
-- Re-running this script reuses the database and schemas.

CREATE DATABASE IF NOT EXISTS DE_PORTFOLIO_DB;

CREATE SCHEMA IF NOT EXISTS DE_PORTFOLIO_DB.RAW;
CREATE SCHEMA IF NOT EXISTS DE_PORTFOLIO_DB.ANALYTICS;

-- Select a warehouse available to your role in Snowsight, or uncomment and
-- adapt the following if you have permission to use the project warehouse:
-- USE WAREHOUSE SNOWFLAKE_LEARNING_WH;

USE DATABASE DE_PORTFOLIO_DB;
