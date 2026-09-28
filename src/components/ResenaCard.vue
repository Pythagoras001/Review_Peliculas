<script setup lang="ts">
import { computed } from 'vue';
import type { Resena } from '../lib/types';

// En el index se renderiza en el servidor (HTML puro);
// en el admin se usa dentro de AdminPanel, que corre en el navegador
const { resena } = defineProps<{ resena: Resena }>();

// computed: si la reseña cambia (al editar en el admin), las estrellas se actualizan
const calificacion = computed(() => resena.calificacion ?? 0);
const estrellas = computed(() => '★'.repeat(calificacion.value) + '☆'.repeat(5 - calificacion.value));
const meta = computed(() => [resena.director, resena.anio, resena.genero].filter(Boolean).join(' · '));
</script>

<template>
  <li class="rounded-lg border border-zinc-800 bg-zinc-900 p-4">
    <img
      v-if="resena.poster_url"
      :src="resena.poster_url"
      :alt="`Póster de ${resena.titulo}`"
      loading="lazy"
      class="mb-3 aspect-[2/3] w-full rounded object-cover"
    />
    <h2 class="text-lg font-semibold">{{ resena.titulo }}</h2>
    <p class="text-sm text-zinc-400">{{ meta }}</p>
    <p class="my-2 text-amber-400" :aria-label="`${calificacion} de 5`">
      {{ estrellas }}
    </p>
    <p class="text-sm text-zinc-300">{{ resena.resena }}</p>

    <!-- Espacio opcional para botones (lo usa el admin) -->
    <div v-if="$slots.default" class="mt-3 flex gap-2">
      <slot />
    </div>
  </li>
</template>
