
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Lotes`
--

CREATE TABLE `Lotes` (
  `Id_lote` int NOT NULL,
  `CantidadAnimales` int NOT NULL,
  `PesoLote` decimal(10,2) NOT NULL,
  `PrecioKilo` decimal(10,2) NOT NULL,
  `FechaEntrada` date NOT NULL,
  `Razonsocial` varchar(100) NOT NULL,
  `PrecioTotal` decimal(10,2) GENERATED ALWAYS AS ((`PesoLote` * `PrecioKilo`)) STORED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `Lotes`
--

INSERT INTO `Lotes` (`Id_lote`, `CantidadAnimales`, `PesoLote`, `PrecioKilo`, `FechaEntrada`, `Razonsocial`) VALUES
(17, 90, 100.00, 50.00, '2023-12-11', 'Rancho la Unión');

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
