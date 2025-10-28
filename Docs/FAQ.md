#  Frequently Asked Questions

## Is there a custom JSON Schema for Jamf Pro?

[Yes.](Extras.md#custom-json-schema-for-jamf-pro)

## Can you block the user desktop with user initiated enrollment?

Yes, use the top-level `background` key and point it to a local image file or a http URL to an image file. If you don't want custom branding, you can set `background` to `/System/Library/CoreServices/DefaultDesktop.heic` for the default image.

## Setup Manager is not launching after enrollment

There can be many causes for this. A few common causes are:
 
- when running at 'enrollment,' you need at least one of the 'Setup Assistant Options' in the Prestage to be set to _not_ skip. 'Location Services' or 'Terms & Conditions' are a good choice that you generally want to leave up the user anyway. Otherwise, Setup Assistant may quit before Setup Manager can launch and do its actions.
- when using a distribution point other than Jamf Cloud Distribution Point, you need [to provide a manifest](https://appleshare.it/posts/use-manifest-file/)
- Jamf Pro: 
    - check that Setup Manager is added to your Prestage and the package does not have the label "Availability pending" in Settings> Packages
    - in Prestage > Enrollment Packages verify that the Distribution Point is set correctly (it resets to "none" when you remove the last enrollment package, so this is easy to miss)
    - you can try deleting the Setup Manager pkg from Packages and re-uploading it
    - verify that the pkg is not installed during Prestage by checking for the presence of `Setup Manager.app` in `/Applications/Utilities`, if the app does not exist, the Prestage is not installing Setup Manager
    - when the above steps do not remedy the issue, please engage Jamf Support.

## Does Setup Manager require Jamf Connect

No.

Setup Manager will run fine without Jamf Connect. You can even build 'single-touch' style workflows with Setup Manager without Jamf Connect. Some workflows, such as pre-assigning a device to a specific user require Jamf Connect, though.

## How can I use the icon for an app before the app is installed?

- preinstall icon files with a custom package installer in prestage. Set the priority of the media/branding package lower than that for Setup Manager, or give the branding/media package a name that is alphabetically earlier than Setup Manager, so it installs before Setup Manager
- use http(s) urls to the image files
    - you can host them on a web server/service that you have control over
    - you can add the icon to a Self Service policy in Jamf and then copy the url to the icon once uploaded


## What is happening during "Getting Ready" and "Finishing"?

During the "Getting Ready" phase, Setup Manager is waiting for the enrollment configuration to be complete. The steps taken during these phases depend on the version of Setup Manager and the management system.

When enrolled into Jamf Pro, Setup Manager runs (among other things) a recon/Update Inventory during "Getting Ready" and "Finishing." This will make up most of the time in these phases.

You can open the log window (command-L) or review the [log file](Extras.md#logging) for detail for each step. Should Setup Manager stall during one of these steps, you can [quit](Extras.md#quit) out of Setup Manager and review the [log file](Extras.md#logging) after completing the setup.

## (Jamf Pro) Getting Ready is taking very long (several minutes). What is happening and can I do something to make it faster?

The "Getting Ready" phase prepares some steps and waits for all essential Jamf Pro components (the jamf binary, certificates, Jamf.app, etc.) to be installed and configured before starting with the actual enrollment workflow. Depending on the network connection this might take a while.

Note that you can see the individual steps and the timing for each step in the [Setup Manager log file](Extras.md#logging)].

Once Jamf Pro's enrollment workflow is complete, Setup Manager runs a full update inventory/recon. In general, if the recon takes a long time, you should review the inventory collection settings. Calculating home directory sizes and gathering fonts can take a lot of time and CPU power, and speed up things significantly when turned off, not just during enrollment with Setup Manager.  You should also review extension attributes, for how long each one runs.

Mac App Store/VPP and Jamf App Installer apps that are scoped to the computer will also begin installing _immediately_ after enrollment. Since macOS will only perform one installation at a time, these might delay the installation of essential Jamf Pro components. You can create smart groups to defer these installations.

With Setup Manager 1.3 and higher, you can check whether apps are getting installed before Setup Manager starts the actions in the Setup Manager log.


## Can I set the wallpaper/desktop picture or dock with Setup Manager?

The settings for the dock and wallpaper/desktop picture are _user_ settings. Since the user account usually does not yet exist when Setup Manager runs, you cannot affect those settings.

What you can do is run a script at login which sets the desktop (using [desktoppr](https://github.com/scriptingosx/desktoppr) ) or the dock (using [dockutil](https://github.com/kcrawford/dockutil) or a similar tool).

## If Setup Manager cannot do it, how can I run scripts at first login

There are several options:

- Jamf Pro: [Self Service macOS Onboarding](https://learn.jamf.com/en-US/bundle/jamf-pro-documentation-current/page/macOS_Onboarding.html)
- Jamf Pro: [policy with a login trigger](https://learn.jamf.com/en-US/bundle/jamf-pro-documentation-current/page/Login_Events.html)
- custom launch agent
- [outset](https://github.com/macadmins/outset/)

## Can Setup Manager run at first login, rather than right after enrollment?

Technically, yes.

With Jamf Pro, you can set the Setup Manager pkg to install at the `login` trigger or manually from Self Service. Then it will launch within the user session.

This is not, however, the primary workflow for Setup Manager and not something that we will test or verify. We believe running right after enrollment over Setup Assistant is the preferable deployment.

With Jamf Pro, you should consider [macOS Onboarding in Self Service](https://learn.jamf.com/en-US/bundle/jamf-pro-documentation-current/page/macOS_Onboarding.html) or a [login trigger](https://learn.jamf.com/en-US/bundle/jamf-pro-documentation-current/page/Login_Events.html) instead.

## Installer or Policy Script is failing with access errors

For some policy scripts or installers it may be necessary to give the Setup Manager app Full Disk Access or some other exemptions with a PPPC Profile. 

## Installomator actions are all failing

The log shows exit code 4, which means the download was rejected.

Installomator uses Gatekeeper to verify the downloads. When Gatekeeper is set to allow Mac App Store apps only it will reject all third party apps and installers and the verification will fail.

## Can I set Installomator variables?

Yes. The `installomator` action has an `arguments` key, which takes an array strings, one for each argument. With this, you can override variables in Installomator.

Example: 

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
