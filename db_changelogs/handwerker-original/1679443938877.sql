drop view if exists "public"."handwerkerservice_orderitems";

drop view if exists "public"."handwerkerservice_orderitemsaggr";

drop view if exists "public"."localized_de_handwerkerservice_orderitems";

drop view if exists "public"."localized_fr_handwerkerservice_orderitems";

drop view if exists "public"."localized_handwerkerservice_orderitems";

drop view if exists "public"."handwerker_orderitemsaggr";

drop view if exists "public"."localized_de_handwerker_orderitems";

drop view if exists "public"."localized_fr_handwerker_orderitems";

drop view if exists "public"."localized_handwerker_orderitems";

alter table "public"."handwerker_orderitems" add column "unitsalesprice" numeric(9,2);

alter table "public"."handwerker_orderitems" add column "unitsalespricecurrency_code" character varying(3);

create or replace view "public"."handwerker_orderitemsaggr" as  SELECT orderitems_0.order_id,
    (count(DISTINCT orderitems_0.id))::integer AS itemscount
   FROM handwerker_orderitems orderitems_0
  GROUP BY orderitems_0.order_id;


create or replace view "public"."handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.salesprice,
    orderitems_0.salespricecurrency_code,
    orderitems_0.unitsalesprice,
    orderitems_0.unitsalespricecurrency_code,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((handwerker_orderitems orderitems_0
     LEFT JOIN handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."handwerkerservice_orderitemsaggr" as  SELECT orderitemsaggr_0.order_id,
    orderitemsaggr_0.itemscount
   FROM handwerker_orderitemsaggr orderitemsaggr_0;


create or replace view "public"."localized_de_handwerker_orderitems" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.order_id,
    l.equipment_id,
    l.quantity,
    l.salesprice,
    l.salespricecurrency_code,
    l.unitsalesprice,
    l.unitsalespricecurrency_code,
    l.completedat
   FROM handwerker_orderitems l;


create or replace view "public"."localized_de_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.salesprice,
    orderitems_0.salespricecurrency_code,
    orderitems_0.unitsalesprice,
    orderitems_0.unitsalespricecurrency_code,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_de_handwerker_orderitems orderitems_0
     LEFT JOIN localized_de_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_de_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_de_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."localized_fr_handwerker_orderitems" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.order_id,
    l.equipment_id,
    l.quantity,
    l.salesprice,
    l.salespricecurrency_code,
    l.unitsalesprice,
    l.unitsalespricecurrency_code,
    l.completedat
   FROM handwerker_orderitems l;


create or replace view "public"."localized_fr_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.salesprice,
    orderitems_0.salespricecurrency_code,
    orderitems_0.unitsalesprice,
    orderitems_0.unitsalespricecurrency_code,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_fr_handwerker_orderitems orderitems_0
     LEFT JOIN localized_fr_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_fr_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_fr_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));


create or replace view "public"."localized_handwerker_orderitems" as  SELECT l.id,
    l.createdat,
    l.createdby,
    l.modifiedat,
    l.modifiedby,
    l.order_id,
    l.equipment_id,
    l.quantity,
    l.salesprice,
    l.salespricecurrency_code,
    l.unitsalesprice,
    l.unitsalespricecurrency_code,
    l.completedat
   FROM handwerker_orderitems l;


create or replace view "public"."localized_handwerkerservice_orderitems" as  SELECT orderitems_0.id,
    orderitems_0.createdat,
    orderitems_0.createdby,
    orderitems_0.modifiedat,
    orderitems_0.modifiedby,
    orderitems_0.order_id,
    orderitems_0.equipment_id,
    orderitems_0.quantity,
    orderitems_0.salesprice,
    orderitems_0.salespricecurrency_code,
    orderitems_0.unitsalesprice,
    orderitems_0.unitsalespricecurrency_code,
    orderitems_0.completedat,
    equipment_3.name AS equipmentname,
    (((client_2.name)::text || ', '::text) || to_char(order_1.createdat, 'YYYY-MM-DD'::text)) AS clientconcatcreatedon
   FROM (((localized_handwerker_orderitems orderitems_0
     LEFT JOIN localized_handwerker_orders order_1 ON (((orderitems_0.order_id)::text = (order_1.id)::text)))
     LEFT JOIN localized_handwerker_businesspartners client_2 ON (((order_1.client_id)::text = (client_2.id)::text)))
     LEFT JOIN localized_handwerker_equipments equipment_3 ON (((orderitems_0.equipment_id)::text = (equipment_3.id)::text)));



