# Architecture Overview

## Logical flow

```text
                Synthetic source data
                         |
                         v
             +------------------------+
             | RAW.CUSTOMERS          |
             | 7 source rows          |
             +------------------------+
                         |
             Email masking policy
             - NULL stays NULL
             - Non-NULL email masked
               except ACCOUNTADMIN
                         |
                         v
             +------------------------+
             | ANALYTICS              |
             | CLEAN_CUSTOMERS        |
             | 4 validated rows       |
             +------------------------+
                         |
                         v
             +------------------------+
             | CUSTOMER_SUMMARY       |
             | 2 state/status groups  |
             +------------------------+
```

## Security boundary

`DE_PORTFOLIO_ANALYST` is granted:
- `USAGE` on `DE_PORTFOLIO_DB`
- `USAGE` on `DE_PORTFOLIO_DB.ANALYTICS`
- `SELECT` on `DE_PORTFOLIO_DB.ANALYTICS.CLEAN_CUSTOMERS`

The analyst role is not granted `USAGE` on `DE_PORTFOLIO_DB.RAW` or `SELECT` on `DE_PORTFOLIO_DB.RAW.CUSTOMERS`.

## Design lesson

Masking policies can affect predicates that reference protected columns. The policy therefore explicitly preserves `NULL` before masking non-NULL email values. This keeps the clean-view `EMAIL IS NOT NULL` rule consistent for the analyst role.
