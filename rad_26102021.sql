SELECT
    *
FROM
    covid_deaths
ORDER BY
    3,
    4;	dwhforbi	1635233724043	SQL	2	0.051
	
	
	
	
SELECT
    *
FROM
    covid_vaccinations
ORDER BY
    3,
    4;	dwhforbi	1635233797199	SQL	2	0.096
	
	
SELECT
    location,
    dan,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    covid_deaths
ORDER BY
    1,
    2;	dwhforbi	1635233868362	SQL	1	0.118
	
	
SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
--population
    ( total_deaths / total_cases ) * 100 AS death_pct
FROM
    covid_deaths
--WHERE location = 'United States'
WHERE
        location = 'Bosnia and Herzegovina'
--WHERE location = 'Serbia'
--WHERE location = 'Slovenia'
--WHERE location =  'Croatia'
--WHERE location =  'Montenegro'
--WHERE location = 'North Macedonia'
--WHERE location = 'Kosovo'
    AND dan > sysdate - 27--'20-OCT-21'
ORDER BY
    1,
    2;	dwhforbi	1635233921563	SQL	1	0.017
	
	
SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
--population
    ( total_deaths / total_cases ) * 100 AS death_pct
FROM
    covid_deaths
--WHERE location = 'United States'
WHERE
        location = 'Bosnia and Herzegovina'
--WHERE location = 'Serbia'
--WHERE location = 'Slovenia'
--WHERE location =  'Croatia'
--WHERE location =  'Montenegro'
--WHERE location = 'North Macedonia'
--WHERE location = 'Kosovo'
    AND dan > sysdate - 26--'20-OCT-21'
ORDER BY
    1,
    2;	dwhforbi	1635234346073	SQL	3	0.01
	
	
SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
--population
    ( total_deaths / total_cases ) * 100 AS death_pct
FROM
    covid_deaths
--WHERE location = 'United States'
WHERE
        location = 'Bosnia and Herzegovina'
--WHERE location = 'Serbia'
--WHERE location = 'Slovenia'
--WHERE location =  'Croatia'
--WHERE location =  'Montenegro'
--WHERE location = 'North Macedonia'
--WHERE location = 'Kosovo'
    AND dan > sysdate - 8--'20-OCT-21'
ORDER BY
    1,
    2;	dwhforbi	1635234361663	SQL	1	0.01
	
SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
--population
    ( total_deaths / total_cases ) * 100 AS death_pct
FROM
    covid_deaths
--WHERE location = 'United States'
WHERE
        location = 'Bosnia and Herzegovina'
--WHERE location = 'Serbia'
--WHERE location = 'Slovenia'
--WHERE location =  'Croatia'
--WHERE location =  'Montenegro'
--WHERE location = 'North Macedonia'
--WHERE location = 'Kosovo'
    AND dan > sysdate - 7--'20-OCT-21'
ORDER BY
    1,
    2;	dwhforbi	1635234369743	SQL	1	0.009
	
SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
--population
    ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths / total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths
--WHERE location = 'United States'
WHERE
        location = 'Bosnia and Herzegovina'
--WHERE location = 'Serbia'
--WHERE location = 'Slovenia'
--WHERE location =  'Croatia'
--WHERE location =  'Montenegro'
--WHERE location = 'North Macedonia'
--WHERE location = 'Kosovo'
    AND dan > sysdate - 7--'20-OCT-21'
ORDER BY
    1,
    2;	dwhforbi	1635234599849	SQL	1	0.433
	
	
SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
--population
    ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths / total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths;	dwhforbi	1635234643947	SQL	1	0.049
	
	
SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
--population
    ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths / total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7;	dwhforbi	1635234681343	SQL	1	0.014


SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
 --   population
    ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths / total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND total_cases >= 100000;	dwhforbi	1635235197629	SQL	1	0.015



SELECT *
FROM covid_deaths
WHERE location = 'World';	dwhforbi	1635235336938	SQL	1	0.165



SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
 --   population
    ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths / total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND continent IS NOT NULL;	dwhforbi	1635235848044	SQL	1	0.185


SELECT
    location,
    dan,
    total_cases,
--new_cases,
    total_deaths,
 --   population
    ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths / total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND total_cases >= 100000
AND continent IS NOT NULL;	dwhforbi	1635235880318	SQL	2	0.013



SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
 --   population
   -- ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND continent IS NOT NULL;	dwhforbi	1635236050228	SQL	1	0.144


SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
   population,
   -- ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND continent IS NOT NULL;	dwhforbi	1635236649973	SQL	1	0.136


SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
 --   population
   -- ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia')
AND continent IS NOT NULL;	dwhforbi	1635238091578	SQL	1	0.018

SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
     population,
    ( total_cases / population ) * 100 AS cases_per_popul_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases / population DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND continent IS NOT NULL;	dwhforbi	1635238374883	SQL	1	0.012


SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
     population,
   ROUND( ( total_cases / population ) * 100,2) AS cases_per_popul_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases / population DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND continent IS NOT NULL;	dwhforbi	1635238476534	SQL	1	0.013



SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
     population,
   ROUND( ( total_cases / population ) * 100,2) AS cases_per_popul_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases / population DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
AND population >= 1000000
AND continent IS NOT NULL;	dwhforbi	1635238841546	SQL	1	0.015



SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
     population,
   ROUND( ( total_cases / population ) * 100,2) AS cases_per_popul_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases / population DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan > sysdate - 7
--AND population >= 1000000-- ako hocu samo zemlje sa preko milion stanovnika
AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia')
AND continent IS NOT NULL;	dwhforbi	1635239147402	SQL	1	0.018


SELECT
    location,
--dan,
    population,
    MAX(total_cases)                            AS max_inf_cnt,
--new_cases,
--total_deaths,
--population
--(total_deaths/total_cases)*100 AS DEATH_PCT
    MAX((total_cases / population)) * 100       AS max_cases_per_popul_pct
FROM
    covid_deaths
--WHERE location = 'United States'
--WHERE location = 'Bosnia and Herzegovina'
--WHERE location = 'Serbia'
--WHERE location = 'Slovenia'
--WHERE location =  'Croatia'
--WHERE location =  'Montenegro'
--WHERE location = 'North Macedonia'
--WHERE location = 'Kosovo'
--AND dan > SYSDATE - 2--'20-OCT-21'
GROUP BY
    location,
--dan,
    population
ORDER BY
    4 DESC;	dwhforbi	1635240276098	SQL	1	0.062
	
	
	
SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
     population,
   ROUND( ( total_cases / population ) * 100,2) AS cases_per_popul_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases / population DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan = (SELECT MAX(dan) FROM covid_deaths)-- sysdate - 7
--AND population >= 1000000-- ako hocu samo zemlje sa preko milion stanovnika
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia')--WBC+ zemlje
AND continent IS NOT NULL;	dwhforbi	1635240391047	SQL	1	0.026


SELECT
     dan,
     location,
     total_cases,
--new_cases,
  -- total_deaths,
 --   population
   -- ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_cases DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan = (SELECT MAX(dan) FROM covid_deaths)
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia')--WBC+ zemlje
AND continent IS NOT NULL;	dwhforbi	1635240445067	SQL	1	0.02



SELECT
     dan,
     location,
   --  total_cases,
--new_cases,
  total_deaths,
 --   population
   -- ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan = (SELECT MAX(dan) FROM covid_deaths)
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia')--WBC+ zemlje
AND continent IS NOT NULL;	dwhforbi	1635241384555	SQL	1	0.02




SELECT
     dan,
     location,
   --  total_cases,
--new_cases,
  total_deaths,
 --   population
   -- ( total_deaths / total_cases ) * 100 AS death_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan = (SELECT MAX(dan) FROM covid_deaths)
AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia')--WBC+ zemlje
AND continent IS NOT NULL;	dwhforbi	1635241498813	SQL	1	0.025


SELECT
     dan,
     location,
     --total_cases,
--new_cases,
  total_deaths,
     population,
   ROUND( ( total_deaths / population ) * 100,2) AS deaths_per_popul_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths / population DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan = (SELECT MAX(dan) FROM covid_deaths)-- sysdate - 7
--AND population >= 1000000-- ako hocu samo zemlje sa preko milion stanovnika
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia')--WBC+ zemlje
AND continent IS NOT NULL;	dwhforbi	1635241714872	SQL	1	0.022


SELECT
     dan,
     location,
     --total_cases,
--new_cases,
  total_deaths,
     population,
   ROUND( ( total_deaths / population ) * 100,3) AS deaths_per_popul_pct,
    ROW_NUMBER() OVER(ORDER BY total_deaths / population DESC NULLS LAST) AS RED
FROM
    covid_deaths

WHERE dan = (SELECT MAX(dan) FROM covid_deaths)-- sysdate - 7
--AND population >= 1000000-- ako hocu samo zemlje sa preko milion stanovnika
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia')--WBC+ zemlje
AND continent IS NOT NULL;	dwhforbi	1635241779535	SQL	1	1.632



SELECT
    location,
--dan,
--population,
    MAX(total_deaths) AS total_deaths_cnt
--new_cases,
--total_deaths,
--population
--(total_deaths/total_cases)*100 AS DEATH_PCT
--MAX((total_cases/population))*100 AS MAX_CASES_PER_POPUL_PCT
FROM
    covid_deaths
--WHERE location = 'United States'
--WHERE location = 'Bosnia and Herzegovina'
--WHERE location = 'Serbia'
--WHERE location = 'Slovenia'
--WHERE location =  'Croatia'
--WHERE location =  'Montenegro'
--WHERE location = 'North Macedonia'
--WHERE location = 'Kosovo'
--AND dan > SYSDATE - 2--'20-OCT-21'
WHERE
    continent IS NOT NULL
GROUP BY
    location
--dan,
--population
ORDER BY
    2 DESC;	dwhforbi	1635241895813	SQL	1	0.024
	
	
	
SELECT
--location,
 --   dan,
    SUM(new_cases)                                    AS total_cases,
    SUM(new_deaths)                                   AS total_deaths,
    ( SUM(new_deaths) / SUM(new_cases) ) * 100        AS death_pct
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
--GROUP BY
 --   dan
ORDER BY
    1,
    2;	dwhforbi	1635242020548	SQL	1	1.157
	
	
SELECT
    dan,
    SUM(new_cases)
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY
    dan
ORDER BY
    1,
    2;	dwhforbi	1635245783245	SQL	2	0.021
	
	
	SELECT
    dan,
    SUM(new_cases),
    SUM(new_deaths)
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY
    dan
ORDER BY
    1,
    2;	dwhforbi	1635245877554	SQL	2	0.021
	
	
	
	SELECT
--location,
    dan,
    SUM(new_cases)                                    AS total_cases,
    SUM(new_deaths)                                   AS total_deaths,
    ( SUM(new_deaths) / SUM(new_cases) ) * 100        AS death_pct
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
GROUP BY
    dan
ORDER BY
    1,
    2;	dwhforbi	1635246396803	SQL	3	0.021
	
	
	SELECT
--location,
   -- dan,
    SUM(new_cases)                                    AS total_cases,
    SUM(new_deaths)                                   AS total_deaths,
    ( SUM(new_deaths) / SUM(new_cases) ) * 100        AS death_pct
FROM
    covid_deaths
WHERE
    continent IS NOT NULL;	dwhforbi	1635246894955	SQL	1	0.016
	
	
	
	SELECT
--location,
   -- dan,
    SUM(new_cases)                                    AS total_cases,
    SUM(new_deaths)                                   AS total_deaths,
    ROUND (( SUM(new_deaths) / SUM(new_cases) ) * 100,3 )       AS death_pct
FROM
    covid_deaths
WHERE
    continent IS NOT NULL;	dwhforbi	1635246969991	SQL	1	1.662
	
	
	
	