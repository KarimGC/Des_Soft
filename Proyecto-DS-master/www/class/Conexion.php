<?php
class Conexion {
    private $servidor = 'db';
    private $usuario = 'root';
    private $password = 'clave';
    private $database = 'Ganaderia';
    private $port = 3306;

    public function conectar() {
        $conn = new mysqli(
            $this->servidor,
            $this->usuario,
            $this->password,
            $this->database,
            $this->port
        );

        if ($conn->connect_error) {
            die("Conexión fallida: " . $conn->connect_error);
        }

        return $conn;
    }
}
?>
