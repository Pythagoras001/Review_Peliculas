export interface Resena {
  id: number;
  titulo: string;
  director: string | null;
  anio: number | null;
  genero: string | null;
  poster_url: string | null;
  calificacion: number | null;
  resena: string | null;
  user_id: string | null;
  created_at: string;
}

// Datos que envía el formulario al crear o editar (Supabase completa el resto)
export type ResenaInput = Omit<Resena, 'id' | 'user_id' | 'created_at'>;
