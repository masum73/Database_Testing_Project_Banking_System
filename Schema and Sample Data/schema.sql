-- =============================================================
-- schema.sql
-- Online Banking System - Polished Database Schema
-- DB: MySQL/MariaDB (works on XAMPP)
-- Notes:
--  * Uses InnoDB + utf8mb4 for reliability and emoji-safe text.
--  * Keeps core constraints minimal for broad compatibility.
--  * Optional advanced constraints are included as comments.
-- =============================================================

-- Use your database (make sure it exists):
-- CREATE DATABASE banking_system;
USE banking_system;

-- ------------------------------
-- Table: customers
-- ------------------------------
DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY COMMENT 'PK',
  full_name   VARCHAR(100) NOT NULL COMMENT 'Customer full name',
  email       VARCHAR(100) NOT NULL COMMENT 'Unique email address',
  phone       VARCHAR(15) NULL COMMENT 'Optional numeric phone',
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Row creation timestamp',

  CONSTRAINT uq_customers_email UNIQUE (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Customer master';

-- ------------------------------
-- Table: accounts
-- ------------------------------
DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts (
  account_id   INT AUTO_INCREMENT PRIMARY KEY COMMENT 'PK',
  customer_id  INT NOT NULL COMMENT 'FK -> customers.customer_id',
  account_type ENUM('SAVINGS','CURRENT') NOT NULL COMMENT 'Account type',
  balance      DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Current balance',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Row creation timestamp',

  CONSTRAINT fk_accounts_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,

  INDEX idx_accounts_customer_id (customer_id)
  -- Optional: enforce one account of each type per customer (uncomment if desired)
  -- , CONSTRAINT uq_accounts_customer_type UNIQUE (customer_id, account_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bank accounts per customer';

-- ------------------------------
-- Table: transactions
-- ------------------------------
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
  transaction_id   INT AUTO_INCREMENT PRIMARY KEY COMMENT 'PK',
  account_id       INT NOT NULL COMMENT 'FK -> accounts.account_id',
  transaction_type ENUM('DEPOSIT','WITHDRAW','TRANSFER') NOT NULL COMMENT 'Txn type',
  amount           DECIMAL(12,2) NOT NULL COMMENT 'Positive amount of the transaction',
  transaction_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'When txn occurred',

  CONSTRAINT fk_transactions_account
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
    ON DELETE CASCADE
    ON UPDATE RESTRICT,

  INDEX idx_transactions_account_id (account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ledger of account transactions';

-- ------------------------------
-- Recommended (optional) enhancements
-- ------------------------------
-- 1) CHECKs (MySQL 8+ enforces; older MariaDB may ignore):
-- ALTER TABLE transactions
--   ADD CONSTRAINT chk_transactions_amount_pos CHECK (amount > 0);
--
-- 2) Trigger to block negative balances (advanced):
-- CREATE TRIGGER trg_accounts_no_negative_before_update
-- BEFORE UPDATE ON accounts
-- FOR EACH ROW
-- BEGIN
--   IF NEW.balance < 0 THEN
--     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Balance cannot be negative';
--   END IF;
-- END;
--
-- 3) Stored procedure for atomic transfers (advanced) and associated tests.
-- 4) View for reporting total balances per customer (advanced).
