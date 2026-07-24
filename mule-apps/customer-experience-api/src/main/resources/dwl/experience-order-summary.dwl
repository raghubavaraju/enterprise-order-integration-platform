/**
 * STATUS: Working example DataWeave transformation.
 * Shapes the Order Process API's OrderSummary response per consuming channel.
 * Input: vars.processApiResponse (canonical OrderSummary), vars.channel ("mobile" | "storefront" | "dealer-portal")
 */
%dw 2.0
output application/json
var order = vars.processApiResponse
---
{
    orderId: order.orderId,
    status: order.status,
    orderDate: order.orderDate,
    totalAmount: order.totalAmount,
    currency: order.currency
} ++ (
    // Mobile gets the lightweight shape only — no line items, no customer detail,
    // to keep mobile payloads small (channel-specific concern, per ADR-001 boundary rules).
    if (vars.channel == "mobile")
        {}
    // Dealer portal gets extended account/pricing fields; storefront gets line items only.
    else if (vars.channel == "dealer-portal")
        {
            customerSummary: order.customer default {},
            lineItems: order.lineItems default []
        }
    else
        {
            lineItems: order.lineItems default []
        }
)
