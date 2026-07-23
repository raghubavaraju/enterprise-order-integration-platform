/**
 * STATUS: Working example DataWeave transformation.
 * Combines the canonical Order (from SAP System API) and canonical Customer (from
 * Salesforce System API, may be absent if degraded) into the OrderSummary shape
 * defined in api-specs/order-process-api.raml.
 *
 * Inputs (set as Mule variables upstream):
 *   vars.sapOrder            - canonical Order from SAP System API (required)
 *   vars.salesforceCustomer  - canonical Customer from Salesforce System API (optional; null if degraded)
 */
%dw 2.0
output application/json
---
{
    orderId: vars.sapOrder.orderId,
    status: vars.sapOrder.status,
    orderDate: vars.sapOrder.orderDate,
    totalAmount: vars.sapOrder.totalAmount,
    currency: vars.sapOrder.currency,
    customerDataAvailable: vars.salesforceCustomer != null
} ++ (
    if (vars.salesforceCustomer != null)
        {
            customer: {
                customerId: vars.salesforceCustomer.customerId,
                accountType: vars.salesforceCustomer.accountType,
                loyaltyTier: vars.salesforceCustomer.loyaltyTier default null
            } filterObject ((value, key) -> value != null)
        }
    else
        {}
) ++ {
    lineItems: vars.sapOrder.lineItems
}
