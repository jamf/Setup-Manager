#  Setup Manager - Change Log

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

### Notes

#### Logging

The format of the Setup Manager log file (in `/Library/Logs/Setup Manager.log`) has changed. The new format should be easier to parse with other tools. There are four columns:

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


#### Network change logging

Setup Manager 1.3 adds logging for changes to network interfaces. it is possible that there will multiple entries in the log with regards to the same network change. Most changes logged will be neutral and should not affect your deployment negatively.

However, it is possible that changes to the network configuration of a device can influence the deployment workflow. For example, when a configuration profile with the access information for a secure corporate Wifi is installed on the device, then the download access to  required resources might change. Another example are security that might lead to restricted access for downloads (Installomator uses `curl` to download data, which might trigger security tools.) 

Knowing that network changes or outages occurred during enrollment can be useful for troubleshooting.

#### Network Status icon/menu

Network status is also shown with a new icon in the top-right corner of the Setup Manager window.  
 
Note that Network Relay will only protect traffic to certain configured servers and services, not all traffic.

By default, the network icon will _not_ be shown. You can activate it manually with the command-N keystroke.

When you click on the Network status icon, a popup will show:
 - the current active network interface
 - IPv4 and IPv6 addresses
 - download and upload bandwidth (will take a while to appear)
 - Network Relay hosts (when network relay profile is present)
 - list of additional custom hosts, configured in the profile

Note that the connectivity is very basic and might not catch all functionality that is required for a service to work. It should provide an indication whether a service is available, but deeper trouble-shooting and monitoring might be required for reliable diagnostics.

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
