<script setup lang="ts">
// Isla de Vue: se usa con client:only="vue", así que todo esto corre en el navegador
import { onMounted, ref } from 'vue';
import { navigate } from 'astro:transitions/client';
import { supabase } from '../lib/supabase';

const input = 'w-full rounded border border-zinc-700 bg-zinc-900 px-3 py-2';

const email = ref('');
const password = ref('');
const enviando = ref(false);
const error = ref('');

onMounted(async () => {
  // Si ya hay sesión, no tiene sentido mostrar el login
  const { data: { session } } = await supabase.auth.getSession();
  if (session) navigate('/admin');
});

async function entrar() {
  enviando.value = true;
  error.value = '';

  const { error: errorAuth } = await supabase.auth.signInWithPassword({
    email: email.value,
    password: password.value,
  });

  enviando.value = false;

  if (errorAuth) {
    error.value = 'Correo o contraseña incorrectos.';
    return;
  }

  navigate('/admin');
}
</script>

<template>
  <div class="mx-auto max-w-sm">
    <h1 class="mb-6 text-3xl font-bold">Iniciar sesión</h1>

    <form class="space-y-4" @submit.prevent="entrar">
      <input v-model="email" type="email" required placeholder="Correo" :class="input" />
      <input v-model="password" type="password" required placeholder="Contraseña" :class="input" />
      <button
        :disabled="enviando"
        class="w-full rounded bg-amber-500 py-2 font-semibold text-zinc-950 hover:bg-amber-400 disabled:opacity-50"
      >
        {{ enviando ? 'Entrando...' : 'Entrar' }}
      </button>
    </form>

    <p v-if="error" class="mt-4 text-sm text-red-400">{{ error }}</p>

    <p class="mt-6 text-sm text-zinc-400">
      ¿No tienes cuenta? <a href="/registro" class="text-amber-400 underline">Regístrate</a>
    </p>
  </div>
</template>
