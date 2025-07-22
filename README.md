# Eps1llonUILibrary

A modern, animated UI library for Roblox executors with a clean, outlined design and smooth interactions.

## Features

- Draggable window (smooth animation)
- Rayfield-style slider (full fill, no knob, smooth)
- Easy-to-use API for scripts

## Example Usage

```lua
local Eps1llonUI = require(path.to.Eps1llonUI)

local win = Eps1llonUI:CreateWindow({title = "Eps1llon Hub"})

win:AddLabel({text = "Rayfield-Style Slider Demo"})

win:AddSlider({
    text = "Volume",
    min = 0,
    max = 100,
    default = 50,
    onChange = function(val)
        print("Slider:", val)
    end
})
```

---

## Getting Started

- Copy `src/Eps1llonUI.lua` into your executor’s workspace.
- `require` it as shown above.
