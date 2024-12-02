
DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`%` PROCEDURE `AgregarGanadero` (IN `p_razonsocial` VARCHAR(100), IN `p_nombre` VARCHAR(150), IN `p_psg` VARCHAR(12), IN `p_domicilio` VARCHAR(150), IN `p_codigo_postal` INT)   BEGIN
    INSERT INTO Ganaderos (razonsocial, nombre, psg, domicilio, codigo_postal)
    VALUES (p_razonsocial, p_nombre, p_psg, p_domicilio, p_codigo_postal);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `CalcularGasto` (`p_FechaEntrada` DATE, `p_FechaVenta` DATE, OUT `p_Gasto` DECIMAL(10,2))   BEGIN
    SET p_Gasto = GastoDietaFinal(p_FechaEntrada, p_FechaVenta);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `ComprarAlimento` (IN `p_CantidadMaiz` INT, IN `p_CantidadSalvado` INT, IN `p_CantidadSoya` INT, IN `p_CantidadMelaza` INT, IN `p_CantidadSal` INT, IN `p_CantidadMinerales` INT, IN `p_CantidadRastrojo` INT)   BEGIN
    START TRANSACTION;

    UPDATE Alimentos
    SET
        Cantidad = Cantidad +
            CASE
                WHEN id_alimento = 1 THEN p_CantidadMaiz
                WHEN id_alimento = 2 THEN p_CantidadSalvado
                WHEN id_alimento = 3 THEN p_CantidadSoya
                WHEN id_alimento = 4 THEN p_CantidadMelaza
                WHEN id_alimento = 5 THEN p_CantidadSal
                WHEN id_alimento = 6 THEN p_CantidadMinerales
                WHEN id_alimento = 7 THEN p_CantidadRastrojo
            END
    WHERE
        id_alimento IN (1, 2, 3, 4, 5, 6, 7);

    SET @montoTotal = (
        (p_CantidadMaiz * 50) +
        (p_CantidadSalvado * 50) +
        (p_CantidadSoya * 30) +
        (p_CantidadMelaza * 70) +
        (p_CantidadSal * 15) +
        (p_CantidadMinerales * 90) +
        (p_CantidadRastrojo * 100)
    );

    INSERT INTO Caja (FechaOperacion, TipoOperacion, Monto)
    VALUES (NOW(), 'Gasto', @montoTotal);

    COMMIT;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `ComprarLote` (IN `p_RazonSocial` VARCHAR(255), IN `p_FechaEntrada` DATE, IN `p_PesoLote` DECIMAL(10,2), IN `p_PrecioKilo` DECIMAL(10,2), IN `p_CantidadAnimales` INT)   BEGIN
    DECLARE v_PrecioTotal DECIMAL(10,2);
    DECLARE v_GastoDietaFinal DECIMAL(10,2);

    -- Calcular el precio total
    SET v_PrecioTotal = p_PesoLote * p_PrecioKilo;

    -- Calcular GastoDietaFinal
    SET v_GastoDietaFinal = p_PesoLote * p_PrecioKilo;

    -- Insertar en la tabla Lotes
    INSERT INTO Lotes (Razonsocial, CantidadAnimales, PesoLote, PrecioKilo, FechaEntrada, PrecioTotal, GastoDietaFinal)
    VALUES (p_RazonSocial, p_CantidadAnimales, p_PesoLote, p_PrecioKilo, p_FechaEntrada, v_PrecioTotal, v_GastoDietaFinal);

    -- Actualizar la suma de gastos de dieta
    INSERT INTO ResumenGastos (Fecha, Tipo, Monto)
    VALUES (p_FechaEntrada, 'Dieta', v_GastoDietaFinal)
    ON DUPLICATE KEY UPDATE Monto = Monto + VALUES(Monto);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `EliminarEmpleado` (IN `p_IdEmpleado` INT)   BEGIN
    IF EXISTS (SELECT 1 FROM Empleados WHERE Id_empleado = p_IdEmpleado) THEN
        DELETE FROM Empleados WHERE Id_empleado = p_IdEmpleado;
        SELECT 'Empleado eliminado correctamente.' AS Mensaje;
    ELSE
        SELECT 'No se encontró.' AS Mensaje;
    END IF;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `EliminarGanadero` (IN `p_razonSocial` VARCHAR(100))   BEGIN
    DECLARE exit handler for sqlexception
    BEGIN
    
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM Lotes WHERE Razonsocial = p_razonSocial;

    DELETE FROM Ganaderos WHERE razonsocial = p_razonSocial;

    COMMIT;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `GastoDieta1` ()   BEGIN
    DECLARE maiz INT;
    DECLARE salvado INT;
    DECLARE soya INT;
    DECLARE melaza INT;
    DECLARE sal INT;
    DECLARE minerales INT;
    DECLARE rastrojo INT;
    DECLARE totalGasto DECIMAL(10, 2);

    SELECT
        Maiz, Salvado, Soya, Melaza, Sal, Minerales, Rastrojo
    INTO
        maiz, salvado, soya, melaza, sal, minerales, rastrojo
    FROM
        Dieta
    WHERE
        Id_dieta = 1;

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 15
    WHERE
        Id_alimento = 1; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 20
    WHERE
        Id_alimento = 2; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 10
    WHERE
        Id_alimento = 3; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 20
    WHERE
        Id_alimento = 4; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 20
    WHERE
        Id_alimento = 5; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 15
    WHERE
        Id_alimento = 6;

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 20
    WHERE
        Id_alimento = 7; 

    SET totalGasto = (15 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 1)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 2)) +
                    (10 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 3)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 4)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 5)) +
                    (15 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 6)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 7));

    INSERT INTO Caja (FechaOperacion, TipoOperacion, Monto)
    VALUES (NOW(), 'gasto', totalGasto);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `GastoDieta2` ()   BEGIN
    DECLARE maiz INT;
    DECLARE salvado INT;
    DECLARE soya INT;
    DECLARE melaza INT;
    DECLARE sal INT;
    DECLARE minerales INT;
    DECLARE rastrojo INT;
    DECLARE totalGasto DECIMAL(10, 2);

    SELECT
        Maiz, Salvado, Soya, Melaza, Sal, Minerales, Rastrojo
    INTO
        maiz, salvado, soya, melaza, sal, minerales, rastrojo
    FROM
        Dieta
    WHERE
        Id_dieta = 1;

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 15
    WHERE
        Id_alimento = 1; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 20
    WHERE
        Id_alimento = 2; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 10
    WHERE
        Id_alimento = 3; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 20
    WHERE
        Id_alimento = 4; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 20
    WHERE
        Id_alimento = 5; 

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 15
    WHERE
        Id_alimento = 6;

    UPDATE Alimentos
    SET
        Cantidad = Cantidad - 20
    WHERE
        Id_alimento = 7; 

    SET totalGasto = (15 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 1)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 2)) +
                    (10 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 3)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 4)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 5)) +
                    (15 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 6)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 7));

    INSERT INTO Caja (FechaOperacion, TipoOperacion, Monto)
    VALUES (NOW(), 'gasto', totalGasto);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `InsertarEmpleado` (IN `p_nombre` VARCHAR(255), IN `p_paterno` VARCHAR(255), IN `p_materno` VARCHAR(255), IN `p_edad` INT, IN `p_id_puesto` INT)   BEGIN
    INSERT INTO Empleados (Nombre, Paterno, Materno, Edad, Id_puesto)
    VALUES (p_nombre, p_paterno, p_materno, p_edad, p_id_puesto);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `InsertarVacuna` (IN `p_nombre` VARCHAR(255), IN `p_cantidad` INT, IN `p_PrecioUni` DECIMAL(10,2))   BEGIN
    INSERT INTO Vacunas (nombre, cantidad, PrecioUni)
    VALUES (p_nombre, p_cantidad, p_PrecioUni);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `VenderLote` (IN `p_IdLote` INT, IN `p_PrecioKilo` DECIMAL(10,2), IN `p_AnimalesVenta` INT)   BEGIN
    DECLARE totalGasto DECIMAL(10, 2);
    DECLARE peso DECIMAL(10, 2);

    SET totalGasto = (15 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 1)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 2)) +
                    (10 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 3)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 4)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 5)) +
                    (15 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 6)) +
                    (20 * (SELECT PrecioUni FROM Alimentos WHERE Id_alimento = 7));

    SELECT PesoLote + (0.70 * DATEDIFF(NOW(), FechaEntrada)) INTO peso
    FROM Lotes
    WHERE Id_lote = p_IdLote;

    START TRANSACTION;

    INSERT INTO Ventas (Id_lote, FechaVenta, GastoDieta, Peso, PrecioKilo, PrecioTotal, AnimalesVenta)
    VALUES (p_IdLote, NOW(), totalGasto, peso, p_PrecioKilo, peso * p_PrecioKilo, p_AnimalesVenta);

    INSERT INTO Caja (FechaOperacion, TipoOperacion, Monto)
    VALUES (NOW(), 'Venta', peso * p_PrecioKilo);

    UPDATE Lotes
    SET
        CantidadAnimales = CantidadAnimales - p_AnimalesVenta
    WHERE
        Id_lote = p_IdLote;

    COMMIT;
END$$

DELIMITER ;
