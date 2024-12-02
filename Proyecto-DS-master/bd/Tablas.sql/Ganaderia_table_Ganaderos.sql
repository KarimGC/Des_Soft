
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
  `codigo_postal` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Ganaderos`
--

INSERT INTO `Ganaderos` (`id_ganadero`, `razonsocial`, `nombre`, `psg`, `domicilio`, `codigo_postal`) VALUES
(34, 'Rancho La Paz', 'Martín Contreras', 'MC12AJH45AS1', 'Octavio Paz', 38964),
(35, 'Rancho la Unión', 'Omar Santoyo', 'OS12AJH45AS1', 'Centro', 38150),
(38, 'El poder', 'Martín Contreras', 'FA12AJH45AS1', 'La aldea', 38946),
(40, 'El dorado2', 'Martín Contreras', '1412AEF45A34', 'La aldea', 38940),
(41, 'Rancheria Alicia', 'Alicia Gómez', 'IS12AJH45AS1', 'Jose Magaña', 38940);
