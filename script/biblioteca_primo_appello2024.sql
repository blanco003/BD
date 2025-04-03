DROP DATABASE IF EXISTS biblio_blanco;
CREATE DATABASE IF NOT EXISTS biblio_blanco;
USE biblio_blanco;

CREATE TABLE lettori(
	cod char(3) PRIMARY KEY,
	nome varchar(20) NOT NULL,
	indirizzo varchar(20) NOT NULL
);

CREATE TABLE libri(
	titolo varchar(30) PRIMARY KEY
);

CREATE TABLE copie(
	cod char(3) PRIMARY KEY,
	tipo varchar(20) NOT NULL,
	libro varchar(30) NOT NULL,
	FOREIGN KEY (libro) REFERENCES libri(titolo)
);

CREATE TABLE autori(
 	cod char(3) PRIMARY KEY,
	nome varchar(20) NOT NULL,
	cognone varchar(20) NOT NULL
);
	


CREATE TABLE scritti(
	libro varchar(30) NOT NULL,
	autore char(3) NOT NULL,
	PRIMARY KEY (libro,autore),
	FOREIGN KEY (libro) REFERENCES libri(titolo),
	FOREIGN KEY (autore) REFERENCES autori(cod)

);

CREATE TABLE prestiti(
	lettore char(3) NOT NULL,	
	data_acq date NOT NULL,
	copia char(3) NOT NULL,
	ora_acq int NOT NULL,
	ora_rit int NOT NULL,
	data_rit date NOT NULL,
	PRIMARY KEY (lettore,data_acq,copia),
	FOREIGN KEY (lettore) REFERENCES lettori(cod),
	FOREIGN KEY (copia) REFERENCES copie(cod)
);

INSERT INTO lettori VALUES ("111","nome1","via1");
INSERT INTO lettori VALUES ("222","nome2","via2");
INSERT INTO lettori VALUES ("333","nome3","via3");

INSERT INTO autori VALUES ("111","nome1","cogn1");
INSERT INTO autori VALUES ("222","nome2","cogn2");
INSERT INTO autori VALUES ("333","nome3","cogn3");

INSERT INTO libri VALUES ("titolo1");
INSERT INTO libri VALUES ("titolo2");
INSERT INTO libri VALUES ("titolo3");

INSERT INTO scritti VALUES ("titolo1","111");
INSERT INTO scritti VALUES ("titolo2","222");
INSERT INTO scritti VALUES ("titolo3","333");

INSERT INTO copie VALUES ("111","disponibile","titolo1");
INSERT INTO copie VALUES ("222","disponibile","titolo2");
INSERT INTO copie VALUES ("333","prestito","titolo3");

INSERT INTO prestiti VALUES ("111","2020-1-1","333","20","22","2020-1-1");
INSERT INTO prestiti VALUES ("222","2020-1-2","222","20","22","2020-1-3");
INSERT INTO prestiti VALUES ("333","2020-1-3","111","20","22","2020-1-2");


-- Dato un nome di lettore, mostrare l’elenco di titoli che ha chiesto in prestito, con data di acquisizione e riconsegna;

SELECT c.libro,p.data_acq,p.data_rit
FROM lettori AS l JOIN prestiti AS p ON p.lettore = l.cod JOIN copie AS c ON p.copia = c.cod
WHERE l.nome = "nome1";

-- Mostrare i titoli dei libri in prestito, con l’indicazione del titolo e del nome del lettore;

SELECT l.nome AS lettore, c.libro AS titolo
FROM lettori AS l
JOIN prestiti AS p ON p.lettore = l.cod
JOIN copie AS c ON p.copia = c.cod
WHERE c.tipo = "prestito";

-- Mostrare i titoli dei libri archiviati in biblioteca, con l’indicazione del numero di copie disponibili per la consultazione e il numero di copie prestate;

SELECT l.titolo AS titolo_libro,
       COUNT(CASE WHEN c.tipo = 'disponibile' THEN 1 END) AS copie_disponibili,
       COUNT(CASE WHEN c.tipo = 'prestito' THEN 1 END) AS copie_in_prestito
FROM libri AS l
LEFT JOIN copie AS c ON l.titolo = c.libro
GROUP BY l.titolo;




	