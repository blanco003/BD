DROP DATABASE IF EXISTS voti_BlancoLorenzo;
CREATE DATABASE IF NOT EXISTS voti_BlancoLorenzo;
USE voti_BlancoLorenzo;

CREATE TABLE docenti(
	matricola char(6) PRIMARY KEY,
	nome varchar(10) NOT NULL
); 

CREATE TABLE corsi(
	cod char(3) PRIMARY KEY,
	nome varchar(25) NOT NULL
);

CREATE TABLE edizioni(
	anno int NOT NULL,
	corso char(3) NOT NULL,
	docente char(6),
	PRIMARY KEY (anno,corso),
	FOREIGN KEY (corso) REFERENCES corsi(cod),
	FOREIGN KEY (docente) REFERENCES docenti(matricola)
);

CREATE TABLE esercitazioni(
	anno int NOT NULL,
	corso char(3) NOT NULL,
	numero int NOT NULL,
	descrizione text NOT NULL,
	PRIMARY KEY (anno,corso,numero),
	FOREIGN KEY (anno,corso) REFERENCES edizioni (anno,corso)
);


CREATE TABLE studenti(
	matricola char(6) PRIMARY KEY,
	nome varchar(10) NOT NULL
); 

CREATE TABLE svolge(
	studente char(6) NOT NULL,
	anno int NOT NULL,
	corso char(3) NOT NULL,
	numero int NOT NULL,
	punteggio int NOT NULL,
	PRIMARY KEY (studente,anno,corso,numero),
	FOREIGN KEY (studente) REFERENCES studenti (matricola),
	FOREIGN KEY (anno,corso,numero) REFERENCES esercitazioni (anno,corso,numero)
);

CREATE TABLE esami(
	data date NOT NULL,
	anno int NOT NULL,
	corso char(3) NOT NULL,
	studente char(6) NOT NULL,
	orale int NOT NULL,
	scritto int NOT NULL,
	voto_finale int NOT NULL,
	PRIMARY KEY (data,anno,corso,studente),
	FOREIGN KEY (studente) REFERENCES studenti (matricola),
	FOREIGN KEY (anno,corso) REFERENCES edizioni (anno,corso)
);

INSERT INTO docenti VALUES ("111111","doc1");
INSERT INTO docenti VALUES ("222222","doc2");
INSERT INTO docenti VALUES ("333333","doc3");

INSERT INTO corsi VALUES ("111","basi di dati corso a");
INSERT INTO corsi VALUES ("222","algortmi e strutture dati");
INSERT INTO corsi VALUES ("333","programmazione");

INSERT INTO edizioni VALUES ("2024","111","111111");
INSERT INTO edizioni VALUES ("2023","222","222222");
INSERT INTO edizioni VALUES ("2022","333","333333");

INSERT INTO esercitazioni VALUES ("2024","111","1","desc1");
INSERT INTO esercitazioni VALUES ("2023","222","1","desc2");
INSERT INTO esercitazioni VALUES ("2022","333","1","desc3");

INSERT INTO studenti VALUES ("111111","stud1");
INSERT INTO studenti VALUES ("222222","stud2");
INSERT INTO studenti VALUES ("333333","stud3");

INSERT INTO svolge VALUES ("111111","2024","111","1","30");
INSERT INTO svolge VALUES ("222222","2023","222","1","20");
INSERT INTO svolge VALUES ("333333","2022","333","1","10");

INSERT INTO esami VALUES ("2024-1-1","2024","111","111111","20","30","25");
INSERT INTO esami VALUES ("2024-1-1","2024","111","222222","22","18","20");
INSERT INTO esami VALUES ("2024-1-1","2024","111","333333","23","19","22");

-- Visualizzare matricola e nome degli di studenti che hanno superato l’esame di ‘basi di dati corso a’, riportando punteggio dell’orale, dello scritto e il voto finale

SELECT s.matricola,s.nome,e.scritto,e.orale,e.voto_finale
FROM studenti AS s JOIN esami AS e ON e.studente = s.matricola JOIN edizioni AS ed ON e.anno = ed.anno AND e.corso = ed.corso JOIN corsi AS c  ON ed.corso = c.cod
WHERE c.nome = "basi di dati corso a";

-- Visualizzare la media dei voti conseguiti nel corso di ‘basi di dati corso a’ del 2021 nell’appello del 14/11/2022

SELECT avg(e.voto_finale) AS media_voti
FROM esami AS e JOIN edizioni AS ed ON e.anno = ed.anno AND e.corso = ed.corso JOIN corsi AS c  ON ed.corso = c.cod
WHERE c.nome = "basi di dati corso a" AND e.anno = 2024;

-- Visualizzare matricola e nome di studenti che hanno seguito nell’edizione del 2021 di ‘basi di dati corso a’ e, per ognuno, il numero di esercitazioni che hanno svolto.

SELECT s.matricola,s.nome,count(sv.studente) AS numero_esercitazioni
FROM studenti AS s JOIN svolge AS sv ON sv.studente = s.matricola JOIN esercitazioni AS es ON sv.numero = es.numero AND sv.corso = es.corso AND sv.anno = es.anno JOIN edizioni as ed ON es.corso = ed.corso AND es.anno = ed.anno JOIN corsi AS c ON ed.corso = c.cod
WHERE ed.anno = 2024 AND c.nome = "basi di dati corso a"
GROUP BY (s.matricola);

