using {
    cuid,
    Currency,
    managed
} from '@sap/cds/common';

namespace handwerker;

// use custom to avoid problems with language-dependent problems (not working with PG-adapter)
entity Currencies {
    key code   : String(3) @(title: '{i18n>CurrencyCode}');
        symbol : String(5) @(title: '{i18n>CurrencySymbol}');
}

entity BusinessPartners : cuid, managed {
    name    : String                       @title: '{i18n>name}';
    orders  : Association to many Orders
                  on orders.client = $self @title: '{i18n>orders}';
    address : Association to Adresses
}

@title: '{i18n>address}'
entity Adresses : cuid, managed {
    street      : String @title: '{i18n>street}';
    houseNumber : String @title: '{i18n>houseNumber}';
    postalCode  : String @title: '{i18n>postalCode}';
    city        : String @title: '{i18n>city}';
}

entity Equipments : cuid, managed {
    name                  : String        @title: '{i18n>name}';

    @Measures.ISOCurrency: purchasePriceCurrency_code
    purchasePrice         : Decimal(9, 2) @title: '{i18n>purchasePrice}';
    purchasePriceCurrency : Currency      @title: '{i18n>purchasePriceCurrency}';

    @Measures.ISOCurrency: salesPriceCurrency_code
    salesPrice            : Decimal(9, 2) @title: '{i18n>salesPrice}';
    salesPriceCurrency    : Currency      @title: '{i18n>salesPriceCurrency}';
    margin                : Decimal       @title: '{i18n>margin}';
}

entity Orders : cuid, managed {
    title              : String                          @title: '{i18n>title}';
    description        : String                          @title: '{i18n>description}';
    client             : Association to BusinessPartners @title: '{i18n>client}';

    @Measures.ISOCurrency: salesPriceCurrency_code
    salesPrice         : Decimal(9, 2)                   @title: '{i18n>salesPrice}';
    salesPriceCurrency : Currency                        @title: '{i18n>salesPriceCurrency}';
    items              : Composition of many OrderItems
                             on items.order = $self      @title: '{i18n>items}';
    attachments        : Composition of many Attachments
                             on attachments.order = $self;
}

entity OrderItems : cuid, managed {
    order                  : Association to Orders     @title: '{i18n>order}';
    equipment              : Association to Equipments @title: '{i18n>equipment}';
    quantity               : Integer                   @title: '{i18n>quantity}';

    @Measures.ISOCurrency: salesPriceCurrency_code
    salesPrice             : Decimal(9, 2)             @title: '{i18n>salesPrice}';
    salesPriceCurrency     : Currency                  @title: '{i18n>salesPriceCurrency}';

    @Measures.ISOCurrency: unitSalesPriceCurrency_code
    unitSalesPrice         : Decimal(9, 2)             @title: '{i18n>unitSalesPrice}';
    unitSalesPriceCurrency : Currency                  @title: '{i18n>unitSalesPriceCurrency}';
    completedAt            : DateTime                  @title: '{i18n>completedAt}';
}

entity Settings : managed {
    key settingsKey   : String @title: '{i18n>settingsKey}';
        settingsValue : String @title: '{i18n>settingsValue}';
}

view OrderItemsAggr as
    select from OrderItems {
        key order.ID as order_ID,
            cast(
                count(
                    distinct ID
                ) as                 Integer
            )        as itemsCount : Integer @title: '{i18n>itemsCount}',
    }
    group by
        order.ID;


entity Attachments : cuid, managed {
    fileName  : String;
    size      : Integer;

    @Core.MediaType  : mediaType
    content   : LargeBinary;

    @Core.IsMediaType: true
    mediaType : String;
    order     : Association to Orders;
}
