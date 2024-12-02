
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Vacunas`
--

CREATE TABLE `Vacunas` (
  `id_vacuna` int NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `cantidad` int NOT NULL,
  `PrecioUni` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Vacunas`
--

INSERT INTO `Vacunas` (`id_vacuna`, `nombre`, `cantidad`, `PrecioUni`) VALUES
(1, 'Ala', 345, 0.00),
(2, 'Vacune con bacterina', 340, 50.00),
(3, 'Antrax', 70, 20.00),
(4, 'Antrax 2', 1932, 20.00);

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
