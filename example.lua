# Eps1llonUILibrary

A modern, animated UI library for Roblox executors with a clean, outlined design and smooth interactions.

## Features

- Draggable, square window (rounded, but less smooth corners)
- Slider with curved-square background, bar with slightly rounded corners, value always at left
- Easy-to-use API for scripts

## Example Usage

```lua
local Eps1llonUI = require(path.to.Eps1llonUI)

local win = Eps1llonUI:CreateWindow({title = "Eps1llon Hub"})

win:AddLabel({text = "Square Window, Curved Slider"})

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
