<template>
  <q-page class="q-pa-md bg-grey-2">
    <!-- Encabezado de Gestión de Usuarios -->
    <div class="row items-center justify-between q-mb-md">
      <div>
        <div class="text-h5 text-weight-bold text-primary">Gestión de Usuarios del Sistema</div>
        <div class="text-subtitle2 text-grey-7">
          Administración de cuentas, roles y permisos de acceso para personal DCA y clientes
        </div>
      </div>
      <div class="row q-gutter-sm">
        <q-btn icon="person_add" color="primary" label="Nuevo Usuario" @click="nuevoUsuario">
          <q-tooltip>Registrar un nuevo usuario en la plataforma</q-tooltip>
        </q-btn>
        <q-btn icon="refresh" flat color="primary" label="Actualizar" @click="cargarUsuarios">
          <q-tooltip>Recargar la lista de usuarios registrados</q-tooltip>
        </q-btn>
      </div>
    </div>

    <!-- Métricas Rápidas de Usuarios -->
    <div class="row q-col-gutter-md q-mb-md">
      <div class="col-12 col-sm-3">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center justify-between">
            <div>
              <div class="text-caption text-uppercase text-weight-bold text-grey-7">
                Usuarios Totales
              </div>
              <div class="text-h5 text-weight-bold text-primary">16</div>
            </div>
            <q-avatar icon="group" color="blue-1" text-color="primary" size="42px" />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-3">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center justify-between">
            <div>
              <div class="text-caption text-uppercase text-weight-bold text-grey-7">
                Contadores DCA
              </div>
              <div class="text-h5 text-weight-bold text-teal-8">6</div>
            </div>
            <q-avatar icon="badge" color="teal-1" text-color="teal-8" size="42px" />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-3">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center justify-between">
            <div>
              <div class="text-caption text-uppercase text-weight-bold text-grey-7">
                Recepcionistas
              </div>
              <div class="text-h5 text-weight-bold text-deep-purple">4</div>
            </div>
            <q-avatar
              icon="support_agent"
              color="deep-purple-1"
              text-color="deep-purple"
              size="42px"
            />
          </q-card-section>
        </q-card>
      </div>

      <div class="col-12 col-sm-3">
        <q-card flat class="shadow-1 rounded-borders bg-white">
          <q-card-section class="row items-center justify-between">
            <div>
              <div class="text-caption text-uppercase text-weight-bold text-grey-7">
                Accesos Clientes
              </div>
              <div class="text-h5 text-weight-bold text-orange-9">6</div>
            </div>
            <q-avatar icon="storefront" color="orange-1" text-color="orange-9" size="42px" />
          </q-card-section>
        </q-card>
      </div>
    </div>

    <!-- Tabla Principal de Usuarios -->
    <q-card flat class="shadow-2 rounded-borders bg-white">
      <q-card-section class="row items-center justify-between q-pb-none">
        <div class="text-h6 text-weight-bold text-grey-8">Directorio de Usuarios</div>
        <div class="row q-gutter-sm">
          <q-input
            v-model="filter"
            dense
            outlined
            placeholder="Buscar por nombre, correo o rol..."
            style="width: 280px"
          >
            <template #append>
              <q-icon name="search" />
            </template>
          </q-input>
          <q-select
            v-model="filtroRol"
            :options="['Todos los Roles', 'Administrador', 'Contador', 'Recepcionista', 'Cliente']"
            dense
            outlined
            style="width: 170px"
          />
        </div>
      </q-card-section>

      <q-card-section>
        <q-table
          :rows="filteredRows"
          :columns="columns"
          row-key="id"
          flat
          bordered
          :pagination="{ rowsPerPage: 6 }"
        >
          <!-- Usuario (Avatar + Nombre + Correo) -->
          <template #body-cell-usuario="props">
            <q-td :props="props">
              <div class="row items-center">
                <q-avatar color="primary" text-color="white" size="32px" class="q-mr-sm">
                  {{ props.row.nombre.charAt(0) }}
                </q-avatar>
                <div>
                  <div class="text-weight-bold text-grey-9">{{ props.row.nombre }}</div>
                  <div class="text-caption text-grey-7">{{ props.row.email }}</div>
                </div>
              </div>
            </q-td>
          </template>

          <!-- Rol -->
          <template #body-cell-rol="props">
            <q-td :props="props" class="text-center">
              <q-chip
                :color="getRolColor(props.value)"
                text-color="white"
                size="sm"
                class="text-weight-bold"
              >
                {{ props.value }}
              </q-chip>
            </q-td>
          </template>

          <!-- Estatus (Activo/Inactivo) -->
          <template #body-cell-estatus="props">
            <q-td :props="props" class="text-center">
              <q-badge :color="props.value === 'Activo' ? 'positive' : 'grey-6'" class="q-pa-xs">
                {{ props.value }}
              </q-badge>
            </q-td>
          </template>

          <!-- Acciones con Tooltips Claros -->
          <template #body-cell-acciones="props">
            <q-td :props="props" class="text-center">
              <q-btn flat round dense icon="edit" color="primary" @click="editarUsuario(props.row)">
                <q-tooltip>Editar información y perfil del usuario</q-tooltip>
              </q-btn>
              <q-btn
                flat
                round
                dense
                icon="lock_reset"
                color="warning"
                @click="resetPassword(props.row)"
              >
                <q-tooltip>Restablecer contraseña de acceso</q-tooltip>
              </q-btn>
              <q-btn
                flat
                round
                dense
                :icon="props.row.estatus === 'Activo' ? 'block' : 'check_circle'"
                :color="props.row.estatus === 'Activo' ? 'negative' : 'positive'"
                @click="toggleEstatus(props.row)"
              >
                <q-tooltip>{{
                  props.row.estatus === 'Activo' ? 'Desactivar usuario' : 'Activar usuario'
                }}</q-tooltip>
              </q-btn>
            </q-td>
          </template>
        </q-table>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const filter = ref('')
const filtroRol = ref('Todos los Roles')

const columns = [
  { name: 'usuario', label: 'Usuario / Correo', field: 'nombre', align: 'left', sortable: true },
  { name: 'empresaDca', label: 'Empresa DCA / Entidad', field: 'empresaDca', align: 'left' },
  { name: 'rol', label: 'Rol del Sistema', field: 'rol', align: 'center', sortable: true },
  { name: 'fechaRegistro', label: 'Fecha de Alta', field: 'fechaRegistro', align: 'center' },
  { name: 'estatus', label: 'Estado', field: 'estatus', align: 'center', sortable: true },
  { name: 'acciones', label: 'Acciones', field: 'acciones', align: 'center' },
]

const rows = ref([
  {
    id: 1,
    nombre: 'Lic. Roberto Garza',
    email: 'admin@ejemplo.com',
    empresaDca: 'DCA Contadores Públicos S.C.',
    rol: 'Administrador',
    fechaRegistro: '2025-01-15',
    estatus: 'Activo',
  },
  {
    id: 2,
    nombre: 'C.P. Ana Martínez',
    email: 'contador@ejemplo.com',
    empresaDca: 'DCA Asesores Fiscales S.A.',
    rol: 'Contador',
    fechaRegistro: '2025-03-10',
    estatus: 'Activo',
  },
  {
    id: 3,
    nombre: 'María López',
    email: 'recepcion@ejemplo.com',
    empresaDca: 'DCA Contadores Públicos S.C.',
    rol: 'Recepcionista',
    fechaRegistro: '2025-05-20',
    estatus: 'Activo',
  },
  {
    id: 4,
    nombre: 'Comercializadora del Norte (Acceso Cliente)',
    email: 'contacto@ejemplo.com',
    empresaDca: 'Cliente Externo',
    rol: 'Cliente',
    fechaRegistro: '2026-02-01',
    estatus: 'Activo',
  },
  {
    id: 5,
    nombre: 'C.P. Miguel Ángel Torres',
    email: 'mtorres@ejemplo.com',
    empresaDca: 'DCA Soluciones de Nómina S.C.',
    rol: 'Contador',
    fechaRegistro: '2025-08-12',
    estatus: 'Inactivo',
  },
])

const filteredRows = computed(() => {
  const q = filter.value.toLowerCase().trim()
  return rows.value.filter((r) => {
    const coincideRol = filtroRol.value === 'Todos los Roles' || r.rol === filtroRol.value
    const coincideTexto =
      !q ||
      r.nombre.toLowerCase().includes(q) ||
      r.email.toLowerCase().includes(q) ||
      r.rol.toLowerCase().includes(q)
    return coincideRol && coincideTexto
  })
})

const getRolColor = (rol) => {
  const map = {
    Administrador: 'purple-8',
    Contador: 'teal-8',
    Recepcionista: 'deep-purple',
    Cliente: 'orange-9',
  }
  return map[rol] || 'grey-7'
}

const nuevoUsuario = () => {
  $q.notify({
    type: 'info',
    message: 'Formulario para registrar nuevo usuario.',
    position: 'top-right',
  })
}

const cargarUsuarios = () => {
  $q.notify({
    type: 'positive',
    message: 'Lista de usuarios actualizada.',
    position: 'top-right',
  })
}

const editarUsuario = (usuario) => {
  $q.notify({
    type: 'info',
    message: `Editando datos de ${usuario.nombre}`,
    position: 'top-right',
  })
}

const resetPassword = (usuario) => {
  $q.notify({
    type: 'warning',
    message: `Enviando correo de restablecimiento de contraseña a ${usuario.email}`,
    position: 'top-right',
  })
}

const toggleEstatus = (usuario) => {
  usuario.estatus = usuario.estatus === 'Activo' ? 'Inactivo' : 'Activo'
  $q.notify({
    type: 'positive',
    message: `Estatus de ${usuario.nombre} cambiado a ${usuario.estatus}`,
    position: 'top-right',
  })
}
</script>
