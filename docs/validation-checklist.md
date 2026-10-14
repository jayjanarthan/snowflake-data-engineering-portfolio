# Validation Checklist

Run the checks after executing the SQL scripts in order.

## Raw data

- [ ] `DE_PORTFOLIO_DB.RAW.CUSTOMERS` contains 7 rows.
- [ ] Customer `1004` has a genuine `NULL` email.
- [ ] Customer ID `1005` appears twice in raw data.
- [ ] The raw data includes one invalid status (`PENDING`) and one invalid state (`ZZ`).

## Clean view

- [ ] `DE_PORTFOLIO_DB.ANALYTICS.CLEAN_CUSTOMERS` returns 4 rows.
- [ ] Returned IDs are 1001, 1002, 1003, and 1005.
- [ ] The retained customer 1005 record is Liam Davis (`ACTIVE`).
- [ ] Customer 1004 is excluded because its email is `NULL`.
- [ ] Customer 1007 is excluded because state `ZZ` is not allowed.
- [ ] Ava Brown's customer 1005 record is excluded because `PENDING` is not an allowed status.

## Reporting

- [ ] `CUSTOMER_SUMMARY` returns two groups.
- [ ] CA / ACTIVE has count 3.
- [ ] TX / INACTIVE has count 1.
- [ ] Total summary count is 4.

## Security

- [ ] Under `ACCOUNTADMIN`, non-NULL emails are visible.
- [ ] Under `DE_PORTFOLIO_ANALYST`, non-NULL emails display as `***MASKED***`.
- [ ] The masking policy preserves a genuine `NULL` value as `NULL`.
- [ ] Under `DE_PORTFOLIO_ANALYST`, the clean view returns 4 rows.
- [ ] Under `DE_PORTFOLIO_ANALYST`, querying `RAW.CUSTOMERS` fails with an authorization error.

## Notes

Record the date, role, query, actual result, and any differences from expected output. Do not include credentials, account identifiers, or non-synthetic data in screenshots or repository files.
