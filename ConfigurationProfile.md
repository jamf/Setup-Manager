# Configuration Profile format

The project some sample files to get you started:
- [sample plist](Examples/sample-com.jamf.setupmanager.plist) for Jamf Pro
- [sample plist](Examples/sample-waitForUserEntry.plist) for Jamf Pro with [two phase workflow](Docs/JamfPro-TwoPhase.md)
- [configuration profile](Examples/sample-jamfschool.mobileconfig) for Jamf School

**Important:** all keys and values are **case-senstive**.

## Top-level keys

#### `DEBUG`

(Boolean, default: `false`)

When this is set to `true` any steps that actually change software on the disk will not be performed. This will also allow you to launch Setup Manager by double-clicking as the user. This can be useful to test a profile, or to take screenshots for documentation.

These behaviors change in debug mode: 
- checks for the existence of the Jamf binary and keychain are skipped
- Jamf Setup Manager will accept enrollmentActions from a non-managed preference file
- `policy`, `recon`, and `shell` actions that require root are replaced with a delay (and will always complete successfully)
- `watchPath` and `wait` actions timeout and fail after 10 seconds

When in debug mode, you can also set the `simulateMDM` preference key to `Jamf Pro` or `Jamf School`. This allows you to do test runs on un-enrolled Macs.

#### `title`

(String, default: `Welcome to Setup Manager`, localized, substitutions)

The main title over the window.

Example:

```xml
<key>title</key>
<string>Welcome to your new Mac!</string>
```

When `title` is empty or unset, the default message `Welcome to Setup Manager` will be shown, unless the `banner` set, when no title will be shown instead. This allows for a custom branded title and icon in the banner image.

#### `icon`

(String, default: `name:AppIcon`, localized, dark mode)

The icon shown at the top center of the window. There are many options to define icons, described in the [Icon Sources](#icon-sources) section later. Images will be scaled to fit a size of 700x128 pixels (or 1400x256 @2x).

When `icon` is empty or unset, Setup Manager will show the Setup Manager app icon, unless the `banner` is set, when no icon will be shown instead. This allows for a custom branded icon and title in the banner image.

#### `message`

(String, default: `Setup Manager is configuring your Mac…`, localized, substitutions, markdown)

The message shown below the title.

Example:

```xml
<key>message</key>
<string>Please wait a few moments while we install essential software…</string>
```

The message can use [substitutions](#substitution).

Example:

```xml
<key>message</key>
<string>Preparing your new %model%. Please be patient.</string>
```

Markdown formatting options in the message field will be translated into rich text:

Example:

```xml
<key>message</key>
<string>Preparing your new %model%. **Please be patient.**</string>
```

`Please be patient.` will be bold. More detail on [Markdown here](#markdown).

During the "Getting Ready" phase up to three lines of text will be shown. When the action icon progress list is shown, text will be truncated to a single line.

Use actual line breaks in the XML for line breaks in this text. (`\n` escape sequence will _not_ work in XML)

Example:

```xml
<key>message</key>
<string>Please be patient…

This line of text will be truncated when the action icon list is shown.</string>
```

#### `banner`

(String, optional, localized, dark mode, v1.4)

When this key is set, Setup Manager treats it as an image/[icon source](#icon-sources) and displays it as a banner image in the top area of the Setup Manager window, behind the `icon` and `title`. The banner area size is 800x233 pixels (1600x466 @2x) on Sequoia and earlier and 800x247 (1600x494 @2x) on Tahoe (the liquid glass toolbar on Tahoe is taller). The banner image will _not_ be scaled down to fit. The image will be displayed with bottom-center alignment, so you can add a extra pixels at the top and the same image should work for all macOS versions.

When the `banner` is set, and the `title` or `icon` are empty or unset, _neither_ title message _nor_ icon will be shown. This allows for customized branding of the title area with just the banner image. Note that you can localize banner image sources.

#### `background`

(String, optional, localized, dark mode)

When this key is set, Setup Manager treats it as an image/[icon source](#icon-sources) and displays the image in a screen covering background.

#### `runAt`

(String, optional, default: `enrollment`)

This value determines when Setup Manager should launch. There are two values: `enrollment` (default) and `loginwindow`. When set to `enrollment` Setup Manager will launch immediately when its installation package is installed. This is the setting to use for automated device enrollment (without Auto Advance) and user-initiated enrollment.

When the `runAt` value is set to `loginwindow` Setup Manager will launch only when the login window is shown. This is useful for fully automated enrollments using Auto Advance and some workflows involving Jamf Connect or similar tools.

A setting of `loginwindow` will only work with enrollment setups that eventually end on the login window (i.e. a user has to be created automatically, the device is bound to a directory, etc).

Example:

```xml
<key>runAt</key>
<string>loginwindow</string>
```

#### `enrollmentActions`

(Array of Dicts, required)

This array contains a list of `Dict`s which describe the individual actions to be performed in order. Actions are described in detail in the [Actions](#actions) section.

#### `userEntry`

(Dict of Dicts, optional)

When this key exists, Setup Manager will prompt for user data while the enrollment actions are running. The individual keys are described in [User Entry](#user-entry).

#### `help`

(Dict of Strings, optional)

When this key exists, Setup Manager will show a "Help" button (a circled question mark) in the lower right corner while it is running. You can add sub-keys with content for the help, which are described in [Help](#help-1). When Setup Manager has completed, the "Help" button will be replaced with the "Continue" and/or "Shutdown" button.

#### `accentColor`

(String or Dict, optional, localized, dark mode, default: system blue)

Sets the accent color for buttons, progress bar, SF Symbol icons, and other UI elements. You can use this to match branding. Color is encoded as a six digit hex code, e.g. `#FF0088`.

Example:

```xml
<key>accentColor</key>
<string>#FF00AA</string>
```

You can also use named system colors. (See ['Defining Colors'](#defining-colors) for a full list.)

Example:

```xml
<key>accentColor</key>
<string>##green</string>
```

If you want different accent colors depending on whether the system is in light or dark mode, provide a `dict` with two keys, for `light` and `dark` mode: (Note: named system colors adapt automatically)

Example:

```xml
<key>accentColor</key>
<dict>
  <key>dark</key>
  <string>#FF00AA</string>
  <key>light</key>
  <string>#AA0055</string>
</dict>
```

#### `tileColor`

(String or Dict, optional, localized, dark mode, default: `##background`, v1.4)

Sets the action tile background color for all action tiles, unless the value is overridden by an individual action's `tileColor` key. You can use [color designators](#defining-colors). See the action level [`tileColor`](#tilecolor-1) for details.

When you set the `tileColor` to `##automatic`, Setup Manager computes an average color from the tile's `icon`. For `symbol` icons, the default background will be used.

#### `finalCountdown`

(Number/integer, optional, default: `60`)

This key changes the duration (in seconds) of the "final countdown" before the app automatically performs the `finalAction`. Set to `-1` to disable automated execution.

Example:

```xml
<key>finalCountdown</key>
<integer>30</integer>
```

Disable the countdown: 

```xml
<key>finalCountdown</key>
<integer>-1</integer>
```

#### `finalAction`

(String, optional, default: `continue`)

This key sets the action and label for the button shown when Setup Manger has completed. 

There are four options:
- `continue`: (default) merely quits Setup Manager and allows the user to continue (probably Setup Assistant or login window)
- `restart`: restarts the Mac
- `shutdown`: (no space!) shuts down the Mac
- `none`: no button shown. (see note below)

**Warning:** `restart` and `shutdown` options will force their action immediately. If a user is logged in (after user-initiated enrollment), they may lose data from open, unsaved documents.

**Note on `none`:** the `none` option exists for workflows where the restart or continue is controlled by a process other than Setup Manager. For example, when installing additional software with a `finishedScript` or `finishedTrigger` which forces a restart. Having a `continue` or `restart` button would be confusing and might interrupt the installation in the finished process. However, having no button to end Setup Manager at all, might leave the user 'stuck' there, so be sure to always restart or kill Setup Manager. You can always use the keyboard shortcut `shift-control-command-E` to quit Setup Manager.

This is also the action that is performed when the `finalCountdown` timer runs out.

When the `DEBUG` preference is set, `shutdown` or `restart` will merely quit/continue.

Example:

```xml
<key>finalAction</key>
<string>shutdown</string>
```

#### `finishedScript`

(String, optional)

A full path to a script file which will be executed _after_ Setup Manager has finished its workflow. This process runs independently of Setup Manager, so it can run installers or scripts that affect Setup Manager.

The script has to fulfill these criteria to be executed:

- owner: `root`, group: `wheel`
- executable bit set
- not writable for group or other (file mode `755` or `555`)
- no quarantine flag attached

The output of the finished script and trigger will be logged to `/private/var/log/setupManagerFinished.log`.

Example:

```xml
<key>finishedScript</key>
<string>/Library/Management/finishedScript.sh</string>
```

#### `finishedTrigger`

(String, optional, Jamf Pro only)

A custom policy trigger which will be executed _after_ Setup Manager has finished its workflow. This process runs independently of Setup Manager, so it can run installers or scripts that affect Setup Manager.

The output of the finished script and trigger will be logged to `/private/var/log/setupManagerFinished.log`.

Example:

```xml
<key>finishedTrigger</key>
<string>setup_manager_finished</string>
```

#### `totalDownloadBytes`

(Integer, optional, default: 1000000000 or 1GB, v0.8)

Use this value to provide an estimate for the total size of all items that will be downloaded. Setup Manager will display an estimated download time for this sum in the "About this Mac..." popup window.

Example:

```xml
<key>totalDownloadBytes</key>
<integer>4500000000</integer>
```

#### `computerID`

(String, Jamf Pro only)

When filled with the correct payload variable, this provides the identifier for the computer to Setup Manager. It will be displayed in the in the 'About this Mac…' popup, when clicked with the option key.

For Jamf Pro, the value for `computerID` should be `$JSSID`. For Jamf School, it should be `%udid%.

Examples:

Jamf Pro:

```xml
<key>computerID</key>
<string>$JSSID</string>
```

Jamf School:

```xml
<key>computerID</key>
<string>%udid%</string>
```

Note: up to version 1.3, this key was called `jssID`. This was changed in v1.4 for Jamf School support. The old key `jssID` is deprecated.

#### `enrollmentUserID`

(String, Jamf Pro only)

Set this to `$EMAIL` in the configuration profile. This communicates the user who logged in to customized enrollment to Setup Manager. This can be used together with the [`userEntry.showForUserIDs`](#conditionally-show-the-user-entry-for-certain-users) key to control which users see the user entry UI.

Example:

```xml
<key>enrollmentUserID</key>
<string>$EMAIL</string>
```

Note: in Setup Manager v1.3 and earlier, this key was called `userID`. The name changed in v1.4 to avoid confusion with `userEntry.userID` which serves a different purpose and can have different values. The top-level `userID` key will keep working with the same function for now. If both keys are given, `enrollmentUserID` will take precedence. The top-level `userID` key will be removed in a future version.

#### `computerNameTemplate`

(String, Jamf Pro only, substitutions)

When this key is set, Setup Manager will generate the computer name from this template and set it automatically. When this key is present, a `computerName` dict or string in `userEntry` will be ignored.

The template uses substitution tokens, which begin and end with `%` character which will be substituted with data at run time. See [Substitutions](#substitution) for details.

Example:

```xml
<key>computerNameTemplate</key>
<string>Mac-%serial:=6%</string>
```

This will set the computer name to `Mac-DEF456` where `DEF456` are the center six characters of the serial number 

#### `overrideSerialNumber`

(String, optional)

When set, the "About this Mac" info window will show this value instead of the real serial number. This is useful when making screenshots or recordings for documentation or presentations where you do not want to expose real serial numbers.

Note: This is for display only. [Substitutions](#substitution) will still use the real serial number.

Example:

```xml
<key>overrideSerialNumber</key>
<string>ABC1DEFABC</string>
```

#### `hideActionLabels`

(Bool, optional, default: `false`)

Hides the individual labels under each action's icon.

Example:

```xml
<key>hideActionLabels</key>
<true/>
``` 

#### `hideDebugLabel`

(Bool, optional, default: `false`)

When set, suppresses display of the red 'DEBUG' label in debug mode. Useful for screenshots and recordings.

Example:

```
<key>hideDebugLabel</key>
<true/>
```

#### `simulateMDM`

(String, optional)

When debug mode is enabled, you can set the `simulateMDM` preference key to `Jamf Pro` or `Jamf School`. This allows you to do test runs on un-enrolled Macs.

#### `actionOutputLogging`

(string, optional, default: `error`)

This key controls whether the output of actions is written to the Setup Manager log file.

There are three options:
- `always`: output and exit code are always written to the log file
- `error`: (default) output and exit code are only written on errors
- `never`: output and exit are never written to the log file

Setup Manager's log window will always show the output, regardless of this setting.

Example:

```xml
<key>actionOutputLogging</key>
<string>always</string>
```

#### `networkQualityCheck`

(Bool, optional, default: `true`, v1.4)

Set this key to false to suppress the network quality check. This is useful in classroom or lab environments where multiple Macs are re-enrolled at similar times to protect network bandwidth.

Example:

```xml
<key>networkQualityCheck</key>
<false/>
```

#### `finishedMessage`

(String, optional, localized, substitutions, markdown, v1.4)

Custom message when Setup Manager workflow is complete.

Example: 

```xml
<key>finishedMessage</key>
<string>**Finished** – _Enjoy your %model%!_</string>
```

## Actions

All actions should have these keys:

#### `label`

(String, required, localized, substitutions)

The label is used as the name of the action in display.

#### `icon`

(String, optional, localized, dark mode)

The [icon source](#icon-sources) used for the display of the label. Different types of actions will have different default icons, which are used when no `icon` key is present. The icons will be scaled to fit 64x64 pixels (or 128x128 @2x).

There are several different types of actions, and these are defined by additional keys. These keys will be on the same level as the keys above.

#### `tileColor`

(String, optional, dark mode, v1.4)

This key sets this action's' background color. You can use [color designators](#defining-colors).

`tileColor` values set on individual actions will override the top-level `tileColor`.

Example: 

```xml
<key>tileColor</key>
<string>#FF00AA</string>
```

```xml
<key>tileColor</key>
<string>##gray</string>
```

Set the key to an empty value or `##background` to use the default window background color instead.


```xml
<key>tileColor</key>
<string/>
```

```xml
<key>tileColor</key>
<string>##background</string>
```

When you set the `tileColor` to `##automatic`, Setup Manager computes an average color from tile's `icon`. For `symbol` icons, the default background will be used.

```xml
<key>tileColor</key>
<string>##automatic</string>
```

Set `tileColor` to `##clear` to remove the tile background. This works best when `hideActionLabels` is set to false.

```xml
<key>tileColor</key>
<string>##clear</string>
<key>hideActionLabels</key>
<false/>
```

### Shell Command

#### `shell`

(String)

The path to the command or script that should be run for this action. You need to provide the absolute full path to the command, e.g. `/usr/bin/say`.

#### `arguments`

(Array of Strings, optional)

When the command given in `shell` requires arguments they are listed here, one item per argument. Do _not_ escape or quote spaces or other special characters.

#### `requiresRoot`

(Bool, default: `false`, optional)

When this key is set to `true`, Setup Manager will only run this when itself is running as root. Otherwise, it will fail the action. When `DEBUG` is enabled, it will replace the action with a delay instead.

Example:

```xml
<dict>
  <key>label</key>
  <string>Set Time Zone</string>
  <key>icon</key>
  <string>symbol:clock</string>
  <key>shell</key>
  <string>/usr/sbin/systemsetup</string>
  <key>arguments</key>
  <array>
    <string>-setTimeZone</string>
    <string>Europe/Amsterdam</string>
  </array>
  <key>requiresRoot</key>
  <true/>
</dict>
```

This example is the equivalent of this command line:

```
sudo systemsetup -setTimeZone Europe/Amsterdam
```

Notes: to break the command in to its components

- full path to the command
- arguments are split into the `arguments` array, one string entry per argument, no quoting or backslash escaping
- if the command contains a `&` it needs to be escaped with `&amp;`
- shell constructs such as substitution (e.g `$SHELL`), redirection (e.g `&2>1`)
- `sudo` won't work in this context, instead set `requiresRoot` to true

### Jamf Policy Trigger

#### `policy`

(String, Jamf Pro only)

This will run the Jamf Pro policy or polices with the given trigger name. This is the equivalent of running 

```
jamf policy -event <triggername> -verbose -forceNoRecon -doNotRestart -noInteraction -skipAppUpdates
```

Note: Jamf Pro policies can do a lot of different things and fail in many different ways. Setup Manager does _not_ check for all possible failure modes. It only checks for failed installer pkgs and policy scripts that return non-zero exit codes, which should cover most uses of policies for initial deployment.

Example:

```xml
<dict>
  <key>label</key>
  <string>BBEdit</string>
  <key>icon</key>
  <string>https://ics.services.jamfcloud.com/icon/hash_abcdefghj</string>
  <key>policy</key>
  <string>install_bbedit</string>
</dict>
```

Note: You can trigger policies attached to "Recurring Check-in" by leaving the string value empty:


```xml
<dict>
  <key>icon</key>
  <string>symbol:arrow.trianglehead.2.clockwise.rotate.90</string>
  <key>label</key>
  <string>Check-in</string>
  <key>policy</key>
  <string/>
</dict>
```

### Watch Path

#### `watchPath`

(String)

This action will wait until a file at the given path exists (`wait` is `untilExists`, default) or is removed (`wait` is `whileExists`).

#### `wait`

(String, default: `untilExists`)

Determines if the action waits until the file exists (`untilExists`) or until the file is removed (`whileExists`).

#### `timeout`

(Number/integer, in seconds, default: `600`)

The action will fail after this timeout.

Example:

```xml
<dict>
  <key>label</key>
  <string>Jamf Protect</string>
  <key>icon</key>
  <string>symbol:app.badge</string>
  <key>watchPath</key>
  <string>/Applications/JamfProtect.app</string>
  <key>timeout</key>
	<integer>300</integer>
</dict>
```

Note: This is intended to check if an app is installed from the Mac App Store or by Jamf App Installers. In my experience, these installation methods are quite unreliable during enrollment, hence the timeout. Since you cannot anticipate the order in which these apps may be installed, it is best to put the `watchPath` actions at the end. For large installations, such as Xcode, or Adobe apps, you want to set a large timeout.

### Wait

#### `wait`

(Number/integer, in seconds)

Wait for a given time. Use this to let the system catch up with previous installations.

Example:

```xml
<dict>
  <key>label</key>
  <string>Waiting…</string>
  <key>wait</key>
  <integer>20</integer>
</dict>
```

### Wait for User Entry

#### `waitForUserEntry`

(String, value is ignored, Jamf Pro only)

If Setup Manager reaches this action before the user entry has been completed, it will wait until the user entry is completed and the user has clicked 'Save.'

When the user entry is saved and this action is reached, it will set the computer name, according to the `computerNameTemplate` or what was entered by the user and run a recon/Update Inventory which submits the user data. It will also save the data from the user entry to the [user data file](Docs/Extras.md#user-data-file).

This action allows for "two phase" installation workflows where the policies in the second phase are scoped to data from the user entry. After this action, smart groups in Jamf Pro should reflect the data entered and you can use scoping in subsequent policies to choose which policies should or should not run on this device.

Regardless of whether there is a `waitForUserEntry` action or not, Setup Manager will submit the user data and run a recon/Update Inventory after all actions are finished.

```xml
<dict>
  <key>label</key>
  <string>Submit User Entry</string>
  <key>waitForUserEntry</key>
  <string/>
</dict>
```

### Jamf Inventory Update (recon)

#### `recon`

(String, value is ignored, Jamf Pro only)

This will run a Jamf Inventory update.

This action exists mainly for troubleshooting. You should generally not need to add a recon step. By default, Setup Manager will automatically run an inventory update before and after running the enrollment actions. If you have a `waitForUserEntry` action configured, this will also run a recon/inventory update.

Example:

```xml
<dict>
  <key>recon</key>
  <string/>
</dict>
```

### Installomator

Setup Manager includes the [Installomator](https://github.com/Installomator/Installomator) script to simplify installations. This action will run [Installomator](https://github.com/Installomator/Installomator) to install a given label.

Note: by default, Setup manager will add `NOTIFY=silent` to the arguments to suppress notifications. You can override these variables and add more with the `arguments` key.

#### `installomator`

(String)

The installomator label to run.

#### `arguments`

(Array of Strings, optional)

List of additional arguments passed into Installomator.

Example:

```xml
<dict>
  <key>label</key>
  <string>Google Chrome</string>
  <key>icon</key>
  <string>symbol:gearshape.2</string>
  <key>installomator</key>
  <string>googlechromepkg</string>
</dict>
```

with arguments: 

```xml
<dict>
  <key>label</key>
  <string>Example App</string>
  <key>installomator</key>
  <string>example</string>
  <key>arguments</key>
  <array>
    <string>downloadURL=https://example.com/alternativeURL</string>
  </array>
</dict>
```


## Icon Sources

Icons (which include the top-level `icon`, the `background` and the `icon`s in individual actions) can be defined in several ways in Setup Manager.

### From the web

When the icon source string starts with `http` or `https`, Setup Manager will attempt to download a file from that URL and interpret it as an image file. It will show a spinning progress view while downloading.

```xml
<key>icon</key>
<string>https://example.com/path/to/icon.png</string>
```

### Local file

When the icon source is an absolute file path, Setup Manager will attempt to read that file as an image file and display it.

```xml
<key>icon</key>
<string>/Library/Organization/image.png</string>
```

You will need to install custom local image files _before_ Setup Manager runs.

With Jamf Pro, you can achieve that by adding another pkg to the Prestage. Since the Prestage installs pkgs in alphabetical order, this branding pkg should be named to be alphabetically _before_ "Setup Manager."

### Application:

When the icon source is an absolute file path that ends in `.app`, Setup Manager will get the icon from that app.

```xml
<key>icon</key>
<string>/System/Applications/App Store.app</string>
```

### Name:

When the icon source starts with `name:`, Setup Manager will get the icon with that name. Two names are useful: `AppIcon` gets Setup Manager's app icon and `NSComputer` will get an icon representing the current hardware.

```xml
<key>icon</key>
<string>name:AppIcon</string>
```

### SF Symbols:

When the icon source starts with `symbol:`, Setup Manager will create the icon using that symbol's name. You can look up symbol names using the [SF Symbols](https://developer.apple.com/sf-symbols/) app.

Note that the availability and appearance of SF Symbols may vary with the OS version and language/region.

```xml
<key>icon</key>
<string>symbol:clock</string>
```

### Color

(v1.4)

When the icon source starts with `#`, Setup Manager will interpret it as a hex color.

You can use hex color notation with three digits, e.g `#0f0` or six digits, e.g. `#f900a2`. 

You can also use named system colors with two leading `##`, e.g `##yellow` or `##primary`. 

(See ['Defining Colors'](#defining-colors) for details.)

```xml
<key>background</key>
<string>##white</string>
```

```xml
<key>background</key>
<string>#aaa</string>
```

### Dark Mode

Note: after enrollment, over Setup Assistant, the system is always in light mode. This is only relevant when you use Setup Manager after user-initiated enrollment or launch it otherwise over user space.

To provide alternative images for dark or light mode, change the `string` defining the image to a dictionary with a `dark` and a `light` key. This works with the `background`, `icon`, and each action's `icon`. This also works with the `accentColor` key.

Setup Manager does _not_ monitor the appearance mode, so if it changes _while_ Setup Manager is running, things will not update consistently.

Example: 

```xml
<key>icon</key>
<dict>
  <key>dark</key>
  <string>name:Jamf_white</string>
  <key>light</key>
  <string>name:Jamf_blue</string>
</dict>
```


## User Entry

You can enable user entry for the following keys:

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

`userID` and `email` can be somewhat confusing and depending on which Cloud directory you have configured in Jamf Pro, you may need one or the other or both. Because of this Setup Manager 1.1 and older would only prompt for 'User email' and set both `userID` and `email` from that value. To maintain compatibility with this behavior, Setup Manager will continue to set _both_ `userID` and `email` when only one of the two values is requested and entered. If you request both fields, both will be set individually in the recon.


### User Data file

Data from user entry is written, together with some other data to a file when Setup Manager reaches a `waitForUserEntry` action and again when it finishes. The file is stored at `/private/var/db/SetupManagerUserData.txt`. [More details.](Docs/Extras.md#user-data-file)

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

For this, you need to setup the top-level `enrollmnetUserID` to receive the `$EMAIL` variable. This will communicate to SetupManager the user who logged in with customized enrollment. Then you add key `showForUserIDs` with an array of user emails to the `userEntry` dict. When both `enrollmentUserID` and `userEntry.showForUserIDs` are set, the user entry UI will only show for the listed users.

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

## Help

When you provide a top-level `help` key with a dictionary a help button (with a circled question mark) will be shown in the lower right corner (for left-to-right localizations). When you click on the help button a window with information will be shown. You can set the information with the following keys in the `help` dictionary.

#### `title`

(String, optional, localized)

#### `message`

(String, optional, localized, markdown)

#### `url`: 

(String, optional, localized)

The contents of the `url` key will be translated into a QR code and displayed next to the help message. This allows for end users to follow a link to more information on another device while the Mac is performing installations.

Example:

```xml
<key>help</key>
<dict>
  <key>message</key>
  <string>This is some help message content.</string>
  <key>title</key>
  <string>Help Content</string>
  <key>url</key>
  <string>https://jamf.com</string>
</dict>
```

## Webhooks

Setup Manager can send web hooks to servers and services to trigger workflows there. You can read [details on how to configure and use WebHooks here](Docs/Webhooks.md).

## Network Connectivity

Setup Manager can check and display the network status and connectivity to a list of hosts. You can read [the details on how to configure this here](Docs/Network.md).

## Localization

The app will pick up the user choice of the UI language for the interface elements. (Table of currently available languages below.) The app will fall back to English for other language choices.

You can provide localizations for the custom texts given in the configuration profile. 

**Deprecation notice:** the method for providing localized texts in the configuration profile changed in version 1.1. The previous method (by appending the two letter language code to the key) is considered deprecated. It will continue to work for the time being but will be removed in a future release. It is _strongly_ recommended to change to the new dictionary-based solution.

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
  <string>Bienvenu!</string>
  <key>nl</key>
  <string>Welkom!</string>
</dict>
```

When there is no value for the localization, the app will fall back to the value of the `en` key.

The following keys can be localized:

### Top-level keys

- `title`
- `message`
- `icon`
- `background`

### Actions

- `label`
- `icon`

### User Entry

- `default`
- `placeholder`
- `validationMessage`
- `label`

### Help

- `title`
- `message`
- `url`

### Network Check

- `label`

Use these two-letter codes for these languages:

| Language           | two-letter code |
|--------------------|-----------------|
| English            | en (default)    |
| Dutch (Nederlands) | nl              |
| French             | fr              |
| German             | de              |
| Hebrew             | he              |
| Italian            | it              |
| Norwegian          | nb              |
| Polish             | pl              |
| Spanish            | es              |
| Swedish            | sv              |

The [plist and profile example files](Examples) contain localizations for many of the custom text elements.

## Substitution

Certain keys, such as `computerNameTemplate` can use tokens, which begin and end with `%` character. The tokens will be substituted with data from the device or user entry.

For example, in the template `Mac-%serial%` the `%serial%` token will be replaced with the computer's serial number. 

A double `%%` will be substituted with a single `%`, in case you need to represent this symbol.

The following tokens are available:

- `serial`: the computer's serial number
- `udid`: the computer's provisioning universal device identifier
- `model`: the computer's model name, e.g. `MacBook Air` or `Mac mini`
- `model-short`: the first word of `model` (no spaces), i.e. `MacBook`, `Mac` or `iMac`
- these values from user entry, _after_ user entry has completed (see [`waitForUserEntry`](#waitForUserEntry))
    - `email`
    - `assetTag`
    - `building`
    - `department`
    - `room`

If the value for a token cannot be retrieved or is empty, it will be substituted with `%%%` (three percentage signs).

You can add a `:n` (where `n` is an integer number) to a token. This will substitute only the first `n` characters of the string. For example `%serial:5%` will be substituted with the first 5 characters of the serial number. When `n` is negative, it will substitute the _last_ `n` characters. For example, `%udid:-8%` will substitute the last eight characters of the udid. When you use `:=n` the _center_ `n` characters will be picked.

These keys can use substitutions:

- `title`
- `message`
- `computerNameTemplate`
- actions: `label`

## Markdown

In some fields, markdown formatting can be used to generate rich, formatted text. For example:

```xml
<key>message</key>
<string>Preparing your new Mac. **Please be patient.**</string>
```

The `Please be patient.` text will be shown bolded. You can find details on markdown formatting in the [Markdown Cheat Sheet](https://www.markdownguide.org/cheat-sheet/).

Note that while you _can_ embed links to websites in the markdown using the `[…](…)` syntax they will not work while running over Setup Assistant or Login Window.

These keys can use markdown:

- `message`
- Help: `message`

## Defining Colors

Colors are defined with strings in the profile.

When the icon source starts with `#`, Setup Manager will interpret it as a hex color.

You can use hex color notation with three digits, e.g `#0f0` or six digits, e.g. `#f900a2`. 

Example: 

```xml
<key>accentColor</key>
<string>#FF00AA</string>
```

(v1.4) You can also use named system colors with two leading `##`, e.g `##yellow` or `##primary`. Available color names are:

```
 primary         primary text color, black in light mode, white in dark mode
 secondary       slightly muted variant of primary
 accentColor     color used for controls, set with `accentColor`
 background      system window background color
 clear           no background/transparent (1)
 black           (1)
 blue
 brown
 cyan
 gray
 green
 indigo
 mint
 orange
 pink
 purple
 red
 teal
 white           (1)
 yellow
```

(1) All colors will automatically adapt to dark or light mode, _except_ `clear`, `black`, and `white`.

Example:

```xml
<key>accentColor</key>
<string>##green</string>
```

### Dark mode

If you want different accent colors depending on whether the system is in light or dark mode, provide a `dict` with two keys, for `light` and `dark` mode: (Note: most named system colors adapt automatically)

Example:

```xml
<key>accentColor</key>
<dict>
  <key>dark</key>
  <string>#FF00AA</string>
  <key>light</key>
  <string>#AA0055</string>
</dict>
```
