# MEMORY.md — Recepcion de documentos DCA

Memoria del proyecto entre sesiones. Máximo ~50 líneas: resume o elimina lo que ya no aporte.

## Estado actual

- Maquetación/Prototipo PWA completado (Frontend Vue 3 + Quasar).
- Esquema de base de datos MySQL creado y validado en `Backend/schema.sql`:
  - 10 tablas normalizadas: `roles`, `empresas`, `departamentos`, `tipos_documento`, `clientes`, `usuarios`, `documentos`, `documento_archivos`, `documento_historial`, `cliente_doc_requeridos`.
  - Soporta semáforo por cliente, múltiples adjuntos, firmas Base64/Ruta, línea de tiempo de trámites y asignación de contador a clientes/documentos.

## Decisiones (y por qué)

- **Formulario Recepción (IndexPage.vue):** Alineado con el modelo de datos (asunto, departamento, prioridad, SLA, contador, notificación correo). Se añadió `notificar_correo` (TINYINT) a la tabla `documentos`.
- **Lógica SLA:** Se calculan días hábiles (excluyendo fin de semana) según prioridad (2/4/8/15 días).
- **Validaciones:** Se bloquea el registro sin firmas digitales y se limita el tamaño de archivos a 25MB (con `accept`).
- **Correcciones:** Canvas de firma redimensionado para corregir deformación de trazo; folios unificados a `DCA-2026-XXXX`.

## Aprendizajes y errores a evitar

- Al calcular fechas (SLA), siempre trabajar con fechas locales para evitar saltos UTC que cambian el día.
- El canvas de HTML requiere ajustar `canvas.width` al `offsetWidth` del contenedor para que la coordenada `clientX - rect.left` sea exacta.
- Regla de oro: No modificar tablas sin preguntar (y documentar en `schema.sql` y `MEMORY.md`).
- En Windows PowerShell usar `cmd /c npm run lint` si existe restricción de ExecutionPolicy.
- Todos los botones que contengan un icono deben incluir `<q-tooltip>` descriptivo.
- Al crear cualquier funcionalidad que tenga que ver con fechas, siempre tener en cuenta el uso correcto de las fechas y horas en la aplicacion.

## Próximos pasos

- Crear los modelos y endpoints en Node.js + Express (`Backend`) para conectar con el Frontend Vue 3.
- **Pendiente de mapeo en `documentos`:** los campos `ejercicio`, `periodo`, `viaEntrega` y `observaciones` ya existen en la maqueta de `IndexPage.vue` pero **no tienen columna** en la tabla `documentos`. Al implementar el backend se requiere:
  - Decidir si se agregan columnas (`ejercicio`, `periodo_mes`, `via_entrega`, `observaciones`) o si el periodo fiscal se deriva de `cliente_doc_requeridos`.
  - Evitar duplicar el periodo fiscal entre `documentos` y la matriz del semáforo.
