using {handwerker as my} from '../db/schema';

@(requires: 'authenticated-user')
service HandwerkerService {
    entity BusinessPartners as projection on my.BusinessPartners;
    entity Equipments       as projection on my.Equipments;
    entity Settings         as projection on my.Settings;
    entity Users            as projection on my.Users;
    entity OrderItemsAggr   as projection on my.OrderItemsAggr;

    entity Orders           as projection on my.Orders {
            *,
        key ID,
            itemsAggr                 : Association to OrderItemsAggr on itemsAggr.order_ID = ID,
            items                     : Association to many OrderItems on items.order = $self,
            client.name as clientName : String @title: '{i18n>clientName}',
            TO_CHAR(
                createdAt, 'YYYY-MM-DD'
            )           as createdOn  : String @title: '{i18n>createdOn}'
    };

    @cds.redirection.target
    entity OrderItems       as projection on my.OrderItems {
        *,
        equipment.name as equipmentName         : String @title: '{i18n>equipmentName}',
        order.client.name || ', ' || TO_CHAR(
            order.createdAt, 'YYYY-MM-DD'
        )              as clientConcatCreatedOn : String @title: '{i18n>createdOn}'
    };

    entity Attachments      as projection on my.Attachments;
    function getUserInfo() returns Users;
}
