alter table "public"."handwerker_equipments" add column "price" numeric;

create or replace view "public"."handwerkerservice_equipments" as  SELECT equipments_0.id,
    equipments_0.createdat,
    equipments_0.createdby,
    equipments_0.modifiedat,
    equipments_0.modifiedby,
    equipments_0.name,
    equipments_0.price
   FROM handwerker_equipments equipments_0;



