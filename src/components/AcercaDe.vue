<script setup lang="ts">
// Sin client:*: se renderiza una sola vez en el build y llega como HTML puro
const tarjetas = [
  { titulo: 'Listado (SSR)', texto: 'Se genera en el servidor en cada visita, con búsqueda y paginación.' },
  { titulo: 'Páginas estáticas (SSG)', texto: 'Acerca de, login, registro y administración se pre-renderizan en el build.' },
  { titulo: 'Supabase', texto: 'Base de datos, autenticación y seguridad con políticas RLS.' },
  { titulo: 'Cloudflare Workers', texto: 'Hospeda el sitio y ejecuta las páginas SSR.' },
];

const equipo = ['Nombre integrante 1', 'Nombre integrante 2'];
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
    <h2 class="mb-3 text-xl font-semibold text-amber-400">¿Cómo está construido?</h2>
    <ul class="grid gap-3 sm:grid-cols-2">
      <li v-for="t in tarjetas" :key="t.titulo" class="rounded-lg border border-zinc-800 bg-zinc-900 p-4">
        <strong>{{ t.titulo }}</strong>
        <p class="text-sm text-zinc-400">{{ t.texto }}</p>
      </li>
    </ul>
  </section>

  <section>
    <h2 class="mb-3 text-xl font-semibold text-amber-400">Equipo</h2>
    <ul class="list-inside list-disc text-zinc-300">
      <li v-for="nombre in equipo" :key="nombre">{{ nombre }}</li>
    </ul>
  </section>
</template>
