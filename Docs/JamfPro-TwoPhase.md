#  Jamf Pro: extra installations based on user data entry

In this simple example workflow, we run certain Jamf Pro policies depending on the department. This example can be expanded to other user entry data fields.

- create Setup Manager configuration profile
  - create a `userEntry` key with a list of options for the department:

```xml
<key>userEntry</key>
<array>
  <dict>
    <key>identifier</key>
    <string>department</string>
    <key>options</key>
    <array>
      <string>Sales</string>
      <string>Development</string>
      <string>IT</string>
      <string>Marketing</string>
    </array>
  </dict>
</array>
```

Note that you need to have the matching departments in Jamf Pro.

- add the `enrollmentActions` that should run on all computers first
- then add a `waitForUserEntry` action:

```xml
<dict>
  <key>label</key>
  <string>Submit entries</string>
  <key>waitForUserEntry</key>
  <string/>
</dict>
```

When Setup Manager reaches this action it will wait for the user data entry to be complete if it isn't already. Then Setup Manager will submit the data from the user entry to Jamf Pro and run a recon, so you can use the data for scoping subsequent policies.

Setup Manager also saves the data from user entry in a plain text file which you can use in policy scripts after the `waitForUserEntry` action. [See details here.](Extras.md#user-data-file)

- Insert this action 

``` xml
<dict>
  <key>icon</key>
  <string>symbol:plus.app</string>
  <key>label</key>
  <string>Extra Apps for %department%</string>
  <key>policy</key>
  <string>install_extra_apps</string>
</dict>
```

- for the policies you want run/install depending on the user entry:
  - give the policy a custom trigger matching the trigger in 'Extra Apps' action: `install_extra_apps`
  - scope the policy to the department(s) that should receive the installations
  - repeat for every extra installation that depends on the user entry

