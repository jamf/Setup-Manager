# Localization

The app will pick up the user choice of the UI language for the interface elements. (Table of currently available languages below.) The app will fall back to English for other language choices.

You can provide localizations for the custom texts given in the configuration profile. 

To provide a set of localizations for a value in the profile, change its type from `string` to `dict`. Inside the `dict`, provide a value for each localization for each localization with the language code as key.

For example, this unlocalized key-value pair

```xml
<key>title</key>
<string>Welcome!</string>
``` 

can be localized like this:

```xml
<key>title</key>
<dict>
  <key>en</key>
  <string>Welcome!</string>
  <key>de</key>
  <string>Willkommen!</string>
  <key>fr</key>
  <string>Bienvenue!</string>
  <key>nl</key>
  <string>Welkom!</string>
</dict>
```

When there is no value for the localization, the app will fall back to the value of the `en` key.

The following keys can be localized:

#### Top-level keys

- `title`
- `message`
- `icon`
- `background`
- `banner`
- `startingMessage`
- `finishedMessage`

#### Actions

- `label`
- `icon`

#### User Entry

- `default`
- `placeholder`
- `validationMessage`
- `label`
- `icons.label`
- `icons.icon`

#### Help

- `title`
- `message`
- `url`

#### Network Check

- `label`

Use these codes for these languages:

| Language             | Native Name         |  code           |
|----------------------|---------------------|-----------------|
| English              | English             | en (default)    |
| English (UK)         | English (UK)        | en-GB           |
| Bulgarian            | Български           | bg              |
| Chinese (Taiwan)     | 繁體中文             | zh-TW           |
| Chinese (simplified) | 简体中文             | zh-Hans         |
| Chinese (traditional)| 繁體中文             | zh-Hant         |
| Danish               | Dansk               | da              |
| Dutch                | Nederlands          | nl              |
| Finnish              | Suomi               | fi              |
| French               | Français            | fr              |
| German               | Deutsch             | de              |
| Hebrew               | עברית               | he              |
| Hindi                | हिन्दी                 | hi              |
| Italian              | Italiano            | it              |
| Japanese             | 日本語               | ja              |
| Korean               | 한국어                | ko              |
| Norwegian            | Norsk bokmål        | nb              |
| Polish               | Polski              | pl              |
| Portuguese (Brazil)  | Português (Brasil)  | pt-BR           |
| Portuguese           | Português           | pt-PT           |
| Spanish              | Español             | es              |
| Swedish              | Svenska             | sv              |
| Turkish              | Türkçe              | tr              |
| Ukrainian            | Українська          | uk              |

The [plist and profile example files](../Examples) contain localizations for many of the custom text elements.


#### Deprecation notice
 
The method for providing localized texts in the configuration profile changed in version 1.1. The previous method (by appending the two letter language code to the key) is considered deprecated. It will continue to work for the time being but will be removed in a future release. It is _strongly_ recommended to change to the new dictionary-based solution.
