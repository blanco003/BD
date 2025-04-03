DROP DATABASE IF EXISTS esercizio;
CREATE DATABASE IF NOT EXISTS esercizio;
USE esercizio;

CREATE TABLE aeroporti(
    citta varchar(20) PRIMARY KEY,
    nazione varchar(20),
    num_piste int
);

CREATE TABLE aerei(
    tipo_aereo varchar(20) PRIMARY KEY,
    num_passeggeri int,
    qta_merci int
);

CREATE TABLE voli(
    id_volo int,    
    giorno_sett int,
    citta_partenza varchar(20),
    ora_partenza int,
    citta_arrivo varchar(20),
    ora_arrivo int,
    tipo_aereo varchar(20),
    PRIMARY KEY(id_volo, giorno_sett),
    FOREIGN KEY (citta_partenza) REFERENCES aeroporti(citta) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (citta_arrivo) REFERENCES aeroporti(citta) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tipo_aereo) REFERENCES aerei(tipo_aereo) ON DELETE CASCADE ON UPDATE CASCADE
);

DESCRIBE aeroporti;
DESCRIBE aerei;
DESCRIBE voli;

INSERT INTO aeroporti VALUES ("Milano","Italia",5);
INSERT INTO aeroporti VALUES ("Berlino","Germania",10);
INSERT INTO aeroporti VALUES ("Parigi","Francia",2);
INSERT INTO aeroporti (citta,nazione) VALUES ("Bari","Italia");

INSERT INTO aerei VALUES ("Boeing",50,100);
INSERT INTO aerei VALUES ("Militare",20,300);
INSERT INTO aerei VALUES ("Ryanair",85,50);

INSERT INTO voli VALUES (123,3,"Milano",15,"Berlino",20,"Ryanair");
INSERT INTO voli VALUES (274,5,"Berlino",6,"Parigi",12,"Militare");
INSERT INTO voli VALUES (354,4,"Parigi",15,"Milano",18,"Boeing");
INSERT INTO voli VALUES (125,3,"Milano",15,"Parigi",20,"Boeing");
INSERT INTO voli VALUES (274,4,"Bari",6,"Parigi",12,"Militare");
INSERT INTO voli VALUES (262,4,"Bari",6,"Milano",12,"Ryanair");
INSERT INTO voli VALUES (764,4,"Parigi",12,"Bari",20,"Boeing");

SELECT * FROM aeroporti;
SELECT * FROM aerei;
SELECT * FROM voli;

-- 1) citta con un aeroporto di cui non è noto il numero di piste
SELECT citta
FROM aeroporti
wHERE num_piste IS NULL;

-- 2) nazioni di cui parte e arriva il volo con codice 274
SELECT a1.nazione, a2.nazione
FROM aeroporti AS a1 join voli on a1.citta=citta_partenza 
join aeroporti AS a2 on a2.citta=citta_partenza 
WHERE id_volo=274;


-- 3) tipi di aereo usati nei voli che partono da Milano
SELECT tipo_aereo
FROM voli
WHERE citta_partenza="Milano";

-- 4) tipi di aereo e numero di passeggeri per i tipi di aereo usati nei voli che partono da Milano
SELECT a.tipo_aereo, a.num_passeggeri
FROM voli v JOIN aerei a ON v.tipo_aereo = a.tipo_aereo
WHERE v.citta_partenza = "Milano";

-- 5) le città da cui partono voli internazionali
SELECT citta_partenza
FROM aeroporti AS a1 JOIN voli ON a1.citta = citta_partenza
JOIN aeroporti AS a2 ON a2.citta = citta_arrivo
WHERE a1.nazione <> a2.nazione;


-- 6) le città da cui partono voli diretti a Milano, ordinate alfabeticamente
SELECT citta_partenza
FROM voli
WHERE citta_arrivo = "Milano" ORDER BY citta_partenza ASC;

-- 7) il numero di voli internazionali che partono il giovedì (giorno 4) da Parigi
SELECT count(*)
FROM voli 
WHERE giorno_sett=4 AND citta_partenza="Parigi";

-- 8) il numero di voli internazionali che partono ogni settimana da città italiane (farlo in due modi, 
-- facendo comparire o meno nel risultato gli aeroporti senza voli internazionali)

-- solo contando
SELECT count(citta_arrivo)
FROM aeroporti AS a1 JOIN voli ON citta_partenza = a1.citta
JOIN aeroporti AS a2 ON citta_arrivo = a2.citta
WHERE a1.nazione = "Italia" AND a1.nazione <> a2.nazione
GROUP BY citta_partenza;

-- mostrando i voli non internazionali
SELECT count(*), citta_partenza
FROM aeroporti AS a1 JOIN voli ON citta_partenza = a1.citta
JOIN aeroporti AS a2 ON citta_arrivo = a2.citta
WHERE a1.nazione = "Italia" AND a1.nazione <> a2.nazione
GROUP BY citta_partenza;

-- 9) le città francesi da cui partono più di venti voli alla settimana diretti in Italia
SELECT citta_partenza
FROM aeroporti AS a1 JOIN voli ON citta_partenza = a1.citta
JOIN aeroporti AS a2 ON citta_arrivo = a2.citta
WHERE a1.nazione="Francia" AND a2.nazione="Italia"
GROUP BY citta_partenza
HAVING count(*)>20;

-- 10) gli aeroporti italiani che hanno solo voli interni
SELECT DISTINCT a1.citta
FROM aeroporti AS a1 JOIN voli ON citta_partenza = a1.citta
JOIN aeroporti AS a2 ON citta_arrivo = a2.citta
WHERE a1.Nazione = "Italia" AND a2.nazione = a1.nazione;