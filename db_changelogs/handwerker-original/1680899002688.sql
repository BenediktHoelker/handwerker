drop view if exists "public"."handwerkerservice_settings";

alter table "public"."handwerker_settings" drop constraint "handwerker_settings_pkey";

drop index if exists "public"."handwerker_settings_pkey";

alter table "public"."handwerker_adresses" add column "email" character varying(5000);

alter table "public"."handwerker_adresses" add column "phone" character varying(5000);

alter table "public"."handwerker_settings" drop column "settingskey";

alter table "public"."handwerker_settings" drop column "settingsvalue";

alter table "public"."handwerker_settings" add column "address_id" character varying(36);

alter table "public"."handwerker_settings" add column "salesmargin" numeric;

alter table "public"."handwerker_settings" add column "tenant" character varying(5000) not null;

CREATE UNIQUE INDEX handwerker_settings_pkey ON public.handwerker_settings USING btree (tenant);

alter table "public"."handwerker_settings" add constraint "handwerker_settings_pkey" PRIMARY KEY using index "handwerker_settings_pkey";

create or replace view "public"."handwerkerservice_adresses" as  SELECT adresses_0.id,
    adresses_0.createdat,
    adresses_0.createdby,
    adresses_0.modifiedat,
    adresses_0.modifiedby,
    adresses_0.street,
    adresses_0.housenumber,
    adresses_0.postalcode,
    adresses_0.city,
    adresses_0.email,
    adresses_0.phone
   FROM handwerker_adresses adresses_0;


create or replace view "public"."handwerkerservice_settings" as  SELECT settings_0.createdat,
    settings_0.createdby,
    settings_0.modifiedat,
    settings_0.modifiedby,
    settings_0.tenant,
    settings_0.salesmargin,
    settings_0.address_id
   FROM handwerker_settings settings_0;



