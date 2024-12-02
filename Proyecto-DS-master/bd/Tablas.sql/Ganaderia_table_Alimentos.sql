
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
(1, 'Maiz', 1385, 'kilos', 50.00),
(2, 'Salvado', 1650, 'kilos', 50.00),
(3, 'Soya', 45100, 'kilos', 30.00),
(4, 'Melaza', 1970, 'kilos', 70.00),
(5, 'Sal', 48710, 'kilos', 15.00),
(6, 'Minerales', 47930, 'kilos', 90.00),
(7, 'Rastrojo', 84000, 'kilos', 100.00);
