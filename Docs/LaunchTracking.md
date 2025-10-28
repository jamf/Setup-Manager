# Launch and Completion Tracking in Setup Manager

Setup Manager sends tracking signals to a service we use to gather usage data. Currently (since 1.4) the service is [TelemetryDeck](https://telemetrydeck.com/). Older versions use [pendo.io](https://pendo.io).

In the ping, some data is transferred to the service, and the time and date of the signal are recorded.

This is the data in the signal:

- macOS system version and build
- Setup Manager version
- Device management service: Jamf Pro or Jamf School
- A hash of the device management server url. This allows us to see how many devices are enrolled with a particular device management server, but we _cannot_ identify _which_ particular customer or server it is

Setup Manager version 1.4 adds the following info to the signal.

- Device information (model identifier, architecture)
- Language and Region settings, preferred and actual
- Color scheme choice: dark or light mode
- Duration of the Setup Manager workflow
- Running after enrollment, at login window, or over user space
- Fatal errors (Setup Manager giving up completely, individual errors in actions are **not** tracked)

No signals are sent when `DEBUG` is set to `true`. The signal is sent to `nom.telemetrydeck.com`. 

We use this data to determine the usage of Setup Manager and where to focus future development, so we appreciate when you let us gather this data.

You can suppress the tracking signal by setting the `PLEASE_DO_NOT_TRACK' boolean key to `true` in the configuration profile.
