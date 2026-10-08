<template>
  <q-layout view="lHh Lpr lFf">
    <q-header elevated class="bg-navbar text-white">
      <q-toolbar class="bg-navbar">
        <q-btn flat dense round icon="menu" aria-label="Menu" @click="toggleLeftDrawer">
          <q-tooltip>Mostrar / Ocultar menú lateral</q-tooltip>
        </q-btn>
        <q-toolbar-title class="row items-center">
          <q-img src="/logo.jpg" width="50px" height="50px" class="rounded-borders" />
          <div class="q-ml-md">
            <div class="text-weight-bold" style="font-size: 1.1rem; line-height: 1.2">
              Grupo DCA
            </div>
            <div class="text-caption text-blue-2" style="font-size: 0.75rem">
              Recepción y Control Documental
            </div>
          </div>
        </q-toolbar-title>
      </q-toolbar>
    </q-header>

    <q-drawer v-model="leftDrawerOpen" show-if-above bordered class="bg-grey-1">
      <q-list padding class="text-grey-9">
        <q-item-label header class="text-weight-bold text-uppercase text-grey-7">
          Menú Principal
        </q-item-label>

        <q-item clickable v-ripple to="/" active-class="text-primary text-weight-bold bg-blue-1">
          <q-item-section avatar><q-icon name="cloud_upload" color="primary" /></q-item-section>
          <q-item-section>Recepción de Docs</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Formulario de registro y firmas de entrega</q-tooltip
          >
        </q-item>

        <q-item
          clickable
          v-ripple
          to="/dashboard"
          active-class="text-primary text-weight-bold bg-blue-1"
        >
          <q-item-section avatar><q-icon name="dashboard" color="primary" /></q-item-section>
          <q-item-section>Dashboard de Control</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Tablero principal con semaforización de estados</q-tooltip
          >
        </q-item>

        <q-item
          clickable
          v-ripple
          to="/clientes"
          active-class="text-primary text-weight-bold bg-blue-1"
        >
          <q-item-section avatar><q-icon name="groups" color="primary" /></q-item-section>
          <q-item-section>Clientes y Semáforo</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Directorio de clientes y estatus de expediente</q-tooltip
          >
        </q-item>

        <q-item
          clickable
          v-ripple
          to="/seguimiento"
          active-class="text-primary text-weight-bold bg-blue-1"
        >
          <q-item-section avatar><q-icon name="track_changes" color="primary" /></q-item-section>
          <q-item-section>Seguimiento de Docs</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Portal de consulta de avance por folio o RFC</q-tooltip
          >
        </q-item>

        <q-item
          clickable
          v-ripple
          to="/usuarios"
          active-class="text-primary text-weight-bold bg-blue-1"
        >
          <q-item-section avatar><q-icon name="manage_accounts" color="primary" /></q-item-section>
          <q-item-section>Usuarios del Sistema</q-item-section>
          <q-tooltip anchor="center right" self="center left"
            >Gestión de usuarios, roles y permisos</q-tooltip
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
const leftDrawerOpen = ref(false)

function toggleLeftDrawer() {
  leftDrawerOpen.value = !leftDrawerOpen.value
}
</script>
