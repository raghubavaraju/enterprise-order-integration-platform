/**
 * STATUS: Working example DataWeave transformation.
 * Maps a fictional Salesforce SOQL-query-shaped customer/account record to this
 * platform's canonical Customer model (the `Customer` type in
 * api-specs/salesforce-system-api.raml).
 */
%dw 2.0
output application/json
---
{
    customerId: payload.External_Customer_Id__c,
    salesforceAccountId: payload.Id,
    accountType: if (payload.Type == "Dealer") "DEALER" else "RETAIL",
    loyaltyTier: payload.Loyalty_Tier__c default null,
    dealerPricingTier: payload.Dealer_Pricing_Tier__c default null,
    createdDate: payload.CreatedDate[0 to 9] as Date {format: "yyyy-MM-dd"}
} filterObject ((value, key) -> value != null)
