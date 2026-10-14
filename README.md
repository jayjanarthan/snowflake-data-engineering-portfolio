# Snowflake Data Engineering Portfolio

A small, reproducible Snowflake project demonstrating SQL transformations, data-quality rules, role-based access control (RBAC), column-level email masking, and a reporting layer.

> **Data notice:** All records and email addresses in this project are synthetic. No employer or customer data is included.
>
> **Scope note:** These scripts are reproduction scripts based on the project built and validated interactively. They have not been executed as a packaged set, so review each script against your Snowflake account and run them in the order below.

## Project goals

- Load a small synthetic customer dataset into a raw layer.
- Filter invalid records and deduplicate customers into an analytics view.
- Build a reporting view for customer counts by state and status.
- Apply a masking policy to email addresses while preserving genuine `NULL` values.
- Demonstrate an analyst role that can query the clean view but cannot query the raw table.
- Document expected outputs and validation checks.

## Architecture

```text
Synthetic customer records
           |
           v
DE_PORTFOLIO_DB.RAW.CUSTOMERS
           |
           |  Email masking policy on EMAIL
           v
DE_PORTFOLIO_DB.ANALYTICS.CLEAN_CUSTOMERS
           |
           v
DE_PORTFOLIO_DB.ANALYTICS.CUSTOMER_SUMMARY
           |
           v
State/status customer counts
```

The analyst role receives access to the analytics schema and clean view, not the raw schema/table.

See [`docs/architecture.md`](docs/architecture.md) for more detail.

## Repository layout

```text
.
├── README.md
├── sql/
│   ├── 01_setup.sql
│   ├── 02_synthetic_data.sql
│   ├── 03_masking_policy.sql
│   ├── 04_clean_view.sql
│   ├── 05_reporting_view.sql
│   ├── 06_role_grants.sql
│   └── 07_validation.sql
└── docs/
    ├── architecture.md
    └── validation-checklist.md
```

## Prerequisites

- A Snowflake account and permission to create the database objects used here.
- A warehouse available to your role.
- `ACCOUNTADMIN` or an appropriately delegated administrative role for the setup and grants scripts.
- A worksheet in Snowsight or another Snowflake SQL client.

The role and grant statements may need adjustment for your account's security model. Follow least privilege; do not grant broad access just to make a script run.

## Execution order

Run the scripts in `sql/` in numeric order:

1. `01_setup.sql` — create database and schemas.
2. `02_synthetic_data.sql` — create the raw table and insert seven synthetic records.
3. `03_masking_policy.sql` — create the masking policy and apply it to the raw email column.
4. `04_clean_view.sql` — create the clean analytics view.
5. `05_reporting_view.sql` — create the reporting summary view.
6. `06_role_grants.sql` — create/grant the analyst role (administrative privileges required).
7. `07_validation.sql` — run the checks, switching to the analyst role for the analyst-specific tests.

**Important:** Run `03_masking_policy.sql` before `04_clean_view.sql`. The masking policy preserves genuine `NULL` email values. In testing, masking a `NULL` as a non-NULL placeholder changed how `EMAIL IS NOT NULL` behaved for a role using the view. Preserving `NULL` values avoids that issue.

## Data-quality rules

The clean view applies these rules:

- Exclude rows with `EMAIL IS NULL`.
- Keep only states `CA`, `NY`, and `TX`.
- Keep only statuses `ACTIVE` and `INACTIVE`.
- Deduplicate by `CUSTOMER_ID`, keeping the earliest signup date among records that passed the filters.

Filtering happens **before** deduplication. As a result, Ava Brown's `PENDING` record for customer ID `1005` is excluded, while Liam Davis's later `ACTIVE` record is retained.

## Expected results

### Raw layer

Seven synthetic source records.

### Clean view

Four rows:

| CUSTOMER_ID | FIRST_NAME | LAST_NAME | STATE | CUSTOMER_STATUS |
|---:|---|---|---|---|
| 1001 | Maya | Patel | CA | ACTIVE |
| 1002 | Ethan | Chen | CA | ACTIVE |
| 1003 | Olivia | Garcia | TX | INACTIVE |
| 1005 | Liam | Davis | CA | ACTIVE |

Excluded records:
- Customer `1004` (Noah Williams): email is `NULL`.
- Customer `1005` (Ava Brown): status is `PENDING`.
- Customer `1007` (Sophia Wilson): state `ZZ` is not allowed.

### Reporting view

| STATE | CUSTOMER_STATUS | CUSTOMER_COUNT |
|---|---|---:|
| CA | ACTIVE | 3 |
| TX | INACTIVE | 1 |

Expected total: four clean customers across two groups.

## Security behavior

The masking policy:
- Preserves `NULL` as `NULL`.
- Shows the original email only when `CURRENT_ROLE() = 'ACCOUNTADMIN'`.
- Returns `***MASKED***` for non-NULL emails under other roles.

The `DE_PORTFOLIO_ANALYST` role is intended to have `USAGE` on the database and analytics schema, plus `SELECT` on `CLEAN_CUSTOMERS`, but no access to `RAW.CUSTOMERS`. The exact grant statements are in `sql/06_role_grants.sql`.

This is a learning demonstration, not a production-ready security template. In a production environment, use purpose-specific roles and avoid relying on a single role name as the only condition for unmasking sensitive values.

## Cortex AI status

A Cortex `AI_SENTIMENT` test was attempted, but the Snowflake trial returned an error that the function was not available for trial accounts. No AI feature is represented as completed in this repository. A future extension could classify synthetic feedback after confirming account eligibility and cost implications.

## What this project demonstrates

- SQL-based data transformation and aggregation.
- Data-quality filters and deduplication.
- Understanding of how masking policies can interact with predicates.
- Least-privilege access design for raw and analytics layers.
- Validation through expected row counts and role-specific tests.
- Clear documentation of assumptions and limitations.

## Validation checklist

Use [`docs/validation-checklist.md`](docs/validation-checklist.md) and compare the actual outputs in your account with the expected results above.
