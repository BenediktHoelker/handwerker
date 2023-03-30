drop view if exists "public"."handwerkerservice_attachments";

alter table "public"."handwerker_attachments" add column "createdat" timestamp with time zone;

alter table "public"."handwerker_attachments" add column "createdby" character varying(255);

alter table "public"."handwerker_attachments" add column "modifiedat" timestamp with time zone;

alter table "public"."handwerker_attachments" add column "modifiedby" character varying(255);

alter table "public"."handwerker_attachments" add column "order_id" character varying(36);

create or replace view "public"."localized_de_handwerker_attachments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.filename,
    l.size,
    l.content,
    l.mediatype,
    l.order_id
   FROM handwerker_attachments l;


create or replace view "public"."localized_de_handwerkerservice_attachments" as  SELECT attachments_0.id,
    attachments_0.createdat,
    attachments_0.createdby,
    attachments_0.modifiedat,
    attachments_0.modifiedby,
    attachments_0.filename,
    attachments_0.size,
    attachments_0.content,
    attachments_0.mediatype,
    attachments_0.order_id
   FROM localized_de_handwerker_attachments attachments_0;


create or replace view "public"."localized_fr_handwerker_attachments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.filename,
    l.size,
    l.content,
    l.mediatype,
    l.order_id
   FROM handwerker_attachments l;


create or replace view "public"."localized_fr_handwerkerservice_attachments" as  SELECT attachments_0.id,
    attachments_0.createdat,
    attachments_0.createdby,
    attachments_0.modifiedat,
    attachments_0.modifiedby,
    attachments_0.filename,
    attachments_0.size,
    attachments_0.content,
    attachments_0.mediatype,
    attachments_0.order_id
   FROM localized_fr_handwerker_attachments attachments_0;


create or replace view "public"."localized_handwerker_attachments" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.filename,
    l.size,
    l.content,
    l.mediatype,
    l.order_id
   FROM handwerker_attachments l;


create or replace view "public"."localized_handwerkerservice_attachments" as  SELECT attachments_0.id,
    attachments_0.createdat,
    attachments_0.createdby,
    attachments_0.modifiedat,
    attachments_0.modifiedby,
    attachments_0.filename,
    attachments_0.size,
    attachments_0.content,
    attachments_0.mediatype,
    attachments_0.order_id
   FROM localized_handwerker_attachments attachments_0;


create or replace view "public"."handwerkerservice_attachments" as  SELECT attachments_0.id,
    attachments_0.createdat,
    attachments_0.createdby,
    attachments_0.modifiedat,
    attachments_0.modifiedby,
    attachments_0.filename,
    attachments_0.size,
    attachments_0.content,
    attachments_0.mediatype,
    attachments_0.order_id
   FROM handwerker_attachments attachments_0;



