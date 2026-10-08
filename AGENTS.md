# AGENTS.md - Recepcion de documentos DCA

PWA para gestion y recepcion de documentos del grupo DCA, para uso interno y externo. con el objetivo de gestionar y tener control de los documentos que llegan a las empresas que conforman el grupo y a su ves pueda ser administrado mediante un dashboar con un semaforo de estado de cada cliente y los documentos que tiene pendiente de registrar.

## Stack y estructura

- HTML, VUE 3, Vite, Pinia, JavaScript, Quasar Framework, librerias como axios, quasar, jspdf, html2pdf.js.
- El proyecto tiene 2 carpetas la carpeta "Frontend" que es donde se encuentra el codigo de la aplicacion, el esqueleto del proyecto, vistas y funciones del framework y la carpeta "Backend" que es el servidor de base de datos y la logica del negocio.

## Vistas

- `DashboardPage.vue` Es la pantalla principal que se mostrara a los contadores, que se muestra despues de iniciar sesion, es un dashboard donde se muestran los clientes y el estado de sus documentos.
- `ClientesPage.vue` Es una pantalla donde se muestran los clientes, es una tabla con los clientes y sus datos.
- `IndexPage.vue` Es la pantalla donde se recepcionan los documentos, es un formulario que permite recepcionar los documentos con firma de entregado del cliente, firma de recibido para el usuario recepcionista.
- `SeguimientoPage.vue` Es la pantalla que el cliente puede ver desde su portal, donde podra seguir sus documentos.
- `UsersPage.vue` Es una pantalla donde se muestran los usuarios, es una tabla con los usuarios y sus datos.

## Comandos

- **Development Server:**
  ```bash
  cd Frontend
  npm run dev
  ```
- **Build:**
  ```bash
  cd Frontend
  npm run build
  ```
- **Linting:**
  - Fix: `npm run lint`
  - Check only: `npm run lint:check`

## Backend

- El servidor de base de datos esta hecho en nodejs con express y mysql, se encuentra en la carpeta "Backend" se pueden ejecutar los comandos:
  - `cd Backend`
  - `npm install`
  - `npm run dev`

## Convenciones

- Textos de la interfaz en español.
- El lenguaje que se debe utilizar en todo el proyecto es el Español.
- Los comentarios deben estar en español.
- las vistas deben ser responsivas para todo tipo de dispositivos (mobile, tablet, desktop).
- Cada vista debe tener su script con vue 3.
- los textos de las vistas no tienen que ser ambiguos para que todas los usuarios puedan entender
- tener tooltips para dar contexto al usuario y evitar ambiguedad.
- los botones que tengan un icono deben tener un tooltip.

## Reglas de dominio / trampas conocidas

- Lo que es fácil hacer mal y el agente no puede deducir leyendo el código.

## Forma de trabajar

- No crear archivos que no sean necesarios, siempre preguntar antes de crear archivos nuevos o modificar los existentes.
- No modificar archivos que no sean necesarios, siempre preguntar antes de modificar archivos existentes.
- Haz solo lo que se pide: no añadas funcionalidades por tu cuenta.
- Cambios pequeños y enfocados; no reescribas lo que ya funciona.
- Al terminar, resume qué has cambiado y cualquier decisión que deba revisar.

## Memoria

- Al empezar, lee `MEMORY.md` para conocer el estado del proyecto y las decisiones tomadas.
- Al terminar una tarea, actualízalo: estado actual, decisiones importantes (con su porqué) y errores a evitar.
- Mantenlo breve (máximo ~50 líneas): resume o elimina lo que ya no aporte.
- Si algo se convierte en una regla permanente, propón moverlo a `AGENTS.md` en lugar de dejarlo en la memoria.
- No guardes nunca datos sensibles (claves, tokens, datos personales).

## Límites

- ✅ Siempre: hacer pruebas, mantener los textos en español, respetar la estrutura del proyecto, mantener las funciones que ya funcionan y no modificarlas sin preguntarme, actualizar `MEMORY.md` al terminar cada tarea.
- ⚠️ Pregunta antes: dependencias nuevas, archivos nuevos, cambios en la estructura de los datos, cambios en la lógica del programa, etc.
- 🚫 Nunca: hacer cambios sin preguntar y sobre todo no modificar las funciones que ya funcionan y no modificarlas sin preguntarme.

## Verificación

- Comprobar que un cambio funciona antes de darlo por terminado.
