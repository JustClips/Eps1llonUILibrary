local Eps1llonUI = {}
Eps1llonUI.__index = Eps1llonUI

function Eps1llonUI:CreateWindow(props)
    local window = setmetatable({
        title = props.title or "Window",
        elements = {}
    }, {
        __index = function(tbl, key)
            return Eps1llonUI[key]
        end
    })
    return window
end

function Eps1llonUI:AddButton(props)
    local button = {
        text = props.text or "Button",
        onClick = props.onClick or function() end
    }
    table.insert(self.elements, button)
    return button
end

function Eps1llonUI:AddLabel(props)
    local label = {
        text = props.text or "Label"
    }
    table.insert(self.elements, label)
    return label
end

return setmetatable({}, Eps1llonUI)
