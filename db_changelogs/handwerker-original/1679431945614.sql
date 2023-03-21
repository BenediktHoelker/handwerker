drop view if exists "public"."handwerkerservice_equipments";

drop view if exists "public"."handwerkerservice_orderitems";

drop view if exists "public"."localized_de_handwerkerservice_equipments";

drop view if exists "public"."localized_de_handwerkerservice_orderitems";

drop view if exists "public"."localized_fr_handwerkerservice_equipments";

drop view if exists "public"."localized_fr_handwerkerservice_orderitems";

drop view if exists "public"."localized_handwerkerservice_equipments";

drop view if exists "public"."localized_handwerkerservice_orderitems";

drop view if exists "public"."localized_de_handwerker_equipments";

drop view if exists "public"."localized_fr_handwerker_equipments";

drop view if exists "public"."localized_handwerker_equipments";

create table "public"."handwerker_settings" (
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "settingskey" character varying(5000) not null,
    "settingsvalue" character varying(5000)
);


alter table "public"."handwerker_equipments" drop column "price";

alter table "public"."handwerker_equipments" add column "purchaseprice" numeric(9,2);

alter table "public"."handwerker_equipments" add column "salesprice" numeric(9,2);

CREATE UNIQUE INDEX handwerker_settings_pkey ON public.handwerker_settings USING btree (settingskey);

alter table "public"."handwerker_settings" add constraint "handwerker_settings_pkey" PRIMARY KEY using index "handwerker_settings_pkey";

create or replace view "public"."handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.purchaseprice,
    equipments_0.salesprice,
    equipments_0.currency_code
   FROM handwerker_equipments equipments_0;


create or replace view "public"."handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((handwerker_orderitems orderitems_0
     LEFT JOIN handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."localized_de_handwerker_equipments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.purchaseprice,
    l.salesprice,
    l.currency_code
   FROM handwerker_equipments l;


create or replace view "public"."localized_de_handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.purchaseprice,
    equipments_0.salesprice,
    equipments_0.currency_code
   FROM localized_de_handwerker_equipments equipments_0;


create or replace view "public"."localized_de_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_de_handwerker_orderitems orderitems_0
     LEFT JOIN localized_de_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_de_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_de_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."localized_fr_handwerker_equipments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.purchaseprice,
    l.salesprice,
    l.currency_code
   FROM handwerker_equipments l;


create or replace view "public"."localized_fr_handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.purchaseprice,
    equipments_0.salesprice,
    equipments_0.currency_code
   FROM localized_fr_handwerker_equipments equipments_0;


create or replace view "public"."localized_fr_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_fr_handwerker_orderitems orderitems_0
     LEFT JOIN localized_fr_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_fr_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_fr_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."localized_handwerker_equipments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.purchaseprice,
    l.salesprice,
    l.currency_code
   FROM handwerker_equipments l;


create or replace view "public"."localized_handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.purchaseprice,
    equipments_0.salesprice,
    equipments_0.currency_code
   FROM localized_handwerker_equipments equipments_0;


create or replace view "public"."localized_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_handwerker_orderitems orderitems_0
     LEFT JOIN localized_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));



