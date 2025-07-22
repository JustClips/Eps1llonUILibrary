# Eps1llonUILibrary

Eps1llonUILibrary is a UI library for Roblox executors, making it easy to add custom GUIs to your scripts.

## Features
- Window/frame creation
- Button and label components
- Simple API for expansion

## Usage Example
```lua
local Eps1llonUI = require(path.to.Eps1llonUI)

local window = Eps1llonUI:CreateWindow({title = "My Executor"})
local button = window:AddButton({text = "Run Script", onClick = function()
    print("Script executed!")
end})
window:AddLabel({text = "Welcome to Eps1llon!"})
```

## Getting Started
Copy the library from `src/Eps1llonUI.lua` into your Roblox executor environment and use as shown above.
