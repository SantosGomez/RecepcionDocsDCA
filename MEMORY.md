# MEMORY.md — Recepcion de documentos DCA

Memoria del proyecto entre sesiones. Máximo ~50 líneas: resume o elimina lo que ya no aporte.

## Estado actual

- Maquetación/Prototipo PWA completado (Frontend Vue 3 + Quasar).
- Esquema de base de datos MySQL creado y validado en `Backend/schema.sql`:
  - 10 tablas normalizadas: `roles`, `empresas`, `departamentos`, `tipos_documento`, `clientes`, `usuarios`, `documentos`, `documento_archivos`, `documento_historial`, `cliente_doc_requeridos`.
  - Soporta semáforo por cliente, múltiples adjuntos, firmas Base64/Ruta, línea de tiempo de trámites y asignación de contador a clientes/documentos.

## Decisiones (y por qué)

- Sin backend activo por ahora: Se definieron las tablas en `Backend/schema.sql` como primer paso antes de implementar la API con Express/MySQL.
- Nomenclatura SQL: Se unificó a `snake_case` y se resolvió la dependencia circular entre `clientes` y `usuarios` (`contador_id` asignado mediante FK).
- Entidad `empresas`: Añadida para soportar la regla de negocio del Grupo DCA (múltiples filiales).

## Aprendizajes y errores a evitar

- En Windows PowerShell usar `cmd /c npm run lint` si existe restricción de ExecutionPolicy.
- Todos los botones que contengan un icono deben incluir `<q-tooltip>` descriptivo.

## Próximos pasos

- Ejecutar `Backend/schema.sql` en MySQL / phpMyAdmin.
- Crear los modelos y endpoints en Node.js + Express (`Backend`) para conectar con el Frontend Vue 3.
