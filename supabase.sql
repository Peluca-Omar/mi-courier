-- Ejecutar una vez en el editor SQL de un proyecto Supabase nuevo.
-- Crear el usuario desde Authentication > Users y desactivar nuevos registros.
create table public.clients (
 id uuid primary key default gen_random_uuid(),
 owner uuid not null default auth.uid() references auth.users(id),
 first_name text not null check(length(trim(first_name)) > 0),
 last_name text not null check(length(trim(last_name)) > 0),
 created_at timestamptz not null default now(),
 unique(id, owner)
);
create table public.orders (
 id uuid primary key default gen_random_uuid(),
 owner uuid not null default auth.uid() references auth.users(id),
 client_id uuid not null,
 kind text not null check(kind in ('purchase','shipping')),
 items jsonb not null check(jsonb_typeof(items) = 'array' and jsonb_array_length(items) > 0),
 order_date date not null default current_date,
 purchase numeric(12,2) not null default 0 check(purchase >= 0),
 commission numeric(12,2) not null default 0 check(commission >= 0),
 shipping numeric(12,2) check(shipping >= 0),
 status text not null default 'Pendiente' check(status in ('Pendiente','En camino','Recibido','Entregado')),
 created_at timestamptz not null default now(),
 foreign key(client_id,owner) references public.clients(id,owner),
 check(kind <> 'shipping' or (purchase = 0 and commission = 0)),
 unique(id,owner)
);
create table public.payments (
 id uuid primary key default gen_random_uuid(),
 owner uuid not null default auth.uid() references auth.users(id),
 order_id uuid not null,
 amount numeric(12,2) not null check(amount > 0),
 paid_on date not null default current_date,
 created_at timestamptz not null default now(),
  foreign key(order_id,owner) references public.orders(id,owner) on delete cascade
);
alter table public.clients enable row level security;
alter table public.orders enable row level security;
alter table public.payments enable row level security;
create policy own_clients on public.clients for all to authenticated using(owner = auth.uid()) with check(owner = auth.uid());
create policy own_orders on public.orders for all to authenticated using(owner = auth.uid()) with check(owner = auth.uid());
create policy own_payments on public.payments for all to authenticated using(owner = auth.uid()) with check(owner = auth.uid());
-- Los pagos se eliminan automáticamente junto con su pedido.
revoke delete on public.clients, public.orders, public.payments from authenticated;
grant delete on public.orders to authenticated;
grant usage on schema public to authenticated;
grant select, insert, update on public.clients, public.orders, public.payments to authenticated;
create index orders_client on public.orders(client_id);
create index payments_order on public.payments(order_id);
