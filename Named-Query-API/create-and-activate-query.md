---

# Creating a Named Query API

## Prerequisites

Before creating a Named Query API, ensure that:

- You have the appropriate permissions to create Named Queries.
- The objects and fields you want to query are accessible.
- The users who will call the API have the required object, field, and record permissions.
- API access is enabled for the calling user.

---

# Step 1: Open Setup

1. Log in to Salesforce.
2. Click **Setup** (⚙️).
3. Search for **Named Queries** in the Quick Find box.
4. Open **Named Queries**.

---

# Step 2: Create a New Named Query

Click **New**.

Provide the following information:

| Field | Example |
|--------|----------|
| Name | GetAccountCases |
| API Name | GetAccountCases |
| Description | Returns cases related to an Account |

---

# Step 3: Write the SOQL Query

Example:

```sql
SELECT Id,
       CaseNumber,
       Subject,
       Status,
       Priority,
       CreatedDate
FROM Case
WHERE AccountId = :accountId
ORDER BY CreatedDate DESC
LIMIT :maxRecords
```

---

# Step 4: Define Parameters

Salesforce detects parameters prefixed with `:`.

For the above query, the parameters are:

| Parameter | Type |
|-----------|------|
| accountId | ID |
| maxRecords | Number |

These values are supplied by the API caller at runtime.

---

# Step 5: Validate the Query

Use the validation option (if available in your org) to verify:

- The SOQL syntax is correct.
- All referenced objects and fields exist.
- Parameter names are valid.

Fix any errors before saving.

---

# Step 6: Save the Named Query

Click **Save**.

The Named Query is now created in Salesforce.

---

---

# Activating a Named Query API

Creating a Named Query does **not** automatically make it available to API consumers. It must be published through the **API Catalog**.

## Step 1: Open Setup

- Go to **Setup**.
- In the **Quick Find** box, search for **API Catalog**.
- Open **API Catalog**.

---

## Step 2: Locate Your Named Query

- In the API Catalog, find the **Named Queries** section.
- Locate the Named Query you created (for example, `GetAccountCases`).

---

## Step 3: Activate the Named Query

- Open the Named Query.
- Click **Activate** (or **Publish**, depending on your Salesforce release).
- Confirm the activation.

Once activated, the Named Query becomes available for API consumers.

---

## Step 4: Invoke the API

After activation, authenticated applications can invoke the Named Query endpoint by supplying the required parameters.

Example:

```
GET /services/data/vXX.X/named-query/GetAccountCases?accountId=001XXXXXXXXXXXX&maxRecords=10
```

Salesforce then:

1. Authenticates the caller.
2. Validates the input parameters.
3. Applies object permissions.
4. Applies field-level security.
5. Applies record-level sharing.
6. Executes the SOQL query.
7. Returns the matching records as JSON.
