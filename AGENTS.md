# AGENTS.md - Recepcion de documentos DCA

PWA para gestion y recepcion de documentos del grupo DCA, para uso interno y externo. con el objetivo de gestionar y tener control de los documentos que llegan a las empresas que conforman el grupo y a su ves pueda ser administrado mediante un dashboar con un semaforo de estado de cada cliente y los documentos que tiene pendiente de registrar.

## Stack y estructura

- HTML, VUE 3, Vite, Pinia, JavaScript, Quasar Framework, librerias como axios, quasar, jspdf, html2pdf.js.
- El proyecto tiene 2 carpetas la carpeta "Frontend" que es donde se encuentra el codigo de la aplicacion, el esqueleto del proyecto, vistas y funciones del framework y la carpeta "Backend" que es el servidor de base de datos y la logica del negocio.
- en las carpetas de el proyecto en front se tiene una carpeta de nombre `/src` la cual en la carpeta `/assets` se tiene la tipografia y las imagenes que se utilizara para el proyecto.
- la tipografia se encuentra en la carpeta `/assets/fonts` y las imagenes se encuentran en la carpeta `/assets/icons` la cual se divide en 2 subcarpetas `/assets/icons/JPG` y `/assets/icons/PNG`.
- la carpeta css con los estilos se encuentra en la carpeta `/src/css` y ya tiene la paleta de colores institucional definidos en `/src/css/quasar.variables.scss`.
- estos son las variables o componentes scss de los colores institucionales: $primary, $secondary, $accent, $secondary-black, $secondary-white, $secondary-white-alternative y estos de para el semaforo y estados de notificaciones o alertas: $positive, $negative, $info, $warning.

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

## Base de Datos y Entorno Local

- **Servidor MySQL:** Local mediante XAMPP (`localhost:3306`).
- **Base de Datos:** `dca_documentos` (creada mediante `Backend/schema.sql`).
- **Usuario local:** `root` (sin contraseña).
- **Ruta binario MySQL (XAMPP):** `C:\xampp\mysql\bin\mysql.exe`
- **Permisos del Agente:** El agente está autorizado para ejecutar el script `Backend/schema.sql` y migraciones en el entorno local de desarrollo cuando el usuario lo solicite.

## Convenciones

- Textos de la interfaz en español.
- El lenguaje que se debe utilizar en todo el proyecto es el Español.
- Los comentarios deben estar en español.
- las vistas deben ser responsivas para todo tipo de dispositivos (mobile, tablet, desktop).
- Cada vista debe tener su script con vue 3.
- los textos de las vistas no tienen que ser ambiguos para que todas los usuarios puedan entender
- tener tooltips para dar contexto al usuario y evitar ambiguedad.
- los botones que tengan un icono deben tener un tooltip.
- los botones de icono (como el menú lateral) deben tener también `aria-label` en español para lectores de pantalla.

## Reglas de diseño (identidad visual)

- Usar las variables SCSS de `Frontend/src/css/quasar.variables.scss`: `$primary`, `$secondary`, `$accent`, `$negative`, `$positive`, `$warning`, `$info`, `$secondary-white-alternative`, etc.
- No usar clases de color de Material (`blue-1`, `grey-7`) para elementos de marca. Solo se permiten grises Material muy oscuros en texto (`text-grey-7` a `text-grey-9`) porque cumplen contraste WCAG.
- ⚠️ **No usar `$secondary-white` (#bfbfbf) para texto**: sobre fondo blanco da 2.5:1 y no cumple el mínimo de 4.5:1 de WCAG. Solo usarlo en bordes o fondos.
- Tipografías: **Matter** para texto general, **Monument Extended** disponible para títulos. Se cargan en `Frontend/src/css/app.scss`.
- Logos oficiales en `Frontend/src/assets/icons/PNG` y `/JPG` (variantes `DELGROW_LOGO` e `ISOTIPO`). No se han integrado aún en las vistas.

## Reglas de dominio / trampas conocidas

- Lo que es fácil hacer mal y el agente no puede deducir leyendo el código.

## Forma de trabajar

- No crear archivos que no sean necesarios, siempre preguntar antes de crear archivos nuevos o modificar los existentes.
- No modificar archivos que no sean necesarios, siempre preguntar antes de modificar archivos existentes.
- Haz solo lo que se pide: no añadas funcionalidades por tu cuenta.
- No modificar archivos que ya funcionan, no modificarlas sin preguntarme.
- no agregar inputs o campos a formularios si no estan en la tabla donde se guardara informacion, en caso de necesitar mas campos proponer un cambio a la tabla y preguntar si se procede a modificar.
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
