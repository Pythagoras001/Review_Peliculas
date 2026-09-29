<script setup lang="ts">
// Solo dibuja el menú. El comportamiento de "Cerrar sesión" lo agrega
// el <script> de Layout.astro buscando el id="nav-auth"
import { computed } from 'vue';

// Ruta actual (Layout.astro le pasa Astro.url.pathname) para marcar el link activo
const { actual = '/' } = defineProps<{ actual?: string }>();

const links = [
  { href: '/', texto: 'Inicio' },
  { href: '/acerca-de', texto: 'Acerca de' },
  { href: '/admin', texto: 'Mis reseñas' },
];

// Inicio solo está activo en "/"; los demás también en sus subrutas (ej. /admin/algo)
const conEstado = computed(() =>
  links.map((link) => ({
    ...link,
    activo: link.href === '/' ? actual === '/' : actual.startsWith(link.href),
  })),
);
</script>

<template>
  <header class="border-b border-zinc-800 bg-zinc-950">
    <nav class="mx-auto flex h-16 max-w-5xl items-stretch gap-8 px-4">
      <a href="/" class="flex items-center gap-2 text-lg font-bold text-amber-400">
        <!-- Ícono de claqueta -->
        <svg class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
          <rect x="3" y="4" width="18" height="16" rx="2" />
          <path d="M3 9h18M8 4l-2 5M13 4l-2 5M18 4l-2 5" />
        </svg>
        CineReseñas
      </a>

      <!-- items-stretch + h-full: cada link ocupa todo el alto, así la línea queda pegada al borde inferior -->
      <ul class="flex items-stretch gap-6">
        <li v-for="link in conEstado" :key="link.href" class="flex">
          <a
            :href="link.href"
            :aria-current="link.activo ? 'page' : undefined"
            class="flex items-center border-b-2 pt-0.5 transition-colors"
            :class="link.activo
              ? 'border-amber-400 font-semibold text-zinc-50'
              : 'border-transparent text-zinc-400 hover:text-zinc-100'"
          >
            {{ link.texto }}
          </a>
        </li>
      </ul>

      <!-- Botón de sesión: Layout.astro cambia el texto a "Cerrar sesión" si hay sesión -->
      <div class="ml-auto flex items-center">
        <a
          id="nav-auth"
          href="/login"
          class="rounded-lg bg-amber-500 px-4 py-2 text-sm font-semibold text-zinc-950 hover:bg-amber-400"
        >
          Iniciar sesión
        </a>
      </div>
    </nav>
  </header>
</template>
