# Jamf School: Setup Manager Quick Start

### Upload Setup Manager Package

Download the latest version of the Setup Manager installation pkg from the [releases page](https://github.com/Jamf-Concepts/Setup-Manager/releases)

Once you have the pkg it needs to be uploaded to Jamf School as an `In House macOS app` and can be done by logging into Jamf School and Navigating to

* **Apps** -> **Inventory** -> **click on + Add App** 
* Click **Add In-House macOS Package** 
* Navigate to the downloaded Jamf Setup Manager Package and drag into the window 
* Once uploaded click **Save** (no need to scope anything at this point)


### Prepare Jamf School In House macOS Apps, VPP Apps and Configurations

Setup Manager can "watch" for items in a particular file path on the volume. This is a great way to check if an app installed via VPP or In House macOS Apps (custom packages) are installed before moving on to the next action. 

If you intend to "watch" for an item in your Setup Manager workflow ensure to scope the app(s) in the conventional way. 

Other apps (that are not being monitored through Setup Manager) and profile configurations should be scoped to the target devices in the conventional way

*How you scope these additional items will depend on your deployment but as an example this could be done through the App Inventory menu or via a smart / static group.*

### Create the Setup Manager Configuration Profile

There are many actions and configurable items available for Setup Manager, which are well [documented here](https://github.com/Jamf-Concepts/Setup-Manager/blob/main/ConfigurationProfile.md). 

*It's worth noting that there are a number of actions that can be performed that are only available for Jamf Pro, these are clearly stated in the documentation.*

To help you get started on creating a Configuration Profile, there is a [sample profile](https://github.com/Jamf-Concepts/Setup-Manager/blob/main/Examples/sample-jamfschool.mobileconfig). 

This sample profile can then be edited using a text editor tool such as [BBEdit](https://www.barebones.com/products/bbedit/) or a tool specifically for editing plists and profiles, such as [PlistEdit Pro](https://www.fatcatsoftware.com/plisteditpro/). 

If you'd prefer to not edit in text format [iMazing Profile Editor](https://imazing.com/profile-editor) now has a community created payload specifically for Setup Manager which enables you to create a profile in a more user friendly GUI 

Once you have a configuration profile with the desired actions it should be uploaded to Jamf School. Navigate to

* **Profiles** -> **Overview** -> click **+Create Profile**
* Click **Upload Custom Profile** -> Find the configuration profile on your system and drag to the window
* Click **Next**
* Give the profile a name and description -> click **Next**
* Click **Finish**
* Click **Save** (no need to scope anything at this point)

### Automated Device Enrolment Profile & Scoping

Create a new ADE profile by Navigating to 

* **Profiles** -> **Automated Device Enrolment Profiles** -> click **+macOS**
* Fill out the profile as required for your deployment but **DO NOT** check the *Enable Zero-Touch Setup* box
* Click **Add** under profiles and select your *Jamf Setup Manager Configuration Profile* from the drop down menu
* Click **Add** under packages and select the *Jamf Setup Manager package* from the drop down menu
* Click **Save**

Finally scope the ADE profile to the required devices

### Wipe The Test Mac

* On the test mac, choose `Erase all Contents and Settings` in the Settings app or wipe the Mac using the `Erase Device` remote management command in Jamf Pro
* Click through the initial enrollment dialogs. After you approve the enrollment in your MDM, Setup Manager should appear and perform the actions you configured
* While the installations are progressing, click on "About this Mac…" for information, click again while holding down the option key for even more information
* Hit `command-L` for a log window. You can also find this log info later at `/Library/Logs/Setup Manager.log`

