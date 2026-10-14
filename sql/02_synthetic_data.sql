-- 02_synthetic_data.sql
-- Synthetic-only sample data. This script recreates the table and its rows.

CREATE OR REPLACE TABLE DE_PORTFOLIO_DB.RAW.CUSTOMERS (
    CUSTOMER_ID INTEGER,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    EMAIL VARCHAR(100),
    STATE VARCHAR(2),
    SIGNUP_DATE DATE,
    CUSTOMER_STATUS VARCHAR(20)
);

INSERT INTO DE_PORTFOLIO_DB.RAW.CUSTOMERS
    (CUSTOMER_ID, FIRST_NAME, LAST_NAME, EMAIL, STATE, SIGNUP_DATE, CUSTOMER_STATUS)
VALUES
    (1001, 'Maya',   'Patel',   'maya@example.com',   'CA', '2025-01-15', 'ACTIVE'),
    (1002, 'Ethan',  'Chen',    'ethan@example.com',  'CA', '2025-02-20', 'ACTIVE'),
    (1003, 'Olivia', 'Garcia',  'olivia@example.com', 'TX', '2025-03-10', 'INACTIVE'),
    (1004, 'Noah',   'Williams', NULL,                'NY', '2025-04-05', 'ACTIVE'),
    (1005, 'Ava',    'Brown',   'ava@example.com',    'CA', '2025-05-12', 'PENDING'),
    (1005, 'Liam',   'Davis',   'liam@example.com',   'CA', '2025-06-01', 'ACTIVE'),
    (1007, 'Sophia', 'Wilson',  'sophia@example.com', 'ZZ', '2025-06-15', 'ACTIVE');

-- Expected raw row count: 7
SELECT COUNT(*) AS RAW_ROW_COUNT
FROM DE_PORTFOLIO_DB.RAW.CUSTOMERS;
