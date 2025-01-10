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

-- Retrieve Basic Customer Information
SELECT 
    CustomerId,
    FirstName,
    LastName,
    City,
    State,
    Country,
    Email
FROM 
    Customer;


--Aggregate Total Revenue by Customer

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
ORDER BY 
    TotalRevenue DESC;



--Count Purchases Each Customer Has Made
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    COUNT(i.InvoiceId) AS NumberOfPurchases
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
GROUP BY 
    c.CustomerId, c.FirstName, c.LastName
ORDER BY 
    NumberOfPurchases DESC;

--Analyze Revenue by Genre
SELECT 
    g.Name AS Genre,
    SUM(il.Quantity * il.UnitPrice) AS Revenue
FROM 
    InvoiceLine il
JOIN 
    Track t ON il.TrackId = t.TrackId
JOIN 
    Genre g ON t.GenreId = g.GenreId
GROUP BY 
    g.Name
ORDER BY 
    Revenue DESC;

-- Retrieve Tracks Purchased by Each Customer
SELECT 
    c.CustomerId,
    c.FirstName,
    c.LastName,
    t.Name AS TrackName,
    i.InvoiceDate
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
JOIN 
    InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN 
    Track t ON il.TrackId = t.TrackId
ORDER BY 
    c.CustomerId, i.InvoiceDate;

--Monthly Revenue Analysis
SELECT 
    strftime('%Y-%m', i.InvoiceDate) AS YearMonth,
    SUM(i.Total) AS MonthlyRevenue
FROM 
    Invoice i
GROUP BY 
    YearMonth
ORDER BY 
    YearMonth;

--Top Spending Cities
SELECT 
    c.City,
    c.Country,
    SUM(i.Total) AS CityRevenue
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
GROUP BY 
    c.City, c.Country
ORDER BY 
    CityRevenue DESC;

--Identify Customers with No Purchases

