create table "public"."handwerkerservice_settings_drafts" (
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "tenant" character varying(5000) not null,
    "salesmargin" numeric,
    "address_id" character varying(36),
    "isactiveentity" boolean,
    "hasactiveentity" boolean,
    "hasdraftentity" boolean,
    "draftadministrativedata_draftuuid" character varying(36) not null
);


CREATE UNIQUE INDEX handwerkerservice_settings_drafts_pkey ON public.handwerkerservice_settings_drafts USING btree (tenant);

alter table "public"."handwerkerservice_settings_drafts" add constraint "handwerkerservice_settings_drafts_pkey" PRIMARY KEY using index "handwerkerservice_settings_drafts_pkey";


