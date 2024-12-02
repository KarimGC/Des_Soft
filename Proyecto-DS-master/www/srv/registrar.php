<?php
    include "../class/Auth.php";

    $email = $_POST['email']; 
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT);

    $Auth = new Auth();

    if ($Auth->registrar($email, $password)) {
        header("Location:../index.php");
    } else {
        echo "No se pudo registrar";
    }
?>
