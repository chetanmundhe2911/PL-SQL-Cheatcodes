--DO not change anything in below query just run it as it is

SELECT 
    m.name AS TableName,
    p.name AS ColumnName,
    p.type AS DataType
FROM 
    sqlite_master m
JOIN 
    pragma_table_info(m.name) p
WHERE 
    m.type = 'table'
ORDER BY 
    TableName, p.cid;


--Query to Find Top 10% Revenue Contributors
WITH CustomerRevenue AS (
    -- Step 1: Calculate total revenue for each customer
    SELECT 
        c.CustomerId,
        c.FirstName,
        c.LastName,
        SUM(i.Total) AS TotalRevenue
    FROM 
        Customer c
    JOIN 
        Invoice i ON c.CustomerId = i.CustomerId
    GROUP BY 
        c.CustomerId, c.FirstName, c.LastName
),
RankedCustomers AS (
    -- Step 2: Rank customers by their total revenue in descending order
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY TotalRevenue DESC) AS Rank
    FROM 
        CustomerRevenue
),
TopTenPercent AS (
    -- Step 3: Calculate the cutoff rank for the top 10% of contributors
    SELECT
        MAX(Rank) * 0.10 AS TopPercentCutoff
    FROM 
        RankedCustomers
)
-- Step 4: Select only customers in the top 10%
SELECT 
    r.CustomerId,
    r.FirstName,
    r.LastName,
    r.TotalRevenue
FROM 
    RankedCustomers r
CROSS JOIN 
    TopTenPercent t
WHERE 
    r.Rank <= t.TopPercentCutoff
ORDER BY 
    r.TotalRevenue DESC;

-- 
