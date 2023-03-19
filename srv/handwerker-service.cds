using {handwerker as my} from '../db/schema';

service HandwerkerService {
    entity BusinessPartners as projection on my.BusinessPartners;
    entity Equipments       as projection on my.Equipments;
    entity Orders           as projection on my.Orders;
    entity OrderItems       as projection on my.OrderItems;
}
