# YUI 0.6.6
## A UI system for GameMaker by [@shdwcat](https://github.com/shdwcat)

### Why YUI?
Writing UI code is annoying and tedious! Why write UI code when you can edit readable text files instead?

#### Notable features
- [Live Reload](https://github.com/shdwcat/YUI/wiki/Live-Reload) while the game is running!
- Flexible and powerful [Data Binding](https://github.com/shdwcat/YUI/wiki/Data-Binding) and [Embedded Scripting](https://github.com/shdwcat/YUI/wiki/YuiScript) system to get your game data into the UI
- [Template](https://github.com/shdwcat/YUI/wiki/Templates) system lets you design and re-use [custom widgets](https://github.com/shdwcat/YUI/wiki/Custom-Widgets)
- UI Animation system - slide/fade/etc! Also supports color curves, animation sequences, and custom effects
- [Theme](https://github.com/shdwcat/YUI/wiki/Themes) system and widget styles
- Powerful [Drag and Drop](https://github.com/shdwcat/YUI/wiki/Drag-and-Drop) feature built in (no coding!)
- VS Code syntax highlighting extension:
  https://marketplace.visualstudio.com/items?itemName=shdwcat.yui-vs-code-support
  ![syntax highlighting example image](https://github.com/shdwcat/yui-vs-code-support/raw/HEAD/images/highlighting.png)

### Platform Support
YUI is confirmed to work on Windows, Mac, and Linux. YUI does not *yet* work on HTML5 as included file handling needs to be fixed (#72). As far as I know, YUI has not been tested on mobile or consoles, if you want to try it out, please do and let me know if it works! (see Discord link below).

### Library Support
YUI has built-in optional support for the popular Scribble and Input libraries. These are NOT included with YUI by default but can be added for more features.

* **[Scribble 8.7.0](https://github.com/JujuAdams/scribble)** - Advanced Text Rendering

  YUI is designed to be compatible with Scribble 8.7.0 and future 8.x.x versions, and may be compatible with previous 8.x.x versions.

  When Scribble is included in your project, you can set `scribble: true` on a `text` element to access standard Scribble text formatting features.

  See the Scribble documentation for how to set up Scribble and what formatting features are available

* **[Input 6.1.5](https://github.com/offalynne/input)** - Mouse/Keyboard/Gamepad/Touch Support

  YUI is designed to be compatible with Input 6.1.5 and future 6.x.x versions, and may be compatible with previous 6.x.x versions.

  When Input is included in your project and YUI is configured to use it for navigation, the gamepad will be able to navigate the UI similar to the standard keyboard navigation support. (Touchpad support is untested currently!)

  Please see https://github.com/shdwcat/YUI/wiki/Input for how to configure YUI to use Input!

### OK, where do I start?
You can either clone the Example Project (this repo) to play around with it, or import the latest package from the [Releases](https://github.com/shdwcat/YUI/releases) page.

Please note that the [Wiki](https://github.com/shdwcat/YUI/wiki) is quite out of date (but may still be useful).

### The Example Project
Contained in this repo is the YUI Example project. If you clone the repo locally you can run the project to get an idea of what YUI is capable of. The Example Project is still a work in progress, but make sure to check out the Inventory Screen for an example of how to quickly set up drag and drop!

### Help!
If you need help with anything, please stop by the GameMaker Kitchen discord:
https://discord.gg/8krYCqr

### Dependencies
YUI has a number of dependencies, which are automatically included in the project.

- [Inspectron](https://github.com/shdwcat/Inspectron) - runtime instance debug overlays

Credit to [@jujuadams](https://github.com/JujuAdams):
- [Gumshoe](https://github.com/JujuAdams/Gumshoe) - file finder

And [@offalynne](https://github.com/offalynne):
- [input-string](https://github.com/offalynne/input-string) - text input backend

### Credits
<div>Some icons made by <a href="https://www.flaticon.com/authors/pixel-perfect" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
(Specifically the 'yui_error' icon)
