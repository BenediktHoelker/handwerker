drop view if exists "public"."handwerkerservice_orders";

create or replace view "public"."handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    count(DISTINCT items_2.id) AS itemscount,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM ((handwerker_orders orders_0
     LEFT JOIN handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)))
     LEFT JOIN handwerker_orderitems items_2 ON (((items_2.order_id)::text = (orders_0.id)::text)))
  GROUP BY orders_0.createdat, orders_0.createdby, orders_0.description, orders_0.id, orders_0.modifiedat, orders_0.modifiedby, orders_0.title, client_1.name;



