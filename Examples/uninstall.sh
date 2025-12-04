#!/bin/sh

# uninstall.sh

# removes Setup Manager app and all related files

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

# Note:
# Setup Manager creates flag and data files at
#
# /private/var/db/.JamfSetupStarted
# /private/var/db/.JamfSetupEnrollmentDone
# /private/var/db/SetupManagerUserData.txt
#
# This uninstall script does NOT (yet) remove these files.
#
# When you re-install Setup Manager after running this script,
# the `.JamfSetupEnrollmentDone` flag file's existence will
# suppress the launch of Setup Manager.
#
# Depending on your workflow needs, you may want to preserve
# or remove these files during un-installation. Uncomment the
# respective `rm` lines at the end of this script.

appName="Setup Manager"
bundleID="com.jamf.setupmanager"

appPath="/Applications/Utilities/${appName}.app"

if [ "$(whoami)" != "root" ]; then
    echo "needs to run as root!"
    exit 1
fi

if launchctl list | grep -q "$bundleID.finished" ; then
    echo "unloading launch daemon"
    launchctl unload /Library/LaunchDaemons/"$bundleID".finished.plist
fi

if launchctl list | grep -q "$bundleID" ; then
    echo "unloading launch daemon"
    launchctl unload /Library/LaunchDaemons/"$bundleID".plist
fi

echo "removing files"
rm -rfv "$appPath"
rm -v /Library/LaunchDaemons/"$bundleID".plist
rm -v /Library/LaunchAgents/"$bundleID".loginwindow.plist
rm -v /Library/LaunchAgents/"$bundleID".finished.plist

echo "forgetting $bundleID pkg receipt"
pkgutil --forget "$bundleID"

# uncomment depending on which files you need to remove or preserve

# rm -v /private/var/db/.JamfSetupStarted
# rm -v /private/var/db/.JamfSetupEnrollmentDone
# rm -v /private/var/db/SetupManagerUserData.txt

# always exit success regardless of exit code of above commands
exit 0
