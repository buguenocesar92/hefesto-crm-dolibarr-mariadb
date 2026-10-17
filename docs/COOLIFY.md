# Instalación en Coolify
1. Preparar DNS crm.tudominio.cl hacia el VPS. Instalar Docker/Compose v2 mediante el procedimiento de tu plataforma y disponer de HTTPS.
2. Subir el contenido a un repositorio privado SIN .env ni backups. Crear recurso Docker Compose que use compose.yaml, con contexto de construcción raíz.
3. Generar .env localmente y trasladar sus variables al editor seguro del recurso. Mantener copia segura; INSTANCE_ID debe conservarse siempre, incluso en un traspaso. COMPANY_NAME es el nombre de la empresa cliente.
4. Asociar https://crm.tudominio.cl al servicio proxy, puerto interno 80. No asignar dominios/puertos a db, web ni cron. Permitir salida HTTPS al construir para descargar Dolibarr. Los servicios de aplicación requieren salida para futuras integraciones.
5. Construir y desplegar. La base debe estar healthy; web instala el esquema y ejecuta el hook Hefesto; proxy y cron esperan a web healthy. Esto puede tardar varios minutos.
6. Revisar estados y logs de forma privada. El instalador nativo puede incluir información sensible; no pegar logs completos en canales públicos. No ejecutar `docker compose down -v` sobre datos reales.
7. Acceder a la URL HTTPS; revisar acceso, módulos, parámetros regionales, generación de PDF y permisos. El instalador web está bloqueado por el proxy además del install.lock nativo.

El compose no publica puertos al host: precisa el enrutamiento de Coolify u otro proxy HTTPS conectado a la red del servicio proxy. No es una demo accesible directamente por localhost.

Si web queda unhealthy: consultar logs y /var/www/documents/initdb.log, disponibilidad DB, install.lock y .hefesto-configured. No crear el marcador manualmente para omitir errores. El hook puede reejecutarse con `docker compose exec web php /opt/hefesto/initialize.php` SOLO tras diagnosticar una primera instalación fallida y antes de operar con usuarios reales: podría restablecer la clave inicial si el marcador todavía no existe.

Las etiquetas MariaDB/Nginx fijan la rama, no el digest. Registrar sus digests en la entrega y validar actualizaciones en staging. No activar actualizaciones automáticas sin respaldo y prueba.
