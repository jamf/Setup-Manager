# Single Touch workflow with Jamf Pro and Jamf Connect

## What is Single Touch?

In a single touch workflow a tech performs or monitors the initial setup of a device to the point just before the user creates their account. While Setup Manager can run zero-touch workflows, it was built specifically with single-touch workflows in mind.

A single touch workflow can be as easy the tech unpacking the Mac (erasing it with an MDM command or restoring it with Apple Configurator when necessary), connecting it to network, stepping through the initial Setup dialogs, optionally entering the asset tag or other data, monitoring Setup Manager's process until it is finished and then handing over or sending the Mac to the designated end user who continues the setup and creates their account in Setup Assistant.

You can use a combination of Jamf Pro, Setup Manager and Jamf Connector, to get a tighter deployment, user assignment and account creation process. This requires a bit more setup and configuration. This workflow allows the tech to monitor the Setup Manager workflow, enter device specific data such as an asset tag and assign _and lock_ the device to a different user, without requiring the end user's login credentials.

## What you need

- Jamf Pro
- Setup Manager
- Jamf Connect Login configured with SSO

Customized Enrollment with SSO is not _required_ for this workflow. The assignment to the final user is set from the email entered in Setup Manager. Nevertheless, customized enrollment with SSO is useful in this context since restricts Mac enrollment to a group of authorized accounts.

You should have Jamf Pro and Jamf Connect configured with the required SSO integrations and thoroughly tested before configuring this workflow. 

Verify that "Collect User and Location information from Directory Service" is **enabled** in Settings > Computer management > Inventory collection.

## Configure Setup Manager

Add the Setup Manager pkg to the Prestage. Also create a configuration profile for Setup Manager with the workflow to install and configure the software you want to be installed at this stage.

You need to leave least one panel of Setup Assistant _enabled_. Otherwise Setup Manager might not launch.

Setup Manager profile will require a `userEntry` field for `userID` to know which user to assign the Mac to. This will show a field prompting for "User Email." You can of course add other fields to `userEntry` at this time, though they are not required.

Example:

```xml
<key>userID</key>
<dict>
  <key>placeholder</key>
  <string>first.last@example.com</string>
  <key>validation</key>
  <string>\S+\.\S+\@example\.com</string>
  <key>validationMessage</key>
  <string>Email needs to be for example.com!</string>
  <key>validationMessage.de</key>
  <string>Email muss für example.com sein!</string>
</dict>
```

## Deploy Jamf Connect

You also need to make sure that Jamf Connect (Login) is deployed is installed and configured. There are different approaches to do this.

- add Jamf Connect pkg to prestage
- install Jamf Connect with a pkg policy triggered from Setup Manager workflow
- install Jamf Connect with Installomator action in Setup Manager workflow
- install Jamf Connect with Jamf App Installers

When you upload the Jamf Connect pkg to Jamf Pro and add it to either the Prestage or a policy, you retain control over which version of Jamf Connect gets deployed. With Installomator or Jamf App Installer you will always get the latest available version.

When you use Jamf App Installers you have no direct control over when the installation actually occurs. You should add a `watchPath` action at the end of your `enrollmentActions` array in the Setup Manager profile to ensure that Jamf Connect is installed before proceeding:

```xml
<dict>
  <key>label</key>
  <string>Jamf Connect</string>
  <key>icon</key>
  <string>symbol:app.badge</string>
  <key>watchPath</key>
  <string>/Applications/Jamf Connect.app</string>
  <key>wait</key>
	<integer>900</integer>
</dict>
```

## Create Extension Attribute

The email entered for userID will be submitted to Jamf Pro at the end of the Setup Manager workflow. When the Setup Manager workflow is done a flag file will be created at `/private/var/db/.JamfSetupEnrollmentDone`. We can use this to scope profiles and policies to Macs that have finished the Setup Manager workflow.

Create an Extension attribute named "Setup Manager Done" with the script code:

```sh
if [ -f "/private/var/db/.JamfSetupEnrollmentDone" ]; then
  echo "<result>done</result>"
else
  echo "<result>incomplete</result>"
fi
```

Then create a Smart Group named "Setup Manager Done" with the criteria `"Setup Manager Done" is "done"`.

## Pre-set user for Jamf Connect

Note: this step only works with Entra ID as the Identity Provider.

Jamf Connect Login allows pre-configuring the user. Create a configuration profile named "Jamf Connect Enrollment User" to the preference domain `com.jamf.connect.login` with the following property list:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>EnrollmentRealName</key>
  <string>$REALNAME</string>
  <key>EnrollmentUserName</key>
  <string>$EMAIL</string>
</dict>
</plist>
```

Scope this configuration profile the "Setup Manager Done" smart group you created earlier.

With this setup, the configuration profile that presets the user in Jamf Connect Login will be pushed out after Setup Manager finishes its final recon, which sets the user information to the Mac in Jamf Pro.
