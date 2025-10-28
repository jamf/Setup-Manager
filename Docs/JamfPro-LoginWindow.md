#  Jamf Pro: Run Setup Manager at Login Window

By default, Setup Manager launches as soon as the installation completes. You can defer launching Setup Manager to launch when the macOS Login Window appears, instead.

When the `runAt` key in the profile is set to `loginwindow`, Setup Manager will not launch immediately after installation but when Login Window appears. In combination with the 'AutoAdvance' feature for automated device enrollment, this allows for completely 'hands-off' enrollment and configuration workflows.

However, this requires the enrollment workflow to be configured so that it will eventually end at Login Window, usually by connecting the Mac to a directory service.

## Prestage configuration

- Create or clone a new prestage to run Setup Manager at Login Window.

- Under 'General', under 'Setup Assistant', enable 'Automatically advance through Setup Assistant'. Select the language and region you want to assign to the Macs.

- Select all options to be skipped.

- Under 'Account Settings' choose to create a managed local administrator, configure the user name, password and other options.

- In 'Local User Account Type', select 'Skip Account Creation'

- Under 'Configuration Profiles', select the Setup Manager configuration profile. In that profile, set the [`runAt` key](../ConfigurationProfile.md#runAt) to `loginwindow`.

- Upload the Setup Manager installation pkg from the [Releases](https://github.com/jamf-concepts/setup-manager/releases) section to Jamf Pro and add it to the 'Enrollment Packages' section. Ensure you have selected 'Cloud Distribution Point' as the distribution point or setup the manifest for an on-premise deployment.

## Bind to directory

You will likely need to bind the Mac to a directory service to allow for user login after successful deployment. This can be triggered by a policy as an Setup Manager action.

## Auto Advance

The Apple feature to automatically advance through the Setup Assistant screens has a few requirements. The Mac has to be registered in Apple Business Manager or Apple School Manager and assigned to the MDM servier. It also has to be connected with ethernet to a network that can reach the MDM server, all Apple services and other internal services you might configure during enrollment (e.g. directory or IdP server).

Auto Advance doesn't 'kick in' until after Voiceover has introduced itself and if you ever touch any of the controls, AutoAdvance will stop and you have to continue manually.
