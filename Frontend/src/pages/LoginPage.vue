<template>
  <q-layout class="bg-grey-2">
    <q-page-container>
      <q-page class="flex flex-center q-pa-md">
        <!-- Columna informativa (escritorio) -->
        <div class="row items-center justify-center full-width">
          <div class="col-12 col-sm-8 col-md-5">
            <!-- Tarjeta de Ingreso -->
            <q-card flat class="shadow-3 rounded-borders bg-white">
              <q-card-section class="text-center q-pb-none">
                <q-img
                  src="/logo-alternativo.jpg"
                  width="200px"
                  height="200px"
                  class="rounded-borders"
                />
                <div class="text-h5 text-weight-bold text-primary q-mt-md">Ingreso al Sistema</div>
                <div class="text-subtitle2 text-grey-7">
                  Grupo DCA — Recepción y Control Documental
                </div>
              </q-card-section>

              <q-card-section>
                <q-form @submit="onSubmit" class="q-gutter-y-md">
                  <q-input
                    v-model="form.correo"
                    label="Correo electrónico *"
                    outlined
                    dense
                    type="email"
                    autocomplete="email"
                    :rules="[(val) => !!val || 'Ingrese su correo electrónico', esCorreoValido]"
                  >
                    <template #prepend>
                      <q-icon name="mail" color="primary" />
                    </template>
                  </q-input>

                  <q-input
                    v-model="form.contrasena"
                    label="Contraseña *"
                    outlined
                    dense
                    :type="mostrarContrasena ? 'text' : 'password'"
                    autocomplete="current-password"
                    :rules="[
                      (val) => !!val || 'Ingrese su contraseña',
                      (val) =>
                        (val || '').length >= 6 || 'La contraseña debe tener al menos 6 caracteres',
                    ]"
                  >
                    <template #prepend>
                      <q-icon name="lock" color="primary" />
                    </template>
                    <template #append>
                      <q-btn
                        flat
                        dense
                        round
                        size="sm"
                        :icon="mostrarContrasena ? 'visibility_off' : 'visibility'"
                        @click="mostrarContrasena = !mostrarContrasena"
                      >
                        <q-tooltip>
                          {{ mostrarContrasena ? 'Ocultar contraseña' : 'Mostrar contraseña' }}
                        </q-tooltip>
                      </q-btn>
                    </template>
                  </q-input>

                  <q-select
                    v-model="form.rol"
                    :options="opcionesRoles"
                    label="Perfil de acceso *"
                    outlined
                    dense
                    options-dense
                    :rules="[(val) => !!val || 'Seleccione el perfil con el que ingressa']"
                  >
                    <template #prepend>
                      <q-icon name="badge" color="primary" />
                    </template>
                    <template #hint>
                      Determina a qué módulo del sistema tendrá acceso al ingresar
                    </template>
                  </q-select>

                  <div class="row items-center justify-between">
                    <q-toggle v-model="form.recordarSesion" label="Recordar mi acceso" dense />
                    <q-btn
                      flat
                      dense
                      no-caps
                      label="¿Olvidaste tu contraseña?"
                      @click="recuperarContrasena"
                    >
                      <q-tooltip>Enviar un enlace de restablecimiento a su correo</q-tooltip>
                    </q-btn>
                  </div>

                  <q-banner dense rounded class="bg-blue-1 text-primary">
                    <template #avatar>
                      <q-icon name="info" />
                    </template>
                    Maquetación: cualquier correo válido y contraseña de 6 caracteres permiten el
                    ingreso.
                  </q-banner>

                  <q-btn
                    type="submit"
                    label="Iniciar Sesión"
                    color="primary"
                    class="full-width"
                    size="lg"
                    unelevated
                    :loading="cargando"
                  >
                    <q-tooltip>Entrar al sistema con el perfil seleccionado</q-tooltip>
                  </q-btn>
                </q-form>
              </q-card-section>

              <q-separator />

              <q-card-actions align="center">
                <q-btn flat dense no-caps color="grey-7" label="Volver al inicio" to="/" />
              </q-card-actions>
            </q-card>
          </div>
        </div>
      </q-page>
    </q-page-container>
  </q-layout>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useQuasar } from 'quasar'
import { useRouter } from 'vue-router'

const $q = useQuasar()
const router = useRouter()

const mostrarContrasena = ref(false)
const cargando = ref(false)

// Catálogo de roles tomado de la tabla `roles` en Backend/schema.sql
const opcionesRoles = ['Administrador', 'Contador', 'Recepcionista', 'Cliente']

// Vista inicial según el perfil (simula los permisos de cada rol)
const inicioPorRol = {
  Administrador: '/dashboard',
  Contador: '/direccionamiento',
  Recepcionista: '/',
  Cliente: '/seguimiento',
}

const form = reactive({
  correo: '',
  contrasena: '',
  rol: null,
  recordarSesion: false,
})

// Validador de formato de correo (mensaje en español)
const esCorreoValido = (val) => {
  if (!val) return true
  const formato = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  return formato.test(val) || 'Ingrese un correo electrónico válido'
}

const onSubmit = () => {
  cargando.value = true

  // Simula la latencia de una petición al backend
  setTimeout(() => {
    cargando.value = false

    const destino = inicioPorRol[form.rol] || '/'
    $q.notify({
      type: 'positive',
      message: `Sesión iniciada como ${form.rol}.`,
      position: 'top-right',
    })
    router.push(destino)
  }, 700)
}

const recuperarContrasena = () => {
  if (!form.correo) {
    $q.notify({
      type: 'warning',
      message: 'Ingrese su correo electrónico para restablecer la contraseña.',
      position: 'top-right',
    })
    return
  }
  $q.notify({
    type: 'info',
    message: `Enviando enlace de restablecimiento a ${form.correo}`,
    position: 'top-right',
  })
}
</script>
