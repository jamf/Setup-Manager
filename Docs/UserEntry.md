#  User Entry
When a `userEntry` key is present and configured correctly, a sheet with fields for user entry will be shown when Setup Manager starts processing the `enrollmentAction`. The values of the fields the user enters will be written to the user data file and sent in the userEntry and finished webhooks.
Setup Manager 1.5 introduces a new schema in the configuration profile to configure the user entry. It uses an ordered `array` of `dicts` to define the user entry fields. Each field has a unique `identifier` value which is used to to identify the value in the user data field and webhooks. There are a list of special identifiers that will be submitted to Jamf Pro on a recon.

### User Data file
Data from user entry is written, together with  other data to a file when Setup Manager reaches a `waitForUserEntry` action and again when it finishes. The file is stored at `/private/var/db/SetupManagerUserData.txt`. [More details.](Extras.md#user-data-file)

### Jamf Pro: recon backed fields
Certain user entry fields will be submitted to and updated in Jamf Pro on the next recon performed by Setup Manager, either during `waitForUserEntry` or in the finishing phase. These fields have to use specific identifiers:

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

The identifiers are all case-sensitive.

### Computer Name
`computerName` is a special case, which will also set the computer name and, on Jamf Pro, update the computer name during the next recon, usually in `waitForUserEntry` or during the finishing phase.

When a `computerNameTemplate` is set, a `computerName` item in the user entry is ignored and not shown to the user. The computer name will be generated from the template.

If the `computerName` field is cleared, Setup Manager will not rename the Mac.

### Conditionally show the user entry for certain users
With the top-level [`enrollmentUserID`](../ConfigurationProfile.md#enrollmentuserid) and [`showUserEntryForUserIDs`](../ConfigurationProfile.md#showuserentryforuserids) keys you can restrict the user entry to certain users.

## Keys

#### `userEntry`

(Array of Dicts (v1.5+), optional)

When this key exists, Setup Manager will prompt for user data while the enrollment actions are running. 

Example:

```xml
<key>userEntry</key>
<array>
  <dict>
    <key>identifier</key>
    <string>userID</string>
    <key>placeholder</key>
    <string>first.last@example.com</string>
  </dict>
  <dict>
    <key>identifier</key>
    <string>assetTag</string>
    <key>placeholder</key>
    <string>Enter an Asset Tag</string>
    <key>validation</key>
    <string>.+</string>
    <key>validationMessage</key>
    <string>Asset Tag is required</string>
  </dict>
  <dict>
    <key>identifier</key>
    <string>role</string>
    <key>label</key>
    <dict>
      <key>de</key>
      <string>Rolle</string>
      <key>en</key>
      <string>Role</string>
    </dict>
    <key>options</key>
    <array>
      <string>Basic</string>
      <string>Finance</string>
      <string>Developer</string>
    </array>
  </dict>
</array>
```

Each item of the array is a `dict` representing an entry field in the interface and a value in the user data text file and the webhooks. The order of the items in the array is preserved in the user interface and the user data text file.

Each field has the following keys: 

#### `identifier`

(String, required, unique)

Used to identify the value entered or saved into the user field in the text file and webhooks. When more than one user entry field have the same value for `identifier` , only the first one will be used, subsequent items will be ignored.
Certain values for the identifier (`computerName` and the list shown above for Jamf Pro recon backed fields) will have additional behaviors. The `identifier` value is case-sensitive.
The identifier may not be empty. While the identifier can contain special characters, whitespace and colon `:`, it is recommended to avoid those characters as they might make parsing the user data text file or webhook data difficult.
it is also recommended to avoid the following identifiers, as they are used for other values and substitutions:
- `model`
- `model-short`
- `enrollmentUserID`
- `udid`

#### `label`

(String, localized, optional)

Setup Manager contains localized labels for the standard Jamf recon backed fields and `computerName`. You can use this key to override the Setup Manager default or provide a localized label for a custom user entry field.

Many Jamf Pro admins use the standard fields in ways that don't match their built-in label. For this purpose you can override the default label shown for a field in the user entry.

The text label in the [User Data file](Extras.md#user-data-file) and the key in the webhook will be the `identifier` not the `label`.

Example:

```xml
<dict>
  <key>identifier</key>
  <string>room</string>
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

In this example, the 'Room' field will be shown in Setup Manager with the label 'Site.' The choice will be submitted  to the 'room' field in Jamf Pro inventory and written with the 'room' label to the [User data file](Extras.md#user-data-file). You can then pick up the data in policy scripts after Setup Manager is finished or the `waitForUserEntry` action and process it accordingly.

#### `default`

(String, localized, substitutions, optional)

The default value which is pre-filled into the entry field.

Example:

```xml
<dict>
  <key>identifier</key>
  <string>assetTag</string>
  <key>default</key>
  <string>ABC12345</string>
</dict>
```

The default value can contain [substitutions](../ConfigurationProfile.md#substitution), e.g.:

```xml
<dict>
  <key>identifier</key>
  <string>computerName</string>
  <key>default</key>
  <string>%model-short%-%serial:=6%</string>
</dict>
```

#### `placeholder`

(String, localized, substitutions, optional)

This will show the string value given as a greyed out placeholder in the empty text field.

```xml
<dict>
  <key>identifier</key>
  <string>assetTag</string>
  <key>placeholder</key>
  <string>ABC12345</string>
</dict>
```

Note: a `default` value will prevent the placeholder from appearing, unless the user actively deletes the contents of a field.

#### `options`

(Array of Strings, optional)

This will show a popup list of preset options:

```xml
<dict>
  <key>identifier</key>
  <string>department</string>
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

#### `icons`

(Array of Dicts, optional)

This will show a horizontal list of icons with labels. The user can click on one to select it.

Each `dict` in the `array` has the following keys:

##### `identifier

(String, required)

The value represented by this icon. Must be unique within the array. This is the value the user field will receive when it is selected.

##### `icon`

(String, required, localized, dark mode)

Icon source to be used for the icon for this option. icons will be scaled to fit 100x100 pixels (200x200 @2x)

#### `label`

(String, optional, localized, default: value of `identifier`)

The text label shown under the icon, max two lines of text. Will default to the value of `identifier` when missing.

Example:

In the example below, when the user selects the icon labeled 'Minimal (Fast)', the value of the user field will be 'minimal' (the `identifier`) in the webhook and user data text file.

```xml
<key>icons</key>
<array>
  <dict>
    <key>icon</key>
    <string>symbol:shippingbox</string>
    <key>identifier</key>
    <string>minimal</string>
    <key>label</key>
    <dict>
      <key>de</key>
      <string>Minimal (Schnell)</string>
      <key>en</key>
      <string>Minimal (Fast)</string>
    </dict>
  </dict>
  <dict>
    <key>icon</key>
    <string>symbol:truck.box</string>
    <key>identifier</key>
    <string>recommended</string>
    <key>label</key>
    <dict>
      <key>de</key>
      <string>Empfohlen</string>
      <key>en</key>
      <string>Recommended</string>
    </dict>
  </dict>
  <dict>
    <key>icon</key>
    <string>symbol:truck.box.badge.clock</string>
    <key>identifier</key>
    <string>all</string>
    <key>label</key>
    <dict>
      <key>de</key>
      <string>Alles (Langsam)</string>
      <key>en</key>
      <string>Everything (Slow)</string>
    </dict>
  </dict>
</array>
```

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
<dict>
  <key>identifier</key>
  <string>userID</string>
  <key>placeholder</key>
  <string>first.last@example.com</string>
  <key>validation</key>
  <string>\S+\.\S+\@example\.com</string>
</dict>
```

#### `validationMessage`

(String, localized, substitutions, optional)

The default validation message will show the regular expression the value is not matching. This is suitable for debugging but not at all user friendly. You really should provide a localized message explaining how the entry should conform.

```xml
<dict>
  <key>identifier</key>
  <string>assetTag</string>
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
