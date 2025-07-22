local Eps1llonUI = require("src.Eps1llonUI")

local win = Eps1llonUI:CreateWindow({title = "Eps1llon Hub"})

-- Slider with value on left, label, custom width/font
win:AddSlider({
    min = 0,
    max = 1000,
    default = 750,
    width = 340,
    barHeight = 36,
    leftLabel = "Test",
    valueFont = Enum.Font.GothamBold,     -- change the font of value text
    labelFont = Enum.Font.GothamBlack,    -- change the font of the label (left of slider)
    onChange = function(val)
        print("Slider:", val)
    end
})

-- Toggle that looks like your image
win:AddToggle({
    default = false,
    width = 54,      -- width of toggle bar
    barHeight = 28,  -- height of toggle bar
    onChange = function(val)
        print("Toggle:", val)
    end
})
