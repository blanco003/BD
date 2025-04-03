DROP DATABASE IF EXISTS testateGiornalistiche_blanco;
CREATE DATABASE IF NOT EXISTS testateGiornalistiche_blanco;
USE testateGiornalistiche_blanco;

-- inseriamo redazioni prima di testate poiche non possiamo specificare il vincolo di integrita referenziale in testate se prima non esiste redazioni
CREATE TABLE redazioni(
    idRedazione char(4) PRIMARY KEY,
    nomeComitato varchar(10),
    citta varchar(8),
    indirizzoWeb text
);

CREATE TABLE testate(
    idTestata char(4) PRIMARY KEY,
    nome varchar(20),
    redazione char(4),
    CONSTRAINT chiave_esterna_testate FOREIGN KEY (redazione) REFERENCES redazioni(idRedazione)
);

CREATE TABLE redattori(
    idRedattori char(3) PRIMARY KEY,
    cognome varchar(10),
    nome varchar(8),
    via varchar(15),
    citta varchar(15),
    provincia varchar(2),
    CAP varchar(5),
    email text
);

CREATE TABLE redazRedat(
    idRedazione char(4),
    idRedattori char(3),
    PRIMARY KEY(idRedazione,idRedattori),
    FOREIGN KEY (idRedazione) REFERENCES redazioni(idRedazione),
    FOREIGN KEY (idRedattori) REFERENCES redattori(idRedattori)
);

CREATE TABLE categorie(
    nomeCategoria varchar(10) PRIMARY KEY,
    categoriaPadre varchar(10),
    CONSTRAINT chiave_esterna_categorie FOREIGN KEY (categoriaPadre) REFERENCES categorie(nomeCategoria)
);


CREATE TABLE inserzioni(
    codice varchar(6) PRIMARY KEY,
    testo text,
    categoria varchar(10),
    CONSTRAINT chiave_esterna_inserzioni FOREIGN KEY (categoria) REFERENCES categorie(nomeCategoria)
);

CREATE TABLE instest(
    idInserzione varchar(6),
    idTestata char(4),
    PRIMARY KEY(idInserzione,idTestata),
    CONSTRAINT FOREIGN KEY (idInserzione) REFERENCES inserzioni(codice),
    FOREIGN KEY (idTestata) REFERENCES testate(idTestata) 
);

CREATE TABLE aziende(
    idAzienda char(6) PRIMARY KEY,
    nomeAzienda varchar(40),
    referente varchar(40),
    telefono varchar(11),
    citta varchar(15),
    provincia char(2),
    CAP varchar(5),
    CapitaleSociale float,
    numero_civico varchar(5),
    anno_fondazione int
);

CREATE TABLE insaz(
    idAzienda varchar(6),
    idInserzione varchar(4),
    PRIMARY KEY(idAzienda,idInserzione),
    CONSTRAINT FOREIGN KEY (idAzienda) REFERENCES aziende(idAzienda),
    FOREIGN KEY (idInserzione) REFERENCES inserzioni(codice)     
);

CREATE TABLE privati(
    idPrivato char(3) PRIMARY KEY,
    cognome varchar(10),
    nome varchar(8),
    eta int,
    numero_civico varchar(10),
    via varchar(15),
    citta varchar(15),
    provincia char(2),
    CAP varchar(5),
    email text
);

CREATE TABLE inspriv(
    idPrivato char(3),
    idInserzione varchar(6),
    PRIMARY KEY (idPrivato,idInserzione),
    CONSTRAINT chiave_esterna_inspriv_privati FOREIGN KEY (idPrivato) REFERENCES privati(idPrivato),
    CONSTRAINT chiave_esterna_inspriv_inserzioni FOREIGN KEY (idInserzione) REFERENCES inserzioni(codice)
);

-- inserire nel database almeno tre testate di giornale
-- inseriamo prima delle testate le redazioni poichè esiste un vincolo di intergrità referenziale
INSERT INTO redazioni VALUES ("1234","Sole","Firenze","sole.it");
INSERT INTO redazioni VALUES ("2345","Republlica","Roma","republlica.it");
INSERT INTO redazioni VALUES ("3456","Sera","Milano","sera.it");

INSERT INTO testate VALUES ("1111","Il sole 24 ore","1234");
INSERT INTO testate VALUES ("2222","La repubblica","2345");
INSERT INTO testate VALUES ("3333","Corriere della sera","3456");

-- modificare la dimensione del nome e del cognome dei privati in testo di 30 caratteri utilizzando l'istruzione ALTER TABLE
ALTER TABLE privati 
MODIFY COLUMN nome varchar(30), 
MODIFY COLUMN cognome varchar(30);

-- creare la tabella città avente come attributi: città, provincia e CAP, in cui CAP è chiave primaria
CREATE TABLE citta(
    citta varchar(15),
    provincia char(2),
    CAP varchar(5) PRIMARY KEY
);

-- modificare le tabelle in cui è presente l'attributo città in modo che abbiano una chiave esterna alla tabella città al posto dei tre attributi separati
ALTER TABLE redattori
DROP COLUMN citta,
DROP COLUMN provincia,
ADD FOREIGN KEY (CAP) REFERENCES citta(CAP);

ALTER TABLE aziende
DROP COLUMN citta,
DROP COLUMN provincia,
ADD FOREIGN KEY (CAP) REFERENCES citta(CAP);

ALTER TABLE privati
DROP COLUMN citta,
DROP COLUMN provincia,
ADD FOREIGN KEY (CAP) REFERENCES citta(CAP);

-- inserire nel database tanti comitati di redazioni quante sono le testate di giornale inserite
-- è stato già fatto prima di inserire le testate in quanto esisteva già un vincolo di integrità referenziale

-- inserire nel database un numero di persone che compongono i comitati di redazione, tenendo conto che qualche redattore può far parte di più comitati
INSERT INTO citta VALUES("Milano","MI","70121");
INSERT INTO citta VALUES("Bari","BA","70125");
INSERT INTO citta VALUES("Firenze","FI","71342");
INSERT INTO citta VALUES("Roma","RM","00042");
INSERT INTO citta VALUES("Siena","SI","70222");

INSERT INTO redattori VALUES ("111","Rossi","Mario","Verde","70121","rossi.mario@gmail.com");
INSERT INTO redattori VALUES ("444","Abbate","Luigi","Resistenza","00042","abbate.luigi@gmail.com");
INSERT INTO redattori VALUES ("222","Gialli","Giuseppe","Maggio","70222","gialli.giuseppe.gmail.com");
INSERT INTO redattori VALUES ("333","Blui","Marco","Reggia","71342","blui.marco@gmail.com");

INSERT INTO redazRedat VALUES("1234","111");
INSERT INTO redazRedat VALUES("2345","222");
INSERT INTO redazRedat VALUES("2345","333");
INSERT INTO redazRedat VALUES("3456","444");


-- modificare la tabella categorie in modo che la chiave primaria sia idCategoria anziché nomeCategoria

/* prima di eliminare l'attributo nomeCategoria rimuoviamo i vincoli con esso,
 successivamente aggiungiamo il nuovo attributo come chiave primaria 
 e reinseriamo i vincoli di integrità */

ALTER TABLE inserzioni
DROP FOREIGN KEY chiave_esterna_inserzioni;

ALTER TABLE categorie
DROP FOREIGN KEY chiave_esterna_categorie;

ALTER TABLE categorie
DROP PRIMARY KEY;

ALTER TABLE categorie
ADD COLUMN idCategoria varchar(10) PRIMARY KEY;

ALTER TABLE categorie
ADD FOREIGN KEY (categoriaPadre) REFERENCES categorie(idCategoria);

ALTER TABLE inserzioni
ADD FOREIGN KEY (categoria) REFERENCES categorie(idCategoria);

-- inserire le categorie e ognuna con un diverso numero di sottocategorie (es. affitti e vendite sono sottocategorie di case)
INSERT INTO categorie (nomeCategoria,idCategoria) VALUES  ("case","1");
INSERT INTO categorie VALUES  ("affitti","1","2");
INSERT INTO categorie VALUES  ("vendite","1","3");

-- inserire nelle tabelle almeno 10 inserzioni di privati e 10 inserzioni di aziende
INSERT INTO privati VALUES ("111","Gialli","Lucia",25,"123","Cavour","70121","gialli.lucia@gmail.com");
INSERT INTO privati VALUES ("222","Neri","Marco",30,"45","Urbana","70125","neri.marco@gmail.com");
INSERT INTO privati VALUES ("333","Rossi","Luca",28,"89","Palermo","70222","rossi.luca@gmail.com");
INSERT INTO privati VALUES ("444","Verdi","Francesco",35,"10","Milazzo","70121","verdi.francesco@gmail.com");
INSERT INTO privati VALUES ("555","Bianchi","Antonio",40,"202","Catania","71342","bianchi.antonio@gmail.com");
INSERT INTO privati VALUES ("666","Blui","Marco",22,"303","Cesare","70121", "blui.marco@gmail.com");
INSERT INTO privati VALUES ("777","Ponti","Lucia",31,"22","Stefano","70222","ponti.lucia@gmail.com");
INSERT INTO privati VALUES ("888","Abbate","Maria",27,"15","Tiburtina","00042","abbate.maria@gmail.com");
INSERT INTO privati VALUES ("999","Morandi","Silvia",33,"60","Antonio","70125","morandi.silvia@gmail.com");
INSERT INTO privati VALUES ("100","Gentili","Arnold",29,"707","Montello","71342","gentili.arnold@gmail.com");


INSERT INTO inserzioni VALUES("1","testo1","1");
INSERT INTO inserzioni VALUES("2","testo2","2");
INSERT INTO inserzioni VALUES("3","testo3","2");
INSERT INTO inserzioni VALUES("4","testo4","3");
INSERT INTO inserzioni VALUES("5","testo5","1");
INSERT INTO inserzioni VALUES("6","testo6","1");
INSERT INTO inserzioni VALUES("7","testo7","3");
INSERT INTO inserzioni VALUES("8","testo8","2");
INSERT INTO inserzioni VALUES("9","testo9","2");
INSERT INTO inserzioni VALUES("10","testo10","1");

INSERT INTO inspriv VALUES("111","1");
INSERT INTO inspriv VALUES("222","2");
INSERT INTO inspriv VALUES("333","3");
INSERT INTO inspriv VALUES("444","4");
INSERT INTO inspriv VALUES("555","5");
INSERT INTO inspriv VALUES("666","6");
INSERT INTO inspriv VALUES("777","7");
INSERT INTO inspriv VALUES("888","8");
INSERT INTO inspriv VALUES("999","9");
INSERT INTO inspriv VALUES("100","10");

INSERT INTO aziende VALUES("111111","Barilla","Marco","3331234567","00042",123000,"4",2023);
INSERT INTO aziende VALUES("111112","Lamborghini","Luigi","3231238932","00042",999000,"56",1998);
INSERT INTO aziende VALUES("111113","Benetton","Stefano","3355562853","70121",15000,"663",1980);
INSERT INTO aziende VALUES("111114","Luxottica","Maria","0801231672","70222",1000000,"1",1940);
INSERT INTO aziende VALUES("111115","Enel","Giovanni","3131234567","00042",500000,"24",2005);
INSERT INTO aziende VALUES("111116","Pirelli","Dario","0801234504","71342",193000,"542",1994);
INSERT INTO aziende VALUES("111117","Unicredit","Giuseppe","3321234509","71342",20000000,"235",1947);
INSERT INTO aziende VALUES("111118","Versace","Mattia","3391234908","00042",420000,"15",1978);
INSERT INTO aziende VALUES("111119","Atlantia","Fernando","0801231237","70222",80000,"742",1965);
INSERT INTO aziende VALUES("111120","Gucci","Lorenzo","3231234847","70222",18100000,"632",2014);

INSERT INTO insaz VALUES("111111","1");
INSERT INTO insaz VALUES("111112","2");
INSERT INTO insaz VALUES("111113","3");
INSERT INTO insaz VALUES("111114","4");
INSERT INTO insaz VALUES("111115","5");
INSERT INTO insaz VALUES("111116","6");
INSERT INTO insaz VALUES("111117","7");
INSERT INTO insaz VALUES("111118","8");
INSERT INTO insaz VALUES("111119","9");
INSERT INTO insaz VALUES("111120","10");

INSERT INTO instest VALUES("1","2222");
INSERT INTO instest VALUES("2","1111");
INSERT INTO instest VALUES("3","3333");
INSERT INTO instest VALUES("4","3333");
INSERT INTO instest VALUES("5","1111");
INSERT INTO instest VALUES("6","2222");
INSERT INTO instest VALUES("7","2222");
INSERT INTO instest VALUES("8","3333");
INSERT INTO instest VALUES("9","1111");
INSERT INTO instest VALUES("10","1111");


/*
SELECT * FROM redazioni;
SELECT * FROM redattori;
SELECT * FROM citta;
SELECT * FROM categorie;
SELECT * FROM privati;
SELECT * FROM inserzioni;
SELECT * FROM inspriv;
SELECT * FROM aziende;
SELECT * FROM insaz;
*/

-- creare un vincolo di reazione alla tabella testate di tipo cascade;
ALTER TABLE testate
DROP FOREIGN KEY chiave_esterna_testate;

ALTER TABLE testate
ADD CONSTRAINT chiave_esterna_testate 
FOREIGN KEY (redazione) REFERENCES redazioni(idRedazione)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- creare un vincolo di reazione alla tabella inspriv in modo che se il codice di inserzioni viene modificato/cancellato, nella tabella inspriv idInserzione sia settato a NULL;
/*
ALTER TABLE inspriv
DROP FOREIGN KEY chiave_esterna_inspriv_inserzioni;

ALTER TABLE inspriv
ADD CONSTRAINT hiave_esterna_inspriv_inserzioni
FOREIGN KEY (idInserzione)
REFERENCES inserzioni(codice)
ON UPDATE SET NULL
ON DELETE SET NULL;

andrebbe fatto in questo modo, ma non è leggittimo farlo perchè 
idInserzione non può essere NULL in quanto chiave

*/
-- 6) visualizzare il nome di tutte le testate presenti nel database;
SELECT nome 
FROM testate;

-- 7) visualizzare l'elenco dei redattori presenti nel database, mostrando tutte le informazioni disponibili;
SELECT *
FROM redattori;

-- 8) visualizzare l'elenco dei redattori presenti nel database, mostrando cognome e nome;
SELECT cognome,nome
FROM redattori;

-- 9)visualizzare l'elenco dei redattori presenti nel database, mostrando cognome, nome ed e-mail;
SELECT cognome,nome,email
FROM redattori;

-- 10)visualizzare l'elenco dei redattori presenti nel database la cui e-mail inizia con la lettera a;
SELECT * 
FROM redattori
WHERE email LIKE "a%";

-- 11)visualizzare i redattori che hanno inserito un'email corretta (quelli in cui il campo e-mail contiene una chiocciola;
SELECT * 
FROM redattori
WHERE email LIKE "%@%";

-- 12)visualizzare i redattori che hanno inserito un'email sbagliata (quelli in cui il campo e-mail NON contiene una chiocciola;
SELECT * 
FROM redattori
WHERE email NOT LIKE "%@%";

-- 13) visualizzare il nome di comitato di tutte le redazioni presenti nel database, se presente anche l'indirizzo web;
SELECT  nomeComitato,indirizzoWeb
FROM redazioni;

-- 14) visualizzare il testo e il codice delle inserzioni della categoria 'casa', se questa categoria non è presente prenderne un'altra;
SELECT testo,codice
FROM inserzioni i JOIN categorie c ON i.categoria=c.idCategoria
WHERE c.nomeCategoria="case";

-- 15) visualizzare il codice e il testo di tutte le inserzioni che hanno al loro interno la parola 'casa';
SELECT codice,testo
FROM inserzioni
WHERE testo LIKE "%casa%";

-- 16) visualizzare il codice e il testo di tutte le inserzioni che hanno al loro interno la parola 'casa' e la sottostringa 'vend';
SELECT codice,testo
FROM inserzioni
WHERE testo LIKE "%casa%" AND testo LIKE "%vend%";

-- 17) visualizzare il codice e il testo di tutte le inserzioni che hanno al loro interno la sottostringa 'modic';
SELECT codice,testo
FROM inserzioni
WHERE testo LIKE "%modic%";

-- 18) visualizzare l'elenco dei privati presenti nel database;
SELECT *
FROM privati;

-- 19)visualizzare l'elenco dei privati provenienti dalla città con CAP: 70125 o 70126;
SELECT * 
FROM privati
WHERE CAP="70125" OR CAP="70126";

-- 20)visualizzare l'elenco delle aziende il cui telefono contiene le cifre: 556
SELECT *
FROM aziende
WHERE telefono LIKE "%556%";

-- 21) visualizzare il nome di tutte le aziende presenti nel database;
SELECT nomeAzienda
FROM aziende;

-- 22) visualizzare il nome di tutte le aziende presenti nel database aventi anno di fondazione precedente al 1980;
SELECT nomeAzienda
FROM aziende
WHERE anno_fondazione < 1980;

-- 23) visualizzare il nome di tutte le aziende presenti nel database aventi anno di fondazione successivo al 1998;
SELECT nomeAzienda
FROM aziende
WHERE anno_fondazione > 1998;

-- 24) visualizzare il nome di tutte le aziende presenti nel database aventi anno di fondazione compreso tra il 1980 e il 1998;
SELECT nomeAzienda
FROM aziende
WHERE anno_fondazione > 1980 AND anno_fondazione < 1998;

-- 25) visualizzare l'elenco dei privati presenti nel database, mostrando tutte le informazioni disponibili, evitando l'uso dell'asterisco;
SELECT idPrivato,cognome,nome,eta,numero_civico,via,CAP,email
FROM privati;

-- 26) visualizzare l'elenco dei privati presenti nel database che abitano in un numero civico superiore a 20, mostrando cognome e nome e numero civico;
SELECT cognome,nome,numero_civico
FROM privati
WHERE numero_civico>20;

-- 27) visualizzare l'elenco dei privati presenti nel database che abitano in un numero civico pari a 10 o a 15, mostrando cognome e nome e numero civico;
SELECT cognome,nome,numero_civico
FROM privati
WHERE numero_civico=10 OR numero_civico=15;

-- 28) visualizzare nome, cognome, via, numero civico e CAP dei privati il cui numero civico è compreso tra 15 e 30, visualizzare CAP come Codice_Avviamento_Postale;
SELECT cognome, nome, via, numero_civico, CAP AS Codice_Avviamento_Postale
FROM privati
WHERE numero_civico >15 AND numero_civico<30;

-- 29) visualizzare il nome e il capitale sociale delle aziende, visualizzare anche la metà del capitale sociale con il nome: Plafond_max_disponibile;
SELECT nomeAzienda,CapitaleSociale,(CapitaleSociale/2) AS Plafond_max_disponibile
FROM aziende;

-- 30) visualizzare le età e il nome dei privati che hanno un'età inferiore a 30;   
SELECT eta,nome
FROM privati
WHERE eta<30;

-- 31) visualizzare il nome di comitato di tutte le redazioni presenti nel database che hanno all'interno del nome una sottostringa costituita da tre lettere di cui ma lettera centrale non è importante: "m t";
SELECT nomeComitato
FROM redazioni
WHERE nomeComitato LIKE "%m_t%";

-- 32) creare una tabella PrivatiGiovani con le stesse caratteristiche della tabella Privati e senza vincoli di integrità interrelazionali;
CREATE TABLE PrivatiGiovani AS SELECT * FROM Privati WHERE FALSE;  -- crea la tabella PrivatiGiovani con gli stessi attributi di Privati ma senza vincoli, WHERE FALSE serve a non far copiare anche i valori gia inseriti in privati

-- 33) inserire nella tabella PrivatiGiovani tutti i privati contenuti nella tabella Privati che hanno età inferiore a 30;
INSERT INTO PrivatiGiovani SELECT * FROM Privati WHERE eta<30;

-- 34) Rinominare il cognome dei PrivatiGiovani il cui cognome inizia con la lettera "P" con la parola "Rossi";
UPDATE PrivatiGiovani SET cognome="Rossi" WHERE cognome LIKE "P%";

-- 35) Rinominare il nome dei PrivatiGiovani il cui nome contiene la sottostringa "aur" con la parola "Arnold";
UPDATE PrivatiGiovani SET nome="Arnold" WHERE nome LIKE "%aur%";

-- 36) visualizzare cognome, nome ed età dei privati il cui nome è Arnold, in particolare visualizzare il campo nome come "Nick";
SELECT nome AS Nick,cognome,eta
FROM privati
WHERE nome="Arnold";

-- 37) visualizzare cognome, nome ed età dei privati il cui cognome è "Rossi", in particolare visualizzare un unico campo cognomenome come "Pilota";
SELECT cognome,nome,eta, concat(cognome,nome) AS Pilota
FROM privati
WHERE cognome = "Rossi";
 
-- 38) visualizzare l'elenco delle aziende il cui telefono inizia per 080.
SELECT *
FROM aziende
WHERE telefono LIKE "080%";

-- 39) visualizzare il nome e il numero civico di tutte le aziende presenti nel database che hanno o potrebbero avere un numero civico superiore a 15;
SELECT nomeAzienda,numero_civico
FROM aziende
WHERE numero_civico>15 OR numero_civico IS NULL;

-- 40) visualizzare il nome e l'anno di fondazione di tutte le aziende presenti nel database che hanno o potrebbero avere anno di fondazione precedente al 1980;
SELECT nomeAzienda,anno_fondazione
FROM aziende
WHERE anno_fondazione<1980 OR anno_fondazione IS NULL;

-- 41) visualizzare il nome di tutte le aziende presenti nel database che hanno o potrebbero avere anno di fondazione compreso tra il 1980 e il 1998;
SELECT nomeAzienda,anno_fondazione
FROM aziende
WHERE (anno_fondazione>1980 AND anno_fondazione<1998) OR anno_fondazione IS NULL;

-- 42) visualizzare codice, testo e categoria delle inserzioni presenti nel database;
SELECT codice,testo,categoria
FROM inserzioni;

-- 43) visualizzare l'elenco dei codici di inserzioni e dei codici delle aziende (tabella insaz);
SELECT idAzienda,idInserzione
FROM insaz;

-- 44) visualizzare per ogni codice di inserzione presente in insaz nome azienda, referente e telefono utilizzando il prodotto cartesiano;
SELECT idInserzione,nomeAzienda,referente,telefono
FROM inserzioni,insaz,aziende;
    
-- 45) visualizzare, utilizzando il prodotto cartesiano, codice, testo e categoria delle inserzioni con relativi nome azienda, referente, telefono, utilizzando le tabelle aziende, insaz e inserzioni;
SELECT codice,testo,categoria,nomeAzienda,referente,telefono
FROM insaz,aziende,inserzioni;

-- 46) visualizzare l'interrogazione precedente effettuando le seguenti ridenominazioni sulle relative tabelle: aziende in elenco_aziende, insaz in IA, inserzioni in pubblicazioni;
SELECT pubblicazioni.codice,pubblicazioni.testo,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
FROM insaz AS IA,aziende AS elenco_aziende,inserzioni AS pubblicazioni;

-- 47) visualizzare l'interrogazione precedente ridenominando i seguenti attributi: codice in codice_articolo, testo in descrizione;
SELECT pubblicazioni.codice AS codice_articolo,pubblicazioni.testo AS descrizione,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
FROM insaz AS IA,aziende AS elenco_aziende,inserzioni AS pubblicazioni;

-- 48) della query precedente visualizzare solo le aziende che hanno un capitale sociale superiore 18000000;
SELECT pubblicazioni.codice AS codice_articolo,pubblicazioni.testo AS descrizione,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
FROM insaz AS IA,aziende AS elenco_aziende,inserzioni AS pubblicazioni
WHERE elenco_aziende.CapitaleSociale > 18000000;

-- 49) visualizzare l'elenco dei nomi dei privati presenti nel database;
SELECT nome
FROM privati;

-- 50) visualizzare l'elenco dei nomi diversi presenti nel database;
SELECT DISTINCT nome
FROM privati;

-- 51) ripetere le interrogazioni dalla numero 45 alla numero 48 utilizzando il NATURAL JOIN (Join naturale);

    -- dobbiamo prima effettuare una selezione per far si che i vincoli di integrità vengano rispettati tra codice in inserzioni e idInserzioni in insaz, poichè il NATURAL JOIN richiede che le chiavi abbiano nome comune

        -- 45) 
            SELECT ins.idInserzione,ins.testo,ins.categoria,aziende.nomeAzienda,aziende.referente,aziende.telefono
            FROM aziende NATURAL JOIN insaz NATURAL JOIN  (
                    SELECT codice AS idInserzione,testo,categoria FROM inserzioni
            ) AS ins;

         -- 46)
            SELECT pubblicazioni.idInserzione,pubblicazioni.testo,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
            FROM aziende AS elenco_aziende NATURAL JOIN insaz AS IA NATURAL JOIN  (
                    SELECT codice AS idInserzione,testo,categoria FROM inserzioni
            ) AS pubblicazioni;
         
        -- 47)
            SELECT pubblicazioni.idInserzione AS codice_articolo,pubblicazioni.testo AS descrizione,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
            FROM aziende AS elenco_aziende NATURAL JOIN insaz AS IA NATURAL JOIN  (
                    SELECT codice AS idInserzione,testo,categoria FROM inserzioni
            ) AS pubblicazioni;

        -- 48)
            SELECT pubblicazioni.idInserzione AS codice_articolo,pubblicazioni.testo AS descrizione,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
            FROM aziende AS elenco_aziende NATURAL JOIN insaz AS IA NATURAL JOIN  (
                    SELECT codice AS idInserzione,testo,categoria FROM inserzioni
            ) AS pubblicazioni
            WHERE elenco_aziende.CapitaleSociale > 18000000;

-- 52) ripetere le interrogazioni dalla numero 45 alla numero 48 utilizzando il Theta JOIN (Join esplicito);
        -- 45) 
            SELECT codice,testo,categoria,nomeAzienda,referente,telefono
            FROM aziende JOIN insaz ON aziende.idAzienda=insaz.idAzienda JOIN inserzioni ON insaz.idInserzione=inserzioni.codice;

        -- 46)
            SELECT pubblicazioni.codice,pubblicazioni.testo,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
            FROM aziende AS elenco_aziende JOIN insaz ON elenco_aziende.idAzienda=insaz.idAzienda 
            JOIN inserzioni AS pubblicazioni ON insaz.idInserzione=pubblicazioni.codice;

        -- 47)
            SELECT pubblicazioni.codice AS codice_articolo,pubblicazioni.testo AS descrizione,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
            FROM aziende AS elenco_aziende JOIN insaz ON elenco_aziende.idAzienda=insaz.idAzienda
            JOIN inserzioni AS pubblicazioni ON insaz.idInserzione=pubblicazioni.codice;
            
        -- 48)
            SELECT pubblicazioni.codice AS codice_articolo,pubblicazioni.testo AS descrizione,pubblicazioni.categoria,elenco_aziende.nomeAzienda,elenco_aziende.referente,elenco_aziende.telefono
            FROM aziende AS elenco_aziende JOIN insaz ON  elenco_aziende.idAzienda=insaz.idAzienda
            JOIN inserzioni AS pubblicazioni ON insaz.idInserzione=pubblicazioni.codice 
            WHERE elenco_aziende.CapitaleSociale > 18000000;

-- 53) visualizzare l'interrogazione al punto 45 ordinata per numeri di telefono;
SELECT codice,testo,categoria,nomeAzienda,referente,telefono
FROM aziende JOIN insaz ON aziende.idAzienda=insaz.idAzienda JOIN inserzioni ON insaz.idInserzione=inserzioni.codice
ORDER BY telefono;

-- 54) visualizzare l'interrogazione al punto 45 ordinata per numeri di telefono decrescenti;
SELECT codice,testo,categoria,nomeAzienda,referente,telefono
FROM aziende JOIN insaz ON aziende.idAzienda=insaz.idAzienda JOIN inserzioni ON insaz.idInserzione=inserzioni.codice
ORDER BY telefono DESC;

-- 55) visualizzare l'elenco delle aziende, indicando il CAP della città in cui hanno sede;
SELECT nomeAzienda,CAP
FROM aziende;

-- 56) visualizzare l'elenco delle aziende, e per ognuna indicare il nome della città in cui hanno sede, il CAP e la provincia;
SELECT nomeAzienda,c.CAP,citta,provincia
FROM aziende a,citta c
WHERE a.CAP = c.CAP;

-- 57) visualizzare l'elenco dei privati e per ognuno il CAP della città di residenza;
SELECT *
FROM privati;

-- 58) visualizzare l'elenco dei privati e per ognuno il CAP, il nome e la provincia della città in cui risiedono;
SELECT idPrivato,cognome,nome,eta,numero_civico,via,email,c.CAP,citta,provincia
FROM privati    p,citta c
WHERE p.CAP = c.CAP;

-- 59) visualizzare l'elenco delle città e per ogni città, nome dell'azienda che ha sede nella città, nome e cognome dei privati che risiedono nella città (fare attenzione a non visualizzare due volte le stesse informazioni);
SELECT DISTINCT c.CAP,c.citta,c.provincia, a.nomeAzienda, p.nome, p .cognome
FROM citta AS c LEFT JOIN aziende AS a ON c.CAP = a.CAP LEFT JOIN privati AS p ON c.CAP = p.CAP;

-- 60) visualizzare i privati che hanno un cognome iniziante con la lettera P oppure con la lettera A, indicando i codici delle inserzioni che questi hanno fatto;
SELECT p.nome,p.cognome,i.codice
FROM privati AS p JOIN inspriv AS ins ON p.Idprivato=ins.Idprivato JOIN inserzioni AS i ON ins.idInserzione=i.codice
WHERE p.cognome LIKE "P%" OR p.cognome LIKE "A%";

-- 61) ripetere il punto precedente visualizzando anche la categoria dell'inserzione;
SELECT p.nome,p.cognome,i.codice,c.nomeCategoria
FROM privati AS p JOIN inspriv AS ins ON p.Idprivato=ins.Idprivato 
JOIN inserzioni AS i ON ins.idInserzione=i.codice 
JOIN categorie AS c ON i.categoria=c.idCategoria
WHERE p.cognome LIKE "P%" OR p.cognome LIKE "A%";

-- 62) ripetere il punto precedente visualizzando anche il testo delle inserzioni;
SELECT p.nome,p.cognome,i.codice,i.testo,c.nomeCategoria
FROM privati AS p JOIN inspriv AS ins ON p.Idprivato=ins.Idprivato 
JOIN inserzioni AS i ON ins.idInserzione=i.codice 
JOIN categorie AS c ON i.categoria=c.idCategoria
WHERE p.cognome LIKE "P%" OR p.cognome LIKE "A%";

-- 63) visualizzare il nome dei privati e il nome delle testate in cui i privati hanno pubblicato delle inserzioni;
SELECT p.nome, t.nome
FROM privati AS p JOIN inspriv AS insp ON p.idPrivato = insp.idPrivato JOIN instest AS inst ON insp.idInserzione = inst.idInserzione JOIN testate AS t ON inst.idTestata = t.idTestata;

-- 64) visualizzare il nome dei privati, il nome delle testate in cui i privati hanno pubblicato delle inserzioni, i nomi dei comitati di redazione che dirigono le testate visualizzate;
SELECT p.nome AS nome_privato, t.nome AS nome_testata, r.nomeComitato AS nome_comitato
FROM privati AS p JOIN inspriv AS ip ON p.idPrivato = ip.idPrivato
JOIN inserzioni AS i ON ip.idInserzione = i.codice
JOIN instest AS it ON i.codice = it.idInserzione
JOIN testate AS t ON it.idTestata = t.idTestata
JOIN redazioni AS r ON t.redazione = r.idRedazione;

-- 65) visualizzare l'interrogazione al punto precedente indicando anche i nomi di tutti i redattori presenti nelle testate giornalistiche;
SELECT p.nome AS nome_privato, t.nome AS nome_testata, r.nomeComitato AS nome_comitato,re.nome AS nome_redattore
FROM privati AS p JOIN inspriv AS ip ON p.idPrivato = ip.idPrivato
JOIN inserzioni AS i ON ip.idInserzione = i.codice
JOIN instest AS it ON i.codice = it.idInserzione
JOIN testate AS t ON it.idTestata = t.idTestata
JOIN redazioni AS r ON t.redazione = r.idRedazione
JOIN redazredat AS rr ON r.idRedazione = rr.idRedazione
JOIN redattori AS re ON rr.idRedattori = re.idRedattori;

-- 66) effettuare l'interrogazione al punto precedente visualizzando solo i privati il cui cognome inizia con la lettera p oppure con la lettera a.
SELECT p.nome AS nome_privato, t.nome AS nome_testata, r.nomeComitato AS nome_comitato,re.nome AS nome_redattore
FROM privati AS p JOIN inspriv AS ip ON p.idPrivato = ip.idPrivato
JOIN inserzioni AS i ON ip.idInserzione = i.codice
JOIN instest AS it ON i.codice = it.idInserzione
JOIN testate AS t ON it.idTestata = t.idTestata
JOIN redazioni AS r ON t.redazione = r.idRedazione
JOIN redazredat AS rr ON r.idRedazione = rr.idRedazione
JOIN redattori AS re ON rr.idRedattori = re.idRedattori
WHERE p.cognome LIKE "p%" OR p.cognome LIKE "a%";

-- 67) Visualizzare il testo delle inserzioni presenti nelle categorie principali (quelle che non hanno categoria padre);
SELECT testo
FROM inserzioni i,categorie c
WHERE i.categoria=c.idCategoria AND c.categoriaPadre IS NULL;

-- 68) Visualizzare il numero delle inserzioni presenti nelle categorie principali;
SELECT count(codice) AS numero_inserzioni_categorie_principali
FROM inserzioni,categorie 
WHERE categoria=idCategoria AND categoriaPadre IS NULL;

-- 69) Modificare lo script relativo ad insAz in modo da aggiungere l'attributo costo nella tabella insAz;
ALTER TABLE insaz
ADD COLUMN costo float;

-- 70) Inserire il costo delle inserzioni nella tabella insAz, variabile tra 30 e 50 euro;
ALTER TABLE insaz
ADD CONSTRAINT vincolo_costo CHECK (costo > 30 AND costo < 50);

UPDATE insaz SET costo=31 WHERE idAzienda="111111";
UPDATE insaz SET costo=32 WHERE idAzienda="111112";
UPDATE insaz SET costo=44 WHERE idAzienda="111113";
UPDATE insaz SET costo=31 WHERE idAzienda="111114";
UPDATE insaz SET costo=47 WHERE idAzienda="111115";
UPDATE insaz SET costo=48 WHERE idAzienda="111116";
UPDATE insaz SET costo=40 WHERE idAzienda="111117";
UPDATE insaz SET costo=31 WHERE idAzienda="111118";
UPDATE insaz SET costo=39 WHERE idAzienda="111119";
UPDATE insaz SET costo=46 WHERE idAzienda="111120";

-- 71) Visualizzare la spesa totale sostenuta dall'azienda con codice 'COM000' per pubblicare le inserzioni;
SELECT SUM(costo)
FROM aziende AS a, insaz AS i
WHERE a.idAzienda=i.idAzienda AND a.idAzienda="COM000";

-- 72) Visualizzare tutte le informazioni sulle inserzioni pubblicate;
SELECT * 
FROM inserzioni;

-- 73) Visualizzare il numero totale delle inserzioni pubblicate;
SELECT count(codice) AS numero_inserzioni_pubblicate
FROM inserzioni;

-- 74) Visualizzare le inserzioni che hanno all'interno del testo la stringa 'affa';
SELECT * 
FROM inserzioni
WHERE testo LIKE "%affa%";

-- 75) Visualizzare il numero di inserzioni che hanno all'interno del testo la stringa 'affa';
SELECT count(codice) 
FROM inserzioni
WHERE testo LIKE "%affa%";

-- 76) Visualizzare codice e costo delle inserzioni totali (utilizzare l'operatore UNION tra tabella insAz e insPriv);

  -- essendo che l'operatore UNION richiede che i campi delle tabelle su cui è usato coincidano, poiche costo è presente solo in insaz e non in inpriv
  -- nella relativa ad inspriv selezioniamo in output un campo temporareneo costo anche se avrà valori null
SELECT idInserzione, costo
FROM insAz

UNION

SELECT idInserzione,  NULL AS costo
FROM insPriv;

-- 77) Visualizzare il numero delle inserzioni totali (utilizzare l'operatore UNION tra tabella insAz e insPriv);
SELECT count(idInserzione) AS numero_insezioni_totali
FROM(
    SELECT idInserzione FROM inspriv
    UNION 
    SELECT idInserzione FROM insaz
) AS tabella_insezioni_unione;

-- 78) Visualizzare il numero di inserzioni di privati e il numero di inserzioni di aziende;
SELECT count(idPrivato) AS numero_insezioni_privati
FROM inspriv;

SELECT count(idAzienda) AS numero_insezioni_aziende
FROM insaz;

-- 79) Mostrare quante inserzioni ci sono per ogni categoria.
SELECT c.nomeCategoria,count(i.codice)
FROM inserzioni AS i JOIN categorie as c ON i.categoria=c.idCategoria
GROUP BY c.idCategoria;

-- 80) Visualizzare le inserzioni che appartengono a più di una categoria.
    -- ogni inserzione può appartenere ad una sola categoria per come è stato impostato il db, dunque non ci sara mai una inserzione che appartiene a piu di una categoria
 
-- 81) Visualizzare il numero di inserzioni presenti in ciascuna categoria;
SELECT c.nomeCategoria,count(i.codice)
FROM inserzioni AS i JOIN categorie as c ON i.categoria=c.idCategoria
GROUP BY c.idCategoria;

-- 82) Visualizzare il numero di inserzioni pubblicate per ogni testata (insTest collega le inserzioni alle testate);
SELECT t.nome,count(ins.idInserzione)
FROM testate AS t JOIN instest AS ins ON t.idTestata=ins.idTestata
GROUP BY t.nome;

-- 83) Visualizzare in quante testate è presente ogni inserzione
SELECT i.codice,count(ins.idInserzione)
FROM inserzioni AS i JOIN instest AS ins ON i.codice=ins.idInserzione
GROUP BY i.codice;


-- 84) Visualizzare le inserzioni di aziende che costano meno di 35;
SELECT i.codice,i.testo,i.categoria
FROM inserzioni AS i JOIN insaz as ins ON i.codice=ins.idInserzione
WHERE costo<35;

-- 85) Visualizzare il numero di inserzioni di aziende che costano meno di 35;
SELECT count(idInserzione)
FROM insaz
WHERE costo<35;

-- 86) Quanti sono i privati presenti in ogni citta', escludendo Putignano?
SELECT count(idPrivato),CAP
FROM privati
GROUP BY CAP;

-- escludendo Putignano
SELECT count(p.idPrivato),c.CAP
FROM privati AS p JOIN citta AS c ON p.CAP = c.CAP
WHERE c.citta <> "Putignano"
GROUP BY p.CAP;


-- 87) Visualizzare i privati di Bari ordinati per nome;
SELECT *
FROM privati p, citta c
WHERE p.CAP=c.CAP AND c.citta="Bari"
ORDER BY p.nome;

-- 88) Visualizzare l'età media dei privati raggruppati per nome;
SELECT nome,AVG(eta)
FROM privati
GROUP BY nome;

-- 89) Visualizzare nome ed età del privato con età maggiore;
SELECT nome,eta
FROM privati
WHERE eta = (
                SELECT MAX(eta)
                FROM privati
);

-- 90) Ordinare le inserzioni delle aziende (insAz) per costi crescenti e, a parità di costo, per codici decrescenti;
SELECT *
FROM insaz
ORDER BY costo,idInserzione DESC;

-- 91) Ordinare le inserzioni delle aziende (insAz) per costi decrescenti e, a parità di costo, per codici decrescenti;
SELECT *
FROM insaz
ORDER BY costo DESC,idInserzione DESC;

-- 92) Visualizzare per ciascuna inserzione la sua descrizione;
SELECT codice,testo
FROM inserzioni;

-- 93) Visualizzare per ciascuna inserzione il codice dell'azienda che l'ha pubblicata;
SELECT i.codice,i.testo,ins.idAzienda
FROM inserzioni AS i JOIN insAz AS ins ON i.codice=ins.idInserzione;

-- 94) Visualizzare per ciascuna inserzione il codice dell'azienda che l'ha pubblicata e il nome del referente;
SELECT i.codice,i.testo,ins.idAzienda,a.referente
FROM inserzioni AS i JOIN insAz AS ins ON i.codice=ins.idInserzione 
JOIN aziende AS a ON ins.idAzienda=a.idAzienda;

-- 95) Visualizzare per ciascuna inserzione il codice dell'azienda che l'ha pubblicata, il nome e il telefono del referente e la città dell'azienda;
SELECT i.codice,i.testo,ins.idAzienda,a.referente,a.telefono,c.citta
FROM inserzioni AS i JOIN insAz AS ins ON i.codice=ins.idInserzione 
JOIN aziende AS a ON ins.idAzienda=a.idAzienda 
JOIN citta AS c ON a.CAP=c.CAP;

-- 96) Visualizzare per ciascuna inserzione il codice del privato che l'ha pubblicata;
SELECT i.codice,i.testo,ins.idPrivato
FROM inserzioni AS i JOIN inspriv AS ins ON i.codice=ins.idInserzione;

-- 97) Visualizzare per ciascuna inserzione il codice e il nome del privato che l'ha pubblicata;
SELECT i.codice,i.testo,ins.idPrivato,p.nome
FROM inserzioni AS i JOIN inspriv AS ins ON i.codice=ins.idInserzione 
JOIN privati AS p ON ins.idPrivato=p.idPrivato;

-- 98) Visualizzare il numero di inserzioni delle aziende che hanno pubblicato nella testata con numero di inserzioni maggiore, mostrando anche il nome della testata.
SELECT t.nome AS testata_con_max_inserzioni, count(insaz.idAzienda) AS numero_inserzioni
FROM testate AS t JOIN instest AS ins ON t.idTestata=ins.idTestata 
JOIN inserzioni AS i ON ins.idInserzione=i.codice 
JOIN insaz ON i.codice = insaz.idInserzione
GROUP BY t.nome
HAVING count(ins.idInserzione) = ( -- trova la testata con numero maggiore di inserzioni fatte
                               SELECT max(numero_inserzioni)
                               FROM (
                                      SELECT count(idInserzione) AS numero_inserzioni
                                      FROM instest
                                      GROUP BY idTestata
                             ) AS testate_conteggiate
);