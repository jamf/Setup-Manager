# Webhooks

#### `webhooks`

(Dict, optional)

Setup Manager can send webhooks to inform other services of its status. The configuration for the webhooks is all stored under the top-level `webhooks` key.

The webhooks dict can contain up to three keys, all of which are again dicts.

 - `started` defines the webhook or webhooks that are called when Setup Manager starts its workflow
 - `userEntry` defines the webhook or webhooks that are sent during a `waitForUserEntry` step (when present)
 - `finished` defines the webhook or webhooks when it finishes the workflow.

When any of the event keys are missing, no webhook will be sent for that event.

#### Example:

```xml
<key>webhooks</key>
<dict>
  <key>finished</key>
  <string>https://example.com/webhook-finish</string>
  <key>started</key>
  <string>https://example.com/webhook-start</string>
  <key>userEntry</key>
  <string>https://example.com/webhook-userEntry</string>
</dict>
```

## WebHook Data

The webhook data varies by event and some configurations:

| Key                 | started | userEntry | finished | Value type               | Example Value                        | Note                             |
|---------------------|---------|-----------|----------|--------------------------|--------------------------------------|----------------------------------|
| name                | √       | √         | √        | string                   | `Started`, `UserEntry`, or `Finished` |                                |
| event               | √       | √         | √        | string                   | `com.jamf.setupmanager.<name>`       |                                  |
| timestamp           | √       | √         | √        | date as string, iso-8601 | `2026-11-09T14:49:26Z`               | time webhook was sent            |
| started             | √       | √         | √        | date as string, iso-8601 | `2026-11-09T14:49:24Z`               | time Setup Manager started       |
| finished            |         |           | √        | date as string, iso-8601 | `2025-01-14T15:12:20Z`               | time Setup Manager finished      |
| duration            |         |           | √        | integer                  | `73`                                 | in seconds                       |
| modelName           | √       | √         | √        | string                   | `MacBook Pro`                        |                                  |
| modelIdentifier     | √       | √         | √        | string                   | `Mac16.8`                            |                                  |
| setupManagerVersion | √       | √         | √        | string                   | `1.5`                                |                                  |
| macOSVersion        | √       | √         | √        | string                   | `27.2.0`                             |                                  |
| macOSBuild          | √       | √         | √        | string                   | `26B123`                             |                                  |
| serialNumber        | √       | √         | √        | string                   | `ABCD1234DE`                         |                                  |
| computerName        | √       | √         | √        | string                   | `MacBook Pro`                        | computer name when webhook was sent |
| jamfProVersion      |        | *         | *        | string                   | `11.34.0`                            | optional, Jamf Pro only, when the version could be determined |
| computerID          | *       | *         | *        | string                   | `"1234"`                             | optional, when `computerID` is set in profile |
| enrollmentUserID    | *       | *         | *        | string                   | `username`                           | optional, when `enrollmentUserID` is set in profile |
| userEntry           |         | *         | *        | dictionary               | `{"field1": "value"}`                | optional, when `userEntry` is configured | 
| uploadThroughput    |         | *         | *        | integer                  |                                      | optional |
| downloadThroughput  |         | *         | *        | integer                  |                                      | optional |
| enrollmentActions   |         |           | √        | dictionary               | see below                            | dictionary for each action, label and status | 

Webhooks work with Jamf Pro and Jamf School. `jamfProVersion` is only sent for Jamf Pro.

### Examples:

Started Webhook:

```json
{
  "name": "Started",                        // string
  "event": "com.jamf.setupmanager.started", // string
  "timestamp": "2026-11-09T14:49:26Z",      // time webhook was sent, date as string, iso8601
  "started": "2026-11-09T14:49:24Z",        // time Setup Manager started, date as string, iso8601
  "modelName": "MacBook Pro",               // string
  "modelIdentifier": "Mac16,8",             // string
  "setupManagerVersion": "1.5",             // string
  "macOSBuild": "26B123",                   // string
  "computerName": "MacBook Pro",            // computer name when Setup Manager starts, string
  "macOSVersion": "27.2.0",                 // string
  "serialNumber": "ABCD1234DE",             // string
  "computerID": "1234",                     // optional, only when `computerID` is set in profile, string
  "enrollmentUserID": "username"            // optional, only when `enrollmentUserID` is set in profile, string
}
```

User Entry Webhook with a single custom userEntry field `install_type`:

```json
{
  "name": "Userentry",
  "event": "com.jamf.setupmanager.userentry",
  "timestamp": "2026-11-09T14:49:50Z",
  "started": "2026-11-09T14:49:24Z",
  "modelName": "MacBook Pro",
  "modelIdentifier": "Mac16,8",
  "setupManagerVersion": "1.5",
  "userEntry": {
    "install_type": "recommended"
  },
  "macOSBuild": "26B123",
  "jamfProVersion": "11.34.0",
  "uploadThroughput": 147642816,
  "enrollmentUserID": "username",
  "downloadThroughput": 872943680,
  "computerID": "1234",
  "serialNumber": "ABCD1234DE",
  "macOSVersion": "27.2.0",
  "computerName": "Mac-ABCD12"
}
```

The data for the `finished` webhook includes the same as above, with some additional fields:

```json
{
  "modelName": "MacBook Pro",
  "jamfProVersion": "11.34.0",
  "uploadThroughput": 147642816,
  "finished": "2026-11-09T14:50:38Z",
  "duration": 73,
  "timestamp": "2026-11-09T14:50:38Z",
  "serialNumber": "ABCD1234DE",
  "event": "com.jamf.setupmanager.finished",
  "computerID": "1234",
  "userEntry": {
    "install_type": "recommended"
  },
  "computerName": "Mac-ABCD12",
  "downloadThroughput": 872943680,
  "macOSVersion": "27.2.0",
  "enrollmentUserID": "username",
  "modelIdentifier": "Mac16,8",
  "name": "Finished",
  "enrollmentActions": [                    // array of enrollmentActions with status
    {
      "label": "Microsoft 365",
      "status": "finished"                  // status: "finished" or "failed"
    },
    {
      "label": "Google Chrome",
      "status": "finished"
    },
    {
      "label": "Jamf Connect",
      "status": "finished"
    }
  ],
  "started": "2026-11-09T14:49:24Z",
  "macOSBuild": "26B123",
  "setupManagerVersion": "1.5"
}
```


### Computer name

The `computerName` value is the computer name Setup Manager wants the Mac to have, if there is one, otherwise the Mac's current computer name at the time the webhook is sent. The requested name is reported as soon as it is known, even if it has not been applied to the Mac yet. The `computerName` is set during a `waitForUserEntry` action and during the 'Finishing' phase.

- when a [`computerNameTemplate`](../ConfigurationProfile.md#computernametemplate) is set, the requested name is generated from the template. A `computerName` field in `userEntry` is ignored, not shown to the user and not part of the `userEntry` dictionary
- otherwise, if the [user entry](UserEntry.md#computer-name) has a `computerName` field, the name entered by the user becomes the requested name. The field is also listed in the `userEntry` dictionary
- if there is no template and the `computerName` field is empty or missing, Setup Manager does not rename the Mac and `computerName` shows the Mac's current name

Because of this, the `started` webhook usually shows the name the Mac had when Setup Manager launched (or the name generated from `computerNameTemplate`), and the `userEntry` and `finished` webhooks show the name from the template or from the user entry.

## Microsoft Teams

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

## Slack

You can also [configure Slack to receive messages on webhook url](https://api.slack.com/messaging/webhooks).

Use this webhook format in the Setup Manager profile:

```xml
<dict>
  <key>kind</key>
  <string>slack</string>
  <key>url</key>
  <string>--insert url from Slack here--</string>
</dict>
```

## Multiple webhooks

You can send multiple services per event:

```xml
<key>webhooks</key>
<dict>
  <key>finished</key>
  <array>
    <string>https://example.com/webhook-finish</string>
    <dict>
      <key>kind</key>
      <string>teams</string>
      <key>url</key>
      <string>--insert url from Teams Workflows here--</string>
    </dict>
  </array>
  <key>started</key>
  <array>
    <string>https://example.com/webhook-start</string>
    <dict>
      <key>kind</key>
      <string>teams</string>
      <key>url</key>
      <string>--insert url from Teams Workflows here--</string>
    </dict>    
  </array>
</dict>
```

## Webhooks with authentication

When the webhook requires basic or header token authentication, use a `dict` instead of a `string`. The webhook url will be set with the `url` key.

For basic authentication, provide username and password with the `username` and `password` keys. For token header authentication, provide the token with a `token` key. For some token formats, you may have to prepend a `Bearer: ` or similar string before the token.

Example:

```xml
<key>webhooks</key>
<dict>
  <key>finished</key>
  <dict>
    <key>password</key>
    <string>123456</string>
    <key>url</key>
    <string>https://otherservice.com/basic-auth</string>
    <key>username</key>
    <string>user</string>
  </dict>
  <key>started</key>
  <dict>
    <key>token</key>
    <string>abcdefg123456789</string>
    <key>url</key>
    <string>https://yetanotherservice.com/token</string>
  </dict>
</dict>
```

In the above example, the `finished` webhook uses basic authentication. The `started` webhook uses a token.


## Webhooks in Debug mode

Webhooks are generally _not_ sent when `DEBUG` is set to true. However, if you set a `DEBUG` key to `true` _inside_ the `webhooks` dictionary, webhooks will be sent, even when global `DEBUG` is enabled.

## Logging

Since the webhook URLs may contain codes you don't necessarily want to share, only the url scheme, host, and port are printed in the log, unless the `DEBUG` key inside the `webhooks` dictionary is set to `true`.

Note that the full URL for the webhook will always be visible in the profile, which will be visible to every user on the device in System Settings or with other tools. If you want to prevent the user seeing the webhook urls, you need to remove the Setup Manager profile after enrollment (using smart group scoping) or use a middleware server to indirectly talk with the webhook service.
