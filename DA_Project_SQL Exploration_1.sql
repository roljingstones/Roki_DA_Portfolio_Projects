/*
Data Analyst Portfolio Projects
Alex The Analyst
Link:
https://www.youtube.com/playlist?list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f
Projekt 1: SQL Data Exploration

Link:
https://www.youtube.com/watch?v=qfyynHBFOsM&list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f&index=2&t=152s
Link na dataset:
https://ourworldindata.org/covid-deaths
*/

--Provjera da su se tabele dobro ucitale
SELECT
    *
FROM
    covid_deaths
ORDER BY
    3,
    4;

SELECT
    *
FROM
    covid_vaccinations
ORDER BY
    3,
    4;

--Izbor podataka koje cemo koristiti
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
    2;

--Total Cases vs Total Deaths
--CFR
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
    AND dan > sysdate - 2--'20-OCT-21'
ORDER BY
    1,
    2;

--Total Cases vs Population
SELECT
    location,
    dan,
    population,
    total_cases,
--new_cases,
    total_deaths,
--population
--(total_deaths/total_cases)*100 AS DEATH_PCT
    ( total_cases / population ) * 100 AS cases_per_popul_pct
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
ORDER BY
    1,
    2;

--Koja zemlja ima najveci broj zarazenih s obzirom na broj stanovnika?
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
    4 DESC;

--Zemlje s najvecim brojem umrlih po broju stanovnika
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
    2 DESC;

--Total Deaths po kontinentima
SELECT
    continent,
--location,
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
--location
    continent
--dan,
--population
ORDER BY
    2 DESC;

--Proba (ovako se dobiju ispravni brojevi po kontinentima???)
SELECT 
--continent,
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
    continent IS NULL
GROUP BY
    location
--continent
--dan,
--population
ORDER BY
    2 DESC;

--Kontinenti s najvecim Death Countom po broju stanovnika

SELECT
    continent,
--location,
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
--location
    continent
--dan,
--population
ORDER BY
    2 DESC;

--Globalni brojevi
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
    2;

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
    2;

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
    2;

--Ako sad uklonimo dan kao varijablu
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
    2;
    
--Sad ukljucujemo i podatke o vakcinaciji
SELECT
    *
FROM
    covid_vaccinations;

--Join dvije tabele: death i vaccinations
SELECT
    *
FROM
         covid_deaths dea
    JOIN covid_vaccinations vac ON ( dea.location = vac.location
                                     AND dea.dan = vac.dan );

--Ukupna vakcinisanost po populaciji

SELECT
    dea.continent,
    dea.location,
    dea.dan,
    dea.population,
    vac.new_vaccinations
FROM
         covid_deaths dea
    JOIN covid_vaccinations vac ON ( dea.location = vac.location
                                     AND dea.dan = vac.dan )
WHERE
    dea.continent IS NOT NULL
ORDER BY
    1,
    2,
    3;

--Dodajemo rolling sumiranje new vaccinations
SELECT
    dea.continent,
    dea.location,
    dea.dan,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations)
    OVER(PARTITION BY dea.location
         ORDER BY dea.location, dea.dan
    ) AS rolling_people_vaccinated
FROM
         covid_deaths dea
    JOIN covid_vaccinations vac ON ( dea.location = vac.location
                                     AND dea.dan = vac.dan )
WHERE
    dea.continent IS NOT NULL
ORDER BY
    2,
    3;

--Da bi sad taj novi podatak iskoristili za ono sto zelimo, moram to staviti u tmp tabelu

--Preko with clause

WITH popvsvac AS (
    SELECT
        dea.continent,
        dea.location,
        dea.dan,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations)
        OVER(PARTITION BY dea.location
             ORDER BY dea.location, dea.dan
        ) AS rolling_people_vaccinated
    FROM
             covid_deaths dea
        JOIN covid_vaccinations vac ON ( dea.location = vac.location
                                         AND dea.dan = vac.dan )
    WHERE
        dea.continent IS NOT NULL
)
SELECT
    p.*,
    ( p.rolling_people_vaccinated / p.population ) * 100 AS roll_pp_vac_per_pop
FROM
    popvsvac p;
--WHERE p.location = 'Israel';

--Preko temp tabele
--DROP TABLE percent_population_vaccinated;

CREATE TABLE percent_population_vaccinated (
    continent                  VARCHAR2(26),
    location                   VARCHAR2(200),
    dan                        DATE,
    population                 NUMBER(38),
    new_vaccinations           NUMBER(38),
    rolling_people_vaccinated  NUMBER(38)
);

INSERT INTO percent_population_vaccinated
    SELECT
        dea.continent,
        dea.location,
        dea.dan,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations)
        OVER(PARTITION BY dea.location
             ORDER BY dea.location, dea.dan
        ) AS rolling_people_vaccinated
    FROM
             covid_deaths dea
        JOIN covid_vaccinations vac ON ( dea.location = vac.location
                                         AND dea.dan = vac.dan );
                                       
--Kreiranje viewa radi koristenja u kasnijoj vizualizaciji

--DROP VIEW percent_population_vaccinated_v;


CREATE VIEW percent_population_vaccinated_v AS
    SELECT
        dea.continent,
        dea.location,
        dea.dan,
        dea.population,
        vac.new_vaccinations,
        SUM(vac.new_vaccinations)
        OVER(PARTITION BY dea.location
             ORDER BY dea.location, dea.dan
        ) AS rolling_people_vaccinated
    FROM
             covid_deaths dea
        JOIN covid_vaccinations vac ON dea.location = vac.location
                                       AND dea.dan = vac.dan
    WHERE
        dea.continent IS NOT NULL;
        
--Provjera
SELECT
    *
FROM
    percent_population_vaccinated_v;