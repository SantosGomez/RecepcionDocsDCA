<template>
  <q-page class="flex flex-center">
    <div class="column items-center">
      <q-btn class="q-mt-md" color="primary" to="/second" label="Go to Second Page" no-caps />

      <q-card class="my-card q-mt-lg" style="width: 100%;" >
        <q-card-section>
          <div class="text-h6">Recepcion de documentos</div>
          <div class="text-subtitle2">Sistema de Documentos DelGrow</div>
        </q-card-section>
        <q-card-section>
          <q-form @submit="onSubmit" @reset="onReset" class="q-gutter-md">
            <q-input v-model="text" type="text" label="Persona Fisica" />
            <q-select v-model="model" :options="optionesDoc" label="Tipo de documento" filled />
            <q-select v-model="model" :options="optionesContador" label="Contador" filled />
            <q-uploader
              url="http://localhost:4444/upload"
              color="teal"
              flat
              bordered
            />
            
            <div class="column items-center">
              <q-btn label="Enviar" type="submit" color="primary" />
              <q-btn label="Resetear" type="reset" color="primary" flat class="q-ml-sm" />
            </div>
          </q-form>
        </q-card-section>
      </q-card>
    </div>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
const text = ref('')
const optionesDoc = ref([
  { label: 'Factura', value: 'factura' },
  { label: 'Nota de Credito', value: 'nota-de-credito' },
  { label: 'Ticket', value: 'ticket' },
])
const optionesContador = ref([
  { label: 'Contador', value: 'contador' },
  { label: 'Contador 2', value: 'contador-2' },
  { label: 'Contador 3', value: 'contador-3' },
  { label: 'Contador 4', value: 'contador-4' },
  { label: 'Contador 5', value: 'contador-5' },
])
const model = ref(null)
</script>
