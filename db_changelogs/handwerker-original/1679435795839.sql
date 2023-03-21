drop view if exists "public"."handwerkerservice_orders";

drop view if exists "public"."localized_de_handwerkerservice_orders";

drop view if exists "public"."localized_fr_handwerkerservice_orders";

drop view if exists "public"."localized_handwerkerservice_orders";

create or replace view "public"."handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    orderitemsaggr_1.itemscount,
    client_2.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM ((handwerker_orders orders_0
     JOIN handwerker_orderitemsaggr orderitemsaggr_1 ON (((orders_0.id)::text = (orderitemsaggr_1.order_id)::text)))
     LEFT JOIN handwerker_businesspartners client_2 ON (((orders_0.client_id)::text = (client_2.id)::text)));


create or replace view "public"."localized_de_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    orderitemsaggr_1.itemscount,
    client_2.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM ((localized_de_handwerker_orders orders_0
     JOIN handwerker_orderitemsaggr orderitemsaggr_1 ON (((orders_0.id)::text = (orderitemsaggr_1.order_id)::text)))
     LEFT JOIN localized_de_handwerker_businesspartners client_2 ON (((orders_0.client_id)::text = (client_2.id)::text)));


create or replace view "public"."localized_fr_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    orderitemsaggr_1.itemscount,
    client_2.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM ((localized_fr_handwerker_orders orders_0
     JOIN handwerker_orderitemsaggr orderitemsaggr_1 ON (((orders_0.id)::text = (orderitemsaggr_1.order_id)::text)))
     LEFT JOIN localized_fr_handwerker_businesspartners client_2 ON (((orders_0.client_id)::text = (client_2.id)::text)));


create or replace view "public"."localized_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    orderitemsaggr_1.itemscount,
    client_2.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM ((localized_handwerker_orders orders_0
     JOIN handwerker_orderitemsaggr orderitemsaggr_1 ON (((orders_0.id)::text = (orderitemsaggr_1.order_id)::text)))
     LEFT JOIN localized_handwerker_businesspartners client_2 ON (((orders_0.client_id)::text = (client_2.id)::text)));



