--INVOICES THAT ARE ABOVE VALUE--
SELECT 
    InvoiceId,
    Total,
    BillingCountry
FROM Invoice
WHERE Total > (SELECT AVG(Total) FROM Invoice)
ORDER BY Total DESC;

--CUSTOMERS FROM THE COUNTRY WITH THE LARGEST CUSTOMER BASE--
SELECT
    FirstName,
    LastName,
    Country
FROM Customer
WHERE Country = (
    SELECT Country 
    FROM Customer
    GROUP BY Country 
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

--CUSTOMERS FROM THE COUNTRY WITH THE SMALLEST CUSTOMER BASE--
SELECT
    FirstName,
    LastName,
    Country
FROM Customer
WHERE Country = (
    SELECT Country 
    FROM Customer
    GROUP BY Country 
    ORDER BY COUNT(*) ASC
    LIMIT 1
);

--TRACKS LONGER THAN AVERAGE TRACK--
SELECT 
    Name AS TrackName,
    Milliseconds,
    ROUND(Milliseconds / 60000.0, 2) AS Minutes
FROM Track
WHERE Milliseconds > (SELECT AVG(Milliseconds) FROM Track)
ORDER BY Milliseconds DESC
LIMIT 20;

--INVOICES FROM MAJOR MARKETS(Countries with >5 customers)
SELECT
    InvoiceId,
    BillingCountry,
    Total
FROM Invoice
WHERE BillingCountry IN(
    SELECT Country
    FROM Customer
    GROUP BY Country
    HAVING COUNT(*) >5
)
ORDER BY Total DESC; 

--ABOVE AVERAGE SPENDERS--
SELECT 
    Customer.FirstName,
    Customer.LastName,
    SUM(Invoice.Total) AS LifetimeSpending
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName
HAVING SUM(Invoice.Total) > (
    SELECT AVG(CustomerSpending)
    FROM (
        SELECT SUM(Total) AS CustomerSpending
        FROM Invoice
        GROUP BY CustomerId
    ) AS spending
)
ORDER BY LifetimeSpending DESC;


--SUBQUERY WITH (IN)--
SELECT FirstName, LastName, Country
FROM Customer
WHERE CustomerId IN (
    SELECT DISTINCT CustomerId FROM Invoice
);

--SUBQUERY JOIN with DISTINCT--
SELECT DISTINCT 
    Customer.FirstName, 
    Customer.LastName, 
    Customer.Country
FROM Customer
JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId;

--SUBQUERY WITH NOT IN(Customers who have bought nothing)--
SELECT FirstName, LastName,Country
FROM Customer
WHERE CustomerId NOT IN (
    SELECT DISTINCT CustomerId FROM Invoice     
);

--LEFT JOIN With IS NULL trick--
SELECT 
    Customer.FirstName, 
    Customer.LastName, 
    Customer.Country
FROM Customer
LEFT JOIN Invoice ON Customer.CustomerId = Invoice.CustomerId
WHERE Invoice.InvoiceId IS NULL;

--TRACKS PRICED ABOVE AVERAGE--
SELECT 
    Name AS TrackName,
    UnitPrice
FROM Track
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Track)
ORDER BY UnitPrice DESC;

--BIG SPENDERS ($40+ lifetime) using subquery
SELECT 
    Customer.FirstName,
    Customer.LastName,
    Customer.Country
FROM Customer
WHERE Customer.CustomerId IN (
    SELECT CustomerId
    FROM Invoice
    GROUP BY CustomerId
    HAVING SUM(Total) > 40
);

--ALBUM BY THE MOST PROLOFIC ARTIST--
SELECT 
    Album.Title AS AlbumTitle
FROM Album
WHERE Album.ArtistId = (
    SELECT ArtistId
    FROM Album
    GROUP BY ArtistId
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

--ALBUM BY THE LEAST PROLOFIC ARTIST--
SELECT 
    Album.Title AS AlbumTitle
FROM Album
WHERE Album.ArtistId = (
    SELECT ArtistId
    FROM Album
    GROUP BY ArtistId
    ORDER BY COUNT(*) ASC
    LIMIT 1
);

--ALBUM BY THE MOST PROLOFIC ARTIST(Includes Artist Name)--
SELECT 
    Artist.Name AS ArtistName,
    Album.Title AS AlbumTitle
FROM Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId
WHERE Album.ArtistId = (
    SELECT ArtistId
    FROM Album
    GROUP BY ArtistId
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

--ALBUM BY THE LEAST PROLOFIC ARTIST(Includes Artist Name)--
SELECT 
    Artist.Name AS ArtistName,
    Album.Title AS AlbumTitle
FROM Album
JOIN Artist ON Album.ArtistId = Artist.ArtistId
WHERE Album.ArtistId = (
    SELECT ArtistId
    FROM Album
    GROUP BY ArtistId
    ORDER BY COUNT(*) ASC
    LIMIT 1
);

--TRACKS FROM THE MOST-STOCKED GENRE-- 
SELECT 
    Track.Name AS TrackName,
    Track.UnitPrice
FROM Track
WHERE Track.GenreId = (
    SELECT GenreId
    FROM Track
    GROUP BY GenreId
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
LIMIT 20;

--CUSTOMERS IN GROWING MARKETS--
SELECT 
    FirstName,
    LastName,
    Country
FROM Customer
WHERE Country IN (
    SELECT Country
    FROM Customer
    GROUP BY Country
    HAVING COUNT(*) > (
        SELECT AVG(country_count)
        FROM (
            SELECT COUNT(*) AS country_count
            FROM Customer
            GROUP BY Country
        ) AS counts
    )
);