# Defining Colors

Colors are defined with strings in the profile.

When the icon source starts with `#`, Setup Manager will interpret it as a hex color.

You can use hex color notation with three digits, e.g `#0f0` or six digits, e.g. `#f900a2`. 

Example: 

```xml
<key>accentColor</key>
<string>#FF00AA</string>
```

(v1.4) You can also use named system colors with two leading `##`, e.g `##yellow` or `##primary`. Available color names are:

```
 primary         primary text color, black in light mode, white in dark mode
 secondary       slightly muted variant of primary
 accentColor     color used for controls, set with `accentColor`
 background      system window background color
 clear           no background/transparent (1)
 black           (1)
 blue
 brown
 cyan
 gray
 green
 indigo
 mint
 orange
 pink
 purple
 red
 teal
 white           (1)
 yellow
```

(1) All colors will automatically adapt to dark or light mode, _except_ `clear`, `black`, and `white`.

Example:

```xml
<key>accentColor</key>
<string>##green</string>
```

## Dark mode

If you want different accent colors depending on whether the system is in light or dark mode, provide a `dict` with two keys, for `light` and `dark` mode: (Note: most named system colors adapt automatically)

Example:

```xml
<key>accentColor</key>
<dict>
  <key>dark</key>
  <string>#FF00AA</string>
  <key>light</key>
  <string>#AA0055</string>
</dict>
```
