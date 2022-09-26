-- 1. 
/*
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2
*/
--U1: TableauTable1
--Total cases, deaths, CFR
SELECT
--location,
 --   dan,
    SUM(new_cases)                                    AS total_cases,
    SUM(new_deaths)                                   AS total_deaths,
   ROUND( ( SUM(new_deaths) / SUM(new_cases) ) * 100,3)        AS death_pct
FROM
    covid_deaths
WHERE
    continent IS NOT NULL
--GROUP BY
 --   dan
ORDER BY
    1,
    2;
    
/*
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc
*/

--U2:TableauTable2
--Total death count per continents
SELECT
location,
SUM(new_deaths) AS total_death_cnt
FROM covid_deaths
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY 2 DESC;


/*
-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc
*/

--U3: TableauTable3
--Max infection rate over population
SELECT
location,
population,
MAX(total_cases) AS HighestInfectionCount,
ROUND(MAX((total_cases/population))*100,3) as PercentPopulationInfected
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY 4 DESC;

/*
-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc
*/

--U4:TableauTable4
--Infections per day and locations
SELECT
location,
population,
dan,
NVL(MAX(total_cases),0) AS HighestInfectionCount,
ROUND(NVL(MAX((total_cases/population)),0)*100,3) as PercentPopulationInfected
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY dan,location,population
ORDER BY 4 DESC;
