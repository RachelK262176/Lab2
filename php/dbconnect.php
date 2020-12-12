<?php
$servername = "localhost";
$username   = "rachelca_mycakeshopadmin";
$password   = "EQG8TNUIKSDJK";
$dbname     = "rachelca_mycakeshop";

$conn = new mysqli($servername,$username,$password,$dbname);
if($conn->connect_error){
    die("Connection failed: ". $conn->connect_error);
}
?>