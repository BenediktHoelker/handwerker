using {
    cuid,
    managed
} from '@sap/cds/common';

namespace handwerker;

entity BusinessPartners : cuid, managed {
    name   : String                       @title: '{i18n>name}';
    orders : Association to many Orders
                 on orders.client = $self @title: '{i18n>orders}';
}

entity Equipments : cuid, managed {
    name : String @title: '{i18n>name}'
}

entity Orders : cuid, managed {
    client : Association to BusinessPartners @title: '{i18n>client}';
    items  : Association to many OrderItems
                 on items.order = $self      @title: '{i18n>items}';
}

entity OrderItems : cuid, managed {
    order     : Association to Orders     @title: '{i18n>order}';
    equipment : Association to Equipments @title: '{i18n>equipment}';
    quantity  : Integer                   @title: '{i18n>quantity}';
// completedAt : DateTime                  @title: '{i18n>completedAt}'
}
