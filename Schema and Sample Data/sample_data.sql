-- =============================================================
-- sample_data.sql
-- Online Banking System - Polished Sample Data
-- Purpose: Seed realistic & edge-case data for testing
-- =============================================================

USE banking_system;

-- Clean slate for repeatable runs
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE transactions;
TRUNCATE TABLE accounts;
TRUNCATE TABLE customers;
SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------
-- Customers
-- ------------------------------
INSERT INTO customers (full_name, email, phone) VALUES
  ('Alice Johnson',  'alice@example.com',  '1234567890'),
  ('Bob Smith',      'bob@example.com',    '0987654321'),
  ('Charlie Brown',  'charlie@example.com',NULL),           -- NULL phone (edge)
  ('Diana Prince',   'diana@example.com',  '1112223333'),
  ('Eve Adams',      'eve@example.com',    '4445556666');

-- ------------------------------
-- Accounts
-- ------------------------------
-- Note: balances chosen to support positive, zero, low, and high cases
INSERT INTO accounts (customer_id, account_type, balance) VALUES
  (1, 'SAVINGS', 1000.00),   -- A1
  (1, 'CURRENT',    0.00),   -- A2 (zero balance)
  (2, 'SAVINGS',  500.00),   -- A3
  (3, 'CURRENT',   50.00),   -- A4 (low balance)
  (4, 'SAVINGS', 9999999.99),-- A5 (very high)
  (5, 'CURRENT',  250.00);   -- A6

-- ------------------------------
-- Transactions
-- ------------------------------
-- Mix of deposits, withdrawals, transfers; with explicit dates for reporting tests
INSERT INTO transactions (account_id, transaction_type, amount, transaction_date) VALUES
  (1, 'DEPOSIT',  500.00, '2025-01-01 10:00:00'),
  (1, 'WITHDRAW', 200.00, '2025-01-05 14:30:00'),
  (2, 'WITHDRAW',  50.00, '2025-01-07 09:15:00'),  -- zero-balance withdraw attempt (ledger-only; app should guard)
  (3, 'TRANSFER', 100.00, '2025-01-10 16:45:00'),
  (4, 'WITHDRAW',  60.00, '2025-01-12 11:20:00'),  -- exceeds low balance (ledger-only; for mismatch tests)
  (5, 'DEPOSIT', 9999999.99,'2025-01-15 12:00:00'),-- very large deposit
  (6, 'DEPOSIT',  100.00, '2025-01-20 08:30:00'),
  (6, 'WITHDRAW', 250.00, '2025-01-22 19:00:00');  -- equals balance

-- Hints for manual reconciliation tests:
-- * If you want balances to perfectly reconcile with the ledger, update the 'accounts.balance'
--   using the sum of transactions per account. Our test suite intentionally includes cases where
--   balances and transactions may diverge to validate WB04 (balance vs transaction sum).
