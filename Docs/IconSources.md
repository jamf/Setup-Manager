# Icon Sources

Icons (which include the top-level `icon`, the `background` and the `icon`s in individual actions) can be defined in several ways in Setup Manager.

## From the web

When the icon source string starts with `http` or `https`, Setup Manager will attempt to download a file from that URL and interpret it as an image file. It will show a spinning progress view while downloading.

```xml
<key>icon</key>
<string>https://example.com/path/to/icon.png</string>
```

## Local file

When the icon source is an absolute file path, Setup Manager will attempt to read that file as an image file and display it.

```xml
<key>icon</key>
<string>/Library/Organization/image.png</string>
```

You will need to install custom local image files _before_ Setup Manager runs.

With Jamf Pro, you can achieve that by adding another pkg to the Prestage. Since the Prestage installs pkgs in alphabetical order, this branding pkg should be named to be alphabetically _before_ "Setup Manager."

## Application:

When the icon source is an absolute file path that ends in `.app`, Setup Manager will get the icon from that app.

```xml
<key>icon</key>
<string>/System/Applications/App Store.app</string>
```

## Name:

When the icon source starts with `name:`, Setup Manager will get the icon with that name. Two names are useful: `AppIcon` gets Setup Manager's app icon and `NSComputer` will get an icon representing the current hardware.

```xml
<key>icon</key>
<string>name:AppIcon</string>
```

## SF Symbols:

When the icon source starts with `symbol:`, Setup Manager will create the icon using that symbol's name. You can look up symbol names using the [SF Symbols](https://developer.apple.com/sf-symbols/) app.

Note that the availability and appearance of SF Symbols may vary with the OS version and language/region.

```xml
<key>icon</key>
<string>symbol:clock</string>
```

## Color

(v1.4)

When the icon source starts with `#`, Setup Manager will interpret it as a hex color.

You can use hex color notation with three digits, e.g `#0f0` or six digits, e.g. `#f900a2`. 

You can also use named system colors with two leading `##`, e.g `##yellow` or `##primary`. 

(See ['Defining Colors'](Colors.md) for details.)

```xml
<key>background</key>
<string>##white</string>
```

```xml
<key>background</key>
<string>#aaa</string>
```

## Dark Mode

Note: after enrollment, over Setup Assistant, the system is always in light mode. This is only relevant when you use Setup Manager after user-initiated enrollment or launch it otherwise over user space.

To provide alternative images for dark or light mode, change the `string` defining the image to a dictionary with a `dark` and a `light` key. This works with the `background`, `icon`, and each action's `icon`. This also works with the `accentColor` key.

Setup Manager does _not_ monitor the appearance mode, so if it changes _while_ Setup Manager is running, things will not update consistently.

Example: 

```xml
<key>icon</key>
<dict>
  <key>dark</key>
  <string>name:Jamf_white</string>
  <key>light</key>
  <string>name:Jamf_blue</string>
</dict>
```
