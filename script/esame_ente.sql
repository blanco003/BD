DROP DATABASE IF EXISTS ENTE_BlancoLorenzo;
CREATE DATABASE IF NOT EXISTS ENTE_BlancoLorenzo;
USE ENTE_BlancoLorenzo;

CREATE TABLE livelli(
    cod_livello char(1) PRIMARY KEY,
    stipendio int
);

CREATE TABLE impiegati(
    matricola char(4) PRIMARY KEY,
    nome varchar(15) NOT NULL,
    cognome varchar(15) NOT NULL,
    cod_livello char(1),
    CONSTRAINT FOREIGN KEY (cod_livello) REFERENCES livelli(cod_livello)
);

CREATE TABLE manager(
    id_manager char(4) PRIMARY KEY,
    impiegato char(4),
    CONSTRAINT FOREIGN KEY (impiegato) REFERENCES impiegati(matricola)
);

CREATE TABLE progetti(
    nome varchar(20) PRIMARY KEY,
    budget int,
    tema varchar(100),    
    descrizione varchar(100),
    cod_manager char(4),
    CONSTRAINT FOREIGN KEY (cod_manager) REFERENCES manager(id_manager)

);

CREATE TABLE partecipazioni(
    impiegato char(4),
    progetto varchar(20),
    inizio date,
    PRIMARY KEY(impiegato,progetto), 
    CONSTRAINT FOREIGN KEY (impiegato) REFERENCES impiegati(matricola),
    FOREIGN KEY (progetto) REFERENCES progetti(nome) 	
);

CREATE TABLE partecipazioni_passate(
    impiegato char(4),
    progetto varchar(20),
    inizio date,
    fine date,
    PRIMARY KEY(impiegato,progetto), 
    CONSTRAINT FOREIGN KEY (impiegato) REFERENCES impiegati(matricola),
    FOREIGN KEY (progetto) REFERENCES progetti(nome) 	
);


INSERT INTO livelli VALUES ("1",10000);
INSERT INTO livelli VALUES ("2",20000);
INSERT INTO livelli VALUES ("3",30000);

INSERT INTO impiegati VALUES ("1111","Mario","Rossi",1);
INSERT INTO impiegati VALUES ("1112","Giuseppe","Verdi",2);
INSERT INTO impiegati VALUES ("1113","Marco","Bianchi",3);
INSERT INTO impiegati VALUES ("1114","Antonio","Verdi",1);

INSERT INTO manager VALUES ("0001","1111");
INSERT INTO manager VALUES ("0002","1112");

INSERT INTO progetti VALUES ("Esaminando",10000,"gioco","aaaa","0001");
INSERT INTO progetti VALUES ("Prog",312334,"sito","aaasdfsdfsa","0002");
INSERT INTO progetti VALUES ("Test",43100,"app","aaasdasdaa","0002");


INSERT INTO partecipazioni VALUES ("1114","Prog","2020-1-1");
INSERT INTO partecipazioni VALUES ("1113","Prog","2010-3-4");


INSERT INTO partecipazioni_passate VALUES ("1111","Esaminando","2019-1-1","2021-1-1");
INSERT INTO partecipazioni_passate VALUES ("1111","Test","2019-1-1","2021-1-1");
INSERT INTO partecipazioni_passate VALUES ("1112","Esaminando","2019-1-1","2021-1-1");


-- 1) Visualizzare matricola e cognome degli impiegati che hanno partecipato al progetto ‘Esaminando’, attivo dal 2019 al 2021.
SELECT i.matricola,i.cognome
FROM impiegati AS i JOIN partecipazioni_passate AS pp ON i.matricola = pp.impiegato JOIN progetti AS p ON pp.progetto = p.nome
WHERE p.nome = "Esaminando" AND pp.inizio = "2019-1-1" AND pp.fine = "2021-1-1";

-- 2) Visualizzare matricola, cognome, nome, livello e stipendio di tutti gli impiegati
SELECT *
FROM impiegati;

-- 3) Visualizzare l’elenco di progetti a cui Mario Rossi ha partecipato, indicando altresì il budget dei singoli progetti. È di interesse
-- sapere anche la somma totale dei budget di progetti a cui Mario Rossi ha partecipato.

SELECT p.nome,p.budget
FROM impiegati AS i JOIN partecipazioni_passate AS pp ON i.matricola = pp.impiegato JOIN progetti AS p ON pp.progetto = p.nome
WHERE i.nome = "Mario" AND i.cognome = "Rossi"
GROUP BY p.nome;
