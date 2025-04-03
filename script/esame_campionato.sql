DROP DATABASE IF EXISTS CHAMP_BlancoLorenzo;
CREATE DATABASE IF NOT EXISTS CHAMP_BlancoLorenzo;
USE CHAMP_BlancoLorenzo;

CREATE TABLE giornate(
	numero integer NOT NULL,
	girone varchar(10) NOT NULL,
	data date NOT NULL,
	PRIMARY KEY (numero,girone)
);

CREATE TABLE squadre(
	nome varchar(20) PRIMARY KEY,
	citta varchar(20) NOT NULL,
	nome_allenatore varchar(20) NOT NULL
);

CREATE TABLE partite(
	numero integer NOT NULL,
	numerog integer NOT NULL,
	girone varchar(10) NOT NULL,
	casa varchar(20) NOT NULL,
	ospite varchar(20) NOT NULL,
	risultato varchar(5) NOT NULL,
	PRIMARY KEY (numero,numerog,girone),
	FOREIGN KEY (numerog,girone) REFERENCES giornate (numero,girone)
);

CREATE TABLE posizioni(
	squadra varchar(20) NOT NULL,
	numerog integer NOT NULL,
	girone varchar(10) NOT NULL,
	punteggio integer NOT NULL,
	PRIMARY KEY (squadra,numerog,girone),
	FOREIGN KEY (numerog,girone) REFERENCES giornate (numero,girone),
	FOREIGN KEY (squadra) REFERENCES squadre (nome)
);

INSERT INTO giornate VALUES ("1","Andata","2020-1-1");
INSERT INTO giornate VALUES ("2","Andata","2020-1-1");
INSERT INTO giornate VALUES ("3","Ritorno","2020-1-1");

INSERT INTO squadre VALUES ("squadra1","citta1","Rossi1");
INSERT INTO squadre VALUES ("squadra2","citta2","Rossi2");
INSERT INTO squadre VALUES ("squadra3","citta3","Verdi");

INSERT INTO posizioni VALUES ("squadra1","1","Andata","3");
INSERT INTO posizioni VALUES ("squadra2","2","Andata","6");
INSERT INTO posizioni VALUES ("squadra3","3","Ritorno","1");

INSERT INTO partite VALUES ("1","1","Andata","squadra1","squadra2","3-0");
INSERT INTO partite VALUES ("2","2","Andata","squadra2","squadra3","1-1");
INSERT INTO partite VALUES ("3","3","Ritorno","squadra2","squadra1","4-4");
INSERT INTO partite VALUES ("4","3","Ritorno","squadra1","squadra3","1-0");

-- Visualizzare le partite della terza giornata, indicando la città e il nome della squadra di casa e della squadra ospite con i relativi risultati

SELECT sc.nome AS casa, sc.citta AS citta_casa, so.nome AS ospite, so.citta AS citta_ospite, p.risultato
FROM partite AS p 
JOIN squadre AS sc ON p.casa = sc.nome 
JOIN squadre AS so ON p.ospite = so.nome
WHERE p.numerog = "3";

-- Visualizzare il numero di partite e il nome delle squadre il cui nome dell’allenatore contiene la parola “Rossi”
SELECT COUNT(p.numero) AS numero_partite,s.nome 
FROM partite AS p JOIN squadre AS s ON p.casa = s.nome OR p.ospite = s.nome
WHERE s.nome_allenatore LIKE "%Rossi%"
GROUP BY s.nome;

-- Visualizzare la classifica finale del girone di andata e quella del girone di ritorno, riportando anche la data
SELECT g.girone,
       g.data,
       p.squadra,
       p.punteggio
FROM posizioni p
JOIN giornate g ON p.numerog = g.numero AND p.girone = g.girone
WHERE g.girone = 'Andata' OR g.girone = 'Ritorno'
ORDER BY g.data, g.girone, p.punteggio DESC;


