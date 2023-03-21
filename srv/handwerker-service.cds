using {handwerker as my} from '../db/schema';

@(requires: 'authenticated-user')
service HandwerkerService {
    entity BusinessPartners as projection on my.BusinessPartners;
    entity Equipments       as projection on my.Equipments;
    entity Settings         as projection on my.Settings;

    @cds.redirection.target
    entity Orders           as
        select from my.Orders
        join my.OrderItemsAggr
            on Orders.ID = OrderItemsAggr.order_ID
        {
                *,
            key ID,
                client.name as clientName : String @title: '{i18n>clientName}',
                TO_CHAR(
                    createdAt, 'YYYY-MM-DD'
                )           as createdOn  : String @title: '{i18n>createdOn}'
        }
        excluding {
            order_ID
        };

    entity OrderItems       as projection on my.OrderItems {
        *,
        equipment.name as equipmentName         : String @title: '{i18n>equipmentName}',
        order.client.name || ', ' || TO_CHAR(
            order.createdAt, 'YYYY-MM-DD'
        )              as clientConcatCreatedOn : String @title: '{i18n>createdOn}'
    };

    type Users {
        email : String @title: '{i18n>email}';
        name  : String @title: '{i18n>name}';
    }

    function getUserInfo() returns Users;
}
