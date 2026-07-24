# Named Query API in Salesforce

> A complete guide to Salesforce Named Query API with architecture, syntax, examples, security, limitations, interview questions, and best practices.

---

# Table of Contents

1. What is Named Query API?
2. Why was it introduced?
3. How it works
4. Architecture
5. Syntax
6. Writing Named Queries
7. Parameters
8. Examples
9. API Execution Flow
10. Security
11. Authentication
12. Real-world Use Cases
13. Named Query API vs Apex REST
14. Advantages
15. Limitations
16. Considerations
17. Best Practices
18. Common Mistakes
19. Interview Questions
20. Summary

---

# What is Named Query API?

Named Query API is a Salesforce feature that allows you to expose a predefined **SOQL query** as a **REST API endpoint** without writing Apex REST classes.

Instead of creating an Apex REST class just to fetch records, you define a SOQL query once, give it a name, and Salesforce automatically exposes it as an API.

Think of it as:

```
SOQL Query
      +
REST Endpoint
      =
Named Query API
```

It is designed for:

- Agentforce
- External applications
- Experience Cloud
- Mobile Apps
- Integrations
- Internal portals

where only **read operations** are required.

---

# Why was it introduced?

Before Named Query API

```
External App
      │
      ▼
Apex REST Class
      │
      ▼
Business Logic
      │
      ▼
SOQL
      │
      ▼
Salesforce
```

Developer responsibilities

- Write Apex
- Deploy Apex
- Maintain Apex
- Write Test Classes
- Maintain APIs

---

With Named Query API

```
External App
      │
      ▼
Named Query API
      │
      ▼
SOQL
      │
      ▼
Salesforce
```

No Apex required.

---

# How Named Query API Works

Step 1

Create a Named Query

```
GetCustomerCases
```

Step 2

Write SOQL

```sql
SELECT Id,
       CaseNumber,
       Subject,
       Status
FROM Case
WHERE AccountId = :accountId
LIMIT :maxRecords
```

Step 3

Save it

Salesforce automatically creates a REST endpoint.

Step 4

External application calls

```
GET
/services/data/vXX.X/named-query/GetCustomerCases
```

Salesforce executes the query and returns JSON.

---

# Architecture

```
             Mobile App
                  │
                  │
          Agentforce
                  │
                  │
         Experience Cloud
                  │
                  ▼
          Named Query API
                  │
                  ▼
           Parameter Mapping
                  │
                  ▼
              SOQL Query
                  │
                  ▼
           Salesforce Database
                  │
                  ▼
            JSON Response
```

---

# Syntax

Basic query

```sql
SELECT Id,
       Name
FROM Account
```

---

With parameters

```sql
SELECT Id,
       Name
FROM Account
WHERE Industry = :industry
```

Notice

```
:industry
```

The colon (`:`) means

> This value will be provided during API execution.

---

# Understanding Parameters

Instead of

```sql
WHERE Industry = 'Technology'
```

write

```sql
WHERE Industry = :industry
```

API call

```
industry=Technology
```

Salesforce internally executes

```sql
WHERE Industry='Technology'
```

---

Multiple Parameters

```sql
SELECT Id,
       Name
FROM Account
WHERE Industry=:industry
AND Rating=:rating
```

API

```
industry=Technology
rating=Hot
```

---

LIMIT Parameter

```sql
LIMIT :maxRecords
```

API

```
maxRecords=10
```

---

Date Parameter

```sql
WHERE CreatedDate >= :startDate
```

API

```
startDate=2026-01-01
```

---

Number Parameter

```sql
WHERE AnnualRevenue > :minimumRevenue
```

---

LIKE Parameter

```sql
WHERE Name LIKE :accountName
```

API

```
accountName=A%
```

---

# Example 1

Retrieve Accounts

```sql
SELECT Id,
       Name,
       Industry
FROM Account
WHERE Industry=:industry
LIMIT :maxRecords
```

API

```
industry=Technology
maxRecords=5
```

---

# Example 2

Retrieve Contacts

```sql
SELECT FirstName,
       LastName,
       Email
FROM Contact
WHERE AccountId=:accountId
LIMIT :maxRecords
```

---

# Example 3

Retrieve Opportunities

```sql
SELECT Name,
       StageName,
       Amount
FROM Opportunity
WHERE StageName=:stageName
AND Amount>:minimumAmount
```

---

# Example 4

Retrieve Open Cases

```sql
SELECT Id,
       CaseNumber,
       Subject,
       Priority
FROM Case
WHERE Status='New'
AND AccountId=:accountId
LIMIT :maxRecords
```

---

# API Execution Flow

```
REST Request
      │
      ▼
Authentication
      │
      ▼
Authorization
      │
      ▼
Object Permission
      │
      ▼
Field Level Security
      │
      ▼
Record Level Sharing
      │
      ▼
Execute SOQL
      │
      ▼
JSON Response
```

---

# Security

This is one of the most important interview topics.

Many people think

> "Anyone can call the API and retrieve all records."

This is FALSE.

Named Query API always runs in the context of the authenticated user.

Salesforce automatically enforces

- Object Level Security (CRUD)
- Field Level Security (FLS)
- Record Level Sharing
- Organization-Wide Defaults
- Sharing Rules
- Role Hierarchy
- Experience Cloud Sharing

---

Example

Named Query

```sql
SELECT Id,
       CaseNumber
FROM Case
```

Support Agent

Can access

```
Case-001
Case-002
Case-003
Case-004
```

Customer Portal User

Can access only

```
Case-003
```

Even though both execute the exact same query.

---

# Can users manipulate parameters?

Suppose

```
accountId=001AAA
```

Someone changes it to

```
accountId=001XYZ
```

Will they see another customer's records?

No.

Salesforce still checks record-level sharing.

If they don't have access

```
No records returned
```

Changing parameters **does not bypass Salesforce security.**

---

# Authentication

Named Query API does NOT bypass Salesforce authentication.

The caller must authenticate using supported Salesforce authentication mechanisms (for example, OAuth access tokens or a valid Salesforce session).

Without authentication

```
401 Unauthorized
```

---

# JSON Response

Example

```json
{
  "records":[
      {
          "Id":"001XXXX",
          "Name":"Google",
          "Industry":"Technology"
      }
  ]
}
```

---

# Real-world Use Cases

## Agentforce

Retrieve customer information.

---

## Mobile Application

Show customer orders.

---

## Customer Portal

Display only logged-in customer's cases.

---

## Internal Dashboard

Retrieve Accounts

Retrieve Opportunities

Retrieve Cases

---

## External Integrations

Reporting systems

Analytics tools

CRM dashboards

---

# Named Query API vs Apex REST

| Feature | Named Query API | Apex REST |
|----------|----------------|-----------|
| Read Data | ✅ | ✅ |
| Insert Records | ❌ | ✅ |
| Update Records | ❌ | ✅ |
| Delete Records | ❌ | ✅ |
| Business Logic | ❌ | ✅ |
| Callouts | ❌ | ✅ |
| Dynamic SOQL | ❌ | ✅ |
| No Apex Required | ✅ | ❌ |
| Auto REST Endpoint | ✅ | ❌ |
| Test Class Required | ❌ | ✅ |

---

# Advantages

## Very little code

No Apex REST.

---

## Easy to maintain

Only modify SOQL.

---

## Reusable

One query

Many consumers

---

## Secure

Uses Salesforce security model.

---

## Faster Development

No deployment

No Apex

No Test Classes

---

## Great for Agentforce

Excellent for retrieving grounding data.

---

# Limitations

## Read Only

Cannot

- Insert
- Update
- Delete
- Upsert
- Merge

---

## No Apex Logic

Cannot

```apex
if()
else()
switch()
```

---

## No Loops

Cannot

```apex
for()
while()
```

---

## No External API Calls

Cannot call

- SAP
- AWS
- Stripe
- Google APIs
- REST APIs

---

## No Calculations

Cannot

```apex
Discount = Amount * .20;
```

---

## No Dynamic SOQL

Cannot

```apex
String objectName='Account';

SELECT ...
FROM objectName
```

Object names and selected fields are fixed when the query is defined.

---

## No Multiple Queries

Cannot

```
Query Accounts

↓

Query Contacts

↓

Query Opportunities
```

One Named Query represents one SOQL query.

---

## No Transactions

Cannot combine

Read

Update

Delete

Insert

---

## No Business Workflow

Cannot

```
If Opportunity Closed

↓

Create Case

↓

Send Email

↓

Call API
```

---

# Considerations

Use Named Query API when

✅ Read-only APIs

✅ Dashboards

✅ Agentforce

✅ Experience Cloud

✅ Mobile Apps

✅ External Reporting

---

Do NOT use Named Query API when

❌ Complex Business Logic

❌ Triggers

❌ Flows

❌ Integrations

❌ DML

❌ Async Processing

❌ Platform Events

❌ Queueables

❌ Batch Apex

---

# Best Practices

Use descriptive query names

Good

```
GetCustomerCases
```

Bad

```
Query1
```

---

Always use parameters

Good

```sql
WHERE Industry=:industry
```

Avoid hardcoding

```sql
WHERE Industry='Technology'
```

---

Only select required fields

Good

```sql
SELECT Name,
       Industry
```

Avoid

```sql
SELECT *
```

(SOQL doesn't support `SELECT *`, and you should explicitly request only the fields you need.)

---

Use LIMIT whenever possible

```sql
LIMIT :maxRecords
```

Avoid returning thousands of rows unnecessarily.

---

Never expose unnecessary fields

Avoid

- SSN
- Salary
- Internal Notes
- Sensitive Information

---

Use meaningful parameter names

Good

```
accountId
```

Bad

```
x
```

---

# Common Mistakes

Using hardcoded values

Wrong

```sql
Industry='Technology'
```

Better

```sql
Industry=:industry
```

---

Trying to update records

Impossible.

Named Query API is read-only.

---

Expecting Apex functionality

Named Query API only executes SOQL.

---

Ignoring sharing

Named Query API always respects Salesforce security.

---

Returning too much data

Avoid querying thousands of records unnecessarily.

---

# Interview Questions

## What is Named Query API?

Named Query API exposes predefined SOQL queries as REST endpoints without requiring Apex REST classes.

---

## Why use Named Query API?

To retrieve Salesforce data through REST with less code and built-in security.

---

## Does it require Apex?

No.

---

## Can it update records?

No.

Read only.

---

## Does it support CRUD?

Only Read.

---

## Does it respect sharing?

Yes.

It respects

- Object Permissions
- Field Level Security
- Record Level Sharing

---

## Can users bypass security by changing parameters?

No.

Salesforce still checks permissions before returning records.

---

## Can it replace Apex REST?

Only for simple read operations.

Anything involving business logic, DML, callouts, orchestration, or complex processing still requires Apex REST (or another appropriate Salesforce API).

---

## When should you choose Apex REST instead?

When you need

- Business Logic
- Multiple SOQL Queries
- DML
- Callouts
- Integrations
- Dynamic SOQL
- Complex Processing

---

# Summary

Named Query API is a low-code feature that exposes predefined SOQL queries as secure REST endpoints. It is ideal for read-only integrations, Agentforce, Experience Cloud, dashboards, and mobile applications.

### Key Takeaways

- Exposes SOQL as REST
- No Apex REST class required
- Read-only
- Supports parameterized queries
- Automatically enforces Salesforce security
- Great for Agentforce and integrations
- Cannot perform DML or business logic
- Best suited for fast, secure data retrieval
