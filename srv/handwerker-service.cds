using {handwerker as my} from '../db/schema';

@(requires: 'authenticated-user')
service HandwerkerService {
    entity BusinessPartners as projection on my.BusinessPartners;
    entity Equipments       as projection on my.Equipments;
    entity Orders           as projection on my.Orders;

    @(restrict: [
        {
            grant: 'READ',
            to   : 'read:orderitems'
        },
        {
            grant: 'WRITE',
            to   : 'write:orderitems'
        },
    ])
    entity OrderItems       as projection on my.OrderItems
}
