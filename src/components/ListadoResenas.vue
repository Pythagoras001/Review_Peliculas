<script setup lang="ts">
import type { Resena } from '../lib/types';
import ResenaCard from './ResenaCard.vue';
import Paginacion from './Paginacion.vue';

// Sin client:*: se renderiza en el servidor en cada request (SSR) y llega como HTML puro.
// Los datos los consulta index.astro y llegan aquí como props.
const { resenas, q, page, totalPaginas, total, error } = defineProps<{
  resenas: Resena[];
  q: string;
  page: number;
  totalPaginas: number;
  total: number;
  error?: string;
}>();
</script>

<template>
  <h1 class="mb-6 text-3xl font-bold">Reseñas de películas</h1>

  <!-- Formulario HTML normal: al enviar, el navegador va a /?q=... y el servidor responde -->
  <form method="GET" action="/" class="mb-6 flex gap-2">
    <input
      type="search"
      name="q"
      :value="q"
      placeholder="Buscar por título..."
      class="flex-1 rounded border border-zinc-700 bg-zinc-900 px-3 py-2"
    />
    <button class="rounded bg-amber-500 px-4 py-2 font-semibold text-zinc-950 hover:bg-amber-400">
      Buscar
    </button>
  </form>

  <p v-if="q" class="mb-4 text-sm text-zinc-400">
    {{ total }} resultado(s) para "{{ q }}" · <a href="/" class="text-amber-400 underline">Limpiar</a>
  </p>

  <p v-if="error" class="rounded bg-red-900/50 p-4 text-red-200">
    Error al cargar las reseñas: {{ error }}
  </p>

  <p v-else-if="resenas.length === 0" class="text-zinc-400">
    {{ q ? 'No se encontraron reseñas con ese título.' : 'No hay reseñas todavía.' }}
  </p>

  <ul class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
    <ResenaCard v-for="r in resenas" :key="r.id" :resena="r" />
  </ul>

  <Paginacion :page="page" :total-paginas="totalPaginas" :q="q" />
</template>
