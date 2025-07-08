# Extras and Notes


## Keyboard Shortcuts

Note that the Setup Manager window does not activate to receive keystrokes automatically when running over Setup Manager. You have to click in the Setup Manager window first.

| shift-control-command E | ["exit"/quit Setup Manager](#Quit), use only in emergencies as it will leave installations in an  indeterminate state |
| command-L | open [Log window](#Logging) |
| command-B | toggle Battery status icon in Setup Manager window |
| command-N | toggle [Network status icon](Network.md) in Setup Manager window |
| space | show [serial number bar code window](#scannable-serial-number-barcode) |
| i | show "About this Mac" popup |
| h | show "Help" popup, when present |
| hold option key when clicking "About this Mac" | shows more info |

## Custom JSON Schema for Jamf Pro

- create a new profile
- go to ‘Application & Custom Settings’
- select ‘Jamf Applications’
- click the ‘+ Add’ button
- in the ‘Jamf Application Domain’ popup select ‘com.jamf.setupmanager’
- for the version select the version of Setup Manager you are using
- for the ‘Variant’, select ‘Setup Manager.json’
- fill in your fields!

The custom schema does not contain all keys and options available in the [configuration profile](../ConfigurationProfile.md). Specifically, the `wait` action and the option to [localize values](../ConfigurationProfile.md#localization) are not available.

When you reach the limits of the custom schema, use the XML it generates as a starting to building a custom XML.

Note that the custom schema can become confused when you switch between enrollment action types and you will need to clean up extra empty fields.

## Quit

The command-Q keyboard shortcut to quit the app is disabled. Use `shift-control-command-E` instead. This should only be used when debugging and troubleshooting, as it will leave the client in an undetermined state when installations are aborted.

## Logging

While Setup Manager is running you can open a log window with command-L.

There are two or three tabs, one for the main Setup Manager log, one showing output from `/var/log/install.log` and (Jamf Pro only) one tab showing output from `/var/log/jamf.log`. By default, these log tabs will be summarized to events relevant to the enrollment workflow. You can see the full log content by unchecking the 'Summarize' option.

Note that both logs will show events that were not initiated by Setup Manager. Nevertheless, these events may be relevant to your enrollment workflow.

These summarized events will also appear in the Setup Manager log tab and log file, as well as the universal log entries. Having these events in context at the time they occur in the Setup Manager log is very helpful when trouble-shooting enrollment workflows.

Setup Manager logs to `/Library/Logs/Setup Manager.log`. There are four columns:

- timestamp (in ISO8601)
- log level (default, error or fault)
- category (general, install, network, jamfpro)
- message

To clean up the main log a little, Setup Manager will only write the output of actions to the Setup Manager log file when an error occurred. You can control this behavior with a new top-level preference key `actionOutputLogging`.

Setup Manager also logs to the macOS unified system log. The subsystem is `com.jamf.setupmanager`. You can use the `log` command line tool to read the log.

For example:

```
sudo log show --last 30m --predicate 'subsystem="com.jamf.setupmanager"'
```

## Debug mode

When you set the `DEBUG` key to `true` in the profile or locally with the `defaults` command Setup Manager will not perform any tasks that actually perform installations or otherwise change the system. When in DEBUG mode, Setup Manager will also read settings from the local settings (i.e. `~/Library/Preferences/com.jamf.setupmanager.plist`) which simplifies iterating through different settings. If you want to run Setup Manager on an unmanaged Mac, you may need to provide a `simulateMDM` key with a value of either `Jamf Pro` or `Jamf School`.

You may also need to remember to remove the [flag file](#flag-file) before launching Setup Manager.

You will also be able launch the app as the user, by double-clicking the app in `/Applications/Utilities`. This is useful to test the look and feel of your custom icons, text and localization. When you use this to create screen shots for documentation, also note the `overrideSerialNumber` and `hideDebugLabel` keys.


For testing, you can also re-launch Setup Manager from the command line as root with `sudo "/Applications/Utilities/Setup Manager.app/Contents/MacOS/Setup Manager"`

## Flag file

Setup Manager creates a flag file at `/private/var/db/.JamfSetupEnrollmentDone` when it finishes.

If this file exists when Setup Manager launches, the app will terminate immediately without taking any action. You can use this flag file in an extension attribute in Jamf to determine whether the enrollment steps were performed. (Setup Manager does not care if the actions were performed successfully.)

When `DEBUG` is set to `true` in the defaults/configuration profile, the flag file is ignored at launch, but may still be created when done. 

In Jamf Pro, you can create an Extension Attribute named "Setup Manager Done" with the script code:

```sh
if [ -f "/private/var/db/.JamfSetupEnrollmentDone" ]; then
  echo "<result>done</result>"
else
  echo "<result>incomplete</result>"
fi
```

And then create a Smart Group named "Setup Manager Done" with the criteria `"Setup Manager Done" is "done"`. This can be very useful for scoping and limitations.

## User Data file

The data from user entry is written to a file when Setup Manager reaches a `waitForUserEntry` step and again when it finishes. The file is stored at `/private/var/db/SetupManagerUserData.txt`. When `DEBUG` is enabled, the file will be written to `/Users/Shared/`.

The file is plain text with the following format:

```
start: 2024-08-14T13:52:56Z
userID: a.b@example.com
department: Sales
building: Example
room: ABC123
assetTag: XYZ888
computerName: MacBook-M7WGMK
submit: 2024-08-14T13:54:37Z
duration: 101
```
Start time (`start`) and finish/submission time (`submit`) are given in ISO8601 format, universal time (UTC). Duration is given in seconds.

Fields that were not set in user entry will not be shown at all. You can use this file in scripts or extension attributes. One possible way is to parse it with `awk`, e.g.

```xml
duration=$(awk -F ': ' '/duration: / {print $2}' /private/var/db/SetupManagerUserData.txt)
```

Starting with Setup Manager 1.2, the User Data file contains a list of actions with their status:

```
enrollmentActions:
 -action 0: finished - Microsoft 365
 -action 1: finished - Google Chrome
 -action 2: finished - Jamf Connect
```

The status can be `finished` or `failed`.

## "About This Mac…" window

When you hold the option key when clicking on "About This Mac…" you will see more information.

## Scannable Serial Number Barcode

Hitting the space bar while Setup Manager is the Active window will open a window with a scannable barcode of the serial number. Hitting the space bar again will dismiss the window.

Note that Setup Manager does not automatically get Key Window when it launches, while running over Setup Assistant, so you may have to click in the Setup Manager window, before hitting the space bar.

## Uninstall Setup Manager

Setup Manager will unload and remove its LaunchAgent and LauchDaemon files upon successful completion. That together with the [flag file](#flag-file) should prevent Setup Manager from launching on future reboots.

If you still want to remove Setup Manager after successful enrollment, there is [a sample uninstaller script in the Examples folder](../Examples/uninstall.sh).

## (Jamf Pro): Useful Smart Groups 

You can create smart groups to coordinate installations of Configuration profiles. Some useful examples are:

### Setup Manager Installed

Criteria: 'Application Bundle ID' is `com.jamf.setupmanager`

You can use this smart group to scope or limit configuration profiles, Mac App Store/VPP apps, and Jamf App Installer apps. This way their installation will not occur immediately after enrollment, potentially slowing down the installation of essential Jamf Pro components and extending the "Getting Ready" phase.

### Setup Manager Done

Create an Extension attribute named "Setup Manager Done" with the script code:

```sh
if [ -f "/private/var/db/.JamfSetupEnrollmentDone" ]; then
  echo "<result>done</result>"
else
  echo "<result>incomplete</result>"
fi
```

Then create a Smart Group named "Setup Manager Done" with the criteria `"Setup Manager Done" is "done"`.

You can use this to scope configuration profiles and policies so that they are installed or run _after_ Setup Manager is complete.

##  Running Scripts and Policies when Setup Manager finishes

Generally, you want to coordinate tasks, configurations, and installations with Setup Manager actions. However, in some situations the installations might interfere with the Setup Manager workflow itself. This is most relevant with software that needs to reload the login window process, which will also kill Setup Manager. (e.g Jamf Connect Login)

Setup Manager provides a LaunchDaemon which monitors the `.JamfEnrollmentSetupDone` flag file. It then launches a script or a custom Jamf Pro policy trigger. Since this LaunchDaemon runs independently from Setup Manager, so it can run installers or scripts that might quit login window or Setup Manager.

However, if you have set Setup Manager to automatically shut down or restart at the end, this will interrupt the finished script or policy, unless the automated delay is long enough. Use the [`finalAction`](../ConfigurationProfile.md#finalAction) value of `none` to remove the button and countdown from the Setup Manager UI. However, now it the responsibility of the finishing process to restart the Mac or quit the Setup Manager process, otherwise Setup Manager will keep blocking the UI.

The finished script or custom trigger are configured in the Setup Manager configuration profile, with the [`finishedScript`](../ConfigurationProfile.md#finishedScript) and [`finishedTrigger`](../ConfigurationProfile.md#finishedTrigger) keys.

The SetupManagerFinished daemon logs its output (and the output of the policy and scripts to `/private/var/log/setupManagerFinished.log`.

