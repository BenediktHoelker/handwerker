drop view if exists "public"."handwerkerservice_orderitems";

drop view if exists "public"."handwerkerservice_orders";

create table "public"."handwerker_currencies" (
    "code" character varying(3) not null,
    "symbol" character varying(5)
);


create table "public"."handwerker_settings" (
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "settingskey" character varying(5000) not null,
    "settingsvalue" character varying(5000)
);


create table "public"."sap_common_currencies" (
    "name" character varying(255),
    "descr" character varying(1000),
    "code" character varying(3) not null,
    "symbol" character varying(5)
);


create table "public"."sap_common_currencies_texts" (
    "locale" character varying(14) not null,
    "name" character varying(255),
    "descr" character varying(1000),
    "code" character varying(3) not null
);


alter table "public"."handwerker_equipments" add column "margin" numeric;

alter table "public"."handwerker_equipments" add column "purchaseprice" numeric(9,2);

alter table "public"."handwerker_equipments" add column "purchasepricecurrency_code" character varying(3);

alter table "public"."handwerker_equipments" add column "salesprice" numeric(9,2);

alter table "public"."handwerker_equipments" add column "salespricecurrency_code" character varying(3);

alter table "public"."handwerker_orderitems" add column "salesprice" numeric(9,2);

alter table "public"."handwerker_orderitems" add column "salespricecurrency_code" character varying(3);

alter table "public"."handwerker_orders" add column "salesprice" numeric(9,2);

alter table "public"."handwerker_orders" add column "salespricecurrency_code" character varying(3);

CREATE UNIQUE INDEX handwerker_currencies_pkey ON public.handwerker_currencies USING btree (code);

CREATE UNIQUE INDEX handwerker_settings_pkey ON public.handwerker_settings USING btree (settingskey);

CREATE UNIQUE INDEX sap_common_currencies_pkey ON public.sap_common_currencies USING btree (code);

CREATE UNIQUE INDEX sap_common_currencies_texts_pkey ON public.sap_common_currencies_texts USING btree (locale, code);

alter table "public"."handwerker_currencies" add constraint "handwerker_currencies_pkey" PRIMARY KEY using index "handwerker_currencies_pkey";

alter table "public"."handwerker_settings" add constraint "handwerker_settings_pkey" PRIMARY KEY using index "handwerker_settings_pkey";

alter table "public"."sap_common_currencies" add constraint "sap_common_currencies_pkey" PRIMARY KEY using index "sap_common_currencies_pkey";

alter table "public"."sap_common_currencies_texts" add constraint "sap_common_currencies_texts_pkey" PRIMARY KEY using index "sap_common_currencies_texts_pkey";

create or replace view "public"."handwerker_orderitemsaggr" as  SELECT orderitems_0.order_id,
    (count(DISTINCT orderitems_0.id))::integer AS itemscount
   FROM handwerker_orderitems orderitems_0
  GROUP BY orderitems_0.order_id;


create or replace view "public"."handwerkerservice_currencies" as  SELECT currencies_0.name,
    currencies_0.descr,
    currencies_0.code,
    currencies_0.symbol
   FROM sap_common_currencies currencies_0;


create or replace view "public"."handwerkerservice_currencies_texts" as  SELECT texts_0.locale,
    texts_0.name,
    texts_0.descr,
    texts_0.code
   FROM sap_common_currencies_texts texts_0;


create or replace view "public"."handwerkerservice_orderitemsaggr" as  SELECT orderitemsaggr_0.order_id,
    orderitemsaggr_0.itemscount
   FROM handwerker_orderitemsaggr orderitemsaggr_0;


create or replace view "public"."handwerkerservice_settings" as  SELECT settings_0.createdat,
    settings_0.createdby,
    settings_0.modifiedat,
    settings_0.modifiedby,
    settings_0.settingskey,
    settings_0.settingsvalue
   FROM handwerker_settings settings_0;


create or replace view "public"."localized_de_handwerker_businesspartners" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name
   FROM handwerker_businesspartners l;


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


create or replace view "public"."localized_de_handwerker_orderitems" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.order_id,
    l.equipment_id,
    l.quantity,
    l.salesprice,
    l.salespricecurrency_code,
    l.completedat
   FROM handwerker_orderitems l;


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


create or replace view "public"."localized_de_handwerkerservice_businesspartners" as  SELECT businesspartners_0.id,
    businesspartners_0.createdat,
    businesspartners_0.createdby,
    businesspartners_0.modifiedat,
    businesspartners_0.modifiedby,
    businesspartners_0.name
   FROM localized_de_handwerker_businesspartners businesspartners_0;


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


create or replace view "public"."localized_de_sap_common_currencies" as  SELECT COALESCE(localized_de_1.name, l_0.name) AS name,
    COALESCE(localized_de_1.descr, l_0.descr) AS descr,
    l_0.code,
    l_0.symbol
   FROM (sap_common_currencies l_0
     LEFT JOIN sap_common_currencies_texts localized_de_1 ON ((((localized_de_1.code)::text = (l_0.code)::text) AND ((localized_de_1.locale)::text = 'de'::text))));


create or replace view "public"."localized_fr_handwerker_businesspartners" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name
   FROM handwerker_businesspartners l;


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


create or replace view "public"."localized_fr_handwerker_orderitems" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.order_id,
    l.equipment_id,
    l.quantity,
    l.salesprice,
    l.salespricecurrency_code,
    l.completedat
   FROM handwerker_orderitems l;


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


create or replace view "public"."localized_fr_handwerkerservice_businesspartners" as  SELECT businesspartners_0.id,
    businesspartners_0.createdat,
    businesspartners_0.createdby,
    businesspartners_0.modifiedat,
    businesspartners_0.modifiedby,
    businesspartners_0.name
   FROM localized_fr_handwerker_businesspartners businesspartners_0;


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


create or replace view "public"."localized_fr_sap_common_currencies" as  SELECT COALESCE(localized_fr_1.name, l_0.name) AS name,
    COALESCE(localized_fr_1.descr, l_0.descr) AS descr,
    l_0.code,
    l_0.symbol
   FROM (sap_common_currencies l_0
     LEFT JOIN sap_common_currencies_texts localized_fr_1 ON ((((localized_fr_1.code)::text = (l_0.code)::text) AND ((localized_fr_1.locale)::text = 'fr'::text))));


create or replace view "public"."localized_handwerker_businesspartners" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name
   FROM handwerker_businesspartners l;


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


create or replace view "public"."localized_handwerker_orderitems" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.order_id,
    l.equipment_id,
    l.quantity,
    l.salesprice,
    l.salespricecurrency_code,
    l.completedat
   FROM handwerker_orderitems l;


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


create or replace view "public"."localized_handwerkerservice_businesspartners" as  SELECT businesspartners_0.id,
    businesspartners_0.createdat,
    businesspartners_0.createdby,
    businesspartners_0.modifiedat,
    businesspartners_0.modifiedby,
    businesspartners_0.name
   FROM localized_handwerker_businesspartners businesspartners_0;


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


create or replace view "public"."localized_sap_common_currencies" as  SELECT COALESCE(localized_1.name, l_0.name) AS name,
    COALESCE(localized_1.descr, l_0.descr) AS descr,
    l_0.code,
    l_0.symbol
   FROM (sap_common_currencies l_0
     LEFT JOIN sap_common_currencies_texts localized_1 ON ((((localized_1.code)::text = (l_0.code)::text) AND ((localized_1.locale)::text = 'en'::text))));


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


create or replace view "public"."handwerkerservice_orderitems" as  SELECT orderitems_0.id,
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
   FROM (((handwerker_orderitems orderitems_0
     LEFT JOIN handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


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


create or replace view "public"."localized_de_handwerkerservice_currencies" as  SELECT currencies_0.name,
    currencies_0.descr,
    currencies_0.code,
    currencies_0.symbol
   FROM localized_de_sap_common_currencies currencies_0;


create or replace view "public"."localized_fr_handwerkerservice_currencies" as  SELECT currencies_0.name,
    currencies_0.descr,
    currencies_0.code,
    currencies_0.symbol
   FROM localized_fr_sap_common_currencies currencies_0;


create or replace view "public"."localized_handwerkerservice_currencies" as  SELECT currencies_0.name,
    currencies_0.descr,
    currencies_0.code,
    currencies_0.symbol
   FROM localized_sap_common_currencies currencies_0;



