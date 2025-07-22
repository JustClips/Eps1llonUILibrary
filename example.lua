local Eps1llonUI = require("src.Eps1llonUI")

local win = Eps1llonUI:CreateWindow({title = "Eps1llon Hub"})

win:AddLabel({text = "Rayfield-Style Slider (Rounded, Large)"})

win:AddSlider({
    text = "Volume",
    min = 0,
    max = 100,
    default = 50,
    onChange = function(val)
        print("Slider:", val)
    end
})
