# Eps1llonUILibrary

A modular Roblox executor UI library with easy-to-use, scriptable components.

## Features

- Window/frame creation (draggable)
- Button, label, toggle, slider, textbox, dropdown
- Notification/popup support
- Simple API — all components are added by method
- Easy to copy into any script executor

## Example Usage

```lua
local Eps1llonUI = require(path.to.Eps1llonUI)

local win = Eps1llonUI:CreateWindow({title = "My Executor"})

win:AddLabel({text = "Welcome!"})

win:AddButton({text = "Print", onClick = function()
    print("Button pressed!")
    win:Notify({text = "Hello, world!"})
end})

win:AddToggle({text = "Enable Stuff", default = false, onToggle = function(val)
    print("Toggled:", val)
end})

win:AddSlider({text = "Volume", min = 0, max = 100, default = 50, onChange = function(val)
    print("Slider:", val)
end})

win:AddTextbox({placeholder = "Type here", onEnter = function(txt)
    print("You typed:", txt)
end})

win:AddDropdown({choices = {"A", "B", "C"}, default = "B", onSelect = function(val)
    print("Dropdown picked:", val)
end})
```

---

## Getting Started

- Copy `src/Eps1llonUI.lua` into your executor’s workspace.
- `require` it as shown above.
- All UI is self-contained and easy to extend.
