export type Users = {
    email?: string | null
    name?: string | null
}

export type BusinessPartners = {
    ID: string 
    createdAt?: Date | null
    createdBy?: string | null
    modifiedAt?: Date | null
    modifiedBy?: string | null
    name?: string | null
    address_ID?: string | null
    IsActiveEntity: boolean 
    HasActiveEntity: boolean 
    HasDraftEntity: boolean 
    DraftAdministrativeData_DraftUUID?: string | null
}

export type Adresses = {
    ID: string 
    createdAt?: Date | null
    createdBy?: string | null
    modifiedAt?: Date | null
    modifiedBy?: string | null
    street?: string | null
    houseNumber?: string | null
    postalCode?: string | null
    city?: string | null
    email?: string | null
    phone?: string | null
}

export type Equipments = {
    ID: string 
    createdAt?: Date | null
    createdBy?: string | null
    modifiedAt?: Date | null
    modifiedBy?: string | null
    name?: string | null
    purchasePrice?: number | null
    purchasePriceCurrency_code?: string | null
    salesPrice?: number | null
    salesPriceCurrency_code?: string | null
    margin?: number | null
}

export type Settings = {
    createdAt?: Date | null
    createdBy?: string | null
    modifiedAt?: Date | null
    modifiedBy?: string | null
    tenant: string 
    salesMargin?: number | null
    address_ID?: string | null
    IsActiveEntity: boolean 
    HasActiveEntity: boolean 
    HasDraftEntity: boolean 
    DraftAdministrativeData_DraftUUID?: string | null
}

export type OrderItemsAggr = {
    order_ID: string 
    itemsCount?: number | null
}

export type Orders = {
    ID: string 
    createdAt?: Date | null
    createdBy?: string | null
    modifiedAt?: Date | null
    modifiedBy?: string | null
    title?: string | null
    description?: string | null
    client_ID?: string | null
    salesPrice?: number | null
    salesPriceCurrency_code?: string | null
    clientName?: string | null
    createdOn?: string | null
}

export type OrderItems = {
    ID: string 
    createdAt?: Date | null
    createdBy?: string | null
    modifiedAt?: Date | null
    modifiedBy?: string | null
    order_ID?: string | null
    equipment_ID?: string | null
    quantity?: number | null
    salesPrice?: number | null
    salesPriceCurrency_code?: string | null
    unitSalesPrice?: number | null
    unitSalesPriceCurrency_code?: string | null
    completedAt?: Date | null
    equipmentName?: string | null
    clientConcatCreatedOn?: string | null
}

export type Attachments = {
    ID: string 
    createdAt?: Date | null
    createdBy?: string | null
    modifiedAt?: Date | null
    modifiedBy?: string | null
    fileName?: string | null
    size?: number | null
    mediaType?: string | null
    order_ID?: string | null
}

export type Currencies = {
    name?: string | null
    descr?: string | null
    code: string 
    symbol?: string | null
}

export type DraftAdministrativeData = {
    DraftUUID: string 
    CreationDateTime?: Date | null
    CreatedByUser?: string | null
    DraftIsCreatedByMe?: boolean | null
    LastChangeDateTime?: Date | null
    LastChangedByUser?: string | null
    InProcessByUser?: string | null
    DraftIsProcessedByMe?: boolean | null
}

export type Currencies_texts = {
    locale: string 
    name?: string | null
    descr?: string | null
    code: string 
}

