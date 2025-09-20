# Database Testing – Banking System

This file combines the **test cases** with **edge cases** and **simple structural checks** (table/column/length) to demonstrate **black‑box + white‑box + security + performance + reporting** database testing in one project.

Each test case includes:

- **ID**
- **Title**
- **Description**
- **Goal / Bug Prevented**
- **SQL**
- **Expected Result**
- **Actual Result** (fill during execution)

> Run order: `schema.sql` → `sample_data.sql` → this file (in DBeaver).  
> DB: `banking_system`

---

## Section A — Black‑Box Tests

### TC_BB01 – Insert a new customer

**Description:** Validate that a basic customer create works and data is retrievable by a unique attribute (email).  
**Goal / Bug Prevented:** Ensure CRUD insert path works; prevents silent insert failures.

```sql
INSERT INTO customers (full_name, email, phone)
VALUES ('Frank Miller', 'frank@example.com', '7778889999');
SELECT * FROM customers WHERE email = 'frank@example.com';
```

**Expected:** New row returned with non-null `customer_id`.  
**Actual:** _[to be filled]_

---

### TC_BB02 – Prevent duplicate email

**Description:** Attempt to insert a second customer with an existing email to verify UNIQUE constraint.  
**Goal / Bug Prevented:** Duplicate identities.

```sql
INSERT INTO customers (full_name, email, phone)
VALUES ('Duplicate Alice', 'alice@example.com', '1231231234');
```

**Expected:** Error: duplicate key on `email`.  
**Actual:** _[to be filled]_

---

### TC_BB03 – Deposit increases balance

**Description:** Apply a deposit and ensure the account balance increases accordingly.  
**Goal / Bug Prevented:** Under-crediting on deposit.

```sql
UPDATE accounts SET balance = balance + 200 WHERE account_id = 1;
SELECT balance FROM accounts WHERE account_id = 1;
```

**Expected:** Balance increases by 200.  
**Actual:** _[to be filled]_

---

### TC_BB04 – Withdraw more than balance (guarded)

**Description:** Try to withdraw an amount higher than current balance with a safety predicate in WHERE clause.  
**Goal / Bug Prevented:** Accidental overdraft.

```sql
UPDATE accounts SET balance = balance - 100
WHERE account_id = 4 AND balance >= 100;
SELECT balance FROM accounts WHERE account_id = 4;
```

**Expected:** No change if balance < 100.  
**Actual:** _[to be filled]_

---

### TC_BB05 – Transfer (atomic simulation)

**Description:** Simulate a transfer with two updates + a logged transaction inside a transaction boundary.  
**Goal / Bug Prevented:** Half-applied transfers.

```sql
START TRANSACTION;
UPDATE accounts SET balance = balance - 50 WHERE account_id = 1 AND balance >= 50;
UPDATE accounts SET balance = balance + 50 WHERE account_id = 3;
INSERT INTO transactions (account_id, transaction_type, amount) VALUES (1, 'TRANSFER', -50.00);
INSERT INTO transactions (account_id, transaction_type, amount) VALUES (3, 'TRANSFER', 50.00);
COMMIT;
SELECT account_id, balance FROM accounts WHERE account_id IN (1,3);
```

**Expected:** From account decreased by 50, to account increased by 50, one transfer row inserted.  
**Actual:** _[to be filled]_

---

### TC_BB06 – Cascade delete

**Description:** Delete a customer and verify their accounts and transactions are removed.  
**Goal / Bug Prevented:** Orphan rows after deletions.

```sql
INSERT INTO customers (full_name, email, phone) VALUES ('Temp User', 'temp@example.com', '1002003000');
SET @temp_customer_id = LAST_INSERT_ID();
INSERT INTO accounts (customer_id, account_type, balance) VALUES (@temp_customer_id, 'SAVINGS', 100.00);
SET @temp_account_id = LAST_INSERT_ID();
INSERT INTO transactions (account_id, transaction_type, amount) VALUES (@temp_account_id, 'DEPOSIT', 100.00);
DELETE FROM customers WHERE customer_id = @temp_customer_id;
SELECT * FROM accounts WHERE customer_id = @temp_customer_id;
SELECT * FROM transactions WHERE account_id = @temp_account_id;
```

**Expected:** No rows for the deleted customer in child tables.  
**Actual:** _[to be filled]_

---

### TC_BB07 – ENUM rejects invalid value

**Description:** Attempt to insert an account with invalid `account_type`.  
**Goal / Bug Prevented:** Invalid types in reference domain.

```sql
INSERT INTO accounts (customer_id, account_type, balance) VALUES (1, 'FIXED', 100.00);
```

**Expected:** Error: invalid ENUM value.  
**Actual:** _[to be filled]_

---

### TC_BB08 – NOT NULL columns reject NULL

**Description:** Insert NULLs into required fields to verify NOT NULL constraints.  
**Goal / Bug Prevented:** Missing required data.

```sql
INSERT INTO customers (full_name, email, phone) VALUES (NULL, NULL, '1112223333');
```

**Expected:** Error: NOT NULL constraint.  
**Actual:** _[to be filled]_

---

## Section B — White‑Box / Integrity Tests

### TC_WB01 – Orphan transactions check

**Description:** Ensure every transaction references an existing account.  
**Goal / Bug Prevented:** Orphan transactions.

```sql
SELECT t.transaction_id, t.account_id
FROM transactions t
LEFT JOIN accounts a ON a.account_id = t.account_id
WHERE a.account_id IS NULL;
```

**Expected:** 0 rows.  
**Actual:** _[to be filled]_

---

### TC_WB02 – Orphan accounts check

**Description:** Ensure every account references an existing customer.  
**Goal / Bug Prevented:** Orphan accounts.

```sql
SELECT a.account_id, a.customer_id
FROM accounts a
LEFT JOIN customers c ON c.customer_id = a.customer_id
WHERE c.customer_id IS NULL;
```

**Expected:** 0 rows.  
**Actual:** _[to be filled]_

---

### TC_WB03 – 3‑way join verification

**Description:** Verify relationship chain Customer → Account → Transaction.  
**Goal / Bug Prevented:** Broken joins/mislabeled ownership.

```sql
SELECT c.full_name, a.account_id, a.balance, t.transaction_type, t.amount, t.transaction_date
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
JOIN transactions t ON t.account_id = a.account_id;
```

**Expected:** Rows map correctly to owners.  
**Actual:** _[to be filled]_

---

### TC_WB04 – Balance vs sum(transactions)

**Description:** Reconcile account balance with ledger transactions.  
**Goal / Bug Prevented:** Balance/ledger mismatches.

```sql
SELECT a.account_id, a.balance,
       COALESCE(SUM(CASE WHEN t.transaction_type='DEPOSIT' THEN t.amount
                         WHEN t.transaction_type='WITHDRAW' THEN -t.amount
                         ELSE 0 END),0) AS txn_sum
FROM accounts a
LEFT JOIN transactions t ON t.account_id = a.account_id
GROUP BY a.account_id, a.balance
HAVING a.balance <> txn_sum;
```

**Expected:** 0 rows or list of mismatches to investigate.  
**Actual:** _[to be filled]_

---

### TC_WB05 – Duplicate account type per customer (policy)

**Description:** Check if one account type per customer rule is violated.  
**Goal / Bug Prevented:** Policy violations.

```sql
SELECT customer_id, account_type, COUNT(*) AS total
FROM accounts
GROUP BY customer_id, account_type
HAVING COUNT(*) > 1;
```

**Expected:** 0 rows if rule applies.  
**Actual:** _[to be filled]_

---

### TC_WB06 – Invalid phone formats

**Description:** Find NULL/short/non‑digit phones.  
**Goal / Bug Prevented:** Bad contact data.

```sql
SELECT customer_id, full_name, phone
FROM customers
WHERE phone IS NULL OR LENGTH(phone) < 10 OR phone REGEXP '[^0-9]';
```

**Expected:** Returns rows that need cleansing.  
**Actual:** _[to be filled]_

---

### TC_WB07 – Email format heuristic

**Description:** Rough email validity check.  
**Goal / Bug Prevented:** Malformed emails.

```sql
SELECT customer_id, email
FROM customers
WHERE email NOT LIKE '%@%.__%';
```

**Expected:** 0 or list to fix.  
**Actual:** _[to be filled]_

---

### TC_WB08 – Index presence

**Description:** Inspect indexes on critical columns.  
**Goal / Bug Prevented:** Slow queries.

```sql
SHOW INDEXES FROM customers;
SHOW INDEXES FROM accounts;
SHOW INDEXES FROM transactions;
```

**Expected:** Index on `customers.customers_id`,`customers.email`, `accounts.accounts_id`, `accounts.customer_id`, `transactions.transactions_id`,`transactions.account_id`.  
**Actual:** _[to be filled]_

---

### TC_WB09 – EXPLAIN plan on join

**Description:** Evaluate join performance path.  
**Goal / Bug Prevented:** Unoptimized plans.

```sql
EXPLAIN
SELECT c.full_name, a.account_id, SUM(t.amount)
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
LEFT JOIN transactions t ON t.account_id = a.account_id
GROUP BY c.full_name, a.account_id;
```

**Expected:** Uses indexes on join keys.  
**Actual:** _[to be filled]_

---

### TC_WB10 – Future‑dated transactions

**Description:** Detect timestamps set in the future.  
**Goal / Bug Prevented:** Broken reporting timelines.

```sql
SELECT * FROM transactions WHERE transaction_date > NOW();
```

**Expected:** 0 rows.  
**Actual:** _[to be filled]_

---

## Section C — New Simple Structural Checks (tables/columns/length)

### TC_STR01 – Verify tables exist

**Description:** Confirm all expected tables are present.  
**Goal / Bug Prevented:** Missing tables in environment.

```sql
SHOW TABLES;
```

**Expected:** `customers`, `accounts`, `transactions` listed.  
**Actual:** _[to be filled]_

---

### TC_STR02 – Describe `customers` columns

**Description:** Validate column names, data types, nullability.  
**Goal / Bug Prevented:** Schema drift.

```sql
DESCRIBE customers;
```

**Expected:** Matches README schema.  
**Actual:** _[to be filled]_

---

### TC_STR03 – Describe `accounts` columns

**Description:** Validate structure of `accounts`.  
**Goal / Bug Prevented:** Schema drift.

```sql
DESCRIBE accounts;
```

**Expected:** Matches README schema.  
**Actual:** _[to be filled]_

---

### TC_STR04 – Describe `transactions` columns

**Description:** Validate structure of `transactions`.  
**Goal / Bug Prevented:** Schema drift.

```sql
DESCRIBE transactions;
```

**Expected:** Matches README schema.  
**Actual:** _[to be filled]_

---

### TC_STR05 – Max length check: customer name

**Description:** Ensure names > 100 chars are rejected.  
**Goal / Bug Prevented:** Truncation/overflow.

```sql
INSERT INTO customers (full_name, email, phone)
VALUES (RPAD('A',101,'A'), 'toolong@example.com', '1112223333');
```

**Expected:** Error or truncation per server settings (document behavior).  
**Actual:** _[to be filled]_

---

### TC_STR06 – Max length check: email 100 chars

**Description:** Push right up to declared length.  
**Goal / Bug Prevented:** Length mismatch.

```sql
-- 100-char local part + '@x.com' will exceed; adjust to hit exactly limit
INSERT INTO customers (full_name, email, phone)
VALUES ('Len Test', CONCAT(RPAD('l', 95, 'l'), '@x.com'), '2223334444');
```

**Expected:** Insert succeeds at or under 100 chars; fails if over.  
**Actual:** _[to be filled]_

---

### TC_STR07 – Phone length & digits

**Description:** Verify phone shorter than 10 or non-digits are flagged by query checks.  
**Goal / Bug Prevented:** Bad phone data stored.

```sql
SELECT customer_id, phone
FROM customers
WHERE phone IS NULL OR LENGTH(phone) < 10 OR phone REGEXP '[^0-9]';
```

**Expected:** Returns invalid phones.  
**Actual:** _[to be filled]_

---

## Section D — Security Tests

### TC_SEC01 – SQL injection as data (inert)

**Description:** Confirm stored strings with SQL-like content are treated as data only.  
**Goal / Bug Prevented:** Injection via stored values.

```sql
INSERT INTO customers (full_name, email, phone) VALUES ('Hacker Test', "' OR 1=1 --", '9999999999');
SELECT * FROM customers WHERE email = "' OR 1=1 --";
```

**Expected:** Exact literal match only; no mass effects.  
**Actual:** _[to be filled]_

---

### TC_SEC02 – Least privilege (manual)

**Description:** Try writes with read-only user.  
**Goal / Bug Prevented:** Over-privileged accounts.

```
-- Use a read-only DB user and validate writes fail, reads succeed.
```

**Expected:** Writes denied; reads allowed.  
**Actual:** _[to be filled]_

---

## Section E — Reporting / Analytics

### TC_REP01 – Total balance per customer

**Description:** Aggregate balances across a customer’s accounts.  
**Goal / Bug Prevented:** Mis-aggregation.

```sql
SELECT c.customer_id, c.full_name, SUM(a.balance) AS total_balance
FROM customers c
LEFT JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_balance DESC;
```

**Expected:** Totals match base account rows.  
**Actual:** _[to be filled]_

---

### TC_REP02 – Monthly totals

**Description:** Sum deposits/withdrawals/transfer by month.  
**Goal / Bug Prevented:** Incorrect period grouping.

```sql
SELECT DATE_FORMAT(transaction_date, '%Y-%m') AS ym,
       SUM(CASE WHEN transaction_type='DEPOSIT' THEN amount ELSE 0 END) AS deposits,
       SUM(CASE WHEN transaction_type='WITHDRAW' THEN amount ELSE 0 END) AS withdrawals,
       SUM(CASE WHEN transaction_type='TRANSFER' THEN amount ELSE 0 END) AS transfer
FROM transactions
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY ym;
```

**Expected:** Aggregates correct by month.  
**Actual:** _[to be filled]_

---

### TC_REP03 – Dormant accounts

**Description:** List accounts with no transactions.  
**Goal / Bug Prevented:** Missing inactive accounts in reports.

```sql
SELECT a.account_id, a.customer_id
FROM accounts a
LEFT JOIN transactions t ON t.account_id = a.account_id
WHERE t.account_id IS NULL;
```

**Expected:** Accounts without activity returned.  
**Actual:** _[to be filled]_

---

## Section F — Maintenance

### TC_SAFE01 – Backup/restore smoke (manual)

**Description:** Dump & restore to another DB and compare counts.  
**Goal / Bug Prevented:** Unrestorable backups.

```
-- Use mysqldump; compare counts before/after.
```

**Expected:** Counts match pre/post.  
**Actual:** _[to be filled]_

---

**Last updated:** 2025-09-06
