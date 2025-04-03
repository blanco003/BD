DROP DATABASE IF EXISTS dbinf23;
CREATE DATABASE IF NOT EXISTS dbinf23;
USE dbinf23;

CREATE TABLE Impiegati(
    matricola char(7) PRIMARY KEY,
    cognome varchar(30),
    nome varchar(30),
    reparto char(8)
);


CREATE TABLE Reparti(
    cod_reparto char(8),
    nome varchar(25),
    num_dipendenti int NOT NULL, 
    CONSTRAINT PRIMARY KEY (cod_reparto),
    CHECK (num_dipendenti>0 AND num_dipendenti<50)
);


ALTER TABLE Impiegati 
ADD FOREIGN KEY(reparto) 
REFERENCES Reparti (cod_reparto)
ON DELETE CASCADE
ON UPDATE CASCADE;



INSERT INTO Reparti VALUES('hr','Personale',30);
INSERT INTO Reparti VALUES('pr','Produzione',40);

INSERT INTO impiegati VALUES('111111','Rossi','Mario','hr');
INSERT INTO impiegati VALUES('111112','Verdi','Giuseppe','pr');
INSERT INTO impiegati VALUES('111113','Bianchi','Lucia','hr');  
INSERT INTO impiegati VALUES('111114','Gialli','Rocco','pr'); 
INSERT INTO impiegati VALUES('111115','Gialli','Marco','pr'); 
INSERT INTO impiegati (matricola,cognome,reparto) VALUES('111116','Blui','hr');  

UPDATE impiegati SET cognome="Rossini" WHERE cognome = "Rossi";

CREATE TABLE Impiegatipr (
    matricola char(7) PRIMARY KEY,
    cognome varchar(30),
    nome varchar(30),
    reparto char(8),
    CONSTRAINT chiave_esternaFK
    FOREIGN KEY (reparto) 
    REFERENCES Reparti (cod_reparto)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


INSERT INTO Impiegatipr SELECT * FROM Impiegati WHERE reparto = 'pr';



SELECT * FROM Impiegati;
SELECT * FROM Reparti;
SELECT * FROM Impiegatipr;

ALTER TABLE Impiegati 
    ADD COLUMN daeliminare char(25) AFTER matricola,
    ADD COLUMN eliminaredipiu char(25) AFTER daeliminare;

DESCRIBE impiegati;

ALTER TABLE Impiegati 
    DROP COLUMN daeliminare,
    DROP COLUMN eliminaredipiu;

DESCRIBE impiegati;


SELECT DISTINCT reparto FROM Impiegati ORDER BY reparto DESC;

UPDATE Reparti SET cod_reparto="humanr" WHERE cod_reparto = "hr";

/* seleziona il nome e cognome di tutti gli impiegati */ 
SELECT nome, cognome
FROM impiegati;

/* seleziona il nome e cognome di tutti gli impiegati di cognome Gialli*/ 
SELECT nome, cognome
FROM impiegati
WHERE cognome = "Gialli";

SELECT i.cognome AS Cognome , i.nome AS Nome
FROM impiegati i
WHERE i.cognome = "Gialli";

/* seleziona il numero di dipendenti diviso 2 di tutti i reparti */ 
SELECT nome, num_dipendenti/2 AS Dipendenti_rimasti
FROM Reparti;

CREATE TABLE esami(
    nome_esame char(35) PRIMARY KEY,
    cfu_esame int,
    voto_esame int,
    lode bool
);

CREATE TABLE docenti(
    matricola int PRIMARY KEY,
    cognome char(35),
    nome_esame char(35),
    CONSTRAINT FOREIGN KEY(nome_esame) REFERENCES esami (nome_esame)
);

INSERT INTO esami VALUES("ASD",9,18,0);
INSERT INTO esami VALUES("Basi dati",9,28,0);
INSERT INTO esami VALUES("Statistica",6,30,1);
INSERT INTO esami VALUES("Discreta",9,26,0);
INSERT INTO esami VALUES("Programmazione",12,21,0);

INSERT INTO docenti VALUES("123456","buono","Basi dati");
INSERT INTO docenti VALUES("123457","di mauro","ASD");


SELECT * FROM esami;

/*media degli esami */
SELECT AVG(voto_esame) AS Media
FROM esami;

SELECT  nome_esame AS esame,
        voto_esame AS voto,
       (voto_esame * cfu_esame) AS votopercfu,
       (voto_esame*cfu_esame)/9 AS voto_standard
FROM esami;

SELECT SUM(voto_esame*cfu_esame)/SUM(cfu_esame) AS voto_pesato
FROM esami;

-- esami che hanno una doppia m nel nome
SELECT * 
FROM esami
WHERE nome_esame LIKE "%mm%";

-- 
SELECT nome_esame AS Esame
FROM esami
WHERE nome_esame LIKE "A%";

-- GROUP BY serve a raggruppare l'output

-- media degli esami per cfu
SELECT cfu_esame , AVG(voto_esame) AS Media
FROM esami
WHERE cfu_esame<14
GROUP BY cfu_esame;

-- media degli esami per cfu dove la media è superiore a 20
SELECT cfu_esame , AVG(voto_esame) AS Media
FROM esami
WHERE cfu_esame<14
GROUP BY cfu_esame
HAVING Media >22;

-- non si può usare HAVING senza aver fatto il GROUP BY

-- via breve senza join
SELECT *
FROM impiegati, reparti
WHERE reparto = cod_reparto;  -- senza condizione risulterebbe il prodotto cartesiano

-- usando il JOIN
SELECT *
FROM impiegati JOIN reparti ON reparto = cod_reparto;  -- EQUI JOIN

SELECT *
FROM docenti NATURAL JOIN esami;  -- per il NATURAL JOIN devono avere lo stesso nome attributo, altrimenti fa il prodotto cartesiano

-- ORDER BY serve ad ordinare l'output in modo decrescente (DESC) o crescente (ASC), ASC è sottointeso
SELECT *
FROM esami 
ORDER BY voto_esame DESC;

-- si possono inserire più attributi in ordine di ordinamento
SELECT *
FROM esami
ORDER BY cfu_esame, voto_esame DESC;

-- UNION, INTESECTION , EXCEPT e interrogazioni nidificate , ANY e ALL