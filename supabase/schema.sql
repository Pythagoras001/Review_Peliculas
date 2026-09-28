-- =========================================================
-- Taller 2 - Plataforma de reseñas de películas
-- Ejecutar completo en: Supabase Dashboard -> SQL Editor
-- =========================================================

-- 1. Tabla
create table if not exists public.resenas (
  id           bigint generated always as identity primary key,
  titulo       text not null,
  director     text,
  anio         int check (anio between 1880 and 2100),
  genero       text,
  poster_url   text,
  calificacion int check (calificacion between 1 and 5),
  resena       text,
  user_id      uuid default auth.uid() references auth.users(id) on delete set null,
  created_at   timestamptz not null default now()
);

-- 2. Row Level Security (R6)
alter table public.resenas enable row level security;

-- Lectura pública: cualquiera (anon o logueado) puede ver las reseñas
create policy "Lectura pública"
  on public.resenas for select
  to anon, authenticated
  using (true);

-- Escritura: solo usuarios autenticados, y cada uno solo sobre sus propias reseñas
create policy "Crear reseñas propias"
  on public.resenas for insert
  to authenticated
  with check (user_id = auth.uid());

create policy "Editar reseñas propias"
  on public.resenas for update
  to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

create policy "Eliminar reseñas propias"
  on public.resenas for delete
  to authenticated
  using (user_id = auth.uid());

-- 3. Datos de prueba (22 filas -> sirve para probar la paginación)
-- Se cargan sin dueño (user_id = null): se ven en el listado pero nadie
-- puede editarlas desde la app. Para borrarlas al terminar, en el SQL Editor:
--   delete from public.resenas where user_id is null;
insert into public.resenas (titulo, director, anio, genero, calificacion, resena) values
  ('El Padrino', 'Francis Ford Coppola', 1972, 'Crimen', 5, 'Una obra maestra sobre el poder y la familia. Cada escena está cuidada al detalle.'),
  ('Pulp Fiction', 'Quentin Tarantino', 1994, 'Crimen', 5, 'Diálogos brillantes y una estructura no lineal que sigue sorprendiendo.'),
  ('El caballero de la noche', 'Christopher Nolan', 2008, 'Acción', 5, 'El Joker de Heath Ledger eleva la película a otro nivel.'),
  ('Parásitos', 'Bong Joon-ho', 2019, 'Thriller', 5, 'Sátira social impecable que cambia de género sin perder el ritmo.'),
  ('El viaje de Chihiro', 'Hayao Miyazaki', 2001, 'Animación', 5, 'Un mundo mágico lleno de imaginación y de detalles inolvidables.'),
  ('Origen', 'Christopher Nolan', 2010, 'Ciencia ficción', 4, 'Idea original y bien ejecutada, aunque exige mucha atención.'),
  ('Interestelar', 'Christopher Nolan', 2014, 'Ciencia ficción', 4, 'Visualmente impresionante y con una banda sonora enorme.'),
  ('Matrix', 'Lana y Lilly Wachowski', 1999, 'Ciencia ficción', 5, 'Revolucionó el cine de acción y sigue vigente.'),
  ('Forrest Gump', 'Robert Zemeckis', 1994, 'Drama', 4, 'Emotiva y entrañable, con una actuación memorable de Tom Hanks.'),
  ('Coco', 'Lee Unkrich', 2017, 'Animación', 4, 'Un homenaje precioso a la tradición del Día de Muertos.'),
  ('El laberinto del fauno', 'Guillermo del Toro', 2006, 'Fantasía', 5, 'Fantasía oscura que mezcla cuento de hadas y guerra con maestría.'),
  ('Whiplash', 'Damien Chazelle', 2014, 'Drama', 5, 'Tensa de principio a fin. El final es de los mejores del cine reciente.'),
  ('La La Land', 'Damien Chazelle', 2016, 'Musical', 4, 'Colorida y nostálgica, con un final agridulce que funciona.'),
  ('Mad Max: Furia en el camino', 'George Miller', 2015, 'Acción', 4, 'Dos horas de acción práctica sin respiro.'),
  ('Toy Story', 'John Lasseter', 1995, 'Animación', 4, 'La película que inauguró la animación por computadora y sigue encantando.'),
  ('Titanic', 'James Cameron', 1997, 'Romance', 3, 'Espectacular en lo técnico, aunque la historia de amor se alarga.'),
  ('Joker', 'Todd Phillips', 2019, 'Drama', 3, 'Gran actuación de Joaquin Phoenix, pero el guion es irregular.'),
  ('Amores perros', 'Alejandro González Iñárritu', 2000, 'Drama', 4, 'Tres historias cruzadas, crudas y muy bien entrelazadas.'),
  ('El club de la pelea', 'David Fincher', 1999, 'Drama', 4, 'Provocadora y con un giro final que obliga a verla dos veces.'),
  ('Volver al futuro', 'Robert Zemeckis', 1985, 'Ciencia ficción', 4, 'Aventura divertida y perfecta para toda la familia.'),
  ('Oppenheimer', 'Christopher Nolan', 2023, 'Drama', 4, 'Densa pero fascinante, con un montaje que mantiene la tensión.'),
  ('¡Huye!', 'Jordan Peele', 2017, 'Terror', 4, 'Terror inteligente con una crítica social muy clara.');

-- 4. Storage para los pósters
-- Bucket público "posters": máx. 2 MB, solo imágenes
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('posters', 'posters', true, 2097152, array['image/jpeg', 'image/png', 'image/webp']);

-- Cada usuario solo puede subir y borrar archivos dentro de su carpeta: posters/<su user_id>/...
create policy "Subir posters propios"
  on storage.objects for insert to authenticated
  with check (bucket_id = 'posters' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Borrar posters propios"
  on storage.objects for delete to authenticated
  using (bucket_id = 'posters' and (storage.foldername(name))[1] = auth.uid()::text);
