
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
