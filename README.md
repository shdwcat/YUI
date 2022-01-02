# YUI (pre-alpha)
## A UI system for GMS2 by [@shdwcat](https://github.com/shdwcat)

**NOTE:** YUI is ***not*** ready for use in production code yet!

**NOTE:** There is currently a GMS2 bug with running in VM mode *without* the debugger. Please use the debugger or YYC for now!

### Why YUI?
Writing UI code is annoying and tedious! Why write UI code when you can edit readable text files instead?

Notable features:
- Live Reload while the game is running!
- Simple but flexible data-binding system to get your game data into the UI
- Template system lets you design and re-use custom widgets
- Powerful Drag and Drop feature built in (no coding!)

Future features:
- Theme system and widget styles
- Animation (slide/fade/etc)

### OK, where do I start?
You can either clone the Example Project (this repo) to play around with it, or import the latest package from the Releases page.

Documentation is available on the Wiki (may be out of date at times)

### The Example Project
Contained in this repo is the YUI Example project. If you clone the repo locally you can run the project to get an idea of what YUI is capable of. The Example Project is still a work in progress, but make sure to check out the Inventory Screen for an example of how to quickly set up drag and drop!

### Dependencies
YUI has a number of dependencies, which are automatically included in the project.

Credit to the amazing [@jujuadams](https://github.com/JujuAdams):
- [Scribble](https://github.com/JujuAdams/Scribble) - Text renderer
- [SNAP](https://github.com/JujuAdams/SNAP) - YAML reader
- [Gumshoe](https://github.com/JujuAdams/Gumshoe) - File finder
