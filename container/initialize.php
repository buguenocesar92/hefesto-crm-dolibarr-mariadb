<?php
// Runs only during initial native installation. Never use to reset an existing CRM.
define('NOLOGIN', 1);
define('NOREQUIREMENU', 1);
define('NOREQUIREHTML', 1);
define('NOREQUIREAJAX', 1);
require '/var/www/html/main.inc.php';
require_once '/var/www/html/core/lib/admin.lib.php';
$marker = '/var/www/documents/.hefesto-configured';
if (file_exists($marker)) { exit(0); }
foreach (['MAIN_MONNAIE'=>'CLP', 'MAIN_LANG_DEFAULT'=>'es_ES',
          'MAIN_APPLICATION_TITLE'=>'Hefesto CRM', 'MAIN_DISABLE_ALL_MAILS'=>'1'] as $key=>$value) {
    if (dolibarr_set_const($db, $key, $value, 'chaine', 0, '', 1) <= 0) {
        fwrite(STDERR, "Failed to configure $key\n"); exit(1);
    }
}
// Upgrade the initial installer password hash before opening public access.
$pdo = new PDO('mysql:host=db;dbname=dolidb;charset=utf8mb4', 'hefesto_crm', getenv('DOLI_DB_PASSWORD'), [PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);
$stmt = $pdo->prepare('UPDATE llx_user SET pass_crypted=? WHERE login=? AND admin=1');
$stmt->execute([password_hash(getenv('DOLI_ADMIN_PASSWORD'), PASSWORD_BCRYPT), 'hefesto_admin']);
if ($stmt->rowCount() !== 1) { throw new RuntimeException('Administrator missing'); }
if (file_put_contents($marker, "24.0.2\n") === false) { exit(1); }
