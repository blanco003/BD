DROP DATABASE IF EXISTS blanco_concerti;
CREATE DATABASE IF NOT EXISTS blanco_concerti;
USE blanco_concerti;

CREATE TABLE autori(
	codice char(3) PRIMARY KEY,
	nome varchar(30) NOT NULL
);

CREATE TABLE pezzi(
	codice varchar(3) PRIMARY KEY,
	titolo varchar(20) NOT NULL,
	autore char(3) NOT NULL,
	FOREIGN KEY (autore) REFERENCES autori(codice)
);

CREATE TABLE sale(
	codice char(3) PRIMARY KEY,
	nome varchar(20) NOT NULL,
	capienza integer
);

CREATE TABLE orchestre(
	nome varchar(10) PRIMARY KEY,
	nome_direttore varchar(20) NOT NULL,
	cognome_direttore varchar(20) NOT NULL
);

CREATE TABLE concerti(
	codice char(3) PRIMARY KEY,
	descrizione text NOT NULL,
	titolo varchar(30) NOT NULL,
	sala char(3) NOT NULL,
	orchestra varchar(10) NOT NULL,
	FOREIGN KEY (sala) REFERENCES sale(codice),
	FOREIGN KEY (orchestra) REFERENCES orchestre(nome)
);

CREATE TABLE esecuzioni(
	concerto char(3) not null,
	ordine integer not null,
	PRIMARY KEY (concerto,ordine),
	FOREIGN KEY (concerto) REFERENCES concerti(codice)
);

CREATE TABLE suonati(
	concerto char(3) not null,
	ordine integer not null,
	pezzo char(3) Not null,
	PRIMARY KEY (concerto,ordine,pezzo),
	FOREIGN KEY (concerto,ordine) REFERENCES esecuzioni(concerto,ordine)
);

CREATE TABLE repliche (
	data date NOT NULL,
	concerto char(3) NOT NULL,
	PRIMARY KEY (data,concerto),
	FOREIGN KEY (concerto) REFERENCES concerti(codice)
	
);

CREATE TABLE orchestrali (
	matricola char(3) PRIMARY KEY,
	nome varchar(20) NOT NULL,
	cognome varchar(20) NOT NULL	
);

CREATE TABLE comporre (
	orchestra varchar(10) NOT NULL,
	orchestrale char(3) NOT NULL,
	strumento varchar(20),
	PRIMARY KEY (orchestra,orchestrale),
	FOREIGN KEY (orchestra) REFERENCES orchestre(nome),
	FOREIGN KEY (orchestrale) REFERENCES orchestrali(matricola)	
);

INSERT INTO autori VALUES ("111","Mario");
INSERT INTO autori VALUES ("222","Marco");
INSERT INTO autori VALUES ("333","Giuseppe");

INSERT INTO pezzi VALUES ("111","La tua canzone","111");
INSERT INTO pezzi VALUES ("222","algf","222");
INSERT INTO pezzi VALUES ("333","2sefsef","333");

INSERT INTO sale VALUES ("111","sala1",200);
INSERT INTO sale VALUES ("112","sala2",300);
INSERT INTO sale VALUES ("113","sala3",400);

INSERT INTO orchestre VALUES ("orch1","mario","rossi");
INSERT INTO orchestre VALUES ("orch2","mario","rossi2");
INSERT INTO orchestre VALUES ("orch3","mario","rossi3");

INSERT INTO orchestrali VALUES ("111","marco","rossi1");
INSERT INTO orchestrali VALUES ("112","marco2","rossi2");
INSERT INTO orchestrali VALUES ("113","marco3","rossi3");

INSERT INTO comporre VALUES ("orch1","111","flauto");
INSERT INTO comporre VALUES ("orch2","112","flauto2");
INSERT INTO comporre VALUES ("orch3","113","flauto3");

INSERT INTO concerti VALUES ("111","desc1","tit1","111","orch1");
INSERT INTO concerti VALUES ("112","desc2","tit2","112","orch2");
INSERT INTO concerti VALUES ("113","desc3","tit3","113","orch3");

INSERT INTO repliche VALUES ("2020-1-1","111");
INSERT INTO repliche VALUES ("2020-1-1","112");
INSERT INTO repliche VALUES ("2020-1-1","113");

INSERT INTO esecuzioni VALUES ("111","1");
INSERT INTO esecuzioni VALUES ("112","2");
INSERT INTO esecuzioni VALUES ("113","3");

INSERT INTO suonati VALUES ("111", "1", "111");
INSERT INTO suonati VALUES ("112", "2", "222");
INSERT INTO suonati VALUES ("113", "3", "333");
