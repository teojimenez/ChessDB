DELIMITER $$

CREATE TRIGGER IF NOT EXISTS trigger_fechaInicio_fechaFinal BEFORE INSERT ON torneo FOR EACH ROW
BEGIN

IF NEW.fechaInicio >= NEW.fechaFinal THEN
	SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Las columnas fechaInicio y fechaFinal no pueden tener el mismo valor.';
END IF;
  
END$$

CREATE TRIGGER IF NOT EXISTS trigger_Uno_vs_UnoMismo BEFORE INSERT ON partida FOR EACH ROW
BEGIN

IF NEW.idJugadorBlancas = NEW.idJugadorNegras THEN
	SIGNAL SQLSTATE '45001'
    SET MESSAGE_TEXT = 'Un jugador no puede jugar contra sí mismo';
END IF;
  
END$$

CREATE TRIGGER IF NOT EXISTS trigger_mismo_jugador_2veces_torneo BEFORE INSERT ON inscripcion FOR EACH ROW
BEGIN
 DECLARE count_rows INT;
 
 SET count_rows = (SELECT COUNT(*) FROM inscripcion WHERE idTorneo = NEW.idTorneo AND idJugador = NEW.idJugador);
 
 IF count_rows > 0 THEN
     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puede estar el mismo jugador inscrito dos veces en el mismo torneo';
 END IF;
  
END$$



CREATE TRIGGER IF NOT EXISTS trigger_misma_ciudad_año BEFORE INSERT ON torneo FOR EACH ROW
BEGIN

IF EXISTS (SELECT 1 FROM torneo WHERE ciudad = NEW.ciudad AND (YEAR(fechaInicio) = YEAR(NEW.fechaInicio) OR YEAR(fechaFinal) = YEAR(NEW.fechaFinal)))THEN
  SIGNAL SQLSTATE '45007' SET MESSAGE_TEXT = 'No puede haber un torneo que se celebre en la misma ciudad, y el mismo intervalo de año del mismo';
END IF;
  
END$$


CREATE TRIGGER IF NOT EXISTS trigger_inscripcion_max_jugadores BEFORE INSERT ON inscripcion FOR EACH ROW
BEGIN
 DECLARE comprovador_inscripcion INT; 
 DECLARE num INT;

SET comprovador_inscripcion = (SELECT COUNT(idTorneo) FROM inscripcion WHERE idTorneo = NEW.idTorneo);
SET num = (SELECT maxParticipantes FROM torneo WHERE idTorneo = NEW.idTorneo);

IF num < comprovador_inscripcion THEN
  SIGNAL SQLSTATE '45008' SET MESSAGE_TEXT = 'Se ha superado el maximo de jugadores en este torneo';
  END IF;
END$$


CREATE TRIGGER IF NOT EXISTS trigger_partidas_max_partidas BEFORE INSERT ON partida FOR EACH ROW
BEGIN
 DECLARE comprovador_partidas INT; 
 DECLARE num INT;

SET comprovador_partidas = (SELECT COUNT(idTorneo) FROM partida WHERE idTorneo = NEW.idTorneo);
SET num = (SELECT maxPartidas FROM torneo WHERE idTorneo = NEW.idTorneo);

IF comprovador_partidas >= num THEN
  SIGNAL SQLSTATE '45009' SET MESSAGE_TEXT = 'Se ha superado el maximo de partidas en este torneo';
  END IF;
END$$

CREATE TRIGGER IF NOT EXISTS trigger_change_titulo_in_jugador BEFORE UPDATE ON jugador FOR EACH ROW
BEGIN
	IF OLD.elo_actual < NEW.elo_actual THEN
  		SET NEW.idTitulo = (SELECT idTitulo FROM titulos WHERE eloMin <= NEW.elo_actual AND eloMax >= NEW.elo_actual);
  	END IF;
END$$

CREATE TRIGGER IF NOT EXISTS trigger_add_change_titulo BEFORE UPDATE ON jugador FOR EACH ROW
BEGIN
DECLARE	old_titulo VARCHAR(50);
DECLARE	new_titulo VARCHAR(50);

	SET old_titulo = (SELECT Titulo FROM titulos WHERE idTitulo = OLD.idTitulo);
	SET new_titulo = (SELECT Titulo FROM titulos WHERE idTitulo = NEW.idTitulo);
	
	IF OLD.idTitulo != NEW.idTitulo THEN	
  		INSERT INTO log_titulo_changed (idJugador, titulo_actual, titulo_anterior, fecha) VALUES (OLD.idJugador, new_titulo, old_titulo, CURRENT_DATE() );
  	END IF;
END$$


CREATE TRIGGER IF NOT EXISTS trigger_elo_jugador_to_inscripcion BEFORE INSERT ON inscripcion FOR EACH ROW
BEGIN
    IF NEW.elo_actual IS NULL THEN
        SET NEW.elo_actual = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugador);
    END IF;
END$$

CREATE TRIGGER IF NOT EXISTS trigger_elo_jugador_to_partida_NULL BEFORE INSERT ON partida FOR EACH ROW
BEGIN
    IF NEW.eloNegras IS NULL OR NEW.eloBlancas IS NULL THEN
        SET NEW.eloNegras = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugadorNegras);
        SET NEW.eloBlancas = (SELECT elo_actual FROM jugador WHERE idJugador = NEW.idJugadorBlancas);
    END IF;
END$$


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

END$$



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
END $$


DELIMITER ;

DELIMITER $$
CREATE TRIGGER IF NOT EXISTS trigger_verificar_inscripcion
BEFORE INSERT ON partida FOR EACH ROW
BEGIN
    DECLARE jugadorBlancas INT;
    DECLARE jugadorNegras INT;
    DECLARE torneo INT;
    DECLARE contador INT;

    SET jugadorBlancas = NEW.idJugadorBlancas;
    SET jugadorNegras = NEW.idJugadorNegras;
    SET torneo = NEW.idTorneo;
    
    SELECT COUNT(*) INTO contador
    FROM inscripcion
    WHERE idJugador = jugadorBlancas AND idTorneo = torneo;
    IF contador = 0 THEN
        SIGNAL SQLSTATE '45043' 
            SET MESSAGE_TEXT = 'El jugador de las blancas no está inscrito en el torneo';
    END IF;

    SELECT COUNT(*) INTO contador
    FROM inscripcion
    WHERE idJugador = jugadorNegras AND idTorneo = torneo;
    IF contador = 0 THEN
        SIGNAL SQLSTATE '45033' 
            SET MESSAGE_TEXT = 'El jugador de las negras no está inscrito en el torneo';
    END IF;
END$$


DELIMITER ;

SHOW TRIGGERS FROM chessdb_new;