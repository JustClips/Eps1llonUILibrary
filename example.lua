local Eps1llonUI = require("src.Eps1llonUI")

local win = Eps1llonUI:CreateWindow({title = "Eps1llon Hub"})

win:AddLabel({text = "Thick Square Slider Demo"})

win:AddSlider({
    min = 0,
    max = 1000,
    default = 750,
    onChange = function(val)
        print("Slider:", val)
    end
})
