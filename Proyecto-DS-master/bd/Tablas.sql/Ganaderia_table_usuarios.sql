
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
(21, 'manuel@gmail.com', '$2y$10$aiQxJ.E06fx82S4qodow6uLaAQrP0usGwvGRoQ5MgSMwT9tsP1h4i'),
(22, 'e@u', '$2y$10$RkiFIhFtBfDK6UWn8jJZguG7BwPjXEHMncnMixuBHxqcF8XlyFfUe');
