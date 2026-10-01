# CineReseñas

Aplicación web de reseñas de películas construida con Astro y Vue, con Supabase como base de datos y sistema de autenticación, desplegada en Cloudflare Workers. El listado público es de acceso libre; la creación, edición y eliminación de reseñas requiere una cuenta autenticada.

Proyecto desarrollado para el Taller #2: Proyecto Astro con arquitectura híbrida (SSR + SSG) en Cloudflare.

- **URL pública:** https://taller2-astro.thomas200719.workers.dev

---

## Tecnologías

| Pieza | Uso |
|---|---|
| [Astro 7](https://docs.astro.build) | Framework, rutas y renderizado híbrido |
| [Vue 3](https://vuejs.org) (`@astrojs/vue`) | Componentes de la interfaz e islas interactivas |
| [Tailwind CSS 4](https://tailwindcss.com) | Estilos |
| [Supabase](https://supabase.com) | Base de datos Postgres, autenticación, Storage y RLS |
| [Cloudflare Workers](https://developers.cloudflare.com/workers/) (`@astrojs/cloudflare`) | Hosting y ejecución de las páginas SSR |

## Arquitectura: SSR y SSG

| Ruta | Modo | Descripción |
|---|---|---|
| `/` | **SSR** (`prerender = false`) | Listado público con búsqueda (`?q=`) y paginación (`?page=`). Consulta Supabase **desde el servidor** en cada request; las reseñas vienen en el HTML. |
| `/acerca-de` | **SSG** (`prerender = true`) | Página informativa, generada en el build. |
| `/login` | **SSG** | Página estática + isla Vue (`client:only`) con Supabase Auth. |
| `/registro` | **SSG** | Página estática + isla Vue (`client:only`) con Supabase Auth. |
| `/admin` | **SSG** | Página estática + isla Vue (`client:only`): verifica la sesión (redirige a `/login` si no hay) y hace el CRUD **desde el navegador**. |

- **Seguridad:** la escritura está protegida con políticas **RLS** en Supabase (cada usuario solo puede crear, editar y borrar sus propias reseñas). La llave `anon` es pública; la protección real está en la base de datos.
- **Navegación:** el layout común usa `<ClientRouter />` (View Transitions) y un `<title>` distinto por página.

## Estructura

```text
/
├── public/               # Archivos estáticos (logo, favicon)
├── src/
│   ├── components/       # Componentes Vue (listado, tarjetas, formularios, admin, nav)
│   ├── layouts/          # Layout.astro: layout común con <ClientRouter />
│   ├── lib/              # Cliente de Supabase y tipos TypeScript
│   ├── pages/            # Rutas: index (SSR), acerca-de, login, registro, admin (SSG)
│   └── styles/           # global.css (Tailwind)
├── supabase/schema.sql   # Tabla, políticas RLS, datos de prueba y bucket de pósters
├── .env.example          # Variables de entorno necesarias
├── astro.config.mjs
└── wrangler.jsonc        # Configuración del Worker de Cloudflare
```

## Levantar el proyecto en local

**Requisitos:** Node.js 22.12 o superior y una cuenta de Supabase.

### 1. Clonar e instalar

```sh
git clone https://github.com/Pythagoras001/Review_Peliculas.git
cd Review_Peliculas
npm install
```

### 2. Configurar Supabase

1. Crea un proyecto en [supabase.com](https://supabase.com).
2. En **SQL Editor**, ejecuta completo el archivo [`supabase/schema.sql`](supabase/schema.sql). Crea:
   - la tabla `resenas` con sus políticas RLS,
   - 22 reseñas de prueba (para ver la paginación),
   - el bucket público `posters` para las imágenes.
3. En **Authentication → Sign In / Providers → Email**, desactiva **Confirm email** (el registro inicia sesión directamente).

### 3. Variables de entorno

Copia el archivo de ejemplo y llénalo con los datos de **Project Settings → API** de Supabase:

```sh
cp .env.example .env
```

```env
PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
PUBLIC_SUPABASE_ANON_KEY=tu-llave-anon-o-publishable
```

**Importante:** el archivo `.env` está excluido en `.gitignore`. La llave `service_role` / `secret` no debe usarse en este proyecto ni subirse al repositorio.

### 4. Correr en modo desarrollo

```sh
npm run dev
```

Abre http://localhost:4321.

## Comandos

| Comando | Acción |
|---|---|
| `npm install` | Instala las dependencias |
| `npm run dev` | Servidor de desarrollo en `localhost:4321` |
| `npm run build` | Genera el sitio de producción en `./dist/` |
| `npm run preview` | Previsualiza el build localmente |
| `npm run generate-types` | Genera los tipos de Cloudflare (`wrangler types`) |

## Despliegue en Cloudflare Workers

El repositorio está conectado a Cloudflare (**Workers & Pages → Import a repository**): cada `git push` a `main` construye y despliega automáticamente.

| Configuración | Valor |
|---|---|
| Project name | `taller2-astro` (igual al `name` de `wrangler.jsonc`) |
| Build command | `npm run build` |
| Deploy command | `npx wrangler deploy` |

**Variables de build** (Settings → Build → Variables and secrets):

- `PUBLIC_SUPABASE_URL`
- `PUBLIC_SUPABASE_ANON_KEY`

Deben ir como variables **del build** y no del runtime: las variables `PUBLIC_` se incrustan en el código al compilar (`import.meta.env`), así que tienen que existir cuando corre `npm run build`.

Finalmente, en Supabase (**Authentication → URL Configuration**) se agrega la URL de `workers.dev` como **Site URL**.
