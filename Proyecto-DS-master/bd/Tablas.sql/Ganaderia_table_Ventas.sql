
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

--
-- Volcado de datos para la tabla `Ventas`
--

INSERT INTO `Ventas` (`Id_venta`, `Id_lote`, `FechaVenta`, `GastoDieta`, `Peso`, `PrecioKilo`, `PrecioTotal`, `Animalesventa`) VALUES
(44, 17, '2023-12-12', 7100.00, 100.70, 50.00, 5035, 10);
