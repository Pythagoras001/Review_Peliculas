<script setup lang="ts">
import { computed } from 'vue';
import type { Resena } from '../lib/types';

// Tarjeta horizontal para las reseñas del usuario.
// La tabla de reseñas solo guarda user_id, así que el autor (su correo o nombre) llega como prop
const { resena, autor = '' } = defineProps<{ resena: Resena; autor?: string }>();

const puntos = computed(() => resena.calificacion ?? 0);
const calificacion = computed(() => puntos.value.toFixed(1));
const estrellas = computed(() => '★'.repeat(puntos.value) + '☆'.repeat(5 - puntos.value));
const meta = computed(() => [resena.director, resena.anio, resena.genero].filter(Boolean).join(' · '));

</script>

<template>
  <li class="flex gap-4 rounded-2xl border border-zinc-800 bg-zinc-900 p-4">
    <!-- Póster 2:3 a la izquierda (ancho fijo para que quepa en columnas angostas) -->
    <div class="relative aspect-[2/3] w-24 shrink-0 self-start overflow-hidden rounded-lg bg-stone-800/70">
      <img
        v-if="resena.poster_url"
        :src="resena.poster_url"
        :alt="`Póster de ${resena.titulo}`"
        loading="lazy"
        class="absolute inset-0 h-full w-full object-cover"
      />
      <div v-else class="flex h-full flex-col items-center justify-center gap-2 text-stone-400">
        <svg class="h-6 w-6" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true">
          <rect x="5" y="3" width="14" height="18" rx="2" />
          <circle cx="12" cy="9" r="2" />
          <path d="M5 18l4-4 3 3 2-2 5 5" />
        </svg>
        <span class="text-center text-[10px] uppercase tracking-wider">Sin póster</span>
      </div>
    </div>

    <!-- Información -->
    <div class="flex min-w-0 flex-1 flex-col gap-1">
      <div class="flex items-start justify-between gap-2">
        <h2 class="min-w-0 truncate text-lg font-bold text-zinc-50" :title="resena.titulo">{{ resena.titulo }}</h2>
        <span
          class="shrink-0 rounded-full bg-amber-400 px-2.5 py-0.5 text-sm font-semibold text-zinc-950"
          :aria-label="`Calificación ${calificacion} de 5`"
        >
          ★ {{ calificacion }}
        </span>
      </div>

      <p v-if="meta" class="truncate text-sm text-zinc-400" :title="meta">{{ meta }}</p>
      <p class="text-sm tracking-widest text-amber-400" aria-hidden="true">{{ estrellas }}</p>
      <p v-if="resena.resena" class="line-clamp-3 text-sm text-zinc-200">{{ resena.resena }}</p>

      <!-- mt-auto empuja el pie al fondo; flex-wrap baja los botones si no caben al lado -->
      <div class="mt-auto flex flex-wrap items-center justify-between gap-2 pt-3">
     

        <!-- Espacio opcional para botones (Editar / Eliminar) -->
        <div v-if="$slots.default" class="flex gap-2">
          <slot />
        </div>
      </div>
    </div>
  </li>
</template>
