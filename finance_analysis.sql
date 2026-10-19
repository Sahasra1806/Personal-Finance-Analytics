CREATE DATABASE personal_finance;
USE personal_finance;

CREATE TABLE transactions (
    transaction_id VARCHAR(10) PRIMARY KEY,
    transaction_date DATE NOT NULL,
    description VARCHAR(100),
    category VARCHAR(50) NOT NULL,
    type VARCHAR(10) NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    payment_mode VARCHAR(30),
    recurring VARCHAR(5),
    CHECK (type IN ('Income', 'Expense')),
    CHECK (amount >= 0)
);

CREATE TABLE monthly_budget (
    budget_id INT AUTO_INCREMENT PRIMARY KEY,
    budget_month DATE NOT NULL,
    category VARCHAR(50) NOT NULL,
    budget DECIMAL(12,2) NOT NULL,
    UNIQUE (budget_month, category),
    CHECK (budget >= 0)
);

SHOW TABLES;


USE personal_finance;

SELECT * FROM transactions;

USE personal_finance;

INSERT INTO transactions
(transaction_id, transaction_date, description, category,
 `type`, amount, payment_mode, recurring)
VALUES
('T001', '2026-01-01', 'Monthly Salary', 'Salary', 'Income', 30000, 'Bank Transfer', 'No'),
('T002', '2026-01-02', 'House Rent', 'Rent', 'Expense', 8000, 'UPI', 'Yes'),
('T003', '2026-01-03', 'Groceries', 'Food', 'Expense', 2500, 'UPI', 'No'),
('T004', '2026-01-05', 'Electricity Bill', 'Utilities', 'Expense', 1200, 'UPI', 'Yes'),
('T005', '2026-01-07', 'Bus Pass', 'Transport', 'Expense', 800, 'Card', 'Yes'),
('T006', '2026-01-10', 'Online Shopping', 'Shopping', 'Expense', 1800, 'Card', 'No'),
('T007', '2026-01-15', 'Internet Bill', 'Utilities', 'Expense', 700, 'UPI', 'Yes'),
('T008', '2026-01-20', 'Restaurant', 'Food', 'Expense', 900, 'UPI', 'No'),
('T009', '2026-02-01', 'Monthly Salary', 'Salary', 'Income', 30000, 'Bank Transfer', 'No'),
('T010', '2026-02-02', 'House Rent', 'Rent', 'Expense', 8000, 'UPI', 'Yes'),
('T011', '2026-02-04', 'Groceries', 'Food', 'Expense', 2800, 'UPI', 'No'),
('T012', '2026-02-06', 'Electricity Bill', 'Utilities', 'Expense', 1500, 'UPI', 'Yes'),
('T013', '2026-02-08', 'Bus Pass', 'Transport', 'Expense', 800, 'Card', 'Yes'),
('T014', '2026-02-12', 'Online Shopping', 'Shopping', 'Expense', 2500, 'Card', 'No'),
('T015', '2026-02-15', 'Internet Bill', 'Utilities', 'Expense', 700, 'UPI', 'Yes'),
('T016', '2026-02-22', 'Restaurant', 'Food', 'Expense', 1200, 'UPI', 'No');

SELECT COUNT(*) AS total_transactions
FROM transactions;

SELECT *
FROM transactions
ORDER BY transaction_date;

USE personal_finance;

INSERT INTO monthly_budget
(budget_month, category, budget)
VALUES
('2026-01-01', 'Rent', 8000),
('2026-01-01', 'Food', 3500),
('2026-01-01', 'Utilities', 2000),
('2026-01-01', 'Transport', 1200),
('2026-01-01', 'Shopping', 1500),
('2026-02-01', 'Rent', 8000),
('2026-02-01', 'Food', 3500),
('2026-02-01', 'Utilities', 2000),
('2026-02-01', 'Transport', 1200),
('2026-02-01', 'Shopping', 1500);

SELECT *
FROM monthly_budget
ORDER BY budget_month, category;

SELECT
    DATE_FORMAT(transaction_date, '%Y-%m') AS month,
    SUM(CASE
        WHEN type = 'Income' THEN amount
        ELSE 0
    END) AS total_income,
    SUM(CASE
        WHEN type = 'Expense' THEN amount
        ELSE 0
    END) AS total_expenses,
    SUM(CASE
        WHEN type = 'Income' THEN amount
        ELSE -amount
    END) AS net_savings
FROM transactions
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY month;

SELECT
    category,
    SUM(amount) AS total_expense
FROM transactions
WHERE type = 'Expense'
GROUP BY category
ORDER BY total_expense DESC;

SELECT
    b.budget_month,
    b.category,
    b.budget,
    COALESCE(SUM(t.amount), 0) AS actual_spending,
    b.budget - COALESCE(SUM(t.amount), 0)
        AS remaining_budget
FROM monthly_budget b
LEFT JOIN transactions t
    ON t.category = b.category
    AND t.type = 'Expense'
    AND t.transaction_date >= b.budget_month
    AND t.transaction_date <
        DATE_ADD(b.budget_month, INTERVAL 1 MONTH)
GROUP BY
    b.budget_id,
    b.budget_month,
    b.category,
    b.budget
ORDER BY b.budget_month, b.category;