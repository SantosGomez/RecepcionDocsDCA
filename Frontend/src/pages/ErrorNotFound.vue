<template>
  <div class="fullscreen bg-blue text-white text-center q-pa-md flex flex-center">
    <div>
      <div style="font-size: 30vh">404</div>

      <div class="text-h2" style="opacity: 0.4">No encontramos esta página</div>

      <div class="text-subtitle1 q-mt-sm" style="opacity: 0.7">
        La dirección solicitada no existe o fue movida.
      </div>

      <q-btn
        class="q-mt-xl"
        color="white"
        text-color="blue"
        unelevated
        to="/"
        label="Ir al inicio"
        no-caps
      >
        <q-tooltip>Regresar a la pantalla principal del sistema</q-tooltip>
      </q-btn>
    </div>
  </div>
</template>