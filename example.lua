local Eps1llonUI = require("src/Eps1llonUI")

local window = Eps1llonUI:CreateWindow({title = "Executor UI Example"})
window:AddLabel({text = "Welcome!"})
window:AddButton({text = "Print Hello", onClick = function()
    print("Hello from Eps1llonUI!")
end})
