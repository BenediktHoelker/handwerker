create schema if not exists "public";

create table "public"."handwerker_businesspartners" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "name" character varying(5000)
);


create table "public"."handwerker_equipments" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "name" character varying(5000),
    "price" numeric(9,2)
);


create table "public"."handwerker_orderitems" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "order_id" character varying(36),
    "equipment_id" character varying(36),
    "quantity" integer,
    "completedat" timestamp with time zone
);


create table "public"."handwerker_orders" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "title" character varying(5000),
    "description" character varying(5000),
    "client_id" character varying(36)
);


CREATE UNIQUE INDEX handwerker_businesspartners_pkey ON public.handwerker_businesspartners USING btree (id);

CREATE UNIQUE INDEX handwerker_equipments_pkey ON public.handwerker_equipments USING btree (id);

CREATE UNIQUE INDEX handwerker_orderitems_pkey ON public.handwerker_orderitems USING btree (id);

CREATE UNIQUE INDEX handwerker_orders_pkey ON public.handwerker_orders USING btree (id);

alter table "public"."handwerker_businesspartners" add constraint "handwerker_businesspartners_pkey" PRIMARY KEY using index "handwerker_businesspartners_pkey";

alter table "public"."handwerker_equipments" add constraint "handwerker_equipments_pkey" PRIMARY KEY using index "handwerker_equipments_pkey";

alter table "public"."handwerker_orderitems" add constraint "handwerker_orderitems_pkey" PRIMARY KEY using index "handwerker_orderitems_pkey";

alter table "public"."handwerker_orders" add constraint "handwerker_orders_pkey" PRIMARY KEY using index "handwerker_orders_pkey";

create or replace view "public"."handwerkerservice_businesspartners" as  SELECT businesspartners_0.id,
    businesspartners_0.createdat,
    businesspartners_0.createdby,
    businesspartners_0.modifiedat,
    businesspartners_0.modifiedby,
    businesspartners_0.name
   FROM handwerker_businesspartners businesspartners_0;


create or replace view "public"."handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.price
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


create or replace view "public"."handwerkerservice_orders" as  SELECT orders_0.id,
    orders_0.createdat,
    orders_0.createdby,
    orders_0.modifiedat,
    orders_0.modifiedby,
    orders_0.title,
    orders_0.description,
    orders_0.client_id,
    (count(DISTINCT items_2.id))::integer AS itemscount,
    client_1.name AS clientname,
    to_char(orders_0.createdat, 'YYYY-MM-DD'::text) AS createdon
   FROM ((handwerker_orders orders_0
     LEFT JOIN handwerker_businesspartners client_1 ON (((orders_0.client_id)::text = (client_1.id)::text)))
     LEFT JOIN handwerker_orderitems items_2 ON (((items_2.order_id)::text = (orders_0.id)::text)))
  GROUP BY orders_0.createdat, orders_0.createdby, orders_0.description, orders_0.id, orders_0.modifiedat, orders_0.modifiedby, orders_0.title, client_1.name;



