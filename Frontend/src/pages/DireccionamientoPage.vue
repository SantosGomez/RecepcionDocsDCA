<template>
  <q-page class="q-pa-md bg-grey-2">
    <!-- Encabezado -->
    <div class="row items-center justify-between q-mb-md">
      <div>
        <div class="text-h5 text-weight-bold text-primary">Direccionamiento y Recepción Contable</div>
        <div class="text-subtitle2 text-grey-7">
          Entrega formal de documentación del área de recepción al contador asignado
        </div>
      </div>
      <div class="row q-gutter-sm">
        <q-btn icon="refresh" flat color="primary" label="Actualizar" @click="actualizarTabla">
          <q-tooltip>Recargar la lista de documentos pendientes</q-tooltip>
        </q-btn>
        <q-btn icon="print" color="primary" label="Imprimir Relación" @click="imprimirRelacion">
          <q-tooltip>Imprimir la relación de documentos por entregar</q-tooltip>
        </q-btn>
      </div>
    </div>

    <!-- Tarjetas de Conteo por Estado -->
    <div class="row q-col-gutter-md q-mb-md">
      <div class="col-12 col-sm-4">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center">
            <q-icon name="inventory_2" color="primary" size="36px" class="q-mr-sm" />
            <div>
              <div class="text-subtitle2 text-grey-7">Recibidos por Recepción</div>
              <div class="text-h6 text-weight-bold text-primary">{{ contarPorEstado('Recibido') }}</div>
            </div>
          </q-card-section>
        </q-card>
      </div>
      <div class="col-12 col-sm-4">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center">
            <q-icon name="assignment_ind" color="warning" size="36px" class="q-mr-sm" />
            <div>
              <div class="text-subtitle2 text-grey-7">Asignados a Contador</div>
              <div class="text-h6 text-weight-bold text-warning">{{ contarPorEstado('Asignado') }}</div>
            </div>
          </q-card-section>
        </q-card>
      </div>
      <div class="col-12 col-sm-4">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center">
            <q-icon name="pending_actions" color="amber-9" size="36px" class="q-mr-sm" />
            <div>
              <div class="text-subtitle2 text-grey-7">En Proceso Contable</div>
              <div class="text-h6 text-weight-bold text-amber-9">{{ contarPorEstado('En Proceso') }}</div>
            </div>
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Filtros y Tabla -->
    <q-card flat class="shadow-2 rounded-borders bg-white">
      <q-card-section class="row items-center justify-between q-pb-none q-col-gutter-md">
        <div class="text-h6 text-weight-bold text-grey-8">Documentos por Entregar</div>
        <div class="row q-col-gutter-sm items-center">
          <q-select
            v-model="filtroCliente"
            :options="opcionesClientes"
            label="Cliente"
            outlined
            dense
            options-dense
            clearable
            style="min-width: 220px"
          />
          <q-select
            v-model="filtroContador"
            :options="opcionesContadores"
            label="Contador"
            outlined
            dense
            options-dense
            clearable
            style="min-width: 200px"
          />
          <q-input v-model="busqueda" dense outlined placeholder="Buscar folio o cliente..." style="min-width: 220px">
            <template #append>
              <q-icon name="search" />
            </template>
          </q-input>
        </div>
      </q-card-section>

      <q-card-section>
        <q-table
          :rows="rowsFiltrados"
          :columns="columns"
          row-key="folio"
          flat
          bordered
          :pagination="{ rowsPerPage: 6 }"
          :loading="cargando"
        >
          <template #body-cell-cliente="props">
            <q-td :props="props">
              <div class="text-weight-bold text-grey-9">{{ props.row.cliente }}</div>
              <div class="text-caption text-primary">RFC: {{ props.row.rfc }}</div>
            </q-td>
          </template>

          <template #body-cell-prioridad="props">
            <q-td :props="props">
              <q-badge :color="getColorPrioridad(props.value)" class="q-pa-xs text-weight-bold">
                {{ props.value }}
              </q-badge>
            </q-td>
          </template>

          <template #body-cell-estado="props">
            <q-td :props="props" class="text-center">
              <q-badge :color="getColorEstado(props.value)" class="q-pa-xs text-weight-bold">
                <q-icon :name="getIconoEstado(props.value)" class="q-mr-xs" />
                {{ props.value }}
              </q-badge>
            </q-td>
          </template>

          <template #body-cell-acciones="props">
            <q-td :props="props" class="text-center">
              <q-btn
                flat
                round
                dense
                icon="draw"
                color="primary"
                :disable="props.row.estado === 'En Proceso'"
                @click="abrirDialogoEntrega(props.row)"
              >
                <q-tooltip>
                  {{
                    props.row.estado === 'En Proceso'
                      ? 'Este documento ya fue entregado al contador'
                      : 'Formalizar entrega y recepción con firmas'
                  }}
                </q-tooltip>
              </q-btn>
              <q-btn
                flat
                round
                dense
                icon="visibility"
                color="grey-7"
                @click="verDetalle(props.row)"
              >
                <q-tooltip>Ver detalle del documento recibido</q-tooltip>
              </q-btn>
            </q-td>
          </template>
        </q-table>
      </q-card-section>
    </q-card>

    <!-- Diálogo de Firma de Entrega al Contador -->
    <q-dialog v-model="mostrarDialogoEntrega" persistent>
      <q-card style="width: 700px; max-width: 95vw" class="q-pa-sm">
        <q-card-section class="row items-center bg-primary text-white rounded-borders">
          <q-icon name="assignment_return" size="30px" class="q-mr-sm" />
          <div>
            <div class="text-h6 text-weight-bold">Entrega y Recepción Contable</div>
            <div class="text-caption">
              Folio: <strong>{{ documentoSeleccionado.folio }}</strong>
            </div>
          </div>
          <q-space />
          <q-btn icon="close" flat round dense @click="cerrarDialogoEntrega">
            <q-tooltip>Cerrar sin guardar</q-tooltip>
          </q-btn>
        </q-card-section>

        <q-card-section class="q-pt-md">
          <div class="row q-col-gutter-sm q-mb-md bg-blue-1 q-pa-sm rounded-borders">
            <div class="col-12 col-sm-6">
              <div class="text-caption text-grey-7">Cliente:</div>
              <div class="text-weight-bold">{{ documentoSeleccionado.cliente }}</div>
            </div>
            <div class="col-12 col-sm-6">
              <div class="text-caption text-grey-7">Tipo de Documento:</div>
              <div class="text-weight-bold">{{ documentoSeleccionado.tipoDocumento }}</div>
            </div>
          </div>

          <q-select
            v-model="contadorEntrega"
            :options="opcionesContadores"
            label="Contador que Receive la Documentación *"
            outlined
            dense
            options-dense
            :rules="[(val) => !!val || 'Seleccione el contador que recibe']"
          >
            <template #prepend>
              <q-icon name="person_pin" color="primary" />
            </template>
          </q-select>

          <div class="text-subtitle1 text-weight-bold text-grey-8 q-mt-md q-mb-sm row items-center">
            <q-icon name="draw" class="q-mr-xs text-primary" size="20px" />
            Firmas de Conformidad
          </div>

          <div class="row q-col-gutter-md">
            <div class="col-12 col-sm-6">
              <q-card
                flat
                bordered
                :class="['q-pa-sm bg-grey-1', { 'border-negative': submittedEntrega && firmaRecepcionistaVacia }]"
              >
                <div class="text-caption text-weight-bold text-grey-8 q-mb-xs">
                  Firma de Recepción DCA (Entrega) *
                </div>
                <canvas
                  ref="canvasRecepcionista"
                  class="bg-white rounded-borders style-signature-canvas"
                  @mousedown="startDrawingRecepcionista"
                  @mousemove="drawRecepcionista"
                  @mouseup="stopDrawingRecepcionista"
                  @mouseleave="stopDrawingRecepcionista"
                  @touchstart.prevent="startDrawingRecepcionista"
                  @touchmove.prevent="drawRecepcionista"
                  @touchend.prevent="stopDrawingRecepcionista"
                ></canvas>
                <div class="text-caption text-grey-6 text-center q-mt-xs">
                  <q-icon name="gesture" /> Dibuje la firma con el dedo o ratón
                </div>
              </q-card>
            </div>

            <div class="col-12 col-sm-6">
              <q-card
                flat
                bordered
                :class="['q-pa-sm bg-grey-1', { 'border-negative': submittedEntrega && firmaContadorVacia }]"
              >
                <div class="text-caption text-weight-bold text-grey-8 q-mb-xs">
                  Firma del Contador (Recibido) *
                </div>
                <canvas
                  ref="canvasContador"
                  class="bg-white rounded-borders style-signature-canvas"
                  @mousedown="startDrawingContador"
                  @mousemove="drawContador"
                  @mouseup="stopDrawingContador"
                  @mouseleave="stopDrawingContador"
                  @touchstart.prevent="startDrawingContador"
                  @touchmove.prevent="drawContador"
                  @touchend.prevent="stopDrawingContador"
                ></canvas>
                <div class="text-caption text-grey-6 text-center q-mt-xs">
                  <q-icon name="how_to_reg" /> Confirme la recepción del documento
                </div>
              </q-card>
            </div>
          </div>

          <q-input
            v-model="observacionesEntrega"
            type="textarea"
            rows="2"
            label="Observaciones de la entrega"
            outlined
            dense
            class="q-mt-sm"
            placeholder="Ej: Se entregan 45 CFDI del periodo, faltan estados de cuenta del banco."
          />
        </q-card-section>

        <q-card-actions align="right" class="q-pr-md q-pb-md q-gutter-sm">
          <q-btn label="Cancelar" color="grey-8" flat @click="cerrarDialogoEntrega" />
          <q-btn
            label="Confirmar Entrega y Generar Constancia"
            color="primary"
            icon-right="task_alt"
            @click="confirmarEntrega"
          >
            <q-tooltip>Registrar ambas firmas y pasar el documento a En Proceso</q-tooltip>
          </q-btn>
        </q-card-actions>
      </q-card>
    </q-dialog>

    <!-- Diálogo de Detalle del Documento -->
    <q-dialog v-model="mostrarDetalle">
      <q-card style="width: 520px; max-width: 95vw" class="q-pa-sm">
        <q-card-section class="row items-center bg-grey-2 rounded-borders">
          <q-icon name="description" color="primary" class="q-mr-sm" size="28px" />
          <div class="text-h6 text-weight-bold text-grey-9">Detalle del Documento</div>
          <q-space />
          <q-btn icon="close" flat round dense v-close-popup>
            <q-tooltip>Cerrar detalle del documento</q-tooltip>
          </q-btn>
        </q-card-section>
        <q-card-section>
          <q-list separator dense>
            <q-item>
              <q-item-section class="text-grey-7">Folio:</q-item-section>
              <q-item-section side class="text-weight-bold">{{ documentoSeleccionado.folio }}</q-item-section>
            </q-item>
            <q-item>
              <q-item-section class="text-grey-7">Asunto:</q-item-section>
              <q-item-section side class="text-weight-bold">{{ documentoSeleccionado.asunto }}</q-item-section>
            </q-item>
            <q-item>
              <q-item-section class="text-grey-7">Recibido por:</q-item-section>
              <q-item-section side class="text-weight-bold">{{ documentoSeleccionado.recibidoPor }}</q-item-section>
            </q-item>
            <q-item>
              <q-item-section class="text-grey-7">Fecha límite SLA:</q-item-section>
              <q-item-section side class="text-weight-bold">{{ documentoSeleccionado.fechaLimiteSla }}</q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
        <q-card-actions align="right" class="q-pr-md q-pb-md">
          <q-btn flat label="Cerrar" color="grey-8" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </q-page>
</template>

<script setup>
import { ref, computed, nextTick } from 'vue'
import { useQuasar } from 'quasar'

const $q = useQuasar()

// Catálogos de la maqueta
const opcionesClientes = [
  'Comercializadora del Norte S.A. de C.V.',
  'Constructora Grupo Hábitat S. de R.L.',
  'Restaurantes y Alimentos del Centro S.A.',
  'Servicios Médicos Especializados S.C.',
]
const opcionesContadores = ['C.P. Ana Martínez', 'Lic. Roberto Garza', 'C.P. Miguel Ángel Torres']

const columns = [
  { name: 'folio', label: 'Folio', field: 'folio', align: 'left', sortable: true },
  { name: 'cliente', label: 'Cliente / RFC', field: 'cliente', align: 'left', sortable: true },
  { name: 'tipoDocumento', label: 'Tipo de Documento', field: 'tipoDocumento', align: 'left' },
  { name: 'fechaRecepcion', label: 'Recepción', field: 'fechaRecepcion', align: 'left', sortable: true },
  { name: 'prioridad', label: 'Prioridad', field: 'prioridad', align: 'center', sortable: true },
  { name: 'contador', label: 'Contador', field: 'contador', align: 'left' },
  { name: 'estado', label: 'Estado', field: 'estado', align: 'center', sortable: true },
  { name: 'acciones', label: 'Acciones', field: 'acciones', align: 'center' },
]

// Datos de prueba alineados al flujo de estados del semáforo
const rows = ref([
  {
    folio: 'DCA-2026-0841',
    cliente: 'Comercializadora del Norte S.A. de C.V.',
    rfc: 'CNO120415AB3',
    tipoDocumento: 'Facturas Emitidas (CFDI XML/PDF)',
    asunto: 'Facturas del periodo septiembre 2026',
    fechaRecepcion: '09/10/2026 09:12',
    prioridad: 'MEDIA',
    contador: 'C.P. Ana Martínez',
    recibidoPor: 'Recepción DCA (Ana Martínez)',
    fechaLimiteSla: '2026-10-21',
    estado: 'Recibido',
  },
  {
    folio: 'DCA-2026-0842',
    cliente: 'Comercializadora del Norte S.A. de C.V.',
    rfc: 'CNO120415AB3',
    tipoDocumento: 'Estados de Cuenta Bancarios',
    asunto: 'Estados de cuenta septiembre - Santander y Banamex',
    fechaRecepcion: '09/10/2026 10:40',
    prioridad: 'ALTA',
    contador: 'C.P. Ana Martínez',
    recibidoPor: 'Recepción DCA (Ana Martínez)',
    fechaLimiteSla: '2026-10-15',
    estado: 'Asignado',
  },
  {
    folio: 'DCA-2026-0843',
    cliente: 'Constructora Grupo Hábitat S. de R.L.',
    rfc: 'CGH180920K99',
    tipoDocumento: 'Comprobantes de Pago / Transferencias',
    asunto: 'Comprobantes de proveedores principales',
    fechaRecepcion: '08/10/2026 16:25',
    prioridad: 'BAJA',
    contador: 'Lic. Roberto Garza',
    recibidoPor: 'Recepción DCA (Luis Dong)',
    fechaLimiteSla: '2026-10-29',
    estado: 'Recibido',
  },
  {
    folio: 'DCA-2026-0844',
    cliente: 'Restaurantes y Alimentos del Centro S.A.',
    rfc: 'RAC090211H55',
    tipoDocumento: 'Nómina y Comprobantes IMSS/INFONAVIT',
    asunto: 'Comprobantes de nómina segunda quincena',
    fechaRecepcion: '08/10/2026 11:05',
    prioridad: 'URGENTE',
    contador: 'C.P. Miguel Ángel Torres',
    recibidoPor: 'Recepción DCA (Ana Martínez)',
    fechaLimiteSla: '2026-10-13',
    estado: 'En Proceso',
  },
])

// Filtros
const busqueda = ref('')
const filtroCliente = ref(null)
const filtroContador = ref(null)
const cargando = ref(false)

const rowsFiltrados = computed(() => {
  let resultado = rows.value
  if (filtroCliente.value) {
    resultado = resultado.filter((r) => r.cliente === filtroCliente.value)
  }
  if (filtroContador.value) {
    resultado = resultado.filter((r) => r.contador === filtroContador.value)
  }
  if (busqueda.value.trim()) {
    const q = busqueda.value.toLowerCase()
    resultado = resultado.filter(
      (r) => r.folio.toLowerCase().includes(q) || r.cliente.toLowerCase().includes(q)
    )
  }
  return resultado
})

const contarPorEstado = (estado) => rows.value.filter((r) => r.estado === estado).length

const getColorPrioridad = (prioridad) => {
  if (prioridad === 'URGENTE') return 'negative'
  if (prioridad === 'ALTA') return 'orange-9'
  if (prioridad === 'MEDIA') return 'amber-9'
  return 'grey-7'
}

const getColorEstado = (estado) => {
  if (estado === 'En Proceso') return 'amber-9'
  if (estado === 'Asignado') return 'warning'
  return 'primary'
}

const getIconoEstado = (estado) => {
  if (estado === 'En Proceso') return 'hourglass_top'
  if (estado === 'Asignado') return 'assignment_ind'
  return 'inventory_2'
}

const actualizarTabla = () => {
  cargando.value = true
  setTimeout(() => {
    cargando.value = false
    $q.notify({
      type: 'info',
      message: 'Lista de documentos actualizada.',
      position: 'top-right',
    })
  }, 600)
}

const imprimirRelacion = () => {
  $q.notify({
    type: 'info',
    message: 'Generando PDF con la relación de documentos pendientes...',
    position: 'bottom-right',
  })
}

const verDetalle = (row) => {
  documentoSeleccionado.value = row
  mostrarDetalle.value = true
}

// Lógica de entrega y firmas
const mostrarDialogoEntrega = ref(false)
const mostrarDetalle = ref(false)
const documentoSeleccionado = ref({})
const submittedEntrega = ref(false)
const contadorEntrega = ref(null)
const observacionesEntrega = ref('')

const canvasRecepcionista = ref(null)
const canvasContador = ref(null)
const firmaRecepcionistaVacia = ref(true)
const firmaContadorVacia = ref(true)
let ctxRecepcionista = null
let ctxContador = null
let isDrawingRecep = false
let isDrawingCont = false

// Los canvas se dimensionan al abrirse el diálogo (ver abrirDialogoEntrega)
const prepararCanvas = (canvas) => {
  canvas.width = canvas.offsetWidth
  canvas.height = canvas.offsetHeight
  const ctx = canvas.getContext('2d')
  ctx.lineWidth = 2
  ctx.lineCap = 'round'
  return ctx
}

const getPos = (canvas, e) => {
  const rect = canvas.getBoundingClientRect()
  const clientX = e.touches ? e.touches[0].clientX : e.clientX
  const clientY = e.touches ? e.touches[0].clientY : e.clientY
  return { x: clientX - rect.left, y: clientY - rect.top }
}

const abrirDialogoEntrega = async (row) => {
  documentoSeleccionado.value = row
  contadorEntrega.value = row.contador
  observacionesEntrega.value = ''
  submittedEntrega.value = false
  mostrarDialogoEntrega.value = true

  await nextTick()
  ctxRecepcionista = prepararCanvas(canvasRecepcionista.value)
  ctxContador = prepararCanvas(canvasContador.value)
  ctxRecepcionista.strokeStyle = '#1565C0'
  ctxContador.strokeStyle = '#2E7D32'
}

const cerrarDialogoEntrega = () => {
  mostrarDialogoEntrega.value = false
  limpiarFirmas()
}

const limpiarFirmas = () => {
  if (ctxRecepcionista && canvasRecepcionista.value) {
    ctxRecepcionista.clearRect(0, 0, canvasRecepcionista.value.width, canvasRecepcionista.value.height)
  }
  if (ctxContador && canvasContador.value) {
    ctxContador.clearRect(0, 0, canvasContador.value.width, canvasContador.value.height)
  }
  firmaRecepcionistaVacia.value = true
  firmaContadorVacia.value = true
}

// Canvas Recepcionista
const startDrawingRecepcionista = (e) => {
  isDrawingRecep = true
  firmaRecepcionistaVacia.value = false
  const pos = getPos(canvasRecepcionista.value, e)
  ctxRecepcionista.beginPath()
  ctxRecepcionista.moveTo(pos.x, pos.y)
}
const drawRecepcionista = (e) => {
  if (!isDrawingRecep) return
  const pos = getPos(canvasRecepcionista.value, e)
  ctxRecepcionista.lineTo(pos.x, pos.y)
  ctxRecepcionista.stroke()
}
const stopDrawingRecepcionista = () => {
  isDrawingRecep = false
}

// Canvas Contador
const startDrawingContador = (e) => {
  isDrawingCont = true
  firmaContadorVacia.value = false
  const pos = getPos(canvasContador.value, e)
  ctxContador.beginPath()
  ctxContador.moveTo(pos.x, pos.y)
}
const drawContador = (e) => {
  if (!isDrawingCont) return
  const pos = getPos(canvasContador.value, e)
  ctxContador.lineTo(pos.x, pos.y)
  ctxContador.stroke()
}
const stopDrawingContador = () => {
  isDrawingCont = false
}

const confirmarEntrega = () => {
  submittedEntrega.value = true
  if (firmaRecepcionistaVacia.value || firmaContadorVacia.value) {
    $q.notify({
      type: 'warning',
      message: 'Ambas firmas son obligatorias para confirmar la entrega.',
      position: 'top-right',
    })
    return
  }
  if (!contadorEntrega.value) {
    $q.notify({
      type: 'warning',
      message: 'Seleccione el contador que recibe la documentación.',
      position: 'top-right',
    })
    return
  }

  // Cambio de estado: el documento pasa a EN_PROCESO
  documentoSeleccionado.value.contador = contadorEntrega.value
  documentoSeleccionado.value.estado = 'En Proceso'

  $q.notify({
    type: 'positive',
    message: `Documento ${documentoSeleccionado.value.folio} entregado a ${contadorEntrega.value}. Estado: En Proceso.`,
    position: 'top-right',
  })

  cerrarDialogoEntrega()
}
</script>

<style scoped>
.style-signature-canvas {
  touch-action: none;
  cursor: crosshair;
  width: 100%;
  height: 120px;
}
.border-negative {
  border: 2px solid #c10015;
}
</style>