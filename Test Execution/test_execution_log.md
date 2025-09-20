# Test Execution Log – Banking System

**Date:** 2025-09-06  
**Environment:** MySQL/MariaDB via XAMPP, DBeaver

### TC_BB01 – Insert a new customer

- **Expected:** New row returned with non-null `customer_id`.
- **Actual:** Inserted id=6; row visible via SELECT.

### TC_BB02 – Prevent duplicate email

- **Expected:** Duplicate error on `email`.
- **Actual:** Error: `Duplicate entry 'alice@example.com' for key 'customers.email'`.

### TC_BB03 – Deposit increases balance

- **Expected:** Balance increased by 200 compared to previous value.
- **Actual:** Balance updated from 1000.00 → 1200.00.

### TC_BB04 – Withdraw more than balance

- **Expected:** Should fail or result in negative balance (depending on validation rules).
- **Actual:** No change if balance < 100. cause balance is 50. (no rules applied).

### TC_BB05 – Transfer (atomic simulation)

- **Expected:** From account decreased by 50, to account increased by 50, one transfer row inserted.
- **Actual:** Transaction logged, balance reduced from 1200.00 → 1150.00 and increased from 500.00 to 550.00

### TC_BB06 – Cascade delete

- **Expected:** No rows for the deleted customer in child tables.
- **Actual:** No rows for the deleted customer in child tables.

### TC_BB07 – ENUM rejects invalid value

- **Expected:** Error: invalid ENUM value.
- **Actual:** Data truncated for column 'account_type' at row 1

### TC_BB08 – NOT NULL columns reject NULL

- **Expected:** Error: NOT NULL constraint.
- **Actual:** Column 'full_name' cannot be null

### TC_WB01 – Orphan transactions check

- **Expected:** 0 rows.
- **Actual:** 0 rows.

### TC_WB02 – Orphan accounts check

- **Expected:** 0 rows.
- **Actual:** 0 rows.

### TC_WB03 – 3‑way join verification

- **Expected:** Rows map correctly to owners.
- **Actual:** Rows map correctly to owners.

### TC_WB04 – Balance vs sum(transactions)

- **Expected:** 0 rows or list of mismatches to investigate.
- **Actual:** found mismatches to investigate.

### TC_WB05 – Duplicate account type per customer (policy)

- **Expected:** 0 rows if rule applies.
- **Actual:** returns 0 rows

### TC_WB06 – Invalid phone formats

- **Expected:** Returns rows that need cleansing.
- **Actual:** customer id 3 returns with null phone number.

### TC_WB07 – Email format heuristic

- **Expected:** 0 or list to fix.
- **Actual:** 0 rows

### TC_WB08 – Index presence

- **Expected:** Index on `customers.customers_id`,`customers.email`, `accounts.accounts_id`, `accounts.customer_id`, `transactions.transactions_id`,`transactions.account_id`.
- **Actual:** got Primary Keys, Unique Keys, and Foreign Keys of each table means same as expected

### TC_WB09 – EXPLAIN plan on join

- **Expected:** Uses indexes on join keys.
- **Actual:** Used

### TC_WB10 – Future‑dated transactions

- **Expected:** 0 rows.
- **Actual:** 0 rows.

### TC_STR01 – Verify tables exist

- **Expected:** `customers`, `accounts`, `transactions` listed.
- **Actual:** all the tables are listed.

### TC_STR02 – Describe `customers` columns

- **Expected:** Matches README schema.
- **Actual:** matched

### TC_STR03 – Describe `accounts` columns

- **Expected:** Matches README schema.
- **Actual:** matched

### TC_STR04 – Describe `transactions` columns

- **Expected:** Matches README schema.
- **Actual:** matched

### TC_STR05 – Max length check: customer name

- **Expected:** Error or truncation per server settings (document behavior).
- **Actual:** Data truncation: Data too long for column 'full_name' at row 1

### TC_STR06 – Max length check: email 100 chars

- **Expected:** Insert succeeds at or under 100 chars; fails if over.
- **Actual:** Data truncation: Data too long for column 'email' at row 1

### TC_STR07 – Phone length & digits

- **Expected:** Returns invalid phones.
- **Actual:** returned customer id 3 with null phone numbers.

### TC_SEC01 – SQL injection as data (inert)

- **Expected:** Exact literal match only; no mass effects.
- **Actual:** 1 Hacker Test row returned.

### TC_SEC02 – Least privilege (manual)

- **Expected:** Writes denied; reads allowed.
- **Actual:** same as expected.

### TC_REP01 – Total balance per customer

- **Expected:** Totals match base account rows.
- **Actual:** matched also got customer id 6 and 7 with null balance

### TC_REP02 – Monthly totals

- **Expected:** Aggregates correct by month.
- **Actual:** same as expected

### TC_REP03 – Dormant accounts

- **Expected:** Accounts without activity returned.
- **Actual:** 0 rows returned

### TC_SAFE01 – Backup/restore smoke (manual)

- **Expected:** Counts match pre/post.
- **Actual:** same as expected.

---

## Blank Template

### <TEST_CASE_ID> – <Title>

- **Expected:** <expected>
- **Actual:** <actual>
