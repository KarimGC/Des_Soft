<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <title>Alimentar</title>
    <style>
body, html {
    height: 100%;
    margin: 0;
}

.grid-container {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    grid-template-rows: 1fr;
    gap: 20px;
    height: 90%; /* La altura ocupa todo el espacio disponible */
    padding: 20px;
}

.grid-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    text-align: center;
    border: 2px solid #6c757d;
    border-radius: 10px;
    padding: 20px;
    cursor: pointer;
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    height: 100%; /* Ajusta al tamaño del grid */
    text-decoration: none; /* Eliminar subrayado */
}

/* Colores de fondo diferentes para cada grid-item */
.grid-item:nth-child(1) {
    background-color: #f1c40f; /* Color amarillo para el primer item */
}

.grid-item:nth-child(2) {
    background-color: #3498db; /* Color azul para el segundo item */
}

/* Cambia el color de fondo cuando se pasa el mouse */
.grid-item:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
}

/* Cambia el color del texto a negro y asegura que el color se mantenga en negro al hacer hover */
.grid-item .btn-name {
    font-size: 1.2rem;
    font-weight: bold;
    color: black; /* Cambiar color a negro */
}

/* Asegurarse de que el color del texto permanezca negro al hacer hover */
.grid-item:hover .btn-name {
    color: black;
}

.grid-item img {
    width: 120px;
    height: auto;
    margin-bottom: 10px;
}

    </style>
</head>
<body>

<?php
include("includes/header.php");
?>

<div class="container-fluid h-100">
    <div class="grid-container">
        <a href="alimentar_v2.php" class="grid-item">
            <img src="../images/alimentoic.png" alt="Alimentar y Vacunar">
            <div class="btn-name">Alimentar</div>
        </a>
        <a href="dietas.php" class="grid-item">
            <img src="../images/mod_dietas.png" alt="Almacén">
            <div class="btn-name">Dietas</div>
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-Y7xk1Bjc8F9zJxKtJcC5EPsbFVf0jcZ5z5nFf5r5l5uue6bF5f5u5z5z5z5z5z5z5z" crossorigin="anonymous"></script>
</body>
</html>
