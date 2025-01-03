/*

        UFO Sightings Finalise Cleaning Data (SEMI-CLEANED IN EXCEL)

    I came across this data on a for beginners' Kaggle page and expected it
	to be a straightforward data cleaning task; however, it quickly evolved
	into a complex challenge that pushed me beyond my comfort zone. I was
	determined to make sense of this dataset, ultimately progressing
	from fixing simple errors to performing extensive standardization processes,
	handling missing values, and creating clean, usable datasets. Overall, I
	enjoyed cleaning this dataset; it was a great hands-on way to learn SQL and
	data cleaning fundamentals. (Disclaimer: AI was used to help me learn
	SQL functions and understand how to write queries like syntax, order of operations, etc).

	                            --Breakdown of Method--
	
Initial Standardization:

-Standardized country codes 
-Fixed missing column titles

NULL Value Management:

-Identified blank entries not registering as NULL
-Converted empty strings and spaces to NULL values
-Updated coordinates (0,0) to NULL 
-Initial missing data was 25.14% of records

Country and State Cleanup:

-Used city information to fill missing country values
-Updated state values for Australia based on city names
-Standardized UK internal divisions 
-Matched US states with their country
-Matched Canadian provinces with their country

Shape Column Enhancement:

-Used comment text to identify UFO shapes when shape field was NULL
-Mapped descriptive text to standardized shape categories
-Categorized shapes into groups 

Data Validation & Removal:

-Removed records with questionable validity markers

City Name Cleanup:

-Removed parentheses and additional information from city names
-Created a cleaned city name column

Duplicate Management:

-Identified potential duplicates
-Kept multiple reports from same location/time as they could be different witnesses
-Created a separate view for mass sightings 

Final Output Creating two clean views:

-UFO_Sightings_Final_Clean 
-Mass_UFO_Sightings 

*/

SELECT *
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned

  
          --Standarise & format--

--check country values 

SELECT DISTINCT country 
,[State(fixed)], [City(fixed)]
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE country IS NOT NULL
ORDER BY country DESC

-- upon inspecting the data, US = United States, GB = Great Britan (or UNited Kingdom), AU = Australia, ca = Canada and de = Germany. 

SELECT 
    country as current_country,
    CASE 
        WHEN country = 'us' THEN 'United States'
        WHEN country = 'gb' THEN 'United Kingdom'
        WHEN country = 'au' THEN 'Australia'
        WHEN country = 'de' THEN 'Germany'
        WHEN country = 'ca' THEN 'Canada'
        ELSE country
    END as proposed_country
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE country IS NOT NULL
ORDER BY country

--Update Accordingly

UPDATE PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
SET country =
CASE 
     WHEN country = 'us' THEN 'United States'
     WHEN country =  'gb' THEN 'United Kingdom'
	 WHEN country =  'au' THEN 'Australia'
	 WHEN country =  'de' THEN 'Germany'
	 WHEN country =  'ca' THEN 'Canada'
ELSE country
END

-- Rectify missing Cloumn title for UFO comments


USE PortfolioProject
GO
EXEC sp_help 'UFO_Sightings_Excel_Cleaned'

EXEC sp_rename 'UFO_Sightings_Excel_Cleaned.[ ]', 'Comments', 'COLUMN'

          --CHECK FOR NULL VALUES AND DISTRUPED DATA--

--noticed alot of blank columns that were not registering as nulls, check first (i beleive the intial clean in excel may have affected this).

SELECT 
   'Date_sighted(fixed)' as column_name,
   COUNT(CASE WHEN [Date_sighted(fixed)] = '' THEN 1 END) as empty_string_count,
   COUNT(CASE WHEN [Date_sighted(fixed)] = ' ' THEN 1 END) as space_count,
   COUNT(CASE WHEN [Date_sighted(fixed)] IS NULL THEN 1 END) as null_count
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'Time_sighted(fixed)',
   COUNT(CASE WHEN [Time_sighted(fixed)] = '' THEN 1 END),
   COUNT(CASE WHEN [Time_sighted(fixed)] = ' ' THEN 1 END),
   COUNT(CASE WHEN [Time_sighted(fixed)] IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'City(fixed)',
   COUNT(CASE WHEN [City(fixed)] = '' THEN 1 END),
   COUNT(CASE WHEN [City(fixed)] = ' ' THEN 1 END),
   COUNT(CASE WHEN [City(fixed)] IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'State(fixed)',
   COUNT(CASE WHEN [State(fixed)] = '' THEN 1 END),
   COUNT(CASE WHEN [State(fixed)] = ' ' THEN 1 END),
   COUNT(CASE WHEN [State(fixed)] IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'country',
   COUNT(CASE WHEN country = '' THEN 1 END),
   COUNT(CASE WHEN country = ' ' THEN 1 END),
   COUNT(CASE WHEN country IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'Shape(fixed)',
   COUNT(CASE WHEN [Shape(fixed)] = '' THEN 1 END),
   COUNT(CASE WHEN [Shape(fixed)] = ' ' THEN 1 END),
   COUNT(CASE WHEN [Shape(fixed)] IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'duration (seconds)',
   COUNT(CASE WHEN [duration (seconds)] = '' THEN 1 END),
   COUNT(CASE WHEN [duration (seconds)] = ' ' THEN 1 END),
   COUNT(CASE WHEN [duration (seconds)] IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'duration (hours/min)',
   COUNT(CASE WHEN [duration (hours/min)] = '' THEN 1 END),
   COUNT(CASE WHEN [duration (hours/min)] = ' ' THEN 1 END),
   COUNT(CASE WHEN [duration (hours/min)] IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'Comments',
   COUNT(CASE WHEN Comments = '' THEN 1 END),
   COUNT(CASE WHEN Comments = ' ' THEN 1 END),
   COUNT(CASE WHEN Comments IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'Date_posted(fixed)',
   COUNT(CASE WHEN [Date_posted(fixed)] = '' THEN 1 END),
   COUNT(CASE WHEN [Date_posted(fixed)] = ' ' THEN 1 END),
   COUNT(CASE WHEN [Date_posted(fixed)] IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'latitude',
   COUNT(CASE WHEN latitude = '' THEN 1 END),
   COUNT(CASE WHEN latitude = ' ' THEN 1 END),
   COUNT(CASE WHEN latitude IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
UNION ALL
SELECT 
   'longitude',
   COUNT(CASE WHEN longitude = '' THEN 1 END),
   COUNT(CASE WHEN longitude = ' ' THEN 1 END),
   COUNT(CASE WHEN longitude IS NULL THEN 1 END)
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned

--upon inspection there seems to be alot of missing NULL values. Update accordingly: 
--State(fixed)
--Shape(fixed)
--duration (seconds)
--latitude
--longitude
--(side not lat and long missing values are not blank yet are filled with 0. However, in geographic coordinates, having both lat AND long as exactly 0,0 
--is extremly unliklely, there values will be change to NULL).  

UPDATE UFO_Sightings_Excel_Cleaned
SET [State(fixed)] = NULL
WHERE [State(fixed)] = '' OR [State(fixed)] = ' '

UPDATE UFO_Sightings_Excel_Cleaned
SET [Shape(fixed)] = NULL
WHERE [Shape(fixed)] = '' OR [Shape(fixed)] = ' '

UPDATE UFO_Sightings_Excel_Cleaned
SET [duration (seconds)] = NULL
WHERE [duration (seconds)] = '' OR [duration (seconds)] = ' '

UPDATE UFO_Sightings_Excel_Cleaned
SET latitude = NULL, longitude = NULL
WHERE latitude = 0 AND longitude = 0

-- Now check how many nulls values there are

SELECT 
    COUNT(*) as total_records,
SUM(CASE 
        WHEN [City(fixed)] IS NULL 
            OR [state(fixed)] IS NULL 
            OR [Shape(fixed)] IS NULL
            OR country IS NULL
            OR [duration (seconds)] IS NULL 
            OR latitude IS NULL 
            OR longitude IS NULL 
            OR [Date_Sighted(fixed)] IS NULL
			OR [Time_sighted(fixed)] IS NULL
        THEN 1 
        ELSE 0 
    END) as incomplete_records
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned



SELECT  
    COUNT(*) as total_records,
    ROUND(SUM(CASE 
        WHEN [City(fixed)] IS NULL 
OR [state(fixed)] IS NULL 
OR [Shape(fixed)] IS NULL
OR country IS NULL
OR [duration (seconds)] IS NULL 
OR latitude IS NULL 
OR longitude IS NULL 
            OR [Date_Sighted(fixed)] IS NULL 
			OR [Time_sighted(fixed)] IS NULL
        THEN 1 
        ELSE 0 
    END) * 100.0 / COUNT(*), 2) as incomplete_percentage
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned


--incomplete (null) data records 22341 out of 88875 (25.14%)
--Check which columns are causing most of the incompleteness

SELECT 
    SUM(CASE WHEN [City(fixed)] IS NULL THEN 1 ELSE 0 END) as city_nulls,
    SUM(CASE WHEN [State(fixed)] IS NULL THEN 1 ELSE 0 END) as state_nulls,
    SUM(CASE WHEN [Shape(fixed)] IS NULL THEN 1 ELSE 0 END) as shape_nulls,
    SUM(CASE WHEN [duration (seconds)] IS NULL THEN 1 ELSE 0 END) as duration_nulls,
    SUM(CASE WHEN latitude IS NULL THEN 1 ELSE 0 END) as lat_nulls,
    SUM(CASE WHEN longitude IS NULL THEN 1 ELSE 0 END) as long_nulls,
    SUM(CASE WHEN [Date_sighted(fixed)] IS NULL THEN 1 ELSE 0 END) as date_nulls,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) as country_nulls,
	SUM(CASE WHEN [Time_sighted(fixed)] IS NULL THEN 1 ELSE 0 END) as Time_sighted_nulls
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned

--there is a considerable amount of data missing in the country, state, duration & shape columns, attempt to fill


-- after inspecting city values, a consideable amount have the country origin yet their corrosponding counrty value is NULL

SELECT [City(fixed)], country, [State(fixed)]
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE [City(fixed)] LIKE '%(%)%'
AND country IS NULL
ORDER BY [City(fixed)]

-- use country name from city column to fill country nulls, exclude distrupted values like ?, non specifed, hoax etc. (for simplicty countries within the UK ie scottland and wales will be modifed to Uinted Kingdom)

SELECT [City(fixed)], country,
    CASE 
        WHEN [City(fixed)] LIKE '%(Albania)%' THEN 'Albania'
		WHEN [City(fixed)] LIKE '%(Russia)%' THEN 'Russia'
        WHEN [City(fixed)] LIKE '%(Austria)%' THEN 'Austria'
		WHEN [City(fixed)] LIKE '%(Ukraine)%' THEN 'Ukraine'
        WHEN [City(fixed)] LIKE '%(Belgium)%' THEN 'Belgium'
        WHEN [City(fixed)] LIKE '%(Bulgaria)%' THEN 'Bulgaria'
        WHEN [City(fixed)] LIKE '%(Croatia)%' THEN 'Croatia'
        WHEN [City(fixed)] LIKE '%(Czech Republic)%' OR [City(fixed)] LIKE '%(Czechia)%' THEN 'Czech Republic'
        WHEN [City(fixed)] LIKE '%(Denmark)%' THEN 'Denmark'
        WHEN [City(fixed)] LIKE '%(Estonia)%' THEN 'Estonia'
		WHEN [City(fixed)] LIKE '%(Cyprus)%' THEN 'Cyprus'
        WHEN [City(fixed)] LIKE '%(Finland)%' THEN 'Finland'
        WHEN [City(fixed)] LIKE '%(France)%' THEN 'France'
        WHEN [City(fixed)] LIKE '%(Germany)%' THEN 'Germany'
        WHEN [City(fixed)] LIKE '%(Greece)%' THEN 'Greece'
        WHEN [City(fixed)] LIKE '%(Hungary)%' THEN 'Hungary'
        WHEN [City(fixed)] LIKE '%(Iceland)%' THEN 'Iceland'
        WHEN [City(fixed)] LIKE '%(Ireland)%' THEN 'Ireland'
        WHEN [City(fixed)] LIKE '%(Italy)%' THEN 'Italy'
        WHEN [City(fixed)] LIKE '%(Latvia)%' THEN 'Latvia'
        WHEN [City(fixed)] LIKE '%(Lithuania)%' THEN 'Lithuania'
        WHEN [City(fixed)] LIKE '%(Luxembourg)%' THEN 'Luxembourg'
        WHEN [City(fixed)] LIKE '%(Malta)%' THEN 'Malta'
        WHEN [City(fixed)] LIKE '%(Netherlands)%' OR [City(fixed)] LIKE '%(the netherlands)%' THEN 'Netherlands'
        WHEN [City(fixed)] LIKE '%(Norway)%' THEN 'Norway'
        WHEN [City(fixed)] LIKE '%(Poland)%' THEN 'Poland'
        WHEN [City(fixed)] LIKE '%(Portugal)%' THEN 'Portugal'
		WHEN [City(fixed)] LIKE '%(Northern Ireland)%' THEN 'United Kingdom'
        WHEN [City(fixed)] LIKE '%(Romania)%' THEN 'Romania'
        WHEN [City(fixed)] LIKE '%(Slovakia)%' THEN 'Slovakia'
        WHEN [City(fixed)] LIKE '%(Slovenia)%' THEN 'Slovenia'
        WHEN [City(fixed)] LIKE '%(Spain)%' THEN 'Spain'
        WHEN [City(fixed)] LIKE '%(Sweden)%' THEN 'Sweden'
        WHEN [City(fixed)] LIKE '%(Switzerland)%' THEN 'Switzerland'
		WHEN [City(fixed)] LIKE '%(Republic of ireland)%' THEN 'Ireland'
		WHEN [City(fixed)] LIKE '%(Czechoslovakia)%' THEN 'Czechoslovakia'
		WHEN [City(fixed)] LIKE '%(Serbia)%' THEN 'Serbia'
		WHEN [City(fixed)] LIKE '%(Bosnia)%' THEN 'Bosnia'
        WHEN [City(fixed)] LIKE '%(UK)%' OR [City(fixed)] LIKE '%(United Kingdom)%' OR [City(fixed)] LIKE '%(England)%' OR [City(fixed)] LIKE '%(Scotland)%' OR [City(fixed)] LIKE '%(Wales)%'
		OR [City(fixed)] LIKE '%(UK/England)%' OR [City(fixed)] LIKE '%(UK/Scotland)%' OR [City(fixed)] LIKE '%(UK/Wales)%' THEN 'United Kingdom'

        -- North America
        WHEN [City(fixed)] LIKE '%(Canada)%' THEN 'Canada'
        WHEN [City(fixed)] LIKE '%(Mexico)%' THEN 'Mexico'
        WHEN [City(fixed)] LIKE '%(USA)%' OR [City(fixed)] LIKE '%(United States)%' OR [City(fixed)] LIKE '%(US)%' THEN 'United States'

        -- Asia
        WHEN [City(fixed)] LIKE '%(China)%' THEN 'China'
        WHEN [City(fixed)] LIKE '%(Japan)%' THEN 'Japan'
        WHEN [City(fixed)] LIKE '%(India)%' THEN 'India'
		WHEN [City(fixed)] LIKE '%(Pakistan)%' THEN 'Pakistan'
		WHEN [City(fixed)] LIKE '%(Afghanistan)%' THEN 'Afghanistan'
		WHEN [City(fixed)] LIKE '%(Sri Lanka)%' THEN 'Sri Lanka'
		WHEN [City(fixed)] LIKE '%(Nepal)%' THEN 'Nepal'
        WHEN [City(fixed)] LIKE '%(Indonesia)%' THEN 'Indonesia'
        WHEN [City(fixed)] LIKE '%(Malaysia)%' THEN 'Malaysia'
        WHEN [City(fixed)] LIKE '%(Philippines)%' THEN 'Philippines'
        WHEN [City(fixed)] LIKE '%(Singapore)%' THEN 'Singapore'
        WHEN [City(fixed)] LIKE '%(South Korea)%' THEN 'South Korea'
        WHEN [City(fixed)] LIKE '%(Thailand)%' THEN 'Thailand'
        WHEN [City(fixed)] LIKE '%(Vietnam)%' OR [City(fixed)] LIKE '%(Viet nam)%' THEN 'Vietnam'
        WHEN [City(fixed)] LIKE '%(Turkey)%' THEN 'Turkey'
		WHEN [City(fixed)] LIKE '%(Bangladesh)%' THEN 'Bangladesh'

        -- Oceania
        WHEN [City(fixed)] LIKE '%(Australia)%' OR [City(fixed)] LIKE '%(Western Australia)%' OR [City(fixed)] LIKE '%(South Australia)%' THEN 'Australia'
		WHEN [City(fixed)] LIKE '%Australia%' THEN 'Australia'
        WHEN [City(fixed)] LIKE '%(New Zealand)%' THEN 'New Zealand'
		WHEN [City(fixed)] LIKE '%(Haiti)%' THEN 'Haiti'

        -- South America
		WHEN [City(fixed)] LIKE '%(Jamaica)%' THEN 'Jamaica'
		WHEN [City(fixed)] LIKE '%(Honduras)%' THEN 'Honduras'
		WHEN [City(fixed)] LIKE '%(Panama)%' THEN 'Panama'
		WHEN [City(fixed)] LIKE '%(Bahamas)%' THEN 'Bahamas'
        WHEN [City(fixed)] LIKE '%(Argentina)%' THEN 'Argentina'
		WHEN [City(fixed)] LIKE '%(Cuba)%' THEN 'Cuba'
		WHEN [City(fixed)] LIKE '%(Guatamala)%' THEN 'Guatamala'
		WHEN [City(fixed)] LIKE '%(Ecuador%' THEN 'Ecuador'
        WHEN [City(fixed)] LIKE '%(Brazil%)' OR [City(fixed)] LIKE '%(Brasil)%' THEN 'Brazil'
        WHEN [City(fixed)] LIKE '%(Chile)%' THEN 'Chile'
        WHEN [City(fixed)] LIKE '%(Colombia)%' THEN 'Colombia'
        WHEN [City(fixed)] LIKE '%(Peru)%' THEN 'Peru'
        WHEN [City(fixed)] LIKE '%(Venezuela)%' THEN 'Venezuela'
		WHEN [City(fixed)] LIKE '%(Puerto Rico)%' THEN 'puerto rico'
		WHEN [City(fixed)] LIKE '%(Costa rica)%' THEN 'costa rica'
		WHEN [City(fixed)] LIKE '%(Bolivia)%' THEN 'Bolivia'
		WHEN [City(fixed)] LIKE '%(Dominican republic)%' THEN 'Dominican Republic'
		WHEN [City(fixed)] LIKE '%(Trinidad)%' THEN 'Trinidad'

        -- Africa
        WHEN [City(fixed)] LIKE '%(Egypt)%' THEN 'Egypt'
		WHEN [City(fixed)] LIKE '%(Ethiopia)%' THEN 'Ethiopia'
        WHEN [City(fixed)] LIKE '%(South africa)%' THEN 'South Africa'
        WHEN [City(fixed)] LIKE '%(Morocco)%' THEN 'Morocco'
        WHEN [City(fixed)] LIKE '%(Nigeria)%' THEN 'Nigeria'
        WHEN [City(fixed)] LIKE '%(Kenya)%' THEN 'Kenya'
		WHEN [City(fixed)] LIKE '%(Zimbabwe)%' THEN 'Zimbabwe'

        -- Middle East
		WHEN [City(fixed)] LIKE '%(Jordan)%' THEN 'Jordan'
		WHEN [City(fixed)] LIKE '%(Lebanon)%' THEN 'Lebanon'
		WHEN [City(fixed)] LIKE '%(Iran)%' THEN 'Iran'
		WHEN [City(fixed)] LIKE '%(Syria)%' THEN 'Syria'
		WHEN [City(fixed)] LIKE '%(Qatar)%' THEN 'Qatar'
		WHEN [City(fixed)] LIKE '%(Iraq)%' THEN 'Iraq'
		WHEN [City(fixed)] LIKE '%(Azerbaijan)%' THEN 'Azerbaijan'
        WHEN [City(fixed)] LIKE '%(Israel)%' THEN 'Israel'
        WHEN [City(fixed)] LIKE '%(Saudi arabia)%' THEN 'Saudi Arabia'
        WHEN [City(fixed)] LIKE '%(uae)%' OR [City(fixed)] LIKE '%(united arab emirates)%' OR [City(fixed)] LIKE '%(u.a.e.)%' OR [City(fixed)] LIKE '%(u.a.r.)%' OR [City(fixed)] LIKE '%(u. a. e.)%' THEN 'United Arab Emirates'
    END as country_from_city
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE [City(fixed)] LIKE '%(%)%'
AND country IS NULL
AND [City(fixed)] NOT LIKE '%((%)%'
AND [City(fixed)] NOT LIKE '%(unknown)%'
AND [City(fixed)] NOT LIKE '%(unspecified)%'
AND [City(fixed)] NOT LIKE '%(not specified)%'
AND [City(fixed)] NOT LIKE '%?%'
AND [City(fixed)] NOT LIKE '%(airplane)%'
AND [City(fixed)] NOT LIKE '%(above%'
ORDER BY country_from_city 

--update

UPDATE PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
SET country = 
    CASE 
        WHEN [City(fixed)] LIKE '%(Albania)%' THEN 'Albania'
		WHEN [City(fixed)] LIKE '%(Russia)%' THEN 'Russia'
        WHEN [City(fixed)] LIKE '%(Austria)%' THEN 'Austria'
		WHEN [City(fixed)] LIKE '%(Ukraine)%' THEN 'Ukraine'
        WHEN [City(fixed)] LIKE '%(Belgium)%' THEN 'Belgium'
        WHEN [City(fixed)] LIKE '%(Bulgaria)%' THEN 'Bulgaria'
        WHEN [City(fixed)] LIKE '%(Croatia)%' THEN 'Croatia'
        WHEN [City(fixed)] LIKE '%(Czech Republic)%' OR [City(fixed)] LIKE '%(Czechia)%' THEN 'Czech Republic'
        WHEN [City(fixed)] LIKE '%(Denmark)%' THEN 'Denmark'
        WHEN [City(fixed)] LIKE '%(Estonia)%' THEN 'Estonia'
		WHEN [City(fixed)] LIKE '%(Cyprus)%' THEN 'Cyprus'
        WHEN [City(fixed)] LIKE '%(Finland)%' THEN 'Finland'
        WHEN [City(fixed)] LIKE '%(France)%' THEN 'France'
        WHEN [City(fixed)] LIKE '%(Germany)%' THEN 'Germany'
        WHEN [City(fixed)] LIKE '%(Greece)%' THEN 'Greece'
        WHEN [City(fixed)] LIKE '%(Hungary)%' THEN 'Hungary'
        WHEN [City(fixed)] LIKE '%(Iceland)%' THEN 'Iceland'
        WHEN [City(fixed)] LIKE '%(Ireland)%' THEN 'Ireland'
        WHEN [City(fixed)] LIKE '%(Italy)%' THEN 'Italy'
        WHEN [City(fixed)] LIKE '%(Latvia)%' THEN 'Latvia'
        WHEN [City(fixed)] LIKE '%(Lithuania)%' THEN 'Lithuania'
        WHEN [City(fixed)] LIKE '%(Luxembourg)%' THEN 'Luxembourg'
        WHEN [City(fixed)] LIKE '%(Malta)%' THEN 'Malta'
        WHEN [City(fixed)] LIKE '%(Netherlands)%' OR [City(fixed)] LIKE '%(the netherlands)%' THEN 'Netherlands'
        WHEN [City(fixed)] LIKE '%(Norway)%' THEN 'Norway'
        WHEN [City(fixed)] LIKE '%(Poland)%' THEN 'Poland'
        WHEN [City(fixed)] LIKE '%(Portugal)%' THEN 'Portugal'
		WHEN [City(fixed)] LIKE '%(Northern Ireland)%' THEN 'United Kingdom'
        WHEN [City(fixed)] LIKE '%(Romania)%' THEN 'Romania'
        WHEN [City(fixed)] LIKE '%(Slovakia)%' THEN 'Slovakia'
        WHEN [City(fixed)] LIKE '%(Slovenia)%' THEN 'Slovenia'
        WHEN [City(fixed)] LIKE '%(Spain)%' THEN 'Spain'
        WHEN [City(fixed)] LIKE '%(Sweden)%' THEN 'Sweden'
        WHEN [City(fixed)] LIKE '%(Switzerland)%' THEN 'Switzerland'
		WHEN [City(fixed)] LIKE '%(Republic of ireland)%' THEN 'Ireland'
		WHEN [City(fixed)] LIKE '%(Czechoslovakia)%' THEN 'Czechoslovakia'
		WHEN [City(fixed)] LIKE '%(Serbia)%' THEN 'Serbia'
		WHEN [City(fixed)] LIKE '%(Bosnia)%' THEN 'Bosnia'
        WHEN [City(fixed)] LIKE '%(UK)%' OR [City(fixed)] LIKE '%(United Kingdom)%' OR [City(fixed)] LIKE '%(England)%' OR [City(fixed)] LIKE '%(Scotland)%' OR [City(fixed)] LIKE '%(Wales)%'
		OR [City(fixed)] LIKE '%(UK/England)%' OR [City(fixed)] LIKE '%(UK/Scotland)%' OR [City(fixed)] LIKE '%(UK/Wales)%' THEN 'United Kingdom'

        -- North America
        WHEN [City(fixed)] LIKE '%(Canada)%' THEN 'Canada'
        WHEN [City(fixed)] LIKE '%(Mexico)%' THEN 'Mexico'
        WHEN [City(fixed)] LIKE '%(USA)%' OR [City(fixed)] LIKE '%(United States)%' OR [City(fixed)] LIKE '%(US)%' THEN 'United States'

        -- Asia
        WHEN [City(fixed)] LIKE '%(China)%' THEN 'China'
        WHEN [City(fixed)] LIKE '%(Japan)%' THEN 'Japan'
        WHEN [City(fixed)] LIKE '%(India)%' THEN 'India'
		WHEN [City(fixed)] LIKE '%(Pakistan)%' THEN 'Pakistan'
		WHEN [City(fixed)] LIKE '%(Afghanistan)%' THEN 'Afghanistan'
		WHEN [City(fixed)] LIKE '%(Sri Lanka)%' THEN 'Sri Lanka'
		WHEN [City(fixed)] LIKE '%(Nepal)%' THEN 'Nepal'
        WHEN [City(fixed)] LIKE '%(Indonesia)%' THEN 'Indonesia'
        WHEN [City(fixed)] LIKE '%(Malaysia)%' THEN 'Malaysia'
        WHEN [City(fixed)] LIKE '%(Philippines)%' THEN 'Philippines'
        WHEN [City(fixed)] LIKE '%(Singapore)%' THEN 'Singapore'
        WHEN [City(fixed)] LIKE '%(South Korea)%' THEN 'South Korea'
        WHEN [City(fixed)] LIKE '%(Thailand)%' THEN 'Thailand'
        WHEN [City(fixed)] LIKE '%(Vietnam)%' OR [City(fixed)] LIKE '%(Viet nam)%' THEN 'Vietnam'
        WHEN [City(fixed)] LIKE '%(Turkey)%' THEN 'Turkey'
		WHEN [City(fixed)] LIKE '%(Bangladesh)%' THEN 'Bangladesh'

        -- Oceania
        WHEN [City(fixed)] LIKE '%(Australia)%' OR [City(fixed)] LIKE '%(Western Australia)%' OR [City(fixed)] LIKE '%(South Australia)%' THEN 'Australia'
		WHEN [City(fixed)] LIKE '%Australia%' THEN 'Australia'
        WHEN [City(fixed)] LIKE '%(New Zealand)%' THEN 'New Zealand'
		WHEN [City(fixed)] LIKE '%(Haiti)%' THEN 'Haiti'

        -- South America
		WHEN [City(fixed)] LIKE '%(Jamaica)%' THEN 'Jamaica'
		WHEN [City(fixed)] LIKE '%(Honduras)%' THEN 'Honduras'
		WHEN [City(fixed)] LIKE '%(Panama)%' THEN 'Panama'
		WHEN [City(fixed)] LIKE '%(Bahamas)%' THEN 'Bahamas'
        WHEN [City(fixed)] LIKE '%(Argentina)%' THEN 'Argentina'
		WHEN [City(fixed)] LIKE '%(Cuba)%' THEN 'Cuba'
		WHEN [City(fixed)] LIKE '%(Guatamala)%' THEN 'Guatamala'
		WHEN [City(fixed)] LIKE '%(Ecuador%' THEN 'Ecuador'
        WHEN [City(fixed)] LIKE '%(Brazil%)' OR [City(fixed)] LIKE '%(Brasil)%' THEN 'Brazil'
        WHEN [City(fixed)] LIKE '%(Chile)%' THEN 'Chile'
        WHEN [City(fixed)] LIKE '%(Colombia)%' THEN 'Colombia'
        WHEN [City(fixed)] LIKE '%(Peru)%' THEN 'Peru'
        WHEN [City(fixed)] LIKE '%(Venezuela)%' THEN 'Venezuela'
		WHEN [City(fixed)] LIKE '%(Puerto Rico)%' THEN 'puerto rico'
		WHEN [City(fixed)] LIKE '%(Costa rica)%' THEN 'costa rica'
		WHEN [City(fixed)] LIKE '%(Bolivia)%' THEN 'Bolivia'
		WHEN [City(fixed)] LIKE '%(Dominican republic)%' THEN 'Dominican Republic'
		WHEN [City(fixed)] LIKE '%(Trinidad)%' THEN 'Trinidad'

        -- Africa
        WHEN [City(fixed)] LIKE '%(Egypt)%' THEN 'Egypt'
		WHEN [City(fixed)] LIKE '%(Ethiopia)%' THEN 'Ethiopia'
        WHEN [City(fixed)] LIKE '%(South africa)%' THEN 'South Africa'
        WHEN [City(fixed)] LIKE '%(Morocco)%' THEN 'Morocco'
        WHEN [City(fixed)] LIKE '%(Nigeria)%' THEN 'Nigeria'
        WHEN [City(fixed)] LIKE '%(Kenya)%' THEN 'Kenya'
		WHEN [City(fixed)] LIKE '%(Zimbabwe)%' THEN 'Zimbabwe'

        -- Middle East
		WHEN [City(fixed)] LIKE '%(Jordan)%' THEN 'Jordan'
		WHEN [City(fixed)] LIKE '%(Lebanon)%' THEN 'Lebanon'
		WHEN [City(fixed)] LIKE '%(Iran)%' THEN 'Iran'
		WHEN [City(fixed)] LIKE '%(Syria)%' THEN 'Syria'
		WHEN [City(fixed)] LIKE '%(Qatar)%' THEN 'Qatar'
		WHEN [City(fixed)] LIKE '%(Iraq)%' THEN 'Iraq'
		WHEN [City(fixed)] LIKE '%(Azerbaijan)%' THEN 'Azerbaijan'
        WHEN [City(fixed)] LIKE '%(Israel)%' THEN 'Israel'
        WHEN [City(fixed)] LIKE '%(Saudi arabia)%' THEN 'Saudi Arabia'
        WHEN [City(fixed)] LIKE '%(uae)%' OR [City(fixed)] LIKE '%(united arab emirates)%' OR [City(fixed)] LIKE '%(u.a.e.)%' OR [City(fixed)] LIKE '%(u.a.r.)%' OR [City(fixed)] LIKE '%(u. a. e.)%' THEN 'United Arab Emirates'
END
WHERE [City(fixed)] LIKE '%(%)%'
AND country IS NULL
AND [City(fixed)] NOT LIKE '%((%)%'
AND [City(fixed)] NOT LIKE '%(unknown)%'
AND [City(fixed)] NOT LIKE '%(unspecified)%'
AND [City(fixed)] NOT LIKE '%(not specified)%'
AND [City(fixed)] NOT LIKE '%?%'
AND [City(fixed)] NOT LIKE '%(airplane)%'
AND [City(fixed)] NOT LIKE '%(above%';

--fill country nulls using state and city values

SELECT [City(fixed)], country, [State(fixed)]
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE Country IS NULL
AND [State(fixed)] IS NOT NULL
ORDER BY [State(fixed)]



--After inspecting state values, there are many nulls plus conflicting info between some state values and its corrosponding country (the focus here will be only on four countires: The United States, Canada, Australia, and the UK, for simplicity)

-- create preview idetifying US states etc, update country values accordingly--

--use town, city & state names in city values to update/replace state values


--AUS
SELECT *
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE country = 'Australia'
      OR [City(fixed)] = '%australia%'
ORDER BY [State(fixed)] DESC


SELECT [City(fixed)], country,
   CASE 
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Western Australia)%' OR [City(fixed)] LIKE '%(WA%' 
        OR [City(fixed)] LIKE 'Perth%' OR [City(fixed)] LIKE 'Fremantle%' 
        OR [City(fixed)] LIKE 'Bunbury%' OR [City(fixed)] LIKE 'Geraldton%'
        OR [City(fixed)] LIKE 'Kalgoorlie%'
        OR [City(fixed)] LIKE 'Broome%' OR [City(fixed)] LIKE 'Mandurah%'
        OR [City(fixed)] LIKE 'Mindarie%' OR [City(fixed)] LIKE 'Rockingham%'
        OR [City(fixed)] LIKE 'Esperance%' OR [City(fixed)] LIKE 'Leeman%'
        OR [City(fixed)] LIKE 'Busselton%' OR [City(fixed)] LIKE 'Walpole%'
        OR [City(fixed)] LIKE 'Armadale%') THEN 'WA'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(South Australia)%' OR [City(fixed)] LIKE '%(SA%'
        OR [City(fixed)] LIKE 'Adelaide%' OR [City(fixed)] LIKE 'Port Augusta%'
        OR [City(fixed)] LIKE 'Mount Gambier%' OR [City(fixed)] LIKE 'Whyalla%'
        OR [City(fixed)] LIKE 'Port Lincoln%' OR [City(fixed)] LIKE 'Nuriootpa%'
        OR [City(fixed)] LIKE 'Port Noarlunga%' OR [City(fixed)] LIKE 'Penola%'
        OR [City(fixed)] LIKE 'Semaphore%') THEN 'SA'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Victoria)%' OR [City(fixed)] LIKE '%(vic%'
        OR [City(fixed)] LIKE 'Melbourne%' OR [City(fixed)] LIKE 'Geelong%'
        OR [City(fixed)] LIKE 'Ballarat%' OR [City(fixed)] LIKE 'Bendigo%'
        OR [City(fixed)] LIKE 'Wodonga%' OR [City(fixed)] LIKE 'Maffra%'
        OR [City(fixed)] LIKE 'Moe%' OR [City(fixed)] LIKE 'Yandoit%'
        OR [City(fixed)] LIKE 'Hoppers Crossing%' OR [City(fixed)] LIKE 'Drouin West%'
        OR [City(fixed)] LIKE 'Melton%' OR [City(fixed)] LIKE 'Kilsyth%'
        OR [City(fixed)] LIKE 'Beveridge%' OR [City(fixed)] LIKE 'Kalimna%'
        OR [City(fixed)] LIKE 'Inverloch%' OR [City(fixed)] LIKE 'Dunkeld%'
        OR [City(fixed)] LIKE 'Sale%' OR [City(fixed)] LIKE 'Echuca%'
        OR [City(fixed)] LIKE 'Wangaratta%' OR [City(fixed)] LIKE 'Murtoa%'
        OR [City(fixed)] LIKE 'Glen Waverley%') THEN 'VIC'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Queensland%' OR [City(fixed)] LIKE '%(qld%'
        OR [City(fixed)] LIKE 'Brisbane%' OR [City(fixed)] LIKE 'Gold Coast%'
        OR [City(fixed)] LIKE 'Cairns%' OR [City(fixed)] LIKE 'Townsville%'
        OR [City(fixed)] LIKE 'Toowoomba%' OR [City(fixed)] LIKE 'Mackay%'
        OR [City(fixed)] LIKE 'Mount Isa%' OR [City(fixed)] LIKE 'Ipswich%'
        OR [City(fixed)] LIKE 'Ipswitch%' OR [City(fixed)] LIKE 'Tweed Heads%'
        OR [City(fixed)] LIKE 'Caloundra%' OR [City(fixed)] LIKE 'Cleveland%'
        OR [City(fixed)] LIKE 'Gympie%' OR [City(fixed)] LIKE 'Allora%'
        OR [City(fixed)] LIKE 'Emerald%' OR [City(fixed)] LIKE 'Boyne Island%'
        OR [City(fixed)] LIKE 'Tannum Sands%' OR [City(fixed)] LIKE 'Caboolture%'
        OR [City(fixed)] LIKE 'Biloela%' OR [City(fixed)] LIKE 'Port Douglas%'
        OR [City(fixed)] LIKE 'Logan%' OR [City(fixed)] LIKE 'Hervey Bay%'
        OR [City(fixed)] LIKE 'Gladstone%' OR [City(fixed)] LIKE 'Atherton%'
        OR [City(fixed)] LIKE 'Birdsville%' OR [City(fixed)] LIKE 'Rockhampton%'
        OR [City(fixed)] LIKE 'Wyreema%' OR [City(fixed)] LIKE 'Tamborine%'
        OR [City(fixed)] LIKE 'Redcliffe%' OR [City(fixed)] LIKE 'Bundaberg%'
        OR [City(fixed)] LIKE 'Currumbin%') THEN 'QLD'
		 WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Northern Territory)%' OR [City(fixed)] LIKE '%(NT%'
        OR [City(fixed)] LIKE 'Darwin%' OR [City(fixed)] LIKE 'Alice Springs%'
        OR [City(fixed)] LIKE 'Katherine%' OR [City(fixed)] LIKE 'Palmerston%'
        OR [City(fixed)] LIKE 'Tennant Creek%' OR [City(fixed)] LIKE 'Nhulunbuy%') THEN 'NT'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(New South Wales)%' OR [City(fixed)] LIKE '%(nsw%'
        OR [City(fixed)] LIKE 'Sydney%' OR [City(fixed)] LIKE 'Newcastle%'
        OR [City(fixed)] LIKE 'Wollongong%' OR [City(fixed)] LIKE 'Albury%'
        OR [City(fixed)] LIKE 'Wagga Wagga%' OR [City(fixed)] LIKE 'Coffs Harbour%'
        OR [City(fixed)] LIKE 'Campbelltown%' OR [City(fixed)] LIKE 'Armidale%'
        OR [City(fixed)] LIKE 'Cooma%' OR [City(fixed)] LIKE 'Rhodes%'
        OR [City(fixed)] LIKE 'Forster%' OR [City(fixed)] LIKE 'Broken Hill%'
        OR [City(fixed)] LIKE 'Leeton%' OR [City(fixed)] LIKE 'Cessnock%'
        OR [City(fixed)] LIKE 'Blacktown%' OR [City(fixed)] LIKE 'Lennox Head%'
        OR [City(fixed)] LIKE 'Denman%' OR [City(fixed)] LIKE 'Goulburn%'
        OR [City(fixed)] LIKE 'Berkeley Vale%' OR [City(fixed)] LIKE 'Katoomba%'
        OR [City(fixed)] LIKE 'Wyong%' OR [City(fixed)] LIKE 'Deniliquin%'
        OR [City(fixed)] LIKE 'Penrith%' OR [City(fixed)] LIKE 'Tathra%'
        OR [City(fixed)] LIKE 'Dubbo%' OR [City(fixed)] LIKE 'West Wyalong%'
        OR [City(fixed)] LIKE 'Glen Innes%' OR [City(fixed)] LIKE 'Boggabri%'
        OR [City(fixed)] LIKE 'Gosford%' OR [City(fixed)] LIKE 'Byron Bay%'
        OR [City(fixed)] LIKE 'Bathurst%' OR [City(fixed)] LIKE 'Ballina%'
        OR [City(fixed)] LIKE 'Murwillumbah%' OR [City(fixed)] LIKE 'Mudgee%'
        OR [City(fixed)] LIKE 'Grenfell%' OR [City(fixed)] LIKE 'Moree%'
        OR [City(fixed)] LIKE 'Nowra%' OR [City(fixed)] LIKE 'Molong%'
        OR [City(fixed)] LIKE 'Wallacia%' OR [City(fixed)] LIKE 'Port Macquarie%'
        OR [City(fixed)] LIKE 'Richmond%' OR [City(fixed)] LIKE 'Mittagong%'
        OR [City(fixed)] LIKE 'Woy Woy%' OR [City(fixed)] LIKE 'Ulladulla%'
        OR [City(fixed)] LIKE 'Tenterfield%' OR [City(fixed)] LIKE 'Tweed heads%') THEN 'NSW'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Tasmania)%' OR [City(fixed)] LIKE '%(Tas%' OR [City(fixed)] LIKE '%(Tasmania%'
        OR [City(fixed)] LIKE 'Hobart%' OR [City(fixed)] LIKE 'Launceston%'
        OR [City(fixed)] LIKE 'Devonport%' OR [City(fixed)] LIKE 'Burnie%'
        OR [City(fixed)] LIKE 'George Town%') THEN 'TAS'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(ACT)%' OR [City(fixed)] LIKE '%(act%'
        OR [City(fixed)] LIKE 'Canberra%' OR [City(fixed)] LIKE 'Australian Capital Territory%') THEN 'ACT'
   END AS state_code
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE country = 'Australia'

--Update

UPDATE PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
SET [State(fixed)] = 
    CASE 
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Western Australia)%' OR [City(fixed)] LIKE '%(WA%' 
        OR [City(fixed)] LIKE 'Perth%' OR [City(fixed)] LIKE 'Fremantle%' 
        OR [City(fixed)] LIKE 'Bunbury%' OR [City(fixed)] LIKE 'Geraldton%'
        OR [City(fixed)] LIKE 'Kalgoorlie%'
        OR [City(fixed)] LIKE 'Broome%' OR [City(fixed)] LIKE 'Mandurah%'
        OR [City(fixed)] LIKE 'Mindarie%' OR [City(fixed)] LIKE 'Rockingham%'
        OR [City(fixed)] LIKE 'Esperance%' OR [City(fixed)] LIKE 'Leeman%'
        OR [City(fixed)] LIKE 'Busselton%' OR [City(fixed)] LIKE 'Walpole%'
        OR [City(fixed)] LIKE 'Armadale%') THEN 'WA'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(South Australia)%' OR [City(fixed)] LIKE '%(SA%'
        OR [City(fixed)] LIKE 'Adelaide%' OR [City(fixed)] LIKE 'Port Augusta%'
        OR [City(fixed)] LIKE 'Mount Gambier%' OR [City(fixed)] LIKE 'Whyalla%'
        OR [City(fixed)] LIKE 'Port Lincoln%' OR [City(fixed)] LIKE 'Nuriootpa%'
        OR [City(fixed)] LIKE 'Port Noarlunga%' OR [City(fixed)] LIKE 'Penola%'
        OR [City(fixed)] LIKE 'Semaphore%') THEN 'SA'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Victoria)%' OR [City(fixed)] LIKE '%(vic%'
        OR [City(fixed)] LIKE 'Melbourne%' OR [City(fixed)] LIKE 'Geelong%'
        OR [City(fixed)] LIKE 'Ballarat%' OR [City(fixed)] LIKE 'Bendigo%'
        OR [City(fixed)] LIKE 'Wodonga%' OR [City(fixed)] LIKE 'Maffra%'
        OR [City(fixed)] LIKE 'Moe%' OR [City(fixed)] LIKE 'Yandoit%'
        OR [City(fixed)] LIKE 'Hoppers Crossing%' OR [City(fixed)] LIKE 'Drouin West%'
        OR [City(fixed)] LIKE 'Melton%' OR [City(fixed)] LIKE 'Kilsyth%'
        OR [City(fixed)] LIKE 'Beveridge%' OR [City(fixed)] LIKE 'Kalimna%'
        OR [City(fixed)] LIKE 'Inverloch%' OR [City(fixed)] LIKE 'Dunkeld%'
        OR [City(fixed)] LIKE 'Sale%' OR [City(fixed)] LIKE 'Echuca%'
        OR [City(fixed)] LIKE 'Wangaratta%' OR [City(fixed)] LIKE 'Murtoa%'
        OR [City(fixed)] LIKE 'Glen Waverley%') THEN 'VIC'
		 WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Northern Territory)%' OR [City(fixed)] LIKE '%(NT%'
        OR [City(fixed)] LIKE 'Darwin%' OR [City(fixed)] LIKE 'Alice Springs%'
        OR [City(fixed)] LIKE 'Katherine%' OR [City(fixed)] LIKE 'Palmerston%'
        OR [City(fixed)] LIKE 'Tennant Creek%' OR [City(fixed)] LIKE 'Nhulunbuy%') THEN 'NT'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Queensland%' OR [City(fixed)] LIKE '%(qld%'
        OR [City(fixed)] LIKE 'Brisbane%' OR [City(fixed)] LIKE 'Gold Coast%'
        OR [City(fixed)] LIKE 'Cairns%' OR [City(fixed)] LIKE 'Townsville%'
        OR [City(fixed)] LIKE 'Toowoomba%' OR [City(fixed)] LIKE 'Mackay%'
        OR [City(fixed)] LIKE 'Mount Isa%' OR [City(fixed)] LIKE 'Ipswich%'
        OR [City(fixed)] LIKE 'Ipswitch%' OR [City(fixed)] LIKE 'Tweed Heads%'
        OR [City(fixed)] LIKE 'Caloundra%' OR [City(fixed)] LIKE 'Cleveland%'
        OR [City(fixed)] LIKE 'Gympie%' OR [City(fixed)] LIKE 'Allora%'
        OR [City(fixed)] LIKE 'Emerald%' OR [City(fixed)] LIKE 'Boyne Island%'
        OR [City(fixed)] LIKE 'Tannum Sands%' OR [City(fixed)] LIKE 'Caboolture%'
        OR [City(fixed)] LIKE 'Biloela%' OR [City(fixed)] LIKE 'Port Douglas%'
        OR [City(fixed)] LIKE 'Logan%' OR [City(fixed)] LIKE 'Hervey Bay%'
        OR [City(fixed)] LIKE 'Gladstone%' OR [City(fixed)] LIKE 'Atherton%'
        OR [City(fixed)] LIKE 'Birdsville%' OR [City(fixed)] LIKE 'Rockhampton%'
        OR [City(fixed)] LIKE 'Wyreema%' OR [City(fixed)] LIKE 'Tamborine%'
        OR [City(fixed)] LIKE 'Redcliffe%' OR [City(fixed)] LIKE 'Bundaberg%'
        OR [City(fixed)] LIKE 'Currumbin%') THEN 'QLD'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(New South Wales)%' OR [City(fixed)] LIKE '%(nsw%'
        OR [City(fixed)] LIKE 'Sydney%' OR [City(fixed)] LIKE 'Newcastle%'
        OR [City(fixed)] LIKE 'Wollongong%' OR [City(fixed)] LIKE 'Albury%'
        OR [City(fixed)] LIKE 'Wagga Wagga%' OR [City(fixed)] LIKE 'Coffs Harbour%'
        OR [City(fixed)] LIKE 'Campbelltown%' OR [City(fixed)] LIKE 'Armidale%'
        OR [City(fixed)] LIKE 'Cooma%' OR [City(fixed)] LIKE 'Rhodes%'
        OR [City(fixed)] LIKE 'Forster%' OR [City(fixed)] LIKE 'Broken Hill%'
        OR [City(fixed)] LIKE 'Leeton%' OR [City(fixed)] LIKE 'Cessnock%'
        OR [City(fixed)] LIKE 'Blacktown%' OR [City(fixed)] LIKE 'Lennox Head%'
        OR [City(fixed)] LIKE 'Denman%' OR [City(fixed)] LIKE 'Goulburn%'
        OR [City(fixed)] LIKE 'Berkeley Vale%' OR [City(fixed)] LIKE 'Katoomba%'
        OR [City(fixed)] LIKE 'Wyong%' OR [City(fixed)] LIKE 'Deniliquin%'
        OR [City(fixed)] LIKE 'Penrith%' OR [City(fixed)] LIKE 'Tathra%'
        OR [City(fixed)] LIKE 'Dubbo%' OR [City(fixed)] LIKE 'West Wyalong%'
        OR [City(fixed)] LIKE 'Glen Innes%' OR [City(fixed)] LIKE 'Boggabri%'
        OR [City(fixed)] LIKE 'Gosford%' OR [City(fixed)] LIKE 'Byron Bay%'
        OR [City(fixed)] LIKE 'Bathurst%' OR [City(fixed)] LIKE 'Ballina%'
        OR [City(fixed)] LIKE 'Murwillumbah%' OR [City(fixed)] LIKE 'Mudgee%'
        OR [City(fixed)] LIKE 'Grenfell%' OR [City(fixed)] LIKE 'Moree%'
        OR [City(fixed)] LIKE 'Nowra%' OR [City(fixed)] LIKE 'Molong%'
        OR [City(fixed)] LIKE 'Wallacia%' OR [City(fixed)] LIKE 'Port Macquarie%'
        OR [City(fixed)] LIKE 'Richmond%' OR [City(fixed)] LIKE 'Mittagong%'
        OR [City(fixed)] LIKE 'Woy Woy%' OR [City(fixed)] LIKE 'Ulladulla%'
        OR [City(fixed)] LIKE 'Tenterfield%' OR [City(fixed)] LIKE 'Tweed heads%') THEN 'NSW'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(Tasmania)%' OR [City(fixed)] LIKE '%(Tas%' OR [City(fixed)] LIKE '%(Tasmania%'
        OR [City(fixed)] LIKE 'Hobart%' OR [City(fixed)] LIKE 'Launceston%'
        OR [City(fixed)] LIKE 'Devonport%' OR [City(fixed)] LIKE 'Burnie%'
        OR [City(fixed)] LIKE 'George Town%') THEN 'TAS'
        WHEN country = 'Australia' AND ([City(fixed)] LIKE '%(ACT)%' OR [City(fixed)] LIKE '%(act%'
        OR [City(fixed)] LIKE 'Canberra%' OR [City(fixed)] LIKE 'Australian Capital Territory%') THEN 'ACT'

    END
WHERE country = 'Australia'


SELECT *
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE country = 'United Kingdom'
	  OR [City(fixed)] = '%UK%'
ORDER BY [State(fixed)] DESC
      
--The state values for the UK do not corrospond with the city and country values since Uk does not have states, however we can update/replace state values as the countries wihtin the UK eg Scottland, England etc

SELECT [city(fixed)], [state(fixed)], country,
    CASE 
        WHEN [City(fixed)] LIKE '%(Uk/England)%' 
            OR [City(fixed)] LIKE '%England%' OR [City(fixed)] LIKE '%endland%' 
			OR [City(fixed)] LIKE '%London%' OR [City(fixed)] LIKE '%Birmingham%'THEN 'England'
        WHEN [City(fixed)] LIKE '%(Uk/Scotland)%'  
            OR [City(fixed)] LIKE '%(Scotland)%' THEN 'Scotland'
        WHEN [City(fixed)] LIKE '%(Uk/Wales)%' 
            OR [City(fixed)] LIKE '%(Wales)%'
			OR [City(fixed)] LIKE '%Wales%'THEN 'Wales'
        WHEN [City(fixed)] LIKE '%(Uk/Northern Ireland)%' 
            OR [City(fixed)] LIKE '%(Northern Ireland)%' OR [City(fixed)] LIKE '%N. Ireland%' THEN 'Northern Ireland'
    END AS state_code
	FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE country = 'United Kingdom'
      AND ([State(fixed)] IS NULL 
           OR [State(fixed)] IN ('BC', 'LA', 'MS', 'NC', 'NS', 'NT', 'RI', 'SK', 'TN', 'WV', 'YT'))

--Update

UPDATE PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
SET [State(fixed)] = 
    CASE 
        WHEN [City(fixed)] LIKE '%(Uk/England)%' 
            OR [City(fixed)] LIKE '%England%' OR [City(fixed)] LIKE '%endland%' 
            OR [City(fixed)] LIKE '%London%' OR [City(fixed)] LIKE '%Birmingham%' THEN 'England'
        WHEN [City(fixed)] LIKE '%(Uk/Scotland)%'  
            OR [City(fixed)] LIKE '%(Scotland)%' THEN 'Scotland'
        WHEN [City(fixed)] LIKE '%(Uk/Wales)%' 
            OR [City(fixed)] LIKE '%(Wales)%'
            OR [City(fixed)] LIKE '%Wales%' THEN 'Wales'
        WHEN [City(fixed)] LIKE '%(Uk/Northern Ireland)%' 
            OR [City(fixed)] LIKE '%(Northern Ireland)%' OR [City(fixed)] LIKE '%N. Ireland%' THEN 'Northern Ireland'
    END
WHERE country = 'United Kingdom'
      AND ([State(fixed)] IS NULL 
           OR [State(fixed)] IN ('BC', 'LA', 'MS', 'NC', 'NS', 'NT', 'RI', 'SK', 'TN', 'WV', 'YT'))

--USA

SELECT 
    [City(fixed)], [State(fixed)],
    country as current_country,
    'United States' as would_be_updated_to
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE country IS NULL 
AND [State(fixed)] IN (
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
    'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
    'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'DC'
)

--Update
UPDATE PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
SET country = 'United States'
WHERE country IS NULL 
AND [State(fixed)] IN (
    'AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA',
    'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD',
    'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ',
    'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC',
    'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'DC'
)
--Canada 

SELECT 
    [State(fixed)],
    country as current_country,
    'Canada' as would_be_updated_to
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE country IS NULL 
AND [State(fixed)] IN ('AB', 'BC', 'MB', 'ON', 'NS', 'SK', 'NT')

--Update
UPDATE PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
SET country = 'Canada'
WHERE country IS NULL 
AND [State(fixed)] IN ('AB', 'BC', 'MB', 'ON', 'NS', 'SK', 'NT')

--Shape nulls--

--using the comments, idetify if shape of UFO was decribed, use that info to update shap column
--firstly idetify shape descriptions and quantity

SELECT [shape(fixed)]
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE [Shape(fixed)] IS NOT NULL
GROUP BY [Shape(fixed)] 
ORDER BY [Shape(fixed)] 

--24 out of the 27 are shapes (dynamic, is made up by descriptions of changing shapes or in formation, other needs further investigating plus unknown)

SELECT comments, [shape(fixed)],
    CASE 
    -- Light patterns (specific to general)
    WHEN comments LIKE '%ball of light%' THEN 'Sphere'
    WHEN comments LIKE '%beam of light%' THEN 'Cylinder'
    WHEN comments LIKE '%point of light%' THEN 'Light'
    WHEN comments LIKE '%light source%' THEN 'Light'
    WHEN comments LIKE '%Bright Light%' THEN 'Light'

    -- Dynamic/Changing patterns
    WHEN comments LIKE '%formation of lights%' 
         OR comments LIKE '%changing formation%' 
         OR comments LIKE '%changing shape%'
         OR comments LIKE '%formation of shapes%'
         OR comments LIKE '%changing pattern%'
         OR comments LIKE '%morphing%'
         OR comments LIKE '%changing colour%'
         OR comments LIKE '%changing color%'
         OR comments LIKE '%transforming%'
         OR comments LIKE '%shape shifting%'
         OR comments LIKE '%formation in sky%'
         OR comments LIKE '%moving formation%'
         OR comments LIKE '%formation of objects%'
         OR comments LIKE '%shifting shape%'
         OR comments LIKE '%changing form%'
         OR comments LIKE '%shape changed%'
         OR comments LIKE '%multiple formations%' THEN 'Dynamic'

    -- Round/Circular shapes
    WHEN comments LIKE '%Circle%' OR comments LIKE 'circular' THEN 'Circle'
    WHEN comments LIKE '%Round%' THEN 'Round'
    WHEN comments LIKE '%sphere%' 
         OR comments LIKE '%spherical%'
         OR comments LIKE '%ball%'
         OR comments LIKE '%ball shaped%'
         OR comments LIKE '%ball-like%' THEN 'Sphere'
    WHEN comments LIKE '%Disk%' THEN 'Disk'
    WHEN comments LIKE '%Dome%' THEN 'Dome'

    -- Triangular/Angular shapes
    WHEN comments LIKE '%Chevron%' OR comments LIKE '%V shape%' THEN 'Chevron'
    WHEN comments LIKE '%Triangle%' OR comments LIKE '%triangular%' THEN 'Triangle'
    WHEN comments LIKE '%Delta%' THEN 'Delta'
    WHEN comments LIKE '%Diamond%' THEN 'Diamond'
    WHEN comments LIKE '%Pyramid%' THEN 'Pyramid'

    -- Elongated shapes
    WHEN comments LIKE '%Cigar%' THEN 'Cigar'
    WHEN comments LIKE '%Cylinder%' THEN 'Cylinder'

    -- Other geometric shapes
    WHEN comments LIKE '%Hexagon%' OR comments LIKE '%hexagonal%' THEN 'Hexagon'
    WHEN comments LIKE '%Rectangle%' OR comments LIKE '%Rectangular%' THEN 'Rectangle'
    WHEN comments LIKE '%Cone%' THEN 'Cone'
    WHEN comments LIKE '%Cross%' OR comments LIKE 'X shape' THEN 'Cross'
    
    -- Irregular shapes
    WHEN comments LIKE '%Crescent%' THEN 'Crescent'
    WHEN comments LIKE '%Egg%' THEN 'Egg'
    WHEN comments LIKE '%Oval%' THEN 'Oval'
    WHEN comments LIKE '%Teardrop%' THEN 'Teardrop'

    -- Light phenomena
    WHEN comments LIKE '%Fireball%' THEN 'Fireball'
    WHEN comments LIKE '%Flare%' THEN 'Flare'
    WHEN comments LIKE '%Flash%' THEN 'Flash'
    
    -- Generic light (most general - keep at end)
    WHEN comments LIKE '%light%' THEN 'Light'
    END AS shape_code
	FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
	WHERE [shape(fixed)] IS NULL

	ORDER BY shape_code DESC

--Update

UPDATE PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
SET [shape(fixed)] = 
    CASE 
    -- Light patterns (specific to general)
    WHEN comments LIKE '%ball of light%' THEN 'Sphere'
    WHEN comments LIKE '%beam of light%' THEN 'Cylinder'
    WHEN comments LIKE '%point of light%' THEN 'Light'
    WHEN comments LIKE '%light source%' THEN 'Light'
    WHEN comments LIKE '%Bright Light%' THEN 'Light'
    -- Dynamic/Changing patterns
    WHEN comments LIKE '%formation of lights%' 
         OR comments LIKE '%changing formation%' 
         OR comments LIKE '%changing shape%'
         OR comments LIKE '%formation of shapes%'
         OR comments LIKE '%changing pattern%'
         OR comments LIKE '%morphing%'
         OR comments LIKE '%changing colour%'
         OR comments LIKE '%changing color%'
         OR comments LIKE '%transforming%'
         OR comments LIKE '%shape shifting%'
         OR comments LIKE '%formation in sky%'
         OR comments LIKE '%moving formation%'
         OR comments LIKE '%formation of objects%'
         OR comments LIKE '%shifting shape%'
         OR comments LIKE '%changing form%'
         OR comments LIKE '%shape changed%'
         OR comments LIKE '%multiple formations%' THEN 'Dynamic'
    -- Round/Circular shapes
    WHEN comments LIKE '%Circle%' OR comments LIKE 'circular' THEN 'Circle'
    WHEN comments LIKE '%Round%' THEN 'Round'
    WHEN comments LIKE '%sphere%' 
         OR comments LIKE '%spherical%'
         OR comments LIKE '%ball%'
         OR comments LIKE '%ball shaped%'
         OR comments LIKE '%ball-like%' THEN 'Sphere'
    WHEN comments LIKE '%Disk%' THEN 'Disk'
    WHEN comments LIKE '%Dome%' THEN 'Dome'
    -- Triangular/Angular shapes
    WHEN comments LIKE '%Chevron%' OR comments LIKE '%V shape%' THEN 'Chevron'
    WHEN comments LIKE '%Triangle%' OR comments LIKE '%triangular%' THEN 'Triangle'
    WHEN comments LIKE '%Delta%' THEN 'Delta'
    WHEN comments LIKE '%Diamond%' THEN 'Diamond'
    WHEN comments LIKE '%Pyramid%' THEN 'Pyramid'
    -- Elongated shapes
    WHEN comments LIKE '%Cigar%' THEN 'Cigar'
    WHEN comments LIKE '%Cylinder%' THEN 'Cylinder'
    -- Other geometric shapes
    WHEN comments LIKE '%Hexagon%' OR comments LIKE '%hexagonal%' THEN 'Hexagon'
    WHEN comments LIKE '%Rectangle%' OR comments LIKE '%Rectangular%' THEN 'Rectangle'
    WHEN comments LIKE '%Cone%' THEN 'Cone'
    WHEN comments LIKE '%Cross%' OR comments LIKE 'X shape' THEN 'Cross'
    -- Irregular shapes
    WHEN comments LIKE '%Crescent%' THEN 'Crescent'
    WHEN comments LIKE '%Egg%' THEN 'Egg'
    WHEN comments LIKE '%Oval%' THEN 'Oval'
    WHEN comments LIKE '%Teardrop%' THEN 'Teardrop'
    -- Light phenomena
    WHEN comments LIKE '%Fireball%' THEN 'Fireball'
    WHEN comments LIKE '%Flare%' THEN 'Flare'
    WHEN comments LIKE '%Flash%' THEN 'Flash'
    -- Generic light (most general - keep at end)
    WHEN comments LIKE '%light%' THEN 'Light'
    END
WHERE [shape(fixed)] IS NULL

--Change city/state/country vaslues to NULL

SELECT *
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE [City(fixed)] IN ('?', '??', '??', '??', '?????', 
                      '((Unspecified Location))', 
                      '((Unspecified))',
                      '(Unspecified)',
                      '((Location Unspecified)) (Uk/England)',
                      '((Town Name Temporarily Deleted))',
                      '((Name Of Town Deleted))',
                      '(Unknown)')


UPDATE PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
SET [City(fixed)] = null
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE [City(fixed)] IN ('?', '??', '??', '??', '?????', 
                      '((Unspecified Location))', 
                      '((Unspecified))',
                      '(Unspecified)',
                      '((Location Unspecified)) (Uk/England)',
                      '((Town Name Temporarily Deleted))',
                      '((Name Of Town Deleted))',
                      '(Unknown)')

--Rechecked null value percentage, now 13.74%, this is sufficient enough to work with

              --Cleaning (removing) values--

		
--begin by highlighting missing crucial data from rows with the most incomplte columns
--i.e. lat, loing, city, country duration, shape

SELECT * 
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned 
WHERE latitude IS NULL 
AND longitude IS NULL
AND [State(fixed)] IS NULL 
AND country IS NULL 
AND [duration (seconds)] IS NULL
AND [Shape(fixed)] IS NULL

SELECT * 
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned 
WHERE NOT (

    (latitude IS NOT NULL AND longitude IS NOT NULL)
    OR
    ([City(fixed)] IS NOT NULL AND country IS NOT NULL)
)

--identified several keywords in comments cloumn with questionable UFO sighting validity/realiblity most notably indicated by the National UFO Reporting Center 

--begin by creating sevearl queriues that oraginse questionable data for clarity

--HOAX AND NUFORC

SELECT *
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE (
    Comments LIKE '%((HOAX))%'
	OR Comments LIKE '%HOAX%'
    OR Comments LIKE '%((NUFORC Note: Hoax%'
    OR Comments LIKE '%((NUFORC Note:%'
)
ORDER BY Comments

--NOT A UFO

SELECT *
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE (
    Comments LIKE '%not a UFO%'
    OR Comments LIKE '%does not look like%'
    OR Comments LIKE '%this isn''t an actual sighting%'
    OR Comments LIKE '%this is not a UFO report%'
    OR Comments LIKE '%may not be%UFO%'
)
AND (
    Comments NOT LIKE '%((HOAX))%'
    AND Comments NOT LIKE '%HOAX%'
    AND Comments NOT LIKE '%((NUFORC Note: Hoax%'
    AND Comments NOT LIKE '%((NUFORC Note:%'
)
ORDER BY Comments


--somethinng other than UFO

SELECT *
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned
WHERE (
   -- Known phenomena confirmations
   Comments LIKE '%turned out to be%star%'
   OR Comments LIKE '%turned out to be%plane%'
   OR Comments LIKE '%turned out to be%aircraft%'
   OR Comments LIKE '%turned out to be%satellite%'
   OR Comments LIKE '%turned out to be%ISS%'
   OR Comments LIKE '%turned out to be%space station%'
   OR Comments LIKE '%turned out to be%balloon%'
   OR Comments LIKE '%turned out to be%helicopter%'
   OR Comments LIKE '%turned out to be%meteor%'
   OR Comments LIKE '%turned out to be%planet%'
   OR Comments LIKE '%turned out to be%lantern%'
   OR Comments LIKE '%turned out to be%reflection%'
   OR Comments LIKE '%turned out to be%venus%'
   OR Comments LIKE '%turned out to be%jupiter%'
   OR Comments LIKE '%turned out to be%mars%'
   
   -- Confirmed as variations
   OR Comments LIKE '%confirmed as%spotlight%'
   OR Comments LIKE '%confirmed as%aircraft%'
   OR Comments LIKE '%confirmed as%star%'
   OR Comments LIKE '%confirmed as%balloon%'
   OR Comments LIKE '%confirmed as%satellite%'
   
   -- Identified as variations
   OR Comments LIKE '%identified as%NASA%'
   OR Comments LIKE '%identified as%meteor%'
   OR Comments LIKE '%identified as%aircraft%'
   OR Comments LIKE '%identified as%satellite%'
   
   -- Was actually variations
   OR Comments LIKE '%was actually%star%'
   OR Comments LIKE '%was actually%planet%'
   OR Comments LIKE '%was actually%aircraft%'
   
   -- Determined/Found variations
   OR Comments LIKE '%determined to be%lantern%'
   OR Comments LIKE '%determined to be%balloon%'
   OR Comments LIKE '%found to be%aircraft%'
   OR Comments LIKE '%found to be%satellite%'
   
   -- Dreams
   OR Comments LIKE '%was a dream%'
   OR Comments LIKE '%in my dream%'
   OR Comments LIKE '%during a dream%'
   OR Comments LIKE '%had a dream%'
)

AND (
    Comments NOT LIKE '%((HOAX))%'
    AND Comments NOT LIKE '%HOAX%'
    AND Comments NOT LIKE '%((NUFORC Note: Hoax%'
    AND Comments NOT LIKE '%((NUFORC Note:%'
	AND Comments NOT LIKE '%not a UFO%'
    AND Comments NOT LIKE '%does not look like%'
    AND Comments NOT LIKE '%this isn''t an actual sighting%'
    AND Comments NOT LIKE '%this is not a UFO report%'
    AND Comments NOT LIKE '%may not be%UFO%'
	AND Comments NOT LIKE '%was actually staying%'
)
ORDER BY Comments



--create a view table that excludes unuseable data (clean/valid data table)

CREATE VIEW UFO_Sightings_Final_Clean AS
SELECT * 
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned 
WHERE 
-- Location validation (must have either coordinates OR complete location info)
(
    (latitude IS NOT NULL AND longitude IS NOT NULL)
    OR
    ([City(fixed)] IS NOT NULL AND country IS NOT NULL)
)
AND NOT (
    -- Remove records missing multiple critical fields
    latitude IS NULL 
    AND longitude IS NULL
    AND [State(fixed)] IS NULL 
    AND country IS NULL 
    AND [duration (seconds)] IS NULL
    AND [Shape(fixed)] IS NULL
)
AND NOT (
   -- Known phenomena confirmations
   Comments LIKE '%turned out to be%star%'
   OR Comments LIKE '%turned out to be%plane%'
   OR Comments LIKE '%turned out to be%aircraft%'
   OR Comments LIKE '%turned out to be%satellite%'
   OR Comments LIKE '%turned out to be%ISS%'
   OR Comments LIKE '%turned out to be%space station%'
   OR Comments LIKE '%turned out to be%balloon%'
   OR Comments LIKE '%turned out to be%helicopter%'
   OR Comments LIKE '%turned out to be%meteor%'
   OR Comments LIKE '%turned out to be%planet%'
   OR Comments LIKE '%turned out to be%lantern%'
   OR Comments LIKE '%turned out to be%reflection%'
   OR Comments LIKE '%turned out to be%venus%'
   OR Comments LIKE '%turned out to be%jupiter%'
   OR Comments LIKE '%turned out to be%mars%'
   
   -- Confirmed as variations
   OR Comments LIKE '%confirmed as%spotlight%'
   OR Comments LIKE '%confirmed as%aircraft%'
   OR Comments LIKE '%confirmed as%star%'
   OR Comments LIKE '%confirmed as%balloon%'
   OR Comments LIKE '%confirmed as%satellite%'
   
   -- Identified as variations
   OR Comments LIKE '%identified as%NASA%'
   OR Comments LIKE '%identified as%meteor%'
   OR Comments LIKE '%identified as%aircraft%'
   OR Comments LIKE '%identified as%satellite%'
   
   -- Was actually variations
   OR Comments LIKE '%was actually%star%'
   OR Comments LIKE '%was actually%planet%'
   OR Comments LIKE '%was actually%aircraft%'
   
   -- Determined/Found variations
   OR Comments LIKE '%determined to be%lantern%'
   OR Comments LIKE '%determined to be%balloon%'
   OR Comments LIKE '%found to be%aircraft%'
   OR Comments LIKE '%found to be%satellite%'
   
   -- Dreams
   OR Comments LIKE '%was a dream%'
   OR Comments LIKE '%in my dream%'
   OR Comments LIKE '%during a dream%'
   OR Comments LIKE '%had a dream%'
   
   -- Hoaxes and invalid reports
   OR Comments LIKE '%((HOAX))%'
   OR Comments LIKE '%HOAX%'
   OR Comments LIKE '%((NUFORC Note: Hoax%'
   OR Comments LIKE '%((NUFORC Note:%'
   OR Comments LIKE '%not a UFO%'
   OR Comments LIKE '%does not look like%'
   OR Comments LIKE '%this isn''t an actual sighting%'
   OR Comments LIKE '%this is not a UFO report%'
   OR Comments LIKE '%may not be%UFO%'
   OR Comments LIKE '%was actually staying%'
)

Select *
From UFO_Sightings_Final_Clean



                 --Inspect city cloumn for data cleaning--

				 -- Remove parentheses from city column
SELECT 
    [City(fixed)] as OriginalCity,
    CASE 
        WHEN CHARINDEX('(', [City(fixed)]) > 0 
        THEN TRIM(LEFT([City(fixed)], CHARINDEX('(', [City(fixed)]) - 1))
        WHEN CHARINDEX('/', [City(fixed)]) > 0
        THEN TRIM(LEFT([City(fixed)], CHARINDEX('/', [City(fixed)]) - 1))
        ELSE [City(fixed)]
    END as CleanedCity
FROM UFO_Sightings_Final_Clean
WHERE [City(fixed)] LIKE '%(%' 
   OR [City(fixed)] LIKE '%/%'
ORDER BY [City(fixed)]

--for simplicty and a cleaner dataset, this analysis will soley focus on grounf UFO_Sightings (since the number of ariel sightings is very low, it shouldt affect the data). 

SELECT * 
FROM  UFO_Sightings_Final_Clean
WHERE  
--(latitude IS NULL AND longitude IS NULL) AND 
(

   [City(fixed)] LIKE '%above%'
   OR [City(fixed)] LIKE '%flight%'
   OR [City(fixed)] LIKE '%airplane%'

   	     )
ORDER BY [City(fixed)]



--UPDATE (Alter) VIEW

ALTER VIEW UFO_Sightings_Final_Clean AS
SELECT *, 
    CASE 
        WHEN CHARINDEX('(', [City(fixed)]) > 0 
        THEN TRIM(LEFT([City(fixed)], CHARINDEX('(', [City(fixed)]) - 1))
        WHEN CHARINDEX('/', [City(fixed)]) > 0
        THEN TRIM(LEFT([City(fixed)], CHARINDEX('/', [City(fixed)]) - 1))
        ELSE [City(fixed)]
		END AS CityCleaned
FROM PortfolioProject.dbo.UFO_Sightings_Excel_Cleaned 
WHERE 

(
    (latitude IS NOT NULL AND longitude IS NOT NULL)
    OR
    ([City(fixed)] IS NOT NULL AND country IS NOT NULL)
)
AND NOT (

    latitude IS NULL 
    AND longitude IS NULL
    AND [State(fixed)] IS NULL 
    AND country IS NULL 
    AND [duration (seconds)] IS NULL
    AND [Shape(fixed)] IS NULL
)
AND NOT (

   Comments LIKE '%turned out to be%star%'
   OR Comments LIKE '%turned out to be%plane%'
   OR Comments LIKE '%turned out to be%aircraft%'
   OR Comments LIKE '%turned out to be%satellite%'
   OR Comments LIKE '%turned out to be%ISS%'
   OR Comments LIKE '%turned out to be%space station%'
   OR Comments LIKE '%turned out to be%balloon%'
   OR Comments LIKE '%turned out to be%helicopter%'
   OR Comments LIKE '%turned out to be%meteor%'
   OR Comments LIKE '%turned out to be%planet%'
   OR Comments LIKE '%turned out to be%lantern%'
   OR Comments LIKE '%turned out to be%reflection%'
   OR Comments LIKE '%turned out to be%venus%'
   OR Comments LIKE '%turned out to be%jupiter%'
   OR Comments LIKE '%turned out to be%mars%'
   
   OR Comments LIKE '%confirmed as%spotlight%'
   OR Comments LIKE '%confirmed as%aircraft%'
   OR Comments LIKE '%confirmed as%star%'
   OR Comments LIKE '%confirmed as%balloon%'
   OR Comments LIKE '%confirmed as%satellite%'
   
   OR Comments LIKE '%identified as%NASA%'
   OR Comments LIKE '%identified as%meteor%'
   OR Comments LIKE '%identified as%aircraft%'
   OR Comments LIKE '%identified as%satellite%'
   
   OR Comments LIKE '%was actually%star%'
   OR Comments LIKE '%was actually%planet%'
   OR Comments LIKE '%was actually%aircraft%'
   
   OR Comments LIKE '%determined to be%lantern%'
   OR Comments LIKE '%determined to be%balloon%'
   OR Comments LIKE '%found to be%aircraft%'
   OR Comments LIKE '%found to be%satellite%'
   
   OR Comments LIKE '%was a dream%'
   OR Comments LIKE '%in my dream%'
   OR Comments LIKE '%during a dream%'
   OR Comments LIKE '%had a dream%'
   
   OR Comments LIKE '%((HOAX))%'
   OR Comments LIKE '%HOAX%'
   OR Comments LIKE '%((NUFORC Note: Hoax%'
   OR Comments LIKE '%((NUFORC Note:%'
   OR Comments LIKE '%not a UFO%'
   OR Comments LIKE '%does not look like%'
   OR Comments LIKE '%this isn''t an actual sighting%'
   OR Comments LIKE '%this is not a UFO report%'
   OR Comments LIKE '%may not be%UFO%'
   OR Comments LIKE '%was actually staying%'

--removes sighitngs from flights
   OR [City(fixed)] LIKE '%above%'
   OR [City(fixed)] LIKE '%flight%'
   OR [City(fixed)] LIKE '%airplane%'
   OR [City(fixed)] LIKE '%airline%'
 OR [City(fixed)] LIKE '%airways%'
 OR [City(fixed)] LIKE '%plane%'

   )


--CHECK VIEW

SELECT *
FROM UFO_Sightings_Final_Clean
ORDER BY CityCleaned


           --check for double ups--


--Find duplicates based on rows with cleaned data 

WITH RowNumCTE AS(
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY CityCleaned,
                     [State(fixed)],
                     latitude,
                     longitude,
                     LEFT([Date_sighted(fixed)], 10)
        ORDER BY [Time_sighted(fixed)]
    ) row_num
    FROM UFO_Sightings_Final_Clean
    WHERE CityCleaned IS NOT NULL
    AND [State(fixed)] IS NOT NULL
    AND latitude IS NOT NULL
    AND longitude IS NOT NULL
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY row_num
         
   
 -- after reviewing possible duplicates, a question arose that these duplicates could infact be other eye witnessnes since no names are within the data. for example the mass sighting at Tinley Park

WITH RowNumCTE AS(
    SELECT *,
    ROW_NUMBER() OVER (
        PARTITION BY CityCleaned,
                     [State(fixed)],
                     latitude,
                     longitude,
                     LEFT([Date_sighted(fixed)], 10)
        ORDER BY [Time_sighted(fixed)]
    ) row_num
    FROM UFO_Sightings_Final_Clean
    WHERE CityCleaned IS NOT NULL
    AND [State(fixed)] IS NOT NULL
    AND latitude IS NOT NULL
    AND longitude IS NOT NULL
)
SELECT * 
FROM RowNumCTE
WHERE CityCleaned = 'Tinley Park' 
AND [State(fixed)] = 'IL'
AND [Date_sighted(fixed)] = '10/31/2004'
ORDER BY row_num



-- create a view that groups similar sightings
 DROP VIEW Mass_UFO_Sightings
CREATE VIEW Mass_UFO_Sightings AS
WITH SightingGroups AS (
    SELECT 
        CityCleaned,
        [State(fixed)],
        LEFT([Date_sighted(fixed)], 10) as SightingDate,
        latitude,
        longitude,
        COUNT(*) as NumberOfWitnesses,
        MIN([Time_sighted(fixed)]) as FirstReport,
        MAX([Time_sighted(fixed)]) as LastReport,
        STRING_AGG(CAST(Comments as NVARCHAR(MAX)), ' | ') WITHIN GROUP (ORDER BY [Time_sighted(fixed)]) as AllDescriptions
    FROM UFO_Sightings_Final_Clean
    GROUP BY 
        CityCleaned,
        [State(fixed)],
        LEFT([Date_sighted(fixed)], 10),
        latitude,
        longitude
    HAVING COUNT(*) > 3
)
SELECT *
FROM SightingGroups

--View Mass_UFO_Sightings table 


SELECT 
    CityCleaned,
    [State(fixed)],
    SightingDate,
    NumberOfWitnesses,
    FirstReport,
    LastReport
FROM Mass_UFO_Sightings
ORDER BY NumberOfWitnesses DESC

-- these mass sightings give significant credability to the UFO Sightings analysis


--Save both view tables and export as a CSV to present in Tableau 

SELECT * FROM Mass_UFO_Sightings

SELECT 
    [Date_sighted(fixed)] as 'Date_Sighted',
    [Time_sighted(fixed)] as 'Time_Sighted',
    CityCleaned as 'City',
    [State(fixed)] as 'State',
    country as 'Country',
    [Shape(fixed)] as 'Shape',
    [duration (seconds)] as 'Duration_Seconds',
    Comments,
    [Date_posted(fixed)] as 'Date_Posted',
    latitude as 'Latitude',
    longitude as 'Longitude'
FROM UFO_Sightings_Final_Clean