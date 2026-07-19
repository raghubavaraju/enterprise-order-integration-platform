/**
 * STATUS: Working example DataWeave transformation.
 * Maps a fictional SAP OData-style order payload to this platform's canonical Order model
 * (the shape defined by the `Order` type in api-specs/sap-system-api.raml).
 *
 * Input: fictional SAP OData order response
 * Output: canonical Order JSON
 */
%dw 2.0
output application/json

var statusMap = {
    "10": "CREATED",
    "20": "IN_FULFILLMENT",
    "30": "SHIPPED",
    "40": "DELIVERED",
    "90": "CANCELLED"
}

---
{
    orderId: payload.SalesOrder,
    sapOrderNumber: payload.SalesOrder,
    customerId: payload.SoldToParty,
    // Business interpretation of SAP's raw numeric status code lives here, in the
    // System API's mapping layer, translating protocol-level detail into the
    // canonical model — NOT business-rule interpretation, which stays in the Process API.
    status: statusMap[payload.OverallSDProcessStatus] default "CREATED",
    orderDate: payload.SalesOrderDate[0 to 9] as Date {format: "yyyy-MM-dd"},
    lineItems: payload.to_Item map (item) -> {
        sku: item.Material,
        quantity: item.RequestedQuantity as Number,
        unitPrice: item.NetPriceAmount as Number
    },
    totalAmount: payload.TotalNetAmount as Number,
    currency: payload.TransactionCurrency default "USD"
}
