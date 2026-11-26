-- Ejecutar en el Editor SQL de Supabase. No elimina registros existentes.
-- El borrado posterior de un pedido elimina sus pagos en la misma transacción.
begin;
alter table public.payments
  drop constraint if exists payments_order_id_owner_fkey;
alter table public.payments
  add constraint payments_order_id_owner_fkey
  foreign key (order_id, owner) references public.orders(id, owner)
  on delete cascade;
grant delete on public.orders to authenticated;
commit;
