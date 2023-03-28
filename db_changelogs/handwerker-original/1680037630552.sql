drop view if exists "public"."handwerkerservice_attachments";

alter table "public"."handwerker_attachments" add column "filename" character varying(5000);

alter table "public"."handwerker_attachments" add column "size" integer;

create or replace view "public"."handwerkerservice_attachments" as  SELECT attachments_0.id,
    attachments_0.filename,
    attachments_0.size,
    attachments_0.content,
    attachments_0.mediatype
   FROM handwerker_attachments attachments_0;



