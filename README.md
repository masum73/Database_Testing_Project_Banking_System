# Database Testing Project – Banking System

## Overview

This project is a **portfolio-ready demonstration of Database Testing** using **MySQL/MariaDB** on **XAMPP** with **DBeaver** as the client tool.

It simulates a **Banking System**, where customers can create accounts, deposit, withdraw, and transfer funds. Instead of testing through a web or mobile app, this project directly tests the **database layer** — ensuring that the data is stored correctly, relationships are consistent, rules are enforced, and performance is reliable.

The project includes:

- A **database schema** (tables, relationships, constraints).
- **Sample data** (both normal and edge cases).
- A detailed **test case suite** with 30+ SQL-based test scenarios.
- An **execution log** showing real results after running those queries.

This demonstrates both **test planning** and **test execution**, skills essential for a **Software QA Engineer**.

---

## What You’ll Find

- **schema.sql** – Defines database structure:
  - `customers` (personal info with unique emails).
  - `accounts` (linked to customers, with balances).
  - `transactions` (linked to accounts, deposits/withdrawals/transfers).
- **sample_data.sql** – Populates tables with realistic banking data including **edge cases**:
  - Zero balances, very large balances, NULL phone numbers, over-withdrawal attempts.
- **test_cases.md** – More than **30 SQL-based test cases** with:
  - Description of what’s being tested.
  - Goal (what bug or issue is prevented).
  - SQL query or command.
  - Expected outcome.
- **test_execution_log.md** – Execution results with **actual outputs**, acting as evidence that the tests were run successfully.

---

## How to Use

1. **Create the Database**

   ```sql
   CREATE DATABASE banking_system;
   USE banking_system;
   ```

2. **Run schema.sql**  
   Creates tables with primary keys, foreign keys, and constraints.

3. **Run sample_data.sql**  
   Seeds the database with both normal and edge-case data.

4. **Open test_cases.md**  
   Execute SQL test cases in **DBeaver** and compare results.

5. **Record Outcomes**  
   Fill results into **test_execution_log.md** (this project already has example outcomes logged).

---

## Testing Coverage

1. **Black-box (Functional Testing):**

   - Deposit increases balance.
   - Withdraw reduces balance but not below zero.
   - Transfers update both accounts.
   - Cascade deletes remove linked accounts/transactions.

2. **White-box (Structural Testing):**

   - Foreign key integrity (no orphan accounts/transactions).
   - Balance equals the sum of all transactions.
   - Multi-table joins return correct relationships.

3. **Structural / Schema Validation:**

   - Tables and columns exist.
   - Data types and field lengths are enforced.
   - Edge cases: long names/emails, invalid phone numbers.

4. **Security Testing:**

   - SQL injection strings stored safely as data.
   - Least-privilege validation (manual check).

5. **Performance Testing:**

   - Indexes exist on critical columns.
   - EXPLAIN query plans show optimized paths.

6. **Reporting / Analytics:**
   - Monthly totals of deposits/withdrawals.
   - Per-customer balances across accounts.
   - Dormant accounts with no transactions.

---

## Why This Project Matters

Databases are the **heart of every application** — especially in banking, where **accuracy, security, and consistency** are critical. Bugs at the database level can cause serious issues like:

- Wrong balances shown to customers.
- Transactions not linked to accounts.
- Performance bottlenecks with large data.
- Security vulnerabilities from bad queries.

This project shows how a **QA Engineer** can ensure data is:

- **Accurate** (no mismatches between balances and transactions).
- **Consistent** (no orphan or duplicate records).
- **Secure** (injection attempts stored safely, access controlled).
- **Performant** (optimized queries with indexes).

---

## Skills Demonstrated

- Designing and executing **SQL-based test cases**.
- Validating **data integrity, constraints, and relationships**.
- Performing **black-box and white-box database testing**.
- Checking **performance** with indexing and query plans.
- Documenting testing in **professional formats** (`test_cases.md`, `test_execution_log.md`).
- Presenting a project in a **GitHub portfolio-ready** format.

---

📅 **Last Updated:** 2025-09-20
