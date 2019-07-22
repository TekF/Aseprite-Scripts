# Aseprite Scripts

To use, download the .lua files and put them in [Aseprite's user script folder](https://community.aseprite.org/t/locate-user-scripts-folder/2170).

## Parallax

[parallax.lua](https://raw.githubusercontent.com/TekF/Aseprite-Scripts/master/parallax.lua) (Right-click and "Save as")
![demo](https://github.com/TekF/Aseprite-Scripts/blob/master/demos/parallax%20demo.gif)

By default each layer moves twice as fast as the one below.

To control speed manually, add `s=<speed>` to the layer names, like this:

![layer names](https://raw.githubusercontent.com/TekF/Aseprite-Scripts/master/demos/parallax%20layer%20names.png)
![demo speeds](https://raw.githubusercontent.com/TekF/Aseprite-Scripts/master/demos/parallax%20demo%20speeds.gif)

It also supports non-integer speeds. For example a speed of 1.5 will move alternately between moving by 1 pixel or 2 pixels, to give an average movement of 1.5 pixels.

![non-int](https://raw.githubusercontent.com/TekF/Aseprite-Scripts/master/demos/parallax%20non-integers.png)
![suburban](https://raw.githubusercontent.com/TekF/Aseprite-Scripts/master/demos/parallax%20test%20suburbs.gif)

#### Update

Put "w=x", "w=y", or "w=xy" in the layer name to wrap the layer on the x and/or y axes. It wraps at either the layer bounds or the image bounds - whichever's bigger.
