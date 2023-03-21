create table "public"."handwerker_currencies" (
    "code" character varying(3) not null,
    "symbol" character varying(5)
);


CREATE UNIQUE INDEX handwerker_currencies_pkey ON public.handwerker_currencies USING btree (code);

alter table "public"."handwerker_currencies" add constraint "handwerker_currencies_pkey" PRIMARY KEY using index "handwerker_currencies_pkey";

create or replace view "public"."handwerkerservice_settings" as  SELECT settings_0.createdat,
    settings_0.createdby,
    settings_0.modifiedat,
    settings_0.modifiedby,
    settings_0.settingskey,
    settings_0.settingsvalue
   FROM handwerker_settings settings_0;



