<script setup lang="ts">
import type { Resena } from '../lib/types';

// Se renderiza en el servidor: llega al navegador como HTML puro
const { resena } = defineProps<{ resena: Resena }>();

const calificacion = resena.calificacion ?? 0;
const estrellas = '★'.repeat(calificacion) + '☆'.repeat(5 - calificacion);
</script>

<template>
  <li class="rounded-lg border border-zinc-800 bg-zinc-900 p-4">
    <h2 class="text-lg font-semibold">{{ resena.titulo }}</h2>
    <p class="text-sm text-zinc-400">
      {{ resena.director }} · {{ resena.anio }} · {{ resena.genero }}
    </p>
    <p class="my-2 text-amber-400" :aria-label="`${calificacion} de 5`">
      {{ estrellas }}
    </p>
    <p class="text-sm text-zinc-300">{{ resena.resena }}</p>
  </li>
</template>
