DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS proc_tabla_maestra_titulos()
BEGIN
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (0, 1499, 'NO', 'Newbie');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (1500, 1799, 'AM', 'Amateur');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (1800, 2199, 'SP', 'SemiProfesional');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (2200, 2299, 'CM', 'Candidato a Maestro');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (2300, 2399, 'MF', 'Maestro FIDE');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (2400, 2499, 'MI', 'Maestro Internacional');
    INSERT INTO titulos(eloMin, eloMax, Siglas, Titulo) VALUES (2500, 9999, 'GM', 'Gran Maestro');
END$$

CREATE PROCEDURE IF NOT EXISTS proc_eliminar_tablas()
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
END$$

CREATE PROCEDURE IF NOT EXISTS proc_alta_torneos()
BEGIN
	INSERT INTO torneo (nombre, ciudad, premio, fechaInicio, fechaFinal, maxPartidas, maxParticipantes)
	VALUES ('Torneo1','Barcelona', 100, '2023-03-12','2025-04-28', 12, 8);
	INSERT INTO torneo (nombre, ciudad, premio, fechaInicio, fechaFinal, maxPartidas, maxParticipantes)
	VALUES ('Torneo2','Valencia', 10000, '2024-02-11','2024-10-01', 20, 8);
	INSERT INTO torneo (nombre, ciudad, premio, fechaInicio, fechaFinal, maxPartidas, maxParticipantes)	
	VALUES ('Torneo3','Madrid', 1000, '2023-02-20','2025-06-28', 40, 8);
END$$

CREATE PROCEDURE IF NOT EXISTS proc_alta_jugadores()
BEGIN
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Teo','Jimenez', 'Esp', 0, 0, 1799);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Mario','Caravaca', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Juan','Gimenez', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Emma','Brujula', 'Esp', 0, 0, 3000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Jaume','Lamo', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Mar','Jimenez', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Antonio','Gutierrez', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Jose','Alcala', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Isa','Monleon', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Manuela','Sanchez', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Manolo','Casas', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Francisco','Jose', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Abel','Barqueros', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Edu','Ros', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Victor','Ye', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Guille','Martinez', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Lucas','Fernandez', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Manuel','Lopez', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Alejandro','Perez', 'Esp', 0, 0, 1000);
	INSERT INTO jugador (nombre, apellido, pais, numVictoria, numDerrota, elo_actual)
	VALUES ('Martin','Garcia', 'Esp', 0, 0, 1000);
	
END$$

CREATE PROCEDURE IF NOT EXISTS proc_alta_inscribir_jugadores_torneo()
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
	
END$$


CREATE PROCEDURE IF NOT EXISTS proc_alta_partidas()
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
	
END$$

CREATE PROCEDURE IF NOT EXISTS proc_seleccionar_clasificacion(IN numero_torneo INT)
BEGIN
SELECT * FROM clasificacion WHERE idTorneo = numero_torneo;

END$$



DELIMITER ;

-- CODIGO ELO (añadido puesto que al exportar no se guardaba);
DELIMITER $$

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
	

END$$

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

END$$

DELIMITER ;

CALL proc_eliminar_tablas();

CALL proc_tabla_maestra_titulos();
CALL proc_alta_jugadores();
CALL proc_alta_torneos();
CALL proc_alta_inscribir_jugadores_torneo();
CALL proc_alta_partidas();

CALL proc_seleccionar_clasificacion(1);


