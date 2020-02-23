-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Feb 23, 2020 alle 01:58
-- Versione del server: 5.7.17
-- Versione PHP: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `funfinder`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `citta`
--

CREATE TABLE `citta` (
  `codiceIstat` int(11) NOT NULL,
  `cap` char(5) DEFAULT NULL,
  `nome` varchar(20) DEFAULT NULL,
  `regione` varchar(20) DEFAULT NULL,
  `provincia` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `citta`
--

INSERT INTO `citta` (`codiceIstat`, `cap`, `nome`, `regione`, `provincia`) VALUES
(87032, '95046', 'palagonia', 'sicilia', 'CT'),
(87037, '95040', 'ramacca', 'sicilia', 'CT'),
(87015, '95100', 'catania', 'sicilia', 'CT'),
(15146, '20019', 'milano', 'lombardia', 'MI'),
(58091, '100', 'roma', 'lazio', 'RM');

-- --------------------------------------------------------

--
-- Struttura della tabella `evento`
--

CREATE TABLE `evento` (
  `idE` int(11) NOT NULL,
  `idL` int(11) NOT NULL,
  `data` date DEFAULT NULL,
  `ora` time DEFAULT NULL,
  `prezzo` float DEFAULT NULL,
  `tipologiaEvento` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `evento`
--

INSERT INTO `evento` (`idE`, `idL`, `data`, `ora`, `prezzo`, `tipologiaEvento`) VALUES
(1, 1, '2020-01-31', '23:00:00', 30, 'Capodanno'),
(2, 5, '2020-02-03', '00:00:00', 15, 'Fluo Party'),
(3, 2, '2020-02-20', '22:30:00', 12, 'Carnevale'),
(4, 5, '2020-05-01', '10:00:00', 35, 'OneDay Music'),
(5, 4, '2020-08-15', '22:00:00', 30, 'Ferragosto Party');

--
-- Trigger `evento`
--
DELIMITER $$
CREATE TRIGGER `dateCheck` BEFORE INSERT ON `evento` FOR EACH ROW BEGIN
           IF NEW.`data` < date(now()) THEN
               set NEW.`data`= date(now());
           END IF;
       END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `priceCheck` BEFORE INSERT ON `evento` FOR EACH ROW BEGIN
           IF NEW.prezzo < 0 THEN
               SET NEW.prezzo = 0;
           END IF;
       END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `invitati`
--

CREATE TABLE `invitati` (
  `idE` int(11) NOT NULL,
  `CF` char(16) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `invitati`
--

INSERT INTO `invitati` (`idE`, `CF`) VALUES
(1, 'CJTVLZ78C44F639J'),
(1, 'MHULQV72M68G419W'),
(1, 'PRJHCW63R45G638F'),
(1, 'THMVMF72P63H235Q'),
(1, 'VPNNFR42B60C082S'),
(2, 'CGSZZT35S67I487X'),
(2, 'CJTVLZ78C44F639J'),
(2, 'LNCNVU43E31C276O'),
(2, 'THMVMF72P63H235Q'),
(2, 'VPNNFR42B60C082S'),
(3, 'CGSZZT35S67I487X'),
(3, 'CJTVLZ78C44F639J'),
(4, 'CGSZZT35S67I487X'),
(4, 'LNCNVU43E31C276O'),
(4, 'VPNNFR42B60C082S'),
(5, 'CJTVLZ78C44F639J'),
(5, 'GVPRJE86P68D491Z'),
(5, 'LNCNVU43E31C276O');

--
-- Trigger `invitati`
--
DELIMITER $$
CREATE TRIGGER `after_insert_invitati` AFTER INSERT ON `invitati` FOR EACH ROW BEGIN
    
DELETE FROM organizzazione
	   WHERE organizzazione.idE=new.idE and organizzazione.CF= new.CF;

END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `etaCheck` BEFORE INSERT ON `invitati` FOR EACH ROW BEGIN
       DECLARE eta integer;
       SET @eta =(SELECT (YEAR(now()) - YEAR(p.dataNascita)) AS eta
                   FROM persona p
                   WHERE p.CF= new.CF);
       
           IF @eta>=18  THEN
               insert into invitati(idE, CF) values(new.idE, new.CF);

           END IF;
       END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `startedEventCheck` BEFORE INSERT ON `invitati` FOR EACH ROW BEGIN
       DECLARE giornoOra datetime;
       SET @giornoOra :=(SELECT CONCAT(e.`data`, ' ', e.ora) AS giornoOra
                   FROM evento e
                   WHERE e.idE= new.idE);
       
           IF giornoOra> now()  THEN
               insert into invitati(idE, CF) values(new.idE, new.CF);
           END IF;
       END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `locale`
--

CREATE TABLE `locale` (
  `idL` int(11) NOT NULL,
  `idCitta` int(11) NOT NULL,
  `nome` varchar(20) DEFAULT NULL,
  `indirizzo` varchar(20) DEFAULT NULL,
  `capienza` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `locale`
--

INSERT INTO `locale` (`idL`, `idCitta`, `nome`, `indirizzo`, `capienza`) VALUES
(1, 87015, 'ecs dogana', 'via dusmet', 10000),
(2, 87037, 'blanco club', 'via roma', 5000),
(3, 87032, 'vertigo', 'via palermo', 6500),
(4, 58091, 'armani club', 'via dusmet', 25000),
(5, 87015, 'afrobar', 'viale kennedy', 12000);

--
-- Trigger `locale`
--
DELIMITER $$
CREATE TRIGGER `capienzaCheck` BEFORE INSERT ON `locale` FOR EACH ROW BEGIN
           IF NEW.capienza < 0 THEN
               SET NEW.capienza = 0;
           END IF;
       END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `organizzazione`
--

CREATE TABLE `organizzazione` (
  `idE` int(11) NOT NULL,
  `CF` char(16) NOT NULL,
  `ruolo` varchar(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `organizzazione`
--

INSERT INTO `organizzazione` (`idE`, `CF`, `ruolo`) VALUES
(4, 'QHYXHR97R71A045Z', 'sicurezza'),
(3, 'VHCLJR69L57I351L', 'barman'),
(2, 'NSINQC53R59C274V', 'sicurezza'),
(2, 'NGNYHD32E06F030D', 'barman'),
(1, 'NGNYHD32E06F030D', 'PR'),
(1, 'QHYXHR97R71A045Z', 'sicurezza'),
(1, 'VHCLJR69L57I351L', 'barman'),
(1, 'MHULQV72M68G419W', 'PR'),
(5, 'MHULQV72M68G419W', 'PR'),
(5, 'NSINQC53R59C274V', 'PR'),
(5, 'VHCLJR69L57I351L', 'PR');

--
-- Trigger `organizzazione`
--
DELIMITER $$
CREATE TRIGGER `after_insert_organizzazione` AFTER INSERT ON `organizzazione` FOR EACH ROW BEGIN
    
DELETE FROM invitati
	   WHERE invitati.idE=new.idE and invitati.CF= new.CF;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struttura della tabella `ospitispeciali`
--

CREATE TABLE `ospitispeciali` (
  `CF` char(16) NOT NULL,
  `idE` int(11) NOT NULL,
  `nome` varchar(20) DEFAULT NULL,
  `cognome` varchar(20) DEFAULT NULL,
  `professione` varchar(30) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `ospitispeciali`
--

INSERT INTO `ospitispeciali` (`CF`, `idE`, `nome`, `cognome`, `professione`) VALUES
('HDMLCL61R60B705X', 4, 'sfera', 'ebbasta', 'cantante'),
('KZYTQA59H58D689E', 4, 'travis', 'scott', 'cantante'),
('ZHZQRM82L25F861D', 1, 'skillex', NULL, 'DJ'),
('GVPRJE86P68D491Z', 2, 'ludovica', 'pagani', 'influencer'),
('RVPMLN36L30B128A', 3, 'martin', 'garrix', 'DJ'),
('RJLBNP65M08L065P', 5, 'night', 'skinny', 'DJ');

-- --------------------------------------------------------

--
-- Struttura della tabella `persona`
--

CREATE TABLE `persona` (
  `CF` char(16) NOT NULL,
  `nome` varchar(20) DEFAULT NULL,
  `cognome` varchar(20) DEFAULT NULL,
  `dataNascita` date DEFAULT NULL,
  `telefono` char(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dump dei dati per la tabella `persona`
--

INSERT INTO `persona` (`CF`, `nome`, `cognome`, `dataNascita`, `telefono`) VALUES
('CJTVLZ78C44F639J', 'davide', 'casano', '1999-04-02', '3381881234'),
('VPNNFR42B60C082S', 'valerio', 'catania', '1999-07-09', '3381882345'),
('LRPLMV81P54M126K', 'christian', 'gurrieri', '1999-07-12', '3381883456'),
('THMVMF72P63H235Q', 'marco', 'ardizzone', '1999-03-02', '3381884567'),
('PRJHCW63R45G638F', 'giorgio', 'gambino', '1998-09-23', '3381885678'),
('CGSZZT35S67I487X', 'salvatore', 'ardizzone', '1996-10-22', '3381889876'),
('LNCNVU43E31C276O', 'mario', 'rossi', '1999-10-02', '3381889454'),
('NGNYHD32E06F030D', 'luigi', 'gialli', '1992-12-21', '3392881234'),
('NSINQC53R59C274V', 'francesco', 'viola', '1991-11-17', '3321881234'),
('QHYXHR97R71A045Z', 'fausto', 'di stefano', '1999-04-02', '3381771234'),
('VHCLJR69L57I351L', 'giuseppe', 'manfredi', '1998-08-30', '3381946234'),
('MHULQV72M68G419W', 'andrea', 'campisi', '1999-08-08', '3291881234'),
('wwwwwwwwwwwww', 'prova', 'test', '2000-11-11', NULL);

--
-- Trigger `persona`
--
DELIMITER $$
CREATE TRIGGER `personBirthdayCheck` BEFORE INSERT ON `persona` FOR EACH ROW BEGIN

           IF  new.dataNascita> date(now()) THEN
              insert into persona(CF, cognome, dataNascita, nome, telefono) values(new.CF, new.cognome, date(now()), new.nome, new.telefono);
        
           END IF;
       END
$$
DELIMITER ;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `citta`
--
ALTER TABLE `citta`
  ADD PRIMARY KEY (`codiceIstat`);

--
-- Indici per le tabelle `evento`
--
ALTER TABLE `evento`
  ADD PRIMARY KEY (`idE`),
  ADD KEY `idL` (`idL`);

--
-- Indici per le tabelle `invitati`
--
ALTER TABLE `invitati`
  ADD PRIMARY KEY (`idE`,`CF`),
  ADD KEY `CF` (`CF`);

--
-- Indici per le tabelle `locale`
--
ALTER TABLE `locale`
  ADD PRIMARY KEY (`idL`),
  ADD KEY `idCitta` (`idCitta`);

--
-- Indici per le tabelle `organizzazione`
--
ALTER TABLE `organizzazione`
  ADD PRIMARY KEY (`idE`,`CF`),
  ADD KEY `CF` (`CF`);

--
-- Indici per le tabelle `ospitispeciali`
--
ALTER TABLE `ospitispeciali`
  ADD PRIMARY KEY (`CF`,`idE`),
  ADD KEY `idE` (`idE`);

--
-- Indici per le tabelle `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`CF`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
