-- ============================================
--NUMBER INVOICES IN CHRONOLOGICAL ORDER--
SELECT 
    InvoiceId,
    InvoiceDate,
    Total,
    ROW_NUMBER() OVER (ORDER BY InvoiceDate) AS InvoiceNumber
FROM Invoice
LIMIT 10;

-- ============================================

-- ============================================
--TOP 3 CUSTOMERS PER COUNTRY (RANKED)--
WITH customer_country_spending AS (
    SELECT 
        Customer.Country,
        Customer.FirstName,
        Customer.LastName,
        SUM(Invoice.Total) AS TotalSpent
    FROM Customer
    JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Customer.CustomerId, Customer.Country, Customer.FirstName, Customer.LastName
),
ranked_customers AS (
    SELECT 
        Country,
        FirstName,
        LastName,
        TotalSpent,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY TotalSpent DESC) AS RankInCountry
    FROM customer_country_spending
)

SELECT 
    Country,
    FirstName,
    LastName,
    ROUND(TotalSpent, 2) AS TotalSpent,
    RankInCountry
FROM ranked_customers
WHERE RankInCountry <= 3
ORDER BY Country, RankInCountry;

-- ============================================

-- ============================================
--COMPARE ROW_NUMBER, RANK, DENSE_RANK--
WITH customer_spending AS (
    SELECT 
        Customer.FirstName,
        Customer.LastName,
        SUM(Invoice.Total) AS Spending
    FROM Customer
    JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
)

SELECT 
    FirstName,
    LastName,
    ROUND(Spending, 2) AS Spending,
    ROW_NUMBER() OVER (ORDER BY Spending DESC) AS RowNum,
    RANK() OVER (ORDER BY Spending DESC) AS Rank,
    DENSE_RANK() OVER (ORDER BY Spending DESC) AS DenseRank
FROM customer_spending
ORDER BY Spending DESC
LIMIT 15;

-- ============================================

-- ============================================
--MONTHLY REVENUE WITH RUNNING TOTAL--
WITH monthly_revenue AS (
    SELECT 
        SUBSTR(InvoiceDate, 1, 7) AS Month,
        SUM(Total) AS MonthRevenue
    FROM Invoice
    GROUP BY Month
)

SELECT 
    Month,
    ROUND(MonthRevenue, 2) AS MonthRevenue,
    ROUND(SUM(MonthRevenue) OVER (ORDER BY Month), 2) AS RunningTotal
FROM monthly_revenue
ORDER BY Month;

-- ============================================

-- ============================================
--MONTH-OVER-MONTH REVENUE CHANGE(using LAG)--
WITH monthly_revenue AS (
    SELECT 
        SUBSTR(InvoiceDate, 1, 7) AS Month,
        SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY Month
)

SELECT 
    Month,
    ROUND(Revenue, 2) AS Revenue,
    ROUND(LAG(Revenue) OVER (ORDER BY Month), 2) AS PreviousMonth,
    ROUND(Revenue - LAG(Revenue) OVER (ORDER BY Month), 2) AS Change,
    ROUND(
        ((Revenue - LAG(Revenue) OVER (ORDER BY Month)) / LAG(Revenue) OVER (ORDER BY Month)) * 100, 
        2
    ) AS PercentChange
FROM monthly_revenue
ORDER BY Month;

-- ============================================

-- ============================================
--CUSTOMER SPENDING VS COUNTRY AVERAGE--
WITH customer_spending AS (
    SELECT 
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Customer.Country,
        SUM(Invoice.Total) AS TotalSpent
    FROM Customer
    JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName, Customer.Country
)

SELECT 
    Country,
    FirstName,
    LastName,
    ROUND(TotalSpent, 2) AS TotalSpent,
    ROUND(AVG(TotalSpent) OVER (PARTITION BY Country), 2) AS CountryAvg,
    ROUND(TotalSpent - AVG(TotalSpent) OVER (PARTITION BY Country), 2) AS DiffFromAvg
FROM customer_spending
ORDER BY Country, TotalSpent DESC;

-- ============================================

-- ============================================
--CUSTOMER QUARTILES BY SPENDING--
WITH customer_spending AS (
    SELECT 
        Customer.FirstName,
        Customer.LastName,
        SUM(Invoice.Total) AS TotalSpent
    FROM Customer
    JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
)

SELECT 
    FirstName,
    LastName,
    ROUND(TotalSpent, 2) AS TotalSpent,
    NTILE(4) OVER (ORDER BY TotalSpent DESC) AS Quartile
FROM customer_spending
ORDER BY TotalSpent DESC;

-- ============================================

-- ============================================
--COMPLETE CUSTOMER ANALYTICS DASHBOARD--
WITH customer_spending AS (
    SELECT 
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Customer.Country,
        SUM(Invoice.Total) AS TotalSpent,
        COUNT(Invoice.InvoiceId) AS InvoiceCount
    FROM Customer
    JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName, Customer.Country
)

SELECT 
    FirstName,
    LastName,
    Country,
    ROUND(TotalSpent, 2) AS Spending,
    InvoiceCount,
    ROW_NUMBER() OVER (ORDER BY TotalSpent DESC) AS GlobalRank,
    ROW_NUMBER() OVER (PARTITION BY Country ORDER BY TotalSpent DESC) AS CountryRank,
    ROUND(AVG(TotalSpent) OVER (PARTITION BY Country), 2) AS CountryAvg,
    NTILE(4) OVER (ORDER BY TotalSpent DESC) AS Quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY TotalSpent DESC) = 1 THEN 'Premium'
        WHEN NTILE(4) OVER (ORDER BY TotalSpent DESC) = 2 THEN 'High Value'
        WHEN NTILE(4) OVER (ORDER BY TotalSpent DESC) = 3 THEN 'Regular'
        ELSE 'Casual'
    END AS Segment
FROM customer_spending
ORDER BY GlobalRank;

-- ============================================
