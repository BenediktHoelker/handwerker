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
    name      : String                                   @title: '{i18n>name}';
    orders    : Association to many Orders
                    on orders.client = $self             @title: '{i18n>orders}';
    addresses : Composition of many Addresses
                    on addresses.businessPartner = $self @title: '{i18n>addresses}';
}

@title: '{i18n>address}'
entity Addresses : cuid, managed {
    street          : String                          @title: '{i18n>street}';
    postalCode      : String                          @title: '{i18n>postalCode}';
    city            : String                          @title: '{i18n>city}';
    email           : String                          @title: '{i18n>email}';
    phone           : String                          @title: '{i18n>phone}';
    website         : String                          @title: '{i18n>website}';
    businessPartner : Association to BusinessPartners @title: '{i18n>businessPartner}';
    type            : String                          @title: '{i18n>addressType}' enum {
        Invoice;
        Shipping
    };
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

entity Users : managed {
    key email : String @title: '{i18n>email}';
        name  : String @title: '{i18n>name}';
}

entity Settings : managed {
    key userEmail   : String  @title: '{i18n>user}';
        salesMargin : Decimal @title: '{i18n>salesMargin}';
        address     : Association to Addresses
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
