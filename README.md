# AccountManagementRestService

## Overview

The `AccountManagementRestService` is a custom Apex REST service that provides a structured response containing:

- Accounts filtered by Industry
- Related Contacts
- Related Cases

This class is useful for integrations where external systems need to fetch detailed information about Accounts and their related records in a single API call.

## Endpoint


## Response Structure

The API returns a JSON object with the following structure:

```json
{
  "accList": [
    {
      "Id": "001...",
      "Name": "Acme Inc",
      "Industry": "Technology",
      "Rating": "Hot",
      "AnnualRevenue": 5000000.00
    }
  ],
  "conList": [
    {
      "Id": "003...",
      "FirstName": "John",
      "LastName": "Doe",
      "Email": "john.doe@example.com",
      "AccountId": "001..."
    }
  ],
  "caseList": [
    {
      "Id": "500...",
      "CaseNumber": "00001001",
      "Priority": "High",
      "Subject": "Login issue",
      "AccountId": "001..."
    }
  ]
}
