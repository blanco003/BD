DROP DATABASE IF EXISTS blanco_ZOO;
CREATE DATABASE IF NOT EXISTS blanco_ZOO;
USE blanco_ZOO;

CREATE TABLE specie(
	id_specie varchar(10) PRIMARY KEY,
	nome varchar(20) NOT NULL
);


CREATE TABLE animali(
	id_animale varchar(5) PRIMARY KEY,
        eta integer NOT NULL,
        nome varchar(15),
	specie varchar(10) NOT NULL,
	CONSTRAINT FOREIGN KEY (specie) REFERENCES specie(id_specie)
);


CREATE TABLE settori(
	id_settore varchar(5) PRIMARY KEY,
	tipo varchar(15) NOT NULL,
	specie varchar(10) NOT NULL,
	continente varchar(15),
	espansione varchar(20),
	temperatura_acqua double,
	CONSTRAINT FOREIGN KEY (specie) REFERENCES specie(id_specie)
);

INSERT INTO specie VALUES ("1","giraffa");
INSERT INTO specie VALUES ("2","zebre");
INSERT INTO specie VALUES ("3","canguri");
INSERT INTO specie VALUES ("4","koala");
INSERT INTO specie VALUES ("5","squalo");
INSERT INTO specie VALUES ("6","calamari");

INSERT INTO animali VALUES ("11",12,"giraffa1","1");
INSERT INTO animali VALUES ("12",15,"giraffa2","1");
INSERT INTO animali VALUES ("13",22,"giraffa3","1");
INSERT INTO animali VALUES ("14",24,"giraffa4","1");

INSERT INTO animali VALUES ("15",24,"zebra1","2");
INSERT INTO animali VALUES ("16",24,"zebra2","2");
INSERT INTO animali VALUES ("17",26,"zebra3","2");
INSERT INTO animali VALUES ("18",25,"zebra4","2");

INSERT INTO animali VALUES ("19",1,"canguri1","3");
INSERT INTO animali VALUES ("20",5,"canguri2","3");
INSERT INTO animali VALUES ("21",10,"canguri3","3");
INSERT INTO animali VALUES ("22",12,"canguri4","3");

INSERT INTO animali VALUES ("23",1,"koala1","4");
INSERT INTO animali VALUES ("24",7,"koala2","4");
INSERT INTO animali VALUES ("25",9,"koala3","4");
INSERT INTO animali VALUES ("26",12,"koala4","4");
INSERT INTO animali VALUES ("27",15,"koala5","4");

INSERT INTO animali VALUES ("28",18,"squalo1","5");
INSERT INTO animali VALUES ("29",23,"squalo1","5");
INSERT INTO animali VALUES ("30",42,"squalo1","5");

INSERT INTO animali VALUES ("31",2,"calamari1","6");
INSERT INTO animali VALUES ("32",3,"calamari","6");
INSERT INTO animali VALUES ("33",8,"calamari","6");
INSERT INTO animali VALUES ("34",12,"calamari","6");

INSERT INTO settori VALUES ("11","Terra","1","AfricaS","20",NULL);
INSERT INTO settori VALUES ("12","Terra","1","AfricaS","20",NULL);
INSERT INTO settori VALUES ("13","Terra","1","AfricaS","20",NULL);
INSERT INTO settori VALUES ("14","Terra","1","AfricaS","20",NULL);

INSERT INTO settori VALUES ("15","Terra","2","AfricaN","20",NULL);
INSERT INTO settori VALUES ("16","Terra","2","AfricaN","20",NULL);
INSERT INTO settori VALUES ("17","Terra","2","AfricaN","20",NULL);
INSERT INTO settori VALUES ("18","Terra","2","AfricaN","20",NULL);

INSERT INTO settori VALUES ("19","Terra","3","AfricaE","20",NULL);
INSERT INTO settori VALUES ("20","Terra","3","AfricaE","20",NULL);
INSERT INTO settori VALUES ("21","Terra","3","AfricaE","20",NULL);
INSERT INTO settori VALUES ("22","Terra","3","AfricaE","20",NULL);

INSERT INTO settori VALUES ("23","Terra","4","AfricaW","20",NULL);
INSERT INTO settori VALUES ("24","Terra","4","AfricaW","20",NULL);
INSERT INTO settori VALUES ("25","Terra","4","AfricaW","20",NULL);
INSERT INTO settori VALUES ("26","Terra","4","AfricaW","20",NULL);
INSERT INTO settori VALUES ("27","Terra","4","AfricaW","20",NULL);

INSERT INTO settori VALUES ("28","Acquatico","5",NULL,NULL,"40");
INSERT INTO settori VALUES ("29","Acquatico","5",NULL,NULL,"40");
INSERT INTO settori VALUES ("30","Acquatico","5",NULL,NULL,"40");


INSERT INTO settori VALUES ("31","Acquatico","6",NULL,NULL,"41");
INSERT INTO settori VALUES ("32","Acquatico","6",NULL,NULL,"41");
INSERT INTO settori VALUES ("33","Acquatico","6",NULL,NULL,"41");
INSERT INTO settori VALUES ("34","Acquatico","6",NULL,NULL,"41");


-- 1) l’età media degli animali dello zoo, suddivisa per settore

SELECT sett.id_settore,avg(a.eta)
FROM animali AS a JOIN specie AS s ON a.specie = s.id_specie JOIN settori AS sett ON sett.specie = s.id_specie
GROUP BY (sett.id_settore);

-- 2) il numero totale di animali presenti nello zoo.

SELECT count(id_animale)
FROM animali;

-- 3) codice e nome degli animali che hanno tra 10 e 20 mesi e che siano posizionati in un settore acquatico

SELECT DISTINCT a.id_animale,a.nome,a.eta
FROM animali AS a JOIN specie AS s ON a.specie = s.id_specie JOIN settori AS sett ON sett.specie = s.id_specie
WHERE sett.tipo ="Acquatico" AND (a.eta > 10 AND a.eta <20);
