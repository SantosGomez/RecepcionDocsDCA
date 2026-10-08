<template>
  <q-page class="q-pa-md bg-grey-2">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <!-- Encabezado de la Vista -->
        <q-card flat class="q-mb-md bg-white shadow-1 rounded-borders">
          <q-card-section class="row items-center q-pb-none">
            <div class="col">
              <div class="text-h5 text-weight-bold text-primary">Recepción de Documentos</div>
              <div class="text-subtitle2 text-grey-7">
                Módulo de registro e ingesta de comprobantes contables y fiscales
              </div>
            </div>
            <div class="col-auto">
              <q-chip color="blue-1" text-color="primary" icon="history">
                Folio actual: <strong class="q-ml-xs">DCA-2026-0842</strong>
              </q-chip>
            </div>
          </q-card-section>
          <q-separator class="q-mt-md" />
        </q-card>

        <!-- Formulario Principal -->
        <q-card flat class="shadow-2 bg-white rounded-borders">
          <q-card-section>
            <q-form @submit="onSubmit" class="q-gutter-y-md">
              <!-- Sección 1: Datos de la Entidad -->
              <div class="text-subtitle1 text-weight-bold text-grey-8 row items-center">
                <q-icon name="business" class="q-mr-xs text-primary" size="20px" />
                1. Selección de Cliente y Empresa Receptora
              </div>

              <div class="row q-col-gutter-md">
                <div class="col-12 col-sm-6">
                  <q-select
                    v-model="form.empresaDca"
                    :options="opcionesEmpresasDca"
                    label="Empresa del Grupo DCA Receptora *"
                    outlined
                    dense
                    options-dense
                    :rules="[(val) => !!val || 'Seleccione la empresa receptora']"
                  >
                    <template #prepend>
                      <q-icon name="account_balance" color="primary" />
                    </template>
                  </q-select>
                </div>

                <div class="col-12 col-sm-6">
                  <q-select
                    v-model="form.cliente"
                    :options="opcionesClientes"
                    label="Cliente / Razón Social *"
                    outlined
                    dense
                    use-input
                    input-debounce="0"
                    options-dense
                    :rules="[(val) => !!val || 'Seleccione o ingrese un cliente']"
                  >
                    <template #prepend>
                      <q-icon name="person" color="primary" />
                    </template>
                  </q-select>
                </div>
              </div>

              <!-- Sección 2: Clasificación Contable -->
              <div class="text-subtitle1 text-weight-bold text-grey-8 row items-center q-pt-sm">
                <q-icon name="folder" class="q-mr-xs text-primary" size="20px" />
                2. Clasificación Contable y Periodo
              </div>

              <div class="row q-col-gutter-md">
                <div class="col-12 col-sm-6">
                  <q-select
                    v-model="form.tipoDocumento"
                    :options="opcionesTiposDocumento"
                    label="Tipo de Documento *"
                    outlined
                    dense
                    options-dense
                    :rules="[(val) => !!val || 'Seleccione el tipo de documento']"
                  >
                    <template #prepend>
                      <q-icon name="article" color="primary" />
                    </template>
                  </q-select>
                </div>

                <div class="col-6 col-sm-3">
                  <q-select
                    v-model="form.ejercicio"
                    :options="opcionesEjercicios"
                    label="Ejercicio (Año) *"
                    outlined
                    dense
                    options-dense
                  />
                </div>

                <div class="col-6 col-sm-3">
                  <q-select
                    v-model="form.periodo"
                    :options="opcionesMeses"
                    label="Periodo (Mes) *"
                    outlined
                    dense
                    options-dense
                  />
                </div>
              </div>

              <!-- Sección 3: Vía de Entrega y Carga de Archivos -->
              <div class="text-subtitle1 text-weight-bold text-grey-8 row items-center q-pt-sm">
                <q-icon name="cloud_upload" class="q-mr-xs text-primary" size="20px" />
                3. Vía de Entrega y Archivos Adjuntos
              </div>

              <div class="row q-col-gutter-md">
                <div class="col-12 col-sm-6">
                  <q-select
                    v-model="form.viaEntrega"
                    :options="[
                      'Digital (PWA / Web)',
                      'Físico en Ventanilla',
                      'Correo Electrónico',
                      'Mensajería',
                    ]"
                    label="Vía de Entrega *"
                    outlined
                    dense
                  />
                </div>

                <div class="col-12 col-sm-6">
                  <q-input
                    v-model="form.recibidoPor"
                    label="Atendido / Recibido por *"
                    outlined
                    dense
                    readonly
                  >
                    <template #prepend>
                      <q-icon name="badge" color="primary" />
                    </template>
                  </q-input>
                </div>
              </div>

              <!-- Zona de subida de archivos (Simulación PWA) -->
              <div class="q-my-sm">
                <q-file
                  v-model="form.archivos"
                  label="Seleccionar o arrastrar archivos (PDF, XML, ZIP, JPG)"
                  outlined
                  multiple
                  use-chips
                  append
                >
                  <template #prepend>
                    <q-icon name="attach_file" color="primary" />
                  </template>
                  <template #hint>
                    Formatos aceptados: .pdf, .xml, .zip, .jpg. Tamaño máximo: 25MB por archivo.
                  </template>
                </q-file>
              </div>

              <!-- Sección 4: Firmas Digitales de Conformidad -->
              <div class="text-subtitle1 text-weight-bold text-grey-8 row items-center q-pt-sm">
                <q-icon name="draw" class="q-mr-xs text-primary" size="20px" />
                4. Firmas Digitales de Conformidad
              </div>

              <div class="row q-col-gutter-md">
                <!-- Firma de Entregado (Cliente) -->
                <div class="col-12 col-sm-6">
                  <q-card flat bordered class="q-pa-sm bg-grey-1">
                    <div class="row items-center justify-between q-mb-xs">
                      <div class="text-caption text-weight-bold text-grey-8">
                        Firma de Entregado (Cliente / Entrega) *
                      </div>
                      <q-btn
                        flat
                        dense
                        size="sm"
                        color="negative"
                        icon="clear"
                        label="Limpiar"
                        @click="limpiarFirmaCliente"
                      >
                        <q-tooltip>Limpiar trazo de la firma del cliente</q-tooltip>
                      </q-btn>
                    </div>
                    <canvas
                      ref="canvasCliente"
                      width="350"
                      height="120"
                      class="bg-white rounded-borders style-signature-canvas"
                      @mousedown="startDrawingCliente"
                      @mousemove="drawCliente"
                      @mouseup="stopDrawingCliente"
                      @mouseleave="stopDrawingCliente"
                      @touchstart.prevent="startDrawingCliente"
                      @touchmove.prevent="drawCliente"
                      @touchend.prevent="stopDrawingCliente"
                    ></canvas>
                    <div class="text-caption text-grey-6 text-center q-mt-xs">
                      <q-icon name="gesture" /> Dibuje la firma con el dedo o ratón
                    </div>
                  </q-card>
                </div>

                <!-- Firma de Recibido (Recepcionista DCA) -->
                <div class="col-12 col-sm-6">
                  <q-card flat bordered class="q-pa-sm bg-grey-1">
                    <div class="row items-center justify-between q-mb-xs">
                      <div class="text-caption text-weight-bold text-grey-8">
                        Firma de Recibido (Usuario Recepción DCA) *
                      </div>
                      <q-btn
                        flat
                        dense
                        size="sm"
                        color="negative"
                        icon="clear"
                        label="Limpiar"
                        @click="limpiarFirmaRecepcion"
                      >
                        <q-tooltip>Limpiar trazo de la firma del recepcionista</q-tooltip>
                      </q-btn>
                    </div>
                    <canvas
                      ref="canvasRecepcion"
                      width="350"
                      height="120"
                      class="bg-white rounded-borders style-signature-canvas"
                      @mousedown="startDrawingRecepcion"
                      @mousemove="drawRecepcion"
                      @mouseup="stopDrawingRecepcion"
                      @mouseleave="stopDrawingRecepcion"
                      @touchstart.prevent="startDrawingRecepcion"
                      @touchmove.prevent="drawRecepcion"
                      @touchend.prevent="stopDrawingRecepcion"
                    ></canvas>
                    <div class="text-caption text-grey-6 text-center q-mt-xs">
                      <q-icon name="edit" /> Firma del usuario recepcionista
                    </div>
                  </q-card>
                </div>
              </div>

              <!-- Comentarios adicionales -->
              <q-input
                v-model="form.observaciones"
                type="textarea"
                rows="2"
                label="Observaciones o notas adicionales"
                outlined
                dense
                placeholder="Ej: Facturas pendientes de la segunda quincena, faltan 2 estados de cuenta de Santander."
              />

              <!-- Acciones -->
              <q-separator />

              <div class="row justify-end q-gutter-sm">
                <q-btn label="Limpiar Formulario" color="grey-7" flat @click="resetForm" />
                <q-btn
                  type="submit"
                  label="Registrar Recepción y Generar Acuse"
                  color="primary"
                  icon-right="receipt_long"
                  class="q-px-md"
                >
                  <q-tooltip>Registrar la entrega e imprimir acuse de recepción</q-tooltip>
                </q-btn>
              </div>
            </q-form>
          </q-card-section>
        </q-card>

        <!-- Modal de Acuse de Recibo Simulado -->
        <q-dialog v-model="mostrarAcuse">
          <q-card style="width: 580px; max-width: 95vw" class="q-pa-sm">
            <q-card-section class="row items-center bg-primary text-white rounded-borders">
              <q-icon name="verified" size="32px" class="q-mr-sm" />
              <div>
                <div class="text-h6 text-weight-bold">Acuse Digital de Recepción</div>
                <div class="text-caption">Grupo DCA — Recepción de Documentación</div>
              </div>
              <q-space />
              <q-btn icon="close" flat round dense v-close-popup>
                <q-tooltip>Cerrar acuse de recepción</q-tooltip>
              </q-btn>
            </q-card-section>

            <q-card-section class="q-pt-md">
              <div
                class="row justify-between items-center q-mb-md bg-blue-1 q-pa-sm rounded-borders"
              >
                <div>
                  <span class="text-caption text-grey-8">Folio de Acuse:</span><br />
                  <strong class="text-subtitle1 text-primary">{{ acuseData.folio }}</strong>
                </div>
                <div class="text-right">
                  <span class="text-caption text-grey-8">Fecha y Hora:</span><br />
                  <strong class="text-caption">{{ acuseData.fechaHora }}</strong>
                </div>
              </div>

              <q-list separator dense>
                <q-item>
                  <q-item-section class="text-grey-7">Empresa Receptora:</q-item-section>
                  <q-item-section class="text-weight-bold text-right">{{
                    form.empresaDca
                  }}</q-item-section>
                </q-item>
                <q-item>
                  <q-item-section class="text-grey-7">Cliente / Razón Social:</q-item-section>
                  <q-item-section class="text-weight-bold text-right">{{
                    form.cliente
                  }}</q-item-section>
                </q-item>
                <q-item>
                  <q-item-section class="text-grey-7">Tipo de Documento:</q-item-section>
                  <q-item-section class="text-weight-bold text-right">{{
                    form.tipoDocumento
                  }}</q-item-section>
                </q-item>
                <q-item>
                  <q-item-section class="text-grey-7">Periodo Fiscal:</q-item-section>
                  <q-item-section class="text-weight-bold text-right"
                    >{{ form.periodo }} {{ form.ejercicio }}</q-item-section
                  >
                </q-item>
                <q-item>
                  <q-item-section class="text-grey-7">Vía de Entrega:</q-item-section>
                  <q-item-section class="text-weight-bold text-right">{{
                    form.viaEntrega
                  }}</q-item-section>
                </q-item>
                <q-item>
                  <q-item-section class="text-grey-7">Archivos Adjuntos:</q-item-section>
                  <q-item-section class="text-weight-bold text-right">
                    {{
                      form.archivos && form.archivos.length
                        ? form.archivos.length + ' archivo(s)'
                        : 'Sin adjuntos (Físico)'
                    }}
                  </q-item-section>
                </q-item>
              </q-list>

              <!-- Sección de Firmas Estampadas en el Acuse -->
              <div class="q-mt-md text-subtitle2 text-weight-bold text-grey-8">
                Firmas Registradas de Conformidad:
              </div>
              <div class="row q-col-gutter-sm q-mt-xs">
                <div class="col-6 text-center">
                  <div class="q-pa-xs border-grey rounded-borders bg-white">
                    <img
                      v-if="firmaClienteUrl"
                      :src="firmaClienteUrl"
                      style="max-width: 100%; height: 60px; object-fit: contain"
                    />
                    <div v-else class="text-caption text-italic text-grey-5 style-no-signature">
                      [Sin Firma Dibujada]
                    </div>
                  </div>
                  <div class="text-caption text-weight-bold q-mt-xs text-grey-8">
                    Firma de Entregado
                  </div>
                  <div class="text-caption text-grey-7" style="font-size: 0.7rem">
                    {{ form.cliente || 'Cliente' }}
                  </div>
                </div>

                <div class="col-6 text-center">
                  <div class="q-pa-xs border-grey rounded-borders bg-white">
                    <img
                      v-if="firmaRecepcionUrl"
                      :src="firmaRecepcionUrl"
                      style="max-width: 100%; height: 60px; object-fit: contain"
                    />
                    <div v-else class="text-caption text-italic text-grey-5 style-no-signature">
                      [Sin Firma Dibujada]
                    </div>
                  </div>
                  <div class="text-caption text-weight-bold q-mt-xs text-grey-8">
                    Firma de Recibido
                  </div>
                  <div class="text-caption text-grey-7" style="font-size: 0.7rem">
                    {{ form.recibidoPor }}
                  </div>
                </div>
              </div>

              <div class="q-mt-md text-caption text-grey-7 bg-grey-2 q-pa-sm rounded-borders">
                <strong>Nota:</strong> Este comprobante digital valida la ingesta preliminar de la
                documentación en el sistema del Grupo DCA para su posterior revisión contable.
              </div>
            </q-card-section>

            <q-card-actions align="right" class="q-pr-md q-pb-md">
              <q-btn flat label="Cerrar" color="grey-8" v-close-popup />
              <q-btn
                icon="print"
                label="Imprimir / PDF Acuse"
                color="primary"
                @click="simularImpresion"
              >
                <q-tooltip>Imprimir o descargar acuse digital en PDF</q-tooltip>
              </q-btn>
            </q-card-actions>
          </q-card>
        </q-dialog>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useQuasar } from 'quasar'

const $q = useQuasar()

const opcionesEmpresasDca = [
  'DCA Contadores Públicos y Consultores S.C.',
  'DCA Asesores Fiscales y Legales S.A. de C.V.',
  'DCA Soluciones Integrales de Nómina S.C.',
]

const opcionesClientes = [
  'Comercializadora del Norte S.A. de C.V.',
  'Constructora Grupo Hábitat S. de R.L.',
  'Restaurantes y Alimentos del Centro S.A.',
  'Servicios Médicos Especializados S.C.',
  'Transportes y Logística Rápida S.A.',
  'Industrias Plásticas de México S.A.',
]

const opcionesTiposDocumento = [
  'Facturas Emitidas / Recibidas (CFDI XML/PDF)',
  'Estados de Cuenta Bancarios',
  'Comprobantes de Pago / Transferencias',
  'Nómina y Comprobantes IMSS/INFONAVIT',
  'Declaraciones / Acuses de Impuestos',
  'Contratos / Expediente Legal',
  'Papelería y Comprobantes Diversos',
]

const opcionesEjercicios = ['2026', '2025', '2024']
const opcionesMeses = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
]

const form = reactive({
  empresaDca: 'DCA Contadores Públicos y Consultores S.C.',
  cliente: null,
  tipoDocumento: null,
  ejercicio: '2026',
  periodo: 'Octubre',
  viaEntrega: 'Digital (PWA / Web)',
  recibidoPor: 'Recepción DCA (Ana Martínez)',
  archivos: null,
  observaciones: '',
})

const mostrarAcuse = ref(false)
const acuseData = reactive({
  folio: '',
  fechaHora: '',
})

// Lógica de Canvas para Firmas Digitales
const canvasCliente = ref(null)
const canvasRecepcion = ref(null)
let ctxCliente = null
let ctxRecepcion = null
let isDrawingC = false
let isDrawingR = false

const firmaClienteUrl = ref('')
const firmaRecepcionUrl = ref('')

onMounted(() => {
  if (canvasCliente.value) {
    ctxCliente = canvasCliente.value.getContext('2d')
    ctxCliente.lineWidth = 2
    ctxCliente.lineCap = 'round'
    ctxCliente.strokeStyle = '#1565C0'
  }
  if (canvasRecepcion.value) {
    ctxRecepcion = canvasRecepcion.value.getContext('2d')
    ctxRecepcion.lineWidth = 2
    ctxRecepcion.lineCap = 'round'
    ctxRecepcion.strokeStyle = '#2E7D32'
  }
})

function getPos(canvas, evt) {
  const rect = canvas.getBoundingClientRect()
  const clientX = evt.touches ? evt.touches[0].clientX : evt.clientX
  const clientY = evt.touches ? evt.touches[0].clientY : evt.clientY
  return {
    x: clientX - rect.left,
    y: clientY - rect.top,
  }
}

// Canvas Cliente
const startDrawingCliente = (e) => {
  isDrawingC = true
  const pos = getPos(canvasCliente.value, e)
  ctxCliente.beginPath()
  ctxCliente.moveTo(pos.x, pos.y)
}
const drawCliente = (e) => {
  if (!isDrawingC) return
  const pos = getPos(canvasCliente.value, e)
  ctxCliente.lineTo(pos.x, pos.y)
  ctxCliente.stroke()
}
const stopDrawingCliente = () => {
  isDrawingC = false
}
const limpiarFirmaCliente = () => {
  if (ctxCliente && canvasCliente.value) {
    ctxCliente.clearRect(0, 0, canvasCliente.value.width, canvasCliente.value.height)
    firmaClienteUrl.value = ''
  }
}

// Canvas Recepción
const startDrawingRecepcion = (e) => {
  isDrawingR = true
  const pos = getPos(canvasRecepcion.value, e)
  ctxRecepcion.beginPath()
  ctxRecepcion.moveTo(pos.x, pos.y)
}
const drawRecepcion = (e) => {
  if (!isDrawingR) return
  const pos = getPos(canvasRecepcion.value, e)
  ctxRecepcion.lineTo(pos.x, pos.y)
  ctxRecepcion.stroke()
}
const stopDrawingRecepcion = () => {
  isDrawingR = false
}
const limpiarFirmaRecepcion = () => {
  if (ctxRecepcion && canvasRecepcion.value) {
    ctxRecepcion.clearRect(0, 0, canvasRecepcion.value.width, canvasRecepcion.value.height)
    firmaRecepcionUrl.value = ''
  }
}

const onSubmit = () => {
  if (canvasCliente.value) {
    firmaClienteUrl.value = canvasCliente.value.toDataURL()
  }
  if (canvasRecepcion.value) {
    firmaRecepcionUrl.value = canvasRecepcion.value.toDataURL()
  }

  acuseData.folio = 'DCA-REC-' + Math.floor(100000 + Math.random() * 900000)
  acuseData.fechaHora = new Date().toLocaleString('es-MX')
  mostrarAcuse.value = true

  $q.notify({
    type: 'positive',
    message: 'Documento registrado con firmas exitosamente en el sistema Grupo DCA',
    position: 'top-right',
  })
}

const resetForm = () => {
  form.cliente = null
  form.tipoDocumento = null
  form.archivos = null
  form.observaciones = ''
  limpiarFirmaCliente()
  limpiarFirmaRecepcion()
}

const simularImpresion = () => {
  $q.notify({
    type: 'info',
    message: 'Generando archivo PDF del Acuse de Recepción con firmas digitalizadas...',
    position: 'bottom-right',
  })
}
</script>

<style scoped>
.style-signature-canvas {
  border: 1px dashed #bdbdbd;
  touch-action: none;
  cursor: crosshair;
  width: 100%;
}
.border-grey {
  border: 1px solid #e0e0e0;
}
.style-no-signature {
  height: 60px;
  line-height: 60px;
}
</style>
