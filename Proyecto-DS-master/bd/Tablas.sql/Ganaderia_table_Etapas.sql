
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
