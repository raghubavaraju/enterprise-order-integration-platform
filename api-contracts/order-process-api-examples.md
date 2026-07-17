> **Document type: Architecture documentation (example contracts).** All data below is fictional sample data.

# Order Process API — Example Contracts

## GET /api/v1/orders/{orderId} — full success (both backends healthy)

**Response — 200 OK**
```json
{
  "orderId": "ORD-100245",
  "status": "IN_FULFILLMENT",
  "orderDate": "2026-07-20",
  "totalAmount": 258.99,
  "currency": "USD",
  "customer": {
    "customerId": "CUST-88213",
    "accountType": "RETAIL",
    "loyaltyTier": "GOLD"
  },
  "customerDataAvailable": true,
  "lineItems": [
    { "sku": "NB-TENT-2P-GRN", "quantity": 1, "unitPrice": 189.99 },
    { "sku": "NB-STOVE-CMP-01", "quantity": 2, "unitPrice": 34.50 }
  ]
}
```

## GET /api/v1/orders/{orderId} — graceful degradation (Salesforce unavailable)

**Response — 206 Partial Content**
```json
{
  "orderId": "ORD-100245",
  "status": "IN_FULFILLMENT",
  "orderDate": "2026-07-20",
  "totalAmount": 258.99,
  "currency": "USD",
  "customerDataAvailable": false,
  "lineItems": [
    { "sku": "NB-TENT-2P-GRN", "quantity": 1, "unitPrice": 189.99 },
    { "sku": "NB-STOVE-CMP-01", "quantity": 2, "unitPrice": 34.50 }
  ]
}
```

## POST /api/v1/orders — idempotency key reused with a different payload

**Response — 409 Conflict**
```json
{
  "errorCode": "IDEMPOTENCY_KEY_CONFLICT",
  "message": "Idempotency-Key 8b6a1f2c-storefront-9911 was already used with a different request body.",
  "correlationId": "6f2b1a3e-2c31-4e9a-9a2d-1a7b6f8e2b10",
  "timestamp": "2026-07-28T10:16:02.118Z"
}
```
