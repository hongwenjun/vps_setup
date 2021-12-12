<?php
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
$mysqli = mysqli_connect("18.18.18.18", "root", "实际密码", "vps2022","53306");

$result = mysqli_query($mysqli, "SELECT name FROM text");
// $result = mysqli_query($mysqli, "SELECT * FROM text WHERE name = 'addfile.py'");

$rows = mysqli_fetch_all($result, MYSQLI_ASSOC);   // MYSQLI_ASSOC, MYSQLI_NUM, or MYSQLI_BOTH
foreach ($rows as $row) {
    printf("%s\n", $row["name"]);
    // printf("%s (%s)\n", $row["name"], $row["text"]);
}

var_dump($rows);
/**  MYSQLI_ASSOC 
array(11) {
    [0]=>
    array(1) {
      ["name"]=>
      string(10) "addfile.py"
 **  MYSQLI_NUM
array(11) {
  [0]=>
  array(1) {
    [0]=>
    string(10) "addfile.py"
 */