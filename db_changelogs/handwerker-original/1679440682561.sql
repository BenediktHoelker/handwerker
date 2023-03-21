drop view if exists "public"."handwerkerservice_equipments";

drop view if exists "public"."handwerkerservice_orders";

drop view if exists "public"."localized_de_handwerkerservice_equipments";

drop view if exists "public"."localized_de_handwerkerservice_orderitems";

drop view if exists "public"."localized_de_handwerkerservice_orders";

drop view if exists "public"."localized_fr_handwerkerservice_equipments";

drop view if exists "public"."localized_fr_handwerkerservice_orderitems";

drop view if exists "public"."localized_fr_handwerkerservice_orders";

drop view if exists "public"."localized_handwerkerservice_equipments";

drop view if exists "public"."localized_handwerkerservice_orderitems";

drop view if exists "public"."localized_handwerkerservice_orders";

drop view if exists "public"."localized_de_handwerker_equipments";

drop view if exists "public"."localized_fr_handwerker_equipments";

drop view if exists "public"."localized_handwerker_equipments";

alter table "public"."handwerker_orders" add column "salesprice" numeric(9,2);

alter table "public"."handwerker_orders" add column "salespricecurrency_code" character varying(3);

create or replace view "public"."handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.purchaseprice,
    equipments_0.purchasepricecurrency_code,
    equipments_0.salesprice,
    equipments_0.salespricecurrency_code,
    equipments_0.margin
   FROM handwerker_equipments equipments_0;


create or replace view "public"."handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    orders_0.salesprice,
    orders_0.salespricecurrency_code,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (handwerker_orders orders_0
     LEFT JOIN handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));


create or replace view "public"."localized_de_handwerker_equipments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.purchaseprice,
    l.purchasepricecurrency_code,
    l.salesprice,
    l.salespricecurrency_code,
    l.margin
   FROM handwerker_equipments l;


create or replace view "public"."localized_de_handwerker_orders" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.title,
    l.description,
    l.client_id,
    l.salesprice,
    l.salespricecurrency_code
   FROM handwerker_orders l;


create or replace view "public"."localized_de_handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.purchaseprice,
    equipments_0.purchasepricecurrency_code,
    equipments_0.salesprice,
    equipments_0.salespricecurrency_code,
    equipments_0.margin
   FROM localized_de_handwerker_equipments equipments_0;


create or replace view "public"."localized_de_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.salesprice,
    orderitems_0.salespricecurrency_code,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_de_handwerker_orderitems orderitems_0
     LEFT JOIN localized_de_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_de_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_de_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."localized_de_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    orders_0.salesprice,
    orders_0.salespricecurrency_code,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (localized_de_handwerker_orders orders_0
     LEFT JOIN localized_de_handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));


create or replace view "public"."localized_fr_handwerker_equipments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.purchaseprice,
    l.purchasepricecurrency_code,
    l.salesprice,
    l.salespricecurrency_code,
    l.margin
   FROM handwerker_equipments l;


create or replace view "public"."localized_fr_handwerker_orders" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.title,
    l.description,
    l.client_id,
    l.salesprice,
    l.salespricecurrency_code
   FROM handwerker_orders l;


create or replace view "public"."localized_fr_handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.purchaseprice,
    equipments_0.purchasepricecurrency_code,
    equipments_0.salesprice,
    equipments_0.salespricecurrency_code,
    equipments_0.margin
   FROM localized_fr_handwerker_equipments equipments_0;


create or replace view "public"."localized_fr_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.salesprice,
    orderitems_0.salespricecurrency_code,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_fr_handwerker_orderitems orderitems_0
     LEFT JOIN localized_fr_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_fr_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_fr_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."localized_fr_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    orders_0.salesprice,
    orders_0.salespricecurrency_code,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (localized_fr_handwerker_orders orders_0
     LEFT JOIN localized_fr_handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));


create or replace view "public"."localized_handwerker_equipments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.purchaseprice,
    l.purchasepricecurrency_code,
    l.salesprice,
    l.salespricecurrency_code,
    l.margin
   FROM handwerker_equipments l;


create or replace view "public"."localized_handwerker_orders" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.title,
    l.description,
    l.client_id,
    l.salesprice,
    l.salespricecurrency_code
   FROM handwerker_orders l;


create or replace view "public"."localized_handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.purchaseprice,
    equipments_0.purchasepricecurrency_code,
    equipments_0.salesprice,
    equipments_0.salespricecurrency_code,
    equipments_0.margin
   FROM localized_handwerker_equipments equipments_0;


create or replace view "public"."localized_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.salesprice,
    orderitems_0.salespricecurrency_code,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_handwerker_orderitems orderitems_0
     LEFT JOIN localized_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."localized_handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    orders_0.salesprice,
    orders_0.salespricecurrency_code,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM (localized_handwerker_orders orders_0
     LEFT JOIN localized_handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)));



