# User Entry: Legacy format
Setup Manager v1.4.7 and earlier use a different schema for the `userEntry` settings. Setup Manager 1.5 will still be able to read the old schema. The old schema is more limited and it is strongly recommended to move to the new schema with Setup Manager 1.5 described [here](UserEntry.md).
You can enable user entry for the following fields:

- `userID`
- `email`
- `endUsername` (shown as 'Account Name')
- `realname` (shown as 'Full Name')
- `position`
- `phone`
- `department`
- `building`
- `room`
- `assetTag`
- `computerName`

Any of the fields will only be shown when its key exists. If you were to create an empty `userEntry` dict, you get an empty user input screen with a 'Save' button - not a good user experience.

For each field, you need to provide at least one of `default`, `placeholder`, or `options`.

`userID` and `email` can be somewhat confusing and depending on which Cloud directory you have configured in Jamf Pro, you may need one or the other or both. Because of this Setup Manager 1.1 and older would only prompt for 'User email' and set both `userID` and `email` from that value. To maintain compatibility with this behavior, Setup Manager will continue to set _both_ `userID` and `email` when only one of the two values is requested and entered. If you request both fields, both will be set individually in the recon.



### Keys

#### `default`

(String, localized)

Provide a default value in one of two ways:

Example:

```xml
<key>computerName</key>
<string>Mac-12345</string>
```

Use this simple `string` form, when all you need is the field with a default value filled in. Leave the `string` value empty if you don't even want a default value.

When you want to configure other options of the field, you need to use the `dict` form:

Example:

```xml
<key>computerName</key>
<dict>
  <key>default</key>
  <string>ABC12345</string>
  <key>validation</key>
  <string>[A-Z]{3}\d{5}</string>
</dict>
```


#### `placeholder`

(String, localized)

This will show the string value given as a greyed out placeholder in the empty text field.

```xml
<key>assetTag</key>
<dict>
  <key>placeholder</key>
  <string>ABC12345</string>
</dict>
```

Note: a `default` value will prevent the placeholder from appearing, unless the user actively deletes the contents of a field.

#### `options`

(Array of Strings, optional)

This will show a popup list of preset options:

```xml
<key>department</key>
<dict>
  <key>options</key>
  <array>
    <string>IT</string>
    <string>Sales</string>
    <string>R&amp;D</string>
  </array>
</dict>
```

The first option is the default selection.

Note: since we want to avoid having to provide Jamf Pro API credentials to Setup Manager, JSM does _not_ read the list of  buildings or departments from Jamf and you will have to transcribe them into the profile. Annoying, but the lesser of two evils, here.

#### `validation`

(String, optional)

The value of this key is a regular expression string. When the expression matches the entire string entered, it validates. For example, a `validation` of `[A-Z]{3}\d{5}` will match three uppercase letters (`[A-Z]{3}`) and then five numbers (`\d{5}`).

Some useful regular expressions:

- `.+`: at least one character (i.e. not empty)
- `[a-z]{7}`: exactly seven lowercase letters
- `\d{3,5}`: three to five digits (numbers)
- `\S+\@(example\.com|example.org)`: email ending with `example.com` or `example.org`

Detailed description of the regular expression syntax: [NSRegularExpression](https://developer.apple.com/documentation/foundation/nsregularexpression)

Example:

```xml
<key>userID</key>
<dict>
  <key>placeholder</key>
  <string>first.last@example.com</string>
  <key>validation</key>
  <string>\S+\.\S+\@example\.com</string>
</dict>
```

#### `validationMessage`

(String, optional, localized)

The default validation message will show the regular expression the value is not matching. This is suitable for debugging but not at all user friendly. You really should provide a localized message explaining how the entry should conform.

```xml
<key>assetTag</key>
<dict>
  <key>placeholder</key>
  <string>ABC12345</string>
  <key>validation</key>
  <string>[A-Z]{3}\d{5}</string>
  <key>validationMessage</key>
  <dict>
    <key>en</key>
    <string>Asset Tag needs to be of format 'ABC12345'</string>
    <key>de</key>
    <string>Etikett Nummer muss im Format 'ABC12345' sein</string>
    <key>fr</key>
    <string>L'étiquette d'actif doit être au format 'ABC12345'</string>
    <key>nl</key>
    <string>Asset Tag moet het formaat 'ABC12345' hebben</string>
  </dict>
</dict>
```

#### `label`

(String, localized, optional)

Many Jamf Pro admins use the standard fields in ways that don't match their built-in label. For this purpose you can override the default label shown for a field in the user entry.

Note that the text label in the [User Data file](Docs/Extras.md#user-data-file) will _not_ be changed.

Example:

```xml
<key>room</key>
<dict>
  <key>label</key>
  <string>Site</string>
  <key>options</key>
  <array>
    <string>London</string>
    <string>Paris</string>
    <string>Amsterdam</string>
  </array>
</dict>
```

In this example, the 'Room' field will be shown in Setup Manager with the label 'Site.' The choice will be submitted  to the 'room' field in Jamf Pro inventory and written with the 'room' label to the [User data file](Docs/Extras.md#user-data-file). You can then pick up the data in policy scripts after Setup Manager is finished or the `waitForUserEntry` action and process it accordingly.

### Conditionally show the user entry for certain users

You can configure Setup Manager to only show the user entry section when specified users have authenticated in enrollment customization. This enables workflows, where certain users (techs and admins) get the option to re-assign the device to another user, but other users don't see the option.

For this, you need to setup the top-level `enrollmentUserID` to receive the `$EMAIL` variable. This will communicate to SetupManager the user who logged in with customized enrollment. Then you add key `showForUserIDs` with an array of user emails to the `userEntry` dict. When both `enrollmentUserID` and `userEntry.showForUserIDs` are set, the user entry UI will only show for the listed users.

#### `showForUserIDs`

(Array of Strings, optional)

Example:

```xml
<key>userEntry</key>
<dict>
  <key>showForUserIDs</key>
  <array>
    <string>a.b@example.com</string>
    <string>m.b@example.com</string>
    <string>r.p@example.com</string>
  </array>
  <key>userID</key>
  <dict>
    <key>placeholder</key>
    <string>first.last@example.com</string>
    <key>validation</key>
    <string>\S+\.\S+@example.com</string>
  </dict>
</dict>
<key>enrollmentUserID</key>
<string>$EMAIL</string>
```
