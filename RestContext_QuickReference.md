🚀 What is RestContext?
RestContext is a built-in Apex class that provides access to the incoming HTTP request and outgoing HTTP response when using @RestResource.

✅ Syntax
RestRequest req = RestContext.request;

RestResponse res = RestContext.response;

Imagine your Apex class is like a receptionist at a company. When someone (like a client app or Postman) sends an HTTP request, the receptionist:
Reads the request (what the person wants).
Prepares a response (a reply to send back).

In Apex, RestContext is like the receptionist’s desk — it holds both:
RestContext.request → The incoming message from the visitor (the HTTP request).
RestContext.response → The outgoing reply you send back (the HTTP response).

🔹 RestRequest – Gives you details about the incoming HTTP Request.

| Property / Method     | Purpose (Simple)                                 | Example Usage                                      |
| --------------------- | ------------------------------------------------ | -------------------------------------------------- |
| `RestContext.request` | Get the current HTTP request                     | `RestRequest req = RestContext.request;`           |
| `req.params`          | Query parameters from the URL (`?key=value`)     | `String id = req.params.get('id');`                |
| `req.requestBody`     | Full body content of the request                 | `String body = req.requestBody.toString();`        |
| `req.httpMethod`      | HTTP method used (GET, POST, etc.)               | `String method = req.httpMethod;`                  |
| `req.headers`         | Access custom or standard HTTP headers           | `String token = req.headers.get('Authorization');` |
| `req.requestURI`      | Full URL path including `/services/apexrest/...` | `String fullPath = req.requestURI;`                |
| `req.requestPath`     | Path without query params                        | `String path = req.requestPath;`                   |


🔸 RestResponse – Used to send a custom response back to the caller.

| Property / Method      | Purpose (Simple)                                | Example Usage                                        |
| ---------------------- | ----------------------------------------------- | ---------------------------------------------------- |
| `RestContext.response` | Access the current HTTP response                | `RestResponse res = RestContext.response;`           |
| `res.statusCode`       | Set the HTTP status code (e.g., 200, 400, etc.) | `res.statusCode = 200;`                              |
| `res.responseBody`     | Set the body of the response (text, JSON, etc.) | `res.responseBody = Blob.valueOf('Done');`           |
| `res.addHeader()`      | Add a custom header to the response             | `res.addHeader('Content-Type', 'application/json');` |


✅ Example Usage in Apex REST Class

@RestResource(urlMapping='/myEndpoint/*')
global with sharing class MyApi {
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String body = req.requestBody.toString(); // Request body
        res.statusCode = 201; // Created
        res.responseBody = Blob.valueOf('Item created');
    }
}


💡 Tips
Use JSON.deserialize() to convert request body JSON into Apex objects.
Always validate req.params.get() values to avoid null errors.
Set proper res.statusCode to indicate success (200/201) or failure (400/500).
