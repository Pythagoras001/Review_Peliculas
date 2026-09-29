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
  <!-- Encabezado centrado -->
  <header class="mb-8 text-center">
    <h1 class="text-4xl font-bold sm:text-5xl">Reseñas de películas</h1>
    <p class="mt-3 text-zinc-400">Busca una película y descubre qué opina la comunidad.</p>
  </header>

  <!-- Formulario HTML normal: al enviar, el navegador va a /?q=... y el servidor responde.
       Es una sola "barra": el ícono, el input y el botón van dentro del mismo contenedor -->
  <form
    method="GET"
    action="/"
    role="search"
    class="mx-auto mb-8 flex max-w-3xl items-center gap-2 rounded-xl border border-zinc-800 bg-zinc-900 p-1.5 pl-4 focus-within:border-amber-500"
  >
    <svg class="h-4 w-4 shrink-0 text-zinc-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
      <circle cx="11" cy="11" r="7" />
      <path d="M20 20l-3.5-3.5" />
    </svg>
    <input
      type="search"
      name="q"
      :value="q"
      placeholder="Buscar por título..."
      aria-label="Buscar reseñas por título"
      class="min-w-0 flex-1 bg-transparent py-2 placeholder:text-zinc-500 focus:outline-none"
    />
    <button class="rounded-lg bg-amber-500 px-4 py-2 font-semibold text-zinc-950 hover:bg-amber-400">
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
