-- ================================================
-- SAN JUAN PROPIEDADES & MINERÍA — PARTICULARES
-- Pegá este SQL en: supabase.com > tu proyecto
--   > SQL Editor > New query > Pegar > Run
-- ================================================

-- 1. Tabla de avisos
create table public.listings (
  id          uuid        default gen_random_uuid() primary key,
  nombre      text        not null,
  telefono    text        not null,
  categoria   text        not null,
  operacion   text        not null,
  titulo      text        not null,
  precio      text,
  moneda      text        default 'ARS',
  zona        text        not null,
  descripcion text        not null,
  fotos       text[]      default '{}',
  origen      text        default 'directo',
  status      text        default 'pendiente',
  created_at  timestamptz default now()
);

-- 2. Seguridad por fila (RLS)
alter table public.listings enable row level security;

-- 3. Política: cualquiera puede VER los avisos aprobados
create policy "ver_aprobados"
  on public.listings for select
  using ( status = 'aprobado' );

-- 4. Política: cualquiera puede INSERTAR un aviso nuevo
create policy "insertar_aviso"
  on public.listings for insert
  with check ( true );

-- 5. Índices para búsquedas rápidas
create index on public.listings (status);
create index on public.listings (categoria);
create index on public.listings (created_at desc);

-- ================================================
-- STORAGE: hacé esto desde la UI de Supabase
-- ================================================
-- Storage > New bucket
-- Nombre: listing-photos
-- Tildá "Public bucket"
--
-- Después en Storage > Policies > listing-photos:
-- New policy > For INSERT > nombre: "upload_publico"
-- Expresión: true
-- ================================================


-- ================================================
-- MIGRACIÓN: medir de qué campaña viene cada aviso
-- ------------------------------------------------
-- Si la tabla YA EXISTE (es tu caso), no ejecutes todo
-- lo de arriba. Ejecutá SOLO estas dos líneas:
-- ================================================

alter table public.listings
  add column if not exists origen text default 'directo';

create index if not exists listings_origen_idx on public.listings (origen);


-- ================================================
-- CONSULTA: qué canal te trae más publicaciones
-- Pegala en SQL Editor cuando quieras ver los números
-- ================================================

-- select
--   coalesce(origen, 'directo') as canal,
--   count(*)                    as avisos,
--   max(created_at)             as ultimo
-- from public.listings
-- group by 1
-- order by avisos desc;
