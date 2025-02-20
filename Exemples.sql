/*Exercitiul 12:
Urmatoare cerere contine urmatorul subpunct:
a)subcereri sincronizate în care intervin cel puțin 3 tabele;
-grupari de date;
Cerinta: 
Afisati numele, pozitia si salariul mediu al galeriei din care fac parte supervizorii ce apartin unei galerii ce are atribuite mai putine orare decat supervizorul are oameni in subordine. Rezultatele vor fi grupate dupa numele supervizorului si id-ul galeriei.
Query:*/
SELECT a.nume, s.pozitie, AVG(s.salariu_supervizor) AS salariu_mediu
FROM Supervizor s
JOIN Angajat a ON s.angajat_id = a.angajat_id
WHERE a.galerie_id IN (
    SELECT g.galerie_id
    FROM Galerie g
    WHERE (
        SELECT COUNT(o.orar_id)
        FROM Orar o
        WHERE o.galerie_id = g.galerie_id
    ) < (
        SELECT COUNT(ss.angajat_id_supervizat)
        FROM Supervizat_Supervizor ss
        WHERE ss.angajat_id_supervizor = s.angajat_id
    )
)
GROUP BY a.nume, a.galerie_id, s.pozitie;

/*Urmatoare cerere contine urmatorul subpunct:
d) ordonări și utilizarea funcțiilor NVL și DECODE (în cadrul aceleiași cereri)
e) utilizarea a cel puțin 2 funcții pe șiruri de caractere, 2 funcții pe date calendaristice, a cel puțin unei expresii CASE
f) utilizarea a cel puțin 1 bloc de cerere (clauza WITH)
Cerinta:
	Afișați informații despre evenimente și sponsori, inclusiv numele evenimentului, numele sponsorului, telefonul sponsorului, adresa sediului sponsorului (fără spații la început și sfârșit), anul de început al evenimentului și numărul de zile până la sfârșitul anului 2024 de la începutul datei evenimentului. În plus, trebuie să fie afișat și un status al anului care indică dacă anul evenimentului este curent (2024) sau anterior. În cazul în care telefonul sponsorului nu este disponibil, să se afișeze "N/A". Rezultatele trebuie ordonate descrescător după nr de zile pana la sfarsitul anului și numele evenimentului.
Query:*/
WITH EventSponsorInfo AS (
    SELECT
        e.event_id,
        e.nume AS nume_eveniment,
        s.nume_sponsor,
        NVL(s.telefon, 'N/A') AS telefon,
        TRIM(BOTH ' ' FROM s.adresa_sediu) AS adresa_sediu,
        EXTRACT(YEAR FROM e.data_inceput) AS an_inceput_eveniment,
        e.data_inceput
    FROM
        Eveniment e
    JOIN Eveniment_Sponsor es ON e.event_id = es.event_id
    JOIN Sponsor s ON es.nume_sponsor = s.nume_sponsor
)
SELECT
    event_id,
    nume_eveniment,
    nume_sponsor,
    telefon,
    adresa_sediu,
    an_inceput_eveniment,
    DECODE(an_inceput_eveniment, 2024, 'An curent', 'An anterior') AS status_an,
    TO_CHAR(TO_DATE('2024-12-31', 'YYYY-MM-DD') - data_inceput, '999') || ' zile' AS zile_pana_la_sfarsitul_anului
FROM
    EventSponsorInfo
ORDER BY
    zile_pana_la_sfarsitul_anului DESC,
    nume_eveniment;

/*Urmatoare cerere contine urmatorul subpunct:
b) subcereri nesincronizate în clauza FROM
c) grupări de date, funcții grup, filtrare la nivel de grupuri cu subcereri nesincronizate (în clauza de HAVING) în care intervin cel puțin 3 tabele (in cadrul aceleiași cereri)

Cerinta:
	Afisati informatiile despre galeriile care au mai puține orare decat numarul total de angajati din acele galerii. Includeti numele galeriei, numărul de orare și numărul total de angajati. Utilizati subcereri nesincronizate în clauza FROM pentru a obține numărul de angajați din fiecare galerie și filtrati la nivel de grupuri cu subcereri nesincronizate în clauza HAVING.
Query:*/
SELECT
    g.nume AS nume_galerie,
    COUNT(o.orar_id) AS numar_orare,
    (SELECT COUNT(*) FROM Angajat a WHERE a.galerie_id = g.galerie_id) AS numar_angajati
FROM
    Galerie g
LEFT JOIN Orar o ON g.galerie_id = o.galerie_id
GROUP BY
    g.nume,
    g.galerie_id
HAVING
    COUNT(o.orar_id) < (
        SELECT COUNT(a.galerie_id)
        FROM Angajat a
        WHERE a.galerie_id = g.galerie_id
    );

/*Urmatoare cerere contine urmatorul subpunct:
b) subcereri nesincronizate în clauza FROM
c) grupări de date, funcții grup, filtrare la nivel de grupuri cu subcereri nesincronizate (în clauza de HAVING) în care intervin cel puțin 3 tabele (in cadrul aceleiași cereri)
Cerinta:
Afișați media salariilor ghizilor care au mai mult de 4 ani vechime și lucrează în galerii care au cel puțin 10 exponate permanente. Includeți numele galeriei și media salariilor ghizilor. Utilizați subcereri nesincronizate în clauza FROM pentru a obține numărul de exponate permanente din fiecare galerie și filtrați la nivel de grupuri cu subcereri nesincronizate în clauza HAVING pentru a selecta ghizii cu mai mult de 5 ani vechime și galeriile cu cel puțin 10 exponate permanente.
Query:*/
SELECT
    g.nume AS nume_galerie,
    AVG(gh.salariu_ghid) AS media_salariilor_ghizilor
FROM
    Galerie g
INNER JOIN Angajat a ON g.galerie_id = a.galerie_id
INNER JOIN Ghid gh ON a.angajat_id = gh.angajat_id
WHERE
    g.nr_exponate >= 10
    AND a.vechime > 4
GROUP BY
    g.nume
HAVING
    COUNT(g.galerie_id) >= 1;


/*Urmatoare cerere contine urmatorul subpunct:
f) utilizarea a cel puțin 1 bloc de cerere (clauza WITH)
Cerinta:
Afișați numărul total de bilete achiziționate de către utilizatori pentru evenimentele care au loc înainte de data curentă, împărțite pe tipuri de bilete.
Query:*/
WITH BiletePerTip AS (
    SELECT
        b.tip,
        COUNT(*) AS total_bilete
    FROM
        Bilet b
    LEFT JOIN Bilet_Eveniment be ON b.bilet_id = be.bilet_id
    LEFT JOIN Eveniment e ON be.event_id = e.event_id AND e.data_inceput < SYSDATE
    WHERE
        e.event_id IS NULL -- Excludem biletele care nu sunt asociate cu un eveniment sau cu un eveniment care a început deja
    GROUP BY
        b.tip
)
SELECT
    tip,
    NVL(total_bilete, 0) AS total_bilete
FROM
    BiletePerTip;

/*Exercitiul 13:*/
UPDATE Ghid
SET salariu_ghid = salariu_ghid * 1.1
WHERE angajat_id IN (
    SELECT angajat_id
    FROM Angajat
    WHERE galerie_id IN (
        SELECT galerie_id
        FROM Galerie
        WHERE nr_exponate > 50
    )
);

UPDATE Exponat
SET nume_categorie = 'Necunoscută'
WHERE NOT EXISTS (
    SELECT *
    FROM Categorie
    WHERE Exponat.nume_categorie = Categorie.nume_categorie
);

UPDATE Supervizor
SET salariu_supervizor = salariu_supervizor * 1.05
WHERE angajat_id IN (
    SELECT angajat_id_supervizor
    FROM Supervizat_Supervizor
    INNER JOIN Angajat ON Supervizat_Supervizor.angajat_id_supervizat = Angajat.angajat_id
    WHERE Angajat.vechime < 3
);

DELETE FROM Bilet
WHERE utilizator_id IN (
    SELECT utilizator_id
    FROM Utilizator
    WHERE email IS NULL
);

DELETE FROM Bilet_Eveniment
WHERE event_id IN (
    SELECT event_id
    FROM Eveniment
    WHERE NOT EXISTS (
        SELECT *
        FROM Eveniment_Sponsor
        WHERE Eveniment.event_id = Eveniment_Sponsor.event_id
    )
);
DELETE FROM Bilet
WHERE bilet_id IN (
    SELECT bilet_id
    FROM Bilet_Eveniment
    WHERE event_id IN (
        SELECT event_id
        FROM Eveniment
        WHERE NOT EXISTS (
            SELECT *
            FROM Eveniment_Sponsor
            WHERE Eveniment.event_id = Eveniment_Sponsor.event_id
        )
    )
);

DELETE FROM Categorie
WHERE NOT EXISTS (
    SELECT *
    FROM Exponat
    WHERE Categorie.nume_categorie = Exponat.nume_categorie
);

/*Exercitiul 14*/
Creare View
CREATE VIEW DetaliiGalerii AS
WITH 
    SupervizorCount AS (
        SELECT 
            ss.angajat_id_supervizor, 
            COUNT(ss.angajat_id_supervizat) AS numar_supervizati
        FROM Supervizat_Supervizor ss
        GROUP BY ss.angajat_id_supervizor
    ),
    OrarCount AS (
        SELECT 
            o.galerie_id, 
            COUNT(o.orar_id) AS numar_orare
        FROM Orar o
        GROUP BY o.galerie_id
    ),
    TotalBilete AS (
        SELECT 
            b.utilizator_id,
            SUM(bg.pret_galerie) AS total_pret_galerie,
            SUM(be.pret_eveniment) AS total_pret_eveniment
        FROM Bilet b
        LEFT JOIN Bilet_Galerie bg ON b.bilet_id = bg.bilet_id
        LEFT JOIN Bilet_Eveniment be ON b.bilet_id = be.bilet_id
        GROUP BY b.utilizator_id
    )
SELECT 
    a.angajat_id,
    a.nume AS nume_angajat,
    g.nume AS nume_galerie,
    CASE
        WHEN s.pozitie IS NULL AND gh.angajat_id IS NOT NULL THEN 'Ghid'
        ELSE s.pozitie
    END AS pozitie,
    NVL(s.salariu_supervizor, gh.salariu_ghid) AS salariu,
    TRIM(a.email) AS email_curat,
    SUBSTR(a.nume, 1, 3) AS nume_prescurtat,
    a.varsta,
    CASE 
        WHEN a.varsta >= 50 THEN 'Senior'
        ELSE 'Junior'
    END AS categorie_varsta,
    NVL(sc.numar_supervizati, 0) AS numar_supervizati,
    NVL(oc.numar_orare, 0) AS numar_orare,
    NVL(tb.total_pret_galerie, 0) + NVL(tb.total_pret_eveniment, 0) AS total_incasat
FROM 
    Angajat a
LEFT JOIN Supervizor s ON a.angajat_id = s.angajat_id
LEFT JOIN Ghid gh ON a.angajat_id = gh.angajat_id
LEFT JOIN Galerie g ON a.galerie_id = g.galerie_id
LEFT JOIN SupervizorCount sc ON a.angajat_id = sc.angajat_id_supervizor
LEFT JOIN OrarCount oc ON a.galerie_id = oc.galerie_id
LEFT JOIN TotalBilete tb ON a.angajat_id = tb.utilizator_id;

Operatie permisa:
INSERT INTO Angajat (angajat_id, galerie_id, tip, vechime, nume, varsta, telefon, email)
VALUES (20, 1, 'Ghid', 5, 'Popescu Maria', 35, '0722123456', 'pop_maria213@gmail.com');
INSERT INTO Ghid (angajat_id, limba, salariu_ghid)
    VALUES (20, 'Italiana', 3500);

Operatie nepermisa:
UPDATE DetaliiGalerii
SET total_incasat = total_incasat + 100;

/*Exercitiul 15*/

/*Outer-join pe minim 4 tabele*/
SELECT 
    g.galerie_id,
    g.nume AS nume_galerie,
    g.nr_exponate,
    CASE
        WHEN g.data_incheiere IS NULL THEN 'Permanenta'
        ELSE TO_CHAR(g.data_incheiere, 'DD-MM-YYYY')
    END AS status_galerie,
    e.exponat_id,
    e.nume AS nume_exponat,
    NVL(a.nume, 'Nu exista') AS nume_angajat, 
    CASE
        WHEN s.angajat_id IS NOT NULL THEN 'Supervizor'
        WHEN gh.angajat_id IS NOT NULL THEN 'Ghid'
        ELSE 'Necunoscut'
    END AS pozitie_angajat,
    ev.event_id,
    ev.nume AS nume_eveniment
FROM 
    Galerie g
LEFT JOIN Exponat e ON g.galerie_id = e.galerie_id
LEFT JOIN Angajat a ON g.galerie_id = a.galerie_id
LEFT JOIN Supervizor s ON a.angajat_id = s.angajat_id
LEFT JOIN Ghid gh ON a.angajat_id = gh.angajat_id
LEFT JOIN Galerie_Eveniment ge ON g.galerie_id = ge.galerie_id
LEFT JOIN Eveniment ev ON ge.event_id = ev.event_id
ORDER BY g.galerie_id, e.exponat_id, a.angajat_id, ev.event_id;

/*Divison:*/
SELECT u.utilizator_id, u.nume, u.prenume
FROM Utilizator u
WHERE NOT EXISTS (
    SELECT *
    FROM Eveniment e
    WHERE NOT EXISTS (
        SELECT *
        FROM Bilet b
        WHERE b.utilizator_id = u.utilizator_id
        AND EXISTS (
            SELECT *
            FROM Bilet_Eveniment be
            WHERE be.bilet_id = b.bilet_id
            AND be.event_id = e.event_id
        )
    )
);

/*Analiza top-n*/
WITH Salarii AS (
    SELECT a.galerie_id, g.salariu_ghid AS salariu
    FROM Ghid g
    JOIN Angajat a ON g.angajat_id = a.angajat_id
    UNION ALL
    SELECT a.galerie_id, s.salariu_supervizor AS salariu
    FROM Supervizor s
    JOIN Angajat a ON s.angajat_id = a.angajat_id
)
SELECT g.galerie_id, g.nume AS nume_galerie, AVG(s.salariu) AS salariu_mediu
FROM Galerie g
JOIN Salarii s ON g.galerie_id = s.galerie_id
GROUP BY g.galerie_id, g.nume
ORDER BY salariu_mediu DESC
FETCH FIRST 2 ROWS ONLY;


