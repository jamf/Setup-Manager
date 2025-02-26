# Webhooks

#### `webhooks`

(Dict, optional)

Setup Manager can send webhooks to inform other services of its status. The configuration for the webhooks in all stored under the top-level `webhooks` key.

The webhooks dict can contain two keys, both of which are again dicts. `started` defines the webhook or webhooks that are called when Setup Manager starts its workflow, and the other `finished` defines the webhook or webhooks when it finishes the workflow.

When the either the `started` or `finished` key is missing, no webhook will be sent for that event.

Example:

```xml
<key>webhooks</key>
<dict>
  <key>finished</key>
  <string>https://example.com/webhook-finish</string>
  <key>started</key>
  <string>https://example.com/webhook-start</string>
</dict>
```

### Multiple webhooks

You can send multiple services per event:

```xml
<key>webhooks</key>
<dict>
  <key>finished</key>
  <array>
    <string>https://example.com/webhook-finish</string>
    <string>https://otherservice.com/abc123456</string>
  </array>
  <key>started</key>
  <array>
    <string>https://example.com/webhook-start</string>
    <string>https://otherservice.com/abc123456</string>
  </array>
</dict>
```

### WebHook Data

For the `started` webhook, Setup Manager attaches this data:

```json
{
  "name": "Started",                     // string
  "timestamp": "2025-01-14T15:11:28Z",   // time setup manager started, date as string, iso8601
  "started": "2025-01-14T15:11:27Z",     // time webhook was sent, date as string, iso8601 
  "modelName": "MacBook Air",            // string
  "modelIdentifier": "Mac14,2",          // string
  "macOSBuild": "24C101",                // string
  "macOSVersion": "15.2.0",              // string
  "serialNumber": "ABCD1234DE",          // string
  "setupManagerVersion": "1.2"           // string
  "jamfProVersion": "11.13.0"            // optional, only for Jamf Pro, string
  "jssID": 1234                          // optional, only when `jssID` is set in profile, string
}
```

The data for the `finished` webhook includes the same as above, with some additional fields:

```json
{
  "name": "Finished",                    // string
  "duration": 53,                        // integer
  "finished": "2025-01-14T15:12:20Z",    // time Setup Manager finished, date as string, iso8601
  "computerName": "Mac-123456"           // computer name, only when set through Setup Manager
  "userEntry": {                         // data entered by the user
    "department": "IT",
    "computerName": "IT-ABC123",
    "userID": "a.b@example.,com",
    "assetTag": "abc54321"
  },
  "enrollmentActions": [                 // array of enrollmentActions with status
    {
      "label": "Microsoft 365",
      "status": "finished"               // status: "finished" or "failed"
    },
    {
      "label": "Google Chrome",
      "status": "finished"
    },
    {
      "label": "Jamf Connect",
      "status": "finished"
    },
  ],
}
```

### Microsoft Teams

When you set up [an incoming webhook workflow with Microsoft Teams](https://support.microsoft.com/en-us/office/create-incoming-webhooks-with-workflows-for-microsoft-teams-8ae491c7-0394-4861-ba59-055e33f75498) the json payload is expected in a certain format. 

**Important Note:** _The Teams Workflow Webhook URL will contain ampersands `&`. Since configuration profiles are XML files, you need to escape/replace all ampersands in the URL with the XML escape sequence `&amp;`._

Use this webhook format in the Setup Manager profile:

```xml
<dict>
  <key>kind</key>
  <string>teams</string>
  <key>url</key>
  <string>--insert url from Teams Workflows here--</string>
</dict>
```

This `dict` replaces the simple `string` syntax.
