use loan;

SELECT COUNT(*) AS total_rows
FROM loans_data;

SELECT * FROM loans_data;

 -- 1 the specified loan data statistics from the 'loans_data' table between 0.06 and 0.26
SELECT
    COUNT(*) AS loan_count,
    AVG(rate) AS average_interest_rate,
    MIN(rate) AS min_interest_rate,
    MAX(rate) AS max_interest_rate,
    AVG(loan_amount) AS average_loan_amount,
    MIN(loan_amount) AS min_loan_amount,
    MAX(loan_amount) AS max_loan_amount
FROM
    loans_data
WHERE
    rate BETWEEN 0.06 AND 0.26;

	-- 2. aggregate loan amounts by employment status
SELECT
    employment,
    SUM(loan_amount) AS total_loan
FROM
    loans_data
GROUP BY
    employment
ORDER BY
    employment ASC;

-- 3. count loans by duration and status 
SELECT
    duration,
    status,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    duration, status
ORDER BY
    duration ASC, status ASC;

 -- 4.analyze loans by employment status
SELECT
    employment,
    AVG(rate) AS average_interest_rate,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    employment
ORDER BY
    employment ASC;

-- 5. analyze loans by home ownership
SELECT
    home_owner,
    AVG(rate) AS average_interest_rate,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    home_owner
ORDER BY
    home_owner ASC;

	--6. analyze loans by Prosper rating
SELECT
    prosper,
    AVG(rate) AS average_interest_rate,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    prosper
ORDER BY
    prosper ASC;
 -- 7.  analyze loans by loan amount
SELECT
    loan_amount,
    AVG(payment) AS average_payment,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    loan_amount
ORDER BY
    loan_amount ASC;

 -- 8.analyze loans by the number of investors 
SELECT
    investors,
    AVG(rate) AS average_interest_rate,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    investors
ORDER BY
    investors ASC;

-- 9. analyze loans by duration and return rate 
SELECT
    duration,
    AVG("return") AS average_return_rate,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    duration
ORDER BY
    duration ASC;

 -- 10. analyze loans by Prosper rating and return rate
SELECT
    prosper,
    AVG("return") AS average_return_rate,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    prosper
ORDER BY
    prosper ASC;

	-- 11.the default rate for each Prosper rating, providing insights into how creditworthiness impacts loan outcomes
SELECT
    prosper,
    COUNT(*) AS total_loans,
    SUM(CASE WHEN status = 'Chargedoff' THEN 1 ELSE 0 END) AS defaulted_loans,
    AVG(rate) AS average_interest_rate,
    (SUM(CASE WHEN status = 'Chargedoff' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS DECIMAL(10,2))) * 100 AS default_rate_percentage
FROM
    loans_data
GROUP BY
    prosper
ORDER BY
    prosper ASC;

	-- 12. Analyze the distribution of monthly loan payments for each Prosper rating.
SELECT DISTINCT
    prosper,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY payment) OVER (PARTITION BY prosper) AS median_payment,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY payment) OVER (PARTITION BY prosper) AS q1_payment,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY payment) OVER (PARTITION BY prosper) AS q3_payment
FROM
    loans_data
ORDER BY
    prosper ASC;

-- 13. Explore the relationship between the number of investors and loan status.
SELECT
    status,
    AVG(investors) AS average_investors,
    COUNT(*) AS total_loans
FROM
    loans_data
GROUP BY
    status
ORDER BY
    total_loans DESC;

-- 14.Investigate the distribution of loan amounts for different employment statuses.
SELECT
    DISTINCT employment,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY loan_amount) OVER (PARTITION BY employment) AS median_loan_amount,
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY loan_amount) OVER (PARTITION BY employment) AS q1_loan_amount,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY loan_amount) OVER (PARTITION BY employment) AS q3_loan_amount
FROM
    loans_data
ORDER BY
    employment ASC;

-- 15.Investigate transitions between different loan statuses.
SELECT
    prev_status,
    status,
    COUNT(*) AS transition_count
FROM (
    SELECT
        status,
        LAG(status) OVER (ORDER BY status) AS prev_status
    FROM
        loans_data
) AS status_transitions
WHERE
    prev_status IS NOT NULL
GROUP BY
    prev_status, status
ORDER BY
    prev_status, status;

	-- 16.Examine the relationship between interest rates, yields, and Prosper ratings
SELECT
    prosper,
    AVG(rate) AS average_interest_rate,
    AVG(yield) AS average_yield
FROM
    loans_data
GROUP BY
    prosper
ORDER BY
    prosper ASC;

	-- 17.Investigate the relationship between loan amounts and employment status.
SELECT
    employment,
    AVG(loan_amount) AS average_loan_amount
FROM
    loans_data
GROUP BY
    employment
ORDER BY
    employment ASC;

	-- 18.Explore the diversity of investors by analyzing the distribution of unique investors across loans
SELECT
    COUNT(DISTINCT investors) AS unique_investors_count,
    COUNT(*) AS total_loans
FROM
    loans_data;

-- 19.Examine the relationship between loan amounts, returns, and home ownership status
SELECT
    home_owner,
    AVG(loan_amount) AS average_loan_amount,
    AVG("return") AS average_return
FROM
    loans_data
GROUP BY
    home_owner
ORDER BY
    home_owner ASC;
-- 20.Explore the distribution of loan statuses for each Prosper rating
SELECT
    prosper,
    status,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    prosper, status
ORDER BY
    prosper ASC, loan_count DESC;

-- 21.Analyze the trend of loan performance over both Prosper rating and loan duration.
SELECT
    prosper,
    duration,
    status,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    prosper, duration, status
ORDER BY
    prosper ASC, duration ASC, loan_count DESC;

-- 22.Examine the correlation between the number of investors and Prosper ratings.
SELECT
    prosper,
    AVG(investors) AS average_investors
FROM
    loans_data
GROUP BY
    prosper
ORDER BY
    prosper ASC;

	-- 24.Explore the correlation between loan amounts and interest rates.
SELECT
    loan_amount,
    AVG(rate) AS average_interest_rate
FROM
    loans_data
GROUP BY
    loan_amount
ORDER BY
    loan_amount ASC;
-- 24.Explore the correlation between loan amounts and monthly payments, considering Prosper rating and home ownership.
SELECT
    prosper,
    home_owner,
    AVG(loan_amount) AS average_loan_amount,
    AVG(payment) AS average_payment
FROM
    loans_data
GROUP BY
    prosper, home_owner
ORDER BY
    prosper ASC, home_owner ASC;
-- 25.Examine the relationship between loan status, return rates, Prosper rating, and employment status.
SELECT
    prosper,
    employment,
    status,
    AVG("return") AS average_return_rate,
    COUNT(*) AS loan_count
FROM
    loans_data
GROUP BY
    prosper, employment, status
ORDER BY
    prosper ASC, employment ASC, loan_count DESC;
