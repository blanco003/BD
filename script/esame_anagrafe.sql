DROP DATABASE IF EXISTS anagrafe_blanco;
CREATE DATABASE IF NOT EXISTS anagrafe_blanco;
USE anagrafe_blanco;

CREATE TABLE cittadini(
	cf varchar(20) PRIMARY KEY,	
	nome varchar(20) NOT NULL,
	cognome varchar(20) NOT NULL,
	sesso char(1) NOT NULL,
	data_nascita date NOT NULL,
	tipo ENUM("nato in comune","nato in altro comune") NOT NULL,
	comune_nascita varchar(20),
	num_reg int,
	num_pag int,
	residente ENUM("residente","non residente") NOT NULL
);

CREATE TABLE famiglie(
	capo_famiglia varchar(20) PRIMARY KEY,
	via varchar(30) NOT NULL,
	numero_civico int NOT NULL,
	interno varchar(2) NOT NULL,
	FOREIGN KEY (capo_famiglia) REFERENCES cittadini(cf)
);


CREATE TABLE membri(
	cittadino varchar(20) NOT NULL,
	famiglia varchar(20) NOT NULL,
	grado varchar(15) NOT NULL,
	PRIMARY KEY (cittadino, famiglia),
	FOREIGN KEY (famiglia) REFERENCES famiglie(capo_famiglia),
	FOREIGN KEY (cittadino) REFERENCES cittadini(cf)
);

INSERT INTO cittadini VALUES ("1","Mario","Rossi","M","2024-1-1","nato in comune",null,"1","1","residente");
INSERT INTO cittadini VALUES ("2","Mario2","Rossi2","M","2024-1-2","nato in comune",null,"1","2","non residente");
INSERT INTO cittadini VALUES ("3","Mario3","Rossi3","M","2024-1-3","nato in altro comune","lecce",null,null,"residente");
INSERT INTO cittadini VALUES ("4","Mario4","Rossi4","M","2024-1-4","nato in altro comune","lecce",null,null,"residente");
INSERT INTO cittadini VALUES ("5","Mario5","Rossi5","M","2024-1-5","nato in altro comune","lecce",null,null,"residente");

INSERT INTO famiglie VALUES ("1","vi1","1","i1");
INSERT INTO famiglie VALUES ("2","vi2","2","i2");
INSERT INTO famiglie VALUES ("3","vi3","3","i3");

INSERT INTO membri VALUES ("4","1","figlio");
INSERT INTO membri VALUES ("5","2","zio");

-- Visualizzare cognome e nome dei residenti, e cognome e nome del capofamiglia;
SELECT c.cognome AS cognome_residente,
       c.nome AS nome_residente,
       fc.cognome AS cognome_capofamiglia,
       fc.nome AS nome_capofamiglia
FROM cittadini AS c
JOIN membri AS m ON c.cf = m.cittadino
JOIN famiglie AS f ON m.famiglia = f.capo_famiglia
JOIN cittadini AS fc ON f.capo_famiglia = fc.cf
WHERE c.residente = 'residente';


-- Visualizzare cognome, nome e comune di nascita dei cittadini capofamiglia residenti e il numero di componenti della famiglia;

-- Visualizzare il numero di cittadini e di cittadine nati nel comune, il numero di cittadini e di cittadine nati in altri comun
SELECT 
	COUNT(CASE WHEN c.tipo = "nato in comune" THEN 1 END) AS nati_nel_comune,
	COUNT(CASE WHEN c.tipo = "nato in altro comune" THEN 1 END) AS nati_in_altro_comune
FROM cittadini AS c;


-- SELECT * FROM CITTADINI;
-- SELECT * FROM FAMIGLIE;
-- SELECT * FROM MEMBRI;