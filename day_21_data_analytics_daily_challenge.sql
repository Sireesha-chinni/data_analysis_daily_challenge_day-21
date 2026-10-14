use dailychallenges_2;


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



-- Task 1:
-- Find claims where claim amount is greater than average claim amount

select * from claims
where claim_amount  > (select avg(claim_amount) from claims);


-- Task 2:
-- Find policy holders who have at least one approved claim

select policy_holder, count(*) as claim_status
from claims
where status = "Approved"
group by policy_holder
having claim_status >=1 ;

select policy_holder from claims
where status = "Approved";


-- Task 3:
-- Find claims where claim amount is greater than that policy holder’s average claim

select * from claims c 
where claim_amount > ( select avg(claim_amount) from claims where policy_holder = c.policy_holder);

-- Task 4:
-- Display each claim along with overall average claim amount

select policy_holder, avg(claim_amount) as avg_claim_amt 
from claims
group by policy_holder;

select *, avg(claim_amount) over() AS overall_avg_claim
FROM claims; 