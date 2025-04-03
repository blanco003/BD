DROP DATABASE IF EXISTS tornei_blanco;
CREATE DATABASE IF NOT EXISTS tornei_blanco;
USE tornei_blanco;

CREATE TABLE tornei (
	codice varchar(5) PRIMARY KEY,
	nome varchar(15) NOT NULL
);

CREATE TABLE squadre (
	nome varchar(15) PRIMARY KEY,
	rosa varchar(15) NOT NULL,
	punteggio integer NOT NULL,
	torneo varchar(5) NOT NULL,
	FOREIGN KEY (torneo) REFERENCES tornei (codice)
);

CREATE TABLE partite (
	data date NOT NULL,
	stadio varchar(15) NOT NULL,
	risultato varchar(10) NOT NULL,
	PRIMARY KEY (data,stadio)
);


CREATE TABLE dispute (
	data date NOT NULL,
	stadio varchar(15) NOT NULL,
	squadra varchar(15) NOT NULL,
	PRIMARY KEY (data,stadio,squadra),
	FOREIGN KEY (squadra) REFERENCES squadre(nome),
	FOREIGN KEY (data,stadio) REFERENCES partite(data,stadio)
);

CREATE TABLE giocatori (
	squadra varchar(15) NOT NULL,
	numero_maglia integer NOT NULL,
	data_nascita date NOT NULL,
	nome varchar(20) NOT NULL,
	PRIMARY KEY (numero_maglia,squadra),
	FOREIGN KEY (squadra) REFERENCES squadre (nome)
);

CREATE TABLE partecipazioni (
	squadra varchar(15) NOT NULL,
	giocatore integer NOT NULL,	
	data date NOT NULL,
	stadio varchar(15) NOT NULL,
	ruolo varchar(20) NOT NULL,
	PRIMARY KEY (squadra,giocatore,data,stadio),
	FOREIGN KEY (squadra,giocatore) REFERENCES giocatori (squadra,numero_maglia),
	FOREIGN KEY (data,stadio) REFERENCES partite (data,stadio)
);

INSERT INTO tornei VALUES ("1","Torneo 1");
INSERT INTO tornei VALUES ("2","Torneo 2");
INSERT INTO tornei VALUES ("3","Torneo 3");

INSERT INTO squadre VALUES ("Squadra 1","Rosa 1","1","1");
INSERT INTO squadre VALUES ("x","Rosa 2","2","2");
INSERT INTO squadre VALUES ("Squadra 3","Rosa 3","3","3");

INSERT INTO partite VALUES ("2000-1-1","Stadio 1","1-1");
INSERT INTO partite VALUES ("2010-2-2","Stadio 2","3-2");
INSERT INTO partite VALUES ("2012-3-3","Stadio 3","0-0");


INSERT INTO dispute VALUES ("2000-1-1","Stadio 1","Squadra 1");
INSERT INTO dispute VALUES ("2010-2-2","Stadio 2","x");
INSERT INTO dispute VALUES ("2012-3-3","Stadio 3","Squadra 3");

INSERT INTO giocatori VALUES ("Squadra 1","1","2000-1-1","Nome 1");
INSERT INTO giocatori VALUES ("x","22","2000-1-1","Nome 2");
INSERT INTO giocatori VALUES ("x","33","2000-1-1","Nome 3");

INSERT INTO partecipazioni VALUES ("Squadra 1","1","2000-1-1","Stadio 1","Attaccante");
INSERT INTO partecipazioni VALUES ("x","22","2010-2-2","Stadio 2","Difensore");
INSERT INTO partecipazioni VALUES ("x","33","2012-3-3","Stadio 3","Attaccante");

-- visualizza tutti i giocatori della squadra 'x'
SELECT * 
FROM giocatori
WHERE squadra = "x";

-- visualizzare tutte le informazioni relative alla squadra 'x'
SELECT * 
FROM squadre
WHERE nome = "x";

-- visualizza la squadra in prima posizione in classifica
SELECT nome AS "squara in testa"
FROM squadre
GROUP BY nome
ORDER BY sum(punteggio) desc
LIMIT 1;

-- visualizza tutte le partite svolte nello stadio 'x'
SELECT d.stadio, d.squadra,d.data,p.risultato
FROM dispute AS d JOIN partite AS p ON d.stadio = p.stadio AND d.data = p.data
WHERE d.stadio = "Stadio 2";

-- visualizzare tutte le squadre partecipanti al torneo 'x', ordinate per posizionamento in classifica
SELECT nome AS "squadra"
FROM squadre
WHERE torneo = "1"
ORDER BY punteggio desc;