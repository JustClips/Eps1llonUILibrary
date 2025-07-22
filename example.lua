local Eps1llonUI = require("src.Eps1llonUI")

local win = Eps1llonUI:CreateWindow({title = "Executor Demo"})

win:AddLabel({text = "Welcome to Eps1llonUILibrary!"})

win:AddButton({text = "Click Me", onClick = function()
    print("Clicked!")
    win:Notify({text = "You clicked the button!"})
end})

win:AddToggle({text = "Godmode", default = false, onToggle = function(state)
    print("Godmode:", state)
end})

win:AddSlider({text = "Speed", min = 1, max = 100, default = 10, onChange = function(val)
    print("Speed:", val)
end})

win:AddTextbox({placeholder = "Enter a command", onEnter = function(txt)
    print("Command:", txt)
end})

win:AddDropdown({choices = {"Red", "Green", "Blue"}, default = "Green", onSelect = function(val)
    print("Color picked:", val)
end})
