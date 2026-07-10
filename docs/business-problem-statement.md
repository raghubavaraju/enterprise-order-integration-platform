> **Document type: Architecture documentation** — fictional scenario, no proprietary information. See [Fictional Scenario Disclosure](../README.md#fictional-scenario-disclosure) in this repository's README.

# Business Problem Statement

## Fictional Enterprise: Northbridge Consumer Products

Northbridge Consumer Products is a fictional multi-brand manufacturer and distributor of home and outdoor goods, selling through its own e-commerce storefront, a mobile app, and a network of independent dealers who place orders through a partner portal.

## The Problem

Order data is created and managed in **SAP** (order management, inventory, fulfillment status). Customer and account data — including dealer accounts, loyalty tier, and support case history — is managed in **Salesforce**. A legacy **relational order archive database** holds multi-year order history that predates the current SAP implementation and is still queried by finance and customer service.

Historically, each downstream consumer-facing application (storefront, mobile app, dealer portal) integrated **directly and independently** with SAP and Salesforce:

- Every application team built and maintained its own SAP and Salesforce client code, authentication handling, and data transformation logic.
- A change to a SAP field mapping or a Salesforce object required coordinated changes across every consuming application.
- Error handling, retry behavior, and logging were inconsistent between applications, making production issues difficult to triage.
- There was no single, governed contract for "what an order looks like" or "what a customer looks like" — each team interpreted the source system's raw schema differently.
- Adding a new downstream consumer (e.g., a future partner integration) meant repeating the same direct SAP/Salesforce integration work from scratch.

## The Business Goal

Replace direct, point-to-point integration with a governed, API-led integration platform that:

1. Exposes SAP and Salesforce data through stable, reusable **System APIs**, so downstream teams no longer integrate directly with source systems.
2. Provides a single **Order Process API** that owns the business logic of combining order and customer data, applying business rules, and archiving to the relational order history database.
3. Provides a **Customer Experience API** tailored to the specific needs of consumer-facing channels (storefront, mobile app, dealer portal), so each channel gets a shape of data suited to it without re-implementing orchestration logic.
4. Establishes reusable patterns (error handling, security, logging, versioning) that any future integration on the platform can adopt, rather than reinvent.

## Why This Scenario Was Chosen

This scenario is modeled on the general shape of enterprise integration problems common in manufacturing and retail environments — ERP order data, CRM customer data, and multiple downstream consumer applications — without describing any specific real employer's systems, data, or implementation. It is designed to be architecturally representative, not a disclosure of prior work.
