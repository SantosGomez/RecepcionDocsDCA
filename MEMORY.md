# MEMORY.md — Recepcion de documentos DCA

Memoria del proyecto entre sesiones. Máximo ~50 líneas: resume o elimina lo que ya no aporte.

## Estado actual

- Maquetación/Prototipo PWA completado (Frontend Vue 3 + Quasar).
- Esquema de base de datos MySQL creado y validado en `Backend/schema.sql`:
  - 10 tablas normalizadas: `roles`, `empresas`, `departamentos`, `tipos_documento`, `clientes`, `usuarios`, `documentos`, `documento_archivos`, `documento_historial`, `cliente_doc_requeridos`.
  - Soporta semáforo por cliente, múltiples adjuntos, firmas Base64/Ruta, línea de tiempo de trámites y asignación de contador a clientes/documentos.

- **Vista Direccionamiento (nueva):** Flujo de entrega del área de recepción al contador con doble firma (recepcionista + contador). El documento pasa de `RECEPCIONADO` a `EN_PROCESO` cuando el contador confirma recepción.
- **Cuatro firmas en `documentos`:** `firma_cliente` + `firma_recep` (cliente→recepción, en `IndexPage.vue`) y `firma_contador_recep` + `firma_contador` (recepción→contador, en `DireccionamientoPage.vue`).
- **Semáforo por estados:** Recibido → Asignado → En Proceso → Completado. Solo `COMPLETADO` pinta verde; `EN_PROCESO` queda en ámbar para no marcar al cliente al día antes de tiempo.
- **Sin store compartido:** La maqueta no usa Pinia; cada vista tiene sus datos mock. El semáforo de `ClientesPage` NO se actualiza en vivo al firmar en `DireccionamientoPage`.
- **Paleta de colores, tipografias e imagenes institucionales:** Se encuentran en la carpeta `src/assets` y `src/css`.

## Decisiones (y por qué)

- **Formulario Recepción (IndexPage.vue):** Alineado con el modelo de datos (asunto, departamento, prioridad, SLA, contador, notificación correo). Se añadió `notificar_correo` (TINYINT) a la tabla `documentos`.
- **Lógica SLA:** Se calculan días hábiles (excluyendo fin de semana) según prioridad (2/4/8/15 días).
- **Validaciones:** Se bloquea el registro sin firmas digitales y se limita el tamaño de archivos a 25MB (con `accept`).
- **Correcciones:** Canvas de firma redimensionado para corregir deformación de trazo; folios unificados a `DCA-2026-XXXX`.

- El menú lateral vive solo en `MainLayout.vue`: **toda vista nueva debe registrarse ahí** además de en `router/routes.js`, si no queda inaccesible.
- El drawer se controla con `leftDrawerOpen` (ref) y `v-model` en `q-drawer`; no usar `$q.leftDrawer.value` en `v-model` porque no se desenvuelve automáticamente en el template.

- **Login (LoginPage.vue):** Pantalla de ingreso en `/login`, fuera de `MainLayout` (ocupa pantalla completa). Redirige según rol: Administrador→`/dashboard`, Contador→`/direccionamiento`, Recepcionista→`/`, Cliente→`/seguimiento`.
- **Excepción a la regla de campos:** el login NO guarda datos en ninguna tabla; autentica contra `usuarios` y abre sesión. "Recordar mi acceso" es estado del navegador, no una columna.
- **Login sin sesión real:** No hay store ni autenticación; el menú no se filtra por rol. Todo el menú es visible tras ingresar.
- **Datos de ejemplo:** Los correos en las vistas usan `@ejemplo.com`, nunca dominios reales.

- **Identidad visual en `IndexPage.vue`:** acuse y chip del folio usan `$secondary` (#5abbf1) en vez de `blue-1`; bordes y fondos de firma usan `$secondary-white-alternative` (#e5e6eb).
- **Tipografías cargadas en `app.scss`:** Matter (texto general, pesos 400/500/600/700) y Monument Extended (400/700). Se quitó `roboto-font` de los extras en `quasar.config.js`.
- **Logos oficiales siguen sin usarse:** las vistas cargan `public/logo.jpg`, no las variantes de `/src/assets/icons`.

## Aprendizajes y errores a evitar

- Al calcular fechas (SLA), siempre trabajar con fechas locales para evitar saltos UTC que cambian el día.
- El canvas de HTML requiere ajustar `canvas.width` al `offsetWidth` del contenedor para que la coordenada `clientX - rect.left` sea exacta.
- Regla de oro: No modificar tablas sin preguntar (y documentar en `schema.sql` y `MEMORY.md`).
- En Windows PowerShell usar `cmd /c npm run lint` si existe restricción de ExecutionPolicy.
- Todos los botones que contengan un icono deben incluir `<q-tooltip>` descriptivo.
- Usar el prop `exact` en `<q-item>` para la navegación (`to="..."`) en `MainLayout.vue`, impidiendo que la ruta raíz `/` se mantenga resaltada en subrutas.
- Al crear cualquier funcionalidad que tenga que ver con fechas, siempre tener en cuenta el uso correcto de las fechas y horas en la aplicacion.
- En tablas, el filtro de búsqueda debe integrarse en el `computed` junto con los demás filtros; no combinar `:filter` de Quasar con un `computed` que solo filtra otra cosa.
- `q-tooltip` NO acepta `icon`; ese atributo se descarta en silencio y da la falsa impresión de que sí funciona.
- Las rutas de login y 404 van FUERA de los `children` de `MainLayout` para que ocupen toda la pantalla.

## Próximos pasos

- terminar de maquetar las vistas faltantes de la aplicacion para tener la maqueta completa (solo se tiene la vista de recepcion de documentos - IndexPage.vue).
- Crear los modelos y endpoints en Node.js + Express (`Backend`) para conectar con el Frontend Vue 3.
- **Pendiente de mapeo en `documentos`:** los campos `ejercicio`, `periodo`, `viaEntrega` y `observaciones` ya existen en la maqueta de `IndexPage.vue` pero **no tienen columna** en la tabla `documentos`. Al implementar el backend se requiere:
  - Decidir si se agregan columnas (`ejercicio`, `periodo_mes`, `via_entrega`, `observaciones`) o si el periodo fiscal se deriva de `cliente_doc_requeridos`.
  - Evitar duplicar el periodo fiscal entre `documentos` y la matriz del semáforo.
