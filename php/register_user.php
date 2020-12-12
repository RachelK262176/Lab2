<?php
include_once("dbconnect.php");
$name = $_POST['name'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$password = sha1($_POST['password']);
$otp = rand(1000,9999);

$sqlregister = "INSERT INTO USER(NAME,PHONE,EMAIL,PASSWORD,OTP) VALUES('$name','$phone','$email','$password','$otp')";

if ($conn->query($sqlregister) === TRUE){
    sendEmail($otp,$email);
    echo "success";
}else{
    echo "failed";
}

function sendEmail($otp,$email){
    $from = "noreply@mycakeshop.com";
    $to = $email;
    $subject = "From My Cake Shop. Verify your account";
    $message = "Use the following link to verify your account :"."\n http://rachelcake.com/mycakeshop/php/verify_account.php?email=".$email."&key=".$otp;
    $headers = "From:" . $from;
    mail($email,$subject,$message, $headers);
}
?>
