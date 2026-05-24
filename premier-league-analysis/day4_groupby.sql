--COUNT ALL TRACKS(Refresher)--
SELECT COUNT (*) AS TotalTracks FROM Track;

--TOTAL REVENUE ACROSS ALL TRACKS(Refresher)--
SELECT SUM(Total) AS TotalRevenue FROM Invoice;

--SMALLEST AND BIGGEST INVOICE(Refresher)--
SELECT
MIN(Total) AS Smallest,
MAX(Total) AS Biggest
FROM Invoice;

--MULTIPLE AGGREGATES AT ONCE ON TRACK TABLE(Refresher)--
SELECT
 COUNT(*) AS TrackCount,
 AVG(UnitPrice) AS AvgPrice,
 MIN(Milliseconds) AS ShortestMS,
 MAX(Milliseconds) AS LongestMS
FROM Track; 

--CUSTOMER PER COUNTRY--
SELECT
    Country,
    COUNT(*) AS CustomerCount
FROM Customer
GROUP BY Country 
ORDER BY CustomerCount DESC;

--REVENUE PER COUNTRY--
SELECT 
    BillingCountry,
    SUM(TOTAL) AS Revenue
FROM Invoice
GROUP BY BillingCountry 
ORDER BY Revenue DESC;

--INVOICE COUNT PER CUSTOMER--
SELECT 
    CustomerId,
    COUNT(*) AS InvoiceCount
FROM Invoice
GROUP BY CustomerId 
ORDER BY InvoiceCount DESC
LIMIT 10;

--IMPROVED: Top customers WITH names (sneak peek at JOIN)--
SELECT 
    Customer.FirstName,
    Customer.LastName,
    Customer.Country,
    COUNT(*) AS InvoiceCount
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName, Customer.Country
ORDER BY InvoiceCount DESC
LIMIT 10;

--AVERAGE TRACK DURATION PER GENRE--
SELECT 
    GenreId,
    AVG(Milliseconds) AS AvgDurationMs,
    AVG(Milliseconds / 60000.0) AS AvgMinutes
FROM Track
GROUP BY GenreId 
ORDER BY AvgMinutes DESC;

--AVERAGE TRACK DURATION PER GENRE(JOIN)--
SELECT
    Genre.GenreId,
    Genre.Name AS GenreName,
    AVG(Milliseconds) AS AvgDurationMs,
    AVG(Milliseconds / 60000.0) AS AvgMinutes
FROM Track
JOIN Genre ON Track.GenreId = Genre.GenreId 
GROUP BY Genre.GenreId, Genre.Name  
ORDER BY AvgMinutes DESC;  

--HOW MANY CUSTOMERS DOES EACH SALES REP HANDLE--
SELECT 
    SupportRepId,
    COUNT(*) AS CustomerCount
FROM Customer
GROUP BY SupportRepId 
ORDER BY CustomerCount DESC;

--HOW MANY CUSTOMERS DOES EACH SALES REP HANDLE(JOIN)--
SELECT
    Employee.EmployeeId,
    Employee.FirstName,
    Employee.LastName,
COUNT(*) AS CustomerCount
FROM Customer
JOIN Employee ON Customer.SupportRepId = Employee.EmployeeId
GROUP BY 
    Employee.EmployeeId,
    Employee.FirstName,
    Employee.LastName
ORDER BY CustomerCount DESC;



  

