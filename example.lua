local Eps1llonUI = require("src.Eps1llonUI")

local win = Eps1llonUI:CreateWindow({title = "Eps1llon Hub"})

win:AddLabel({text = "InputBox Example"})
win:AddInput{
    placeholder = "Enter your username...",
    onChange = function(text) print("Input:", text) end
}

win:AddLabel({text = "Dropdown Example"})
win:AddDropdown{
    options = {"Apple", "Banana", "Cherry"},
    default = "Banana",
    onChange = function(option) print("Dropdown:", option) end
}

win:AddLabel({text = "Slider Example"})
win:AddSlider{
    min = 0,
    max = 100,
    default = 50,
    width = 320,
    leftLabel = "Volume"
}

win:AddLabel({text = "Toggle Example"})
win:AddToggle{
    default = false,
    onChange = function(val) print("Toggle:", val) end
}
