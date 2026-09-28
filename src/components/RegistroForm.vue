<script setup lang="ts">
// Isla de Vue: se usa con client:only="vue", así que todo esto corre en el navegador
import { ref } from 'vue';
import { navigate } from 'astro:transitions/client';
import { supabase } from '../lib/supabase';

const input = 'w-full rounded border border-zinc-700 bg-zinc-900 px-3 py-2';

const email = ref('');
const password = ref('');
const enviando = ref(false);
const mensaje = ref<{ texto: string; ok: boolean } | null>(null);

async function registrar() {
  enviando.value = true;
  mensaje.value = null;

  const { data, error } = await supabase.auth.signUp({
    email: email.value,
    password: password.value,
  });

  enviando.value = false;

  if (error) {
    mensaje.value = { texto: error.message, ok: false };
    return;
  }

  if (data.session) {
    navigate('/admin'); // sin confirmación de email: ya hay sesión
  } else {
    mensaje.value = { texto: 'Cuenta creada. Revisa tu correo para confirmarla.', ok: true };
  }
}
</script>

<template>
  <div class="mx-auto max-w-sm">
    <h1 class="mb-6 text-3xl font-bold">Crear cuenta</h1>

    <form class="space-y-4" @submit.prevent="registrar">
      <input v-model="email" type="email" required placeholder="Correo" :class="input" />
      <input
        v-model="password"
        type="password"
        required
        minlength="6"
        placeholder="Contraseña (mín. 6 caracteres)"
        :class="input"
      />
      <button
        :disabled="enviando"
        class="w-full rounded bg-amber-500 py-2 font-semibold text-zinc-950 hover:bg-amber-400 disabled:opacity-50"
      >
        {{ enviando ? 'Creando cuenta...' : 'Registrarme' }}
      </button>
    </form>

    <p v-if="mensaje" class="mt-4 text-sm" :class="mensaje.ok ? 'text-green-400' : 'text-red-400'">
      {{ mensaje.texto }}
    </p>

    <p class="mt-6 text-sm text-zinc-400">
      ¿Ya tienes cuenta? <a href="/login" class="text-amber-400 underline">Inicia sesión</a>
    </p>
  </div>
</template>
