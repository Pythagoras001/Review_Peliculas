// @ts-check
import { defineConfig } from 'astro/config';

import cloudflare from '@astrojs/cloudflare';

import tailwindcss from '@tailwindcss/vite';

import vue from '@astrojs/vue';

// https://astro.build/config
export default defineConfig({
  adapter: cloudflare(),

  integrations: [vue()],

  vite: {
    plugins: [tailwindcss()]
  }
});
