--Data Analyst Portfolio Project | Data Cleaning in SQL | Project 3/4

--Import dataseta: Nashville Housing Data for Data Cleaning.xlsx
--Tabela: NASHVILLE_HOUSING


/*
Name           	Type          
---------------	------------- 
UNIQUEID       	NUMBER(38)    
PARCELID       	VARCHAR2(50)  
LANDUSE        	VARCHAR2(50)  
PROPERTYADDRESS	VARCHAR2(200) 
SALEDATE       	DATE          
SALEPRICE      	NUMBER(38)    
LEGALREFERENCE 	VARCHAR2(50)  
SOLDASVACANT   	VARCHAR2(26)  
OWNERNAME      	VARCHAR2(200) 
OWNERADDRESS   	VARCHAR2(200) 
ACREAGE        	NUMBER(38,2)  
TAXDISTRICT    	VARCHAR2(50)  
LANDVALUE      	NUMBER(38)    
BUILDINGVALUE  	NUMBER(38)    
TOTALVALUE     	NUMBER(38)    
YEARBUILT      	NUMBER(38)    
BEDROOMS       	NUMBER(38)    
FULLBATH       	NUMBER(38)    
HALFBATH       	NUMBER(38)
*/

--Provjera podataka
SELECT
    *
FROM
    nashville_housing;

--Da provjerimo broj redova
SELECT
    COUNT(*)
FROM
    nashville_housing;
--56477

--Kod Alexa je moralo da se pretvara datum iz varchar u date format, kod nas ne treba
--eventualno, mozemo u Tools --> Preferences --> NLS settings promijeniti:
/*
Stari settings:
Date format: DD-MON-RR
Timestamp format: DD-MON-RR HH.MI.SSXFF AM
Timestamp TZ format: DD-MON-RR HH.MI.SSXFF AM TZR

Novi settings:
Date format: DD.MM.YYYY
Timestamp format: DD.MM.YYYY HH24:MI:SS
*/

--Provjera da vidimo kako se promijenio format datuma
SELECT
    *
FROM
    nashville_housing;

--Da ne bih radio nad originalnim podacima kreiracu kopiju tabele
CREATE TABLE nhc
    AS
        ( SELECT
            *
        FROM
            nashville_housing
        );

------------------------------------
--Populate Property Address data
------------------------------------

--Moze se uociti da postoje zapisi kod kojih je podatak o propertyaddress NULL
SELECT
    *
FROM
    nhc
WHERE
    propertyaddress IS NULL;
--imamo 29 takvih slucajeva

--Ako poredamo po ID-u parcele:
SELECT
    *
FROM
    nhc
ORDER BY
    parcelid;

--mozemo vidjeti da za svaku null vrijednost propertyaddress postoji
--nenulta vrijednost na istoj parceli
--npr. 025 07 0 031.00
--pa to mozemo iskoristiti da azuriramo podatke u o propertyaddress za nulte slucajeve

--Npr.
SELECT
    *
FROM
    nhc
WHERE
    parcelid = '025 07 0 031.00'
ORDER BY
    parcelid;

--npr.
SELECT
    *
FROM
    nhc
WHERE
    parcelid = '025 07 0 031.00';

--vidimo da imaju razlicit uniqueid, a da im je parcelid isti
--Kako bi ih onda uvezali preko self joina?
SELECT
    *
FROM
         nhc a
    JOIN nhc b ON ( a.parcelid = b.parcelid
                    AND a.uniqueid <> b.uniqueid )
WHERE
    a.propertyaddress IS NULL;
--vidimo da se neki imaju i tri i vise id-eva na istoj parceli (jer sad imamo 35 redova, a ne 29)
--npr. parcelid = 108 07 0A 026.00

SELECT
    *
FROM
    nhc
WHERE
    parcelid = '108 07 0A 026.00';
--WHERE uniqueid = 14753;

--Za one parcele koji imaju zapis sa nepopunjenim poljem propertyaddress
--pronadji mi prvi zapis sa istim parcelid-em, a da mu je propertyaddress popunjeno

SELECT
    uniqueid,
    parcelid,
    propertyaddress,
    ROW_NUMBER()
    OVER(PARTITION BY parcelid
         ORDER BY propertyaddress
    ) AS red
FROM
    nhc
WHERE
    propertyaddress IS NOT NULL
    AND parcelid = '108 07 0A 026.00';

--..treba mi samo jedan ovakav
SELECT
    *
FROM
    (
        SELECT
            uniqueid,
            parcelid,
            propertyaddress,
            ROW_NUMBER()
            OVER(PARTITION BY parcelid
                 ORDER BY propertyaddress
            ) AS red
        FROM
            nhc
        WHERE
            propertyaddress IS NOT NULL
            AND parcelid = '108 07 0A 026.00'
    ) a
WHERE
    a.red = 1;

--..sad join ove tabele sa podacima

SELECT
    *
FROM
         nhc d
    JOIN (
        SELECT
            *
        FROM
            (
                SELECT
                    uniqueid,
                    parcelid,
                    propertyaddress,
                    ROW_NUMBER()
                    OVER(PARTITION BY parcelid
                         ORDER BY propertyaddress
                    ) AS red
                FROM
                    nhc
                WHERE
                    propertyaddress IS NOT NULL
--AND parcelid = '108 07 0A 026.00'
            ) a
        WHERE
            a.red = 1
    ) b ON d.parcelid = b.parcelid
WHERE
    d.propertyaddress IS NULL;
--sad vidimo da imamo tacno 39 redova i to onih koje treba updateati

--nama za update treba samo polje propertyaddress iz tabele b
SELECT
    b.propertyaddress
FROM
         nhc d
    JOIN (
        SELECT
            *
        FROM
            (
                SELECT
                    uniqueid,
                    parcelid,
                    propertyaddress,
                    ROW_NUMBER()
                    OVER(PARTITION BY parcelid
                         ORDER BY propertyaddress
                    ) AS red
                FROM
                    nhc
                WHERE
                    propertyaddress IS NOT NULL
--AND parcelid = '108 07 0A 026.00'
            ) a
        WHERE
            a.red = 1
    ) b ON d.parcelid = b.parcelid
WHERE
    d.propertyaddress IS NULL;

--Sad formiramo update naredbu
UPDATE nhc nhc
SET
    nhc.propertyaddress = (
        SELECT
            b.propertyaddress
        FROM
                 nhc d
            JOIN (
                SELECT
                    *
                FROM
                    (
                        SELECT
                            uniqueid,
                            parcelid,
                            propertyaddress,
                            ROW_NUMBER()
                            OVER(PARTITION BY parcelid
                                 ORDER BY propertyaddress
                            ) AS red
                        FROM
                            nhc
                        WHERE
                            propertyaddress IS NOT NULL
--AND parcelid = '108 07 0A 026.00'
                    ) a
                WHERE
                    a.red = 1
            ) b ON d.parcelid = b.parcelid
        WHERE
            d.propertyaddress IS NULL
            AND nhc.parcelid = d.parcelid--ako se izostavi jos ovaj dodatni uslov onda Oracle javlja ORA-01427: single-row subquery returns more than one row
    )
WHERE
    nhc.propertyaddress IS NULL;
--29 rows updated.

--...inace ovo se moze i jednostavnije izvesti
--npr. na ovom linku:
--https://stackoverflow.com/questions/44872802/oracle-self-join-to-update-a-column

--Primjer updatea preko self joina sa gornjeg linka
/*
npr za tabelu:
Sample Data
request_num|Customer id
12         | ANBZ
12         |
12         | 
13         | 
13         | xyz

--i sad treba updateati customer id koji su NULL da budu popunjeni
--vrijednostima onih customer id koji nisu NULL a imaju isti request_num

UPDATE CUST_VW C
    SET CUST_ID = (SELECT MAX(C2.CUST_ID)
                   FROM CUST_VW C2
                   WHERE C.REQUEST_NUM = C2.REQUEST_NUM AND
                          C2.CUST_ID IS NOT NULL
                  )
    WHERE CUST_ID IS NULL ;
*/
--Kad bi se to primijenilo u nasem slucaju:
/*
UPDATE nhc1 a
SET a.propertyaddress = (
SELECT MAX(b.propertyaddress)
FROM nhc1 b
WHERE a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid)
WHERE a.propertyaddress IS NULL;
*/

--Provjera
SELECT
    *
FROM
    nhc
WHERE
    parcelid = '108 07 0A 026.00';


---------------------------------------------------------------------
--Breaking out Address into individual columns (Address, City, State)
---------------------------------------------------------------------

--Pogledajmo kolonu propertyaddress
SELECT
    propertyaddress
FROM
    nhc;
--sastoji se od broja, adrese pa zarez pa mjesto

--Oracle SUBSTR()
--https://www.techonthenet.com/oracle/functions/substr.php
--Oracle INSTR()
--https://www.techonthenet.com/oracle/functions/instr.php

--Zelimo da razdvojimo u posebne kolone ove podatke

--F-je SUBSTR() i INSTR()

--Zelimo da nadjemo poziciju prvog pojavljivanja zareza u propertyaddress
SELECT
    instr(propertyaddress, ',')
FROM
    nhc;

--Sad zelimo da izdvojimo string od prve pozicije do pozicije prvog zareza u propertyaddress
SELECT
    substr(propertyaddress, 1, instr(propertyaddress, ',') - 1)
FROM
    nhc;

--...a onda sve od zareza do kraja stringa
SELECT
    substr(propertyaddress, instr(propertyaddress, ',') + 1, length(propertyaddress))
FROM
    nhc;

--Sad cemo od ovoga napraviti dvije nove kolone
--..koje prethodno moramo kreirati

ALTER TABLE nhc ADD propertysplitaddress VARCHAR2(200);

ALTER TABLE nhc ADD propertysplitcity VARCHAR2(200);

--Sad cemo napuniti ove nove kolone ovim gore vrijednostima
UPDATE nhc
SET
    propertysplitaddress = substr(propertyaddress, 1, instr(propertyaddress, ',') - 1);
--56,477 rows updated.

UPDATE nhc
SET
    propertysplitcity = substr(propertyaddress, instr(propertyaddress, ',') + 1, length(propertyaddress));
--56,477 rows updated.

--Provjera
SELECT
    *
FROM
    nhc;
--vidimo da su to krajnje dvije kolone i da u uredno popunjene

--------------------
--Sad posmatramo kolonu OWNERADDRESS

SELECT
    owneraddress
FROM
    nhc;
--sad imamo adresu, mjesto i saveznu drzavu

--Tu sad Alex koristi PARSENAME f-ju koja postoji u MS SQL-u, ali u Oracleu ne postoji
--..pa mozemo na stari nacin

SELECT
    owneraddress,
    substr(owneraddress, 1, instr(owneraddress, ',') - 1) AS ownersplitaddress
FROM
    nhc;

SELECT
    owneraddress,
    substr(owneraddress, instr(owneraddress, ',') + 1, instr(owneraddress, ',', 1, 2) -(instr(owneraddress, ',') + 1)) AS ownersplitcity
FROM
    nhc;--substring od mjesta nakon prvog zareza pa onoliko mjesta koliko iznosi razlika izmedju pozicije dvaju zareza

SELECT
    owneraddress,
    substr(owneraddress, instr(owneraddress, ',', 1, 2) + 1, length(owneraddress)) AS ownersplitstate
FROM
    nhc;--substring od mjesta nakon drugog zareza do kraja

--U Oracleu nema funkcije PARSENAME, ali 
--..postoji slicna funkcija koja koristi regularne izraze:
--https://stackoverflow.com/questions/33261947/sql-server-parsename-equivalent
--regexp substr

--https://www.techonthenet.com/oracle/functions/regexp_substr.php

/*
--npr.
SELECT REGEXP_SUBSTR ('TechOnTheNet is a great resource', '(\S*)(\s)')
FROM dual;

Result: 'TechOnTheNet '
This example will return 'TechOnTheNet ' because it will extract all non-whitespace characters as specified by (\S*) and
 then the first whitespace character as specified by (\s). 
The result will include both the first word as well as the space after the word.
*/
/*
--npr.
SELECT REGEXP_SUBSTR('Ja,citam','[^,]+',1,1) AS prva_rijec
FROM dual;

-- [^,]  --znaci: trazi znakove razlicite od ','
-- +   -- znaci jedno ili vise ponavljanja

*/
--Ovo je rjesenje do kojeg su dosli Risto Maric i Marko Kalember ETF BL
SELECT
    owneraddress,
    regexp_substr(owneraddress, '[^,]+', 1, 1)           AS ownersplitaddress,
    regexp_substr(owneraddress, '[^,]+', 1, 2)           AS ownersplitcity,
    regexp_substr(owneraddress, '[^,]+', 1, 3)           AS ownersplitstate
FROM
    nhc;

--Sad cemo opet alterovati tabelu, kreirati nove tri kolone i updateati ih ovim podacima
ALTER TABLE nhc ADD ownersplitaddress VARCHAR2(200);

ALTER TABLE nhc ADD ownersplitcity VARCHAR2(200);

ALTER TABLE nhc ADD ownersplitstate VARCHAR2(50);

UPDATE nhc
SET
    ownersplitaddress = regexp_substr(owneraddress, '[^,]+', 1, 1);
--56,477 rows updated.

UPDATE nhc
SET
    ownersplitcity = regexp_substr(owneraddress, '[^,]+', 1, 2);
--56,477 rows updated.

UPDATE nhc
SET
    ownersplitstate = regexp_substr(owneraddress, '[^,]+', 1, 3);
--56,477 rows updated.

--Provjera
SELECT
    *
FROM
    nhc;
--sve je ok isparsirano i updateano

-------------------------------------------------------
--Change Y and N to Yes i No in 'Sold as Vacant' fields
-------------------------------------------------------

SELECT
    soldasvacant
FROM
    nhc;

SELECT DISTINCT
    soldasvacant
FROM
    nhc;

--Da prebrojimo koliko kojih ima
SELECT
    soldasvacant,
    COUNT(*)
FROM
    nhc
GROUP BY
    soldasvacant
ORDER BY
    2 DESC;

--Hocemo da promijenimo sve N u No i sve Y u Yes
SELECT
    soldasvacant,
    (
        CASE
            WHEN soldasvacant = 'Y'  THEN
                'Yes'
            WHEN soldasvacant = 'N'  THEN
                'No'
            ELSE
                soldasvacant
        END
    ) AS soldchng
FROM
    nhc;

--Da probamo da li ce proci update kao kod Alexa
UPDATE nhc
SET
    soldasvacant =
        CASE
            WHEN soldasvacant = 'Y'  THEN
                'Yes'
            WHEN soldasvacant = 'N'  THEN
                'No'
            ELSE
                soldasvacant
        END;
--56,477 rows updated.

--Provjera
SELECT DISTINCT
    soldasvacant
FROM
    nhc;
--to je to

-------------------
--Remove Duplicates
-------------------

SELECT
    n.*,
    ROW_NUMBER()
    OVER(PARTITION BY n.parcelid, n.propertyaddress, n.saleprice, n.saledate, n.legalreference
         ORDER BY n.uniqueid
    ) row_num
FROM
    nhc n
ORDER BY
    n.parcelid;
   
--npr. parcelid = 081 02 0 144.00

SELECT
    *
FROM
    nhc
WHERE
    parcelid = '081 02 0 144.00';

--Napravimo ovo kao CTE (Common Table Expressions)
WITH rownumcte AS (
    SELECT
        n.*,
        ROW_NUMBER()
        OVER(PARTITION BY n.parcelid, n.propertyaddress, n.saleprice, n.saledate, n.legalreference
             ORDER BY n.uniqueid
        ) row_num
    FROM
        nhc n
)
SELECT
    *
FROM
    rownumcte;

WITH rownumcte AS (
    SELECT
        n.*,
        ROW_NUMBER()
        OVER(PARTITION BY n.parcelid, n.propertyaddress, n.saleprice, n.saledate, n.legalreference
             ORDER BY n.uniqueid
        ) row_num
    FROM
        nhc n
)
SELECT
    *
FROM
    rownumcte
WHERE
    row_num > 1
ORDER BY
    propertyaddress;
--svi ovi su duplikati, ima ih 104

--Sad ih treba izbrisati

/*
--Ovo moze proci u MS SQL-u, ali ne prolazi u Oracle SQL-u
WITH rownumcte AS (
SELECT
    n.*,
    ROW_NUMBER()
    OVER(PARTITION BY n.parcelid, n.propertyaddress, n.saleprice, n.saledate, n.legalreference
         ORDER BY n.uniqueid
    ) row_num
FROM
    nhc n

)
DELETE
FROM rownumcte
WHERE row_num > 1;
*/

DELETE FROM nhc
WHERE
    uniqueid IN (
        WITH rownumcte AS (
            SELECT
                n.*, ROW_NUMBER()
                     OVER(PARTITION BY n.parcelid, n.propertyaddress, n.saleprice, n.saledate, n.legalreference
                          ORDER BY n.uniqueid
                     ) row_num
            FROM
                nhc n
        )
        SELECT
            uniqueid
        FROM
            rownumcte
        WHERE
            row_num > 1
    );
	
--104 rows deleted.

--Provjera da li sad ima duplih
WITH rownumcte AS (
    SELECT
        n.*,
        ROW_NUMBER()
        OVER(PARTITION BY n.parcelid, n.propertyaddress, n.saleprice, n.saledate, n.legalreference
             ORDER BY n.uniqueid
        ) row_num
    FROM
        nhc n
)
SELECT
    *
FROM
    rownumcte
WHERE
    row_num > 1
ORDER BY
    propertyaddress;
--nema

-----------------------
--Delete unused columns
-----------------------

--Rijesicemo se kolona koje nam ne trebaju
ALTER TABLE nhc DROP COLUMN owneraddress;
--Table NHC altered.

ALTER TABLE nhc DROP COLUMN taxdistrict;
--Table NHC altered.

ALTER TABLE nhc DROP COLUMN propertyaddress;
--Table NHC altered.

ALTER TABLE nhc DROP COLUMN saledate;
--Table NHC altered.

--Provjera
SELECT
    *
FROM
    nhc;