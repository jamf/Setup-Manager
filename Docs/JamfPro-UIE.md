#  Running Setup Manager at User Initiated Enrollment

While we strongly recommend to use Automated Device Enrollment where possible, we understand there are many situations where manual enrollment is still required. Setup Manager works fine after profile based device enrollment (also called User-initiated enrollment or UIE), but there are few things to consider.

## Installation at User Initiated Enrollment

Since Prestage enrollment packages are only installed during Automated Device Enrollment, you need to create a policy which installs the Setup Manager pkg and attach that to the `enrollmentComplete` trigger.

Create the Setup Manager profile and make sure it is scoped in a way that it will reach the device immediataly at enrollment. For example, you can create a smart group on the criterium `Enrolled via Automated Device Enrollment` `is` `No` to gather all Macs _not_ enrolled with ADE.

## Troubleshooting

With UIE, there _will_ be an unvoidable short delay between the enrollment and when Setup Manager launches. If the pause is very long, you will need to analyse jamf.log and install.log to see where the time is spent. Setup Manager logs will show some events that occur even before Setup Manager is installed and launches, but the time information might be lost or not represented. Use the suggestions here for reducing the time to launch.

## Workflow and Profile

Once Setup Manager launches it will work through the actions in the profile same as with Automated Device Enrollment. We recommend setting a `background` to block access to other apps while Setup Manager is running. If you don't have a custom background/wallpaper image, you can set `background` to `/System/Library/CoreServices/DefaultDesktop.heic` to use the default wallpaper.

Even though Setup Manager works basically the same, there are enough differences between the environment after User Initiated Enrollment, where the system is already set up, the user account already exists, and the user may have already done installations and configuration that you should revisit your enrollment workflow actions in Setup Manager and consider them in this context. You will likely use a modified workflow and Setup Manager workflow for manual enrollment.
