
--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Alimentos`
--
ALTER TABLE `Alimentos`
  ADD PRIMARY KEY (`id_alimento`);

--
-- Indices de la tabla `Caja`
--
ALTER TABLE `Caja`
  ADD PRIMARY KEY (`Id_caja`);

--
-- Indices de la tabla `Ciudades`
--
ALTER TABLE `Ciudades`
  ADD PRIMARY KEY (`Id_ciudad`),
  ADD KEY `Id_municipio` (`Id_municipio`);

--
-- Indices de la tabla `CompraAlim`
--
ALTER TABLE `CompraAlim`
  ADD PRIMARY KEY (`id_compralim`),
  ADD KEY `id_alimento` (`id_alimento`);

--
-- Indices de la tabla `CompraVacuna`
--
ALTER TABLE `CompraVacuna`
  ADD PRIMARY KEY (`id_compravacuna`),
  ADD KEY `id_medicamento` (`id_vacuna`);

--
-- Indices de la tabla `CP`
--
ALTER TABLE `CP`
  ADD PRIMARY KEY (`CodigoPostal`),
  ADD KEY `Id_ciudad` (`Id_ciudad`);

--
-- Indices de la tabla `Dieta`
--
ALTER TABLE `Dieta`
  ADD PRIMARY KEY (`Id_dieta`);

--
-- Indices de la tabla `Empleados`
--
ALTER TABLE `Empleados`
  ADD PRIMARY KEY (`Id_empleado`),
  ADD KEY `Id_puesto` (`Id_puesto`);

--
-- Indices de la tabla `Estados`
--
ALTER TABLE `Estados`
  ADD PRIMARY KEY (`Id_estado`);

--
-- Indices de la tabla `Etapas`
--
ALTER TABLE `Etapas`
  ADD PRIMARY KEY (`Id_etapa`);

--
-- Indices de la tabla `Ganaderos`
--
ALTER TABLE `Ganaderos`
  ADD PRIMARY KEY (`id_ganadero`),
  ADD KEY `codigo_postal` (`codigo_postal`),
  ADD KEY `idx_razonsocial` (`razonsocial`);

--
-- Indices de la tabla `Lotes`
--
ALTER TABLE `Lotes`
  ADD PRIMARY KEY (`Id_lote`),
  ADD KEY `Razonsocial` (`Razonsocial`);

--
-- Indices de la tabla `Municipios`
--
ALTER TABLE `Municipios`
  ADD PRIMARY KEY (`Id_municipio`),
  ADD KEY `Id_estado` (`Id_estado`);

--
-- Indices de la tabla `Puestos`
--
ALTER TABLE `Puestos`
  ADD PRIMARY KEY (`Id_puesto`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- Indices de la tabla `Vacunas`
--
ALTER TABLE `Vacunas`
  ADD PRIMARY KEY (`id_vacuna`);

--
-- Indices de la tabla `Ventas`
--
ALTER TABLE `Ventas`
  ADD PRIMARY KEY (`Id_venta`),
  ADD KEY `Ventas_ibfk_1` (`Id_lote`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Alimentos`
--
ALTER TABLE `Alimentos`
  MODIFY `id_alimento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `Caja`
--
ALTER TABLE `Caja`
  MODIFY `Id_caja` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT de la tabla `Ciudades`
--
ALTER TABLE `Ciudades`
  MODIFY `Id_ciudad` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT de la tabla `CompraAlim`
--
ALTER TABLE `CompraAlim`
  MODIFY `id_compralim` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `CompraVacuna`
--
ALTER TABLE `CompraVacuna`
  MODIFY `id_compravacuna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `CP`
--
ALTER TABLE `CP`
  MODIFY `CodigoPostal` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38986;

--
-- AUTO_INCREMENT de la tabla `Dieta`
--
ALTER TABLE `Dieta`
  MODIFY `Id_dieta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `Empleados`
--
ALTER TABLE `Empleados`
  MODIFY `Id_empleado` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `Estados`
--
ALTER TABLE `Estados`
  MODIFY `Id_estado` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT de la tabla `Ganaderos`
--
ALTER TABLE `Ganaderos`
  MODIFY `id_ganadero` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT de la tabla `Lotes`
--
ALTER TABLE `Lotes`
  MODIFY `Id_lote` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `Municipios`
--
ALTER TABLE `Municipios`
  MODIFY `Id_municipio` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32059;

--
-- AUTO_INCREMENT de la tabla `Puestos`
--
ALTER TABLE `Puestos`
  MODIFY `Id_puesto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `Vacunas`
--
ALTER TABLE `Vacunas`
  MODIFY `id_vacuna` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `Ventas`
--
ALTER TABLE `Ventas`
  MODIFY `Id_venta` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `Ciudades`
--
ALTER TABLE `Ciudades`
  ADD CONSTRAINT `Ciudades_ibfk_1` FOREIGN KEY (`Id_municipio`) REFERENCES `Municipios` (`Id_municipio`);

--
-- Filtros para la tabla `CompraAlim`
--
ALTER TABLE `CompraAlim`
  ADD CONSTRAINT `CompraAlim_ibfk_1` FOREIGN KEY (`id_alimento`) REFERENCES `Alimentos` (`id_alimento`);

--
-- Filtros para la tabla `CompraVacuna`
--
ALTER TABLE `CompraVacuna`
  ADD CONSTRAINT `CompraVacuna_ibfk_1` FOREIGN KEY (`id_vacuna`) REFERENCES `Vacunas` (`id_vacuna`);

--
-- Filtros para la tabla `CP`
--
ALTER TABLE `CP`
  ADD CONSTRAINT `CP_ibfk_1` FOREIGN KEY (`Id_ciudad`) REFERENCES `Ciudades` (`Id_ciudad`);

--
-- Filtros para la tabla `Empleados`
--
ALTER TABLE `Empleados`
  ADD CONSTRAINT `Empleados_ibfk_1` FOREIGN KEY (`Id_puesto`) REFERENCES `Puestos` (`Id_puesto`);

--
-- Filtros para la tabla `Ganaderos`
--
ALTER TABLE `Ganaderos`
  ADD CONSTRAINT `Ganaderos_ibfk_1` FOREIGN KEY (`codigo_postal`) REFERENCES `CP` (`CodigoPostal`);

--
-- Filtros para la tabla `Lotes`
--
ALTER TABLE `Lotes`
  ADD CONSTRAINT `Lotes_ibfk_1` FOREIGN KEY (`Razonsocial`) REFERENCES `Ganaderos` (`razonsocial`);

--
-- Filtros para la tabla `Municipios`
--
ALTER TABLE `Municipios`
  ADD CONSTRAINT `Municipios_ibfk_1` FOREIGN KEY (`Id_estado`) REFERENCES `Estados` (`Id_estado`);

--
-- Filtros para la tabla `Ventas`
--
ALTER TABLE `Ventas`
  ADD CONSTRAINT `fk_ventas_lotes_nuevo_nombre` FOREIGN KEY (`Id_lote`) REFERENCES `Lotes` (`Id_lote`) ON DELETE CASCADE,
  ADD CONSTRAINT `Ventas_ibfk_1` FOREIGN KEY (`Id_lote`) REFERENCES `Lotes` (`Id_lote`) ON DELETE CASCADE;
