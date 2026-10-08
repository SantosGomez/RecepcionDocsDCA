<template>
  <q-page class="q-pa-md bg-grey-2">
    <!-- Encabezado -->
    <div class="row items-center justify-between q-mb-md">
      <div>
        <div class="text-h5 text-weight-bold text-primary">Dashboard de Control Contable</div>
        <div class="text-subtitle2 text-grey-7">
          Monitoreo y semaforización de documentos en tiempo real
        </div>
      </div>
      <div class="row q-gutter-sm">
        <q-btn icon="refresh" flat label="Actualizar" color="primary" @click="cargarDatos">
          <q-tooltip>Actualizar indicadores y lista de documentos</q-tooltip>
        </q-btn>
        <q-btn icon="add" color="primary" label="Nueva Recepción" to="/">
          <q-tooltip>Ir al formulario de recepción de documentos</q-tooltip>
        </q-btn>
      </div>
    </div>

    <!-- Cards KPI -->
    <div class="row q-col-gutter-md q-mb-lg">
      <div class="col-12 col-sm-6 col-md-3">
        <q-card flat class="shadow-1 rounded-borders bg-white border-left-primary">
          <q-card-section class="row items-center justify-between">
            <div>
              <div class="text-caption text-uppercase text-weight-bold text-grey-7">
                Total Recibidos
              </div>
              <div class="text-h4 text-weight-bolder text-primary">48</div>
              <div class="text-caption text-grey-6">Octubre 2026</div>
            </div>
            <q-avatar icon="inventory_2" color="blue-1" text-color="primary" size="48px" />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-3">
        <q-card flat class="shadow-1 rounded-borders bg-white border-left-warning">
          <q-card-section class="row items-center justify-between">
            <div>
              <div class="text-caption text-uppercase text-weight-bold text-grey-7">
                En Revisión
              </div>
              <div class="text-h4 text-weight-bolder text-amber-9">12</div>
              <div class="text-caption text-amber-9 text-weight-medium">Requieren validación</div>
            </div>
            <q-avatar icon="pending_actions" color="amber-1" text-color="amber-9" size="48px" />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-3">
        <q-card flat class="shadow-1 rounded-borders bg-white border-left-negative">
          <q-card-section class="row items-center justify-between">
            <div>
              <div class="text-caption text-uppercase text-weight-bold text-grey-7">
                Por Vencer / Críticos
              </div>
              <div class="text-h4 text-weight-bolder text-negative">5</div>
              <div class="text-caption text-negative text-weight-bold">Acción inmediata</div>
            </div>
            <q-avatar icon="warning" color="red-1" text-color="negative" size="48px" />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-6 col-md-3">
        <q-card flat class="shadow-1 rounded-borders bg-white border-left-positive">
          <q-card-section class="row items-center justify-between">
            <div>
              <div class="text-caption text-uppercase text-weight-bold text-grey-7">
                Aprobados / Listos
              </div>
              <div class="text-h4 text-weight-bolder text-positive">31</div>
              <div class="text-caption text-positive">Contabilizados</div>
            </div>
            <q-avatar icon="check_circle" color="green-1" text-color="positive" size="48px" />
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Tabla de Control con Semáforo -->
    <q-card flat class="shadow-2 rounded-borders bg-white">
      <q-card-section class="row items-center justify-between q-pb-none">
        <div class="text-h6 text-weight-bold text-grey-8">Documentos Recibidos por Cliente</div>

        <!-- Búsqueda y Filtros -->
        <div class="row q-gutter-sm">
          <q-input
            v-model="filter"
            dense
            outlined
            placeholder="Buscar cliente o folio..."
            class="q-ml-md"
          >
            <template #append>
              <q-icon name="search" />
            </template>
          </q-input>

          <q-select
            v-model="filtroEstado"
            :options="['Todos', 'Pendiente', 'En revisión', 'Por vencer', 'Aprobado', 'Rechazado']"
            dense
            outlined
            style="width: 150px"
          />
        </div>
      </q-card-section>

      <q-card-section>
        <q-table
          :rows="filteredRows"
          :columns="columns"
          row-key="id"
          :filter="filter"
          flat
          bordered
          :pagination="{ rowsPerPage: 6 }"
        >
          <!-- Celda de Folio -->
          <template #body-cell-folio="props">
            <q-td :props="props">
              <span class="text-weight-bold text-primary">{{ props.value }}</span>
            </q-td>
          </template>

          <!-- Celda de Semáforo / Estado -->
          <template #body-cell-estado="props">
            <q-td :props="props">
              <q-chip
                :color="getEstadoChipColor(props.value)"
                text-color="white"
                size="sm"
                class="text-weight-bold"
                :icon="getEstadoIcon(props.value)"
              >
                {{ props.value }}
              </q-chip>
            </q-td>
          </template>

          <!-- Celda de Acciones -->
          <template #body-cell-acciones="props">
            <q-td :props="props" class="text-center">
              <q-btn
                flat
                round
                dense
                icon="visibility"
                color="primary"
                @click="verDetalles(props.row)"
              >
                <q-tooltip>Ver detalle del documento</q-tooltip>
              </q-btn>
              <q-btn flat round dense icon="edit" color="grey-7" @click="cambiarEstado(props.row)">
                <q-tooltip>Cambiar estado contable</q-tooltip>
              </q-btn>
            </q-td>
          </template>
        </q-table>
      </q-card-section>
    </q-card>

    <!-- Modal Ver Detalle de Documento -->
    <q-dialog v-model="mostrarDetalle">
      <q-card style="width: 500px; max-width: 90vw">
        <q-card-section class="bg-primary text-white row items-center">
          <div class="text-h6">Detalle de Documento</div>
          <q-space />
          <q-btn icon="close" flat round dense v-close-popup />
        </q-card-section>
        <q-card-section v-if="docSeleccionado" class="q-gutter-y-sm">
          <div><strong>Folio:</strong> {{ docSeleccionado.folio }}</div>
          <div><strong>Cliente:</strong> {{ docSeleccionado.cliente }}</div>
          <div><strong>Tipo:</strong> {{ docSeleccionado.tipo }}</div>
          <div><strong>Periodo:</strong> {{ docSeleccionado.periodo }}</div>
          <div><strong>Fecha Recepción:</strong> {{ docSeleccionado.fecha }}</div>
          <div>
            <strong>Estado Actual:</strong>
            <q-chip
              :color="getEstadoChipColor(docSeleccionado.estado)"
              text-color="white"
              size="xs"
            >
              {{ docSeleccionado.estado }}
            </q-chip>
          </div>
          <q-separator />
          <div>
            <strong>Observaciones:</strong>
            {{ docSeleccionado.observaciones || 'Sin observaciones registradas.' }}
          </div>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cerrar" color="grey-8" v-close-popup />
          <q-btn label="Marcar como Aprobado" color="positive" @click="aprobarDoc" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const filter = ref('')
const filtroEstado = ref('Todos')
const mostrarDetalle = ref(false)
const docSeleccionado = ref(null)

const getEstadoChipColor = (estado) => {
  const map = {
    Pendiente: 'amber-8',
    'En revisión': 'blue-8',
    'Por vencer': 'deep-orange',
    Rechazado: 'negative',
    Aprobado: 'positive',
  }
  return map[estado] || 'grey-7'
}

const getEstadoIcon = (estado) => {
  const map = {
    Pendiente: 'schedule',
    'En revisión': 'find_in_page',
    'Por vencer': 'priority_high',
    Rechazado: 'cancel',
    Aprobado: 'check_circle',
  }
  return map[estado] || 'help'
}

const columns = [
  { name: 'folio', label: 'Folio', field: 'folio', align: 'left', sortable: true },
  { name: 'cliente', label: 'Cliente', field: 'cliente', align: 'left', sortable: true },
  { name: 'tipo', label: 'Tipo Documento', field: 'tipo', align: 'left' },
  { name: 'periodo', label: 'Periodo', field: 'periodo', align: 'center' },
  { name: 'fecha', label: 'Fecha Recepción', field: 'fecha', align: 'center' },
  { name: 'estado', label: 'Semáforo de Estado', field: 'estado', align: 'center', sortable: true },
  { name: 'acciones', label: 'Acciones', field: 'acciones', align: 'center' },
]

const rows = ref([
  {
    id: 1,
    folio: 'DCA-REC-0842',
    cliente: 'Comercializadora del Norte S.A.',
    tipo: 'Facturas CFDI XML/PDF',
    periodo: 'Oct 2026',
    fecha: '2026-10-08 10:15',
    estado: 'Pendiente',
    observaciones: 'Recepción vía PWA cliente.',
  },
  {
    id: 2,
    folio: 'DCA-REC-0839',
    cliente: 'Constructora Grupo Hábitat S. de R.L.',
    tipo: 'Estados de Cuenta',
    periodo: 'Sep 2026',
    fecha: '2026-10-07 16:30',
    estado: 'En revisión',
    observaciones: 'En proceso de conciliación bancaria.',
  },
  {
    id: 3,
    folio: 'DCA-REC-0835',
    cliente: 'Restaurantes y Alimentos del Centro',
    tipo: 'Nómina y Comprobantes IMSS',
    periodo: 'Sep 2026',
    fecha: '2026-10-06 12:00',
    estado: 'Por vencer',
    observaciones: 'Faltan acuses de pago IMSS del mes.',
  },
  {
    id: 4,
    folio: 'DCA-REC-0830',
    cliente: 'Servicios Médicos Especializados S.C.',
    tipo: 'Declaraciones SAT',
    periodo: 'Sep 2026',
    fecha: '2026-10-05 09:45',
    estado: 'Aprobado',
    observaciones: 'Revisado y auditado por contador asignado.',
  },
  {
    id: 5,
    folio: 'DCA-REC-0828',
    cliente: 'Transportes y Logística Rápida S.A.',
    tipo: 'Comprobantes de Pago',
    periodo: 'Sep 2026',
    fecha: '2026-10-04 11:10',
    estado: 'Rechazado',
    observaciones: 'Comprobante ilegible, se solicitó reenvío.',
  },
  {
    id: 6,
    folio: 'DCA-REC-0822',
    cliente: 'Industrias Plásticas de México S.A.',
    tipo: 'Facturas CFDI XML/PDF',
    periodo: 'Sep 2026',
    fecha: '2026-10-03 14:20',
    estado: 'Aprobado',
    observaciones: 'Expediente completo.',
  },
])

const filteredRows = computed(() => {
  if (filtroEstado.value === 'Todos') return rows.value
  return rows.value.filter((r) => r.estado === filtroEstado.value)
})

const verDetalles = (row) => {
  docSeleccionado.value = row
  mostrarDetalle.value = true
}

const cambiarEstado = (row) => {
  $q.notify({
    type: 'info',
    message: `Editando estado de ${row.folio}...`,
    position: 'top-right',
  })
}

const aprobarDoc = () => {
  if (docSeleccionado.value) {
    docSeleccionado.value.estado = 'Aprobado'
    mostrarDetalle.value = false
    $q.notify({
      type: 'positive',
      message: 'Documento aprobado correctamente.',
      position: 'top-right',
    })
  }
}

const cargarDatos = () => {
  $q.notify({
    type: 'info',
    message: 'Datos del Dashboard actualizados.',
    position: 'top-right',
  })
}
</script>

<style scoped>
.border-left-primary {
  border-left: 5px solid #1976d2;
}
.border-left-warning {
  border-left: 5px solid #ffb300;
}
.border-left-negative {
  border-left: 5px solid #c10015;
}
.border-left-positive {
  border-left: 5px solid #21ba45;
}
</style>
