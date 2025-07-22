# Eps1llonUILibrary

A modern, animated UI library for Roblox executors with a clean, outlined design and smooth interactions.

## Features

- Draggable window (smooth animation)
- Sidebar for navigation (coming soon)
- Sectioned content area
- Animated slider and dropdown
- Easy-to-use API for scripts

## Example Usage

```lua
local Eps1llonUI = require(path.to.Eps1llonUI)

local win = Eps1llonUI:CreateWindow({title = "Eps1llon Hub"})

win:AddLabel({text = "Welcome!"})

win:AddSlider({
    text = "Volume",
    min = 0,
    max = 100,
    default = 50,
    onChange = function(val)
        print("Slider:", val)
    end
})

win:AddDropdown({
    text = "Theme",
    choices = {"Blue", "Red", "Green"},
    default = "Blue",
    onSelect = function(val)
        print("Theme selected:", val)
    end
})
```

---

## Getting Started

- Copy `src/Eps1llonUI.lua` into your executor’s workspace.
- `require` it as shown above.
- All UI is self-contained and easy to extend.
