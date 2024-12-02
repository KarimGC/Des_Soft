<?php
    include "Conexion.php";

    class Auth extends Conexion {

        public function registrar($email, $password) {
            $conexion = parent::conectar();
            $sql = "INSERT INTO usuarios (email, password) 
                    VALUES (?,?)";
            $query = $conexion->prepare($sql);
            $query->bind_param('ss', $email, $password);
            return $query->execute();
        }

        public function logear($email, $password) {
            $conexion = parent::conectar();
            $passwordExistente = "";
            $sql = "SELECT * FROM usuarios 
                    WHERE email = '$email'";
            $respuesta = mysqli_query($conexion, $sql);

            if (mysqli_num_rows($respuesta) > 0) {
                $passwordExistente = mysqli_fetch_array($respuesta);
                $passwordExistente = $passwordExistente['password'];
                
                if (password_verify($password, $passwordExistente)) {
                    $_SESSION['email'] = $email;
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        }   
    }

?>