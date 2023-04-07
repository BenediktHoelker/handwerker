using {HandwerkerService as my} from './handwerker-service';

annotate my.OrderItems with {
    equipment
    @(Common: {
        Text     : {
            $value                : equipmentName,
            ![@UI.TextArrangement]: #TextOnly,
        },
        ValueList: {
            SearchSupported,
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Equipments',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: equipment_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: unitSalesPrice,
                    ValueListProperty: 'salesPrice'
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: unitSalesPriceCurrency_code,
                    ValueListProperty: 'salesPriceCurrency_code'
                }
            ],
        }
    });
};

annotate my.Orders with @(UI: {
    HeaderInfo: {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : '{i18n>orders}',
        TypeNamePlural: '{i18n>order}',
        Title         : {
            $Type: 'UI.DataField',
            Value: title,
        },
    },
    LineItem  : [
        {
            $Type: 'UI.DataField',
            Value: title,
        },
        {
            $Type: 'UI.DataField',
            Value: description,
        },
        {
            $Type: 'UI.DataField',
            Value: clientName,
        },
        {
            $Type: 'UI.DataField',
            Value: salesPrice
        },
        {
            $Type: 'UI.DataField',
            Value: createdOn
        },
    ],
}) {
    client
    @(Common: {
        Text     : {
            $value                : clientName,
            ![@UI.TextArrangement]: #TextOnly,
        },
        ValueList: {
            SearchSupported,
            $Type         : 'Common.ValueListType',
            CollectionPath: 'BusinessPartners',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: client_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name'
                },
            ],
        }
    });
};

annotate my.Equipments with
@(UI: {
    HeaderInfo     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : '{i18n>equipment}',
        TypeNamePlural: '{i18n>equipments}',
        Title         : {
            $Type: 'UI.DataField',
            Value: name,
        },
    },
    Facets         : [{
        $Type : 'UI.ReferenceFacet',
        Target: '@UI.Identification',
    }, ],
    Identification : [{
        $Type: 'UI.DataField',
        Value: name,
    }, ],
    SelectionFields: [name, ],
    LineItem       : [{
        $Type: 'UI.DataField',
        Value: name
    }, ]
}) {
    ID @(
        UI    : {Hidden, },
        Common: {
            Text           : name,
            TextArrangement: #TextOnly,
        }
    )
};

annotate my.BusinessPartners with
@(UI: {
    HeaderInfo     : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : '{i18n>businessPartner}',
        TypeNamePlural: '{i18n>businessPartners}',
        Title         : {
            $Type: 'UI.DataField',
            Value: name,
        },
    },
    Facets         : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.Identification',
            Label : '{i18n>identification}',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'address/@UI.Identification',
            Label : '{i18n>address}',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'orders/@UI.LineItem',
            Label : '{i18n>orders}',
        },
    ],
    Identification : [{
        $Type: 'UI.DataField',
        Value: name,
    }, ],
    SelectionFields: [name, ],
    LineItem       : [{
        $Type: 'UI.DataField',
        Value: name
    }, ]
}) {
    ID @(
        UI    : {Hidden, },
        Common: {
            Text           : name,
            TextArrangement: #TextOnly,
        }
    )
};

annotate my.Adresses with @UI: {
    LineItem      : [
        {
            $Type: 'UI.DataField',
            Value: street,
        },
        {
            $Type: 'UI.DataField',
            Value: houseNumber,
        },
        {
            $Type: 'UI.DataField',
            Value: postalCode,
        },
        {
            $Type: 'UI.DataField',
            Value: city,
        },
    ],
    HeaderInfo    : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : '{i18n>address}',
        TypeNamePlural: '{i18n>addresses}'
    },
    Identification: [
        {
            $Type: 'UI.DataField',
            Value: street,
        },
        {
            $Type: 'UI.DataField',
            Value: houseNumber,
        },
        {
            $Type: 'UI.DataField',
            Value: postalCode,
        },
        {
            $Type: 'UI.DataField',
            Value: street,
        },
    ],
};

annotate my.Settings with @(UI: {
    HeaderInfo    : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : '{i18n>settings}',
        TypeNamePlural: '{i18n>settings}',
    },
    Facets        : [
        {
            $Type : 'UI.ReferenceFacet',
            Target: '@UI.Identification',
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target: 'address/@UI.Identification',
        },
    ],
    Identification: [{
        $Type: 'UI.DataField',
        Value: salesMargin,
    }]
});
