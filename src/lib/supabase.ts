import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL;
const supabaseKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
  throw new Error('Faltan PUBLIC_SUPABASE_URL o PUBLIC_SUPABASE_ANON_KEY en el .env');
}

// Un solo cliente para servidor (listado SSR) y navegador (login, registro, admin).
// La llave es pública: la seguridad real la dan las políticas RLS.
export const supabase = createClient(supabaseUrl, supabaseKey);
