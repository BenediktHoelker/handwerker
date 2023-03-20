create or replace view "public"."handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.client_id,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM handwerker_orders orders_0;



