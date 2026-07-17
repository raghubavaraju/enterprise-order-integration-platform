> **Document type: Architecture documentation (example contracts).** All data below is fictional sample data.

# SAP System API — Example Contracts

## GET /api/v1/sap-orders/{orderId}

**Request**
```
GET /api/v1/sap-orders/ORD-100245 HTTP/1.1
Authorization: Bearer <token>
X-Correlation-Id: 6f2b1a3e-2c31-4e9a-9a2d-1a7b6f8e2b10
```

**Response — 200 OK**
```json
{
  "orderId": "ORD-100245",
  "sapOrderNumber": "45001002389",
  "customerId": "CUST-88213",
  "status": "IN_FULFILLMENT",
  "orderDate": "2026-07-20",
  "lineItems": [
    { "sku": "NB-TENT-2P-GRN", "quantity": 1, "unitPrice": 189.99 },
    { "sku": "NB-STOVE-CMP-01", "quantity": 2, "unitPrice": 34.50 }
  ],
  "totalAmount": 258.99,
  "currency": "USD"
}
```

**Response — 502 Bad Gateway (SAP unavailable)**
```json
{
  "errorCode": "SAP_BACKEND_UNAVAILABLE",
  "message": "SAP order service did not respond within the configured timeout.",
  "correlationId": "6f2b1a3e-2c31-4e9a-9a2d-1a7b6f8e2b10",
  "timestamp": "2026-07-28T10:15:32.401Z"
}
```

## POST /api/v1/sap-orders

**Request**
```json
{
  "customerId": "CUST-88213",
  "idempotencyKey": "8b6a1f2c-storefront-9911",
  "lineItems": [
    { "sku": "NB-TENT-2P-GRN", "quantity": 1 }
  ]
}
```

**Response — 201 Created**
```json
{
  "orderId": "ORD-100301",
  "sapOrderNumber": "45001002440",
  "customerId": "CUST-88213",
  "status": "CREATED",
  "orderDate": "2026-07-28",
  "lineItems": [
    { "sku": "NB-TENT-2P-GRN", "quantity": 1, "unitPrice": 189.99 }
  ],
  "totalAmount": 189.99,
  "currency": "USD"
}
```
