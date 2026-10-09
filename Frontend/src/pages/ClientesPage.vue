<template>
  <q-page class="q-pa-md bg-grey-2">
    <!-- Encabezado -->
    <div class="row items-center justify-between q-mb-md">
      <div>
        <div class="text-h5 text-weight-bold text-primary">
          Directorio de Clientes y Semáforo Fiscal
        </div>
        <div class="text-subtitle2 text-grey-7">
          Estado global de cumplimiento de entrega de documentos de clientes DCA
        </div>
      </div>
      <div class="row q-gutter-sm">
        <q-btn icon="person_add" color="primary" label="Nuevo Cliente" @click="nuevoCliente">
          <q-tooltip>Registrar un nuevo cliente en el sistema</q-tooltip>
        </q-btn>
        <q-btn
          icon="download"
          flat
          color="primary"
          label="Exportar Reporte"
          @click="exportarReporte"
        >
          <q-tooltip>Descargar reporte de semáforo fiscal en Excel/PDF</q-tooltip>
        </q-btn>
      </div>
    </div>

    <!-- Filtros y Métricas Rápidas -->
    <div class="row q-col-gutter-md q-mb-md">
      <div class="col-12 col-sm-4">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center">
            <q-icon name="check_circle" color="positive" size="36px" class="q-mr-sm" />
            <div>
              <div class="text-subtitle2 text-grey-7">Clientes Al Día (Semáforo Verde)</div>
              <div class="text-h6 text-weight-bold text-positive">18 / 24 Clientes</div>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-4">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center">
            <q-icon name="warning" color="warning" size="36px" class="q-mr-sm" />
            <div>
              <div class="text-subtitle2 text-grey-7">Pendientes Faltantes (Semáforo Amarillo)</div>
              <div class="text-h6 text-weight-bold text-warning">4 Clientes</div>
            </div>
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-4">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center">
            <q-icon name="error" color="negative" size="36px" class="q-mr-sm" />
            <div>
              <div class="text-subtitle2 text-grey-7">Retraso Crítico (Semáforo Rojo)</div>
              <div class="text-h6 text-weight-bold text-negative">2 Clientes</div>
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Tabla Principal de Clientes -->
    <q-card flat class="shadow-2 rounded-borders bg-white">
      <q-card-section class="row items-center justify-between q-pb-none">
        <div class="text-h6 text-weight-bold text-grey-8">Clientes Asignados</div>
        <q-input
          v-model="filter"
          dense
          outlined
          placeholder="Buscar por RFC o Razón Social..."
          style="width: 300px"
        >
          <template #append>
            <q-icon name="search" />
          </template>
        </q-input>
      </q-card-section>

      <q-card-section>
        <q-table
          :rows="rows"
          :columns="columns"
          row-key="id"
          :filter="filter"
          flat
          bordered
          :pagination="{ rowsPerPage: 6 }"
        >
          <!-- RFC y Razón Social -->
          <template #body-cell-cliente="props">
            <q-td :props="props">
              <div class="text-weight-bold text-grey-9">{{ props.row.razonSocial }}</div>
              <div class="text-caption text-primary">RFC: {{ props.row.rfc }}</div>
            </q-td>
          </template>

          <!-- Semáforo de Cumplimiento -->
          <template #body-cell-semaforo="props">
            <q-td :props="props" class="text-center">
              <q-badge
                :color="getSemaforoColor(props.value)"
                class="q-pa-xs text-weight-bold"
                style="font-size: 0.8rem"
              >
                <q-icon :name="getSemaforoIcon(props.value)" class="q-mr-xs" />
                {{ props.value }}
              </q-badge>
            </q-td>
          </template>

          <!-- Documentos Pendientes -->
          <template #body-cell-pendientes="props">
            <q-td :props="props">
              <div v-if="props.value.length === 0" class="text-positive text-weight-bold">
                <q-icon name="done_all" /> Completo
              </div>
              <div v-else>
                <q-chip
                  v-for="(doc, idx) in props.value"
                  :key="idx"
                  size="xs"
                  color="orange-1"
                  text-color="orange-9"
                  class="q-mr-xs"
                >
                  {{ doc }}
                </q-chip>
              </div>
            </q-td>
          </template>

          <!-- Acciones -->
          <template #body-cell-acciones="props">
            <q-td :props="props" class="text-center">
              <q-btn
                flat
                round
                dense
                icon="folder_open"
                color="primary"
                @click="verExpediente(props.row)"
              >
                <q-tooltip>Ver expedientes del cliente</q-tooltip>
              </q-btn>
              <q-btn
                flat
                round
                dense
                icon="send"
                color="secondary"
                @click="recordatorio(props.row)"
              >
                <q-tooltip>Enviar recordatorio de documentos</q-tooltip>
              </q-btn>
            </q-td>
          </template>
        </q-table>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref } from 'vue'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const filter = ref('')

const getSemaforoColor = (nivel) => {
  if (nivel === 'Al día') return 'positive'
  if (nivel === 'En Proceso') return 'amber-8'
  if (nivel === 'Incompleto') return 'amber-9'
  if (nivel === 'Vencido') return 'negative'
  return 'grey-7'
}

const getSemaforoIcon = (nivel) => {
  if (nivel === 'Al día') return 'check_circle'
  if (nivel === 'En Proceso') return 'hourglass_top'
  if (nivel === 'Incompleto') return 'warning'
  if (nivel === 'Vencido') return 'dangerous'
  return 'help'
}

const columns = [
  { name: 'cliente', label: 'Cliente / RFC', field: 'razonSocial', align: 'left', sortable: true },
  { name: 'empresaDca', label: 'Despacho DCA Asignado', field: 'empresaDca', align: 'left' },
  { name: 'contador', label: 'Contador Asignado', field: 'contador', align: 'left' },
  {
    name: 'semaforo',
    label: 'Semáforo de Entrega',
    field: 'semaforo',
    align: 'center',
    sortable: true,
  },
  {
    name: 'pendientes',
    label: 'Documentos Pendientes (Octubre)',
    field: 'pendientes',
    align: 'left',
  },
  { name: 'acciones', label: 'Acciones', field: 'acciones', align: 'center' },
]

const rows = ref([
  {
    id: 1,
    razonSocial: 'Comercializadora del Norte S.A. de C.V.',
    rfc: 'CNO120415AB3',
    empresaDca: 'DCA Contadores Públicos S.C.',
    contador: 'Lic. Roberto Garza',
    semaforo: 'Al día',
    pendientes: [],
  },
  {
    id: 2,
    razonSocial: 'Constructora Grupo Hábitat S. de R.L.',
    rfc: 'CGH180920K99',
    empresaDca: 'DCA Asesores Fiscales S.A.',
    contador: 'C.P. Ana Martínez',
    semaforo: 'En Proceso',
    pendientes: ['Estados de Cuenta Santander', 'Facturas de Gastos'],
  },
  {
    id: 3,
    razonSocial: 'Restaurantes y Alimentos del Centro S.A.',
    rfc: 'RAC090211H55',
    empresaDca: 'DCA Soluciones de Nómina S.C.',
    contador: 'C.P. Miguel Ángel Torres',
    semaforo: 'Vencido',
    pendientes: ['Acuses IMSS/INFONAVIT', 'Comprobantes Nómina Quincena 2', 'XML Emitidos'],
  },
  {
    id: 4,
    razonSocial: 'Servicios Médicos Especializados S.C.',
    rfc: 'SME150601882',
    empresaDca: 'DCA Contadores Públicos S.C.',
    contador: 'Lic. Roberto Garza',
    semaforo: 'Al día',
    pendientes: [],
  },
  {
    id: 5,
    razonSocial: 'Transportes y Logística Rápida S.A.',
    rfc: 'TLR210110XX1',
    empresaDca: 'DCA Asesores Fiscales S.A.',
    contador: 'C.P. Ana Martínez',
    semaforo: 'Incompleto',
    pendientes: ['Póliza Seguro Flotilla'],
  },
])

const nuevoCliente = () => {
  $q.notify({
    type: 'info',
    message: 'Abrir diálogo de registro de nuevo cliente.',
    position: 'top-right',
  })
}

const exportarReporte = () => {
  $q.notify({
    type: 'positive',
    message: 'Reporte de semaforización exportado en Excel/PDF.',
    position: 'top-right',
  })
}

const verExpediente = (cliente) => {
  $q.notify({
    type: 'info',
    message: `Abriendo expediente contable de ${cliente.razonSocial}`,
    position: 'top-right',
  })
}

const recordatorio = (cliente) => {
  $q.notify({
    type: 'positive',
    message: `Recordatorio enviado vía WhatsApp/Email a ${cliente.razonSocial}`,
    position: 'top-right',
  })
}
</script>
