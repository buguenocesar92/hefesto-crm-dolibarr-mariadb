# Configuración y oferta comercial
## Preparación de la empresa
Completar razón social, dirección, país, moneda CLP, zona horaria y logo desde Configuración. Revisar IVA y reglas aplicables con el responsable contable; no hay tasas tributarias precargadas por este paquete. Revisar numeración y plantilla PDF en el módulo de propuestas.

Activar/verificar Terceros, Propuestas comerciales, Proyectos, Agenda, Servicios, Pedidos, Importaciones, Exportaciones y Trabajos programados. En Proyectos habilitar seguimiento de oportunidades si se necesita y definir estados/probabilidades con el cliente. La agenda no implica sincronización con Google Calendar.

## Flujo recomendado
1. Registrar tercero como prospecto y contactos; asignar comercial.
2. Registrar oportunidad/proyecto con monto esperado, estado y próxima acción.
3. Agendar llamada o reunión; registrar resultado y siguiente fecha.
4. Crear propuesta con servicio, cantidades, precios, validez y condiciones.
5. Revisar PDF y aprobación interna. Enviar manualmente al comenzar; configurar correo solo después de pruebas.
6. Registrar aceptación o rechazo; convertir a pedido cuando corresponda. No afirmar cobro ni facturación electrónica sin integrar herramientas apropiadas.
7. Revisar semanalmente propuestas pendientes, vencidas, aceptadas y próximas acciones. Definir metas con datos reales, sin métricas de muestra presentadas como ventas.

## Usuarios
Administrador para configuración; comercial para terceros/propuestas/proyectos propios según permisos y asignación; supervisor para revisión y reportes. Crear grupos y probar con usuarios sin privilegios. El aislamiento por vendedor depende de permisos nativos y asignaciones, no viene garantizado por el ZIP. No utilizar administrador para el trabajo diario. Revisar autenticación y políticas disponibles en la versión instalada.

## Correo
El hook establece MAIN_DISABLE_ALL_MAILS=1. Configurar SMTP en Dolibarr, remitente y dominio autenticado; desactivar esa constante únicamente cuando se apruebe una prueba a dirección propia. No hacer campañas ni importar contactos sin base legítima. La configuración SMTP y entrega efectiva no están probadas aquí.

## Servicios que Hefesto puede vender
Implementación con parametrización, carga inicial revisada, entrenamiento, soporte mensual, respaldo externo y mantenimiento. Cobrar por ese trabajo y alojamiento; respetar la licencia del software. Cotizar integraciones y migraciones separadamente después de revisar APIs, mapeos y versiones.

El ejemplo CSV es deliberadamente genérico: descargar plantilla del importador nativo, mapear columnas, verificar duplicados y ensayar con pocos registros. No importar directamente sin revisar.
