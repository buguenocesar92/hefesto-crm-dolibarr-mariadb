<?php
try {
    if (!is_file('/var/www/documents/install.lock') || !is_file('/var/www/documents/.hefesto-configured')) { exit(1); }
    $db = new PDO('mysql:host=db;dbname=dolidb;charset=utf8mb4', 'hefesto_crm', getenv('DOLI_DB_PASSWORD'), [PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION]);
    if (!$db->query('SELECT COUNT(*) FROM llx_user WHERE admin=1 AND statut=1')->fetchColumn()) { exit(1); }
    $h = curl_init('http://127.0.0.1/');
    curl_setopt_array($h, [CURLOPT_RETURNTRANSFER=>true, CURLOPT_TIMEOUT=>5, CURLOPT_FOLLOWLOCATION=>false]);
    curl_exec($h); $code=curl_getinfo($h,CURLINFO_HTTP_CODE);
    exit($code >= 200 && $code < 400 ? 0 : 1);
} catch (Throwable $e) { exit(1); }
