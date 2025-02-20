CREATE SEQUENCE utilizator_seq START WITH 1 INCREMENT BY 1; 
CREATE SEQUENCE galerie_seq START WITH 1 INCREMENT BY 1; 
CREATE SEQUENCE event_seq START WITH 1 INCREMENT BY 1; 
CREATE SEQUENCE exponat_seq START WITH 1 INCREMENT BY 1; 
CREATE SEQUENCE bilet_seq START WITH 1 INCREMENT BY 1; 
CREATE SEQUENCE angajat_seq START WITH 1 INCREMENT BY 1; 
CREATE SEQUENCE orar_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE Utilizator ( 
utilizator_id INT DEFAULT utilizator_seq.NEXTVAL PRIMARY KEY,
nume VARCHAR(50),
prenume VARCHAR(50), 
data_nastere DATE, 
telefon VARCHAR(15), 
email VARCHAR(100) );

CREATE TABLE Galerie ( 
galerie_id INT DEFAULT galerie_seq.NEXTVAL PRIMARY KEY,
 nume VARCHAR(100),
 nr_exponate INT,
 permanenta VARCHAR(1),
 data_incheiere DATE );

CREATE TABLE Eveniment ( 
event_id INT DEFAULT event_seq.NEXTVAL PRIMARY KEY,
 nume VARCHAR(100),
 data_inceput DATE,
 data_incheiere DATE,
 descriere VARCHAR(300) );

CREATE TABLE Sponsor (
 nume_sponsor VARCHAR(100) PRIMARY KEY,
 adresa_sediu VARCHAR(255),
 fax VARCHAR(20),
 telefon VARCHAR(15),
 nume_CEO VARCHAR(100) );

CREATE TABLE Categorie (
 nume_categorie VARCHAR(100) PRIMARY KEY,
 perioada VARCHAR(50),
 zona VARCHAR(50),
 descriere VARCHAR(300) );

CREATE TABLE Exponat(
 exponat_id INT DEFAULT exponat_seq.NEXTVAL PRIMARY KEY,
 galerie_id INT REFERENCES Galerie(galerie_id),
 nume_categorie VARCHAR(100) REFERENCES Categorie(nume_categorie),
 nume VARCHAR(100),
 an INT,
 creator VARCHAR(100) );

CREATE TABLE Angajat (
 angajat_id INT DEFAULT angajat_seq.NEXTVAL PRIMARY KEY,
 galerie_id INT REFERENCES Galerie(galerie_id),
 tip VARCHAR(50),
 vechime INT,
 nume VARCHAR(100),
 varsta INT,
 telefon VARCHAR(15),
 email VARCHAR(100));

CREATE TABLE Ghid (
 angajat_id INT PRIMARY KEY,
 FOREIGN KEY(angajat_id) REFERENCES Angajat(angajat_id),
 limba VARCHAR(50),
salariu_ghid NUMBER(10, 2));

CREATE TABLE Supervizor (
 angajat_id INT PRIMARY KEY,
 FOREIGN KEY(angajat_id) REFERENCES Angajat(angajat_id),
 pozitie VARCHAR(100),
 obligatii VARCHAR(4000),
salariu_supervizor NUMBER(10, 2));

	CREATE TABLE Orar (
 orar_id INT DEFAULT orar_seq.NEXTVAL PRIMARY KEY,
 angajat_id INT REFERENCES Angajat(angajat_id),
 galerie_id INT REFERENCES Galerie(galerie_id),
 data_orar DATE );
	
CREATE TABLE Bilet (
 bilet_id INT DEFAULT bilet_seq.NEXTVAL PRIMARY KEY,
 utilizator_id INT REFERENCES Utilizator(utilizator_id),
 tip VARCHAR(50),
 orar_id INT REFERENCES Orar(orar_id));

CREATE TABLE Bilet_Galerie (
 bilet_id INT PRIMARY KEY ,
FOREIGN KEY(bilet_id) REFERENCES Bilet(bilet_id),
 galerie_id INT REFERENCES Galerie(galerie_id),
pret_galerie NUMBER(10, 2) );

CREATE TABLE Bilet_Eveniment (
 bilet_id INT  PRIMARY KEY ,
FOREIGN KEY(bilet_id) REFERENCES Bilet(bilet_id),
 event_id INT REFERENCES Eveniment(event_id),
pret_eveniment NUMBER(10, 2) );

CREATE TABLE Supervizat_Supervizor (
 angajat_id_supervizat INT,
 angajat_id_supervizor INT,
 PRIMARY KEY(angajat_id_supervizat,angajat_id_supervizor),
 FOREIGN KEY(angajat_id_supervizat) REFERENCES Angajat (angajat_id),
 FOREIGN KEY(angajat_id_supervizor) REFERENCES Angajat(angajat_id));

 CREATE TABLE Galerie_Eveniment (
 galerie_id INT,
 event_id INT,
 PRIMARY KEY(galerie_id,event_id),
 FOREIGN KEY(galerie_id) REFERENCES Galerie (galerie_id),
 FOREIGN KEY(event_id) REFERENCES Eveniment(event_id));

 CREATE TABLE Eveniment_Sponsor (
 event_id INT,
 nume_sponsor VARCHAR(100),
 PRIMARY KEY(event_id,nume_sponsor),
 FOREIGN KEY(event_id) REFERENCES Eveniment (event_id),
 FOREIGN KEY(nume_sponsor) REFERENCES Sponsor(nume_sponsor));

INSERT INTO Utilizator (nume, prenume, data_nastere, telefon, email) VALUES
('Popescu', 'Ion', TO_DATE('1985-05-15', 'YYYY-MM-DD'), '0741234567', 'popion@yahoo.com');

INSERT INTO Utilizator (nume, prenume, data_nastere, telefon, email) VALUES
('Ionescu', 'Maria', TO_DATE('1990-07-20', 'YYYY-MM-DD'), '0742345678', 'maria9ionescu@gmail.com');

INSERT INTO Utilizator (nume, prenume, data_nastere, telefon, email) VALUES
('Georgescu', 'Alexandru', TO_DATE('1978-03-10', 'YYYY-MM-DD'), '0743456789', 'alexandru_georgescu@yahoo.com');

INSERT INTO Utilizator (nume, prenume, data_nastere, telefon, email) VALUES
('Vasilescu', 'Elena', TO_DATE('1982-11-25', 'YYYY-MM-DD'), '0744567890', 'elena.vasilescu@gmail.com');

INSERT INTO Utilizator (nume, prenume, data_nastere, telefon, email) VALUES
('Marin', 'Daniel', TO_DATE('2000-01-30', 'YYYY-MM-DD'), '0745678901', 'daniel00marin@yahoo.com');


INSERT INTO Sponsor (nume_sponsor, adresa_sediu, fax, telefon, nume_CEO) VALUES
('Dacia', 'Calea Floreasca 166, Bucuresti', '0211234567', '0721123456', 'Christophe Dridi');

INSERT INTO Sponsor (nume_sponsor, adresa_sediu, fax, telefon, nume_CEO) VALUES
('BCR', 'Bd. Regina Elisabeta 5, Bucuresti', '0212345678', '0722234567', 'Sergiu Manea');

INSERT INTO Sponsor (nume_sponsor, adresa_sediu, fax, telefon, nume_CEO) VALUES
('Petrom', 'Str. Coralilor 22, Bucuresti', '0213456789', '0723345678', 'Christina Verchere');

INSERT INTO Sponsor (nume_sponsor, adresa_sediu, fax, telefon, nume_CEO) VALUES
('Bitdefender', 'Str. Barbu Vacarescu 54, Bucuresti', '0214567890', '0724456789', 'Florin Talpes');

INSERT INTO Sponsor (nume_sponsor, adresa_sediu, fax, telefon, nume_CEO) VALUES
('eMAG', 'Str. Bdul. Pierre de Coubertin 3-5, Bucuresti', '0215678901', '0725567890', 'Iulian Stanciu');


INSERT INTO Exponat (galerie_id, nume_categorie, nume, an, creator) VALUES
(1, 'Pictura sec XIX', 'Ciobanas cu turma de oi', 1895, 'Nicolae Grigorescu');

INSERT INTO Exponat (galerie_id, nume_categorie, nume, an, creator) VALUES
(2, 'Sculptura sec XIX', 'Domnitorul Alexandru Ioan Cuza', 1860, 'Ion Georgescu');

INSERT INTO Exponat (galerie_id, nume_categorie, nume, an, creator) VALUES
(3, 'Arta Populara sec XX', 'Covor Oltenesc', 1920, 'Artisan Popular');

INSERT INTO Exponat (galerie_id, nume_categorie, nume, an, creator) VALUES
(4, 'Fotografie sec XX', 'Revolutia din 1989', 1989, 'Fotoreporter Necunoscut');

INSERT INTO Exponat (galerie_id, nume_categorie, nume, an, creator) VALUES
(5, 'Arta Contemporana', 'Ingerul', 2005, 'Ion Barladeanu');


INSERT INTO Galerie (nume, nr_exponate, permanenta, data_incheiere) VALUES
('Galeria de Arta Moderna', 50, 'Y', NULL);

INSERT INTO Galerie (nume, nr_exponate, permanenta, data_incheiere) VALUES
('Galeria de Istorie Antica', 30, 'N', TO_DATE('2023-12-31', 'YYYY-MM-DD'));

INSERT INTO Galerie (nume, nr_exponate, permanenta, data_incheiere) VALUES
('Galeria de Stiinta', 40, 'Y', NULL);

INSERT INTO Galerie (nume, nr_exponate, permanenta, data_incheiere) VALUES
('Galeria de Arta Contemporana', 20, 'N', TO_DATE('2024-06-30', 'YYYY-MM-DD'));

INSERT INTO Galerie (nume, nr_exponate, permanenta, data_incheiere) VALUES
('Galeria de Fotografie', 25, 'Y', NULL);


INSERT INTO Categorie (nume_categorie, perioada, zona, descriere) VALUES
('Pictura sec XIX', '1800-1900', 'Europa de Est', 'Picturi din secolul XIX din Europa de Est');

INSERT INTO Categorie (nume_categorie, perioada, zona, descriere) VALUES
('Sculptura sec XIX', '1800-1900', 'Europa de Est', 'Sculpturi din secolul XIX din Europa de Est');

INSERT INTO Categorie (nume_categorie, perioada, zona, descriere) VALUES
('Arta Populara sec XX', '1900-2000', 'Romania', 'Obiecte de arta populara romaneasca din secolul XX');

INSERT INTO Categorie (nume_categorie, perioada, zona, descriere) VALUES
('Fotografie sec XX', '1900-2000', 'Romania', 'Fotografii istorice din Romania secolului XX');

INSERT INTO Categorie (nume_categorie, perioada, zona, descriere) VALUES
('Arta Contemporana', '2000-prezent', 'Romania', 'Lucrari de arta contemporana din Romania');


INSERT INTO Eveniment (nume, data_inceput, data_incheiere, descriere) VALUES
('Noaptea Muzeelor', TO_DATE('2024-05-18', 'YYYY-MM-DD'), TO_DATE('2024-05-18', 'YYYY-MM-DD'), 'Eveniment special cu acces gratuit.');

INSERT INTO Eveniment (nume, data_inceput, data_incheiere, descriere) VALUES
('Expozitia de Vara', TO_DATE('2024-06-01', 'YYYY-MM-DD'), TO_DATE('2024-08-31', 'YYYY-MM-DD'), 'Expozitie temporara de vara.');

INSERT INTO Eveniment (nume, data_inceput, data_incheiere, descriere) VALUES
('Festivalul de Arta', TO_DATE('2024-09-15', 'YYYY-MM-DD'), TO_DATE('2024-09-30', 'YYYY-MM-DD'), 'Festival de arta contemporana.');

INSERT INTO Eveniment (nume, data_inceput, data_incheiere, descriere) VALUES
('Saptamana Istoriei', TO_DATE('2024-10-01', 'YYYY-MM-DD'), TO_DATE('2024-10-07', 'YYYY-MM-DD'), 'Saptamana dedicata istoriei.');

INSERT INTO Eveniment (nume, data_inceput, data_incheiere, descriere) VALUES
('Zilele Culorii', TO_DATE('2024-11-10', 'YYYY-MM-DD'), TO_DATE('2024-11-20', 'YYYY-MM-DD'), 'Eveniment dedicat oricarui tip de pata de culoare.');



INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (1, 'ghid', 3, 'Ivan Ion', 32, '0741122334', 'ion_ivan13@yahoo.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (3, 'ghid', 5, 'Vladimirescu Cornel', 28, '0755566778', 'corneliusvlad@gmail.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (1, 'ghid', 2, 'Grigorescu Ionel', 40, '0766677889', 'ionel-grigorita@yahoo.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (1, 'ghid', 4, 'Negoita Florin', 35, '0777788990', 'florinita@gmail.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (3, 'ghid', 1, 'Dragulici Marin', 26, '0788899001', 'dragurin@yahoo.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (1, 'supervizor', 6, 'Popa Vlad', 45, '0741000000', 'vladivici.popa@yahoo.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (1, 'supervizor', 8, 'Veira Radu', 50, '0755000000', 'veiradu@gmail.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (3, 'supervizor', 3, 'Istratie Ionut', 35, '0766000000', 'ionut.istratie@yahoo.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (3, 'supervizor', 7, 'Stanciu Mario', 48, '0777000000', 'ggmariom8stanciu@gmail.com');
INSERT INTO Angajat (galerie_id, tip, vechime, nume, varsta, telefon, email) VALUES (1, 'supervizor', 2, 'Andreea Dumitrescu', 30, '0788000000', 'andreea.dumitrescu@yahoo.com');


INSERT INTO Ghid (angajat_id, limba, salariu_ghid) VALUES (5, 'Engleză', 3500.50);
INSERT INTO Ghid (angajat_id, limba, salariu_ghid) VALUES (6, 'Germană', 3700.75);
INSERT INTO Ghid (angajat_id, limba, salariu_ghid) VALUES (7, 'Franceză', 3400.00);
INSERT INTO Ghid (angajat_id, limba, salariu_ghid) VALUES (8, 'Spaniolă', 3600.20);
INSERT INTO Ghid (angajat_id, limba, salariu_ghid) VALUES (9, 'Italiană', 3550.80);


INSERT INTO Supervizor (angajat_id, pozitie, obligatii, salariu_supervizor) 
VALUES (10, 'Supervizor de galerie', 'Coordonarea personalului, planificarea și organizarea evenimentelor și expozițiilor, gestionarea operațiunilor zilnice ale galeriei', 4500.00);
INSERT INTO Supervizor (angajat_id, pozitie, obligatii, salariu_supervizor) 
VALUES (11, 'Curator', 'Planificarea și organizarea expozițiilor, cercetarea și selectarea operelor de artă, gestionarea colecțiilor', 4700.00);
INSERT INTO Supervizor (angajat_id, pozitie, obligatii, salariu_supervizor) 
VALUES (12, 'Manager de muzeu', 'Supervizarea întregii activități a muzeului, elaborarea strategiilor de dezvoltare, gestionarea resurselor umane și financiare', 5000.00);
INSERT INTO Supervizor (angajat_id, pozitie, obligatii, salariu_supervizor) 
VALUES (13, 'Conservator', 'Restaurarea și conservarea operelor de artă, elaborarea planurilor de conservare și restaurare, documentarea și cercetarea obiectelor de artă', 4800.00);
INSERT INTO Supervizor (angajat_id, pozitie, obligatii, salariu_supervizor) 
VALUES (14, 'Manager Human Resources', 'Organizarea personalului si rezolvarea oricaror conflicte interne ce pot aparea de-a lungul timpului.', 4600.00);


INSERT INTO Orar (angajat_id, galerie_id, data_orar) VALUES (5, 1, TO_DATE('2024-05-18', 'YYYY-MM-DD'));
INSERT INTO Orar (angajat_id, galerie_id, data_orar) VALUES (6, 3, TO_DATE('2024-05-18', 'YYYY-MM-DD'));
INSERT INTO Orar (angajat_id, galerie_id, data_orar) VALUES (7, 1, TO_DATE('2024-05-18', 'YYYY-MM-DD'));
INSERT INTO Orar (angajat_id, galerie_id, data_orar) VALUES (8, 1, TO_DATE('2024-05-18', 'YYYY-MM-DD'));
INSERT INTO Orar (angajat_id, galerie_id, data_orar) VALUES (9, 3, TO_DATE('2024-05-18', 'YYYY-MM-DD'));



-- Bilete pentru galerii
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (1, 'galerie', 1);  
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (1, 'galerie', 2);  
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (4, 'galerie', 3);  
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (3, 'galerie', 4); 
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (4, 'galerie', 5);  

INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (2, 'eveniment', 1);
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (2, 'eveniment', 2); 
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (3, 'eveniment', 3); 
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (5, 'eveniment', 4);
INSERT INTO Bilet (utilizator_id, tip, orar_id) VALUES (5, 'eveniment', 5);


INSERT INTO Bilet_Galerie (bilet_id, galerie_id, pret_galerie) VALUES (1, 1, 50.00);
INSERT INTO Bilet_Galerie (bilet_id, galerie_id, pret_galerie) VALUES (2, 3, 60.00);
INSERT INTO Bilet_Galerie (bilet_id, galerie_id, pret_galerie) VALUES (3, 1, 50.00);
INSERT INTO Bilet_Galerie (bilet_id, galerie_id, pret_galerie) VALUES (4, 1, 50.00);
INSERT INTO Bilet_Galerie (bilet_id, galerie_id, pret_galerie) VALUES (5, 3, 60.00);


INSERT INTO Bilet_Eveniment (bilet_id, event_id, pret_eveniment) VALUES (6, 1, 0.00);
INSERT INTO Bilet_Eveniment (bilet_id, event_id, pret_eveniment) VALUES (7, 1, 0.00);
INSERT INTO Bilet_Eveniment (bilet_id, event_id, pret_eveniment) VALUES (8, 5, 75.00);
INSERT INTO Bilet_Eveniment (bilet_id, event_id, pret_eveniment) VALUES (9, 3, 80.00);
INSERT INTO Bilet_Eveniment (bilet_id, event_id, pret_eveniment) VALUES (10, 4, 70.00);


INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (5, 10);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (5, 11);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (5, 14);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (7, 10);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (7, 11);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (7, 14);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (8, 10);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (8, 11);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (8, 14);
INSERT INTO Supervizat_Supervizor (angajat_id_supervizat, angajat_id_supervizor) VALUES (6, 12);


INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (1, 1);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (3, 1);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (1, 5);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (1, 3);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (3, 4);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (2, 1);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (4, 1);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (5, 1);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (2, 2);
INSERT INTO Galerie_Eveniment (galerie_id, event_id) VALUES (5, 4);


INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (1, 'BCR');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (2, 'Petrom');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (3, 'Bitdefender');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (4, 'eMAG');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (5, 'Dacia');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (1, 'eMAG');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (2, 'BCR');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (3, 'eMAG');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (4, 'Dacia');
INSERT INTO Eveniment_Sponsor (event_id, nume_sponsor) VALUES (5, 'Bitdefender');
