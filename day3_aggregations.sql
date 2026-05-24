--COUNT ALL ROWS IN THE TABLE--
SELECT COUNT(*) FROM Customer;

--COUNT ROWS IN A SPECIFIC COLUMN (excludes NULLs) --
SELECT COUNT(Email) FROM Customer;

--COUNT UNIQUE VALUES IN A COLUMN--
SELECT COUNT (DISTINCT Country)FROM Customer;

--COUNT ALL TRACKS IN DATABASE--
SELECT COUNT(*) FROM Track;

--COUNT ALL INVOICES PROCESSED--
SELECT COUNT(*) FROM Invoice;

--COUNT UNIQUE ARTISTS--
SELECT COUNT(DISTINCT ArtistId) FROM Album;

--TOTAL REVENUE ACROSS ALL INVOICES--
SELECT SUM(Total) FROM Invoice;

--AVERAGE INVOICE VALUE--
SELECT AVG (Total) FROM Invoice;

--SMALLEST AND LARGEST INVOICE--
SELECT MIN(Total), MAX(Total) FROM Invoice;

--COLUMN HEADER--
SELECT 
    SUM(Total) AS TotalRevenue,
    AVG(Total) AS AverageInvoice,
    MIN(Total) AS SmallestInvoice,
    MAX(Total) AS LargestInvoice
FROM Invoice;

--TOTAL REVENUE--
SELECT SUM(Total) AS TotalRevenue FROM Invoice;

--AVERAGE TRACK LENGTH IN MINUTES(Milliseconds/60000)
SELECT AVG(Milliseconds / 60000.0) AS AvgMinutes FROM Track;

--MOST EXPENSIVE TRACK--
SELECT MAX(UnitPrice) AS MaxPrice FROM Track;

--ALL SUMMARY STATS FOR TRACKS (Use AS For Each)
SELECT 
    COUNT(*) AS TotalTracks,
    AVG(Milliseconds) AS AvgDuration,
    MIN(UnitPrice) AS CheapestPrice,
    MAX(UnitPrice) AS PriciestPrice
FROM Track;


