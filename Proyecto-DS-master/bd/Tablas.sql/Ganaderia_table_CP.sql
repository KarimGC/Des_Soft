
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `CP`
--

CREATE TABLE `CP` (
  `CodigoPostal` int NOT NULL,
  `Colonia` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_ciudad` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `CP`
--

INSERT INTO `CP` (`CodigoPostal`, `Colonia`, `Id_ciudad`) VALUES
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
