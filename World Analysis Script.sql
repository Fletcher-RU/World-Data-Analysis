SELECT * FROM country;
SELECT * FROM countrylanguage;
SELECT * FROM city; 
-- Calculate the population density for each country(Population / SurfaceArea).
SELECT NAME, ROUND((Population / SurfaceArea), 2) AS PopDensity
FROM country;

-- Categorize countries into Highly Dense, Moderately Dense, and Sparsely Populated. 

WITH CountryDensity AS (
    SELECT Name, (Population / SurfaceArea) AS PopDensity,
           CASE
               WHEN (Population / SurfaceArea) > 200 THEN "Highly Dense"
               WHEN (Population / SurfaceArea) > 20 THEN "Moderately Dense"
               ELSE "Sparsely Populated"
           END AS DensityCategory
    FROM Country
)
SELECT Name, PopDensity, DensityCategory
FROM CountryDensity;

-- Calculate the amount of countries within each category
WITH CountryDensity AS (
    SELECT Name, (Population / SurfaceArea) AS PopDensity,
           CASE
               WHEN (Population / SurfaceArea) > 200 THEN "Highly Dense"
               WHEN (Population / SurfaceArea) > 20 THEN "Moderately Dense"
               ELSE "Sparsely Populated"
           END AS DensityCategory
    FROM Country
)
SELECT DensityCategory, COUNT(*) AS CategoryCount
FROM CountryDensity
GROUP BY DensityCategory;

-- Find the Most Spoken Language in Each Country
-- Identify the most spoken language (by percentage) in each country.
SELECT * FROM countrylanguage;

SELECT * FROM country;

-- Creates an inner join to join the tables 'country' and 'countrylanguage'
SELECT c.NAME, cl.Language, cl.Percentage
FROM country c
INNER JOIN countrylanguage cl
ON c.Code = cl.CountryCode;

-- Displays which language is spoken the most in each country. 
SELECT c.Name AS Country, cl.Language, cl.Percentage
FROM country c
INNER JOIN countrylanguage cl ON c.Code = cl.CountryCode
WHERE cl.Percentage = (
    SELECT MAX(Percentage)
    FROM countrylanguage
    WHERE CountryCode = cl.CountryCode
);


-- Identify the largest city (by population) in each country.

-- joins the two tables city and country
SELECT c.Name, ci.Population, ci.name AS City
FROM country c
INNER JOIN city ci
ON c.Code = ci.CountryCode;

-- Finds the highest populated city for each country

SELECT c.Name, ci.Population, ci.name AS City
FROM country c
INNER JOIN city ci
ON c.Code = ci.CountryCode
WHERE ci.Population = (
	SELECT MAX(Population)
    FROM city
    WHERE Countrycode = ci.CountryCode
);

-- Calculate the total city population per country from the City table.


SELECT c.Name AS Country, SUM(ci.Population) AS TotalCityPop
FROM city ci
INNER JOIN country c
ON c.Code = ci.CountryCode
GROUP BY ci.CountryCode;

-- Find how much of each countries population is contributed by their cities. 

SELECT 
	c.Name AS Country,
	SUM(ci.Population) AS TotalCityPop,
    c.Population AS TotalPop,
    ROUND((SUM(ci.Population) / c.population * 100), 2) AS CityPopPercentage
FROM city ci
INNER JOIN country c
ON c.Code = ci.CountryCode
GROUP BY c.Code, c.Name, c.Population
ORDER BY CityPopPercentage DESC;

-- Categorize countries into Highly Urbanized, Moderately Urbanized, and Rural. 

SELECT 
    c.Name AS Country,
    SUM(ci.Population) AS TotalCityPop,
    c.Population AS TotalPop,
    ROUND((SUM(ci.Population) / c.Population * 100), 2) AS CityPopPercentage,
    CASE 
        WHEN (SUM(ci.Population) / c.Population * 100) > 60 THEN 'Highly Urbanized'
        WHEN (SUM(ci.Population) / c.Population * 100) > 25 THEN 'Moderately Urbanized'
        ELSE 'Rural'
    END AS UrbanizationCategory
FROM city ci
INNER JOIN country c ON c.Code = ci.CountryCode
GROUP BY c.Code, c.Name, c.Population
HAVING SUM(ci.Population) <= c.Population  -- Ensures no incorrect values
ORDER BY CityPopPercentage DESC;

-- Calculate the average city size per country

SELECT c.Name AS Country, ROUND(AVG(ci.Population), 1) AS AvgCityPop
FROM country c
INNER JOIN city ci ON c.code = ci.CountryCode
GROUP BY c.Code, c.Name
ORDER BY AvgCityPop DESC; 

-- Find the Largest country in Each continent by area and Population
-- Area
SELECT Name AS Country, Continent, SurfaceArea, Population
FROM Country c
WHERE SurfaceArea = (SELECT MAX(SurfaceArea) FROM COUNTRY WHERE Continent = C.continent)
ORDER BY SurfaceArea DESC;

-- Population

SELECT Name AS Country, Continent, Population
FROM Country c
WHERE Population = (SELECT MAX(Population) FROM COUNTRY WHERE Continent = C.continent)
ORDER BY Population DESC;






