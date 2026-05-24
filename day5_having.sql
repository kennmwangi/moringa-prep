--EACH INVOICE WITH CUSTOMER'S NAME--
SELECT 
    Invoice.InvoiceId,
    Customer.FirstName,
    Customer.LastName,
    Invoice.Total
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
LIMIT 10;

--ALL INVOICES FROM BRAZILIAN CUSTOMER'S--
SELECT 
    Customer.FirstName,
    Customer.LastName,
    Customer.Country,
    Invoice.Total,
    Invoice.InvoiceDate
FROM Invoice
JOIN Customer ON Invoice.CustomerId = Customer.CustomerId
WHERE Customer.Country = 'Brazil'
ORDER BY Invoice.Total DESC;

--TOTAL REVENUE PER COUNTRY--
SELECT 
    Customer.Country,
    SUM(Invoice.Total) AS Revenue,
    COUNT(Invoice.InvoiceId) AS InvoiceCount
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.Country
ORDER BY Revenue DESC;

--ONLY COUNTRIES WITH MORE THAN 5 CUSTOMERS--
SELECT Country, COUNT(*) AS CustomerCount
FROM Customer
GROUP BY Country
HAVING COUNT(*) >= 5
ORDER BY CustomerCount DESC;

--HIGH VALUE CUSTOMERS (LIFETIME SPENDING OF >$40)
SELECT 
    CustomerId,
    SUM(Total) AS LifetimeSpending,
    COUNT(*) AS InvoiceCount
FROM Invoice
GROUP BY CustomerId
HAVING SUM(Total) > 40
ORDER BY LifetimeSpending DESC;

--HIGH VALUE CUSTOMER'S WITH NAMES--
SELECT 
    Customer.FirstName,
    Customer.LastName,
    Customer.Country,
    SUM(Invoice.Total) AS LifetimeSpending
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName, Customer.Country
HAVING SUM(Invoice.Total) > 40
ORDER BY LifetimeSpending DESC;

--MAJOR MUSIC GENRES(>100 tracks)
SELECT 
    Genre.Name AS GenreName,
    COUNT(Track.TrackId) AS TrackCount
FROM Genre
JOIN Track ON Genre.GenreId = Track.GenreId
GROUP BY Genre.GenreId, Genre.Name
HAVING COUNT(Track.TrackId) > 100
ORDER BY TrackCount DESC;

--BIG ALBUMS(> 15 TRACKS)
SELECT 
    Album.Title AS AlbumTitle,
    COUNT(Track.TrackId) AS TrackCount
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Album.AlbumId, Album.Title
HAVING COUNT(Track.TrackId) > 15
ORDER BY TrackCount DESC;

--COUNTRIES WITH MULTIPLE HIGH-VALUE INVOICES(>$5 invoices,count>3)
SELECT 
    BillingCountry,
    COUNT(*) AS HighValueInvoices,
    AVG(Total) AS AvgInvoice
FROM Invoice
WHERE Total > 5
GROUP BY BillingCountry
HAVING COUNT(*) > 3
ORDER BY HighValueInvoices DESC;

--TOP 10 MOST BOUGHT TRACKS(TOTAL REVENUE)--
SELECT 
    Track.Name AS TrackName,
    SUM(InvoiceLine.Quantity) AS UnitsSold,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.TrackId, Track.Name
ORDER BY UnitsSold DESC
LIMIT 10;

--TOP 10 MOST BOUGHT TRACKS(UNITS SOLD)--
SELECT 
    Track.Name AS TrackName,
    SUM(InvoiceLine.Quantity) AS UnitsSold
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.TrackId, Track.Name
ORDER BY UnitsSold DESC
LIMIT 10;

--COUNTRIES WITH HIGH-VALUE CUSTOMERS--
SELECT 
    Customer.Country,
    COUNT(DISTINCT Customer.CustomerId) AS HighValueCustomers
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId, Customer.Country
HAVING SUM(Invoice.Total) > 40
ORDER BY HighValueCustomers DESC;

--TOP 5 GENRES IN 2010--
SELECT 
    Genre.Name AS GenreName,
    SUM(InvoiceLine.Quantity) AS UnitsSold,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
FROM Invoice
JOIN InvoiceLine ON Invoice.InvoiceId = InvoiceLine.InvoiceId
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre ON Track.GenreId = Genre.GenreId
WHERE SUBSTR(Invoice.InvoiceDate, 1, 4) = '2010'
GROUP BY Genre.GenreId, Genre.Name
ORDER BY UnitsSold DESC
LIMIT 5;

--UNDERPERFORMING SALES REPS--
SELECT 
    Employee.FirstName,
    Employee.LastName,
    Employee.Title,
    COUNT(Customer.CustomerId) AS CustomerCount
FROM Employee
LEFT JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
WHERE Employee.Title ='Sales Support Agent'
GROUP BY Employee.EmployeeId, Employee.FirstName, Employee.LastName, Employee.Title
HAVING COUNT(Customer.CustomerId)
ORDER BY CustomerCount DESC;

--COUNTRIES WITH MULTPLE BIG INVOICES--
SELECT 
    Invoice.BillingCountry,
    COUNT(*) AS BigInvoices,
    AVG(Invoice.Total) AS AvgBigInvoice,
    SUM(Invoice.Total) AS BigRevenue
FROM Invoice
WHERE Invoice.Total > 10
GROUP BY Invoice.BillingCountry
HAVING COUNT(*) > 3
ORDER BY BigRevenue DESC;

--PROLIFIC ARTISTS (MORE THAN THREE ALBUMS)--
SELECT 
    Artist.Name AS ArtistName,
    COUNT(Album.AlbumId) AS AlbumCount
FROM Artist
JOIN Album ON Artist.ArtistId = Album.ArtistId
GROUP BY Artist.ArtistId, Artist.Name
HAVING COUNT(Album.AlbumId) > 3
ORDER BY AlbumCount DESC;

--SALES REP PERFORMANCE DASHBOARD--
SELECT 
    Employee.FirstName,
    Employee.LastName,
    Employee.Title,
    COUNT(DISTINCT Customer.CustomerId) AS Customers,
    SUM(Invoice.Total) AS Revenue,
    ROUND(AVG(Invoice.Total), 2) AS AvgInvoice,
    COUNT(DISTINCT Customer.Country) AS CountriesServed
FROM Employee
JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY 
    Employee.EmployeeId,
    Employee.FirstName,
    Employee.LastName,
    Employee.Title
HAVING SUM(Invoice.Total) >= 400
ORDER BY Revenue DESC;

--TOP 10 MOST PURCHASED TRACKS--
SELECT 
    Track.Name AS TrackName,
    SUM(InvoiceLine.Quantity) AS UnitsSold,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.TrackId, Track.Name
ORDER BY UnitsSold DESC
LIMIT 10;

--TOP 10 MOST PURCHASED ALBUMS--
SELECT 
    Album.Title AS AlbumTitle,
    SUM(InvoiceLine.Quantity) AS UnitsSold,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
GROUP BY Album.AlbumId, Album.Title
ORDER BY UnitsSold DESC
LIMIT 10;

--TOP 10 MOST-PURCHASED ARTISTS--
SELECT 
    Artist.Name AS ArtistName,
    SUM(InvoiceLine.Quantity) AS UnitsSold,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
GROUP BY Artist.ArtistId, Artist.Name
ORDER BY UnitsSold DESC
LIMIT 10;

--TOP 10 MOST PURCHASED GENRES--
SELECT 
    Genre.Name AS GenreName,
    SUM(InvoiceLine.Quantity) AS UnitsSold,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue,
    COUNT(DISTINCT InvoiceLine.InvoiceId) AS UniqueCustomers
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY Genre.GenreId, Genre.Name
ORDER BY UnitsSold DESC
LIMIT 10;

--BEST-SELLING TRACKS WITH FULL DETAILS--
SELECT 
    Track.Name AS TrackName,
    Album.Title AS AlbumTitle,
    Artist.Name AS ArtistName,
    Genre.Name AS GenreName,
    SUM(InvoiceLine.Quantity) AS UnitsSold,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
JOIN Genre ON Track.GenreId = Genre.GenreId
GROUP BY 
    Track.TrackId,
    Track.Name,
    Album.Title,
    Artist.Name,
    Genre.Name
ORDER BY UnitsSold DESC
LIMIT 20;

--TOP PERFORMING ARTISTS--
SELECT 
    Artist.Name AS ArtistName,
    SUM(InvoiceLine.Quantity) AS UnitsSold
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
GROUP BY Artist.ArtistId, Artist.Name
HAVING SUM(InvoiceLine.Quantity) > 50
ORDER BY UnitsSold DESC;

--UNITS SOLD Vs Revenue--
SELECT
    Artist.Name AS ArtistName,
    SUM(InvoiceLine.Quantity) AS UnitsSold,
    ROUND(AVG(InvoiceLine.UnitPrice), 2) AS AvgPrice,
    SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS Revenue
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
GROUP BY Artist.ArtistId, Artist.Name
ORDER BY UnitsSold DESC
LIMIT 10;

--ARTISTS BY AVERAGE TRACK PRICE--
SELECT
    Artist.Name AS ArtistName,
    COUNT(DISTINCT Track.TrackId) AS TrackCount,
    ROUND(AVG(InvoiceLine.UnitPrice), 2) AS AvgPrice
FROM InvoiceLine
JOIN Track ON InvoiceLine.TrackId = Track.TrackId
JOIN Album ON Track.AlbumId = Album.AlbumId
JOIN Artist ON Album.ArtistId = Artist.ArtistId
GROUP BY Artist.ArtistId, Artist.Name
ORDER BY AvgPrice DESC;