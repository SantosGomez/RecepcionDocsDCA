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
                Folio actual: <strong class="q-ml-xs">{{ form.folio }}</strong>
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
                    @update:model-value="onClienteChange"
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
                  <q-input
                    v-model="form.asunto"
                    label="Asunto del Documento *"
                    outlined
                    dense
                    :rules="[(val) => !!val || 'El asunto es requerido']"
                  />
                </div>
                <div class="col-12 col-sm-6">
                  <q-select
                    v-model="form.departamento"
                    :options="opcionesDepartamentos"
                    label="Departamento *"
                    outlined
                    dense
                    options-dense
                    :rules="[(val) => !!val || 'Seleccione el departamento']"
                  />
                </div>
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

              <!-- Sección 3: Vía de Entrega y Prioridad -->
              <div class="text-subtitle1 text-weight-bold text-grey-8 row items-center q-pt-sm">
                <q-icon name="assignment_late" class="q-mr-xs text-primary" size="20px" />
                3. Prioridad y Vía de Entrega
              </div>

              <div class="row q-col-gutter-md">
                <div class="col-12 col-sm-4">
                  <q-select
                    v-model="form.prioridad"
                    :options="opcionesPrioridades"
                    label="Prioridad *"
                    outlined
                    dense
                    options-dense
                    @update:model-value="calcularSla"
                  />
                </div>
                <div class="col-12 col-sm-4">
                  <q-input
                    v-model="form.fechaLimiteSla"
                    label="Fecha Límite SLA"
                    outlined
                    dense
                    readonly
                    hint="Calculada automáticamente según prioridad"
                  />
                </div>
                <div class="col-12 col-sm-4">
                  <q-select
                    v-model="form.contadorAsignado"
                    :options="opcionesContadores"
                    label="Contador Asignado"
                    outlined
                    dense
                    options-dense
                    use-input
                  />
                </div>
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
                  <q-toggle
                    v-model="form.notificarCorreo"
                    label="Notificar al cliente por correo al finalizar"
                    color="primary"
                  />
                </div>
              </div>

              <!-- Archivos y firmas... -->
              <div class="text-subtitle1 text-weight-bold text-grey-8 row items-center q-pt-sm">
                <q-icon name="draw" class="q-mr-xs text-primary" size="20px" />
                4. Archivos Adjuntos y Firmas
              </div>

              <div class="q-my-sm">
                <q-file
                  v-model="form.archivos"
                  label="Seleccionar o arrastrar archivos (PDF, XML, ZIP, JPG)"
                  outlined
                  multiple
                  use-chips
                  append
                  accept=".pdf, .xml, .zip, .jpg"
                  @update:model-value="validarTamañoArchivos"
                >
                  <template #prepend>
                    <q-icon name="attach_file" color="primary" />
                  </template>
                  <template #hint>
                    Formatos aceptados: .pdf, .xml, .zip, .jpg. Tamaño máximo: 25MB por archivo.
                  </template>
                </q-file>
              </div>

              <div class="row q-col-gutter-md">
                <div class="col-12 col-sm-6">
                  <q-card flat bordered :class="['q-pa-sm bg-grey-1', { 'border-negative': firmaClienteVacia && submitted }]">
                    <div class="row items-center justify-between q-mb-xs">
                      <div class="text-caption text-weight-bold" :class="[firmaClienteVacia && submitted ? 'text-negative' : 'text-grey-8']">
                        Firma de Entregado (Cliente) *
                      </div>
                      <q-btn flat dense size="sm" color="negative" icon="clear" label="Limpiar" @click="limpiarFirmaCliente">
                        <q-tooltip>Limpiar trazo de la firma del cliente</q-tooltip>
                      </q-btn>
                    </div>
                    <canvas
                      ref="canvasCliente"
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
                <div class="col-12 col-sm-6">
                  <q-card flat bordered :class="['q-pa-sm bg-grey-1', { 'border-negative': firmaRecepcionVacia && submitted }]">
                    <div class="row items-center justify-between q-mb-xs">
                      <div class="text-caption text-weight-bold" :class="[firmaRecepcionVacia && submitted ? 'text-negative' : 'text-grey-8']">
                        Firma de Recibido (DCA) *
                      </div>
                      <q-btn flat dense size="sm" color="negative" icon="clear" label="Limpiar" @click="limpiarFirmaRecepcion">
                        <q-tooltip>Limpiar trazo de la firma del recepcionista</q-tooltip>
                      </q-btn>
                    </div>
                    <canvas
                      ref="canvasRecepcion"
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

              <q-input v-model="form.observaciones" type="textarea" rows="2" label="Observaciones" outlined dense />

              <div class="row justify-end q-gutter-sm">
                <q-btn label="Limpiar" color="grey-7" flat @click="resetForm" />
                <q-btn type="submit" label="Registrar y Acuse" color="primary" icon-right="receipt_long" class="q-px-md">
                   <q-tooltip>Registrar la entrega e imprimir acuse de recepción</q-tooltip>
                </q-btn>
              </div>
            </q-form>
          </q-card-section>
        </q-card>
        
        <!-- Modal Acuse -->
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
              <div class="row justify-between items-center q-mb-md bg-blue-1 q-pa-sm rounded-borders">
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
                <q-item><q-item-section class="text-grey-7">Empresa:</q-item-section><q-item-section class="text-right text-weight-bold">{{ form.empresaDca }}</q-item-section></q-item>
                <q-item><q-item-section class="text-grey-7">Cliente:</q-item-section><q-item-section class="text-right text-weight-bold">{{ form.cliente }}</q-item-section></q-item>
                <q-item><q-item-section class="text-grey-7">Asunto:</q-item-section><q-item-section class="text-right text-weight-bold">{{ form.asunto }}</q-item-section></q-item>
                <q-item><q-item-section class="text-grey-7">Departamento:</q-item-section><q-item-section class="text-right text-weight-bold">{{ form.departamento }}</q-item-section></q-item>
                <q-item><q-item-section class="text-grey-7">SLA (Fecha Límite):</q-item-section><q-item-section class="text-right text-weight-bold">{{ form.fechaLimiteSla }}</q-item-section></q-item>
                <q-item><q-item-section class="text-grey-7">Archivos:</q-item-section><q-item-section class="text-right text-weight-bold">{{ form.archivos ? form.archivos.length + ' archivo(s)' : 'Ninguno' }}</q-item-section></q-item>
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
                    <div v-else class="text-caption text-italic text-grey-5" style="height: 60px; line-height: 60px;">
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
                    <div v-else class="text-caption text-italic text-grey-5" style="height: 60px; line-height: 60px;">
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
               <q-btn icon="print" label="Imprimir Acuse" color="primary" @click="() => {}">
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
const submitted = ref(false)

const opcionesEmpresasDca = ['DCA Contadores Públicos y Consultores S.C.', 'DCA Asesores Fiscales y Legales S.A. de C.V.', 'DCA Soluciones Integrales de Nómina S.C.']
const opcionesClientes = ['Comercializadora del Norte S.A. de C.V.', 'Constructora Grupo Hábitat S. de R.L.', 'Restaurantes y Alimentos del Centro S.A.', 'Servicios Médicos Especializados S.C.', 'Transportes y Logística Rápida S.A.', 'Industrias Plásticas de México S.A.']
const opcionesTiposDocumento = ['Facturas Emitidas / Recibidas (CFDI XML/PDF)', 'Estados de Cuenta Bancarios', 'Comprobantes de Pago / Transferencias', 'Nómina y Comprobantes IMSS/INFONAVIT', 'Declaraciones / Acuses de Impuestos', 'Contratos / Expediente Legal', 'Papelería y Comprobantes Diversos']
const opcionesEjercicios = ['2026', '2025', '2024']
const opcionesMeses = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
const opcionesDepartamentos = ['Contabilidad', 'Fiscal', 'Nóminas', 'Legal']
const opcionesPrioridades = ['URGENTE', 'ALTA', 'MEDIA', 'BAJA']
const opcionesContadores = ['Lic. Ana Martínez', 'CP. Carlos Ruiz', 'Lic. Elena Gómez']

const obtenerFechaSla = (prioridad) => {
  const dias = { 'URGENTE': 2, 'ALTA': 4, 'MEDIA': 8, 'BAJA': 15 }[prioridad] || 8
  let fecha = new Date()
  let sumados = 0
  while (sumados < dias) {
    fecha.setDate(fecha.getDate() + 1)
    if (fecha.getDay() !== 0 && fecha.getDay() !== 6) sumados++
  }
  return fecha.toISOString().split('T')[0]
}

const form = reactive({
  folio: 'DCA-2026-' + Math.floor(1000 + Math.random() * 9000),
  empresaDca: 'DCA Contadores Públicos y Consultores S.C.',
  cliente: null,
  asunto: '',
  departamento: null,
  tipoDocumento: null,
  ejercicio: '2026',
  periodo: 'Octubre',
  prioridad: 'MEDIA',
  fechaLimiteSla: obtenerFechaSla('MEDIA'),
  contadorAsignado: null,
  viaEntrega: 'Digital (PWA / Web)',
  notificarCorreo: false,
  recibidoPor: 'Recepción DCA (Ana Martínez)',
  archivos: null,
  observaciones: ''
})

const calcularSla = () => { form.fechaLimiteSla = obtenerFechaSla(form.prioridad) }
const onClienteChange = (val) => { if (val) form.contadorAsignado = 'CP. Carlos Ruiz' }
const validarTamañoArchivos = (files) => {
  if (!files) return
  for (const file of files) {
    if (file.size > 25 * 1024 * 1024) {
      $q.notify({ type: 'negative', message: 'Archivo ' + file.name + ' excede 25MB' })
      form.archivos = form.archivos.filter(f => f !== file)
    }
  }
}

const mostrarAcuse = ref(false)
const acuseData = reactive({ folio: '', fechaHora: '' })
const firmaClienteUrl = ref('')
const firmaRecepcionUrl = ref('')

// Canvas
const canvasCliente = ref(null)
const canvasRecepcion = ref(null)
const firmaClienteVacia = ref(true)
const firmaRecepcionVacia = ref(true)
let ctxCliente = null, ctxRecepcion = null
let isDrawingC = false, isDrawingR = false

onMounted(() => {
  [canvasCliente.value, canvasRecepcion.value].forEach((c, idx) => {
    c.width = c.offsetWidth
    c.height = c.offsetHeight
    const ctx = c.getContext('2d')
    ctx.lineWidth = 2
    ctx.lineCap = 'round'
    ctx.strokeStyle = idx === 0 ? '#1565C0' : '#2E7D32'
    if (idx === 0) ctxCliente = ctx
    else ctxRecepcion = ctx
  })
})

const getPos = (canvas, e) => {
  const rect = canvas.getBoundingClientRect()
  return { x: (e.touches ? e.touches[0].clientX : e.clientX) - rect.left, y: (e.touches ? e.touches[0].clientY : e.clientY) - rect.top }
}

const startDrawing = (e, canvas, ctx, isVacia) => {
  const pos = getPos(canvas, e)
  ctx.beginPath()
  ctx.moveTo(pos.x, pos.y)
  isVacia.value = false
  return true
}

const startDrawingCliente = (e) => { isDrawingC = startDrawing(e, canvasCliente.value, ctxCliente, firmaClienteVacia) }
const drawCliente = (e) => { if (isDrawingC) { const pos = getPos(canvasCliente.value, e); ctxCliente.lineTo(pos.x, pos.y); ctxCliente.stroke() } }
const stopDrawingCliente = () => { isDrawingC = false }
const limpiarFirmaCliente = () => { ctxCliente.clearRect(0, 0, canvasCliente.value.width, canvasCliente.value.height); firmaClienteVacia.value = true }

const startDrawingRecepcion = (e) => { isDrawingR = startDrawing(e, canvasRecepcion.value, ctxRecepcion, firmaRecepcionVacia) }
const drawRecepcion = (e) => { if (isDrawingR) { const pos = getPos(canvasRecepcion.value, e); ctxRecepcion.lineTo(pos.x, pos.y); ctxRecepcion.stroke() } }
const stopDrawingRecepcion = () => { isDrawingR = false }
const limpiarFirmaRecepcion = () => { ctxRecepcion.clearRect(0, 0, canvasRecepcion.value.width, canvasRecepcion.value.height); firmaRecepcionVacia.value = true }

const onSubmit = () => {
  submitted.value = true
  if (firmaClienteVacia.value || firmaRecepcionVacia.value) {
    $q.notify({ type: 'warning', message: 'Ambas firmas son obligatorias para el registro' })
    return
  }
  acuseData.folio = form.folio
  acuseData.fechaHora = new Date().toLocaleString('es-MX')
  
  // Captura de firmas para persistencia
  firmaClienteUrl.value = canvasCliente.value.toDataURL()
  firmaRecepcionUrl.value = canvasRecepcion.value.toDataURL()

  mostrarAcuse.value = true
}

const resetForm = () => {
  submitted.value = false
  form.asunto = ''; form.departamento = null; form.contadorAsignado = null; form.archivos = null
  limpiarFirmaCliente(); limpiarFirmaRecepcion()
  firmaClienteUrl.value = ''
  firmaRecepcionUrl.value = ''
}
</script>

<style scoped>
.style-signature-canvas { touch-action: none; cursor: crosshair; width: 100%; height: 120px; }
.border-negative { border: 2px solid #C10015; }
.border-grey {
  border: 1px solid #e0e0e0;
}
</style>