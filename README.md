# Day 21 – Insurance Claims Analysis (SQL Subqueries)

A real-world SQL coding challenge on **subqueries** using an insurance claims dataset.

## Files

| File | Description |
|------|-------------|
| `Day21_CodingChallenge.pdf` | Original challenge statement |
| `day_21_data_analytics_daily_challenge.sql` | Table setup, sample data, and solutions |
| `README.md` | This document |

## Concepts Covered

- Scalar subqueries (`WHERE col > (SELECT AVG(...))`)
- Correlated subqueries
- Filtering with `WHERE` / `HAVING`
- Aggregates with `GROUP BY`
- Window functions (alternative approach)

## Dataset

**Table: `claims`**

| Column | Type | Description |
|--------|------|-------------|
| `claim_id` | INT | Unique claim identifier |
| `policy_holder` | VARCHAR(50) | Name of the policy holder |
| `policy_type` | VARCHAR(50) | Health / Vehicle / Life |
| `claim_amount` | INT | Amount claimed |
| `claim_date` | DATE | Date the claim was filed |
| `status` | VARCHAR(20) | Approved / Rejected |

**Sample data (8 rows)**

| claim_id | policy_holder | policy_type | claim_amount | claim_date | status |
|----------|---------------|-------------|--------------|------------|--------|
| 1 | Ravi | Health | 50000 | 2024-01-10 | Approved |
| 2 | Anita | Vehicle | 20000 | 2024-01-12 | Rejected |
| 3 | Ravi | Health | 30000 | 2024-01-20 | Approved |
| 4 | Suresh | Life | 100000 | 2024-01-25 | Approved |
| 5 | Anita | Vehicle | 15000 | 2024-02-01 | Approved |
| 6 | Kiran | Health | 40000 | 2024-02-10 | Rejected |
| 7 | Ravi | Health | 70000 | 2024-02-15 | Approved |
| 8 | Suresh | Life | 50000 | 2024-02-20 | Rejected |

Overall average claim amount: **46,875**

## Setup

```sql
USE dailychallenges_2;

CREATE TABLE claims (
    claim_id INT,
    policy_holder VARCHAR(50),
    policy_type VARCHAR(50),
    claim_amount INT,
    claim_date DATE,
    status VARCHAR(20)
);

INSERT INTO claims VALUES
(1, 'Ravi', 'Health', 50000, '2024-01-10', 'Approved'),
(2, 'Anita', 'Vehicle', 20000, '2024-01-12', 'Rejected'),
(3, 'Ravi', 'Health', 30000, '2024-01-20', 'Approved'),
(4, 'Suresh', 'Life', 100000, '2024-01-25', 'Approved'),
(5, 'Anita', 'Vehicle', 15000, '2024-02-01', 'Approved'),
(6, 'Kiran', 'Health', 40000, '2024-02-10', 'Rejected'),
(7, 'Ravi', 'Health', 70000, '2024-02-15', 'Approved'),
(8, 'Suresh', 'Life', 50000, '2024-02-20', 'Rejected');
```

## Tasks & Solutions

### Task 1 – Claims above the overall average

Find claims where the claim amount is greater than the average claim amount.

```sql
SELECT *
FROM claims
WHERE claim_amount > (SELECT AVG(claim_amount) FROM claims);
```

**Approach:** A scalar subquery computes the overall average (46,875) once, and the outer query filters rows against it.

**Expected result:** claim IDs `1, 4, 7, 8`

---

### Task 2 – Policy holders with at least one approved claim

```sql
SELECT DISTINCT policy_holder
FROM claims
WHERE status = 'Approved';
```

**Approach:** Filter to approved claims, then return each policy holder once. (`GROUP BY policy_holder HAVING COUNT(*) >= 1` also works, but `DISTINCT` is simpler, since any holder appearing after the `WHERE` filter already has at least one approved claim.)

**Expected result:** `Ravi`, `Anita`, `Suresh` (Kiran is excluded, as all of Kiran's claims were rejected)

---

### Task 3 – Claims above that policy holder's own average

```sql
SELECT *
FROM claims c
WHERE claim_amount > (
    SELECT AVG(claim_amount)
    FROM claims
    WHERE policy_holder = c.policy_holder
);
```

**Approach:** A **correlated subquery**: for each row in the outer query, the inner query recalculates the average for that row's policy holder (`c.policy_holder`).

| Policy holder | Their average |
|---------------|---------------|
| Ravi | 50,000 |
| Anita | 17,500 |
| Suresh | 75,000 |
| Kiran | 40,000 |

**Expected result:** claim IDs `2, 4, 7`

---

### Task 4 – Each claim with the overall average

Display each claim along with the overall average claim amount.

```sql
-- Option A: scalar subquery in SELECT
SELECT c.*,
       (SELECT AVG(claim_amount) FROM claims) AS overall_avg_claim
FROM claims c;

-- Option B: window function
SELECT *,
       AVG(claim_amount) OVER () AS overall_avg_claim
FROM claims;
```

**Approach:** The overall average is a single value, so it is repeated on every row alongside the claim details. Using `GROUP BY policy_holder` would instead collapse the rows into per-holder averages and lose the individual claims, so it does not answer this task.

**Expected result:** all 8 claims, each with `overall_avg_claim = 46875.0000`

## Key Takeaways

- A **scalar subquery** returns one value and can be used in `WHERE` or `SELECT`.
- A **correlated subquery** references the outer query and runs once per outer row.
- To show row-level detail next to an aggregate, use a subquery or a window function instead of `GROUP BY`.

## How to Run

1. Open MySQL Workbench (or any MySQL client).
2. Run the setup script to create and populate `claims`.
3. Run each task query and compare with the expected results above.
