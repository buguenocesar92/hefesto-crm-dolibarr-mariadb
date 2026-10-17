# Respaldos, recuperación y entrega
## Respaldar
Desde el directorio del proyecto en un host Docker: `bash scripts/backup.sh`.
La secuencia detiene proxy, cron y web; mantiene la base activa, vuelca SQL y comprime documentos/custom. Luego intenta reiniciar servicios incluso si falla. La parada reduce escrituras, pero deben detenerse también integraciones externas que escriban directamente. Verificar exit status, archivos y servicios al finalizar. Copiar respaldo cifrado fuera del VPS con retención acordada. No se incluye automatización remota ni cifrado.

environment.env contiene contraseñas y clave de instancia: tratar todo respaldo como secreto. Aplicar mínimo acceso y probar recuperación periódicamente. Para Coolify ejecutar en el contexto del mismo recurso/proyecto y variables, no en otro directorio que cree volúmenes nuevos.

## Restaurar en entorno aislado
Usar esta misma versión de imagen/configuración, DNS temporal autorizado y los secretos originales. No restaurar en una base con datos productivos. Preparar un proyecto nuevo, copiar environment.env a .env (modo600), ajustar solo CRM_HOST si corresponde y construir imagen.
1. `docker compose up -d db`; esperar a que esté healthy.
2. `docker compose exec -T db sh -c 'MYSQL_PWD="$MARIADB_PASSWORD" mariadb -u "$MARIADB_USER" "$MARIADB_DATABASE"' < /ruta/respaldo/database.sql`
3. `docker compose run --rm --no-deps -T --entrypoint tar web -xzf - -C /var/www/documents < /ruta/respaldo/documents.tar.gz`
4. `docker compose run --rm --no-deps -T --entrypoint tar web -xzf - -C /var/www/html/custom < /ruta/respaldo/custom.tar.gz`
5. `docker compose up -d`; comprobar propietarios, instalación bloqueada y pruebas de aceptación. No reejecutar el hook de primer arranque sobre una restauración válida.

El archivo conf.php se reconstruye por el entrypoint; respaldar cualquier personalización adicional fuera de este paquete. No editar archivos del contenedor como configuración permanente.

## Entrega al cliente
Transferir repositorio/ZIP, versión y digest de imágenes construidas, DNS, acceso al VPS/Coolify, contraseña administradora actual, INSTANCE_ID, secretos DB y cron, respaldo reciente probado, permisos, configuración SMTP y lista de integraciones existentes. Usar gestor de secretos, nunca adjuntarlos a una propuesta pública. Documentar responsable, retención, ventana de mantenimiento y alcance del soporte.

Cambiar a Odoo no es un restore: exportar terceros, contactos, productos/servicios y propuestas, mapear identificadores/impuestos/adjuntos y probar importación en staging. El paquete no incluye conversor Odoo.

## Actualizar
Respaldar y restaurar en staging antes de cada cambio. Revisar notas oficiales, compatibilidad de módulos personalizados y migraciones de base. El install.lock protege el instalador: seguir el procedimiento oficial de actualización para esa versión, sin retirarlo en producción sin mantenimiento y control de acceso. Este Dockerfile está fijado a24.0.2; no basta cambiar una etiqueta para actualizar todo el código. Después de una migración, rollback requiere restaurar base y documentos compatibles, no solo imagen anterior.
