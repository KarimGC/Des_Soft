-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: db
-- Tiempo de generación: 02-12-2024 a las 09:48:43
-- Versión del servidor: 8.0.40
-- Versión de PHP: 8.2.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `Ganaderia`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`%` PROCEDURE `AgregarGanadero` (IN `p_razonsocial` VARCHAR(100), IN `p_nombre` VARCHAR(150), IN `p_psg` VARCHAR(12), IN `p_domicilio` VARCHAR(150), IN `p_codigo_postal` INT, IN `p_municipio` VARCHAR(50), IN `p_estado` VARCHAR(50), IN `p_localidad` VARCHAR(100))   BEGIN
    INSERT INTO Ganaderos (razonsocial, nombre, psg, domicilio, codigo_postal, Municipio, Estado, Localidad)
    VALUES (p_razonsocial, p_nombre, p_psg, p_domicilio, p_codigo_postal, p_municipio, p_estado, p_localidad);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `CalcularGasto` (`p_FechaEntrada` DATE, `p_FechaVenta` DATE, OUT `p_Gasto` DECIMAL(10,2))   BEGIN
    SET p_Gasto = GastoDietaFinal(p_FechaEntrada, p_FechaVenta);
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `ComprarAlimento` (IN `p_CantidadMaiz` INT, IN `p_CantidadSalvado` INT, IN `p_CantidadSoya` INT, IN `p_CantidadMelaza` INT, IN `p_CantidadZilpaterol` INT, IN `p_CantidadMinerales` INT, IN `p_CantidadRastrojo` INT, IN `p_CantidadRolado` INT, IN `p_CantidadAlfalfa` INT, IN `p_CantidadUrea` INT, IN `p_CantidadElectro` INT)   BEGIN
    START TRANSACTION;

    UPDATE Alimentos
    SET
        Cantidad = Cantidad +
            CASE
                WHEN id_alimento = 1 THEN p_CantidadMaiz
                WHEN id_alimento = 2 THEN p_CantidadSalvado
                WHEN id_alimento = 3 THEN p_CantidadSoya
                WHEN id_alimento = 4 THEN p_CantidadMelaza
                WHEN id_alimento = 5 THEN p_CantidadZilpaterol
                WHEN id_alimento = 6 THEN p_CantidadMinerales
                WHEN id_alimento = 7 THEN p_CantidadRastrojo
                WHEN id_alimento = 8 THEN p_CantidadRolado
                WHEN id_alimento = 9 THEN p_CantidadAlfalfa
                WHEN id_alimento = 10 THEN p_CantidadUrea
                WHEN id_alimento = 11 THEN p_CantidadElectro
            END
    WHERE
        id_alimento IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);

    SET @montoTotal = (
        (p_CantidadMaiz * 50) +
        (p_CantidadSalvado * 50) +
        (p_CantidadSoya * 30) +
        (p_CantidadMelaza * 70) +
        (p_CantidadZilpaterol * 15) +
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

CREATE DEFINER=`root`@`%` PROCEDURE `ComprarVacuna` (IN `p_CantidadVacuna` INT, IN `p_CantidadDespa` INT, IN `p_CantidadVitamns` INT)   BEGIN
    START TRANSACTION;

    UPDATE Vacunas
    SET
        cantidad = cantidad +
            CASE
                WHEN id_vacuna = 1 THEN p_CantidadVacuna
                WHEN id_vacuna = 2 THEN p_CantidadDespa
                WHEN id_vacuna = 3 THEN p_CantidadVitamns
            END
    WHERE
        id_vacuna IN (1, 2, 3);

    COMMIT;
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Alimentos`
--

CREATE TABLE `Alimentos` (
  `id_alimento` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int NOT NULL,
  `UnidadMedida` enum('kilos','toneladas') NOT NULL DEFAULT 'kilos',
  `PrecioUni` decimal(10,2) NOT NULL DEFAULT '0.00',
  `PrecioTotal` decimal(10,2) GENERATED ALWAYS AS ((`cantidad` * `PrecioUni`)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Alimentos`
--

INSERT INTO `Alimentos` (`id_alimento`, `nombre`, `cantidad`, `UnidadMedida`, `PrecioUni`) VALUES
(1, 'Maiz', 4366, 'kilos', 50.00),
(2, 'Salvado', 2190, 'kilos', 50.00),
(3, 'Soya', 46904, 'kilos', 30.00),
(4, 'Melaza', 2510, 'kilos', 70.00),
(5, 'Zilpaterol', 49373, 'kilos', 15.00),
(6, 'Minerales', 48485, 'kilos', 90.00),
(7, 'Rastrojo', 84540, 'kilos', 100.00),
(8, 'Rolado', 4163, 'kilos', 123.00),
(9, 'Alfalfa', 4163, 'kilos', 203.00),
(10, 'Urea', 1942, 'kilos', 432.00),
(11, 'Electrolito', 1044, 'kilos', 873.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Caja`
--

CREATE TABLE `Caja` (
  `Id_caja` int NOT NULL,
  `FechaOperacion` date DEFAULT NULL,
  `TipoOperacion` enum('Venta','Gasto') NOT NULL,
  `Monto` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Caja`
--

INSERT INTO `Caja` (`Id_caja`, `FechaOperacion`, `TipoOperacion`, `Monto`) VALUES
(31, '2023-12-09', 'Venta', 150000.00),
(32, '2023-12-09', 'Gasto', 7100.00),
(33, '2023-12-31', 'Venta', 1000.00),
(34, '2023-12-11', 'Gasto', 7100.00),
(35, '2023-12-11', 'Gasto', 7100.00),
(36, '2023-12-11', 'Venta', 1700.00),
(37, '2023-12-11', 'Gasto', 7100.00),
(38, '2023-12-11', 'Gasto', 7100.00),
(39, '2023-12-11', 'Venta', 500035.00),
(40, '2023-12-11', 'Gasto', 8480.00),
(41, '2023-12-11', 'Gasto', 0.00),
(42, '2023-12-11', 'Gasto', 3975.00),
(43, '2023-12-11', 'Gasto', 3975.00),
(44, '2023-12-11', 'Gasto', 3975.00),
(45, '2023-12-11', 'Gasto', 250.00),
(46, '2023-12-11', 'Venta', 500035.00),
(47, '2023-12-11', 'Venta', 50003.50),
(48, '2023-12-11', 'Gasto', 7100.00),
(49, '2023-12-11', 'Gasto', 7100.00),
(50, '2023-12-11', 'Gasto', 2000.00),
(51, '2023-12-11', 'Gasto', 2000.00),
(52, '2023-12-11', 'Gasto', 7100.00),
(53, '2023-12-12', 'Venta', 500070.00),
(54, '2023-12-12', 'Gasto', 7100.00),
(55, '2023-12-12', 'Venta', 500070.00),
(56, '2023-12-12', 'Gasto', 7100.00),
(57, '2023-12-12', 'Venta', 5035.00),
(58, '2023-12-12', 'Gasto', 7100.00),
(59, '2024-11-29', 'Gasto', 7100.00),
(60, '2024-11-28', 'Gasto', 9000.00),
(61, '2024-11-29', 'Venta', 9042.00),
(62, '2024-11-30', 'Gasto', 10286.00),
(63, '2024-11-30', 'Gasto', 10286.00),
(64, '2024-12-01', 'Gasto', 0.00),
(65, '2024-12-01', 'Gasto', 38865.00),
(66, '2024-12-01', 'Gasto', 0.00),
(67, '2024-12-01', 'Gasto', 0.00),
(68, '2024-12-01', 'Venta', 22698.00),
(69, '2024-12-01', 'Gasto', 7100.00),
(70, '2024-12-01', 'Gasto', 7100.00),
(71, '2024-12-01', 'Gasto', 2.00),
(72, '2024-12-01', 'Gasto', 0.00),
(73, '2024-12-01', 'Gasto', 10317474.00),
(74, '2024-12-01', 'Gasto', 53630192.00),
(75, '2024-12-01', 'Gasto', 423489.00),
(76, '2024-12-01', 'Gasto', 541236.00),
(77, '2024-12-02', 'Gasto', 469695.00),
(78, '2024-12-03', 'Gasto', 124499.00),
(79, '2024-12-04', 'Gasto', 3961461.00),
(80, '2024-12-02', 'Gasto', 384.00),
(81, '2024-12-02', 'Gasto', 0.00),
(82, '2024-12-04', 'Gasto', 384.00),
(83, '2024-12-04', 'Gasto', 384.00),
(84, '2024-12-09', 'Gasto', 1533862.00),
(85, '2024-12-02', 'Gasto', 262482.00),
(86, '2024-12-02', 'Gasto', 243000.00),
(87, '2024-12-02', 'Gasto', 188200.00),
(88, '2024-12-02', 'Gasto', 0.00),
(89, '2024-12-01', 'Gasto', 1150000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Ciudades`
--

CREATE TABLE `Ciudades` (
  `Id_ciudad` int NOT NULL,
  `Ciudad` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_municipio` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `Ciudades`
--

INSERT INTO `Ciudades` (`Id_ciudad`, `Ciudad`, `Id_municipio`) VALUES
(1, 'Yuriria Cabecera', 11046),
(2, 'La Faja', 11046),
(3, 'Monte de los Juarez', 11046),
(4, 'Parangarico', 11046),
(5, 'San Andres Enguaro', 11046),
(6, 'San Francisco de la Cruz', 11046),
(7, 'La Purisima', 11046),
(8, 'Tierra Blanca', 11046),
(9, 'Orucuaro', 11046),
(10, 'San Miguel el Alto (San Miguelito)', 11046),
(11, 'San Jose de Gracia', 11046),
(12, 'Ochomitas', 11046),
(13, 'El Palo Dusal', 11046),
(14, 'San Pablo Casacuaran', 11046),
(15, 'Puerto de Porullo', 11046),
(16, 'Tinaja de Pastores', 11046),
(17, 'Porullo', 11046),
(18, 'Zapotitos', 11046),
(19, 'Ejido de Parangarico (La Y Griega)', 11046),
(21, 'La Mojonera', 11046),
(22, 'Las Rosas', 11046),
(23, 'Malpais', 11046),
(24, 'Martin Checa', 11046),
(25, 'Puesto de Agua Fria (La Mojina)', 11046),
(26, 'Rancho de Geras', 11046),
(27, 'San Gregorio', 11046),
(28, 'San Cayetano', 11046),
(29, 'La Angostura', 11046),
(30, 'Loma de Zempoala', 11046),
(31, 'El Granjenal', 11046),
(32, 'Mexico', 11046),
(33, 'El Pochote', 11046),
(34, 'La Hacienda de la Flor', 11046),
(35, 'Los Tepetates', 11046),
(36, 'Santa Rosa', 11046),
(37, 'Santiaguillo', 11046),
(38, 'El Tigre', 11046),
(39, 'Palo Alto', 11046),
(40, 'San Nicolas Cuerunero', 11046),
(41, 'Xoconoxtle', 11046),
(42, 'El Cimental (Hacienda del Cimental)', 11046),
(43, 'Cuerunero', 11046),
(44, 'Providencia de Cuerunero', 11046),
(45, 'San Vicente Zapote', 11046),
(46, 'Buenavista de la Libertad', 11046),
(47, 'Del Armadillo', 11046),
(48, 'El Bosque', 11046),
(49, 'El Pastor', 11046),
(51, 'La Soledad de Cuerunero', 11046),
(52, 'Ojos de Agua de Cordoba', 11046),
(53, 'San Gabriel', 11046),
(54, 'San Vicente Joyuela', 11046),
(55, 'San Vicente Sabino', 11046),
(56, 'San Vicente Sabino Dos', 11046),
(57, 'Puquichapio', 11046),
(58, 'Cahuilote', 11046),
(59, 'El Velador', 11046),
(60, 'La Punta (Montecillo y Punta)', 11046),
(61, 'Potrero Nuevo', 11046),
(62, 'San Vicente Cienega', 11046),
(63, 'Agua Fria', 11046),
(64, 'La Tinaja del Coyote', 11046),
(65, 'El Timbinal', 11046),
(66, 'Rancho Viejo de Pastores', 11046),
(67, 'Canada de Pastores', 11046),
(68, 'Las Crucitas', 11046),
(69, 'El Salteador', 11046),
(70, 'La Pila', 11046),
(71, 'Espanita', 11046),
(72, 'Las Rosas (La Mina)', 11046),
(73, 'San Aparicio', 11046),
(74, 'Santa Lucia', 11046),
(75, 'Tejocote de Pastores', 11046),
(76, 'Zepeda', 11046),
(77, 'La Calera', 11046),
(78, 'El Canario', 11046),
(79, 'Cerano (San Juan Cerano)', 11046),
(80, 'Tejocote de Calera', 11046),
(81, 'San Andres Calera', 11046),
(82, 'San Isidro Calera', 11046),
(83, 'San Jose Otonguitiro', 11046),
(84, 'El Sauz', 11046),
(85, 'Los Alcantar', 11046),
(86, 'Merino', 11046),
(87, 'Providencia de Calera', 11046),
(88, 'Buenavista (Buena Vista de Cerano)', 11046),
(89, 'Cerecuaro', 11046),
(90, 'Las Mesas', 11046),
(91, 'La Cruz del Nino', 11046),
(92, 'Corrales', 11046),
(93, 'San Felipe', 11046),
(94, 'Jacales', 11046),
(95, 'Aragon', 11046),
(96, 'Ojos de Agua de Cerano', 11046),
(97, 'San Antonio', 11046),
(98, 'Puerto del aguila', 11046),
(99, 'El Moro', 11046),
(100, 'Laguna Prieta', 11046),
(101, 'Ocurio', 11046),
(102, 'Juan Lucas', 11046),
(103, 'El Moralito', 11046),
(104, 'Puerta de Cerano', 11046),
(105, 'El Moral', 11046),
(106, 'Santa Monica Ozumbilla', 11046),
(107, 'Abasolo', 11046),
(108, 'Acambaro', 11046),
(109, 'Apaseo el Alto', 11046),
(110, 'Apaseo el Grande', 11046),
(111, 'Atarjea', 11046),
(112, 'Celaya', 11046),
(113, 'Ciudad Manuel Doblado', 11046),
(114, 'Comonfort', 11046),
(115, 'Coroneo', 11046),
(116, 'Cortazar', 11046),
(117, 'Cueramaro', 11046),
(118, 'Doctor Mora', 11046),
(119, 'Dolores Hidalgo', 11046),
(120, 'Empalme Escobedo', 11046),
(121, 'Guanajuato', 11046),
(122, 'Huanimaro', 11046),
(123, 'Irapuato', 11046),
(124, 'Jaral del Progreso', 11046),
(125, 'Jerecuaro', 11046),
(126, 'Leon', 11046),
(127, 'Leon de los Aldama', 11046),
(128, 'Manuel Doblado', 11046),
(129, 'Marfil', 11046),
(130, 'Moroleon', 11046),
(131, 'Ocampo', 11046),
(132, 'Pueblo Nuevo', 11046),
(133, 'Purisima de Bustos', 11046),
(134, 'Purisima del Rincon', 11046),
(135, 'Penjamo', 11046),
(136, 'Rincon de Tamayo', 11046),
(137, 'Romita', 11046),
(138, 'Salamanca', 11046),
(139, 'Salvatierra', 11046),
(140, 'San Diego de la Union', 11046),
(141, 'San Felipe', 11046),
(142, 'San Francisco del Rincon', 11046),
(143, 'San Jose Iturbide', 11046),
(144, 'San Luis de la Paz', 11046),
(145, 'San Miguel de Allende', 11046),
(146, 'Santa Catarina', 11046),
(147, 'Santa Cruz Juventino Rosas', 11046),
(148, 'Santa Cruz de Juventino Rosas', 11046),
(149, 'Santiago Maravatio', 11046),
(150, 'Silao', 11046),
(151, 'Silao de la Victoria', 11046),
(152, 'Tarandacuao', 11046),
(153, 'Tarimoro', 11046),
(154, 'Tierra Blanca', 11046),
(155, 'Uriangato', 11046),
(156, 'Valle de Santiago', 11046),
(157, 'Victoria', 11046),
(158, 'Villagran', 11046),
(159, 'Xichu', 11046);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `CompraAlim`
--

CREATE TABLE `CompraAlim` (
  `id_compralim` int NOT NULL,
  `id_alimento` int NOT NULL,
  `cantidadcompra` int NOT NULL,
  `preciouni` decimal(10,2) NOT NULL,
  `preciototal` decimal(10,2) GENERATED ALWAYS AS ((`cantidadcompra` * `preciouni`)) STORED,
  `fecha_compra` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `CompraAlim`
--

INSERT INTO `CompraAlim` (`id_compralim`, `id_alimento`, `cantidadcompra`, `preciouni`, `fecha_compra`) VALUES
(1, 1, 20, 100.00, '2023-12-06'),
(2, 1, 20, 100.00, '2023-12-06'),
(3, 1, 100, 15.00, '2023-01-01');

--
-- Disparadores `CompraAlim`
--
DELIMITER $$
CREATE TRIGGER `after_insert_CompraAlim` AFTER INSERT ON `CompraAlim` FOR EACH ROW BEGIN
  UPDATE Alimentos
  SET cantidad = cantidad + NEW.cantidadcompra
  WHERE id_alimento = NEW.id_alimento;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `caja_CompraAlim` AFTER INSERT ON `CompraAlim` FOR EACH ROW BEGIN
    DECLARE totalGasto DECIMAL(10, 2);
    
    SELECT SUM(preciototal) INTO totalGasto
    FROM CompraAlim
    WHERE fecha_compra = NEW.fecha_compra;
    
    INSERT INTO Caja (FechaOperacion, TipoOperacion, Monto)
    VALUES (NEW.fecha_compra, 'Gasto', totalGasto);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `CompraVacuna`
--

CREATE TABLE `CompraVacuna` (
  `id_compravacuna` int NOT NULL,
  `id_vacuna` int NOT NULL,
  `cantidadcompra` int NOT NULL,
  `preciouni` decimal(10,2) NOT NULL,
  `preciototal` decimal(10,2) GENERATED ALWAYS AS ((`cantidadcompra` * `preciouni`)) STORED,
  `fecha_compra` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `CompraVacuna`
--

INSERT INTO `CompraVacuna` (`id_compravacuna`, `id_vacuna`, `cantidadcompra`, `preciouni`, `fecha_compra`) VALUES
(1, 1, 20, 100.00, '2023-12-06');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `CP`
--

CREATE TABLE `CP` (
  `CodigoPostal` int NOT NULL,
  `Colonia` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Id_ciudad` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `CP`
--

INSERT INTO `CP` (`CodigoPostal`, `Colonia`, `Id_ciudad`) VALUES
(27381, NULL, NULL),
(36100, 'Silao', 150),
(36210, 'Romita', 137),
(36220, 'Guanajuato', 121),
(36250, 'Marfil', 129),
(36270, 'Silao de la Victoria', 151),
(36400, 'Purisima de Bustos', 133),
(36420, 'Purisima del Rincon', 134),
(36440, 'San Francisco del Rincon', 142),
(36470, 'Ciudad Manuel Doblado', 113),
(36480, 'Manuel Doblado', 128),
(36800, 'Irapuato', 123),
(36850, 'Salamanca', 138),
(36890, 'Pueblo Nuevo', 132),
(36910, 'Penjamo', 135),
(36963, 'Cueramaro', 117),
(36980, 'Abasolo', 107),
(36996, 'Huanimaro', 122),
(37000, 'Leon de los Aldama', 127),
(37600, 'San Felipe', 141),
(37630, 'Ocampo', 131),
(37650, 'Leon', 126),
(37713, 'San Miguel de Allende', 145),
(37810, 'Dolores Hidalgo', 119),
(37860, 'San Diego de la Union', 140),
(37913, 'San Luis de la Paz', 144),
(37920, 'Victoria', 157),
(37930, 'Xichu', 159),
(37940, 'Atarjea', 111),
(37950, 'Santa Catarina', 146),
(37965, 'Doctor Mora', 118),
(37970, 'Tierra Blanca', 154),
(37986, 'San Jose Iturbide', 143),
(38100, 'Celaya', 112),
(38150, 'Rincon de Tamayo', 136),
(38170, 'Apaseo el Grande', 110),
(38205, 'Comonfort', 114),
(38210, 'Empalme Escobedo', 120),
(38240, 'Santa Cruz Juventino Rosas', 147),
(38250, 'Santa Cruz de Juventino Rosas', 148),
(38263, 'Villagran', 158),
(38410, 'Valle de Santiago', 156),
(38480, 'Jaral del Progreso', 124),
(38490, 'Cortazar', 116),
(38510, 'Apaseo el Alto', 109),
(38550, 'Jerecuaro', 125),
(38590, 'Coroneo', 115),
(38700, 'Tarimoro', 153),
(38730, 'Acambaro', 108),
(38795, 'Tarandacuao', 152),
(38845, 'Moroleon', 130),
(38903, 'Salvatierra', 139),
(38940, 'Yuriria Centro', 1),
(38943, 'Barrio De Tareta', 1),
(38944, 'Campestre-Yacatitas', 1),
(38945, 'Joya-Deportiva', 1),
(38946, 'La Aldea', 1),
(38947, 'Santa Maria-Guadalupana', 1),
(38950, 'Ochomitas,Parangarico,San Andres, San Francisco, Tierra Blanca, San Miguelito', 5),
(38953, 'Pueblo San Pablo Casacuaran', 14),
(38954, 'Porullo, Tinaja, Zapotitos, SanGregorio, SanCayetano', 15),
(38955, 'Angostura, Loma, Tepetates, Santiaguillo, El Tigre, Granjenal, Hacienda de la Flor', 29),
(38956, 'Palo Alto, San Nicolas, El cimental, Cuerunero, San Vicente, Ojos de Agua, San Gabriel, Puquichapio', 39),
(38957, 'Tejocote, Calera, Canario, Cerano', 79),
(38958, ' San Andres Calera, Otonguitiro, Cerecuaro, San Felipe, Las mesas, Jacales, Corrales', 81),
(38960, 'Aragon, Ojos de Agua de Cerano', 96),
(38961, 'Colonia San Antonio, Cerano', 79),
(38963, 'Puerto del Aguila, El Moro, Laguna Prieta, Ocurio, Juan Lucas, El Moralito, Puerta de Cerano', 98),
(38964, 'Santa Monica Ozumbila, La Yacata', 106),
(38973, 'Santiago Maravatio', 149),
(38985, 'Uriangato', 155);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Dieta`
--

CREATE TABLE `Dieta` (
  `Id_dieta` int NOT NULL,
  `Nombre` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Dieta`
--

INSERT INTO `Dieta` (`Id_dieta`, `Nombre`) VALUES
(1, 'Crecimiento'),
(2, 'Engorda');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Dieta_A`
--

CREATE TABLE `Dieta_A` (
  `id_alimento` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int NOT NULL,
  `UnidadMedida` enum('kilos','toneladas','gramos') NOT NULL DEFAULT 'kilos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Dieta_A`
--

INSERT INTO `Dieta_A` (`id_alimento`, `nombre`, `cantidad`, `UnidadMedida`) VALUES
(1, 'Maiz', 100, 'kilos'),
(2, 'Salvado', 0, 'kilos'),
(3, 'Soya', 0, 'kilos'),
(4, 'Melaza', 0, 'kilos'),
(5, 'Zilpaterol', 0, 'gramos'),
(6, 'Minerales', 0, 'kilos'),
(7, 'Rastrojo', 850, 'kilos'),
(8, 'Rolado', 0, 'kilos'),
(9, 'Alfalfa', 0, 'kilos'),
(10, 'Urea', 0, 'kilos'),
(11, 'Electrolito', 10, 'kilos'),
(12, 'Sal', 40, 'kilos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Dieta_D`
--

CREATE TABLE `Dieta_D` (
  `id_alimento` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int NOT NULL,
  `UnidadMedida` enum('kilos','toneladas','gramos') NOT NULL DEFAULT 'kilos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Dieta_D`
--

INSERT INTO `Dieta_D` (`id_alimento`, `nombre`, `cantidad`, `UnidadMedida`) VALUES
(1, 'Maiz', 350, 'kilos'),
(2, 'Salvado', 50, 'kilos'),
(3, 'Soya', 100, 'kilos'),
(4, 'Melaza', 30, 'kilos'),
(5, 'Zilpaterol', 0, 'gramos'),
(6, 'Minerales', 20, 'kilos'),
(7, 'Rastrojo', 200, 'kilos'),
(8, 'Rolado', 200, 'kilos'),
(9, 'Alfalfa', 50, 'kilos'),
(10, 'Urea', 5, 'kilos'),
(11, 'Electrolito', 0, 'kilos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Dieta_E`
--

CREATE TABLE `Dieta_E` (
  `id_alimento` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int NOT NULL,
  `UnidadMedida` enum('kilos','toneladas','gramos') NOT NULL DEFAULT 'kilos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Dieta_E`
--

INSERT INTO `Dieta_E` (`id_alimento`, `nombre`, `cantidad`, `UnidadMedida`) VALUES
(1, 'Maiz', 250, 'kilos'),
(2, 'Salvado', 50, 'kilos'),
(3, 'Soya', 100, 'kilos'),
(4, 'Melaza', 30, 'kilos'),
(5, 'Zilpaterol', 0, 'gramos'),
(6, 'Minerales', 20, 'kilos'),
(7, 'Rastrojo', 200, 'kilos'),
(8, 'Rolado', 300, 'kilos'),
(9, 'Alfalfa', 50, 'kilos'),
(10, 'Urea', 5, 'kilos'),
(11, 'Electrolito', 0, 'kilos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Dieta_F`
--

CREATE TABLE `Dieta_F` (
  `id_alimento` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int NOT NULL,
  `UnidadMedida` enum('kilos','toneladas','gramos') NOT NULL DEFAULT 'kilos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Dieta_F`
--

INSERT INTO `Dieta_F` (`id_alimento`, `nombre`, `cantidad`, `UnidadMedida`) VALUES
(1, 'Maiz', 300, 'kilos'),
(2, 'Salvado', 50, 'kilos'),
(3, 'Soya', 50, 'kilos'),
(4, 'Melaza', 30, 'kilos'),
(5, 'Zilpaterol', 125, 'gramos'),
(6, 'Minerales', 20, 'kilos'),
(7, 'Rastrojo', 200, 'kilos'),
(8, 'Rolado', 300, 'kilos'),
(9, 'Alfalfa', 50, 'kilos'),
(10, 'Urea', 5, 'kilos'),
(11, 'Electrolito', 0, 'kilos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Dieta_Historial`
--

CREATE TABLE `Dieta_Historial` (
  `id_historial` int NOT NULL,
  `REEMO` varchar(100) NOT NULL,
  `Fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Dieta_I`
--

CREATE TABLE `Dieta_I` (
  `id_alimento` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int NOT NULL,
  `UnidadMedida` enum('kilos','toneladas','gramos') NOT NULL DEFAULT 'kilos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Dieta_I`
--

INSERT INTO `Dieta_I` (`id_alimento`, `nombre`, `cantidad`, `UnidadMedida`) VALUES
(1, 'Maiz', 320, 'kilos'),
(2, 'Salvado', 50, 'kilos'),
(3, 'Soya', 100, 'kilos'),
(4, 'Melaza', 30, 'kilos'),
(5, 'Zilpaterol', 0, 'gramos'),
(6, 'Minerales', 20, 'kilos'),
(7, 'Rastrojo', 250, 'kilos'),
(8, 'Rolado', 200, 'kilos'),
(9, 'Alfalfa', 50, 'kilos'),
(10, 'Urea', 5, 'kilos'),
(11, 'Electrolito', 0, 'kilos');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Empleados`
--

CREATE TABLE `Empleados` (
  `Id_empleado` int NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `Paterno` varchar(50) NOT NULL,
  `Materno` varchar(50) NOT NULL,
  `Edad` int NOT NULL,
  `Id_puesto` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Estados`
--

CREATE TABLE `Estados` (
  `Id_estado` int NOT NULL,
  `Estado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `Estados`
--

INSERT INTO `Estados` (`Id_estado`, `Estado`) VALUES
(1, 'Aguascalientes'),
(2, 'Baja California'),
(3, 'Baja California Sur'),
(4, 'Campeche'),
(5, 'Coahuila de Zaragoza'),
(6, 'Colima'),
(7, 'Chiapas'),
(8, 'Chihuahua'),
(9, 'Ciudad de Mexico'),
(10, 'Durango'),
(11, 'Guanajuato'),
(12, 'Guerrero'),
(13, 'Hidalgo'),
(14, 'Jalisco'),
(15, 'Mexico'),
(16, 'Michoacan'),
(17, 'Morelos'),
(18, 'Nayarit'),
(19, 'Nuevo Leon'),
(20, 'Oaxaca'),
(21, 'Puebla'),
(22, 'Queretaro'),
(23, 'Quintana Roo'),
(24, 'San Luis Potosi'),
(25, 'Sinaloa'),
(26, 'Sonora'),
(27, 'Tabasco'),
(28, 'Tamaulipas'),
(29, 'Tlaxcala'),
(30, 'Veracruz '),
(31, 'Yucatan'),
(32, 'Zacatecas');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Etapas`
--

CREATE TABLE `Etapas` (
  `Id_etapa` int NOT NULL,
  `Etapa` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Etapas`
--

INSERT INTO `Etapas` (`Id_etapa`, `Etapa`) VALUES
(1, 'Iniciación'),
(2, 'Engorda');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Ganaderos`
--

CREATE TABLE `Ganaderos` (
  `id_ganadero` int NOT NULL,
  `razonsocial` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nombre` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `psg` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `domicilio` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `codigo_postal` int NOT NULL,
  `Municipio` varchar(100) DEFAULT NULL,
  `Estado` varchar(100) DEFAULT NULL,
  `Localidad` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Ganaderos`
--

INSERT INTO `Ganaderos` (`id_ganadero`, `razonsocial`, `nombre`, `psg`, `domicilio`, `codigo_postal`, `Municipio`, `Estado`, `Localidad`) VALUES
(34, 'Rancho La Paz', 'Martín Contreras', 'MC12AJH45AS1', 'Octavio Paz', 38964, NULL, NULL, NULL),
(35, 'Rancho la Unión', 'Omar Santoyo', 'OS12AJH45AS1', 'Centro', 38150, NULL, NULL, NULL),
(38, 'El poder', 'Martín Contreras', 'FA12AJH45AS1', 'La aldea', 38946, NULL, NULL, NULL),
(40, 'El dorado2', 'Martín Contreras', '1412AEF45A34', 'La aldea', 38940, NULL, NULL, NULL),
(45, 'Rancho los Ahuahuetes', 'Karim Garcia', 'MC12AJH45AZ1', 'Fray Miguel 23A ', 38940, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Lotes`
--

CREATE TABLE `Lotes` (
  `Id_lote` int NOT NULL,
  `PesoLote` decimal(10,2) NOT NULL,
  `PrecioKilo` decimal(10,2) NOT NULL,
  `FechaEntrada` date NOT NULL,
  `Razonsocial` varchar(100) NOT NULL,
  `PrecioTotal` decimal(10,2) GENERATED ALWAYS AS ((`PesoLote` * `PrecioKilo`)) STORED NOT NULL,
  `REEMO` varchar(50) NOT NULL,
  `Motivo` varchar(50) NOT NULL,
  `Consecutivo` varchar(50) NOT NULL,
  `Arete` varchar(50) NOT NULL,
  `Sexo` varchar(50) NOT NULL,
  `Meses` int NOT NULL,
  `Clasif` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Lotes`
--

INSERT INTO `Lotes` (`Id_lote`, `PesoLote`, `PrecioKilo`, `FechaEntrada`, `Razonsocial`, `REEMO`, `Motivo`, `Consecutivo`, `Arete`, `Sexo`, `Meses`, `Clasif`) VALUES
(1, 245.00, 65.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Cría', '2 2021', '5678', 'Macho', 30, 'Toro/Vaca'),
(2, 310.00, 55.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Engorda', '3 2019', '9101', 'Hembra', 10, 'Becerro(a)'),
(3, 400.00, 40.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Sacrificio', '4 2022', '1121', 'Macho', 20, 'Torete/Vacona'),
(4, 220.00, 30.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Engorda', '5 2023', '3141', 'Hembra', 5, 'Becerro(a)'),
(5, 300.00, 45.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Cría', '6 2020', '5161', 'Macho', 35, 'Toro/Vaca'),
(6, 270.00, 60.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Engorda', '7 2021', '7181', 'Hembra', 25, 'Toro/Vaca'),
(7, 330.00, 50.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Sacrificio', '8 2019', '9202', 'Macho', 15, 'Becerro(a)'),
(8, 290.00, 65.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Engorda', '9 2023', '1234', 'Hembra', 40, 'Toro/Vaca'),
(9, 310.00, 55.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Cría', '10 2022', '5678', 'Macho', 50, 'Toro/Vaca'),
(10, 350.00, 70.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Sacrificio', '11 2020', '9101', 'Hembra', 65, 'Toro/Vaca'),
(11, 240.00, 25.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Engorda', '12 2021', '1121', 'Macho', 12, 'Becerro(a)'),
(12, 320.00, 50.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Cría', '1 2023', '3141', 'Hembra', 18, 'Torete/Vacona'),
(34, 230.00, 5000.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Engord', '2 2020', '8293', 'Hembra', 15, 'Becerro(a)'),
(35, 230.00, 50.00, '2024-12-01', 'Rancho los Ahuahuetes', 'HDJ93NC29', 'Engorda', '1 2020', '1234', 'Hembra', 15, 'Becerro(a)'),
(36, 310.00, 55.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Engorda', '3 2019', '9101', 'Hembra', 10, 'Becerro(a)'),
(37, 400.00, 40.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Sacrificio', '4 2022', '1121', 'Macho', 20, 'Torete/Vacona'),
(38, 220.00, 30.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Engorda', '5 2023', '3141', 'Hembra', 5, 'Becerro(a)'),
(39, 300.00, 45.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Cría', '6 2020', '5161', 'Macho', 35, 'Toro/Vaca'),
(40, 270.00, 60.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Engorda', '7 2021', '7181', 'Hembra', 25, 'Toro/Vaca'),
(41, 330.00, 50.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Sacrificio', '8 2019', '9202', 'Macho', 15, 'Becerro(a)'),
(42, 290.00, 65.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Engorda', '9 2023', '1234', 'Hembra', 40, 'Toro/Vaca'),
(43, 310.00, 55.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Cría', '10 2022', '5678', 'Macho', 50, 'Toro/Vaca'),
(44, 350.00, 70.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Sacrificio', '11 2020', '9101', 'Hembra', 65, 'Toro/Vaca'),
(45, 240.00, 25.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Engorda', '12 2021', '1121', 'Macho', 12, 'Becerro(a)'),
(46, 320.00, 50.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Cría', '1 2023', '3141', 'Hembra', 18, 'Torete/Vacona'),
(47, 230.00, 5000.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Engord', '2 2020', '8293', 'Hembra', 15, 'Becerro(a)'),
(48, 230.00, 50.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Engorda', '1 2020', '1234', 'Hembra', 15, 'Becerro(a)'),
(49, 245.00, 65.00, '2024-12-01', 'Rancho la Unión', 'XYZ12AB34', 'Cría', '2 2021', '5678', 'Macho', 30, 'Toro/Vaca');

--
-- Disparadores `Lotes`
--
DELIMITER $$
CREATE TRIGGER `before_delete_lote` BEFORE DELETE ON `Lotes` FOR EACH ROW BEGIN
    -- Eliminar las ventas asociadas al lote que se está eliminando
    DELETE FROM Ventas WHERE Id_lote = OLD.Id_lote;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Municipios`
--

CREATE TABLE `Municipios` (
  `Id_municipio` int NOT NULL,
  `Municipio` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_estado` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `Municipios`
--

INSERT INTO `Municipios` (`Id_municipio`, `Municipio`, `Id_estado`) VALUES
(1001, 'Aguascalientes', 1),
(1002, 'Asientos', 1),
(1003, 'Calvillo', 1),
(1004, 'Cosio', 1),
(1005, 'Jesus Maria', 1),
(1006, 'Pabellon de Arteaga', 1),
(1007, 'Rincon de Romos', 1),
(1008, 'San Jose de Gracia', 1),
(1009, 'Tepezala', 1),
(1010, 'El Llano', 1),
(1011, 'San Francisco de los Romo', 1),
(2001, 'Ensenada', 2),
(2002, 'Mexicali', 2),
(2003, 'Tecate', 2),
(2004, 'Tijuana', 2),
(2005, 'Playas de Rosarito', 2),
(2006, 'San Quintin', 2),
(2007, 'San Felipe', 2),
(3001, 'Comondu', 3),
(3002, 'Mulege', 3),
(3003, 'La Paz', 3),
(3004, 'Los Cabos', 3),
(3005, 'Loreto', 3),
(4001, 'Calkini', 4),
(4002, 'Campeche', 4),
(4003, 'Carmen', 4),
(4004, 'Champoton', 4),
(4005, 'Hecelchakan', 4),
(4006, 'Hopelchen', 4),
(4007, 'Palizada', 4),
(4008, 'Tenabo', 4),
(4009, 'Escarcega', 4),
(4010, 'Calakmul', 4),
(4011, 'Candelaria', 4),
(4012, 'Seybaplaya', 4),
(5001, 'Abasolo', 5),
(5002, 'Acuna', 5),
(5003, 'Allende', 5),
(5004, 'Arteaga', 5),
(5005, 'Candela', 5),
(5006, 'Castanos', 5),
(5007, 'Cuatro Cienegas', 5),
(5008, 'Escobedo', 5),
(5009, 'Francisco I. Madero', 5),
(5010, 'Frontera', 5),
(5011, 'General Cepeda', 5),
(5012, 'Guerrero', 5),
(5013, 'Hidalgo', 5),
(5014, 'Jimenez', 5),
(5015, 'Juarez', 5),
(5016, 'Lamadrid', 5),
(5017, 'Matamoros', 5),
(5018, 'Monclova', 5),
(5019, 'Morelos', 5),
(5020, 'Muzquiz', 5),
(5021, 'Nadadores', 5),
(5022, 'Nava', 5),
(5023, 'Ocampo', 5),
(5024, 'Parras', 5),
(5025, 'Piedras Negras', 5),
(5026, 'Progreso', 5),
(5027, 'Ramos Arizpe', 5),
(5028, 'Sabinas', 5),
(5029, 'Sacramento', 5),
(5030, 'Saltillo', 5),
(5031, 'San Buenaventura', 5),
(5032, 'San Juan de Sabinas', 5),
(5033, 'San Pedro', 5),
(5034, 'Sierra Mojada', 5),
(5035, 'Torreon', 5),
(5036, 'Viesca', 5),
(5037, 'Villa Union', 5),
(5038, 'Zaragoza', 5),
(6001, 'Armeria', 6),
(6002, 'Colima', 6),
(6003, 'Comala', 6),
(6004, 'Coquimatlan', 6),
(6005, 'Cuauhtemoc', 6),
(6006, 'Ixtlahuacan', 6),
(6007, 'Manzanillo', 6),
(6008, 'Minatitlan', 6),
(6009, 'Tecoman', 6),
(6010, 'Villa de Alvarez', 6),
(7001, 'Acacoyagua', 7),
(7002, 'Acala', 7),
(7003, 'Acapetahua', 7),
(7004, 'Altamirano', 7),
(7005, 'Amatan', 7),
(7006, 'Amatenango de la Frontera', 7),
(7007, 'Amatenango del Valle', 7),
(7008, 'Angel Albino Corzo', 7),
(7009, 'Arriaga', 7),
(7010, 'Bejucal de Ocampo', 7),
(7011, 'Bella Vista', 7),
(7012, 'Berriozabal', 7),
(7013, 'Bochil', 7),
(7014, 'El Bosque', 7),
(7015, 'Cacahoatan', 7),
(7016, 'Catazaja', 7),
(7017, 'Cintalapa', 7),
(7018, 'Coapilla', 7),
(7019, 'Comitan de Dominguez', 7),
(7020, 'La Concordia', 7),
(7021, 'Copainala', 7),
(7022, 'Chalchihuitan', 7),
(7023, 'Chamula', 7),
(7024, 'Chanal', 7),
(7025, 'Chapultenango', 7),
(7026, 'Chenalho', 7),
(7027, 'Chiapa de Corzo', 7),
(7028, 'Chiapilla', 7),
(7029, 'Chicoasen', 7),
(7030, 'Chicomuselo', 7),
(7031, 'Chilon', 7),
(7032, 'Escuintla', 7),
(7033, 'Francisco Leon', 7),
(7034, 'Frontera Comalapa', 7),
(7035, 'Frontera Hidalgo', 7),
(7036, 'La Grandeza', 7),
(7037, 'Huehuetan', 7),
(7038, 'Huixtan', 7),
(7039, 'Huitiupan', 7),
(7040, 'Huixtla', 7),
(7041, 'La Independencia', 7),
(7042, 'Ixhuatan', 7),
(7043, 'Ixtacomitan', 7),
(7044, 'Ixtapa', 7),
(7045, 'Ixtapangajoya', 7),
(7046, 'Jiquipilas', 7),
(7047, 'Jitotol', 7),
(7048, 'Juarez', 7),
(7049, 'Larrainzar', 7),
(7050, 'La Libertad', 7),
(7051, 'Mapastepec', 7),
(7052, 'Las Margaritas', 7),
(7053, 'Mazapa de Madero', 7),
(7054, 'Mazatan', 7),
(7055, 'Metapa', 7),
(7056, 'Mitontic', 7),
(7057, 'Motozintla', 7),
(7058, 'Nicolas Ruiz', 7),
(7059, 'Ocosingo', 7),
(7060, 'Ocotepec', 7),
(7061, 'Ocozocoautla de Espinosa', 7),
(7062, 'Ostuacan', 7),
(7063, 'Osumacinta', 7),
(7064, 'Oxchuc', 7),
(7065, 'Palenque', 7),
(7066, 'Pantelho', 7),
(7067, 'Pantepec', 7),
(7068, 'Pichucalco', 7),
(7069, 'Pijijiapan', 7),
(7070, 'El Porvenir', 7),
(7071, 'Villa Comaltitlan', 7),
(7072, 'Pueblo Nuevo Solistahuacan', 7),
(7073, 'Rayon', 7),
(7074, 'Reforma', 7),
(7075, 'Las Rosas', 7),
(7076, 'Sabanilla', 7),
(7077, 'Salto de Agua', 7),
(7078, 'San Cristobal de las Casas', 7),
(7079, 'San Fernando', 7),
(7080, 'Siltepec', 7),
(7081, 'Simojovel', 7),
(7082, 'Sitala', 7),
(7083, 'Socoltenango', 7),
(7084, 'Solosuchiapa', 7),
(7085, 'Soyalo', 7),
(7086, 'Suchiapa', 7),
(7087, 'Suchiate', 7),
(7088, 'Sunuapa', 7),
(7089, 'Tapachula', 7),
(7090, 'Tapalapa', 7),
(7091, 'Tapilula', 7),
(7092, 'Tecpatan', 7),
(7093, 'Tenejapa', 7),
(7094, 'Teopisca', 7),
(7095, 'Tila', 7),
(7096, 'Tonala', 7),
(7097, 'Totolapa', 7),
(7098, 'La Trinitaria', 7),
(7099, 'Tumbala', 7),
(7100, 'Tuxtla Gutierrez', 7),
(7101, 'Tuxtla Chico', 7),
(7102, 'Tuzantan', 7),
(7103, 'Tzimol', 7),
(7104, 'Union Juarez', 7),
(7105, 'Venustiano Carranza', 7),
(7106, 'Villa Corzo', 7),
(7107, 'Villaflores', 7),
(7108, 'Yajalon', 7),
(7109, 'San Lucas', 7),
(7110, 'Zinacantan', 7),
(7111, 'San Juan Cancuc', 7),
(7112, 'Aldama', 7),
(7113, 'Benemerito de las Americas', 7),
(7114, 'Maravilla Tenejapa', 7),
(7115, 'Marques de Comillas', 7),
(7116, 'Montecristo de Guerrero', 7),
(7117, 'San Andres Duraznal', 7),
(7118, 'Santiago el Pinar', 7),
(7119, 'Capitan Luis Angel Vidal', 7),
(7120, 'Rincon Chamula San Pedro', 7),
(7121, 'El Parral', 7),
(7122, 'Emiliano Zapata', 7),
(7123, 'Mezcalapa', 7),
(7124, 'Honduras de la Sierra', 7),
(8001, 'Ahumada', 8),
(8002, 'Aldama', 8),
(8003, 'Allende', 8),
(8004, 'Aquiles Serdan', 8),
(8005, 'Ascension', 8),
(8006, 'Bachiniva', 8),
(8007, 'Balleza', 8),
(8008, 'Batopilas de Manuel Gomez Morin', 8),
(8009, 'Bocoyna', 8),
(8010, 'Buenaventura', 8),
(8011, 'Camargo', 8),
(8012, 'Carichi', 8),
(8013, 'Casas Grandes', 8),
(8014, 'Coronado', 8),
(8015, 'Coyame del Sotol', 8),
(8016, 'La Cruz', 8),
(8017, 'Cuauhtemoc', 8),
(8018, 'Cusihuiriachi', 8),
(8019, 'Chihuahua', 8),
(8020, 'Chinipas', 8),
(8021, 'Delicias', 8),
(8022, 'Dr. Belisario Dominguez', 8),
(8023, 'Galeana', 8),
(8024, 'Santa Isabel', 8),
(8025, 'Gomez Farias', 8),
(8026, 'Gran Morelos', 8),
(8027, 'Guachochi', 8),
(8028, 'Guadalupe', 8),
(8029, 'Guadalupe y Calvo', 8),
(8030, 'Guazapares', 8),
(8031, 'Guerrero', 8),
(8032, 'Hidalgo del Parral', 8),
(8033, 'Huejotitan', 8),
(8034, 'Ignacio Zaragoza', 8),
(8035, 'Janos', 8),
(8036, 'Jimenez', 8),
(8037, 'Juarez', 8),
(8038, 'Julimes', 8),
(8039, 'Lopez', 8),
(8040, 'Madera', 8),
(8041, 'Maguarichi', 8),
(8042, 'Manuel Benavides', 8),
(8043, 'Matachi', 8),
(8044, 'Matamoros', 8),
(8045, 'Meoqui', 8),
(8046, 'Morelos', 8),
(8047, 'Moris', 8),
(8048, 'Namiquipa', 8),
(8049, 'Nonoava', 8),
(8050, 'Nuevo Casas Grandes', 8),
(8051, 'Ocampo', 8),
(8052, 'Ojinaga', 8),
(8053, 'Praxedis G. Guerrero', 8),
(8054, 'Riva Palacio', 8),
(8055, 'Rosales', 8),
(8056, 'Rosario', 8),
(8057, 'San Francisco de Borja', 8),
(8058, 'San Francisco de Conchos', 8),
(8059, 'San Francisco del Oro', 8),
(8060, 'Santa Barbara', 8),
(8061, 'Satevo', 8),
(8062, 'Saucillo', 8),
(8063, 'Temosachic', 8),
(8064, 'El Tule', 8),
(8065, 'Urique', 8),
(8066, 'Uruachi', 8),
(8067, 'Valle de Zaragoza', 8),
(9001, 'Azcapotzalco', 9),
(9002, 'Coyoacan', 9),
(9003, 'Cuajimalpa de Morelos', 9),
(9004, 'Gustavo A. Madero', 9),
(9005, 'Iztacalco', 9),
(9006, 'Iztapalapa', 9),
(9007, 'La Magdalena Contreras', 9),
(9008, 'Milpa Alta', 9),
(9009, 'Alvaro Obregon', 9),
(9010, 'Tlahuac', 9),
(9011, 'Tlalpan', 9),
(9012, 'Xochimilco', 9),
(9013, 'Benito Juarez', 9),
(9014, 'Cuauhtemoc', 9),
(9015, 'Miguel Hidalgo', 9),
(9016, 'Venustiano Carranza', 9),
(10001, 'Canatlan', 10),
(10002, 'Canelas', 10),
(10003, 'Coneto de Comonfort', 10),
(10004, 'Cuencame', 10),
(10005, 'Durango', 10),
(10006, 'General Simon Bolivar', 10),
(10007, 'Gomez Palacio', 10),
(10008, 'Guadalupe Victoria', 10),
(10009, 'Guanacevi', 10),
(10010, 'Hidalgo', 10),
(10011, 'Inde', 10),
(10012, 'Lerdo', 10),
(10013, 'Mapimi', 10),
(10014, 'Mezquital', 10),
(10015, 'Nazas', 10),
(10016, 'Nombre de Dios', 10),
(10017, 'Ocampo', 10),
(10018, 'El Oro', 10),
(10019, 'Otaez', 10),
(10020, 'Panuco de Coronado', 10),
(10021, 'Penon Blanco', 10),
(10022, 'Poanas', 10),
(10023, 'Pueblo Nuevo', 10),
(10024, 'Rodeo', 10),
(10025, 'San Bernardo', 10),
(10026, 'San Dimas', 10),
(10027, 'San Juan de Guadalupe', 10),
(10028, 'San Juan del Rio', 10),
(10029, 'San Luis del Cordero', 10),
(10030, 'San Pedro del Gallo', 10),
(10031, 'Santa Clara', 10),
(10032, 'Santiago Papasquiaro', 10),
(10033, 'Suchil', 10),
(10034, 'Tamazula', 10),
(10035, 'Tepehuanes', 10),
(10036, 'Tlahualilo', 10),
(10037, 'Topia', 10),
(10038, 'Vicente Guerrero', 10),
(10039, 'Nuevo Ideal', 10),
(11001, 'Abasolo', 11),
(11002, 'Acambaro', 11),
(11003, 'San Miguel de Allende', 11),
(11004, 'Apaseo el Alto', 11),
(11005, 'Apaseo el Grande', 11),
(11006, 'Atarjea', 11),
(11007, 'Celaya', 11),
(11008, 'Manuel Doblado', 11),
(11009, 'Comonfort', 11),
(11010, 'Coroneo', 11),
(11011, 'Cortazar', 11),
(11012, 'Cueramaro', 11),
(11013, 'Doctor Mora', 11),
(11014, 'Dolores Hidalgo Cuna de la Independencia Nacional', 11),
(11015, 'Guanajuato', 11),
(11016, 'Huanimaro', 11),
(11017, 'Irapuato', 11),
(11018, 'Jaral del Progreso', 11),
(11019, 'Jerecuaro', 11),
(11020, 'Leon', 11),
(11021, 'Moroleon', 11),
(11022, 'Ocampo', 11),
(11023, 'Penjamo', 11),
(11024, 'Pueblo Nuevo', 11),
(11025, 'Purisima del Rincon', 11),
(11026, 'Romita', 11),
(11027, 'Salamanca', 11),
(11028, 'Salvatierra', 11),
(11029, 'San Diego de la Union', 11),
(11030, 'San Felipe', 11),
(11031, 'San Francisco del Rincon', 11),
(11032, 'San Jose Iturbide', 11),
(11033, 'San Luis de la Paz', 11),
(11034, 'Santa Catarina', 11),
(11035, 'Santa Cruz de Juventino Rosas', 11),
(11036, 'Santiago Maravatio', 11),
(11037, 'Silao de la Victoria', 11),
(11038, 'Tarandacuao', 11),
(11039, 'Tarimoro', 11),
(11040, 'Tierra Blanca', 11),
(11041, 'Uriangato', 11),
(11042, 'Valle de Santiago', 11),
(11043, 'Victoria', 11),
(11044, 'Villagran', 11),
(11045, 'Xichu', 11),
(11046, 'Yuriria', 11),
(12001, 'Acapulco de Juarez', 12),
(12002, 'Ahuacuotzingo', 12),
(12003, 'Ajuchitlan del Progreso', 12),
(12004, 'Alcozauca de Guerrero', 12),
(12005, 'Alpoyeca', 12),
(12006, 'Apaxtla', 12),
(12007, 'Arcelia', 12),
(12008, 'Atenango del Rio', 12),
(12009, 'Atlamajalcingo del Monte', 12),
(12010, 'Atlixtac', 12),
(12011, 'Atoyac de Alvarez', 12),
(12012, 'Ayutla de los Libres', 12),
(12013, 'Azoyu', 12),
(12014, 'Benito Juarez', 12),
(12015, 'Buenavista de Cuellar', 12),
(12016, 'Coahuayutla de Jose Maria Izazaga', 12),
(12017, 'Cocula', 12),
(12018, 'Copala', 12),
(12019, 'Copalillo', 12),
(12020, 'Copanatoyac', 12),
(12021, 'Coyuca de Benitez', 12),
(12022, 'Coyuca de Catalan', 12),
(12023, 'Cuajinicuilapa', 12),
(12024, 'Cualac', 12),
(12025, 'Cuautepec', 12),
(12026, 'Cuetzala del Progreso', 12),
(12027, 'Cutzamala de Pinzon', 12),
(12028, 'Chilapa de Alvarez', 12),
(12029, 'Chilpancingo de los Bravo', 12),
(12030, 'Florencio Villarreal', 12),
(12031, 'General Canuto A. Neri', 12),
(12032, 'General Heliodoro Castillo', 12),
(12033, 'Huamuxtitlan', 12),
(12034, 'Huitzuco de los Figueroa', 12),
(12035, 'Iguala de la Independencia', 12),
(12036, 'Igualapa', 12),
(12037, 'Ixcateopan de Cuauhtemoc', 12),
(12038, 'Zihuatanejo de Azueta', 12),
(12039, 'Juan R. Escudero', 12),
(12040, 'Leonardo Bravo', 12),
(12041, 'Malinaltepec', 12),
(12042, 'Martir de Cuilapan', 12),
(12043, 'Metlatonoc', 12),
(12044, 'Mochitlan', 12),
(12045, 'Olinala', 12),
(12046, 'Ometepec', 12),
(12047, 'Pedro Ascencio Alquisiras', 12),
(12048, 'Petatlan', 12),
(12049, 'Pilcaya', 12),
(12050, 'Pungarabato', 12),
(12051, 'Quechultenango', 12),
(12052, 'San Luis Acatlan', 12),
(12053, 'San Marcos', 12),
(12054, 'San Miguel Totolapan', 12),
(12055, 'Taxco de Alarcon', 12),
(12056, 'Tecoanapa', 12),
(12057, 'Tecpan de Galeana', 12),
(12058, 'Teloloapan', 12),
(12059, 'Tepecoacuilco de Trujano', 12),
(12060, 'Tetipac', 12),
(12061, 'Tixtla de Guerrero', 12),
(12062, 'Tlacoachistlahuaca', 12),
(12063, 'Tlacoapa', 12),
(12064, 'Tlalchapa', 12),
(12065, 'Tlalixtaquilla de Maldonado', 12),
(12066, 'Tlapa de Comonfort', 12),
(12067, 'Tlapehuala', 12),
(12068, 'La Union de Isidoro Montes de Oca', 12),
(12069, 'Xalpatlahuac', 12),
(12070, 'Xochihuehuetlan', 12),
(12071, 'Xochistlahuaca', 12),
(12072, 'Zapotitlan Tablas', 12),
(12073, 'Zirandaro', 12),
(12074, 'Zitlala', 12),
(12075, 'Eduardo Neri', 12),
(12076, 'Acatepec', 12),
(12077, 'Marquelia', 12),
(12078, 'Cochoapa el Grande', 12),
(12079, 'Jose Joaquin de Herrera', 12),
(12080, 'Juchitan', 12),
(12081, 'Iliatenco', 12),
(13001, 'Acatlan', 13),
(13002, 'Acaxochitlan', 13),
(13003, 'Actopan', 13),
(13004, 'Agua Blanca de Iturbide', 13),
(13005, 'Ajacuba', 13),
(13006, 'Alfajayucan', 13),
(13007, 'Almoloya', 13),
(13008, 'Apan', 13),
(13009, 'El Arenal', 13),
(13010, 'Atitalaquia', 13),
(13011, 'Atlapexco', 13),
(13012, 'Atotonilco el Grande', 13),
(13013, 'Atotonilco de Tula', 13),
(13014, 'Calnali', 13),
(13015, 'Cardonal', 13),
(13016, 'Cuautepec de Hinojosa', 13),
(13017, 'Chapantongo', 13),
(13018, 'Chapulhuacan', 13),
(13019, 'Chilcuautla', 13),
(13020, 'Eloxochitlan', 13),
(13021, 'Emiliano Zapata', 13),
(13022, 'Epazoyucan', 13),
(13023, 'Francisco I. Madero', 13),
(13024, 'Huasca de Ocampo', 13),
(13025, 'Huautla', 13),
(13026, 'Huazalingo', 13),
(13027, 'Huehuetla', 13),
(13028, 'Huejutla de Reyes', 13),
(13029, 'Huichapan', 13),
(13030, 'Ixmiquilpan', 13),
(13031, 'Jacala de Ledezma', 13),
(13032, 'Jaltocan', 13),
(13033, 'Juarez Hidalgo', 13),
(13034, 'Lolotla', 13),
(13035, 'Metepec', 13),
(13036, 'San Agustin Metzquititlan', 13),
(13037, 'Metztitlan', 13),
(13038, 'Mineral del Chico', 13),
(13039, 'Mineral del Monte', 13),
(13040, 'La Mision', 13),
(13041, 'Mixquiahuala de Juarez', 13),
(13042, 'Molango de Escamilla', 13),
(13043, 'Nicolas Flores', 13),
(13044, 'Nopala de Villagran', 13),
(13045, 'Omitlan de Juarez', 13),
(13046, 'San Felipe Orizatlan', 13),
(13047, 'Pacula', 13),
(13048, 'Pachuca de Soto', 13),
(13049, 'Pisaflores', 13),
(13050, 'Progreso de Obregon', 13),
(13051, 'Mineral de la Reforma', 13),
(13052, 'San Agustin Tlaxiaca', 13),
(13053, 'San Bartolo Tutotepec', 13),
(13054, 'San Salvador', 13),
(13055, 'Santiago de Anaya', 13),
(13056, 'Santiago Tulantepec de Lugo Guerrero', 13),
(13057, 'Singuilucan', 13),
(13058, 'Tasquillo', 13),
(13059, 'Tecozautla', 13),
(13060, 'Tenango de Doria', 13),
(13061, 'Tepeapulco', 13),
(13062, 'Tepehuacan de Guerrero', 13),
(13063, 'Tepeji del Rio de Ocampo', 13),
(13064, 'Tepetitlan', 13),
(13065, 'Tetepango', 13),
(13066, 'Villa de Tezontepec', 13),
(13067, 'Tezontepec de Aldama', 13),
(13068, 'Tianguistengo', 13),
(13069, 'Tizayuca', 13),
(13070, 'Tlahuelilpan', 13),
(13071, 'Tlahuiltepa', 13),
(13072, 'Tlanalapa', 13),
(13073, 'Tlanchinol', 13),
(13074, 'Tlaxcoapan', 13),
(13075, 'Tolcayuca', 13),
(13076, 'Tula de Allende', 13),
(13077, 'Tulancingo de Bravo', 13),
(13078, 'Xochiatipan', 13),
(13079, 'Xochicoatlan', 13),
(13080, 'Yahualica', 13),
(13081, 'Zacualtipan de Angeles', 13),
(13082, 'Zapotlan de Juarez', 13),
(13083, 'Zempoala', 13),
(13084, 'Zimapan', 13),
(14001, 'Acatic', 14),
(14002, 'Acatlan de Juarez', 14),
(14003, 'Ahualulco de Mercado', 14),
(14004, 'Amacueca', 14),
(14005, 'Amatitan', 14),
(14006, 'Ameca', 14),
(14007, 'San Juanito de Escobedo', 14),
(14008, 'Arandas', 14),
(14009, 'El Arenal', 14),
(14010, 'Atemajac de Brizuela', 14),
(14011, 'Atengo', 14),
(14012, 'Atenguillo', 14),
(14013, 'Atotonilco el Alto', 14),
(14014, 'Atoyac', 14),
(14015, 'Autlan de Navarro', 14),
(14016, 'Ayotlan', 14),
(14017, 'Ayutla', 14),
(14018, 'La Barca', 14),
(14020, 'Cabo Corrientes', 14),
(14021, 'Casimiro Castillo', 14),
(14022, 'Cihuatlan', 14),
(14023, 'Zapotlan el Grande', 14),
(14024, 'Cocula', 14),
(14025, 'Colotlan', 14),
(14026, 'Concepcion de Buenos Aires', 14),
(14027, 'Cuautitlan de Garcia Barragan', 14),
(14028, 'Cuautla', 14),
(14029, 'Cuquio', 14),
(14030, 'Chapala', 14),
(14031, 'Chimaltitan', 14),
(14032, 'Chiquilistlan', 14),
(14033, 'Degollado', 14),
(14034, 'Ejutla', 14),
(14035, 'Encarnacion de Diaz', 14),
(14036, 'Etzatlan', 14),
(14037, 'El Grullo', 14),
(14038, 'Guachinango', 14),
(14039, 'Guadalajara', 14),
(14040, 'Hostotipaquillo', 14),
(14041, 'Huejucar', 14),
(14042, 'Huejuquilla el Alto', 14),
(14043, 'La Huerta', 14),
(14044, 'Ixtlahuacan de los Membrillos', 14),
(14045, 'Ixtlahuacan del Rio', 14),
(14046, 'Jalostotitlan', 14),
(14047, 'Jamay', 14),
(14048, 'Jesus Maria', 14),
(14049, 'Jilotlan de los Dolores', 14),
(14050, 'Jocotepec', 14),
(14051, 'Juanacatlan', 14),
(14052, 'Juchitlan', 14),
(14053, 'Lagos de Moreno', 14),
(14054, 'El Limon', 14),
(14055, 'Magdalena', 14),
(14056, 'Santa Maria del Oro', 14),
(14057, 'La Manzanilla de la Paz', 14),
(14058, 'Mascota', 14),
(14059, 'Mazamitla', 14),
(14060, 'Mexticacan', 14),
(14061, 'Mezquitic', 14),
(14062, 'Mixtlan', 14),
(14063, 'Ocotlan', 14),
(14064, 'Ojuelos de Jalisco', 14),
(14065, 'Pihuamo', 14),
(14066, 'Poncitlan', 14),
(14067, 'Puerto Vallarta', 14),
(14068, 'Villa Purificacion', 14),
(14069, 'Quitupan', 14),
(14070, 'El Salto', 14),
(14071, 'San Cristobal de la Barranca', 14),
(14072, 'San Diego de Alejandria', 14),
(14073, 'San Juan de los Lagos', 14),
(14074, 'San Julian', 14),
(14075, 'San Marcos', 14),
(14077, 'San Martin Hidalgo', 14),
(14078, 'San Miguel el Alto', 14),
(14079, 'Gomez Farias', 14),
(14080, 'San Sebastian del Oeste', 14),
(14081, 'Santa Maria de los Angeles', 14),
(14082, 'Sayula', 14),
(14083, 'Tala', 14),
(14084, 'Talpa de Allende', 14),
(14085, 'Tamazula de Gordiano', 14),
(14086, 'Tapalpa', 14),
(14087, 'Tecalitlan', 14),
(14088, 'Techaluta de Montenegro', 14),
(14089, 'Tecolotlan', 14),
(14090, 'Tenamaxtlan', 14),
(14091, 'Teocaltiche', 14),
(14092, 'Teocuitatlan de Corona', 14),
(14093, 'Tepatitlan de Morelos', 14),
(14094, 'Tequila', 14),
(14095, 'Teuchitlan', 14),
(14096, 'Tizapan el Alto', 14),
(14098, 'San Pedro Tlaquepaque', 14),
(14099, 'Toliman', 14),
(14100, 'Tomatlan', 14),
(14101, 'Tonala', 14),
(14102, 'Tonaya', 14),
(14103, 'Tonila', 14),
(14104, 'Totatiche', 14),
(14105, 'Tototlan', 14),
(14106, 'Tuxcacuesco', 14),
(14107, 'Tuxcueca', 14),
(14108, 'Tuxpan', 14),
(14109, 'Union de San Antonio', 14),
(14110, 'Union de Tula', 14),
(14111, 'Valle de Guadalupe', 14),
(14112, 'Valle de Juarez', 14),
(14113, 'San Gabriel', 14),
(14114, 'Villa Corona', 14),
(14115, 'Villa Guerrero', 14),
(14116, 'Villa Hidalgo', 14),
(14118, 'Yahualica de Gonzalez Gallo', 14),
(14119, 'Zacoalco de Torres', 14),
(14120, 'Zapopan', 14),
(14121, 'Zapotiltic', 14),
(14122, 'Zapotitlan de Vadillo', 14),
(14123, 'Zapotlan del Rey', 14),
(14124, 'Zapotlanejo', 14),
(14125, 'San Ignacio Cerro Gordo', 14),
(15002, 'Acolman', 15),
(15003, 'Aculco', 15),
(15004, 'Almoloya de Alquisiras', 15),
(15005, 'Almoloya de Juarez', 15),
(15006, 'Almoloya del Rio', 15),
(15007, 'Amanalco', 15),
(15008, 'Amatepec', 15),
(15009, 'Amecameca', 15),
(15010, 'Apaxco', 15),
(15011, 'Atenco', 15),
(15012, 'Atizapan', 15),
(15013, 'Atizapan de Zaragoza', 15),
(15014, 'Atlacomulco', 15),
(15015, 'Atlautla', 15),
(15016, 'Axapusco', 15),
(15017, 'Ayapango', 15),
(15018, 'Calimaya', 15),
(15019, 'Capulhuac', 15),
(15020, 'Coacalco de Berriozabal', 15),
(15021, 'Coatepec Harinas', 15),
(15022, 'Cocotitlan', 15),
(15023, 'Coyotepec', 15),
(15024, 'Cuautitlan', 15),
(15025, 'Chalco', 15),
(15026, 'Chapa de Mota', 15),
(15027, 'Chapultepec', 15),
(15028, 'Chiautla', 15),
(15029, 'Chicoloapan', 15),
(15030, 'Chiconcuac', 15),
(15031, 'Chimalhuacan', 15),
(15032, 'Donato Guerra', 15),
(15033, 'Ecatepec de Morelos', 15),
(15034, 'Ecatzingo', 15),
(15035, 'Huehuetoca', 15),
(15036, 'Hueypoxtla', 15),
(15037, 'Huixquilucan', 15),
(15038, 'Isidro Fabela', 15),
(15039, 'Ixtapaluca', 15),
(15040, 'Ixtapan de la Sal', 15),
(15041, 'Ixtapan del Oro', 15),
(15042, 'Ixtlahuaca', 15),
(15043, 'Xalatlaco', 15),
(15044, 'Jaltenco', 15),
(15045, 'Jilotepec', 15),
(15046, 'Jilotzingo', 15),
(15047, 'Jiquipilco', 15),
(15048, 'Jocotitlan', 15),
(15049, 'Joquicingo', 15),
(15050, 'Juchitepec', 15),
(15051, 'Lerma', 15),
(15052, 'Malinalco', 15),
(15053, 'Melchor Ocampo', 15),
(15054, 'Metepec', 15),
(15055, 'Mexicaltzingo', 15),
(15056, 'Morelos', 15),
(15057, 'Naucalpan de Juarez', 15),
(15058, 'Nezahualcoyotl', 15),
(15059, 'Nextlalpan', 15),
(15060, 'Nicolas Romero', 15),
(15061, 'Nopaltepec', 15),
(15062, 'Ocoyoacac', 15),
(15063, 'Ocuilan', 15),
(15064, 'El Oro', 15),
(15065, 'Otumba', 15),
(15066, 'Otzoloapan', 15),
(15067, 'Otzolotepec', 15),
(15068, 'Ozumba', 15),
(15069, 'Papalotla', 15),
(15070, 'La Paz', 15),
(15071, 'Polotitlan', 15),
(15072, 'Rayon', 15),
(15073, 'San Antonio la Isla', 15),
(15074, 'San Felipe del Progreso', 15),
(15075, 'San Martin de las Piramides', 15),
(15076, 'San Mateo Atenco', 15),
(15077, 'San Simon de Guerrero', 15),
(15078, 'Santo Tomas', 15),
(15079, 'Soyaniquilpan de Juarez', 15),
(15080, 'Sultepec', 15),
(15081, 'Tecamac', 15),
(15082, 'Tejupilco', 15),
(15083, 'Temamatla', 15),
(15084, 'Temascalapa', 15),
(15085, 'Temascalcingo', 15),
(15086, 'Temascaltepec', 15),
(15087, 'Temoaya', 15),
(15088, 'Tenancingo', 15),
(15089, 'Tenango del Aire', 15),
(15090, 'Tenango del Valle', 15),
(15091, 'Teoloyucan', 15),
(15092, 'Teotihuacan', 15),
(15093, 'Tepetlaoxtoc', 15),
(15094, 'Tepetlixpa', 15),
(15095, 'Tepotzotlan', 15),
(15096, 'Tequixquiac', 15),
(15097, 'Texcaltitlan', 15),
(15098, 'Texcalyacac', 15),
(15099, 'Texcoco', 15),
(15100, 'Tezoyuca', 15),
(15101, 'Tianguistenco', 15),
(15102, 'Timilpan', 15),
(15103, 'Tlalmanalco', 15),
(15104, 'Tlalnepantla de Baz', 15),
(15105, 'Tlatlaya', 15),
(15106, 'Toluca', 15),
(15107, 'Tonatico', 15),
(15108, 'Tultepec', 15),
(15109, 'Tultitlan', 15),
(15110, 'Valle de Bravo', 15),
(15111, 'Villa de Allende', 15),
(15112, 'Villa del Carbon', 15),
(15113, 'Villa Guerrero', 15),
(15114, 'Villa Victoria', 15),
(15115, 'Xonacatlan', 15),
(15116, 'Zacazonapan', 15),
(15117, 'Zacualpan', 15),
(15118, 'Zinacantepec', 15),
(15119, 'Zumpahuacan', 15),
(15120, 'Zumpango', 15),
(15121, 'Cuautitlan Izcalli', 15),
(15122, 'Valle de Chalco Solidaridad', 15),
(15123, 'Luvianos', 15),
(15124, 'San Jose del Rincon', 15),
(15125, 'Tonanitla', 15),
(16001, 'Acuitzio', 16),
(16002, 'Aguililla', 16),
(16003, 'Alvaro Obregon', 16),
(16004, 'Angamacutiro', 16),
(16005, 'Angangueo', 16),
(16006, 'Apatzingan', 16),
(16007, 'Aporo', 16),
(16008, 'Aquila', 16),
(16009, 'Ario', 16),
(16010, 'Arteaga', 16),
(16012, 'Buenavista', 16),
(16013, 'Caracuaro', 16),
(16014, 'Coahuayana', 16),
(16015, 'Coalcoman de Vazquez Pallares', 16),
(16016, 'Coeneo', 16),
(16017, 'Contepec', 16),
(16018, 'Copandaro', 16),
(16019, 'Cotija', 16),
(16020, 'Cuitzeo', 16),
(16021, 'Charapan', 16),
(16022, 'Charo', 16),
(16023, 'Chavinda', 16),
(16024, 'Cheran', 16),
(16025, 'Chilchota', 16),
(16026, 'Chinicuila', 16),
(16027, 'Chucandiro', 16),
(16028, 'Churintzio', 16),
(16029, 'Churumuco', 16),
(16030, 'Ecuandureo', 16),
(16031, 'Epitacio Huerta', 16),
(16032, 'Erongaricuaro', 16),
(16033, 'Gabriel Zamora', 16),
(16034, 'Hidalgo', 16),
(16035, 'La Huacana', 16),
(16036, 'Huandacareo', 16),
(16037, 'Huaniqueo', 16),
(16038, 'Huetamo', 16),
(16039, 'Huiramba', 16),
(16040, 'Indaparapeo', 16),
(16041, 'Irimbo', 16),
(16042, 'Ixtlan', 16),
(16043, 'Jacona', 16),
(16044, 'Jimenez', 16),
(16045, 'Jiquilpan', 16),
(16046, 'Juarez', 16),
(16047, 'Jungapeo', 16),
(16048, 'Lagunillas', 16),
(16049, 'Madero', 16),
(16050, 'Maravatio', 16),
(16051, 'Marcos Castellanos', 16),
(16052, 'Lazaro Cardenas', 16),
(16053, 'Morelia', 16),
(16054, 'Morelos', 16),
(16055, 'Mugica', 16),
(16056, 'Nahuatzen', 16),
(16057, 'Nocupetaro', 16),
(16058, 'Nuevo Parangaricutiro', 16),
(16059, 'Nuevo Urecho', 16),
(16060, 'Numaran', 16),
(16061, 'Ocampo', 16),
(16062, 'Pajacuaran', 16),
(16063, 'Panindicuaro', 16),
(16064, 'Paracuaro', 16),
(16065, 'Paracho', 16),
(16066, 'Patzcuaro', 16),
(16067, 'Penjamillo', 16),
(16068, 'Periban', 16),
(16069, 'La Piedad', 16),
(16070, 'Purepero', 16),
(16071, 'Puruandiro', 16),
(16072, 'Querendaro', 16),
(16073, 'Quiroga', 16),
(16074, 'Cojumatlan de Regules', 16),
(16075, 'Los Reyes', 16),
(16076, 'Sahuayo', 16),
(16077, 'San Lucas', 16),
(16078, 'Santa Ana Maya', 16),
(16079, 'Salvador Escalante', 16),
(16080, 'Senguio', 16),
(16081, 'Susupuato', 16),
(16082, 'Tacambaro', 16),
(16083, 'Tancitaro', 16),
(16084, 'Tangamandapio', 16),
(16085, 'Tangancicuaro', 16),
(16086, 'Tanhuato', 16),
(16087, 'Taretan', 16),
(16088, 'Tarimbaro', 16),
(16089, 'Tepalcatepec', 16),
(16090, 'Tingambato', 16),
(16092, 'Tiquicheo de Nicolas Romero', 16),
(16093, 'Tlalpujahua', 16),
(16094, 'Tlazazalca', 16),
(16095, 'Tocumbo', 16),
(16096, 'Tumbiscatio', 16),
(16097, 'Turicato', 16),
(16098, 'Tuxpan', 16),
(16099, 'Tuzantla', 16),
(16100, 'Tzintzuntzan', 16),
(16101, 'Tzitzio', 16),
(16102, 'Uruapan', 16),
(16103, 'Venustiano Carranza', 16),
(16104, 'Villamar', 16),
(16105, 'Vista Hermosa', 16),
(16106, 'Yurecuaro', 16),
(16107, 'Zacapu', 16),
(16108, 'Zamora', 16),
(16109, 'Zinaparo', 16),
(16110, 'Zinapecuaro', 16),
(16111, 'Ziracuaretiro', 16),
(16112, 'Zitacuaro', 16),
(16113, 'Jose Sixto Verduzco', 16),
(17001, 'Amacuzac', 17),
(17002, 'Atlatlahucan', 17),
(17003, 'Axochiapan', 17),
(17004, 'Ayala', 17),
(17005, 'Coatlan del Rio', 17),
(17006, 'Cuautla', 17),
(17007, 'Cuernavaca', 17),
(17008, 'Emiliano Zapata', 17),
(17009, 'Huitzilac', 17),
(17010, 'Jantetelco', 17),
(17011, 'Jiutepec', 17),
(17012, 'Jojutla', 17),
(17013, 'Jonacatepec de Leandro Valle', 17),
(17014, 'Mazatepec', 17),
(17015, 'Miacatlan', 17),
(17016, 'Ocuituco', 17),
(17017, 'Puente de Ixtla', 17),
(17018, 'Temixco', 17),
(17019, 'Tepalcingo', 17),
(17020, 'Tepoztlan', 17),
(17021, 'Tetecala', 17),
(17022, 'Tetela del Volcan', 17),
(17023, 'Tlalnepantla', 17),
(17024, 'Tlaltizapan de Zapata', 17),
(17025, 'Tlaquiltenango', 17),
(17026, 'Tlayacapan', 17),
(17027, 'Totolapan', 17),
(17028, 'Xochitepec', 17),
(17029, 'Yautepec', 17),
(17030, 'Yecapixtla', 17),
(17031, 'Zacatepec', 17),
(17032, 'Zacualpan de Amilpas', 17),
(17033, 'Temoac', 17),
(17034, 'Coatetelco', 17),
(17035, 'Xoxocotla', 17),
(17036, 'Hueyapan', 17),
(18001, 'Acaponeta', 18),
(18002, 'Ahuacatlan', 18),
(18003, 'Amatlan de Canas', 18),
(18004, 'Compostela', 18),
(18005, 'Huajicori', 18),
(18006, 'Ixtlan del Rio', 18),
(18007, 'Jala', 18),
(18008, 'Xalisco', 18),
(18009, 'Del Nayar', 18),
(18010, 'Rosamorada', 18),
(18011, 'Ruiz', 18),
(18012, 'San Blas', 18),
(18013, 'San Pedro Lagunillas', 18),
(18014, 'Santa Maria del Oro', 18),
(18015, 'Santiago Ixcuintla', 18),
(18016, 'Tecuala', 18),
(18017, 'Tepic', 18),
(18018, 'Tuxpan', 18),
(18019, 'La Yesca', 18),
(18020, 'Bahia de Banderas', 18),
(19001, 'Abasolo', 19),
(19002, 'Agualeguas', 19),
(19003, 'Los Aldamas', 19),
(19004, 'Allende', 19),
(19005, 'Anahuac', 19),
(19006, 'Apodaca', 19),
(19007, 'Aramberri', 19),
(19008, 'Bustamante', 19),
(19009, 'Cadereyta Jimenez', 19),
(19010, 'El Carmen', 19),
(19011, 'Cerralvo', 19),
(19012, 'Cienega de Flores', 19),
(19013, 'China', 19),
(19014, 'Doctor Arroyo', 19),
(19015, 'Doctor Coss', 19),
(19016, 'Doctor Gonzalez', 19),
(19017, 'Galeana', 19),
(19018, 'Garcia', 19),
(19019, 'San Pedro Garza Garcia', 19),
(19020, 'General Bravo', 19),
(19021, 'General Escobedo', 19),
(19022, 'General Teran', 19),
(19024, 'General Zaragoza', 19),
(19025, 'General Zuazua', 19),
(19026, 'Guadalupe', 19),
(19027, 'Los Herreras', 19),
(19028, 'Higueras', 19),
(19029, 'Hualahuises', 19),
(19030, 'Iturbide', 19),
(19031, 'Juarez', 19),
(19032, 'Lampazos de Naranjo', 19),
(19033, 'Linares', 19),
(19034, 'Marin', 19),
(19035, 'Melchor Ocampo', 19),
(19036, 'Mier y Noriega', 19),
(19037, 'Mina', 19),
(19038, 'Montemorelos', 19),
(19039, 'Monterrey', 19),
(19040, 'Paras', 19),
(19041, 'Pesqueria', 19),
(19042, 'Los Ramones', 19),
(19043, 'Rayones', 19),
(19044, 'Sabinas Hidalgo', 19),
(19045, 'Salinas Victoria', 19),
(19046, 'San Nicolas de los Garza', 19),
(19047, 'Hidalgo', 19),
(19048, 'Santa Catarina', 19),
(19049, 'Santiago', 19),
(19050, 'Vallecillo', 19),
(19051, 'Villaldama', 19),
(20001, 'Abejones', 20),
(20002, 'Acatlan de Perez Figueroa', 20),
(20003, 'Asuncion Cacalotepec', 20),
(20004, 'Asuncion Cuyotepeji', 20),
(20005, 'Asuncion Ixtaltepec', 20),
(20006, 'Asuncion Nochixtlan', 20),
(20007, 'Asuncion Ocotlan', 20),
(20008, 'Asuncion Tlacolulita', 20),
(20009, 'Ayotzintepec', 20),
(20010, 'El Barrio de la Soledad', 20),
(20011, 'Calihuala', 20),
(20012, 'Candelaria Loxicha', 20),
(20013, 'Cienega de Zimatlan', 20),
(20014, 'Ciudad Ixtepec', 20),
(20015, 'Coatecas Altas', 20),
(20016, 'Coicoyan de las Flores', 20),
(20018, 'Concepcion Buenavista', 20),
(20019, 'Concepcion Papalo', 20),
(20020, 'Constancia del Rosario', 20),
(20021, 'Cosolapa', 20),
(20022, 'Cosoltepec', 20),
(20023, 'Cuilapam de Guerrero', 20),
(20024, 'Cuyamecalco Villa de Zaragoza', 20),
(20025, 'Chahuites', 20),
(20026, 'Chalcatongo de Hidalgo', 20),
(20027, 'Chiquihuitlan de Benito Juarez', 20),
(20028, 'Heroica Ciudad de Ejutla de Crespo', 20),
(20029, 'Eloxochitlan de Flores Magon', 20),
(20030, 'El Espinal', 20),
(20031, 'Tamazulapam del Espiritu Santo', 20),
(20032, 'Fresnillo de Trujano', 20),
(20033, 'Guadalupe Etla', 20),
(20034, 'Guadalupe de Ramirez', 20),
(20035, 'Guelatao de Juarez', 20),
(20036, 'Guevea de Humboldt', 20),
(20037, 'Mesones Hidalgo', 20),
(20038, 'Villa Hidalgo', 20),
(20039, 'Heroica Ciudad de Huajuapan de Leon', 20),
(20040, 'Huautepec', 20),
(20041, 'Huautla de Jimenez', 20),
(20042, 'Ixtlan de Juarez', 20),
(20043, 'Juchitan de Zaragoza', 20),
(20044, 'Loma Bonita', 20),
(20045, 'Magdalena Apasco', 20),
(20046, 'Magdalena Jaltepec', 20),
(20047, 'Santa Magdalena Jicotlan', 20),
(20048, 'Magdalena Mixtepec', 20),
(20049, 'Magdalena Ocotlan', 20),
(20051, 'Magdalena Teitipac', 20),
(20052, 'Magdalena Tequisistlan', 20),
(20053, 'Magdalena Tlacotepec', 20),
(20054, 'Magdalena Zahuatlan', 20),
(20055, 'Mariscala de Juarez', 20),
(20056, 'Martires de Tacubaya', 20),
(20058, 'Mazatlan Villa de Flores', 20),
(20059, 'Miahuatlan de Porfirio Diaz', 20),
(20060, 'Mixistlan de la Reforma', 20),
(20061, 'Monjas', 20),
(20062, 'Natividad', 20),
(20063, 'Nazareno Etla', 20),
(20064, 'Nejapa de Madero', 20),
(20065, 'Ixpantepec Nieves', 20),
(20066, 'Santiago Niltepec', 20),
(20067, 'Oaxaca de Juarez', 20),
(20068, 'Ocotlan de Morelos', 20),
(20069, 'La Pe', 20),
(20070, 'Pinotepa de Don Luis', 20),
(20071, 'Pluma Hidalgo', 20),
(20072, 'San Jose del Progreso', 20),
(20073, 'Putla Villa de Guerrero', 20),
(20074, 'Santa Catarina Quioquitani', 20),
(20075, 'Reforma de Pineda', 20),
(20076, 'La Reforma', 20),
(20077, 'Reyes Etla', 20),
(20078, 'Rojas de Cuauhtemoc', 20),
(20079, 'Salina Cruz', 20),
(20080, 'San Agustin Amatengo', 20),
(20081, 'San Agustin Atenango', 20),
(20082, 'San Agustin Chayuco', 20),
(20083, 'San Agustin de las Juntas', 20),
(20084, 'San Agustin Etla', 20),
(20085, 'San Agustin Loxicha', 20),
(20086, 'San Agustin Tlacotepec', 20),
(20087, 'San Agustin Yatareni', 20),
(20088, 'San Andres Cabecera Nueva', 20),
(20089, 'San Andres Dinicuiti', 20),
(20090, 'San Andres Huaxpaltepec', 20),
(20091, 'San Andres Huayapam', 20),
(20092, 'San Andres Ixtlahuaca', 20),
(20093, 'San Andres Lagunas', 20),
(20095, 'San Andres Paxtlan', 20),
(20096, 'San Andres Sinaxtla', 20),
(20097, 'San Andres Solaga', 20),
(20098, 'San Andres Teotilalpam', 20),
(20099, 'San Andres Tepetlapa', 20),
(20100, 'San Andres Yaa', 20),
(20101, 'San Andres Zabache', 20),
(20102, 'San Andres Zautla', 20),
(20103, 'San Antonino Castillo Velasco', 20),
(20104, 'San Antonino el Alto', 20),
(20105, 'San Antonino Monte Verde', 20),
(20106, 'San Antonio Acutla', 20),
(20107, 'San Antonio de la Cal', 20),
(20108, 'San Antonio Huitepec', 20),
(20109, 'San Antonio Nanahuatipam', 20),
(20110, 'San Antonio Sinicahua', 20),
(20111, 'San Antonio Tepetlapa', 20),
(20112, 'San Baltazar Chichicapam', 20),
(20113, 'San Baltazar Loxicha', 20),
(20114, 'San Baltazar Yatzachi el Bajo', 20),
(20115, 'San Bartolo Coyotepec', 20),
(20116, 'San Bartolome Ayautla', 20),
(20117, 'San Bartolome Loxicha', 20),
(20118, 'San Bartolome Quialana', 20),
(20120, 'San Bartolome Zoogocho', 20),
(20121, 'San Bartolo Soyaltepec', 20),
(20122, 'San Bartolo Yautepec', 20),
(20123, 'San Bernardo Mixtepec', 20),
(20124, 'San Blas Atempa', 20),
(20125, 'San Carlos Yautepec', 20),
(20126, 'San Cristobal Amatlan', 20),
(20127, 'San Cristobal Amoltepec', 20),
(20128, 'San Cristobal Lachirioag', 20),
(20129, 'San Cristobal Suchixtlahuaca', 20),
(20130, 'San Dionisio del Mar', 20),
(20131, 'San Dionisio Ocotepec', 20),
(20132, 'San Dionisio Ocotlan', 20),
(20133, 'San Esteban Atatlahuca', 20),
(20134, 'San Felipe Jalapa de Diaz', 20),
(20135, 'San Felipe Tejalapam', 20),
(20136, 'San Felipe Usila', 20),
(20137, 'San Francisco Cahuacua', 20),
(20138, 'San Francisco Cajonos', 20),
(20139, 'San Francisco Chapulapa', 20),
(20140, 'San Francisco Chindua', 20),
(20141, 'San Francisco del Mar', 20),
(20142, 'San Francisco Huehuetlan', 20),
(20143, 'San Francisco Ixhuatan', 20),
(20144, 'San Francisco Jaltepetongo', 20),
(20145, 'San Francisco Lachigolo', 20),
(20146, 'San Francisco Logueche', 20),
(20148, 'San Francisco Ozolotepec', 20),
(20149, 'San Francisco Sola', 20),
(20150, 'San Francisco Telixtlahuaca', 20),
(20151, 'San Francisco Teopan', 20),
(20152, 'San Francisco Tlapancingo', 20),
(20153, 'San Gabriel Mixtepec', 20),
(20154, 'San Ildefonso Amatlan', 20),
(20155, 'San Ildefonso Sola', 20),
(20156, 'San Ildefonso Villa Alta', 20),
(20157, 'San Jacinto Amilpas', 20),
(20158, 'San Jacinto Tlacotepec', 20),
(20159, 'San Jeronimo Coatlan', 20),
(20160, 'San Jeronimo Silacayoapilla', 20),
(20161, 'San Jeronimo Sosola', 20),
(20162, 'San Jeronimo Taviche', 20),
(20163, 'San Jeronimo Tecoatl', 20),
(20164, 'San Jorge Nuchita', 20),
(20165, 'San Jose Ayuquila', 20),
(20166, 'San Jose Chiltepec', 20),
(20168, 'San Jose Estancia Grande', 20),
(20169, 'San Jose Independencia', 20),
(20170, 'San Jose Lachiguiri', 20),
(20171, 'San Jose Tenango', 20),
(20172, 'San Juan Achiutla', 20),
(20173, 'San Juan Atepec', 20),
(20174, 'Animas Trujano', 20),
(20175, 'San Juan Bautista Atatlahuca', 20),
(20176, 'San Juan Bautista Coixtlahuaca', 20),
(20177, 'San Juan Bautista Cuicatlan', 20),
(20178, 'San Juan Bautista Guelache', 20),
(20179, 'San Juan Bautista Jayacatlan', 20),
(20180, 'San Juan Bautista Lo de Soto', 20),
(20181, 'San Juan Bautista Suchitepec', 20),
(20182, 'San Juan Bautista Tlacoatzintepec', 20),
(20183, 'San Juan Bautista Tlachichilco', 20),
(20184, 'San Juan Bautista Tuxtepec', 20),
(20185, 'San Juan Cacahuatepec', 20),
(20186, 'San Juan Cieneguilla', 20),
(20187, 'San Juan Coatzospam', 20),
(20188, 'San Juan Colorado', 20),
(20189, 'San Juan Comaltepec', 20),
(20190, 'San Juan Cotzocon', 20),
(20191, 'San Juan Chicomezuchil', 20),
(20192, 'San Juan Chilateca', 20),
(20193, 'San Juan del Estado', 20),
(20194, 'San Juan del Rio', 20),
(20195, 'San Juan Diuxi', 20),
(20196, 'San Juan Evangelista Analco', 20),
(20197, 'San Juan Guelavia', 20),
(20198, 'San Juan Guichicovi', 20),
(20199, 'San Juan Ihualtepec', 20),
(20200, 'San Juan Juquila Mixes', 20),
(20201, 'San Juan Juquila Vijanos', 20),
(20202, 'San Juan Lachao', 20),
(20203, 'San Juan Lachigalla', 20),
(20204, 'San Juan Lajarcia', 20),
(20205, 'San Juan Lalana', 20),
(20206, 'San Juan de los Cues', 20),
(20207, 'San Juan Mazatlan', 20),
(20208, 'San Juan Mixtepec', 20),
(20209, 'San Juan Mixtepec.', 20),
(20211, 'San Juan Ozolotepec', 20),
(20212, 'San Juan Petlapa', 20),
(20213, 'San Juan Quiahije', 20),
(20214, 'San Juan Quiotepec', 20),
(20215, 'San Juan Sayultepec', 20),
(20216, 'San Juan Tabaa', 20),
(20217, 'San Juan Tamazola', 20),
(20218, 'San Juan Teita', 20),
(20219, 'San Juan Teitipac', 20),
(20220, 'San Juan Tepeuxila', 20),
(20221, 'San Juan Teposcolula', 20),
(20222, 'San Juan Yaee', 20),
(20223, 'San Juan Yatzona', 20),
(20224, 'San Juan Yucuita', 20),
(20225, 'San Lorenzo', 20),
(20226, 'San Lorenzo Albarradas', 20),
(20227, 'San Lorenzo Cacaotepec', 20),
(20228, 'San Lorenzo Cuaunecuiltitla', 20),
(20229, 'San Lorenzo Texmelucan', 20),
(20230, 'San Lorenzo Victoria', 20),
(20231, 'San Lucas Camotlan', 20),
(20232, 'San Lucas Ojitlan', 20),
(20233, 'San Lucas Quiavini', 20),
(20234, 'San Lucas Zoquiapam', 20),
(20235, 'San Luis Amatlan', 20),
(20236, 'San Marcial Ozolotepec', 20),
(20237, 'San Marcos Arteaga', 20),
(20238, 'San Martin de los Cansecos', 20),
(20239, 'San Martin Huamelulpam', 20),
(20240, 'San Martin Itunyoso', 20),
(20241, 'San Martin Lachila', 20),
(20242, 'San Martin Peras', 20),
(20243, 'San Martin Tilcajete', 20),
(20244, 'San Martin Toxpalan', 20),
(20245, 'San Martin Zacatepec', 20),
(20246, 'San Mateo Cajonos', 20),
(20247, 'Capulalpam de Mendez', 20),
(20248, 'San Mateo del Mar', 20),
(20249, 'San Mateo Yoloxochitlan', 20),
(20250, 'San Mateo Etlatongo', 20),
(20251, 'San Mateo Nejapam', 20),
(20254, 'San Mateo Rio Hondo', 20),
(20255, 'San Mateo Sindihui', 20),
(20256, 'San Mateo Tlapiltepec', 20),
(20257, 'San Melchor Betaza', 20),
(20258, 'San Miguel Achiutla', 20),
(20259, 'San Miguel Ahuehuetitlan', 20),
(20260, 'San Miguel Aloapam', 20),
(20261, 'San Miguel Amatitlan', 20),
(20262, 'San Miguel Amatlan', 20),
(20263, 'San Miguel Coatlan', 20),
(20264, 'San Miguel Chicahua', 20),
(20265, 'San Miguel Chimalapa', 20),
(20266, 'San Miguel del Puerto', 20),
(20267, 'San Miguel del Rio', 20),
(20268, 'San Miguel Ejutla', 20),
(20269, 'San Miguel el Grande', 20),
(20270, 'San Miguel Huautla', 20),
(20271, 'San Miguel Mixtepec', 20),
(20272, 'San Miguel Panixtlahuaca', 20),
(20273, 'San Miguel Peras', 20),
(20274, 'San Miguel Piedras', 20),
(20275, 'San Miguel Quetzaltepec', 20),
(20276, 'San Miguel Santa Flor', 20),
(20277, 'Villa Sola de Vega', 20),
(20278, 'San Miguel Soyaltepec', 20),
(20279, 'San Miguel Suchixtepec', 20),
(20280, 'Villa Talea de Castro', 20),
(20281, 'San Miguel Tecomatlan', 20),
(20282, 'San Miguel Tenango', 20),
(20283, 'San Miguel Tequixtepec', 20),
(20284, 'San Miguel Tilquiapam', 20),
(20285, 'San Miguel Tlacamama', 20),
(20286, 'San Miguel Tlacotepec', 20),
(20287, 'San Miguel Tulancingo', 20),
(20288, 'San Miguel Yotao', 20),
(20289, 'San Nicolas', 20),
(20290, 'San Nicolas Hidalgo', 20),
(20291, 'San Pablo Coatlan', 20),
(20292, 'San Pablo Cuatro Venados', 20),
(20293, 'San Pablo Etla', 20),
(20294, 'San Pablo Huitzo', 20),
(20295, 'San Pablo Huixtepec', 20),
(20296, 'San Pablo Macuiltianguis', 20),
(20297, 'San Pablo Tijaltepec', 20),
(20298, 'San Pablo Villa de Mitla', 20),
(20299, 'San Pablo Yaganiza', 20),
(20300, 'San Pedro Amuzgos', 20),
(20301, 'San Pedro Apostol', 20),
(20302, 'San Pedro Atoyac', 20),
(20303, 'San Pedro Cajonos', 20),
(20304, 'San Pedro Coxcaltepec Cantaros', 20),
(20305, 'San Pedro Comitancillo', 20),
(20306, 'San Pedro el Alto', 20),
(20307, 'San Pedro Huamelula', 20),
(20308, 'San Pedro Huilotepec', 20),
(20309, 'San Pedro Ixcatlan', 20),
(20310, 'San Pedro Ixtlahuaca', 20),
(20311, 'San Pedro Jaltepetongo', 20),
(20312, 'San Pedro Jicayan', 20),
(20313, 'San Pedro Jocotipac', 20),
(20314, 'San Pedro Juchatengo', 20),
(20315, 'San Pedro Martir', 20),
(20316, 'San Pedro Martir Quiechapa', 20),
(20317, 'San Pedro Martir Yucuxaco', 20),
(20318, 'San Pedro Mixtepec', 20),
(20319, 'San Pedro Mixtepec', 20),
(20320, 'San Pedro Molinos', 20),
(20321, 'San Pedro Nopala', 20),
(20322, 'San Pedro Ocopetatillo', 20),
(20323, 'San Pedro Ocotepec', 20),
(20324, 'San Pedro Pochutla', 20),
(20325, 'San Pedro Quiatoni', 20),
(20326, 'San Pedro Sochiapam', 20),
(20327, 'San Pedro Tapanatepec', 20),
(20328, 'San Pedro Taviche', 20),
(20329, 'San Pedro Teozacoalco', 20),
(20330, 'San Pedro Teutila', 20),
(20331, 'San Pedro Tidaa', 20),
(20332, 'San Pedro Topiltepec', 20),
(20333, 'San Pedro Totolapam', 20),
(20334, 'Villa de Tututepec', 20),
(20335, 'San Pedro Yaneri', 20),
(20336, 'San Pedro Yolox', 20),
(20337, 'San Pedro y San Pablo Ayutla', 20),
(20338, 'Villa de Etla', 20),
(20339, 'San Pedro y San Pablo Teposcolula', 20),
(20340, 'San Pedro y San Pablo Tequixtepec', 20),
(20341, 'San Pedro Yucunama', 20),
(20342, 'San Raymundo Jalpan', 20),
(20343, 'San Sebastian Abasolo', 20),
(20344, 'San Sebastian Coatlan', 20),
(20345, 'San Sebastian Ixcapa', 20),
(20346, 'San Sebastian Nicananduta', 20),
(20347, 'San Sebastian Rio Hondo', 20),
(20348, 'San Sebastian Tecomaxtlahuaca', 20),
(20349, 'San Sebastian Teitipac', 20),
(20350, 'San Sebastian Tutla', 20),
(20351, 'San Simon Almolongas', 20),
(20352, 'San Simon Zahuatlan', 20),
(20353, 'Santa Ana', 20),
(20354, 'Santa Ana Ateixtlahuaca', 20),
(20355, 'Santa Ana Cuauhtemoc', 20),
(20356, 'Santa Ana del Valle', 20),
(20357, 'Santa Ana Tavela', 20),
(20358, 'Santa Ana Tlapacoyan', 20),
(20359, 'Santa Ana Yareni', 20),
(20360, 'Santa Ana Zegache', 20),
(20361, 'Santa Catalina Quieri', 20),
(20362, 'Santa Catarina Cuixtla', 20),
(20363, 'Santa Catarina Ixtepeji', 20),
(20364, 'Santa Catarina Juquila', 20),
(20365, 'Santa Catarina Lachatao', 20),
(20366, 'Santa Catarina Loxicha', 20),
(20367, 'Santa Catarina Mechoacan', 20),
(20368, 'Santa Catarina Minas', 20),
(20369, 'Santa Catarina Quiane', 20),
(20370, 'Santa Catarina Tayata', 20),
(20371, 'Santa Catarina Ticua', 20),
(20372, 'Santa Catarina Yosonotu', 20),
(20373, 'Santa Catarina Zapoquila', 20),
(20374, 'Santa Cruz Acatepec', 20),
(20375, 'Santa Cruz Amilpas', 20),
(20376, 'Santa Cruz de Bravo', 20),
(20377, 'Santa Cruz Itundujia', 20),
(20378, 'Santa Cruz Mixtepec', 20),
(20379, 'Santa Cruz Nundaco', 20),
(20380, 'Santa Cruz Papalutla', 20),
(20381, 'Santa Cruz Tacache de Mina', 20),
(20382, 'Santa Cruz Tacahua', 20),
(20383, 'Santa Cruz Tayata', 20),
(20384, 'Santa Cruz Xitla', 20),
(20385, 'Santa Cruz Xoxocotlan', 20),
(20386, 'Santa Cruz Zenzontepec', 20),
(20387, 'Santa Gertrudis', 20),
(20388, 'Santa Ines del Monte', 20),
(20389, 'Santa Ines Yatzeche', 20),
(20390, 'Santa Lucia del Camino', 20),
(20391, 'Santa Lucia Miahuatlan', 20),
(20392, 'Santa Lucia Monteverde', 20),
(20393, 'Santa Lucia Ocotlan', 20),
(20394, 'Santa Maria Alotepec', 20),
(20395, 'Santa Maria Apazco', 20),
(20396, 'Santa Maria la Asuncion', 20),
(20397, 'Heroica Ciudad de Tlaxiaco', 20),
(20398, 'Ayoquezco de Aldama', 20),
(20399, 'Santa Maria Atzompa', 20),
(20400, 'Santa Maria Camotlan', 20),
(20401, 'Santa Maria Colotepec', 20),
(20402, 'Santa Maria Cortijo', 20),
(20403, 'Santa Maria Coyotepec', 20),
(20404, 'Santa Maria Chachoapam', 20),
(20405, 'Villa de Chilapa de Diaz', 20),
(20406, 'Santa Maria Chilchotla', 20),
(20407, 'Santa Maria Chimalapa', 20),
(20408, 'Santa Maria del Rosario', 20),
(20409, 'Santa Maria del Tule', 20),
(20410, 'Santa Maria Ecatepec', 20),
(20411, 'Santa Maria Guelace', 20),
(20412, 'Santa Maria Guienagati', 20),
(20413, 'Santa Maria Huatulco', 20),
(20414, 'Santa Maria Huazolotitlan', 20),
(20415, 'Santa Maria Ipalapa', 20),
(20416, 'Santa Maria Ixcatlan', 20),
(20417, 'Santa Maria Jacatepec', 20),
(20418, 'Santa Maria Jalapa del Marques', 20),
(20419, 'Santa Maria Jaltianguis', 20),
(20420, 'Santa Maria Lachixio', 20),
(20421, 'Santa Maria Mixtequilla', 20),
(20422, 'Santa Maria Nativitas', 20),
(20423, 'Santa Maria Nduayaco', 20),
(20424, 'Santa Maria Ozolotepec', 20),
(20425, 'Santa Maria Papalo', 20),
(20427, 'Santa Maria Petapa', 20),
(20428, 'Santa Maria Quiegolani', 20),
(20429, 'Santa Maria Sola', 20),
(20430, 'Santa Maria Tataltepec', 20),
(20431, 'Santa Maria Tecomavaca', 20),
(20432, 'Santa Maria Temaxcalapa', 20),
(20433, 'Santa Maria Temaxcaltepec', 20),
(20434, 'Santa Maria Teopoxco', 20),
(20435, 'Santa Maria Tepantlali', 20),
(20436, 'Santa Maria Texcatitlan', 20),
(20437, 'Santa Maria Tlahuitoltepec', 20),
(20438, 'Santa Maria Tlalixtac', 20),
(20439, 'Santa Maria Tonameca', 20),
(20440, 'Santa Maria Totolapilla', 20),
(20441, 'Santa Maria Xadani', 20),
(20442, 'Santa Maria Yalina', 20),
(20443, 'Santa Maria Yavesia', 20),
(20444, 'Santa Maria Yolotepec', 20),
(20445, 'Santa Maria Yosoyua', 20),
(20446, 'Santa Maria Yucuhiti', 20),
(20447, 'Santa Maria Zacatepec', 20),
(20448, 'Santa Maria Zaniza', 20),
(20449, 'Santa Maria Zoquitlan', 20),
(20450, 'Santiago Amoltepec', 20),
(20451, 'Santiago Apoala', 20),
(20452, 'Santiago Apostol', 20),
(20453, 'Santiago Astata', 20),
(20454, 'Santiago Atitlan', 20),
(20455, 'Santiago Ayuquililla', 20),
(20456, 'Santiago Cacaloxtepec', 20),
(20457, 'Santiago Camotlan', 20),
(20458, 'Santiago Comaltepec', 20),
(20459, 'Villa de Santiago Chazumba', 20),
(20460, 'Santiago Choapam', 20),
(20461, 'Santiago del Rio', 20),
(20462, 'Santiago Huajolotitlan', 20),
(20463, 'Santiago Huauclilla', 20),
(20464, 'Santiago Ihuitlan Plumas', 20),
(20465, 'Santiago Ixcuintepec', 20),
(20466, 'Santiago Ixtayutla', 20),
(20467, 'Santiago Jamiltepec', 20),
(20468, 'Santiago Jocotepec', 20),
(20469, 'Santiago Juxtlahuaca', 20),
(20470, 'Santiago Lachiguiri', 20),
(20471, 'Santiago Lalopa', 20),
(20472, 'Santiago Laollaga', 20),
(20473, 'Santiago Laxopa', 20),
(20474, 'Santiago Llano Grande', 20),
(20475, 'Santiago Matatlan', 20),
(20476, 'Santiago Miltepec', 20),
(20477, 'Santiago Minas', 20),
(20478, 'Santiago Nacaltepec', 20),
(20479, 'Santiago Nejapilla', 20),
(20480, 'Santiago Nundiche', 20),
(20481, 'Santiago Nuyoo', 20),
(20482, 'Santiago Pinotepa Nacional', 20),
(20483, 'Santiago Suchilquitongo', 20),
(20484, 'Santiago Tamazola', 20),
(20485, 'Santiago Tapextla', 20),
(20486, 'Villa Tejupam de la Union', 20),
(20487, 'Santiago Tenango', 20),
(20488, 'Santiago Tepetlapa', 20),
(20489, 'Santiago Tetepec', 20),
(20490, 'Santiago Texcalcingo', 20),
(20491, 'Santiago Textitlan', 20),
(20492, 'Santiago Tilantongo', 20),
(20493, 'Santiago Tillo', 20),
(20494, 'Santiago Tlazoyaltepec', 20),
(20495, 'Santiago Xanica', 20),
(20496, 'Santiago Xiacui', 20),
(20497, 'Santiago Yaitepec', 20),
(20498, 'Santiago Yaveo', 20),
(20499, 'Santiago Yolomecatl', 20),
(20500, 'Santiago Yosondua', 20),
(20501, 'Santiago Yucuyachi', 20),
(20502, 'Santiago Zacatepec', 20),
(20503, 'Santiago Zoochila', 20),
(20504, 'Nuevo Zoquiapam', 20),
(20505, 'Santo Domingo Ingenio', 20),
(20506, 'Santo Domingo Albarradas', 20),
(20507, 'Santo Domingo Armenta', 20),
(20508, 'Santo Domingo Chihuitan', 20),
(20509, 'Santo Domingo de Morelos', 20),
(20510, 'Santo Domingo Ixcatlan', 20),
(20511, 'Santo Domingo Nuxaa', 20),
(20512, 'Santo Domingo Ozolotepec', 20),
(20513, 'Santo Domingo Petapa', 20),
(20514, 'Santo Domingo Roayaga', 20),
(20515, 'Santo Domingo Tehuantepec', 20),
(20516, 'Santo Domingo Teojomulco', 20),
(20517, 'Santo Domingo Tepuxtepec', 20),
(20518, 'Santo Domingo Tlatayapam', 20),
(20519, 'Santo Domingo Tomaltepec', 20),
(20520, 'Santo Domingo Tonala', 20),
(20521, 'Santo Domingo Tonaltepec', 20),
(20522, 'Santo Domingo Xagacia', 20),
(20523, 'Santo Domingo Yanhuitlan', 20),
(20524, 'Santo Domingo Yodohino', 20),
(20525, 'Santo Domingo Zanatepec', 20),
(20526, 'Santos Reyes Nopala', 20),
(20527, 'Santos Reyes Papalo', 20),
(20528, 'Santos Reyes Tepejillo', 20),
(20529, 'Santos Reyes Yucuna', 20),
(20530, 'Santo Tomas Jalieza', 20),
(20531, 'Santo Tomas Mazaltepec', 20),
(20532, 'Santo Tomas Ocotepec', 20),
(20533, 'Santo Tomas Tamazulapan', 20),
(20534, 'San Vicente Coatlan', 20),
(20535, 'San Vicente Lachixio', 20),
(20537, 'Silacayoapam', 20),
(20538, 'Sitio de Xitlapehua', 20),
(20539, 'Soledad Etla', 20),
(20540, 'Villa de Tamazulapam del Progreso', 20),
(20541, 'Tanetze de Zaragoza', 20),
(20542, 'Taniche', 20),
(20543, 'Tataltepec de Valdes', 20),
(20544, 'Teococuilco de Marcos Perez', 20),
(20545, 'Teotitlan de Flores Magon', 20),
(20546, 'Teotitlan del Valle', 20),
(20547, 'Teotongo', 20),
(20548, 'Tepelmeme Villa de Morelos', 20),
(20550, 'San Jeronimo Tlacochahuaya', 20),
(20551, 'Tlacolula de Matamoros', 20),
(20552, 'Tlacotepec Plumas', 20),
(20553, 'Tlalixtac de Cabrera', 20),
(20554, 'Totontepec Villa de Morelos', 20),
(20555, 'Trinidad Zaachila', 20),
(20556, 'La Trinidad Vista Hermosa', 20),
(20557, 'Union Hidalgo', 20),
(20558, 'Valerio Trujano', 20),
(20559, 'San Juan Bautista Valle Nacional', 20),
(20560, 'Villa Diaz Ordaz', 20),
(20561, 'Yaxe', 20),
(20562, 'Magdalena Yodocono de Porfirio Diaz', 20),
(20563, 'Yogana', 20),
(20564, 'Yutanduchi de Guerrero', 20),
(20565, 'Villa de Zaachila', 20),
(20566, 'San Mateo Yucutindoo', 20),
(20567, 'Zapotitlan Lagunas', 20),
(20568, 'Zapotitlan Palmas', 20),
(20569, 'Santa Ines de Zaragoza', 20),
(20570, 'Zimatlan de Alvarez', 20),
(21001, 'Acajete', 21),
(21002, 'Acateno', 21),
(21003, 'Acatlan', 21),
(21004, 'Acatzingo', 21),
(21005, 'Acteopan', 21),
(21006, 'Ahuacatlan', 21),
(21007, 'Ahuatlan', 21),
(21008, 'Ahuazotepec', 21),
(21009, 'Ahuehuetitla', 21),
(21010, 'Ajalpan', 21),
(21011, 'Albino Zertuche', 21),
(21012, 'Aljojuca', 21),
(21013, 'Altepexi', 21),
(21014, 'Amixtlan', 21),
(21015, 'Amozoc', 21),
(21016, 'Aquixtla', 21),
(21017, 'Atempan', 21),
(21018, 'Atexcal', 21),
(21019, 'Atlixco', 21),
(21020, 'Atoyatempan', 21),
(21021, 'Atzala', 21),
(21022, 'Atzitzihuacan', 21),
(21023, 'Atzitzintla', 21),
(21024, 'Axutla', 21),
(21025, 'Ayotoxco de Guerrero', 21),
(21026, 'Calpan', 21),
(21027, 'Caltepec', 21),
(21028, 'Camocuautla', 21),
(21029, 'Caxhuacan', 21),
(21030, 'Coatepec', 21),
(21031, 'Coatzingo', 21),
(21032, 'Cohetzala', 21),
(21033, 'Cohuecan', 21),
(21034, 'Coronango', 21),
(21035, 'Coxcatlan', 21),
(21036, 'Coyomeapan', 21),
(21037, 'Coyotepec', 21),
(21038, 'Cuapiaxtla de Madero', 21),
(21039, 'Cuautempan', 21),
(21040, 'Cuautinchan', 21),
(21041, 'Cuautlancingo', 21),
(21042, 'Cuayuca de Andrade', 21),
(21043, 'Cuetzalan del Progreso', 21),
(21044, 'Cuyoaco', 21),
(21045, 'Chalchicomula de Sesma', 21),
(21046, 'Chapulco', 21),
(21047, 'Chiautla', 21),
(21048, 'Chiautzingo', 21),
(21049, 'Chiconcuautla', 21),
(21050, 'Chichiquila', 21),
(21051, 'Chietla', 21),
(21052, 'Chigmecatitlan', 21),
(21053, 'Chignahuapan', 21),
(21054, 'Chignautla', 21),
(21055, 'Chila', 21),
(21056, 'Chila de la Sal', 21),
(21057, 'Honey', 21),
(21058, 'Chilchotla', 21),
(21059, 'Chinantla', 21),
(21060, 'Domingo Arenas', 21),
(21061, 'Eloxochitlan', 21),
(21062, 'Epatlan', 21),
(21063, 'Esperanza', 21),
(21064, 'Francisco Z. Mena', 21),
(21065, 'General Felipe Angeles', 21),
(21066, 'Guadalupe', 21),
(21067, 'Guadalupe Victoria', 21),
(21068, 'Hermenegildo Galeana', 21),
(21069, 'Huaquechula', 21),
(21070, 'Huatlatlauca', 21),
(21071, 'Huauchinango', 21),
(21072, 'Huehuetla', 21),
(21073, 'Huehuetlan el Chico', 21),
(21074, 'Huejotzingo', 21),
(21075, 'Hueyapan', 21),
(21076, 'Hueytamalco', 21),
(21077, 'Hueytlalpan', 21),
(21078, 'Huitzilan de Serdan', 21),
(21079, 'Huitziltepec', 21),
(21080, 'Atlequizayan', 21),
(21081, 'Ixcamilpa de Guerrero', 21),
(21082, 'Ixcaquixtla', 21),
(21083, 'Ixtacamaxtitlan', 21),
(21084, 'Ixtepec', 21),
(21085, 'Izucar de Matamoros', 21),
(21086, 'Jalpan', 21),
(21087, 'Jolalpan', 21),
(21088, 'Jonotla', 21),
(21089, 'Jopala', 21),
(21090, 'Juan C. Bonilla', 21),
(21091, 'Juan Galindo', 21),
(21092, 'Juan N. Mendez', 21),
(21093, 'Lafragua', 21),
(21094, 'Libres', 21),
(21095, 'La Magdalena Tlatlauquitepec', 21),
(21096, 'Mazapiltepec de Juarez', 21),
(21097, 'Mixtla', 21),
(21098, 'Molcaxac', 21),
(21100, 'Naupan', 21),
(21101, 'Nauzontla', 21),
(21102, 'Nealtican', 21),
(21103, 'Nicolas Bravo', 21),
(21104, 'Nopalucan', 21),
(21105, 'Ocotepec', 21),
(21106, 'Ocoyucan', 21),
(21107, 'Olintla', 21),
(21108, 'Oriental', 21),
(21109, 'Pahuatlan', 21),
(21110, 'Palmar de Bravo', 21),
(21111, 'Pantepec', 21),
(21112, 'Petlalcingo', 21),
(21113, 'Piaxtla', 21),
(21114, 'Puebla', 21),
(21115, 'Quecholac', 21),
(21116, 'Quimixtlan', 21),
(21117, 'Rafael Lara Grajales', 21),
(21118, 'Los Reyes de Juarez', 21),
(21119, 'San Andres Cholula', 21),
(21121, 'San Diego la Mesa Tochimiltzingo', 21),
(21122, 'San Felipe Teotlalcingo', 21),
(21123, 'San Felipe Tepatlan', 21),
(21124, 'San Gabriel Chilac', 21),
(21125, 'San Gregorio Atzompa', 21),
(21126, 'San Jeronimo Tecuanipan', 21),
(21127, 'San Jeronimo Xayacatlan', 21),
(21128, 'San Jose Chiapa', 21),
(21129, 'San Jose Miahuatlan', 21),
(21130, 'San Juan Atenco', 21),
(21131, 'San Juan Atzompa', 21),
(21132, 'San Martin Texmelucan', 21),
(21133, 'San Martin Totoltepec', 21),
(21134, 'San Matias Tlalancaleca', 21),
(21135, 'San Miguel Ixitlan', 21),
(21136, 'San Miguel Xoxtla', 21),
(21137, 'San Nicolas Buenos Aires', 21),
(21138, 'San Nicolas de los Ranchos', 21),
(21139, 'San Pablo Anicano', 21),
(21140, 'San Pedro Cholula', 21),
(21141, 'San Pedro Yeloixtlahuaca', 21),
(21142, 'San Salvador el Seco', 21),
(21143, 'San Salvador el Verde', 21),
(21144, 'San Salvador Huixcolotla', 21),
(21145, 'San Sebastian Tlacotepec', 21),
(21146, 'Santa Catarina Tlaltempan', 21),
(21147, 'Santa Ines Ahuatempan', 21),
(21148, 'Santa Isabel Cholula', 21),
(21149, 'Santiago Miahuatlan', 21),
(21150, 'Huehuetlan el Grande', 21),
(21151, 'Santo Tomas Hueyotlipan', 21),
(21152, 'Soltepec', 21),
(21153, 'Tecali de Herrera', 21),
(21154, 'Tecamachalco', 21),
(21155, 'Tecomatlan', 21),
(21156, 'Tehuacan', 21),
(21157, 'Tehuitzingo', 21),
(21158, 'Tenampulco', 21),
(21159, 'Teopantlan', 21),
(21160, 'Teotlalco', 21),
(21161, 'Tepanco de Lopez', 21);
INSERT INTO `Municipios` (`Id_municipio`, `Municipio`, `Id_estado`) VALUES
(21162, 'Tepango de Rodriguez', 21),
(21163, 'Tepatlaxco de Hidalgo', 21),
(21164, 'Tepeaca', 21),
(21165, 'Tepemaxalco', 21),
(21166, 'Tepeojuma', 21),
(21167, 'Tepetzintla', 21),
(21168, 'Tepexco', 21),
(21169, 'Tepexi de Rodriguez', 21),
(21170, 'Tepeyahualco', 21),
(21171, 'Tepeyahualco de Cuauhtemoc', 21),
(21172, 'Tetela de Ocampo', 21),
(21173, 'Teteles de Avila Castillo', 21),
(21174, 'Teziutlan', 21),
(21175, 'Tianguismanalco', 21),
(21176, 'Tilapa', 21),
(21177, 'Tlacotepec de Benito Juarez', 21),
(21178, 'Tlacuilotepec', 21),
(21179, 'Tlachichuca', 21),
(21180, 'Tlahuapan', 21),
(21181, 'Tlaltenango', 21),
(21182, 'Tlanepantla', 21),
(21183, 'Tlaola', 21),
(21184, 'Tlapacoya', 21),
(21185, 'Tlapanala', 21),
(21186, 'Tlatlauquitepec', 21),
(21187, 'Tlaxco', 21),
(21188, 'Tochimilco', 21),
(21189, 'Tochtepec', 21),
(21190, 'Totoltepec de Guerrero', 21),
(21191, 'Tulcingo', 21),
(21192, 'Tuzamapan de Galeana', 21),
(21193, 'Tzicatlacoyan', 21),
(21194, 'Venustiano Carranza', 21),
(21195, 'Vicente Guerrero', 21),
(21196, 'Xayacatlan de Bravo', 21),
(21197, 'Xicotepec', 21),
(21198, 'Xicotlan', 21),
(21199, 'Xiutetelco', 21),
(21200, 'Xochiapulco', 21),
(21201, 'Xochiltepec', 21),
(21202, 'Xochitlan de Vicente Suarez', 21),
(21203, 'Xochitlan Todos Santos', 21),
(21204, 'Yaonahuac', 21),
(21205, 'Yehualtepec', 21),
(21206, 'Zacapala', 21),
(21207, 'Zacapoaxtla', 21),
(21208, 'Zacatlan', 21),
(21209, 'Zapotitlan', 21),
(21210, 'Zapotitlan de Mendez', 21),
(21211, 'Zaragoza', 21),
(21212, 'Zautla', 21),
(21213, 'Zihuateutla', 21),
(21214, 'Zinacatepec', 21),
(21215, 'Zongozotla', 21),
(21216, 'Zoquiapan', 21),
(21217, 'Zoquitlan', 21),
(22001, 'Amealco de Bonfil', 22),
(22002, 'Pinal de Amoles', 22),
(22003, 'Arroyo Seco', 22),
(22004, 'Cadereyta de Montes', 22),
(22005, 'Colon', 22),
(22006, 'Corregidora', 22),
(22007, 'Ezequiel Montes', 22),
(22008, 'Huimilpan', 22),
(22009, 'Jalpan de Serra', 22),
(22010, 'Landa de Matamoros', 22),
(22011, 'El Marques', 22),
(22012, 'Pedro Escobedo', 22),
(22013, 'Penamiller', 22),
(22014, 'Queretaro', 22),
(22015, 'San Joaquin', 22),
(22016, 'San Juan del Rio', 22),
(22017, 'Tequisquiapan', 22),
(22018, 'Toliman', 22),
(23001, 'Cozumel', 23),
(23002, 'Felipe Carrillo Puerto', 23),
(23003, 'Isla Mujeres', 23),
(23004, 'Othon P. Blanco', 23),
(23005, 'Benito Juarez', 23),
(23006, 'Jose Maria Morelos', 23),
(23007, 'Lazaro Cardenas', 23),
(23008, 'Solidaridad', 23),
(23009, 'Tulum', 23),
(23010, 'Bacalar', 23),
(23011, 'Puerto Morelos', 23),
(24001, 'Ahualulco', 24),
(24002, 'Alaquines', 24),
(24003, 'Aquismon', 24),
(24004, 'Armadillo de los Infante', 24),
(24005, 'Cardenas', 24),
(24006, 'Catorce', 24),
(24007, 'Cedral', 24),
(24008, 'Cerritos', 24),
(24009, 'Cerro de San Pedro', 24),
(24010, 'Ciudad del Maiz', 24),
(24011, 'Ciudad Fernandez', 24),
(24012, 'Tancanhuitz', 24),
(24013, 'Ciudad Valles', 24),
(24014, 'Coxcatlan', 24),
(24015, 'Charcas', 24),
(24016, 'Ebano', 24),
(24017, 'Guadalcazar', 24),
(24018, 'Huehuetlan', 24),
(24019, 'Lagunillas', 24),
(24020, 'Matehuala', 24),
(24021, 'Mexquitic de Carmona', 24),
(24022, 'Moctezuma', 24),
(24023, 'Rayon', 24),
(24024, 'Rioverde', 24),
(24025, 'Salinas', 24),
(24026, 'San Antonio', 24),
(24027, 'San Ciro de Acosta', 24),
(24028, 'San Luis Potosi', 24),
(24029, 'San Martin Chalchicuautla', 24),
(24030, 'San Nicolas Tolentino', 24),
(24031, 'Santa Catarina', 24),
(24032, 'Santa Maria del Rio', 24),
(24033, 'Santo Domingo', 24),
(24034, 'San Vicente Tancuayalab', 24),
(24035, 'Soledad de Graciano Sanchez', 24),
(24036, 'Tamasopo', 24),
(24037, 'Tamazunchale', 24),
(24038, 'Tampacan', 24),
(24039, 'Tampamolon Corona', 24),
(24040, 'Tamuin', 24),
(24041, 'Tanlajas', 24),
(24042, 'Tanquian de Escobedo', 24),
(24043, 'Tierra Nueva', 24),
(24044, 'Vanegas', 24),
(24045, 'Venado', 24),
(24046, 'Villa de Arriaga', 24),
(24047, 'Villa de Guadalupe', 24),
(24048, 'Villa de la Paz', 24),
(24049, 'Villa de Ramos', 24),
(24050, 'Villa de Reyes', 24),
(24051, 'Villa Hidalgo', 24),
(24052, 'Villa Juarez', 24),
(24053, 'Axtla de Terrazas', 24),
(24054, 'Xilitla', 24),
(24055, 'Zaragoza', 24),
(24056, 'Villa de Arista', 24),
(24057, 'Matlapa', 24),
(24058, 'El Naranjo', 24),
(25001, 'Ahome', 25),
(25002, 'Angostura', 25),
(25003, 'Badiraguato', 25),
(25004, 'Concordia', 25),
(25005, 'Cosala', 25),
(25006, 'Culiacan', 25),
(25007, 'Choix', 25),
(25008, 'Elota', 25),
(25009, 'Escuinapa', 25),
(25010, 'El Fuerte', 25),
(25011, 'Guasave', 25),
(25012, 'Mazatlan', 25),
(25013, 'Mocorito', 25),
(25014, 'Rosario', 25),
(25015, 'Salvador Alvarado', 25),
(25016, 'San Ignacio', 25),
(25017, 'Sinaloa', 25),
(25018, 'Navolato', 25),
(26001, 'Aconchi', 26),
(26002, 'Agua Prieta', 26),
(26003, 'Alamos', 26),
(26004, 'Altar', 26),
(26005, 'Arivechi', 26),
(26006, 'Arizpe', 26),
(26007, 'Atil', 26),
(26008, 'Bacadehuachi', 26),
(26009, 'Bacanora', 26),
(26010, 'Bacerac', 26),
(26011, 'Bacoachi', 26),
(26012, 'Bacum', 26),
(26013, 'Banamichi', 26),
(26014, 'Baviacora', 26),
(26015, 'Bavispe', 26),
(26016, 'Benjamin Hill', 26),
(26017, 'Caborca', 26),
(26018, 'Cajeme', 26),
(26019, 'Cananea', 26),
(26020, 'Carbo', 26),
(26021, 'La Colorada', 26),
(26022, 'Cucurpe', 26),
(26023, 'Cumpas', 26),
(26024, 'Divisaderos', 26),
(26025, 'Empalme', 26),
(26026, 'Etchojoa', 26),
(26027, 'Fronteras', 26),
(26028, 'Granados', 26),
(26029, 'Guaymas', 26),
(26030, 'Hermosillo', 26),
(26031, 'Huachinera', 26),
(26032, 'Huasabas', 26),
(26033, 'Huatabampo', 26),
(26034, 'Huepac', 26),
(26035, 'Imuris', 26),
(26036, 'Magdalena', 26),
(26037, 'Mazatan', 26),
(26038, 'Moctezuma', 26),
(26039, 'Naco', 26),
(26040, 'Nacori Chico', 26),
(26041, 'Nacozari de Garcia', 26),
(26042, 'Navojoa', 26),
(26043, 'Nogales', 26),
(26044, 'Onavas', 26),
(26045, 'Opodepe', 26),
(26046, 'Oquitoa', 26),
(26047, 'Pitiquito', 26),
(26049, 'Quiriego', 26),
(26050, 'Rayon', 26),
(26051, 'Rosario', 26),
(26052, 'Sahuaripa', 26),
(26053, 'San Felipe de Jesus', 26),
(26054, 'San Javier', 26),
(26055, 'San Luis Rio Colorado', 26),
(26056, 'San Miguel de Horcasitas', 26),
(26057, 'San Pedro de la Cueva', 26),
(26058, 'Santa Ana', 26),
(26059, 'Santa Cruz', 26),
(26060, 'Saric', 26),
(26061, 'Soyopa', 26),
(26062, 'Suaqui Grande', 26),
(26063, 'Tepache', 26),
(26064, 'Trincheras', 26),
(26065, 'Tubutama', 26),
(26066, 'Ures', 26),
(26067, 'Villa Hidalgo', 26),
(26068, 'Villa Pesqueira', 26),
(26069, 'Yecora', 26),
(26070, 'General Plutarco Elias Calles', 26),
(26071, 'Benito Juarez', 26),
(26072, 'San Ignacio Rio Muerto', 26),
(27001, 'Balancan', 27),
(27002, 'Cardenas', 27),
(27003, 'Centla', 27),
(27004, 'Centro', 27),
(27005, 'Comalcalco', 27),
(27006, 'Cunduacan', 27),
(27007, 'Emiliano Zapata', 27),
(27008, 'Huimanguillo', 27),
(27009, 'Jalapa', 27),
(27010, 'Jalpa de Mendez', 27),
(27011, 'Jonuta', 27),
(27012, 'Macuspana', 27),
(27013, 'Nacajuca', 27),
(27014, 'Paraiso', 27),
(27015, 'Tacotalpa', 27),
(27016, 'Teapa', 27),
(27017, 'Tenosique', 27),
(28001, 'Abasolo', 28),
(28002, 'Aldama', 28),
(28003, 'Altamira', 28),
(28004, 'Antiguo Morelos', 28),
(28005, 'Burgos', 28),
(28006, 'Bustamante', 28),
(28007, 'Camargo', 28),
(28008, 'Casas', 28),
(28009, 'Ciudad Madero', 28),
(28010, 'Cruillas', 28),
(28011, 'Gomez Farias', 28),
(28012, 'Gonzalez', 28),
(28013, 'Guemez', 28),
(28014, 'Guerrero', 28),
(28015, 'Gustavo Diaz Ordaz', 28),
(28016, 'Hidalgo', 28),
(28017, 'Jaumave', 28),
(28018, 'Jimenez', 28),
(28019, 'Llera', 28),
(28020, 'Mainero', 28),
(28021, 'El Mante', 28),
(28022, 'Matamoros', 28),
(28023, 'Mendez', 28),
(28024, 'Mier', 28),
(28025, 'Miguel Aleman', 28),
(28026, 'Miquihuana', 28),
(28027, 'Nuevo Laredo', 28),
(28028, 'Nuevo Morelos', 28),
(28029, 'Ocampo', 28),
(28030, 'Padilla', 28),
(28031, 'Palmillas', 28),
(28032, 'Reynosa', 28),
(28033, 'Rio Bravo', 28),
(28034, 'San Carlos', 28),
(28035, 'San Fernando', 28),
(28036, 'San Nicolas', 28),
(28037, 'Soto la Marina', 28),
(28038, 'Tampico', 28),
(28039, 'Tula', 28),
(28040, 'Valle Hermoso', 28),
(28041, 'Victoria', 28),
(28042, 'Villagran', 28),
(28043, 'Xicotencatl', 28),
(29001, 'Amaxac de Guerrero', 29),
(29002, 'Apetatitlan de Antonio Carvajal', 29),
(29003, 'Atlangatepec', 29),
(29004, 'Atltzayanca', 29),
(29005, 'Apizaco', 29),
(29006, 'Calpulalpan', 29),
(29007, 'El Carmen Tequexquitla', 29),
(29008, 'Cuapiaxtla', 29),
(29009, 'Cuaxomulco', 29),
(29010, 'Chiautempan', 29),
(29013, 'Huamantla', 29),
(29014, 'Hueyotlipan', 29),
(29015, 'Ixtacuixtla de Mariano Matamoros', 29),
(29016, 'Ixtenco', 29),
(29017, 'Mazatecochco de Jose Maria Morelos', 29),
(29018, 'Contla de Juan Cuamatzi', 29),
(29019, 'Tepetitla de Lardizabal', 29),
(29020, 'Sanctorum de Lazaro Cardenas', 29),
(29021, 'Nanacamilpa de Mariano Arista', 29),
(29022, 'Acuamanala de Miguel Hidalgo', 29),
(29023, 'Nativitas', 29),
(29024, 'Panotla', 29),
(29025, 'San Pablo del Monte', 29),
(29026, 'Santa Cruz Tlaxcala', 29),
(29027, 'Tenancingo', 29),
(29028, 'Teolocholco', 29),
(29029, 'Tepeyanco', 29),
(29030, 'Terrenate', 29),
(29031, 'Tetla de la Solidaridad', 29),
(29032, 'Tetlatlahuca', 29),
(29033, 'Tlaxcala', 29),
(29034, 'Tlaxco', 29),
(29035, 'Tocatlan', 29),
(29036, 'Totolac', 29),
(29037, 'Ziltlaltepec de Trinidad Sanchez Santos', 29),
(29038, 'Tzompantepec', 29),
(29039, 'Xaloztoc', 29),
(29040, 'Xaltocan', 29),
(29041, 'Papalotla de Xicohtencatl', 29),
(29042, 'Xicohtzinco', 29),
(29043, 'Yauhquemehcan', 29),
(29044, 'Zacatelco', 29),
(29045, 'Benito Juarez', 29),
(29046, 'Emiliano Zapata', 29),
(29047, 'Lazaro Cardenas', 29),
(29048, 'La Magdalena Tlaltelulco', 29),
(29049, 'San Damian Texoloc', 29),
(29050, 'San Francisco Tetlanohcan', 29),
(29051, 'San Jeronimo Zacualpan', 29),
(29052, 'San Jose Teacalco', 29),
(29053, 'San Juan Huactzinco', 29),
(29054, 'San Lorenzo Axocomanitla', 29),
(29055, 'San Lucas Tecopilco', 29),
(29056, 'Santa Ana Nopalucan', 29),
(29057, 'Santa Apolonia Teacalco', 29),
(29058, 'Santa Catarina Ayometla', 29),
(29059, 'Santa Cruz Quilehtla', 29),
(29060, 'Santa Isabel Xiloxoxtla', 29),
(30001, 'Acajete', 30),
(30002, 'Acatlan', 30),
(30003, 'Acayucan', 30),
(30004, 'Actopan', 30),
(30005, 'Acula', 30),
(30006, 'Acultzingo', 30),
(30007, 'Camaron de Tejeda', 30),
(30008, 'Alpatlahuac', 30),
(30009, 'Alto Lucero de Gutierrez Barrios', 30),
(30010, 'Altotonga', 30),
(30011, 'Alvarado', 30),
(30012, 'Amatitlan', 30),
(30013, 'Naranjos Amatlan', 30),
(30014, 'Amatlan de los Reyes', 30),
(30015, 'Angel R. Cabada', 30),
(30016, 'La Antigua', 30),
(30017, 'Apazapan', 30),
(30018, 'Aquila', 30),
(30019, 'Astacinga', 30),
(30020, 'Atlahuilco', 30),
(30021, 'Atoyac', 30),
(30022, 'Atzacan', 30),
(30023, 'Atzalan', 30),
(30024, 'Tlaltetela', 30),
(30025, 'Ayahualulco', 30),
(30026, 'Banderilla', 30),
(30027, 'Benito Juarez', 30),
(30028, 'Boca del Rio', 30),
(30029, 'Calcahualco', 30),
(30030, 'Camerino Z. Mendoza', 30),
(30031, 'Carrillo Puerto', 30),
(30032, 'Catemaco', 30),
(30033, 'Cazones de Herrera', 30),
(30034, 'Cerro Azul', 30),
(30035, 'Citlaltepetl', 30),
(30036, 'Coacoatzintla', 30),
(30037, 'Coahuitlan', 30),
(30038, 'Coatepec', 30),
(30039, 'Coatzacoalcos', 30),
(30040, 'Coatzintla', 30),
(30041, 'Coetzala', 30),
(30042, 'Colipa', 30),
(30043, 'Comapa', 30),
(30044, 'Cordoba', 30),
(30045, 'Cosamaloapan de Carpio', 30),
(30046, 'Cosautlan de Carvajal', 30),
(30047, 'Coscomatepec', 30),
(30048, 'Cosoleacaque', 30),
(30049, 'Cotaxtla', 30),
(30050, 'Coxquihui', 30),
(30051, 'Coyutla', 30),
(30052, 'Cuichapa', 30),
(30053, 'Cuitlahuac', 30),
(30054, 'Chacaltianguis', 30),
(30055, 'Chalma', 30),
(30056, 'Chiconamel', 30),
(30057, 'Chiconquiaco', 30),
(30058, 'Chicontepec', 30),
(30059, 'Chinameca', 30),
(30060, 'Chinampa de Gorostiza', 30),
(30061, 'Las Choapas', 30),
(30062, 'Chocaman', 30),
(30063, 'Chontla', 30),
(30064, 'Chumatlan', 30),
(30065, 'Emiliano Zapata', 30),
(30066, 'Espinal', 30),
(30067, 'Filomeno Mata', 30),
(30068, 'Fortin', 30),
(30069, 'Gutierrez Zamora', 30),
(30070, 'Hidalgotitlan', 30),
(30071, 'Huatusco', 30),
(30072, 'Huayacocotla', 30),
(30073, 'Hueyapan de Ocampo', 30),
(30074, 'Huiloapan de Cuauhtemoc', 30),
(30075, 'Ignacio de la Llave', 30),
(30076, 'Ilamatlan', 30),
(30077, 'Isla', 30),
(30078, 'Ixcatepec', 30),
(30079, 'Ixhuacan de los Reyes', 30),
(30080, 'Ixhuatlan del Cafe', 30),
(30081, 'Ixhuatlancillo', 30),
(30082, 'Ixhuatlan del Sureste', 30),
(30083, 'Ixhuatlan de Madero', 30),
(30084, 'Ixmatlahuacan', 30),
(30085, 'Ixtaczoquitlan', 30),
(30086, 'Jalacingo', 30),
(30087, 'Xalapa', 30),
(30088, 'Jalcomulco', 30),
(30089, 'Jaltipan', 30),
(30090, 'Jamapa', 30),
(30091, 'Jesus Carranza', 30),
(30092, 'Xico', 30),
(30093, 'Jilotepec', 30),
(30094, 'Juan Rodriguez Clara', 30),
(30095, 'Juchique de Ferrer', 30),
(30096, 'Landero y Coss', 30),
(30097, 'Lerdo de Tejada', 30),
(30098, 'Magdalena', 30),
(30099, 'Maltrata', 30),
(30100, 'Manlio Fabio Altamirano', 30),
(30101, 'Mariano Escobedo', 30),
(30102, 'Martinez de la Torre', 30),
(30103, 'Mecatlan', 30),
(30104, 'Mecayapan', 30),
(30105, 'Medellin de Bravo', 30),
(30106, 'Miahuatlan', 30),
(30107, 'Las Minas', 30),
(30108, 'Minatitlan', 30),
(30109, 'Misantla', 30),
(30110, 'Mixtla de Altamirano', 30),
(30111, 'Moloacan', 30),
(30112, 'Naolinco', 30),
(30113, 'Naranjal', 30),
(30114, 'Nautla', 30),
(30115, 'Nogales', 30),
(30116, 'Oluta', 30),
(30117, 'Omealca', 30),
(30118, 'Orizaba', 30),
(30119, 'Otatitlan', 30),
(30120, 'Oteapan', 30),
(30122, 'Pajapan', 30),
(30123, 'Panuco', 30),
(30124, 'Papantla', 30),
(30125, 'Paso del Macho', 30),
(30126, 'Paso de Ovejas', 30),
(30127, 'La Perla', 30),
(30128, 'Perote', 30),
(30129, 'Platon Sanchez', 30),
(30130, 'Playa Vicente', 30),
(30131, 'Poza Rica de Hidalgo', 30),
(30132, 'Las Vigas de Ramirez', 30),
(30133, 'Pueblo Viejo', 30),
(30134, 'Puente Nacional', 30),
(30135, 'Rafael Delgado', 30),
(30136, 'Rafael Lucio', 30),
(30137, 'Los Reyes', 30),
(30138, 'Rio Blanco', 30),
(30139, 'Saltabarranca', 30),
(30140, 'San Andres Tenejapan', 30),
(30141, 'San Andres Tuxtla', 30),
(30142, 'San Juan Evangelista', 30),
(30143, 'Santiago Tuxtla', 30),
(30144, 'Sayula de Aleman', 30),
(30145, 'Soconusco', 30),
(30146, 'Sochiapa', 30),
(30147, 'Soledad Atzompa', 30),
(30148, 'Soledad de Doblado', 30),
(30149, 'Soteapan', 30),
(30150, 'Tamalin', 30),
(30151, 'Tamiahua', 30),
(30152, 'Tampico Alto', 30),
(30153, 'Tancoco', 30),
(30154, 'Tantima', 30),
(30155, 'Tantoyuca', 30),
(30156, 'Tatatila', 30),
(30157, 'Castillo de Teayo', 30),
(30158, 'Tecolutla', 30),
(30159, 'Tehuipango', 30),
(30160, 'Alamo Temapache', 30),
(30161, 'Tempoal', 30),
(30162, 'Tenampa', 30),
(30163, 'Tenochtitlan', 30),
(30164, 'Teocelo', 30),
(30165, 'Tepatlaxco', 30),
(30166, 'Tepetlan', 30),
(30167, 'Tepetzintla', 30),
(30168, 'Tequila', 30),
(30169, 'Jose Azueta', 30),
(30170, 'Texcatepec', 30),
(30171, 'Texhuacan', 30),
(30172, 'Texistepec', 30),
(30173, 'Tezonapa', 30),
(30174, 'Tierra Blanca', 30),
(30175, 'Tihuatlan', 30),
(30176, 'Tlacojalpan', 30),
(30177, 'Tlacolulan', 30),
(30178, 'Tlacotalpan', 30),
(30179, 'Tlacotepec de Mejia', 30),
(30180, 'Tlachichilco', 30),
(30181, 'Tlalixcoyan', 30),
(30182, 'Tlalnelhuayocan', 30),
(30183, 'Tlapacoyan', 30),
(30184, 'Tlaquilpa', 30),
(30185, 'Tlilapan', 30),
(30186, 'Tomatlan', 30),
(30187, 'Tonayan', 30),
(30188, 'Totutla', 30),
(30189, 'Tuxpan', 30),
(30190, 'Tuxtilla', 30),
(30191, 'Ursulo Galvan', 30),
(30192, 'Vega de Alatorre', 30),
(30193, 'Veracruz', 30),
(30194, 'Villa Aldama', 30),
(30195, 'Xoxocotla', 30),
(30196, 'Yanga', 30),
(30197, 'Yecuatla', 30),
(30198, 'Zacualpan', 30),
(30199, 'Zaragoza', 30),
(30200, 'Zentla', 30),
(30201, 'Zongolica', 30),
(30202, 'Zontecomatlan de Lopez y Fuentes', 30),
(30203, 'Zozocolco de Hidalgo', 30),
(30204, 'Agua Dulce', 30),
(30205, 'El Higo', 30),
(30206, 'Nanchital de Lazaro Cardenas del Rio', 30),
(30207, 'Tres Valles', 30),
(30208, 'Carlos A. Carrillo', 30),
(30209, 'Tatahuicapan de Juarez', 30),
(30210, 'Uxpanapa', 30),
(30211, 'San Rafael', 30),
(30212, 'Santiago Sochiapan', 30),
(31001, 'Abala', 31),
(31002, 'Acanceh', 31),
(31003, 'Akil', 31),
(31004, 'Baca', 31),
(31005, 'Bokoba', 31),
(31006, 'Buctzotz', 31),
(31007, 'Cacalchen', 31),
(31008, 'Calotmul', 31),
(31009, 'Cansahcab', 31),
(31010, 'Cantamayec', 31),
(31011, 'Celestun', 31),
(31012, 'Cenotillo', 31),
(31013, 'Conkal', 31),
(31014, 'Cuncunul', 31),
(31015, 'Cuzama', 31),
(31016, 'Chacsinkin', 31),
(31017, 'Chankom', 31),
(31018, 'Chapab', 31),
(31019, 'Chemax', 31),
(31020, 'Chicxulub Pueblo', 31),
(31021, 'Chichimila', 31),
(31022, 'Chikindzonot', 31),
(31023, 'Chochola', 31),
(31024, 'Chumayel', 31),
(31025, 'Dzan', 31),
(31026, 'Dzemul', 31),
(31027, 'Dzidzantun', 31),
(31028, 'Dzilam de Bravo', 31),
(31029, 'Dzilam Gonzalez', 31),
(31030, 'Dzitas', 31),
(31031, 'Dzoncauich', 31),
(31032, 'Espita', 31),
(31033, 'Halacho', 31),
(31034, 'Hocaba', 31),
(31035, 'Hoctun', 31),
(31036, 'Homun', 31),
(31037, 'Huhi', 31),
(31038, 'Hunucma', 31),
(31039, 'Ixil', 31),
(31040, 'Izamal', 31),
(31041, 'Kanasin', 31),
(31042, 'Kantunil', 31),
(31043, 'Kaua', 31),
(31044, 'Kinchil', 31),
(31045, 'Kopoma', 31),
(31046, 'Mama', 31),
(31047, 'Mani', 31),
(31048, 'Maxcanu', 31),
(31049, 'Mayapan', 31),
(31050, 'Merida', 31),
(31051, 'Mococha', 31),
(31052, 'Motul', 31),
(31053, 'Muna', 31),
(31054, 'Muxupip', 31),
(31055, 'Opichen', 31),
(31056, 'Oxkutzcab', 31),
(31057, 'Panaba', 31),
(31058, 'Peto', 31),
(31059, 'Progreso', 31),
(31060, 'Quintana Roo', 31),
(31061, 'Rio Lagartos', 31),
(31062, 'Sacalum', 31),
(31063, 'Samahil', 31),
(31064, 'Sanahcat', 31),
(31065, 'San Felipe', 31),
(31066, 'Santa Elena', 31),
(31067, 'Seye', 31),
(31068, 'Sinanche', 31),
(31069, 'Sotuta', 31),
(31070, 'Sucila', 31),
(31071, 'Sudzal', 31),
(31072, 'Suma', 31),
(31073, 'Tahdziu', 31),
(31074, 'Tahmek', 31),
(31075, 'Teabo', 31),
(31076, 'Tecoh', 31),
(31077, 'Tekal de Venegas', 31),
(31078, 'Tekanto', 31),
(31079, 'Tekax', 31),
(31080, 'Tekit', 31),
(31081, 'Tekom', 31),
(31082, 'Telchac Pueblo', 31),
(31083, 'Telchac Puerto', 31),
(31084, 'Temax', 31),
(31085, 'Temozon', 31),
(31086, 'Tepakan', 31),
(31087, 'Tetiz', 31),
(31088, 'Teya', 31),
(31089, 'Ticul', 31),
(31090, 'Timucuy', 31),
(31091, 'Tinum', 31),
(31092, 'Tixcacalcupul', 31),
(31093, 'Tixkokob', 31),
(31094, 'Tixmehuac', 31),
(31095, 'Tixpehual', 31),
(31096, 'Tizimin', 31),
(31097, 'Tunkas', 31),
(31098, 'Tzucacab', 31),
(31099, 'Uayma', 31),
(31100, 'Ucu', 31),
(31101, 'Uman', 31),
(31102, 'Valladolid', 31),
(31103, 'Xocchel', 31),
(31104, 'Yaxcaba', 31),
(31105, 'Yaxkukul', 31),
(31106, 'Yobain', 31),
(32001, 'Apozol', 32),
(32002, 'Apulco', 32),
(32003, 'Atolinga', 32),
(32004, 'Benito Juarez', 32),
(32005, 'Calera', 32),
(32007, 'Concepcion del Oro', 32),
(32008, 'Cuauhtemoc', 32),
(32009, 'Chalchihuites', 32),
(32010, 'Fresnillo', 32),
(32011, 'Trinidad Garcia de la Cadena', 32),
(32012, 'Genaro Codina', 32),
(32013, 'General Enrique Estrada', 32),
(32014, 'General Francisco R. Murguia', 32),
(32015, 'El Plateado de Joaquin Amaro', 32),
(32016, 'General Panfilo Natera', 32),
(32017, 'Guadalupe', 32),
(32018, 'Huanusco', 32),
(32019, 'Jalpa', 32),
(32020, 'Jerez', 32),
(32021, 'Jimenez del Teul', 32),
(32022, 'Juan Aldama', 32),
(32023, 'Juchipila', 32),
(32024, 'Loreto', 32),
(32025, 'Luis Moya', 32),
(32026, 'Mazapil', 32),
(32027, 'Melchor Ocampo', 32),
(32028, 'Mezquital del Oro', 32),
(32029, 'Miguel Auza', 32),
(32030, 'Momax', 32),
(32031, 'Monte Escobedo', 32),
(32032, 'Morelos', 32),
(32033, 'Moyahua de Estrada', 32),
(32034, 'Nochistlan de Mejia', 32),
(32035, 'Noria de Angeles', 32),
(32036, 'Ojocaliente', 32),
(32037, 'Panuco', 32),
(32038, 'Pinos', 32),
(32039, 'Rio Grande', 32),
(32040, 'Sain Alto', 32),
(32041, 'El Salvador', 32),
(32042, 'Sombrerete', 32),
(32043, 'Susticacan', 32),
(32044, 'Tabasco', 32),
(32045, 'Tepechitlan', 32),
(32046, 'Tepetongo', 32),
(32047, 'Teul de Gonzalez Ortega', 32),
(32048, 'Tlaltenango de Sanchez Roman', 32),
(32049, 'Valparaiso', 32),
(32050, 'Vetagrande', 32),
(32051, 'Villa de Cos', 32),
(32052, 'Villa Garcia', 32),
(32053, 'Villa Gonzalez Ortega', 32),
(32054, 'Villa Hidalgo', 32),
(32055, 'Villanueva', 32),
(32056, 'Zacatecas', 32),
(32057, 'Trancoso', 32),
(32058, 'Santa Maria de la Paz', 32);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Puestos`
--

CREATE TABLE `Puestos` (
  `Id_puesto` int NOT NULL,
  `Nombre` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Puestos`
--

INSERT INTO `Puestos` (`Id_puesto`, `Nombre`) VALUES
(1, 'Almacén'),
(2, 'Cuidador de animales'),
(3, 'Alimentación'),
(4, 'Mantenimiento');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(245) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `email`, `password`) VALUES
(24, 'Juan', '$2y$10$L098kT0kNNXrnZTRy0r7n.eXtU5BpiQQcV5LaTKH1Fx34dh4H5ir.'),
(25, 'Pablo motos', '$2y$10$tgOMtZCnj.8Ui0xu.TDTA.8/d1P9COr8WLk.9HjeTBdRqosWzXqfy'),
(26, 'Juanito Perez', '$2y$10$FqimtpOOF9ZqlFQesgy0u.bSL7xHJtyawIOlui.dGXTOmjnkNN42C'),
(27, 'Karim Garcia Cortes', '$2y$10$t.z6vEahcMcHgly/Gtxnc.SLQi3m9QDkZCLWz2lQiblPMP0egD7T2');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Vacunas`
--

CREATE TABLE `Vacunas` (
  `id_vacuna` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int NOT NULL,
  `PrecioUni` decimal(10,2) DEFAULT NULL,
  `Presentacion` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Vacunas`
--

INSERT INTO `Vacunas` (`id_vacuna`, `nombre`, `cantidad`, `PrecioUni`, `Presentacion`) VALUES
(1, 'Vacuna', 451, 0.00, 'Dosis'),
(2, 'Desparasitante', 530, 50.00, 'ml'),
(3, 'Vitaminas', 369, 20.00, 'gr');

--
-- Disparadores `Vacunas`
--
DELIMITER $$
CREATE TRIGGER `vacunaCaja` AFTER INSERT ON `Vacunas` FOR EACH ROW BEGIN
    DECLARE monto DECIMAL(10,2);

    SET monto = NEW.cantidad * NEW.PrecioUni;

    INSERT INTO Caja (FechaOperacion, TipoOperacion, Monto)
    VALUES (NOW(), 'Gasto', monto);

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Ventas`
--

CREATE TABLE `Ventas` (
  `Id_venta` int NOT NULL,
  `Id_lote` int DEFAULT NULL,
  `FechaVenta` date DEFAULT NULL,
  `GastoDieta` decimal(10,2) DEFAULT NULL,
  `Peso` decimal(10,2) DEFAULT NULL,
  `PrecioKilo` decimal(10,2) DEFAULT NULL,
  `PrecioTotal` int NOT NULL,
  `Animalesventa` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Venta_animal`
--

CREATE TABLE `Venta_animal` (
  `id_venta` int NOT NULL,
  `Arete` varchar(50) DEFAULT NULL,
  `Motivo` varchar(50) DEFAULT NULL,
  `Peso` decimal(10,2) DEFAULT NULL,
  `Precio_kg` decimal(10,2) DEFAULT NULL,
  `Fecha` date DEFAULT NULL,
  `Precio_total` decimal(20,2) GENERATED ALWAYS AS ((`Peso` * `Precio_kg`)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Venta_lote`
--

CREATE TABLE `Venta_lote` (
  `id_venta` int NOT NULL,
  `REEMO` varchar(50) NOT NULL,
  `Motivo` varchar(50) NOT NULL,
  `Precio` decimal(10,2) NOT NULL,
  `Fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Alimentos`
--
ALTER TABLE `Alimentos`
  ADD PRIMARY KEY (`id_alimento`);

--
-- Indices de la tabla `Caja`
--
ALTER TABLE `Caja`
  ADD PRIMARY KEY (`Id_caja`);

--
-- Indices de la tabla `Ciudades`
--
ALTER TABLE `Ciudades`
  ADD PRIMARY KEY (`Id_ciudad`),
  ADD KEY `Id_municipio` (`Id_municipio`);

--
-- Indices de la tabla `CompraAlim`
--
ALTER TABLE `CompraAlim`
  ADD PRIMARY KEY (`id_compralim`),
  ADD KEY `id_alimento` (`id_alimento`);

--
-- Indices de la tabla `CompraVacuna`
--
ALTER TABLE `CompraVacuna`
  ADD PRIMARY KEY (`id_compravacuna`),
  ADD KEY `id_medicamento` (`id_vacuna`);

--
-- Indices de la tabla `CP`
--
ALTER TABLE `CP`
  ADD PRIMARY KEY (`CodigoPostal`),
  ADD KEY `Id_ciudad` (`Id_ciudad`);

--
-- Indices de la tabla `Dieta`
--
ALTER TABLE `Dieta`
  ADD PRIMARY KEY (`Id_dieta`);

--
-- Indices de la tabla `Dieta_A`
--
ALTER TABLE `Dieta_A`
  ADD PRIMARY KEY (`id_alimento`);

--
-- Indices de la tabla `Dieta_D`
--
ALTER TABLE `Dieta_D`
  ADD PRIMARY KEY (`id_alimento`);

--
-- Indices de la tabla `Dieta_E`
--
ALTER TABLE `Dieta_E`
  ADD PRIMARY KEY (`id_alimento`);

--
-- Indices de la tabla `Dieta_F`
--
ALTER TABLE `Dieta_F`
  ADD PRIMARY KEY (`id_alimento`);

--
-- Indices de la tabla `Dieta_Historial`
--
ALTER TABLE `Dieta_Historial`
  ADD PRIMARY KEY (`id_historial`);

--
-- Indices de la tabla `Dieta_I`
--
ALTER TABLE `Dieta_I`
  ADD PRIMARY KEY (`id_alimento`);

--
-- Indices de la tabla `Empleados`
--
ALTER TABLE `Empleados`
  ADD PRIMARY KEY (`Id_empleado`),
  ADD KEY `Id_puesto` (`Id_puesto`);

--
-- Indices de la tabla `Estados`
--
ALTER TABLE `Estados`
  ADD PRIMARY KEY (`Id_estado`);

--
-- Indices de la tabla `Etapas`
--
ALTER TABLE `Etapas`
  ADD PRIMARY KEY (`Id_etapa`);

--
-- Indices de la tabla `Ganaderos`
--
ALTER TABLE `Ganaderos`
  ADD PRIMARY KEY (`id_ganadero`),
  ADD KEY `codigo_postal` (`codigo_postal`),
  ADD KEY `idx_razonsocial` (`razonsocial`);

--
-- Indices de la tabla `Lotes`
--
ALTER TABLE `Lotes`
  ADD PRIMARY KEY (`Id_lote`),
  ADD KEY `Razonsocial` (`Razonsocial`);

--
-- Indices de la tabla `Municipios`
--
ALTER TABLE `Municipios`
  ADD PRIMARY KEY (`Id_municipio`),
  ADD KEY `Id_estado` (`Id_estado`);

--
-- Indices de la tabla `Puestos`
--
ALTER TABLE `Puestos`
  ADD PRIMARY KEY (`Id_puesto`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `Vacunas`
--
ALTER TABLE `Vacunas`
  ADD PRIMARY KEY (`id_vacuna`);

--
-- Indices de la tabla `Ventas`
--
ALTER TABLE `Ventas`
  ADD PRIMARY KEY (`Id_venta`),
  ADD KEY `Ventas_ibfk_1` (`Id_lote`);

--
-- Indices de la tabla `Venta_animal`
--
ALTER TABLE `Venta_animal`
  ADD PRIMARY KEY (`id_venta`);

--
-- Indices de la tabla `Venta_lote`
--
ALTER TABLE `Venta_lote`
  ADD PRIMARY KEY (`id_venta`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Alimentos`
--
ALTER TABLE `Alimentos`
  MODIFY `id_alimento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `Caja`
--
ALTER TABLE `Caja`
  MODIFY `Id_caja` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT de la tabla `Ciudades`
--
ALTER TABLE `Ciudades`
  MODIFY `Id_ciudad` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT de la tabla `CompraAlim`
--
ALTER TABLE `CompraAlim`
  MODIFY `id_compralim` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `CompraVacuna`
--
ALTER TABLE `CompraVacuna`
  MODIFY `id_compravacuna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `CP`
--
ALTER TABLE `CP`
  MODIFY `CodigoPostal` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38986;

--
-- AUTO_INCREMENT de la tabla `Dieta`
--
ALTER TABLE `Dieta`
  MODIFY `Id_dieta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `Dieta_A`
--
ALTER TABLE `Dieta_A`
  MODIFY `id_alimento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `Dieta_D`
--
ALTER TABLE `Dieta_D`
  MODIFY `id_alimento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `Dieta_E`
--
ALTER TABLE `Dieta_E`
  MODIFY `id_alimento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `Dieta_F`
--
ALTER TABLE `Dieta_F`
  MODIFY `id_alimento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `Dieta_Historial`
--
ALTER TABLE `Dieta_Historial`
  MODIFY `id_historial` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `Dieta_I`
--
ALTER TABLE `Dieta_I`
  MODIFY `id_alimento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `Empleados`
--
ALTER TABLE `Empleados`
  MODIFY `Id_empleado` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `Estados`
--
ALTER TABLE `Estados`
  MODIFY `Id_estado` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `Ganaderos`
--
ALTER TABLE `Ganaderos`
  MODIFY `id_ganadero` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT de la tabla `Lotes`
--
ALTER TABLE `Lotes`
  MODIFY `Id_lote` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT de la tabla `Municipios`
--
ALTER TABLE `Municipios`
  MODIFY `Id_municipio` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32059;

--
-- AUTO_INCREMENT de la tabla `Puestos`
--
ALTER TABLE `Puestos`
  MODIFY `Id_puesto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `Vacunas`
--
ALTER TABLE `Vacunas`
  MODIFY `id_vacuna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `Ventas`
--
ALTER TABLE `Ventas`
  MODIFY `Id_venta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT de la tabla `Venta_animal`
--
ALTER TABLE `Venta_animal`
  MODIFY `id_venta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `Venta_lote`
--
ALTER TABLE `Venta_lote`
  MODIFY `id_venta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `Ciudades`
--
ALTER TABLE `Ciudades`
  ADD CONSTRAINT `Ciudades_ibfk_1` FOREIGN KEY (`Id_municipio`) REFERENCES `Municipios` (`Id_municipio`);

--
-- Filtros para la tabla `CompraAlim`
--
ALTER TABLE `CompraAlim`
  ADD CONSTRAINT `CompraAlim_ibfk_1` FOREIGN KEY (`id_alimento`) REFERENCES `Alimentos` (`id_alimento`);

--
-- Filtros para la tabla `CompraVacuna`
--
ALTER TABLE `CompraVacuna`
  ADD CONSTRAINT `CompraVacuna_ibfk_1` FOREIGN KEY (`id_vacuna`) REFERENCES `Vacunas` (`id_vacuna`);

--
-- Filtros para la tabla `CP`
--
ALTER TABLE `CP`
  ADD CONSTRAINT `CP_ibfk_1` FOREIGN KEY (`Id_ciudad`) REFERENCES `Ciudades` (`Id_ciudad`);

--
-- Filtros para la tabla `Empleados`
--
ALTER TABLE `Empleados`
  ADD CONSTRAINT `Empleados_ibfk_1` FOREIGN KEY (`Id_puesto`) REFERENCES `Puestos` (`Id_puesto`);

--
-- Filtros para la tabla `Ganaderos`
--
ALTER TABLE `Ganaderos`
  ADD CONSTRAINT `Ganaderos_ibfk_1` FOREIGN KEY (`codigo_postal`) REFERENCES `CP` (`CodigoPostal`);

--
-- Filtros para la tabla `Lotes`
--
ALTER TABLE `Lotes`
  ADD CONSTRAINT `Lotes_ibfk_1` FOREIGN KEY (`Razonsocial`) REFERENCES `Ganaderos` (`razonsocial`);

--
-- Filtros para la tabla `Municipios`
--
ALTER TABLE `Municipios`
  ADD CONSTRAINT `Municipios_ibfk_1` FOREIGN KEY (`Id_estado`) REFERENCES `Estados` (`Id_estado`);

--
-- Filtros para la tabla `Ventas`
--
ALTER TABLE `Ventas`
  ADD CONSTRAINT `fk_ventas_lotes_nuevo_nombre` FOREIGN KEY (`Id_lote`) REFERENCES `Lotes` (`Id_lote`) ON DELETE CASCADE,
  ADD CONSTRAINT `Ventas_ibfk_1` FOREIGN KEY (`Id_lote`) REFERENCES `Lotes` (`Id_lote`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
