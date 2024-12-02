<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Link Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <style>
    body, html {
        margin: 0;
        padding: 0;
        height: 100%;
        width: 100%;
    }
    .bg-image {
        background: url('https://via.placeholder.com/1920x1080') no-repeat center center;
        background-size: cover;
        position: absolute;
        top: 0;
        left: 0;
        height: 100%;
        width: 100%;
        z-index: -1;
    }
    .form-container {
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .form-box {
        background: rgba(255, 255, 255, 0.9);
        padding: 50px;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        max-width: 600px;
        width: 100%;
    }
    .form-control {
        font-size: 1.2rem;
        height: calc(1.5em + 1.5rem + 2px);
    }
    .btn-login {
        font-size: 1.2rem;
        padding: 10px 20px;
    }
</style>

    <title>Login</title>
</head>
<body>
<div class="bg-image" style="background-image: url(../images/imagen3.jpg); background-size: cover; background-position: center;"></div>
    <div class="form-container">
    <div class="form-box">
    <div class="text-center mb-4">
        <img src="../images/Imagen4.png" alt="Logo" style="max-width: 100%; height: auto; max-height: 100px;">
    </div>
    <form action="srv/logear.php" method="post">
        <div class="form-floating mb-3">
            <input type="text" class="form-control" name="email" id="email" placeholder="Nombre" required>
            <label for="name">Nombre</label>
        </div>
        <div class="form-floating mb-3">
            <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
            <label for="password">Contraseña</label>
        </div>
        <div class="d-grid">
            <button class="btn btn-primary btn-lg btn-login text-uppercase fw-bold mb-2" type="submit">Entrar</button>
            <div class="text-center">
                <a class="small" href="registro.php">Registrate</a>
            </div>
        </div>
    </form>
</div>

    </div>
    <!-- Link Script Bootstrap 5 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>
</html>
