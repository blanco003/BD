DROP DATABASE IF EXISTS raccolta_blanco_784005;
CREATE DATABASE IF NOT EXISTS raccolta_blanco_784005;
USE raccolta_blanco_784005;

CREATE TABLE associazioni(
	nome varchar(20) PRIMARY KEY,
	iban varchar(30) NOT NULL,
	budget integer NOT NULL
);

CREATE TABLE sedi(
	cod_sede char(3) NOT NULL,
	associazione varchar(20) NOT NULL,
	num_associati integer NOT NULL,
	PRIMARY KEY (cod_sede,associazione),
	FOREIGN KEY (associazione) REFERENCES associazioni(nome)
);

CREATE TABLE responsabili(
	cod_responsabile char(3) PRIMARY KEY,
	cognome varchar(20) NOT NULL,
	nome varchar(20) NOT NULL,
	anno_nascita int NOT NULL
);

CREATE TABLE iniziative(
	cod_iniziativa char(3) NOT NULL,
	sede char(3) NOT NULL,
	associazione varchar(20) NOT NULL,
	nome varchar(20) NOT NULL,
	budget integer NOT NULL,
	responsabile char(3) NOT NULL,
	PRIMARY KEY (cod_iniziativa,sede,associazione),
	FOREIGN KEY (sede,associazione) REFERENCES sedi (cod_sede,associazione),
	FOREIGN KEY (responsabile) REFERENCES responsabili (cod_responsabile)
);

CREATE TABLE attivita(
	cod_attivita char(3) PRIMARY KEY,
	nome varchar(20) NOT NULL
);

CREATE TABLE composte (
	attivita char(3) NOT NULL,
	iniziativa char(3) NOT NULL,
	sede char(3) NOT NULL,
	PRIMARY KEY (attivita,iniziativa,sede),
	FOREIGN KEY (attivita) REFERENCES attivita(cod_attivita),
	FOREIGN KEY (iniziativa,sede) REFERENCES iniziative (cod_iniziativa,sede)
);


INSERT INTO associazioni VALUES ("Filobio","1111",4000);
INSERT INTO associazioni VALUES ("Aiutiamo l'Est","4534534",12330);
INSERT INTO associazioni VALUES ("Accoglienza minori","90993543",53400);

INSERT INTO sedi VALUES ("111","Filobio",100);
INSERT INTO sedi VALUES ("222","Accoglienza minori",200);
INSERT INTO sedi VALUES ("333","Aiutiamo l'Est",300);

INSERT INTO responsabili VALUES ("111","Rossi","mario",1999);
INSERT INTO responsabili VALUES ("222","Verdi","marco",1969);
INSERT INTO responsabili VALUES ("333","Blui","maria",1949);

INSERT INTO iniziative VALUES ("111","111","Filobio","iniz1",999,"111");
INSERT INTO iniziative VALUES ("222","222","Accoglienza minori","iniz2",999,"222");
INSERT INTO iniziative VALUES ("333","333","Aiutiamo l'Est","iniz3",999,"333");

INSERT INTO attivita VALUES ("111","att1");
INSERT INTO attivita VALUES ("222","att2");
INSERT INTO attivita VALUES ("333","att3");

INSERT INTO composte VALUES ("111","111","111");
INSERT INTO composte VALUES ("222","222","222");
INSERT INTO composte VALUES ("333","333","333");

SELECT a.budget,s.cod_sede
FROM associazioni AS a JOIN sedi AS s ON a.nome = s.associazione
WHERE a.nome = "Aiutiamo l'Est";

SELECT r.nome,r.cognome,r.anno_nascita
FROM responsabili AS r JOIN iniziative AS i ON i.responsabile = r.cod_responsabile
WHERE i.associazione = "Accoglienza minori";

-- Visualizzare il numero di iniziative dell’associazione “Filobio” suddivisi per sede, mostrando anche il codice della sede

SELECT count(i.cod_iniziativa) AS numero_iniziative,s.cod_sede
FROM sedi AS s JOIN iniziative AS i ON i.sede = s.cod_sede
WHERE s.associazione = "Filobio"
GROUP BY (s.cod_sede);