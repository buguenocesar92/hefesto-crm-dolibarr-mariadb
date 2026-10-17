# Hefesto CRM · Dolibarr 24.0.2
Paquete de despliegue para vender implementación, capacitación y soporte de CRM a pymes: prospectos, clientes, contactos, agenda, proyectos/oportunidades y presupuestos comerciales.

## Estado real
Preparado y revisado estáticamente. No ha sido construido ni ejecutado con Docker en este entorno; la instalación, autenticación, generación de PDF y recuperación de respaldo requieren las pruebas de aceptación incluidas. No hay servidor, dominio ni credenciales de cliente configurados.

## Stack
- Dolibarr nativo 24.0.2, código fijado por commit y SHA-256; imagen propia sobre runtime oficial 24.0.1 fijado por digest. No se presenta como imagen oficial publicada de 24.0.2.
- MariaDB 11.4, Nginx y proceso cron separado. Coolify termina HTTPS y dirige tráfico exclusivamente a `proxy:80`.
- Volúmenes persistentes para base de datos, documentos y módulos personalizados.
- Sin Supabase en este producto. Dolibarr admite PostgreSQL, pero el instalador Docker automatizado utilizado aquí trabaja con MariaDB/MySQL. Supabase requeriría una variante validada aparte; no mezclar su base con otros productos.

## Inicio
1. Extraer y ejecutar `python3 scripts/configure.py crm.tudominio.cl`.
2. Leer `docs/COOLIFY.md`; ajustar COMPANY_NAME en .env.
3. Ejecutar `docker compose config --quiet` y `docker compose build`.
4. Desplegar mediante Coolify con HTTPS. En una máquina con proxy HTTPS ya configurado: `docker compose up -d`.
5. Entrar con `hefesto_admin` y ADMIN_PASSWORD de .env. Cambiar contraseña en la aplicación, crear usuarios individuales y configurar empresa.
6. Completar `docs/ACEPTACION.md` antes de entregar a un cliente.

Los módulos se solicitan al instalador nativo. Su activación y permisos deben verificarse tras el primer arranque. Correos desactivados mediante MAIN_DISABLE_ALL_MAILS; no se envían mensajes durante instalación. No se incluyen pagos, integración Odoo, sincronización Supabase, firma electrónica ni DTE/SII. Las propuestas PDF son presupuestos comerciales, no documentos tributarios.

## Contenido
- `compose.yaml`, Dockerfile y nginx.conf: despliegue.
- `container/`: configuración inicial y healthcheck.
- `scripts/`: generación de secretos y respaldo con parada breve.
- `docs/`: instalación, uso comercial, traspaso, restauración y aceptación.
- `examples/`: datos ficticios para preparar una importación manual.

Dimensionamiento inicial orientativo: 2 vCPU, 4 GB RAM y 30 GB SSD más documentos y respaldos. Medir según usuarios y carga. Un despliegue aislado por cliente; esto no implementa un SaaS multiempresa.

## Licencias y fuentes
Dolibarr es GPL-3.0-or-later; conservar sus avisos y cumplir sus términos al redistribuir imágenes o modificaciones. Este ZIP contiene configuración, no el código completo de Dolibarr; el build lo obtiene desde el repositorio oficial. Ver docs/FUENTES.md. Las licencias de las imágenes y componentes permanecen vigentes.
