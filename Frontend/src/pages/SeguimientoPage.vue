<template>
  <q-page class="q-pa-md bg-grey-2">
    <div class="row justify-center">
      <div class="col-12 col-md-10 col-lg-8">
        <!-- Encabezado del Portal de Seguimiento -->
        <q-card flat class="q-mb-md bg-white shadow-1 rounded-borders text-center q-pa-md">
          <q-avatar
            icon="track_changes"
            color="blue-1"
            text-color="primary"
            size="60px"
            class="q-mb-xs"
          />
          <div class="text-h5 text-weight-bold text-primary">Portal de Seguimiento Documental</div>
          <div class="text-subtitle2 text-grey-7">
            Consulta el estado de procesamiento de tus comprobantes entregados al Grupo DCA
          </div>
        </q-card>

        <!-- Buscador de Folio o RFC -->
        <q-card flat class="shadow-2 bg-white rounded-borders q-mb-md">
          <q-card-section>
            <div class="text-subtitle1 text-weight-bold text-grey-8 q-mb-sm">
              Buscar Expediente o Folio
            </div>
            <div class="row q-col-gutter-sm">
              <div class="col">
                <q-input
                  v-model="queryBusqueda"
                  outlined
                  dense
                  placeholder="Ingresa tu Folio (ej: DCA-REC-0842) o tu RFC (ej: CNO120415AB3)"
                  @keyup.enter="buscarFolio"
                >
                  <template #prepend>
                    <q-icon name="search" color="primary" />
                  </template>
                </q-input>
              </div>
              <div class="col-auto">
                <q-btn color="primary" label="Consultar" icon="search" @click="buscarFolio">
                  <q-tooltip>Consultar expediente por folio de acuse o RFC</q-tooltip>
                </q-btn>
              </div>
            </div>
          </q-card-section>
        </q-card>

        <!-- Resultado del Seguimiento -->
        <div v-if="expedienteEncontrado">
          <!-- Tarjeta con Resumen de Expediente -->
          <q-card flat class="shadow-2 bg-white rounded-borders q-mb-md">
            <q-card-section class="bg-blue-1 text-primary row items-center justify-between">
              <div>
                <div class="text-caption text-uppercase text-weight-bold">Folio de Recepción</div>
                <div class="text-h6 text-weight-bold">{{ expedienteData.folio }}</div>
              </div>
              <div class="text-right">
                <q-chip
                  :color="getChipColor(expedienteData.estado)"
                  text-color="white"
                  class="text-weight-bold"
                >
                  {{ expedienteData.estado }}
                </q-chip>
              </div>
            </q-card-section>

            <q-card-section>
              <div class="row q-col-gutter-sm">
                <div class="col-12 col-sm-6">
                  <div>
                    <strong class="text-grey-7">Cliente:</strong> {{ expedienteData.cliente }}
                  </div>
                  <div><strong class="text-grey-7">RFC:</strong> {{ expedienteData.rfc }}</div>
                  <div>
                    <strong class="text-grey-7">Despacho Receptor:</strong>
                    {{ expedienteData.empresaDca }}
                  </div>
                </div>
                <div class="col-12 col-sm-6">
                  <div>
                    <strong class="text-grey-7">Tipo de Documento:</strong>
                    {{ expedienteData.tipoDocumento }}
                  </div>
                  <div>
                    <strong class="text-grey-7">Periodo Fiscal:</strong>
                    {{ expedienteData.periodo }}
                  </div>
                  <div>
                    <strong class="text-grey-7">Fecha Ingesta:</strong>
                    {{ expedienteData.fechaRecepcion }}
                  </div>
                </div>
              </div>
            </q-card-section>
          </q-card>

          <!-- Línea de Tiempo (Timeline) de Procesamiento -->
          <q-card flat class="shadow-2 bg-white rounded-borders q-mb-md">
            <q-card-section class="q-pb-none">
              <div class="text-h6 text-weight-bold text-grey-8 row items-center">
                <q-icon name="timeline" color="primary" class="q-mr-xs" />
                Línea de Tiempo del Trámite
              </div>
            </q-card-section>

            <q-card-section>
              <q-timeline color="primary">
                <q-timeline-entry
                  title="Documento Recibido y Acuse Generado"
                  subtitle="08 de Octubre, 2026 - 10:15 AM"
                  icon="inventory_2"
                  color="positive"
                >
                  <div>
                    Ingesta preliminar en ventanilla/PWA registrada exitosamente. Se cuenta con
                    firma de entregado y recibido.
                  </div>
                </q-timeline-entry>

                <q-timeline-entry
                  title="Asignado a Área Contable"
                  subtitle="08 de Octubre, 2026 - 11:30 AM"
                  icon="assignment_ind"
                  color="positive"
                >
                  <div>
                    Documentación entregada al contador asignado (C.P. Ana Martínez) para revisión
                    de comprobantes fiscalmente deducibles.
                  </div>
                </q-timeline-entry>

                <q-timeline-entry
                  title="En Proceso de Conciliación y Registro"
                  subtitle="08 de Octubre, 2026 - En Curso"
                  icon="sync"
                  color="warning"
                >
                  <div>
                    Validación de XMLs contra el portal del SAT y cotejo de estados de cuenta
                    bancarios.
                  </div>
                </q-timeline-entry>

                <q-timeline-entry
                  title="Contabilización e Integración Final"
                  subtitle="Pendiente"
                  icon="fact_check"
                  color="grey-5"
                >
                  <div>
                    Generación de póliza contable y cálculo de impuestos provisionales del periodo.
                  </div>
                </q-timeline-entry>
              </q-timeline>
            </q-card-section>
          </q-card>

          <!-- Archivos adjuntos registrados -->
          <q-card flat class="shadow-2 bg-white rounded-borders">
            <q-card-section>
              <div class="text-subtitle1 text-weight-bold text-grey-8 q-mb-sm">
                Archivos Adjuntos Registrados
              </div>
              <q-list separator bordered rounded>
                <q-item v-for="(archivo, idx) in expedienteData.archivos" :key="idx">
                  <q-item-section avatar>
                    <q-icon
                      :name="archivo.tipo === 'pdf' ? 'picture_as_pdf' : 'code'"
                      color="primary"
                      size="28px"
                    />
                  </q-item-section>

                  <q-item-section>
                    <q-item-label class="text-weight-bold">{{ archivo.nombre }}</q-item-label>
                    <q-item-label caption>{{ archivo.tamano }} — {{ archivo.fecha }}</q-item-label>
                  </q-item-section>

                  <q-item-section side>
                    <q-btn
                      flat
                      round
                      icon="download"
                      color="primary"
                      @click="descargarArchivo(archivo.nombre)"
                    >
                      <q-tooltip>Descargar este archivo adjunto</q-tooltip>
                    </q-btn>
                  </q-item-section>
                </q-item>
              </q-list>
            </q-card-section>
          </q-card>
        </div>

        <!-- Estado si no se encuentra -->
        <div v-else class="text-center q-pa-xl text-grey-7">
          <q-icon name="find_in_page" size="64px" color="grey-4" />
          <div class="text-h6 q-mt-sm">Ingresa un Folio válido para ver el avance</div>
          <div class="text-caption">
            Ejemplo de folio disponible para prueba: <strong>DCA-REC-0842</strong>
          </div>
        </div>
      </div>
    </div>
  </q-page>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const queryBusqueda = ref('DCA-REC-0842')
const expedienteEncontrado = ref(true)

const expedienteData = reactive({
  folio: 'DCA-REC-0842',
  cliente: 'Comercializadora del Norte S.A. de C.V.',
  rfc: 'CNO120415AB3',
  empresaDca: 'DCA Contadores Públicos y Consultores S.C.',
  tipoDocumento: 'Facturas Emitidas / Recibidas (CFDI XML/PDF)',
  periodo: 'Octubre 2026',
  fechaRecepcion: '2026-10-08 10:15 AM',
  estado: 'En revisión',
  archivos: [
    {
      nombre: 'Facturas_Emitidas_Octubre_2026.pdf',
      tamano: '2.4 MB',
      fecha: '2026-10-08 10:15',
      tipo: 'pdf',
    },
    {
      nombre: 'Facturas_Emitidas_Octubre_2026.xml',
      tamano: '840 KB',
      fecha: '2026-10-08 10:15',
      tipo: 'xml',
    },
  ],
})

const getChipColor = (estado) => {
  if (estado === 'En revisión') return 'amber-9'
  if (estado === 'Aprobado') return 'positive'
  if (estado === 'Rechazado') return 'negative'
  return 'primary'
}

const buscarFolio = () => {
  if (!queryBusqueda.value.trim()) {
    $q.notify({
      type: 'warning',
      message: 'Ingresa un folio de acuse o RFC.',
      position: 'top-right',
    })
    return
  }
  expedienteEncontrado.value = true
  $q.notify({
    type: 'positive',
    message: `Expediente ${queryBusqueda.value} encontrado.`,
    position: 'top-right',
  })
}

const descargarArchivo = (nombre) => {
  $q.notify({
    type: 'info',
    message: `Descargando ${nombre}...`,
    position: 'bottom-right',
  })
}
</script>
