using {handwerker as my} from '../db/schema';

@(requires: 'authenticated-user')
service HandwerkerService {
    entity BusinessPartners as projection on my.BusinessPartners;
    entity Equipments       as projection on my.Equipments;

    entity Orders           as projection on my.Orders {
        *,
        client.name   as clientName : String @title: '{i18n>clientName}',
        TO_CHAR(createdAt,
        'YYYY-MM-DD') as createdOn  : String

    @title: '{i18n>createdOn}'
};

entity OrderItems           as projection on my.OrderItems {
    *,
    order.client.name || ', ' || TO_CHAR(
        order.createdAt, 'YYYY-MM-DD'
    ) as clientConcatCreatedOn : String @title: '{i18n>createdOn}'
};
}
