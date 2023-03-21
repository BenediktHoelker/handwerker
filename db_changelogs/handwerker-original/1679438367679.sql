drop view if exists "public"."handwerkerservice_orders";

drop view if exists "public"."localized_de_handwerkerservice_orders";

drop view if exists "public"."localized_fr_handwerkerservice_orders";

drop view if exists "public"."localized_handwerkerservice_orders";

create or replace view "public"."handwerkerservice_orderitemsaggr" as  SELECT orderitemsaggr_0.order_id,
    orderitemsaggr_0.itemscount
   FROM handwerker_orderitemsaggr orderitemsaggr_0;


create or replace view "public"."handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (handwerker_orders orders_0
     LEFT JOIN handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));


create or replace view "public"."localized_de_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (localized_de_handwerker_orders orders_0
     LEFT JOIN localized_de_handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));


create or replace view "public"."localized_fr_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (localized_fr_handwerker_orders orders_0
     LEFT JOIN localized_fr_handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));


create or replace view "public"."localized_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (localized_handwerker_orders orders_0
     LEFT JOIN localized_handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));



