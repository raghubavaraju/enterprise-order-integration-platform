> **Document type: Architecture documentation (example contracts).** All data below is fictional sample data.

# Salesforce System API — Example Contracts

## GET /api/v1/sf-customers/{customerId}

**Request**
```
GET /api/v1/sf-customers/CUST-88213 HTTP/1.1
Authorization: Bearer <token>
X-Correlation-Id: 6f2b1a3e-2c31-4e9a-9a2d-1a7b6f8e2b10
```

**Response — 200 OK**
```json
{
  "customerId": "CUST-88213",
  "salesforceAccountId": "001Ax000009Fz1Q",
  "accountType": "RETAIL",
  "loyaltyTier": "GOLD",
  "createdDate": "2022-03-11"
}
```

**Response — 200 OK (dealer account)**
```json
{
  "customerId": "CUST-40221",
  "salesforceAccountId": "001Ax000009Fz9K",
  "accountType": "DEALER",
  "dealerPricingTier": "TIER_2",
  "createdDate": "2019-11-04"
}
```

**Response — 429 Too Many Requests**
```json
{
  "errorCode": "SALESFORCE_RATE_LIMIT",
  "message": "Salesforce API request limit exceeded; retry after backoff window.",
  "correlationId": "6f2b1a3e-2c31-4e9a-9a2d-1a7b6f8e2b10",
  "timestamp": "2026-07-28T10:15:32.401Z"
}
```
