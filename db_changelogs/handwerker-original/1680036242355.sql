create table "public"."handwerker_attachments" (
    "id" character varying(36) not null,
    "content" bytea,
    "mediatype" character varying(5000)
);


CREATE UNIQUE INDEX handwerker_attachments_pkey ON public.handwerker_attachments USING btree (id);

alter table "public"."handwerker_attachments" add constraint "handwerker_attachments_pkey" PRIMARY KEY using index "handwerker_attachments_pkey";

create or replace view "public"."handwerkerservice_attachments" as  SELECT attachments_0.id,
    attachments_0.content,
    attachments_0.mediatype
   FROM handwerker_attachments attachments_0;



