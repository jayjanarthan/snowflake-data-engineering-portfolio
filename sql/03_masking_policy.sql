-- 03_masking_policy.sql
-- Run with a role authorized to create/alter masking policies and modify the table.
-- The NULL-preserving branch is important: NULL must remain NULL so that
-- predicates such as EMAIL IS NOT NULL behave consistently in protected views.

CREATE OR ALTER MASKING POLICY DE_PORTFOLIO_DB.ANALYTICS.EMAIL_MASK_POLICY
AS (EMAIL_VALUE VARCHAR)
RETURNS VARCHAR ->
    CASE
        WHEN EMAIL_VALUE IS NULL THEN NULL
        WHEN CURRENT_ROLE() = 'ACCOUNTADMIN' THEN EMAIL_VALUE
        ELSE '***MASKED***'
    END;

ALTER TABLE DE_PORTFOLIO_DB.RAW.CUSTOMERS
    MODIFY COLUMN EMAIL
    SET MASKING POLICY DE_PORTFOLIO_DB.ANALYTICS.EMAIL_MASK_POLICY;
