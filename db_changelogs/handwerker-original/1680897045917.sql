create table "public"."handwerker_adresses" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "street" character varying(5000),
    "housenumber" character varying(5000),
    "postalcode" character varying(5000),
    "city" character varying(5000)
);


alter table "public"."handwerker_businesspartners" add column "address_id" character varying(36);

alter table "public"."handwerkerservice_businesspartners_drafts" add column "address_id" character varying(36);

CREATE UNIQUE INDEX handwerker_adresses_pkey ON public.handwerker_adresses USING btree (id);

alter table "public"."handwerker_adresses" add constraint "handwerker_adresses_pkey" PRIMARY KEY using index "handwerker_adresses_pkey";

create or replace view "public"."handwerkerservice_adresses" as  SELECT adresses_0.id,
    adresses_0.createdat,
    adresses_0.createdby,
    adresses_0.modifiedat,
    adresses_0.modifiedby,
    adresses_0.street,
    adresses_0.housenumber,
    adresses_0.postalcode,
    adresses_0.city
   FROM handwerker_adresses adresses_0;


create or replace view "public"."handwerkerservice_businesspartners" as  SELECT businesspartners_0.id,
    businesspartners_0.createdat,
    businesspartners_0.createdby,
    businesspartners_0.modifiedat,
    businesspartners_0.modifiedby,
    businesspartners_0.name,
    businesspartners_0.address_id
   FROM handwerker_businesspartners businesspartners_0;


create or replace view "public"."localized_de_handwerker_businesspartners" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.address_id
   FROM handwerker_businesspartners l;


create or replace view "public"."localized_de_handwerkerservice_businesspartners" as  SELECT businesspartners_0.id,
    businesspartners_0.createdat,
    businesspartners_0.createdby,
    businesspartners_0.modifiedat,
    businesspartners_0.modifiedby,
    businesspartners_0.name,
    businesspartners_0.address_id
   FROM localized_de_handwerker_businesspartners businesspartners_0;


create or replace view "public"."localized_fr_handwerker_businesspartners" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.address_id
   FROM handwerker_businesspartners l;


create or replace view "public"."localized_fr_handwerkerservice_businesspartners" as  SELECT businesspartners_0.id,
    businesspartners_0.createdat,
    businesspartners_0.createdby,
    businesspartners_0.modifiedat,
    businesspartners_0.modifiedby,
    businesspartners_0.name,
    businesspartners_0.address_id
   FROM localized_fr_handwerker_businesspartners businesspartners_0;


create or replace view "public"."localized_handwerker_businesspartners" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.name,
    l.address_id
   FROM handwerker_businesspartners l;


create or replace view "public"."localized_handwerkerservice_businesspartners" as  SELECT businesspartners_0.id,
    businesspartners_0.createdat,
    businesspartners_0.createdby,
    businesspartners_0.modifiedat,
    businesspartners_0.modifiedby,
    businesspartners_0.name,
    businesspartners_0.address_id
   FROM localized_handwerker_businesspartners businesspartners_0;



