# Acta de aceptación pendiente
Fecha, responsable, versión/digest, dominio y resultado de cada punto deben registrarse en la entrega.
- Build completo con SHA verificado y sintaxis PHP válida.
- Compose inicia DB, web, cron y proxy; web alcanza healthy.
- Acceso HTTPS sin bucles, instalador público bloqueado, inicio de sesión correcto.
- Contraseña administrativa cambiada; prueba con usuario comercial sin privilegios.
- Empresa/CLP/idioma correctos; módulos requeridos activos.
- Prospecto y contacto ficticios creados; propuesta con servicio y PDF descargable; pedido desde aceptación.
- Agenda/oportunidades revisadas y cron funcionando, sin publicar su clave.
- Correo inicialmente bloqueado; SMTP solo probado si se configura expresamente.
- Reinicio conserva registros, adjuntos y módulos.
- Respaldo generado y restauración completa probada en entorno aislado.
- Acceso externo a base/servicios internos cerrado; recursos monitorizados.
- Datos ficticios eliminados y acta firmada antes de cargar datos reales.

Validación de este ZIP: revisión estática de YAML, scripts y empaquetado. No equivale a esta aceptación funcional. Docker y PHP no estaban disponibles en el entorno de generación.
