<script setup lang="ts">
// Sin client:*: se renderiza una sola vez en el build y llega como HTML puro
const tarjetas = [
  { titulo: 'Supabase', texto: 'Base de datos, autenticación y seguridad con políticas RLS.' },
  { titulo: 'Cloudflare Workers', texto: 'Hospeda el sitio y ejecuta las páginas SSR.' },
];

// Cómo se genera cada vista. Sale de "export const prerender" en cada archivo de src/pages:
// prerender = false -> SSR (en cada visita) · prerender = true -> SSG (una vez, en el build)
const vistas = [
  {
    ruta: '/',
    nombre: 'Inicio (listado de reseñas)',
    modo: 'SSR',
    detalle:
      'prerender = false. En cada visita el servidor consulta Supabase con la búsqueda (?q) y la página (?page) de la URL, y Vue renderiza el listado en el servidor. Llega como HTML puro, sin JavaScript de Vue.',
  },
  {
    ruta: '/acerca-de',
    nombre: 'Acerca de',
    modo: 'SSG',
    detalle: 'prerender = true. El contenido no cambia, así que se genera una sola vez en el build.',
  },
  {
    ruta: '/login',
    nombre: 'Iniciar sesión',
    modo: 'SSG',
    detalle:
      'prerender = true. La página es estática; el formulario es una isla de Vue (client:only) que habla con Supabase Auth desde el navegador.',
  },
  {
    ruta: '/registro',
    nombre: 'Registro',
    modo: 'SSG',
    detalle: 'prerender = true. Igual que login: página estática con una isla de Vue (client:only).',
  },
  {
    ruta: '/admin',
    nombre: 'Mis reseñas (administración)',
    modo: 'SSG',
    detalle:
      'prerender = true. La página es estática; el panel es una isla de Vue (client:only) que revisa la sesión y hace el CRUD contra Supabase desde el navegador.',
  },
] as const;

const equipo = ['Thomas Gomez'];
</script>

<template>
  <h1 class="mb-6 text-3xl font-bold">Acerca de CineReseñas</h1>

  <section class="mb-8 space-y-3 text-zinc-300">
    <p>
      CineReseñas es una plataforma para compartir opiniones sobre películas.
      Cualquier persona puede explorar y buscar reseñas, y los usuarios registrados
      pueden publicar, editar y eliminar las suyas.
    </p>
  </section>

  <section class="mb-8">
    <h2 class="mb-1 text-xl font-semibold text-amber-400">Vistas: SSR y SSG</h2>
    <p class="mb-4 text-sm text-zinc-400">
      <strong class="text-zinc-200">SSR</strong>: se genera en el servidor en cada visita.
      <strong class="text-zinc-200">SSG</strong>: se genera una sola vez al hacer el build.
    </p>
    <!-- Grid: 1 columna en celular, 2 en tablet, 3 en escritorio -->
    <ul class="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
      <li
        v-for="v in vistas"
        :key="v.ruta"
        class="flex flex-col gap-2 rounded-lg border border-zinc-800 bg-zinc-900 p-4"
      >
        <div class="flex items-center justify-between gap-2">
          <code class="text-sm text-zinc-500">{{ v.ruta }}</code>
          <span
            class="rounded-full px-2.5 py-0.5 text-xs font-semibold"
            :class="v.modo === 'SSR' ? 'bg-amber-400 text-zinc-950' : 'bg-zinc-700 text-zinc-100'"
          >
            {{ v.modo }}
          </span>
        </div>
        <strong>{{ v.nombre }}</strong>
        <p class="text-sm text-zinc-400">{{ v.detalle }}</p>
      </li>
    </ul>
  </section>

  <section class="mb-8">
    <h2 class="mb-3 text-xl font-semibold text-amber-400">Servicios</h2>
    <ul class="grid gap-3 sm:grid-cols-2">
      <li v-for="t in tarjetas" :key="t.titulo" class="rounded-lg border border-zinc-800 bg-zinc-900 p-4">
        <strong>{{ t.titulo }}</strong>
        <p class="text-sm text-zinc-400">{{ t.texto }}</p>
      </li>
    </ul>
  </section>

  <section>
    <h2 class="mb-3 text-xl font-semibold text-amber-400">Integrante</h2>
    <ul class="list-inside list-disc text-zinc-300">
      <li v-for="nombre in equipo" :key="nombre">{{ nombre }}</li>
    </ul>
  </section>
</template>
