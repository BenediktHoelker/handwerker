using {handwerker as my} from './schema';

annotate my.OrderItems with {
    equipment
    @(Common: {
        Text     : {
            $value                : equipment.name,
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
                    // LocalDataProperty: equipment.name,
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
