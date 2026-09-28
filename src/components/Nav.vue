<script setup lang="ts">
// Solo dibuja el menú. El comportamiento de "Cerrar sesión" lo agrega
// el <script> de Layout.astro buscando el id="nav-auth"
const links = [
  { href: '/', texto: 'Inicio' },
  { href: '/acerca-de', texto: 'Acerca de' },
  { href: '/admin', texto: 'Mis reseñas' },
];
</script>

<template>
  <header class="border-b border-zinc-800">
    <nav class="mx-auto flex max-w-5xl items-center gap-6 px-4 py-4">
      <a href="/" class="text-lg font-bold text-amber-400">🎬 CineReseñas</a>
      <a v-for="link in links" :key="link.href" :href="link.href" class="hover:text-amber-400">
        {{ link.texto }}
      </a>
      <a id="nav-auth" href="/login" class="ml-auto hover:text-amber-400">Iniciar sesión</a>
    </nav>
  </header>
</template>
