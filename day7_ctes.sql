--TESTING VS CODE → DBeaver Workflow--
SELECT * FROM Customer LIMIT 5;

-- ============================================

--CUSTOMERS WITH THEIR LIFETIME SPENDING--
WITH customer_totals AS (
    SELECT
        CustomerId,
        SUM(Total) AS LifetimeSpending,
        COUNT(*) AS InvoiceCount
    FROM Invoice
    GROUP BY CustomerId
)

SELECT
    Customer.FirstName,
    Customer.LastName,
    customer_totals.LifetimeSpending,
    customer_totals.InvoiceCount
FROM Customer
JOIN customer_totals ON Customer.CustomerId = customer_totals.CustomerId
ORDER BY customer_totals.LifetimeSpending DESC
LIMIT 10;

-- ============================================

--TOP COUNTRIES BY BOTH CUSTOMER COUNT AND REVENUE--
WITH country_customers AS (
    SELECT Country, COUNT(*) AS customer_count
    FROM Customer
    GROUP BY Country
),
country_revenue AS (
    SELECT BillingCountry AS Country, SUM(Total) AS revenue
    FROM Invoice
    GROUP BY BillingCountry
)

SELECT 
    country_customers.Country,
    country_customers.customer_count,
    country_revenue.revenue
FROM country_customers
JOIN country_revenue ON country_customers.Country = country_revenue.Country
ORDER BY country_revenue.revenue DESC
LIMIT 10;

-- ============================================

--ABOVE-AVERAGE CUSTOMERS (cleaner than nested subqueries)--
WITH customer_spending AS (
    SELECT CustomerId, SUM(Total) AS total_spent
    FROM Invoice
    GROUP BY CustomerId
),
spending_average AS (
    SELECT AVG(total_spent) AS avg_amount
    FROM customer_spending
)

SELECT 
    Customer.FirstName,
    Customer.LastName,
    customer_spending.total_spent,
    spending_average.avg_amount
FROM Customer
JOIN customer_spending ON Customer.CustomerId = customer_spending.CustomerId
CROSS JOIN spending_average
WHERE customer_spending.total_spent > spending_average.avg_amount
ORDER BY customer_spending.total_spent DESC;

-- ============================================

--TOP 10 ARTISTS BY UNITS SOLD (CTE version)--
WITH artist_sales AS (
    SELECT 
        Album.ArtistId,
        SUM(InvoiceLine.Quantity) AS UnitsSold,
        SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
    FROM InvoiceLine
    JOIN Track ON InvoiceLine.TrackId = Track.TrackId
    JOIN Album ON Track.AlbumId = Album.AlbumId
    GROUP BY Album.ArtistId
)

SELECT 
    Artist.Name AS ArtistName,
    artist_sales.UnitsSold,
    artist_sales.Revenue
FROM artist_sales
JOIN Artist ON artist_sales.ArtistId = Artist.ArtistId
ORDER BY artist_sales.UnitsSold DESC
LIMIT 10;

-- ============================================

--SALES REP PERFORMANCE DASHBOARD WITH CTEs--
WITH rep_performance AS (
    SELECT 
        Customer.SupportRepId AS EmployeeId,
        COUNT(DISTINCT Customer.CustomerId) AS Customers,
        SUM(Invoice.Total) AS Revenue,
        AVG(Invoice.Total) AS AvgInvoice,
        COUNT(Invoice.InvoiceId) AS InvoicesClosed
    FROM Customer
    JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Customer.SupportRepId
)

SELECT 
    Employee.FirstName,
    Employee.LastName,
    Employee.Title,
    rep_performance.Customers,
    ROUND(rep_performance.Revenue, 2) AS Revenue,
    ROUND(rep_performance.AvgInvoice, 2) AS AvgInvoice,
    rep_performance.InvoicesClosed
FROM rep_performance
JOIN Employee ON rep_performance.EmployeeId = Employee.EmployeeId
ORDER BY rep_performance.Revenue DESC;

-- ============================================

--HIGHEST SPENDING CUSTOMER PER COUNTRY--
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
country_max_spending AS (
    SELECT Country, MAX(TotalSpent) AS MaxSpent
    FROM customer_country_spending
    GROUP BY Country
)

SELECT 
    ccs.Country,
    ccs.FirstName,
    ccs.LastName,
    ccs.TotalSpent
FROM customer_country_spending ccs
JOIN country_max_spending cms 
    ON ccs.Country = cms.Country 
    AND ccs.TotalSpent = cms.MaxSpent
ORDER BY ccs.TotalSpent DESC;

-- ============================================

--EACH GENRE'S % SHARE OF TOTAL REVENUE--
WITH genre_revenue AS (
    SELECT 
        Genre.Name AS GenreName,
        SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
    FROM InvoiceLine
    JOIN Track ON InvoiceLine.TrackId = Track.TrackId
    JOIN Genre ON Track.GenreId = Genre.GenreId
    GROUP BY Genre.GenreId, Genre.Name
),
total_rev AS (
    SELECT SUM(Revenue) AS TotalRevenue FROM genre_revenue
)

SELECT 
    gr.GenreName,
    ROUND(gr.Revenue, 2) AS Revenue,
    ROUND((gr.Revenue / tr.TotalRevenue) * 100, 2) AS PercentShare
FROM genre_revenue gr
CROSS JOIN total_rev tr
ORDER BY gr.Revenue DESC;

-- ============================================

--YEAR OVER YEAR REVENUE GROWTH--
WITH yearly_revenue AS (
    SELECT 
        SUBSTR(InvoiceDate, 1, 4) AS Year,
        SUM(Total) AS Revenue
    FROM Invoice
    GROUP BY Year
)

SELECT 
    Year,
    ROUND(Revenue, 2) AS Revenue
FROM yearly_revenue
ORDER BY Year;

-- ============================================

--BEST SELLING ALBUM EACH YEAR--
WITH album_yearly_sales AS (
    SELECT 
        SUBSTR(Invoice.InvoiceDate, 1, 4) AS Year,
        Album.Title AS AlbumTitle,
        SUM(InvoiceLine.Quantity) AS UnitsSold
    FROM InvoiceLine
    JOIN Track ON InvoiceLine.TrackId = Track.TrackId
    JOIN Album ON Track.AlbumId = Album.AlbumId
    JOIN Invoice ON InvoiceLine.InvoiceId = Invoice.InvoiceId
    GROUP BY Year, Album.AlbumId, Album.Title
),
yearly_max AS (
    SELECT Year, MAX(UnitsSold) AS MaxSold
    FROM album_yearly_sales
    GROUP BY Year
)

SELECT 
    ays.Year,
    ays.AlbumTitle,
    ays.UnitsSold
FROM album_yearly_sales ays
JOIN yearly_max ym 
    ON ays.Year = ym.Year 
    AND ays.UnitsSold = ym.MaxSold
ORDER BY ays.Year;

-- ============================================

--CUSTOMER SEGMENTATION BY LIFETIME SPENDING Premium ($40+), Regular ($20-40), or Casual (under $20)--
WITH customer_totals AS (
    SELECT 
        CustomerId,
        SUM(Total) AS LifetimeSpending
    FROM Invoice
    GROUP BY CustomerId
)

SELECT 
    Customer.FirstName,
    Customer.LastName,
    Customer.Country,
    customer_totals.LifetimeSpending,
    CASE 
        WHEN customer_totals.LifetimeSpending >= 40 THEN 'Premium'
        WHEN customer_totals.LifetimeSpending >= 20 THEN 'Regular'
        ELSE 'Casual'
    END AS CustomerSegment
FROM Customer
JOIN customer_totals ON Customer.CustomerId = customer_totals.CustomerId
ORDER BY customer_totals.LifetimeSpending DESC;