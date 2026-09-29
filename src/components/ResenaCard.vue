<script setup lang="ts">
import { computed } from 'vue';
import type { Resena } from '../lib/types';

// En el index se renderiza en el servidor (HTML puro);
// en el admin se usa dentro de AdminPanel, que corre en el navegador
const { resena } = defineProps<{ resena: Resena }>();

// computed: si la reseña cambia (al editar en el admin), la tarjeta se actualiza
const calificacion = computed(() => (resena.calificacion ?? 0).toFixed(1));
// El género ahora va como etiqueta sobre el póster, por eso sale de aquí
const meta = computed(() => [resena.director, resena.anio].filter(Boolean).join(' · '));
</script>

<template>
  <li class="flex flex-col overflow-hidden rounded-2xl border border-zinc-800 bg-zinc-950">
    <!-- Póster con altura fija: todas las tarjetas miden igual sin importar el tamaño de la imagen -->
    <div class="relative h-72 w-full shrink-0 overflow-hidden bg-slate-800/60">
      <!-- absolute: la imagen no empuja la altura del contenedor, solo lo rellena y se recorta -->
      <img
        v-if="resena.poster_url"
        :src="resena.poster_url"
        :alt="`Póster de ${resena.titulo}`"
        loading="lazy"
        class="absolute inset-0 h-full w-full object-cover object-top"
      />
      <!-- Si no hay póster, se muestra un marcador -->
      <div v-else class="flex h-full flex-col items-center justify-center gap-3 text-slate-400">
        <svg class="h-10 w-10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" aria-hidden="true">
          <rect x="5" y="3" width="14" height="18" rx="2" />
          <circle cx="12" cy="9" r="2" />
          <path d="M5 18l4-4 3 3 2-2 5 5" />
        </svg>
        <span class="text-xs uppercase tracking-widest">Sin póster</span>
      </div>

      <span
        v-if="resena.genero"
        class="absolute left-3 top-3 rounded-full bg-zinc-950/90 px-3 py-1 text-xs font-medium text-zinc-100"
      >
        {{ resena.genero }}
      </span>
    </div>

    <!-- Información con altura fija (más alta en el admin para que quepan los botones) -->
    <div class="flex flex-col gap-1 overflow-hidden p-5" :class="$slots.default ? 'h-52' : 'h-44'">
      <div class="flex items-start justify-between gap-3">
        <!-- truncate / line-clamp: el texto largo se corta con "…" en vez de estirar la tarjeta -->
        <h2 class="min-w-0 truncate text-xl font-bold text-zinc-50" :title="resena.titulo">{{ resena.titulo }}</h2>
        <span
          class="shrink-0 rounded-full bg-amber-400 px-2.5 py-0.5 text-sm font-semibold text-zinc-950"
          :aria-label="`Calificación ${calificacion} de 5`"
        >
          ★ {{ calificacion }}
        </span>
      </div>
      <p v-if="meta" class="truncate text-sm text-zinc-400">{{ meta }}</p>
      <p v-if="resena.resena" class="mt-1 line-clamp-2 text-zinc-300">{{ resena.resena }}</p>

      <!-- Espacio opcional para botones (lo usa el admin) -->
      <div v-if="$slots.default" class="mt-auto flex gap-2 pt-3">
        <slot />
      </div>
    </div>
  </li>
</template>
