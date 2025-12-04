#  Setup Manager - Change Log

## 1.4beta2

(2025-11-24)

Same as [the previous beta](https://github.com/jamf/Setup-Manager/releases/tag/v1.4beta) with these additional changes:

- Localization:
  - added UK English (en-GB) localization
  - various localization fixes (#171)
- fixed Network Info font color (#166)
- `waitForUserEntry` action correctly runs a recon/Update Inventory (#168)
- `accentColor` affects all items and controls (#170)
- UI adjustments (#169)

## v1.4beta
(2025-10-28)

While making sure that Setup Manager looks nice with macOS Tahoe and Liquid Glass, we have added a few more features to improve customization.

### New Features
- User Interface
  - macOS Tahoe/Liquid Glass adaptions
  - new `banner` key allows you to provide a banner image that cover the top part of the Setup Manager window ([details](ConfigurationProfile.md#banner))
  - `title` and `icon` keys are now optional, when a `banner` key is set
  - action tiles can have a background color set with the top-level or per-action 'tileColor'key
  - `banner` and `background` can use hex or system colors
  - where colors are defined, you can use system color names. See ['Defining Colors'](ConfigurationProfile.md#defining-colors) for details.
- new profile keys:
  - `networkQualityCheck` suppresses network bandwidth calculation when set to `false` (#135)
  - `finishedMessage` for a customized message when Setup Manager workflow is complete (#128)
- logging:
  - new tab for configuration profiles in the log
  - detection of configuration profile installation and removal
  - image/icon load errors are now logged
  - logs a warning when Setup Manager detects it is launched for a second time
- switched launch tracking to a new service (see [Launch Tracking](Docs/LaunchTracking.md) for details)

### Fixes and Improvements

- disabled check for Jamf.app as it could fail in some challenging network configs
- enrollmentUserID added to webhook data (#140)
- localization fixes (#149)
- elapsed time in Mac Info window stops counting when workflow is finished
- link to computer in Slack and Teams messages should work with Jamf School
- setting computer name with user entry or `computerNameTemplate` works with Jamf School 
- updated uninstall.sh script (#156)

### Changes, deprecations and removals
- (1.4) `userID` top-level key name changed to `enrollmentUserID`
- (1.4) `jssID` key has been renamed to `computerID`
- (1.3) the minimum macOS requirement for Setup Manager is now macOS 13.5
    - Log window now uses `Window`
- (1.2) `showBothButtons` option removed and non-functional, there will always be just one final action button displayed
- (1.1)the method for providing localized texts in the configuration profile changed in version 1.1. The previous method (by appending the two letter language code to the key) is considered deprecated. It will continue to work for the time being but will be removed in a future release. It is _strongly_ recommended to change to the [new dictionary-based solution](ConfigurationProfile.md#localization)

### Notes

There are quite a few new options in Setup Manager 1.4 beta to configure and customize the new UI. There is a new option for a color or image banner across the top of the Setup Manager window. Action tiles can now be colored automatically or with specific colors. Colors can now be set anywhere that image sources are used and you get a list of named system colors.

While the [description of all the keys in the repo](ConfigurationProfile.md) has been updated, many of the keys, old and new, now work together for a variety of useful combinations.

#### Updating the profile to use 1.4 (beta) features

The good news first: we designed the update so that you can keep using the same profile from earlier versions and the Setup Manager window will look mostly the same on macOS Sequoia and earlier, and have the new “Liquid Glass” look and feel on macOS Tahoe.

To use the new UI options, set the new keys.

#### Banner

Setup Manager 1.4 introduces the option to show a color or image banner in the top of the Setup Manager window. This is controlled by the top-level [`banner` key](ConfigurationProfile.md#banner). The `banner` value is an [image source](ConfigurationProfile.md#icon-sources), so it can be a reference to local image file, an image file hosted on a web server, or (also new in 1.4) a [color designation](ConfigurationProfile.md#defining-colors).

Colors can be set with hex codes, e.g. `#f00` or `#f900a2` or with (new in 1.4) system color names, e.g. `##gray`, `##red`, etc.

The size of the banner area is 800x233 pixels (1600x466 @2x) on Sequoia and earlier and 800x247 (1600x494 @2x) on Tahoe (the liquid glass tool bar is taller). The image will be displayed with bottom-center alignment and _not_ scaled, so you can add a few extra pixels at the top and the same image should work for all macOS versions.

The behavior of the `icon` and `title` keys changes depending on whether the `banner` has a value.

When _no_ `banner` value is set, Setup Manager will show its app icon when an `icon` key is missing or empty. It will also show ‘Welcome’ or the localized equivalent when the `title` key is missing or empty.

When the `banner` _is_ set, an empty or missing `title` or `icon` will simply not be shown. This lets you use the banner image for a completely customized experience.

Note that the `banner` value can be localized.

#### Action Tile Colors

Setup Manager 1.4 allows you to set a color for the action tiles. Use the [top-level `tileColor` key](ConfigurationProfile.md#tilecolor) to set the color for all action tiles. You can also set the tile color for an individual action with [a `tileColor` key in the action](ConfigurationProfile.md#tilecolor-1).

When no `tileColor` is set, the default behavior is to use the window background color (gray on Sequoia and earlier, white on Tahoe, or the dark mode equivalent).

You can set the `tileColor` value (top-level and action level) to [a hex color or system color name](ConfigurationProfile.md#defining-colors). There are a few special color names:

- `##automatic`: calculates each tile's color from the average color of each action’s icon, icons defined with `symbol:…` will use the default color
- `##background`: system window background (gray on Sequoia and earlier, white on Tahoe)
- `##clear`: transparent or no background, works best when `hideActionLabels` is set to false

See [`tileColor`](ConfigurationProfile.md#tilecolor-1) and [‘Defining Colors’](ConfigurationProfile.md#defining-colors) in the documentation for details.

#### Profile Installation and Removal Logging

A new tab has been added to logging window which logs the installation and removal of configuration profiles. These events will also be logged to the main Setup Manager log, which allows you to see them in context of the entire workflow.

This can be especially useful to determine whether a particular profile disrupts the network and possibly the download of an important component. In the unified system log, these entries will have the `profile` category.



## 1.3.1
(2025-07-17)

- updates to Polish localization
- improvements to launch process at login window
- logs macOS version at launch
- email addresses and urls in markdown text are not active links any more
- documentation updates and clarifications

## 1.3
(2025-07-08)

Notes added since 1.3beta are marked with '(release)'

### New Features
- Logging
    - log output format has been cleaned up
    - Install log and Jamf Pro log (when available) can now be viewed in the Log window (#78, #130)
    - now also logs to macOS unified logging
    - new top-level default key to control action output logging
- Network Monitoring
    - changes to network interfaces are now logged, see the Notes section for details (#15)
    - network status can be shown in the top-right corner of the Setup Manager window
- new flag file `/private/var/db/.JamfSetupStarted`, which is created when Setup Manager starts. You can use this to scope Mac App Store apps and Jamf App Installers, which prevents these apps from installing early in the enrollment, slowing down the Jamf Pro configuration
- added [a specific webhook to send a message to Slack](Docs/Webhooks.md#slack) (#104)
- two new defaults keys `finishedScript` and `finishedTrigger` allow to run custom behavior when Setup Manager has finished
- new option `none` for `finalAction` (#115)
- (release) Polish localization (Thanks to @bsojka)

### Fixes and Improvements
- Jamf Pro: improved monitoring for Jamf Pro to complete its setup after enrollment
- webhook log entries correctly show status
- added `-skipAppUpdates` option to list of options for Jamf Pro policy actions, this should avoid some false "error 57" reports
- Jamf Pro policy will trigger 'Recurring Check-in' policies on empty string value
- (release) added name for macOS Tahoe 26
- (release) minor localization and UI fixes
- (release) disabled some undesirable keyboard shortcuts (#125)
- (release) arguments in `installomator` actions are now processed correctly
- (release) output to log is flushed immediately to avoid truncation on restart/shutdown (#129)
- (release) MDM Server address shown in extended "About this Mac" (#127)

### Deprecations and Removals
- (1.3) the minimum macOS requirement for Setup Manager is now macOS 13.5
- (1.2) `showBothButtons` option removed and non-functional, there will always be just one final action button displayed
- the method for providing localized texts in the configuration profile changed in version 1.1. The previous method (by appending the two letter language code to the key) is considered deprecated. It will continue to work for the time being but will be removed in a future release. It is _strongly_ recommended to change to the [new dictionary-based solution](ConfigurationProfile.md#localization)

### Notes

#### Logging

The format of the Setup Manager log file (in `/Library/Logs/Setup Manager.log`) has changed. The new format should be easier to read and parse with other tools. There are four columns:

- timestamp (in ISO8601)
- log level (default, error or fault)
- category (general, install, network, jamfpro)
- message

Setup Manager 1.3 also logs to the macOS unified system log. The subsystem is `com.jamf.setupmanager`. You can use the `log` command line tool to read the log.

For example:

```
sudo log show --last 30m --predicate 'subsystem="com.jamf.setupmanager"'
```

To clean up the log a little, Setup Manager 1.3 will only write the output of actions to the Setup Manager log file when an error occurred. You can control this behavior with a new top-level preference key `actionOutputLogging`.

#### Installation and Jamf Pro logs and summaries

The Log window (open with command-L) gained a new "Install" tab, which shows the system's installation log file (`/var/log/install.log`). When enrolling with Jamf Pro, there is another new "Jamf" tab, which shows the Jamf log (`/var/log/jamf.log`). By default, the Log window will be summarized to events relevant to the enrollment workflow. You can see the full log content by unchecking the 'Summarize' option.

Note that both logs will show events that were not initiated by Setup Manager. Nevertheless, these events may be relevant to your enrollment workflow.

These summarized events will also appear in the Setup Manager log tab and file, as well as the universal log entries. Having these events in context at the time they occur in the Setup Manager log is very helpful when trouble-shooting enrollment workflows.

#### Network change logging

Setup Manager 1.3 adds logging for changes to network interfaces. It is possible that there will multiple entries in the log with regards to the same network change. Most changes logged will be neutral and should not affect your deployment negatively.

However, it is possible that changes to the network configuration of a device can influence the deployment workflow. For example, when a configuration profile with the access information for a secure corporate Wifi is installed on the device, then the download access to  required resources might change. Another example are security tools that might lead to restricted access for downloads (Installomator uses `curl` to download data, which might trigger security tools.) 

Checking the log for network changes or outages during enrollment can be useful for troubleshooting.

#### Network Status icon/menu

Network status can also show with a new icon in the top-right corner of the Setup Manager window.  
 
Note that Network Relay will only protect traffic to certain configured servers and services, not all traffic.

By default, the network icon will _not_ be shown. You can activate it manually with the command-N keystroke.

When you click on the Network status icon, a popup will show:
 - the current active network interface
 - IPv4 and IPv6 addresses
 - download and upload bandwidth (will take a while to appear)
 - Network Relay hosts (when network relay profile is present)
 - list of additional custom hosts, configured in the profile

Note that the connectivity check is quite basic and might not catch all functionality that is required for a service to work. It should provide an indication whether a service is reachable, but deeper trouble-shooting and monitoring might be required for reliable diagnostics.

Seen["Network Connectivity"](Docs/Network.md) for more detail.

#### Finished Script and Trigger

Setup Manager now includes functionality to launch a script or Jamf Pro custom policy trigger in a separate process when the main Setup Manager process is finished. This is useful for installations that might unexpectedly restart the computer or the context that Setup Manager is running in (most commonly, Setup Manager is running at login window, which the Jamf Connect installer will kill).

There are two keys relevant for this: `finishedScript` and `finishedTrigger`. 

See ["Running Scripts and Policies when Setup Manager finishes"](Docs/Extras.md#running-scripts-and-policies-when-setup-manager-finishes) for detail.

## v1.3beta
(2025-05-27)

### New Features
- Logging
    - log output format has been cleaned up
    - Install log and Jamf Pro log (when available) can now be viewed in the Log window (#78)
    - now also logs to macOS unified logging
    - new top-level default key to control action output logging
- Network Monitoring
    - changes to network interfaces are now logged, see the Notes section for details (#15)
    - network status can be shown in the top-right corner of the Setup Manager window
- new flag file `/private/var/db/.JamfSetupStarted`, which is created when Setup Manager starts
- added [a specific webhook to send a message to Slack](Docs/WebHooks.md#Slack) (#104)
- two new defaults keys `finishedScript` and `finishedTrigger` allow to run custom behavior when Setup Manager has finished
- new option `none` for `finalAction` (#115)

### Fixes and Improvements
- Jamf Pro: improved monitoring for Jamf Pro to complete its setup after enrollment
- webhook log entries correctly show status
- added `-skipAppUpdates` option to list of options for Jamf Pro policy actions
- Jamf Pro policy will trigger 'Recurring Check-in' policies on empty string value

### Deprecations and Removals
- (1.3) the minimum macOS requirement for Setup Manager is now macOS 13.5
- (1.2) `showBothButtons` option removed and non-functional, there will always be just one final action button displayed
- the method for providing localized texts in the configuration profile changed in version 1.1. The previous method (by appending the two letter language code to the key) is considered deprecated. It will continue to work for the time being but will be removed in a future release. It is _strongly_ recommended to change to the [new dictionary-based solution](ConfigurationProfile.md#localization)

## v1.2.2
(2025-04-17)
- signed a helper script that could lead to unexpected background item prompts
- disabled command-W keystroke
- fixed a stall in `waitForUserEntry` with Jamf School
- fixed link to computer record in Teams message (#110)
- minor documentation fixes

## v1.2.1
(2025-04-02)

- updated included Installomator script to [v10.8](https://github.com/Installomator/Installomator/releases/tag/v10.8)
- now tries for 15 seconds to reload local `background` image file (#105), this should help in situations where the image file is installed after Setup Manager
- improved monitoring of Jamf Pro enrollment process and completion during the "Getting Ready" phase
- minor documentation fixes (#106)


## v1.2.2
(2025-04-17)
- signed a helper script that could lead to unexpected background item prompts
- disabled command-W keystroke
- fixed a stall in `waitForUserEntry` with Jamf School
- fixed link to computer record in Teams message (#110)
- minor documentation fixes

## v1.2.1
(2025-04-02)

- updated included Installomator script to [v10.8](https://github.com/Installomator/Installomator/releases/tag/v10.8)
- now tries for 15 seconds to reload local `background` image file (#105), this should help in situations where the image file is installed after Setup Manager
- improved monitoring of Jamf Pro enrollment process and completion during the "Getting Ready" phase
- minor documentation fixes (#106)


v1.2
(2025-03-17)

### New Features
- Setup Manager can send [webhooks](Docs/Webhooks.md) on start and finish, (#70)
  - (beta2) added [a specific webhook to send a message to Microsoft Teams](Docs/WebHooks.md#Microsoft-Teams)
- User Entry:
  - `email`, `endUsername`, `realname`, `position` and  `phone` fields added. These will be submitted to Jamf Pro when Setup Manager finishes and during a `waitForUserEntry` action
  - you can set custom and localized labels for user entry fields in the profile with a `label` key
- [User Data file](Docs/Extras.md#user-data-file) now contains a list of enrollmentActions
- added 'restart' option to ['finalAction'](ConfigurationProfile.md#finalAction) (#38, #58)
- [icon sources](ConfigurationProfile.md#icon-source) and [`accentColor`](ConfigurationProfile.md#accentColor) can now have [a dark mode alternative defined in the profile](ConfigurationProfile.md#dark-mode) (#61)
- hitting the space bar while Setup Manager is the Active window will open a window with a scannable barcode of the serial number
- `message` and help:`message` now interpret [markdown formatting](ConfigurationProfile.md#markdown) (#46)

### Fixes and Improvements
- (beta3 and release) return key connected to final action and save buttons (#93)
- (beta3) added an `event` field to standard webhook data, (#94)
- (beta3) "facts" in Teams message are no longer in random order
- (beta3) improved reliablity of running at login window (#77)
- (beta2) an empty `userEntry` dictionary in the profile no longer chokes the UI (#85)
- (beta2) MDM check more resilient to certain profile configs (#87)
- (beta2) the `name` field in WebHook data was shortened from `SetupManagerFinished` and `SetupManagerStarted` to `Finished` and `Started`
- (beta2) early log entry when debug mode is enabled
- icon for `waitForUserEntry` can be changed from the profile
- shell actions correctly show success or failure, depending on their exit code#39)
- Jamf Pro policy actions show success or failure in most situations. Note that there are many things a policy can potentially do. Not all failures are caught. This registers failed pkg installations and policy scripts that return a non-zero exit code, which should cover most situations. Note also, these checks will only work on macOS 13 and higher. On macOS 12, Jamf policies will always be reported as success.
- read enrollment actions data from profile after user-initiated enrollments more reliably
- now tries for 15 seconds to reload images with local file paths, this should help in situations were the resources file are installed after Setup Manager
- many other fixes and improvements
- updated included Installomator to 10.7
- user data file will contain the enrollment user when the `userID` key is set
- battery warning threshold is now different for Intel (%50) and Apple silicon (%20) Macs. This matches Apple's warnings before applying software updates

### Deprecations and Removals
- the minimum macOS requirement for Setup Manager will be raised to macOS 13 soon
- `showBothButtons` option removed and non-functional, there will always be just one final action button displayed
- the method for providing localized texts in the configuration profile changed in version 1.1. The previous method (by appending the two letter language code to the key) is considered deprecated. It will continue to work for the time being but will be removed in a future release. It is _strongly_ recommended to change to the [new dictionary-based solution](ConfigurationProfile.md#localization).

### Beta Features

Even though we are confident that the release is overall stable and ready to be used in production, we believe this feature may require more testing. When, after thorough testing in your environment, you conclude this works for your workflow, please let us know about success or any issues you might encounter.

- Setup Manager can now run over Login Window, instead of immediately after installation. This also allows Setup Manager to work with AutoAdvance. Use [the new `runAt` key](ConfigurationProfile.md#runAt) in the profile to determine when Setup Manager runs


## v1.1.1
(2025-01-28)

- updated included Installomator script to [v10.7](https://github.com/Installomator/Installomator/releases/tag/v10.7)

## v1.1
(2024-10-23)
### New Features

- new action [`waitForUserEntry`](ConfigurationProfile.md#wait-for-user-entry) which allows for two-phase installation workflows in Jamf Pro. When Setup Manager reaches this action it will wait for the user entry to save the data entry, then it will run a recon/Update Inventory. Policy actions that follow this, can then be scoped to data from the user entry. (Jamf-Concepts/Setup-Manager#11)
- data from user entry is now written to a file when Setup Manager submits data. See details in [User Entry](Docs/Extras.md#user-data-file) (Jamf-Concepts/Setup-Manager#9)
- use token substitution in the `title`, `message`, and action `label` values (as well as `computerNameTemplate`)
- token substitution can extract center characters with `:=n`
- localization of custom text in the configuration profile has been simplified. The previous method still works, but is considered deprecated. [Details in the documentation](ConfigurationProfile.md#localization). The [plist and profile example files](Examples) have been updated.

### Fixes and improvements

1.1beta:

- icons using `symbol:` that end in `.app` now work properly
- Elapsed time is shown in "About this Mac…" Start time is shown with option key.
- svg and pdf images used for `icon`s should now work
- general fixes in user entry setup
- improved rendering in Help View (Jamf-Concepts/Setup-Manager#12)
- fixes to json schema
- improved and updated documentation
- included Installomator script updated to [v10.6](https://github.com/Installomator/Installomator/releases/v10.6)
- added Setup Manager version and macOS version and build to tracking ping
- fixed UI glitch in macOS Sequoia

1.1 release:

- documentation updates and fixes (Jamf-Concepts/Setup-Manager#35, Jamf-Concepts/Setup-Manager#44, Jamf-Concepts/Setup-Manager#48, Jamf-Concepts/Setup-Manager#51)
- custom `accentColor` now works correctly with SF Symbol icons (Jamf-Concepts/Setup-Manager#41)
- setting a `placeholder` no longer overrides a `default` in `userEntry` (Jamf-Concepts/Setup-Manager#43)
- more UI updates
- Hebrew localization

### Beta features

Even though we are confident that the 1.1 release is overall stable and ready to be used in production, we believe this feature may require more testing. When, after thorough testing in your environment, you conclude this works for your workflow, please let us know about success or any issues you might encounter.

- Setup Manager can now run over Login Window, instead of immediately after installation. This also allows Setup Manager to work with AutoAdvance. Use [the new `runAt` key](ConfigurationProfile.md#runAt) in the profile to determine when Setup Manager runs (Jamf-Concepts/Setup-Manager#18)

### Deprecations

These features are marked for removal in a future release:

- localized labels and text by adding the two-letter language code to key. Switch to [localization with dictionaries](ConfigurationProfile.md#localization). 
- `showBothButtons` key and functionality


## v1.1beta
(2024-09-09)

### New Features

- new action [`waitForUserEntry`](ConfigurationProfile.md#waitforuserentry) which allows for two-phase installation workflows in Jamf Pro. When Setup Manager reaches this action it will wait for the user entry to save the data entry, then it will run a recon/Update Inventory. Policy actions that follow this, can then be scoped to data from the user entry. (#11)
- Setup Manager can now run over Login Window, instead of immediately after installation. This also allows Setup Manager to work with AutoAdvance. Use the new `runAt` key in the profile to determine when Setup Manager runs (#18)
- data from user entry, is now written to a file when Setup Manager submits data. See details in [User Entry](Extras.md#user-data-file) (#9)
- use token substitution in the `title`, `message`, and action `label` values (as well as `computerNameTemplate`)
- token substitution can extract center characters with `:=n`
- localization in the configuration profile has been simplified. The previous method still works, but is considered deprecated. [Details](ConfigurationProfile.md#localization)

### Fixes and improvements

- icons using `symbol:` that end in `.app` now work properly
- Elapsed time is shown in "About this Mac…" Start time is shown with option key
- svg and pdf images used for `icon`s should now work
- general fixes in user entry setup
- improved rendering in Help View (#12)
- fixes to json schema
- improved and updated documentation
- included Installomator script updated to [v10.6](https://github.com/Installomator/Installomator/releases/v10.6)
- added Setup Manager version and macOS version and build to tracking ping
- fixed UI glitch in macOS Sequoia

## v1.0
(2024-07-01)

- updated to new Jamf Concepts Use Agreement
- updated German and Swedish localizations
- added name for macOS 15
- new `hideActionLabels` and `hideDebugLabel` keys
- 'Jamf ID' is now only visible in the extended 'About this Mac' View (reachable when holding the option key)
- messaging when Setup Manager is launched in user space or with missing configuration
- UI tweaks

## v1.0RC

(2024-03-11)

- various minor fixes to localization, documentation, and small UI tweaks
- better error handling and display for some edge cases
- added ReadMe and License to installer pkg

## v0.9.1

(2023-11-20)

- Norwegian and Swedish localizations, thanks to Sam Wennerlund
- refactored process launching code, this should help with some stalling issues
- shutdown button should not stall anymore
- Setup Manager now caches the defaults at launch. This makes it more resilient to its configuration profile "disappearing" because the computer is not scope. (We still recommend scoping the Setup Manager Configuration profile as well as adding it to the Prestage.) This also addresses the custom UI "flickering" while it runs. (#21)

## v0.9

(2023-10-26)

- Help button
  - new key `help` shows a help button (circled question mark) in the lower right corner. The "Continue" and/or "Shutdown" buttons will replace the "Help" when the appear
  - see [Configuration Profile documentation](ConfigurationProfile.md#help) for more detail
- "About this Mac" info window
  - now shows network connection status. With the option key, the info window shows the interface name and IP address
  - to keep the info window clean, some (more) items are now only shown when opening the info window while holding option keys (Jamf Pro and Setup Manager version)
- updated Installomator to v10.5
- added new defaults key `overrideSerialNumber` to display a preset serial number, this is useful for creating screenshots or recordings
- main window is not resizable (#26)
- user entry with options menu would be empty unless manually set (#23)
- item progress indicators are now more distinct (#25)
- added "Powered by Jamf" and icon in button bar
- Setup Manager rearranges windows properly when a screen is attached or removed
- app and pkg are now signed and notarized with Jamf Developer certificates
- many more bug fixes and improvements

## v0.8.2

(2023-09-19)

- local files are now shown correctly with `icon`
- download speed is shown in macOS Sonoma
- fixed a strange race condition that led to large installomator installations stalling with Jamf School
- 'Shutdown' button is now hidden by default, since it breaks some of the workflows. You can unhide it by setting the `finalAction` key to `shutdown` (this will hide the continue button) or setting the `showBothButtons` key to `true` which will show both buttons.


## v0.8

(2023-09-05)

- Italian and Spanish localizations (Thanks to Nicola Lecchi, Andre Vilja and Javier Tetuan)
- fixed crashing bug when `background` is set
- 'Save Button' in User Entry now enables properly
- UI layout improvements
- main `icon` now properly displays wide aspect images
- watchPath actions time faster in DEBUG mode
- unloads Jamf Pro background check-in during workflow
- About this Mac…
  - Download speed (measured with `networkQuality`) and estimated download time
  - Jamf Pro version
- new preference keys (see [config profile documentation for details](ConfigurationProfile.md))
  - `accentColor`
  - `totalDownloadBytes`
  - `userEntry.showForUserIDs`

## v0.7.1

(2023-06-29)

- flag file is now created _before_ last recon, so Jamf can pick it up with an extension attribute
- fixed some UI bugs in action tiles
- added documentation for single touch workflow with Jamf Connect

## v0.7

(2023-06-27)

- added macOS Sonoma to list of known macOS releases
- added documentation for Jamf School
- added changelog and some more updates to documentation
- computer name can now be generated without UI from a template
- added slight scale animation and edge fade to action list
- user entry fields can now be validated with a regular expression and localized message
- battery widget now display correctly on Macs without a battery

## v0.6

(2023-06-05)

- launchd plist is now removed when app launches and flag file is present. This will prevent further accidental restarts after the app has been re-installed
- improved logging when parsing an action fails
- added Pendo integration to track app launches
- hitting cmd-L multiple times would open multiple log windows
- log window now auto-scrolls to latest entry
- command-W no longer closes main window
- added French localization
- fixed some typos in Dutch localization
- Warning screen appears when battery drops below 20% and disappears when charger is connected
- you can show/hide battery status with cmd-B
- updated built-in Installomator to v10.4
- fixed some logic errors in the Jamf Pro workflow that were introduced when adding Jamf School support

## v0.5

(2023-05-09)

- should now support Jamf School, this required major changes throughout the code, please test everything, also on Jamf Pro
- added installomator as an option for actions (mostly for Jamf School, but this also works with Jamf Pro)
- changed packaging script so that Jamf School can parse the pkg
- while rebuilding everything found a few edge cases that weren't handled very well
- holding the option key when clicking "About this Mac…" will now show some extra info (want to add more data there going forward)
- added SwiftLint to the project

## v0.4

(2023-04-05)

- disk size is shown in "About this Mac…"
- display and Mac will not sleep during installations
- Setup Manager will ignore non-managed enrollmentActions when not in Debug mode
- Setup Manager shows when Debug mode is enabled
- command-Q no longer quits the app (you can use shift-control-command-E) instead

## v0.3

(2023-03-10)

- localization (English, German, Dutch)
- DEBUG mode now does something
- added flag requiresRoot to shell action
- Prerequisites now wait for Jamf keychain
- About this Mac info should work for Intel Macs
- Connected Shutdown button
- Setup Manager creates a flag file at /private/var/db/.JamfSetupEnrollmentDone when it finishes
- when this file exists when Setup Manager launches, the app will terminate immediately and do nothing.
- new defaults key finalCountdown which automatically continues (or shuts down) after a timer
- new defaults key finalAction which can set 'shut down' as the action when the timer runs out
- started out with localization
- background window and log window work over Setup Assistant
- show Jamf Computer ID in Info Window and re-worked Info View
- user input configurable in profile
- added department, building and room as options for input

## v0.2

- app should now work with macOS Monterey
- window not movable
- main window centered correctly
- menu bar hidden
- removed coverflow effect from main action list

known issues:

- log window and background image window don't open when run over login window
- user input not yet optional
- shutdown button does not work yet
