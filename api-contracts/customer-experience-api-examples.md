> **Document type: Architecture documentation (example contracts).** All data below is fictional sample data.

# Customer Experience API — Example Contracts

## GET /api/v1/orders/{orderId} — X-Channel: mobile (lightweight shape)

**Response — 200 OK**
```json
{
  "orderId": "ORD-100245",
  "status": "IN_FULFILLMENT",
  "orderDate": "2026-07-20",
  "totalAmount": 258.99,
  "currency": "USD"
}
```

## GET /api/v1/orders/{orderId} — X-Channel: dealer-portal (extended shape)

**Response — 200 OK**
```json
{
  "orderId": "ORD-100245",
  "status": "IN_FULFILLMENT",
  "orderDate": "2026-07-20",
  "totalAmount": 258.99,
  "currency": "USD",
  "customerSummary": {
    "accountType": "DEALER",
    "dealerPricingTier": "TIER_2"
  },
  "lineItems": [
    { "sku": "NB-TENT-2P-GRN", "quantity": 1, "unitPrice": 189.99 },
    { "sku": "NB-STOVE-CMP-01", "quantity": 2, "unitPrice": 34.50 }
  ]
}
```

## GET /api/v1/orders?status=IN_FULFILLMENT&limit=2

**Response — 200 OK**
```json
[
  { "orderId": "ORD-100245", "status": "IN_FULFILLMENT", "orderDate": "2026-07-20", "totalAmount": 258.99, "currency": "USD" },
  { "orderId": "ORD-100198", "status": "IN_FULFILLMENT", "orderDate": "2026-07-15", "totalAmount": 74.00, "currency": "USD" }
]
```
