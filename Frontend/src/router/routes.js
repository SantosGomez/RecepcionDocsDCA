const routes = [
  {
    path: '/',
    component: () => import('@/layouts/MainLayout.vue'),
    children: [
      { path: '', component: () => import('@/pages/IndexPage.vue') },
      { path: 'dashboard', component: () => import('@/pages/DashboardPage.vue') },
      { path: 'clientes', component: () => import('@/pages/ClientesPage.vue') },
      { path: 'seguimiento', component: () => import('@/pages/SeguimientoPage.vue') },
      { path: 'usuarios', component: () => import('@/pages/UsersPage.vue') },
    ],
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: '/:catchAll(.*)*',
    component: () => import('@/pages/ErrorNotFound.vue'),
  },
]

export default routes
