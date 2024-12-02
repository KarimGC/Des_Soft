<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Footer en el fondo</title>
    <style>
        html, body {
            height: 100%;
            margin: 0;
        }

        body {
            display: flex;
            flex-direction: column;
        }

        footer {
            background: transparent;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            margin-top: auto; /* Esto asegura que el footer se alinee al final */
        }

        footer a {
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        footer img {
            width: 30px;
            height: 30px;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <!-- Footer -->
    <footer>
        <a href="dinero.php">
            <img src="../images/cajaic.jpg" alt="Icono de dinero">
        </a>
    </footer>
</body>
</html>

