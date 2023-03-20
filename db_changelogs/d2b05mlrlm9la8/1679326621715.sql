create or replace view "public"."handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.completedat,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM ((handwerker_orderitems orderitems_0
     LEFT JOIN handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)));


create or replace view "public"."handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.client_id,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (handwerker_orders orders_0
     LEFT JOIN handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));



