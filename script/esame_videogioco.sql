DROP DATABASE IF EXISTS mondi_blanco_784005;
CREATE DATABASE IF NOT EXISTS mondi_blanco_784005;
USE mondi_blanco_784005;

CREATE TABLE mondi(
	nome varchar(30) PRIMARY KEY,
	cordinate varchar(30) NOT NULL,
	diametro float NOT NULL
);

CREATE TABLE stati(
	nome varchar(30) NOT NULL,
	mondo varchar(30) NOT NULL,
	numabitanti int NOT NULL,
	PRIMARY KEY (nome,mondo),
	FOREIGN KEY (mondo) REFERENCES mondi(nome)
);

CREATE TABLE segretari(
	cod_segretario char(3) PRIMARY KEY,
	cognome varchar(30) NOT NULL,
	nome varchar(30) NOT NULL,
	anno_nascita int
);

CREATE TABLE partiti(
	data_elezione date NOT NULL,
	stato varchar(30) NOT NULL,
	mondo varchar(30) NOT NULL,
	nome varchar(30) NOT NULL,
	slogan text NOT NULL,
	segretario char(3) NOT NULL,
	PRIMARY KEY (data_elezione,stato,mondo),
	FOREIGN KEY (stato,mondo) REFERENCES stati (nome,mondo),
	FOREIGN KEY (segretario) REFERENCES segretari (cod_segretario)
);

CREATE TABLE voci_programmi(
	cod_voce char(3) PRIMARY KEY,
	descrizione text
);

CREATE TABLE voci(
	voce char(3) NOT NULL,
	data_elezione date NOT NULL,
	stato varchar(30) NOT NULL,
	mondo varchar(30) NOT NULL,
	PRIMARY KEY (voce,data_elezione,stato,mondo),
	FOREIGN KEY (voce) REFERENCES voci_programmi(cod_voce),
	FOREIGN KEY (data_elezione,stato,mondo) REFERENCES partiti (data_elezione,stato,mondo)

);

INSERT INTO mondi VALUES ("pandora","1x2y3z","100");
INSERT INTO mondi VALUES ("mondo2","1x2y3z","200");
INSERT INTO mondi VALUES ("mondo3","1x2y3z","300");

INSERT INTO stati VALUES ("europa","pandora","100");
INSERT INTO stati VALUES ("africa","pandora","200");
INSERT INTO stati VALUES ("asia","mondo2","300");

INSERT INTO segretari VALUES ("111","Nome1","Cognome1",1999);
INSERT INTO segretari VALUES ("222","Nome2","Cognome2",1959);
INSERT INTO segretari VALUES ("333","Nome3","Cognome3",1939);

INSERT INTO partiti VALUES ("1999-1-1","europa","pandora","nomep1","slo1","111");
INSERT INTO partiti VALUES ("1999-2-2","europa","pandora","nomep2","slo2","222");
INSERT INTO partiti VALUES ("1999-3-3","asia","mondo2","nomep3","slo3","333");

INSERT INTO voci_programmi VALUES ("111","desc1");
INSERT INTO voci_programmi VALUES ("222","desc2");
INSERT INTO voci_programmi VALUES ("333","desc3");

INSERT INTO voci VALUES ("111","1999-1-1","europa","pandora");
INSERT INTO voci VALUES ("222","1999-1-1","europa","pandora");
INSERT INTO voci VALUES ("333","1999-3-3","asia","mondo2");

-- Visualizzare data di elezione e nome dei partiti in che compongono lo stato “Europa” nel mondo “Pandora”;

SELECT data_elezione,nome
FROM partiti
WHERE stato = "europa" AND mondo = "pandora";

-- Visualizzare cognome, nome e anno di nascita dei segretari del partito del mondo “Pandora”;

SELECT s.cognome,s.nome,s.anno_nascita
FROM partiti AS p JOIN segretari AS s ON p.segretario = s.cod_segretario
WHERE p.mondo = "pandora";

-- Visualizzare il numero di partiti nel mondo “Pandora” suddiviso per ogni stato, mostrando anche il nome dello stato.

SELECT count(data_elezione),stato
FROM partiti 
WHERE mondo = "pandora"
GROUP BY stato;