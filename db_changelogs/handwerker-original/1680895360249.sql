create table "public"."draft_draftadministrativedata" (
    "draftuuid" character varying(36) not null,
    "creationdatetime" timestamp with time zone,
    "createdbyuser" character varying(256),
    "draftiscreatedbyme" boolean,
    "lastchangedatetime" timestamp with time zone,
    "lastchangedbyuser" character varying(256),
    "inprocessbyuser" character varying(256),
    "draftisprocessedbyme" boolean
);


create table "public"."handwerkerservice_businesspartners_drafts" (
    "id" character varying(36) not null,
    "createdat" timestamp with time zone,
    "createdby" character varying(255),
    "modifiedat" timestamp with time zone,
    "modifiedby" character varying(255),
    "name" character varying(5000),
    "isactiveentity" boolean,
    "hasactiveentity" boolean,
    "hasdraftentity" boolean,
    "draftadministrativedata_draftuuid" character varying(36) not null
);


CREATE UNIQUE INDEX draft_draftadministrativedata_pkey ON public.draft_draftadministrativedata USING btree (draftuuid);

CREATE UNIQUE INDEX handwerkerservice_businesspartners_drafts_pkey ON public.handwerkerservice_businesspartners_drafts USING btree (id);

alter table "public"."draft_draftadministrativedata" add constraint "draft_draftadministrativedata_pkey" PRIMARY KEY using index "draft_draftadministrativedata_pkey";

alter table "public"."handwerkerservice_businesspartners_drafts" add constraint "handwerkerservice_businesspartners_drafts_pkey" PRIMARY KEY using index "handwerkerservice_businesspartners_drafts_pkey";

create or replace view "public"."handwerkerservice_draftadministrativedata" as  SELECT draftadministrativedata.draftuuid,
    draftadministrativedata.creationdatetime,
    draftadministrativedata.createdbyuser,
    draftadministrativedata.draftiscreatedbyme,
    draftadministrativedata.lastchangedatetime,
    draftadministrativedata.lastchangedbyuser,
    draftadministrativedata.inprocessbyuser,
    draftadministrativedata.draftisprocessedbyme
   FROM draft_draftadministrativedata draftadministrativedata;



