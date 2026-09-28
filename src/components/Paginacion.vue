<script setup lang="ts">
// Se renderiza en el servidor: los enlaces son <a> normales, sin JavaScript
const { page, totalPaginas, q } = defineProps<{
  page: number;
  totalPaginas: number;
  q: string;
}>();

// Arma el link a una página conservando la búsqueda
function urlPagina(p: number) {
  const params = new URLSearchParams();
  if (q) params.set('q', q);
  if (p > 1) params.set('page', String(p));
  const qs = params.toString();
  return qs ? `/?${qs}` : '/';
}

const activo = 'rounded border border-zinc-700 px-4 py-2 hover:border-amber-400';
const inactivo = 'rounded border border-zinc-800 px-4 py-2 text-zinc-600';
</script>

<template>
  <nav v-if="totalPaginas > 1" class="mt-8 flex items-center justify-center gap-4">
    <a v-if="page > 1" :href="urlPagina(page - 1)" :class="activo">← Anterior</a>
    <span v-else :class="inactivo">← Anterior</span>

    <span class="text-sm text-zinc-400">Página {{ page }} de {{ totalPaginas }}</span>

    <a v-if="page < totalPaginas" :href="urlPagina(page + 1)" :class="activo">Siguiente →</a>
    <span v-else :class="inactivo">Siguiente →</span>
  </nav>
</template>
