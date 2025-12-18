<?php
$host = "data";
$user = "tp3user";
$password = "tp3pass";
$database = "tp3";

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$conn->query("INSERT INTO compteur (valeur) VALUES (1)");

$result = $conn->query("SELECT COUNT(*) AS total FROM compteur");
$row = $result->fetch_assoc();

echo "Compteur : " . $row["total"];

$conn->close();
