
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
(58, '2023-12-12', 'Gasto', 7100.00);
