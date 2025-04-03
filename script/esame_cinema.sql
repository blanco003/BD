DROP DATABASE IF EXISTS cinema_blanco;
CREATE DATABASE IF NOT EXISTS cinema_blanco;
USE cinema_blanco;

CREATE TABLE registi(
	codice_regista varchar(5) PRIMARY KEY,
	nome varchar(20) NOT NULL,
	cognome varchar(20) NOT NULL,
	anno_nascita integer NOT NULL
);


CREATE TABLE categorie(
	codice_categoria varchar(5) PRIMARY KEY,
	nome varchar(15) NOT NULL
);

CREATE TABLE film(
	titolo varchar(25) PRIMARY KEY,
	nazionalita varchar(20) NOT NULL,
	regista varchar(5) NOT NULL,
	categoria varchar(5) NOT NULL, 
	FOREIGN KEY (regista) REFERENCES registi(codice_regista),
	FOREIGN KEY (categoria) REFERENCES  categorie(codice_categoria)
);

CREATE TABLE cinema(
	nome varchar(20) PRIMARY KEY,
	indirizzo varchar(30) NOT NULL,
	telefono varchar(20) NOT NULL
);


CREATE TABLE sale(
	id_sala varchar(5),
	cinema varchar(20) NOT NULL,
	posti integer NOT NULL,
	PRIMARY KEY (id_sala,cinema),
	FOREIGN KEY (cinema) REFERENCES cinema(nome)
);

CREATE TABLE proiezioni(
	orario varchar(10) NOT NULL,
	sala varchar(5) NOT NULL,
	cinema varchar(20) NOT NULL,	
	film varchar(25) NOT NULL,
	PRIMARY KEY (orario,sala,cinema),
	FOREIGN KEY (film) REFERENCES film(titolo),
	FOREIGN KEY (sala,cinema) REFERENCES sale (id_sala,cinema)
);

INSERT INTO categorie VALUES ("1","Horror");
INSERT INTO categorie VALUES ("2","Comico");
INSERT INTO categorie VALUES ("3","Giallo");

INSERT INTO registi VALUES ("1","mario","rossi",1999);
INSERT INTO registi VALUES ("2","giuseppe","verdi",1952);
INSERT INTO registi VALUES ("3","alberto","blui",1988);

INSERT INTO film VALUES ("Film1","Italia","1","2");
INSERT INTO film VALUES ("Film2","Francia","2","3");
INSERT INTO film VALUES ("Film3","Germania","3","1");

INSERT INTO cinema VALUES ("Paradiso","Via 1","333333333");
INSERT INTO cinema VALUES ("Cinema 2","Via 2","335464533");
INSERT INTO cinema VALUES ("Cinema 3","Via 3","123123123");

INSERT INTO sale VALUES ("3","Paradiso","100");
INSERT INTO sale VALUES ("1","Paradiso","400");
INSERT INTO sale VALUES ("2","Cinema 2","420");

INSERT INTO proiezioni VALUES ("19:00","3","Paradiso","Film1");
INSERT INTO proiezioni VALUES ("16:00","1","Paradiso","Film2");
INSERT INTO proiezioni VALUES ("22:00","2","Cinema 2","Film3"); 	


SELECT * FROM categorie;
SELECT * FROM registi;
SELECT * FROM film;
SELECT * FROM cinema;
SELECT * FROM sale;


-- Visualizzare Orario e Titolo dei film in programmazione della sala 3 del cinema “Paradiso”;
SELECT orario,film
FROM proiezioni 
WHERE sala = 3 AND cinema = "Paradiso";

-- Visualizzare cognome, nome e anno di nascita dei registi dei film in programmazione nel cinema “Paradiso”;
SELECT r.cognome,r.nome,r.anno_nascita
FROM registi AS r JOIN film AS f ON f.regista = r.codice_regista JOIN proiezioni AS  pr ON pr.film = f.titolo
WHERE pr.cinema = "Paradiso";

-- Visualizzare il numero di film in programmazione nel cinema “Paradiso” per ogni sala, mostrando anche il numero di sala.

SELECT pr.sala , COUNT(pr.film)
FROM proiezioni AS pr
WHERE cinema = "Paradiso"
GROUP BY (sala);
