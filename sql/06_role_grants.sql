-- 06_role_grants.sql
-- Run as ACCOUNTADMIN or another role authorized to create roles and grant privileges.
-- Review/adapt for your own account's security standards before running.

CREATE ROLE IF NOT EXISTS DE_PORTFOLIO_ANALYST;

GRANT USAGE ON DATABASE DE_PORTFOLIO_DB
    TO ROLE DE_PORTFOLIO_ANALYST;

GRANT USAGE ON SCHEMA DE_PORTFOLIO_DB.ANALYTICS
    TO ROLE DE_PORTFOLIO_ANALYST;

GRANT SELECT ON VIEW DE_PORTFOLIO_DB.ANALYTICS.CLEAN_CUSTOMERS
    TO ROLE DE_PORTFOLIO_ANALYST;

-- Intentionally do not grant USAGE on the RAW schema or SELECT on RAW.CUSTOMERS.
-- Assign this role to your own user through your account's approved user/role
-- administration process. Avoid hard-coding a user name into a public script.
