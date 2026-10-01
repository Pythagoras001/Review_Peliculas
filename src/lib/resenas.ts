import { supabase } from './supabase';
import type { Resena, ResenaInput } from './types';

// Todas las funciones lanzan el error de Supabase si algo falla,
// así quien las usa lo maneja con un solo try/catch.

// READ: reseñas de un usuario, las más recientes primero
export async function listarMisResenas(userId: string): Promise<Resena[]> {
  const { data, error } = await supabase
    .from('resenas')
    .select('*')
    .eq('user_id', userId)
    .order('id', { ascending: false });

  if (error) throw error;
  return data as Resena[];
}

// CREATE: no se envía user_id, Supabase lo pone con default auth.uid()
export async function crearResena(datos: ResenaInput) {
  const { error } = await supabase.from('resenas').insert(datos);
  if (error) throw error;
}

// UPDATE: RLS solo deja editar las reseñas propias
export async function actualizarResena(id: number, datos: ResenaInput) {
  const { error } = await supabase.from('resenas').update(datos).eq('id', id);
  if (error) throw error;
}

// DELETE: RLS solo deja eliminar las reseñas propias
export async function eliminarResena(id: number) {
  const { error } = await supabase.from('resenas').delete().eq('id', id);
  if (error) throw error;
}

// Sube el póster a Storage y devuelve su URL pública.
// Ruta: posters/<user_id>/<uuid>.<ext> (las políticas solo permiten subir a la carpeta propia)
export async function subirPoster(userId: string, file: File): Promise<string> {
  const extension = file.name.split('.').pop()?.toLowerCase() || 'jpg';
  const ruta = `${userId}/${crypto.randomUUID()}.${extension}`;

  const { error } = await supabase.storage
    .from('posters')
    .upload(ruta, file, { contentType: file.type });
  if (error) throw error;

  return supabase.storage.from('posters').getPublicUrl(ruta).data.publicUrl;
}
