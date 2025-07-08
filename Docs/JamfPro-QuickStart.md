#  Jamf Pro: Setup Manager Quick Start

## Upload Setup Manager package

Download the latest version of the Setup Manager installation pkg from the [releases page](https://github.com/Jamf-Concepts/Setup-Manager/releases/latest).

In the Jamf Pro web interface, go to Settings > Packages. Create a new package and upload the Setup Manager installer pkg file to Jamf Pro. Save the package.

_Note:_ when the package is marked as 'pending' it will not work in prestage deployment. Wait with testing deployments until the 'pending' flag has disappeared.

## Prepare a Jamf Pro policy for use with Setup Manager

Setup Manager can trigger policies in Jamf Pro. By triggering a sequence of Jamf Pro policies all the required software and configurations will be installed on the device.

## Create the Setup Manager configuration profile

 - Go to Computers > create a new profile
 - Name the profile 'Setup Manager'
 - assign a category, ensure the Level is set to 'Computer Level'
 - in payload sidebar select 'Application & Custom Settings', then select 'Jamf Applications'
 - click the '+ Add' button
 - for the 'Jamf Application Domain' choose `com.jamf.setupmanager`
 - for the version select the version of Setup Manager you are using
 - for the 'Variant', select `Setup Manager.json`
 
### Profile values
 - for the Icon Source, enter `name:NSComputer`. This is a special value that tells Setup Manager to use an image of the computer it is running on. There are many other options you can use as an icon source [documented here](../ConfigurationProfile.md#icon-source).
 - for the Title, enter `Welcome to Setup Manager!`
 - for the Message, enter `Please be patient while we set up your new Mac…`

### Enrollment 
 - under Enrollment Actions, click on 'Add Item'
  - for item 1, from the 'Select Action Type' popup, choose "Installomator"
  - for 'Action Label,' enter `Google Chrome`
  - for 'Action Icon Source,' enter `symbol:network`
  - for 'Installomator Label' enter `googlechromepkg`
  - click 'Add Item'
  - for item 2, from the 'Select Action Type' popup, choose "Shell Command"
  - under 'Command Arguments', click 'Add argument', enter `-setTimeZone`
  - click 'Add argument' again and enter your time zone in the format `Europe/Amsterdam` (the 'TZ identifier' [from this list](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones))
  - for 'Action Label,' enter `Set Time Zone`
  - for 'Action Icon Source,' enter `symbol:clock`
  - for 'Requires Root' select `true`
  - for 'Shell Command Path' enter `/usr/sbin/systemsetup`
  
You can add more actions here. There are more types of actions available, you can use a 'Jamf Policy Trigger' action to run a policy with a custom trigger. You can also use a 'Watch Path' action to wait for an app to be installed from the Mac App Store or Jamf App Installers.

## Scoping and Prestage

- scope the configuration profile to the computers you want to run Setup Manager on
- create a new Prestage or duplicate an existing one
- add the Setup Manager pkg and the configuration profile to the Prestage
- when installing and using Jamf Connect Login, ensure you have the latest version
- ensure that 'Automatically advance through Setup Assitant' is _disabled_
- have at least one Setup Assistant option which shows before user creation _disabled_ (so that _is_ displayed), we recommend the Location Services or Terms and Conditions pane
- ensure your test Mac(s) is (are) assigned to the Prestage

## Wipe the Test Mac

- on the test mac, choose 'Erase all Contents and Settings' in the Settings app or wipe the Mac using the 'Wipe Computer' remote management command in Jamf Pro
- click through the initial enrollment dialogs. After you approve the enrollment in your MDM, Setup Manger should appear and perform the actions you configured
- while the installations are progressing, click on "About this Mac…" for information, click again while holding down the option key for even more information
- hit command-L for a log window. You can also find this log info later at `/Library/Logs/Setup Manager.log`

## Next Steps

- add more [actions](../ConfigurationProfile.md#actions) to Setup Manager, you can use more Jamf Pro policies, Installomator labels, or shell actions
- automate computer naming with a [computer name template key](../ConfigurationProfile.md#computerNameTemplate)
- optionally, add [a `help` section](../ConfigurationProfile.md#help) to let the user know what is going on
- ideally automated deployments shouldn't require manual data entry, but if necessary, you can configure a [user entry](../ConfigurationProfile.md#user-entry) section in the profile
