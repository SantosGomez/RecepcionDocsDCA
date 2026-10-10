<template>
  <q-layout view="lHh Lpr lFf">
    <!-- El header solo existe en movil: en escritorio el drawer carga la marca -->
    <q-header v-if="$q.screen.lt.md" elevated class="bg-primary text-white">
      <q-toolbar>
        <q-btn
          flat
          dense
          round
          :icon="leftDrawerOpen ? 'menu_open' : 'menu'"
          aria-label="Menú lateral"
          @click="toggleDrawer"
        >
          <q-tooltip>{{ leftDrawerOpen ? 'Cerrar menú lateral' : 'Abrir menú lateral' }}</q-tooltip>
        </q-btn>
        <q-toolbar-title class="row items-center">
          <q-img src="/logos/PNG/DELGROW_ISOTIPO-OF_T.png" class="toolbar-logo" />
        </q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-drawer
      v-model="leftDrawerOpen"
      show-if-above
      bordered
      :mini="isMini"
      :width="250"
      :mini-width="68"
      class="bg-primary text-white"
    >
      <q-list padding class="text-white">
        <!-- El logo expande o colapsa el menú en escritorio y tablet -->
        <q-item
          clickable
          v-ripple
          class="gt-sm q-pb-md"
          :aria-label="isMini ? 'Expandir menú lateral' : 'Colapsar menú lateral'"
          @click="toggleMini"
        >
          <q-item-section avatar>
            <q-img src="/logos/PNG/DELGROW_ISOTIPO-OF_T.png" class="toolbar-logo" />
          </q-item-section>
          <q-item-section v-if="!isMini">
            <q-item-label class="text-weight-bold">Grupo DelGrow S.C.</q-item-label>
            <q-item-label caption class="text-secondary">
              Recepción y Control Documental
            </q-item-label>
          </q-item-section>
          <q-tooltip anchor="center right" self="center left">
            {{ isMini ? 'Expandir menú' : 'Colapsar menú' }}
          </q-tooltip>
        </q-item>

        <q-separator v-if="!isMini" dark class="q-mb-sm" />

        <q-item-label header class="text-weight-bold text-uppercase text-secondary" v-if="!isMini">
          Menú Principal
        </q-item-label>

        <q-item
          clickable
          v-ripple
          to="/"
          exact
          active-class="bg-secondary text-primary text-weight-bold"
          class="text-white"
        >
          <q-item-section avatar><q-icon name="cloud_upload" /></q-item-section>
          <q-item-section>Recepción de Docs</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Formulario de registro y firmas de entrega</q-tooltip
          >
        </q-item>

        <q-item
          clickable
          v-ripple
          to="/dashboard"
          exact
          active-class="bg-secondary text-primary text-weight-bold"
          class="text-white"
        >
          <q-item-section avatar><q-icon name="dashboard" /></q-item-section>
          <q-item-section>Dashboard de Control</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Tablero principal con semaforización de estados</q-tooltip
          >
        </q-item>

        <q-separator v-if="!isMini" dark class="q-my-xs" />
        <q-item
          clickable
          v-ripple
          to="/clientes"
          exact
          active-class="bg-secondary text-primary text-weight-bold"
          class="text-white"
        >
          <q-item-section avatar><q-icon name="groups" /></q-item-section>
          <q-item-section>Clientes y Semáforo</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Directorio de clientes y estatus de expediente</q-tooltip
          >
        </q-item>

        <q-item
          clickable
          v-ripple
          to="/direccionamiento"
          exact
          active-class="bg-secondary text-primary text-weight-bold"
          class="text-white"
        >
          <q-item-section avatar><q-icon name="assignment_return" /></q-item-section>
          <q-item-section>Direccionamiento</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Entrega formal y firma de recepción del contador asignado</q-tooltip
          >
        </q-item>

        <q-separator v-if="!isMini" dark class="q-my-xs" />
        <q-item
          clickable
          v-ripple
          to="/seguimiento"
          exact
          active-class="bg-secondary text-primary text-weight-bold"
          class="text-white"
        >
          <q-item-section avatar><q-icon name="track_changes" /></q-item-section>
          <q-item-section>Seguimiento de Docs</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Portal de consulta de avance por folio o RFC</q-tooltip
          >
        </q-item>

        <q-item
          clickable
          v-ripple
          to="/usuarios"
          exact
          active-class="bg-secondary text-primary text-weight-bold"
          class="text-white"
        >
          <q-item-section avatar><q-icon name="manage_accounts" /></q-item-section>
          <q-item-section>Usuarios del Sistema</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Gestión de usuarios, roles y permisos</q-tooltip
          >
        </q-item>

        <q-separator v-if="!isMini" dark class="q-my-xs" />
        <q-item clickable v-ripple to="/login" class="text-white">
          <q-item-section avatar><q-icon name="logout" /></q-item-section>
          <q-item-section>Cerrar Sesión</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Finalizar la sesión actual y volver a la pantalla de ingreso</q-tooltip
          >
        </q-item>
      </q-list>
    </q-drawer>

    <q-page-container>
      <router-view />
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref } from 'vue'
import { useQuasar } from 'quasar'

const $q = useQuasar()

// Estado del menú lateral y de su modo colapsado (mini)
const leftDrawerOpen = ref(true)
const isMini = ref(false)

// El botón del header solo abre o cierra el menú (necesario en móvil)
const toggleDrawer = () => {
  leftDrawerOpen.value = !leftDrawerOpen.value
}

// El logo del drawer solo alterna el modo mini (escritorio y tablet)
const toggleMini = () => {
  isMini.value = !isMini.value
}
</script>

<style scoped>
/* El isotipo se mantiene visible en todas las pantallas, pero mas pequeno en movil */
.toolbar-logo {
  width: 40px;
  height: 40px;
}
@media (max-width: 599px) {
  .toolbar-logo {
    width: 32px;
    height: 32px;
  }
}
</style>
