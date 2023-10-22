-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.27-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para chessdb_new
CREATE DATABASE IF NOT EXISTS `chessdb_new` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `chessdb_new`;

-- Volcando estructura para tabla chessdb_new.clasificacion
CREATE TABLE IF NOT EXISTS `clasificacion` (
  `idJugador` int(11) DEFAULT NULL,
  `idTorneo` int(11) DEFAULT NULL,
  `puntosObtenidos` float DEFAULT NULL,
  KEY `FK_clasificacion_torneo_jugador` (`idJugador`),
  KEY `FK_clasificacion_torneo_torneo` (`idTorneo`),
  CONSTRAINT `FK_clasificacion_torneo_jugador` FOREIGN KEY (`idJugador`) REFERENCES `jugador` (`idJugador`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_clasificacion_torneo_torneo` FOREIGN KEY (`idTorneo`) REFERENCES `torneo` (`idTorneo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla chessdb_new.clasificacion: ~0 rows (aproximadamente)

-- Volcando estructura para función chessdb_new.func_probabilidad
DELIMITER //
CREATE FUNCTION IF NOT EXISTS `func_probabilidad`(`rat1` INT,
	`rat2` INT
) RETURNS float
    DETERMINISTIC
BEGIN
	SET @c=(1*1.0
           / (1
              + 1.0
                    * pow(10,
                          1.0 * (rat1 - rat2) / 400)));

	RETURN (1*1.0
           / (1
              + 1.0
                    * pow(10,
                          1.0 * (rat1 - rat2) / 400)));

END//
DELIMITER ;

-- Volcando estructura para tabla chessdb_new.inscripcion
CREATE TABLE IF NOT EXISTS `inscripcion` (
  `idJugador` int(11) DEFAULT NULL,
  `idTorneo` int(11) DEFAULT NULL,
  `elo_actual` int(11) DEFAULT NULL,
  KEY `FK__jugador` (`idJugador`),
  KEY `FK__torneo` (`idTorneo`),
  CONSTRAINT `FK__jugador` FOREIGN KEY (`idJugador`) REFERENCES `jugador` (`idJugador`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK__torneo` FOREIGN KEY (`idTorneo`) REFERENCES `torneo` (`idTorneo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla chessdb_new.inscripcion: ~0 rows (aproximadamente)

-- Volcando estructura para tabla chessdb_new.jugador
CREATE TABLE IF NOT EXISTS `jugador` (
  `idJugador` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `pais` varchar(50) DEFAULT NULL,
  `numVictoria` int(11) DEFAULT NULL,
  `numDerrota` int(11) DEFAULT NULL,
  `idTitulo` int(11) DEFAULT NULL,
  `elo_actual` int(11) NOT NULL,
  PRIMARY KEY (`idJugador`),
  KEY `FK_jugador_titulos` (`idTitulo`),
  CONSTRAINT `FK_jugador_titulos` FOREIGN KEY (`idTitulo`) REFERENCES `titulos` (`idTitulo`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `no_negativo_elo_actual` CHECK (`elo_actual` >= 0),
  CONSTRAINT `no_negativo_num_Victoria` CHECK (`numVictoria` >= 0),
  CONSTRAINT `no_negativo_num_Derrota` CHECK (`numDerrota` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla chessdb_new.jugador: ~0 rows (aproximadamente)

-- Volcando estructura para tabla chessdb_new.log_titulo_changed
CREATE TABLE IF NOT EXISTS `log_titulo_changed` (
  `idJugador` int(11) DEFAULT NULL,
  `titulo_actual` varchar(50) DEFAULT NULL,
  `titulo_anterior` varchar(50) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  KEY `FK_log_titulo_changed_jugador` (`idJugador`),
  CONSTRAINT `FK_log_titulo_changed_jugador` FOREIGN KEY (`idJugador`) REFERENCES `jugador` (`idJugador`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla chessdb_new.log_titulo_changed: ~0 rows (aproximadamente)

-- Volcando estructura para tabla chessdb_new.partida
CREATE TABLE IF NOT EXISTS `partida` (
  `idPartida` int(11) NOT NULL AUTO_INCREMENT,
  `idJugadorBlancas` int(11) DEFAULT NULL,
  `idJugadorNegras` int(11) DEFAULT NULL,
  `idTorneo` int(11) DEFAULT NULL,
  `resultado` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `eloBlancas` int(11) DEFAULT NULL,
  `eloNegras` int(11) DEFAULT NULL,
  PRIMARY KEY (`idPartida`),
  KEY `FK_partida_jugador` (`idJugadorBlancas`),
  KEY `FK_partida_jugador_2` (`idJugadorNegras`),
  KEY `FK_partida_torneo` (`idTorneo`),
  CONSTRAINT `FK_partida_jugador` FOREIGN KEY (`idJugadorBlancas`) REFERENCES `jugador` (`idJugador`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_partida_jugador_2` FOREIGN KEY (`idJugadorNegras`) REFERENCES `jugador` (`idJugador`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_partida_torneo` FOREIGN KEY (`idTorneo`) REFERENCES `torneo` (`idTorneo`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla chessdb_new.partida: ~0 rows (aproximadamente)

-- Volcando estructura para procedimiento chessdb_new.proc_alta_inscribir_jugadores_torneo
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `proc_alta_inscribir_jugadores_torneo`()
BEGIN
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (1, 1);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (2, 2);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (3, 3);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (4, 1);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (5, 2);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (6, 3);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (7, 1);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (8, 2);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (9, 3);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (10, 1);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (11, 2);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (12, 3);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (13, 1);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (14, 2);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (15, 3);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (16, 1);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (17, 2);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (18, 3);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (19, 1);
	INSERT INTO inscripcion (idJugador, idTorneo)
	VALUES (20, 2);
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento chessdb_new.proc_alta_jugadores
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `proc_alta_jugadores`()
BEGIN
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Teo','Jimenez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Mario','Caravaca', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Juan','Gimenez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Emma','Brujula', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Jaume','Lamo', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Mar','Jimenez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Antonio','Gutierrez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Jose','Alcala', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Isa','Monleon', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Manuela','Sanchez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Manolo','Casas', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Francisco','Jose', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Abel','Barqueros', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Edu','Ros', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Victor','Ye', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Guille','Martinez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Lucas','Fernandez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Manuel','Lopez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Alejandro','Perez', 'Esp', 0, 0, 1, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, idTitulo, elo_actual)
	VALUES ('Martin','Garcia', 'Esp', 0, 0, 1, 1000);
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento chessdb_new.proc_alta_partidas
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `proc_alta_partidas`()
BEGIN
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 1 , 4, 1,'2023-03-22', '19:23:42');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 2 , 5, 2,'2024-05-23', '12:48:51');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 3 , 6, 3,'2025-05-22', '18:35:18');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 7 , 10, 1,'2023-04-20', '19:31:55');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 8 , 11, 2,'2024-04-10', '20:10:52');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 9 , 12, 3,'2025-06-22', '14:40:40');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 13 , 16, 1,'2023-03-24', '12:32:24');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 20 , 2, 2,'2024-05-28', '09:38:32');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 15 , 9, 3,'2025-06-25', '22:50:04');
	INSERT INTO partida (idJugadorBlancas, idJugadorNegras, idTorneo, fecha, hora)
	VALUES ( 19 , 7, 1,'2023-03-27', '11:12:52');
	
END//
DELIMITER ;

-- Volcando estructura para procedimiento chessdb_new.proc_alta_torneos
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `proc_alta_torneos`()
BEGIN
	INSERT INTO torneo (nombre, ciudad, premio, fechaInicio, fechaFinal, maxPartidas, maxParticipantes)
	VALUES ('Torneo1','Barcelona', 100, '2023-03-12','2025-04-28', 12, 8);
	INSERT INTO torneo (nombre, ciudad, premio, fechaInicio, fechaFinal, maxPartidas, maxParticipantes)
	VALUES ('Torneo2','Valencia', 10000, '2024-02-11','2024-10-01', 20, 8);
	INSERT INTO torneo (nombre, ciudad, premio, fechaInicio, fechaFinal, maxPartidas, maxParticipantes)	
	VALUES ('Torneo3','Madrid', 1000, '2023-02-20','2025-06-28', 40, 8);
END//
DELIMITER ;

-- Volcando estructura para procedimiento chessdb_new.proc_calculateELO
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `proc_calculateELO`(
	INOUT `Elo1` INT,
	INOUT `Elo2` INT,
	IN `Victoria1` INT
)
    DETERMINISTIC
BEGIN
	DECLARE var_prob1 FLOAT;
	DECLARE var_prob2 FLOAT;
	DECLARE const_K INT DEFAULT 28;

	-- Calculamos la probabilidad de victoria para cada caso
	--	probabilidad de victoria de jug1
	SET var_prob1=func_probabilidad(Elo2,Elo1);
	--	probabilidad de victoria de jug2
	SET var_prob2=func_probabilidad(Elo1,Elo2);
	
	SET @a=var_prob1;
	SET @b=var_prob2;
	
	-- No esta calculado para empate, por lo que lo quizas sea necesario modificar el proc o no llamarlo
	
	-- victoria1 significa que gana el jugador 1 y pierde jugador 2
	IF (victoria1=1) THEN
		SET elo1=ROUND(Elo1+const_k*(1-var_prob1));
		SET Elo2=ROUND(Elo2+const_k*(0-var_prob2));
	ELSE 
	-- este seria el caso en el jugador 2 gana y el jugador 1 pierde
		SET Elo1=Elo1+const_k*(0-var_prob1);
		SET Elo2=Elo2+const_k*(1-var_prob2);
	END IF;
	

END//
DELIMITER ;

-- Volcando estructura para procedimiento chessdb_new.proc_eliminar_tablas
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `proc_eliminar_tablas`()
BEGIN
SET FOREIGN_KEY_CHECKS=0;
 	TRUNCATE jugador;
	TRUNCATE titulos;
	TRUNCATE torneo;
	TRUNCATE partida;
	TRUNCATE clasificacion;
	TRUNCATE inscripcion;
	TRUNCATE log_titulo_changed;
	SET FOREIGN_KEY_CHECKS=1;
END//
DELIMITER ;

-- Volcando estructura para procedimiento chessdb_new.proc_seleccionar_clasificacion
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `proc_seleccionar_clasificacion`(IN numero_torneo INT)
BEGIN
SELECT * FROM clasificacion WHERE idTorneo = numero_torneo;

END//
DELIMITER ;

-- Volcando estructura para procedimiento chessdb_new.proc_tabla_maestra_titulos
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS `proc_tabla_maestra_titulos`()
BEGIN
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (0, 1499, 'NO', 'Newbie');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (1500, 1799, 'AM', 'Amateur');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (1800, 2199, 'SP', 'SemiProfesional');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (2200, 2299, 'CM', 'Candidato a Maestro');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (2300, 2399, 'MF', 'Maestro FIDE');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (2400, 2499, 'MI', 'Maestro Internacional');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (2500, 9999, 'GM', 'Gran Maestro');
END//
DELIMITER ;

-- Volcando estructura para tabla chessdb_new.titulos
CREATE TABLE IF NOT EXISTS `titulos` (
  `idTitulo` int(11) NOT NULL AUTO_INCREMENT,
  `eloMin` int(11) DEFAULT NULL,
  `eloMax` int(11) DEFAULT NULL,
  `Siglas` varchar(50) DEFAULT NULL,
  `Titulo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idTitulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla chessdb_new.titulos: ~0 rows (aproximadamente)

-- Volcando estructura para tabla chessdb_new.torneo
CREATE TABLE IF NOT EXISTS `torneo` (
  `idTorneo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `ciudad` varchar(50) DEFAULT NULL,
  `premio` int(11) DEFAULT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFinal` date DEFAULT NULL,
  `maxPartidas` int(11) DEFAULT NULL,
  `maxParticipantes` int(11) DEFAULT NULL,
  PRIMARY KEY (`idTorneo`),
  CONSTRAINT `maxParticipantes_mayor2` CHECK (`maxParticipantes` >= 2),
  CONSTRAINT `maxPartida_mayor1` CHECK (`maxPartidas` >= 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla chessdb_new.torneo: ~0 rows (aproximadamente)

-- Volcando estructura para disparador chessdb_new.trigger_actualizar_elo_tras_partida
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_actualizar_elo_tras_partida BEFORE UPDATE ON partida FOR EACH ROW
BEGIN
SET @debug = 1;
	SET @Elo1 = (SELECT eloBlancas FROM partida WHERE idJugadorBlancas = NEW.idJugadorBlancas);
	SET @Elo2 = (SELECT eloNegras FROM partida WHERE idJugadorNegras = NEW.idJugadorNegras);
	SET @eloJugadorBlancas = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugadorBlancas);
	SET @eloJugadorNegras = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugadorNegras);

IF NEW.resultado = 1 THEN
	SET @debug = 2;
	CALL proc_calculateELO(@Elo1, @Elo2, 1);
	SET NEW.eloBlancas = @Elo1;
	SET NEW.eloNegras = @Elo2;
	
	UPDATE jugador SET numVictoria = numVictoria + 1 WHERE idJugador = NEW.idJugadorBlancas;
	UPDATE jugador SET numDerrota = numDerrota + 1 WHERE idJugador = NEW.idJugadorNegras;
	
ELSEIF NEW.resultado = 2 THEN
	CALL proc_calculateELO(@Elo1, @Elo2, 2);
	SET NEW.eloBlancas = @Elo1;
	SET NEW.eloNegras = @Elo2;
	
	UPDATE jugador SET numVictoria = numVictoria + 1 WHERE idJugador = NEW.idJugadorBlancas;
	UPDATE jugador SET numDerrota = numDerrota + 1 WHERE idJugador = NEW.idJugadorNegras;
	
ELSE
	SET NEW.eloBlancas = OLD.eloBlancas;
	SET NEW.eloNegras = OLD.eloNegras;

-- 	INSERT INTO partida (eloBlancas, eloNegras) VALUES (@Elo1, @Elo2);
-- UPDATE partida SET eloBlancas = @Elo1, eloNegras = @Elo2 WHERE idPartida = NEW.idPartida;
END IF;

-- 	SET @eloJugadorBlancas = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugadorBlancas);
-- 	SET @eloJugadorNegras = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugadorNegras);
-- 	

IF NEW.eloBlancas != @eloJugadorBlancas THEN
	SET @debug = 2134;
	SET @eloJugadorBlancas = @Elo1;
	UPDATE jugador SET elo_actual = @eloJugadorBlancas WHERE idJugador = NEW.idJugadorBlancas;
ELSEIF NEW.eloNegras != @eloJugadorNegras THEN
	SET @eloJugadorNegras = @Elo2;
	UPDATE jugador SET elo_actual = @eloJugadorNegras WHERE idJugador = NEW.idJugadorNegras;

END IF;

END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_add_change_titulo
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_add_change_titulo BEFORE UPDATE ON jugador FOR EACH ROW
BEGIN
DECLARE	old_titulo VARCHAR(50);
DECLARE	new_titulo VARCHAR(50);

	SET old_titulo = (SELECT Titulo FROM titulos WHERE idTitulo = OLD.idTitulo);
	SET new_titulo = (SELECT Titulo FROM titulos WHERE idTitulo = NEW.idTitulo);
	
	IF OLD.idTitulo != NEW.idTitulo THEN	
  		INSERT INTO log_titulo_changed (idJugador, titulo_actual, titulo_anterior, fecha) VALUES (OLD.idJugador, new_titulo, old_titulo, CURRENT_DATE() );
  	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_change_titulo_in_jugador
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_change_titulo_in_jugador BEFORE UPDATE ON jugador FOR EACH ROW
BEGIN
	IF OLD.elo_actual < NEW.elo_actual THEN
  		SET NEW.idTitulo = (SELECT idTitulo FROM titulos WHERE eloMin <= NEW.elo_actual AND eloMax >= NEW.elo_actual);
  	END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_elo_jugador_to_inscripcion
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_elo_jugador_to_inscripcion BEFORE INSERT ON inscripcion FOR EACH ROW
BEGIN
    IF NEW.elo_actual IS NULL THEN
        SET NEW.elo_actual = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugador);
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_elo_jugador_to_partida_NULL
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_elo_jugador_to_partida_NULL BEFORE INSERT ON partida FOR EACH ROW
BEGIN
    IF NEW.eloNegras IS NULL OR NEW.eloBlancas IS NULL THEN
        SET NEW.eloNegras = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugadorNegras);
        SET NEW.eloBlancas = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugadorBlancas);
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_fechaInicio_fechaFinal
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_fechaInicio_fechaFinal BEFORE INSERT ON torneo FOR EACH ROW
BEGIN

IF NEW.fechaInicio >= NEW.fechaFinal THEN
	SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Las columnas fechaInicio y fechaFinal no pueden tener el mismo valor.';
END IF;
  
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_inscripcion_max_jugadores
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_inscripcion_max_jugadores BEFORE INSERT ON inscripcion FOR EACH ROW
BEGIN
 DECLARE comprovador_inscripcion INT; 
 DECLARE num INT;

SET comprovador_inscripcion = (SELECT COUNT(idTorneo) FROM inscripcion WHERE idTorneo = NEW.idTorneo);
SET num = (SELECT maxParticipantes FROM torneo WHERE idTorneo = NEW.idTorneo);

IF num < comprovador_inscripcion THEN
  SIGNAL SQLSTATE '45008' SET MESSAGE_TEXT = 'Se ha superado el maximo de jugadores en este torneo';
  END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_misma_ciudad_año
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_misma_ciudad_año BEFORE INSERT ON torneo FOR EACH ROW
BEGIN

IF EXISTS (SELECT 1 FROM torneo WHERE ciudad = NEW.ciudad AND (YEAR(fechaInicio) = YEAR(NEW.fechaInicio) OR YEAR(fechaFinal) = YEAR(NEW.fechaFinal)))THEN
  SIGNAL SQLSTATE '45007' SET MESSAGE_TEXT = 'No puede haber un torneo que se celebre en la misma ciudad, y el mismo intervalo de año del mismo';
END IF;
  
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_mismo_jugador_2veces_torneo
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_mismo_jugador_2veces_torneo BEFORE INSERT ON inscripcion FOR EACH ROW
BEGIN
 DECLARE count_rows INT;
 
 SET count_rows = (SELECT COUNT(*) FROM inscripcion WHERE idTorneo = NEW.idTorneo AND idJugador = NEW.idJugador);
 
 IF count_rows > 0 THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puede estar el mismo jugador inscrito dos veces en el mismo torneo';
 END IF;
  
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_partidas_max_partidas
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_partidas_max_partidas BEFORE INSERT ON partida FOR EACH ROW
BEGIN
 DECLARE comprovador_partidas INT; 
 DECLARE num INT;

SET comprovador_partidas = (SELECT COUNT(idTorneo) FROM partida WHERE idTorneo = NEW.idTorneo);
SET num = (SELECT maxPartidas FROM torneo WHERE idTorneo = NEW.idTorneo);

IF comprovador_partidas >= num THEN
  SIGNAL SQLSTATE '45009' SET MESSAGE_TEXT = 'Se ha superado el maximo de partidas en este torneo';
  END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_Uno_vs_UnoMismo
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_Uno_vs_UnoMismo BEFORE INSERT ON partida FOR EACH ROW
BEGIN

IF NEW.idJugadorBlancas = NEW.idJugadorNegras THEN
	SIGNAL SQLSTATE '45001'
    SET MESSAGE_TEXT = 'Un jugador no puede jugar contra sí mismo';
END IF;
  
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para disparador chessdb_new.trigger_update_clasificacion
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER IF NOT EXISTS trigger_update_clasificacion AFTER UPDATE ON partida
FOR EACH ROW
BEGIN
DECLARE numFilasB INT;
DECLARE numFilasN INT;
DECLARE num_torneo INT DEFAULT 2;
SET numFilasB = (SELECT COUNT(*) FROM clasificacion WHERE idJugador = NEW.idJugadorBlancas);
SET numFilasN = (SELECT COUNT(*) FROM clasificacion WHERE idJugador = NEW.idJugadorNegras);
-- SET numFilasB = (SELECT COUNT(*) FROM clasificacion WHERE idJugador = NEW.idJugadorBlancas AND idTorneo = num_torneo);
-- SET numFilasN = (SELECT COUNT(*) FROM clasificacion WHERE idJugador = NEW.idJugadorNegras AND idTorneo = num_torneo);

IF NEW.resultado = 1 THEN
        IF numFilasB = 0 THEN
            INSERT INTO clasificacion (idJugador, idTorneo, puntosObtenidos) VALUES (NEW.idJugadorBlancas, NEW.idTorneo, 1);
        ELSE
            UPDATE clasificacion SET puntosObtenidos = puntosObtenidos + 1 WHERE idJugador = NEW.idJugadorBlancas AND idTorneo = NEW.idTorneo;
        END IF;
        
      	IF numFilasN = 0 THEN
            INSERT INTO clasificacion (idJugador, idTorneo, puntosObtenidos) VALUES (NEW.idJugadorNegras, NEW.idTorneo, 0);
        ELSE
            UPDATE clasificacion SET puntosObtenidos = puntosObtenidos + 0 WHERE idJugador = NEW.idJugadorNegras AND idTorneo = NEW.idTorneo;
        END IF;
        
   ELSEIF NEW.resultado = 2 THEN
        IF numFilasN = 0 THEN
            INSERT INTO clasificacion (idJugador, idTorneo, puntosObtenidos) VALUES (NEW.idJugadorNegras, NEW.idTorneo, 1);
        ELSE
            UPDATE clasificacion SET puntosObtenidos = puntosObtenidos + 1 WHERE idJugador = NEW.idJugadorNegras AND idTorneo = NEW.idTorneo;
        END IF;
        
        IF numFilasB = 0 THEN
            INSERT INTO clasificacion (idJugador, idTorneo, puntosObtenidos) VALUES (NEW.idJugadorBlancas, NEW.idTorneo, 0);
        ELSE
            UPDATE clasificacion SET puntosObtenidos = puntosObtenidos + 0 WHERE idJugador = NEW.idJugadorBlancas AND idTorneo = NEW.idTorneo;
        END IF;
        
   ELSEIF NEW.resultado = 0 THEN
   		IF numFilasN = 0 THEN
            INSERT INTO clasificacion (idJugador, idTorneo, puntosObtenidos) VALUES (NEW.idJugadorNegras, NEW.idTorneo, 0.5);
        ELSE
            UPDATE clasificacion SET puntosObtenidos = puntosObtenidos + 0.5 WHERE idJugador = NEW.idJugadorNegras AND idTorneo = NEW.idTorneo;
        END IF;
        
        IF numFilasB = 0 THEN
            INSERT INTO clasificacion (idJugador, idTorneo, puntosObtenidos) VALUES (NEW.idJugadorBlancas, NEW.idTorneo, 0.5);
        ELSE
            UPDATE clasificacion SET puntosObtenidos = puntosObtenidos + 0.5 WHERE idJugador = NEW.idJugadorBlancas AND idTorneo = NEW.idTorneo;
        END IF;
   
    END IF;
END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
