<script setup lang="ts">
// Isla de Vue: se usa con client:only="vue", así que todo esto corre en el navegador
import { onMounted, reactive, ref } from 'vue';
import { navigate } from 'astro:transitions/client';
import { supabase } from '../lib/supabase';
import type { Resena, ResenaInput } from '../lib/types';
import ResenaCard from './ResenaCard.vue';

const input = 'rounded border border-zinc-700 bg-zinc-950 px-3 py-2';

const cargando = ref(true);
const email = ref('');
const userId = ref('');
const resenas = ref<Resena[]>([]);
const editandoId = ref<number | null>(null);
const guardando = ref(false);
const mensaje = ref<{ texto: string; ok: boolean } | null>(null);
const formRef = ref<HTMLFormElement | null>(null);

// Estado del formulario (conectado a los inputs con v-model)
const formVacio = () => ({
  titulo: '',
  director: '',
  anio: '' as string | number,
  genero: '',
  calificacion: '',
  poster_url: '',
  resena: '',
});
const form = reactive(formVacio());

onMounted(async () => {
  // R6: sin sesión, al login
  const { data: { session } } = await supabase.auth.getSession();
  if (!session) {
    navigate('/login');
    return;
  }

  userId.value = session.user.id;
  email.value = session.user.email ?? '';
  cargando.value = false;
  await cargar();
});

// READ: solo las reseñas del usuario conectado
async function cargar() {
  const { data, error } = await supabase
    .from('resenas')
    .select('*')
    .eq('user_id', userId.value)
    .order('id', { ascending: false });

  if (error) {
    mensaje.value = { texto: error.message, ok: false };
    return;
  }
  resenas.value = data as Resena[];
}

// Convierte el formulario en un objeto para Supabase (vacío -> null)
function leerForm(): ResenaInput {
  const nulo = (v: string | number) => {
    const s = String(v).trim();
    return s === '' ? null : s;
  };
  const anio = nulo(form.anio);
  return {
    titulo: form.titulo.trim(),
    director: nulo(form.director),
    anio: anio ? Number(anio) : null,
    genero: nulo(form.genero),
    poster_url: nulo(form.poster_url),
    calificacion: Number(form.calificacion),
    resena: nulo(form.resena),
  };
}

// CREATE / UPDATE: el mismo formulario sirve para las dos
async function guardar() {
  guardando.value = true;
  const datos = leerForm();

  // En insert no se envía user_id: Supabase lo pone con default auth.uid()
  const { error } = editandoId.value
    ? await supabase.from('resenas').update(datos).eq('id', editandoId.value)
    : await supabase.from('resenas').insert(datos);

  guardando.value = false;

  if (error) {
    mensaje.value = { texto: error.message, ok: false };
    return;
  }

  mensaje.value = { texto: editandoId.value ? 'Reseña actualizada.' : 'Reseña publicada.', ok: true };
  limpiar();
  await cargar();
}

// Pasa el formulario a modo edición con los datos de la reseña
function editar(r: Resena) {
  editandoId.value = r.id;
  Object.assign(form, {
    titulo: r.titulo,
    director: r.director ?? '',
    anio: r.anio ?? '',
    genero: r.genero ?? '',
    calificacion: r.calificacion ? String(r.calificacion) : '',
    poster_url: r.poster_url ?? '',
    resena: r.resena ?? '',
  });
  mensaje.value = null;
  formRef.value?.scrollIntoView({ behavior: 'smooth' });
}

function limpiar() {
  editandoId.value = null;
  Object.assign(form, formVacio());
}

// DELETE
async function eliminar(r: Resena) {
  if (!confirm(`¿Eliminar la reseña de "${r.titulo}"?`)) return;

  const { error } = await supabase.from('resenas').delete().eq('id', r.id);

  if (error) {
    mensaje.value = { texto: error.message, ok: false };
    return;
  }

  if (editandoId.value === r.id) limpiar();
  mensaje.value = { texto: 'Reseña eliminada.', ok: true };
  await cargar();
}
</script>

<template>
  <p v-if="cargando" class="text-zinc-400">Verificando sesión...</p>

  <div v-else>
    <div class="mb-6">
      <h1 class="text-3xl font-bold">Mis reseñas</h1>
      <p class="text-sm text-zinc-400">{{ email }}</p>
    </div>

    <form
      ref="formRef"
      class="mb-10 grid gap-3 rounded-lg border border-zinc-800 bg-zinc-900 p-4 sm:grid-cols-2"
      @submit.prevent="guardar"
    >
      <h2 class="text-xl font-semibold text-amber-400 sm:col-span-2">
        {{ editandoId ? 'Editando reseña' : 'Nueva reseña' }}
      </h2>
      <input v-model="form.titulo" required placeholder="Título *" :class="[input, 'sm:col-span-2']" />
      <input v-model="form.director" placeholder="Director" :class="input" />
      <input v-model="form.anio" type="number" min="1880" max="2100" placeholder="Año" :class="input" />
      <input v-model="form.genero" placeholder="Género" :class="input" />
      <select v-model="form.calificacion" required :class="input">
        <option value="">Calificación *</option>
        <option v-for="n in [5, 4, 3, 2, 1]" :key="n" :value="String(n)">
          {{ '★'.repeat(n) + '☆'.repeat(5 - n) }} ({{ n }})
        </option>
      </select>
      <input v-model="form.poster_url" type="url" placeholder="URL del póster (opcional)" :class="[input, 'sm:col-span-2']" />
      <textarea v-model="form.resena" rows="3" placeholder="Tu reseña" :class="[input, 'sm:col-span-2']"></textarea>

      <div class="flex gap-2 sm:col-span-2">
        <button
          :disabled="guardando"
          class="rounded bg-amber-500 px-4 py-2 font-semibold text-zinc-950 hover:bg-amber-400 disabled:opacity-50"
        >
          {{ editandoId ? 'Guardar cambios' : 'Publicar' }}
        </button>
        <button v-if="editandoId" type="button" class="rounded border border-zinc-700 px-4 py-2" @click="limpiar">
          Cancelar edición
        </button>
      </div>

      <p v-if="mensaje" class="text-sm sm:col-span-2" :class="mensaje.ok ? 'text-green-400' : 'text-red-400'">
        {{ mensaje.texto }}
      </p>
    </form>

    <p v-if="resenas.length === 0" class="text-zinc-400">Todavía no has publicado reseñas.</p>

    <ul class="grid gap-4 sm:grid-cols-2">
      <ResenaCard v-for="r in resenas" :key="r.id" :resena="r">
        <button
          class="rounded border border-zinc-700 px-3 py-1 text-sm hover:border-amber-400"
          @click="editar(r)"
        >
          Editar
        </button>
        <button
          class="rounded border border-zinc-700 px-3 py-1 text-sm hover:border-red-400 hover:text-red-400"
          @click="eliminar(r)"
        >
          Eliminar
        </button>
      </ResenaCard>
    </ul>
  </div>
</template>
