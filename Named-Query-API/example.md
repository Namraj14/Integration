
# Passing Parameters to a Named Query API

Named Query APIs accept input values as **URL query parameters**.

Each URL parameter is automatically mapped to the corresponding parameter in the SOQL query.

For example, consider the following Named Query: Returning list of cases related to an account

```sql
SELECT Id,
       CaseNumber,
       Subject,
       Priority
FROM Case
WHERE Account.Name = :accountname
AND Priority = :priority
LIMIT :maxrecords
```

The query contains three parameters:

- `:accountname`
- `:priority`
- `:maxrecords`

These values are supplied by the API caller in the request URL.

---

# Correct API Request

```http
GET /services/data/v65.0/named/query/GetRelatedCasesforAccounts?accountname=Burlington%20Textiles%20Corp%20of%20America&maxrecords=2&priority=High
```

> **Note:** Spaces in URLs must be URL-encoded as `%20`. Most API clients like Postman automatically perform this encoding.

---

# Incorrect API Request

```http
GET /services/data/v65.0/named/query/GetRelatedCasesforAccounts?accountname=Burlington Textiles Corp of America&maxrecords=2&priority='High'
```

### Issues

- ❌ Spaces are not URL-encoded.
- ❌ String values should **not** be enclosed in single quotes (`'High'`).

---

# Parameter Mapping

| URL Parameter | Named Query Parameter |
|---------------|-----------------------|
| `accountname=Burlington Textiles Corp of America` | `:accountname` |
| `priority=High` | `:priority` |
| `maxrecords=2` | `:maxrecords` |

Salesforce automatically maps the URL parameters to the corresponding SOQL parameters before executing the query.

---

# What Salesforce Executes Internally

When the request is:

```http
GET /services/data/v65.0/named/query/GetRelatedCasesforAccounts?accountname=Burlington%20Textiles%20Corp%20of%20America&maxrecords=2&priority=High
```

Salesforce internally executes a query similar to:

```sql
SELECT Id,
       CaseNumber,
       Subject,
       Priority
FROM Case
WHERE Account.Name = 'Burlington Textiles Corp of America'
AND Priority = 'High'
LIMIT 2
```

The caller does **not** include quotes in the URL. Salesforce treats the parameter values as the appropriate data type and binds them safely to the query.

---

# Rules for Passing Parameters

✅ Use parameter names that exactly match the Named Query.

Example:

```sql
:accountname
```

URL:

```
accountname=ABC Corp
```

---

✅ Do **not** wrap values in quotes.

Correct:

```
priority=High
```

Incorrect:

```
priority='High'
```

---

✅ URL-encode special characters.

Example:

```
ABC Company
```

becomes

```
ABC%20Company
```

---

✅ Numeric values should be passed without quotes.

Correct:

```
maxrecords=10
```

Incorrect:

```
maxrecords='10'
```

---

# Case Sensitivity

Parameter names should exactly match those defined in the Named Query.

Example:

```sql
:accountname
```

Correct:

```
accountname=ABC
```

Incorrect:

```
AccountName=ABC
```

or

```
accountName=ABC
```

Using consistent parameter names avoids mapping issues and follows Salesforce best practices.

---

# Best Practice

Whenever possible, use **AccountId** instead of **Account Name**.

Example:

```sql
WHERE AccountId = :accountId
```

instead of

```sql
WHERE Account.Name = :accountname
```

### Why?

- Account IDs are unique.
- IDs are indexed, making queries more efficient.
- Account names can change.
- Multiple Accounts can have the same name, which may return unexpected results.

Use Account Name only when your business requirement specifically requires searching by name.

---

# Understanding `%20` in URLs

When passing parameters in a URL, certain characters cannot be used directly. These characters must be **URL encoded**.

One of the most common URL-encoded characters is:

```
%20 = Space (" ")
```

This means every space in a URL is replaced with `%20`.

---

## Example

Normal text:

```text
Burlington Textiles Corp of America
```

URL-encoded text:

```text
Burlington%20Textiles%20Corp%20of%20America
```

Here, every `%20` represents a space.

---

## Why is URL Encoding Required?

URLs cannot contain plain spaces. If a URL contains spaces, it may not be interpreted correctly by browsers or servers.

❌ Incorrect

```http
GET /services/data/v65.0/named/query/GetRelatedCasesforAccounts?accountname=Burlington Textiles Corp of America
```

✅ Correct

```http
GET /services/data/v65.0/named/query/GetRelatedCasesforAccounts?accountname=Burlington%20Textiles%20Corp%20of%20America
```

---

## Common URL Encoded Characters

| Character | URL Encoded Value |
|-----------|-------------------|
| Space (` `) | `%20` |
| `@` | `%40` |
| `#` | `%23` |
| `&` | `%26` |
| `=` | `%3D` |
| `?` | `%3F` |
| `/` | `%2F` |
| `+` | `%2B` |

---

## Postman Behavior

When using **Postman**, you usually **do not need to manually type `%20`**.

If you enter:

```text
accountname = Burlington Textiles Corp of America
```

Postman automatically converts it to:

```text
accountname=Burlington%20Textiles%20Corp%20of%20America
```

before sending the request to Salesforce.

---

## Best Practice

- If you're manually constructing the URL, always URL-encode spaces and special characters.
- If you're using tools like **Postman**, **Insomnia**, or most programming libraries, URL encoding is handled automatically.

---

## Interview Question

### What does `%20` mean in a URL?

**Answer:**

`%20` is the URL-encoded representation of a **space character**. Since URLs cannot contain plain spaces, spaces are replaced with `%20` to ensure the URL is transmitted and interpreted correctly by web servers.
