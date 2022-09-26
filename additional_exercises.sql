--DA Project 1: Eksploratorna analiza podataka u SQL-u - Dodatni rad
--Rad: UT.26.10.2021.

--CovidDeaths

SELECT
    *
FROM
    covid_deaths
ORDER BY
    3,
    4;

--Najsvjeziji brojevi
SELECT
    *
FROM
    covid_deaths
WHERE
    dan = (
        SELECT
            MAX(dan)
        FROM
            covid_deaths
    )--posljednji dan za koji imamo podatke u tabeli
ORDER BY
    3,
    4;

--Izbacujemo slucajeve kad su lokacije u stvari kontinenti
SELECT
    *
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
ORDER BY
    3,
    4;

--Ako zelimo da posmatramo zemlje Zapadnog Balkana + Slovenija i Hrvatska:
SELECT
    *
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
    AND location IN ( 'Slovenia', 'Croatia', 'Bosnia and Herzegovina', 'Serbia', 'Montenegro',
                      'Kosovo', 'North Macedonia', 'Albania' )--WBC+ drzave
ORDER BY
    3,
    4;

--Total Cases---

--Potrebne kolone
SELECT
    dan,
    location,
    population,
    total_cases
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
    ;

--(formatiranje brojeva da bi bilo jasnije, hiljade razdvojene zarezima)
--Link: https://stackoverflow.com/questions/54927174/thousand-separator-oracle
SELECT
    dan,
    location,
    to_char(population, 'FM999G999G999G999')        AS population,
    to_char(total_cases, 'FM999G999G999G999')       AS total_cases
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
    ;

--Zemlje s najvecim brojem slucajeva
--uvodimo u igru analiticku f-ju ROW_NUMBER() da bismo dobili redoslijed
SELECT
    dan,
    location,
--population,
    to_char(total_cases, 'FM999G999G999G999')       AS total_cases,
    ROW_NUMBER()
    OVER(
        ORDER BY total_cases DESC NULLS LAST
    )                                              AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
    ;

--..u WBC+ zoni:

SELECT
    dan,
    location,
--population,
    to_char(total_cases, 'FM999G999G999G999')       AS total_cases,
    ROW_NUMBER()
    OVER(
        ORDER BY total_cases DESC NULLS LAST
    )                                              AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
    AND location IN ( 'Slovenia', 'Croatia', 'Bosnia and Herzegovina', 'Serbia', 'Montenegro',
                      'Kosovo', 'North Macedonia', 'Albania' )--WBC+ drzave
                      ;

--Broj slucajeva u odnosu na broj stanovnika
SELECT
    dan,
    location,
    population,
    total_cases,
    round((total_cases / population) * 100, 3)         AS tot_cas_per_pop,
    ROW_NUMBER()
    OVER(
        ORDER BY total_cases / population DESC NULLS LAST
    )                                                 AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
    ;

---..za zemlje preko milion stanovnika
SELECT
    dan,
    location,
    population,
    total_cases,
    round((total_cases / population) * 100, 3)         AS tot_cas_per_pop,
    ROW_NUMBER()
    OVER(
        ORDER BY total_cases / population DESC NULLS LAST
    )                                                 AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
    AND population >= 1000000;

--za WBC+ zemlje
SELECT
    dan,
    location,
    population,
    total_cases,
    round((total_cases / population) * 100, 3)         AS tot_cas_per_pop,
    ROW_NUMBER()
    OVER(
        ORDER BY total_cases / population DESC NULLS LAST
    )                                                 AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
    AND location IN ( 'Slovenia', 'Croatia', 'Bosnia and Herzegovina', 'Serbia', 'Montenegro',
                      'Kosovo', 'North Macedonia', 'Albania' )--WBC+ drzave
--AND population >= 1000000
                      ;

--Total Deaths
SELECT
    dan,
    location,
--population,
    to_char(total_deaths, 'FM999G999G999G999')       AS total_deaths,
    ROW_NUMBER()
    OVER(
        ORDER BY total_deaths DESC NULLS LAST
    )                                               AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
--AND population >= 1000000
    ;

--najveci broj umrlih u WBC+ drzavama
SELECT
    dan,
    location,
--population,
    to_char(total_deaths, 'FM999G999G999G999')       AS total_deaths,
    ROW_NUMBER()
    OVER(
        ORDER BY total_deaths DESC NULLS LAST
    )                                               AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
    AND location IN ( 'Slovenia', 'Croatia', 'Bosnia and Herzegovina', 'Serbia', 'Montenegro',
                      'Kosovo', 'North Macedonia', 'Albania' )--WBC+ drzave
--AND population >= 1000000
                      ;

--Broj umrlih u odnosu na broj stanovnika
SELECT
    dan,
    location,
    to_char(population, 'FM999G999G999G999')            AS population,
    to_char(total_deaths, 'FM999G999G999G999')          AS total_deaths,
    round((total_deaths / population) * 100, 3)           AS tot_death_per_pop,
    ROW_NUMBER()
    OVER(
        ORDER BY total_deaths / population DESC NULLS LAST
    )                                                  AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
--AND population >= 1000000
    ;

--..za WBC+ zemlje
SELECT
    dan,
    location,
    to_char(population, 'FM999G999G999G999')            AS population,
    to_char(total_deaths, 'FM999G999G999G999')          AS total_deaths,
    round((total_deaths / population) * 100, 3)           AS tot_death_per_pop,
    ROW_NUMBER()
    OVER(
        ORDER BY total_deaths / population DESC NULLS LAST
    )                                                  AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
    AND location IN ( 'Slovenia', 'Croatia', 'Bosnia and Herzegovina', 'Serbia', 'Montenegro',
                      'Kosovo', 'North Macedonia', 'Albania' )--WBC+ drzave
--AND population >= 1000000
                      ;

--Smrtnost
--CFR = total_deaths/total_cases
SELECT
    dan,
    location,
--TO_CHAR(population,'FM999G999G999G999') AS population,
    to_char(total_cases, 'FM999G999G999G999')            AS total_cases,
    to_char(total_deaths, 'FM999G999G999G999')           AS total_deaths,
    round((total_deaths / total_cases) * 100, 3)           AS cfr,
    ROW_NUMBER()
    OVER(
        ORDER BY total_deaths / total_cases DESC NULLS LAST
    )                                                   AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
--AND population >= 1000000
    ;

--..ali samo zemlje preko 1000 slucajeva
SELECT
    dan,
    location,
--TO_CHAR(population,'FM999G999G999G999') AS population,
    to_char(total_cases, 'FM999G999G999G999')            AS total_cases,
    to_char(total_deaths, 'FM999G999G999G999')           AS total_deaths,
    round((total_deaths / total_cases) * 100, 3)           AS cfr,
    ROW_NUMBER()
    OVER(
        ORDER BY total_deaths / total_cases DESC NULLS LAST
    )                                                   AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
--AND population >= 1000000
    AND total_cases >= 1000;

--smrtnost za WBC+ zemlje
SELECT
    dan,
    location,
--TO_CHAR(population,'FM999G999G999G999') AS population,
    to_char(total_cases, 'FM999G999G999G999')            AS total_cases,
    to_char(total_deaths, 'FM999G999G999G999')           AS total_deaths,
    round((total_deaths / total_cases) * 100, 3)           AS cfr,
    ROW_NUMBER()
    OVER(
        ORDER BY total_deaths / total_cases DESC NULLS LAST
    )                                                   AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
    AND location IN ( 'Slovenia', 'Croatia', 'Bosnia and Herzegovina', 'Serbia', 'Montenegro',
                      'Kosovo', 'North Macedonia', 'Albania' )--WBC+ drzave
--AND population >= 1000000
--AND total_cases >= 1000
                      ;

--Porast prosjecnog broja slucajeva za posljednjih 7 dana
--koristenje WITH iskaza za kreiranje pomocne tabele i koristenje LEAD analiticke funkcije

WITH tmp AS (
    SELECT
        dan,
        location,
        new_cases_smoothed,
        LEAD(new_cases_smoothed, 7)
        OVER(PARTITION BY location
             ORDER BY
                 dan DESC
        ) AS prev_7day_ncs
--ROW_NUMBER() OVER(PARTITION BY location ORDER BY dan DESC rows BETWEEN 7 PRECEDING AND CURRENT ROW) AS RED
    FROM
        covid_deaths
    WHERE
        new_cases_smoothed IS NOT NULL
        AND new_cases_smoothed <> 0
        AND continent IS NOT NULL
--AND location = 'Albania'--'Bosnia and Herzegovina'
--AND dan >= SYSDATE - 15

)
SELECT
    dan,
    location,
    new_cases_smoothed,
    prev_7day_ncs,
    round(((new_cases_smoothed - prev_7day_ncs) / prev_7day_ncs) * 100, 3)          AS pct_growth,
    ROW_NUMBER()
    OVER(
        ORDER BY((new_cases_smoothed - prev_7day_ncs) / prev_7day_ncs) DESC
    )                                                                               AS red
FROM
    tmp
WHERE
    dan = '20-OCT-21'
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
    ;

--Globalni brojevi
--preko kumulativne sume novih slucajeva
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
    
--... i kumulativne sume novih smrti 
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

--CFR kao kolicnik kumulativnih suma   
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
    to_char(SUM(new_cases), 'FM999G999G999G999')                     AS total_cases,
    to_char(SUM(new_deaths), 'FM999G999G999G999')                    AS total_deaths,
    round((SUM(new_deaths) / SUM(new_cases)) * 100, 3)             AS death_pct
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
                                     
--npr. za BiH
SELECT
    *
FROM
         covid_deaths dea
    JOIN covid_vaccinations vac ON ( dea.location = vac.location
                                     AND dea.dan = vac.dan )
WHERE
        dea.location = 'Bosnia and Herzegovina'
    AND dea.dan = (
        SELECT
            MAX(dan)
        FROM
            covid_deaths
    );

--Da li parametri iz ove druge tabele uticu na smrtnost koju smo dobili iz prve tabele?

--Smrtnost (raniji upit)

--CFR = total_deaths/total_cases
SELECT
    dan,
    location,
--TO_CHAR(population,'FM999G999G999G999') AS population,
    to_char(total_cases, 'FM999G999G999G999')            AS total_cases,
    to_char(total_deaths, 'FM999G999G999G999')           AS total_deaths,
    round((total_deaths / total_cases) * 100, 3)           AS cfr,
    ROW_NUMBER()
    OVER(
        ORDER BY total_deaths / total_cases DESC NULLS LAST
    )                                                   AS red
FROM
    covid_deaths
WHERE
        dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
    AND population >= 1000000;

--Sad cemo ovo uvezati s podacima iz druge tabele da vidimo kako i sta utice na smrtnost
SELECT
    dea.dan,
    dea.location,
    vac.population_density,
    vac.median_age,
    vac.gdp_per_capita,
    vac.cardiovasc_death_rate,
    vac.diabetes_prevalence,
--TO_CHAR(population,'FM999G999G999G999') AS population,
    to_char(dea.total_cases, 'FM999G999G999G999')                    AS total_cases,
    to_char(dea.total_deaths, 'FM999G999G999G999')                   AS total_deaths,
    round((dea.total_deaths / dea.total_cases) * 100, 3)               AS cfr,
    ROW_NUMBER()
    OVER(
        ORDER BY dea.total_deaths / dea.total_cases DESC NULLS LAST
    )                                                               AS red
FROM
         covid_deaths dea
    JOIN covid_vaccinations vac ON ( dea.location = vac.location
                                     AND dea.dan = vac.dan )
WHERE
        dea.dan = (
            SELECT
                MAX(dan)
            FROM
                covid_deaths
        )--posljednji dan za koji imamo podatke u tabeli
    AND dea.continent IS NOT NULL --posto je u tim slucajevima continent IS NULL, dakle uzimamo samo kad su lokacije drzave
--AND location IN ('Slovenia','Croatia','Bosnia and Herzegovina','Serbia','Montenegro','Kosovo','North Macedonia','Albania')--WBC+ drzave
    AND dea.population >= 1000000;

--Ko najvise testira?

--Da vidimo npr. za BiH broj testova
SELECT
    MAX(dan)                          AS max_dan,
    location,
    MAX(total_tests_per_thousand)     AS max_tests
FROM
    covid_vaccinations
WHERE
        location = 'Bosnia and Herzegovina'
--AND new_vaccinations IS NOT NULL
--AND dan >= SYSDATE - 20
    AND substr(to_char(dan, 'DD-MON-YY'), 4, 6) = 'OCT-21'
GROUP BY 
--dan,
    location;
--ORDER BY dan DESC;

--Da vidimo poretke po broju testova na hiljadu stanovnika u oktobru

WITH pom AS (
    SELECT
        MAX(dan)                          AS max_dan,
        location,
        MAX(total_tests_per_thousand)     AS max_tests_per_tsnd
    FROM
        covid_vaccinations
--WHERE location = 'Bosnia and Herzegovina'
--AND new_vaccinations IS NOT NULL
--AND dan >= SYSDATE - 20
    WHERE
        substr(to_char(dan, 'DD-MON-YY'), 4, 6) = 'OCT-21'
    GROUP BY 
--dan,
        location
)
SELECT
    *
FROM
    pom
WHERE
    max_tests_per_tsnd IS NOT NULL
ORDER BY
    max_tests_per_tsnd DESC;

--Na isti nacin mozemo vidjeti i udio pozitivnih testova
WITH pom AS (
    SELECT
        MAX(dan)               AS max_dan,
        location,
        MAX(positive_rate)     AS max_positive_rate
    FROM
        covid_vaccinations
--WHERE location = 'Bosnia and Herzegovina'
--AND new_vaccinations IS NOT NULL
--AND dan >= SYSDATE - 20
    WHERE
        substr(to_char(dan, 'DD-MON-YY'), 4, 6) = 'OCT-21'
    GROUP BY 
--dan,
        location
)
SELECT
    *
FROM
    pom
WHERE
    max_positive_rate IS NOT NULL
ORDER BY
    max_positive_rate DESC;

--Redoslijed po ukupnom broju vakcinacija
WITH pom AS (
    SELECT
        MAX(dan)                    AS max_dan,
        location,
        MAX(total_vaccinations)     AS max_total_vaccinations
    FROM
        covid_vaccinations
--WHERE location = 'Bosnia and Herzegovina'
--AND new_vaccinations IS NOT NULL
--AND dan >= SYSDATE - 20
    WHERE
            substr(to_char(dan, 'DD-MON-YY'), 4, 6) = 'OCT-21'
        AND continent IS NOT NULL
    GROUP BY 
--dan,
        location
)
SELECT
    max_dan,
    location,
    to_char(max_total_vaccinations, 'FM999G999G999G999') AS max_total_vac
FROM
    pom
WHERE
    max_total_vaccinations IS NOT NULL
ORDER BY
    max_total_vaccinations DESC;

--Vakcinacije po broju stanovnika
WITH pom AS (
    SELECT
        MAX(dea.dan)                      AS max_dan,
        dea.location,
        dea.population,
        MAX(vac.total_vaccinations)       AS max_total_vaccinations
    FROM
             covid_deaths dea
        JOIN covid_vaccinations vac ON ( dea.location = vac.location
                                         AND dea.dan = vac.dan )
--WHERE location = 'Bosnia and Herzegovina'
--AND new_vaccinations IS NOT NULL
--AND dan >= SYSDATE - 20
    WHERE
            substr(to_char(dea.dan, 'DD-MON-YY'), 4, 6) = 'OCT-21'
        AND dea.continent IS NOT NULL
    GROUP BY
        dea.location,
        dea.population
)
SELECT
    max_dan,
    location,
    to_char(population, 'FM999G999G999G999')                      AS popul,
    to_char(max_total_vaccinations, 'FM999G999G999G999')          AS max_total_vac,
    round((max_total_vaccinations / population) * 100, 3)         AS pct_vac
FROM
    pom
WHERE
    max_total_vaccinations IS NOT NULL
ORDER BY
    5 DESC;

--.. da li se to slaze sa nacinom na koji je Alex dobio ovaj podatak?
--on je radio preko kumulativnih suma novih vakcinacija

--idemo sad kako je on radio:

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
--AND dea.location = 'Kosovo'
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