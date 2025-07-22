local Eps1llonUI = {}
Eps1llonUI.__index = Eps1llonUI

-- Helper functions
local function createInstance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

-- Window
function Eps1llonUI:CreateWindow(props)
    props = props or {}
    local selfWindow = setmetatable({
        title = props.title or "Window",
        elements = {},
        _frame = nil
    }, {__index = self})

    -- Create the main frame
    local screenGui = createInstance("ScreenGui", {Name = selfWindow.title.."GUI", ResetOnSpawn = false, Parent = game:GetService("CoreGui")})
    local frame = createInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = screenGui,
        Active = true,
        Draggable = true
    })
    selfWindow._frame = frame

    -- Title bar
    local titleBar = createInstance("TextLabel", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        Text = selfWindow.title,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        Parent = frame
    })

    selfWindow._nextY = 35
    selfWindow._frame = frame
    return selfWindow
end

-- Add a label
function Eps1llonUI:AddLabel(props)
    local label = createInstance("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, self._nextY),
        Text = props.text or "Label",
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        Parent = self._frame
    })
    self._nextY = self._nextY + 30
    table.insert(self.elements, label)
    return label
end

-- Add a button
function Eps1llonUI:AddButton(props)
    local button = createInstance("TextButton", {
        Name = "Button",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, self._nextY),
        Text = props.text or "Button",
        BackgroundColor3 = Color3.fromRGB(60,60,60),
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 18,
        Parent = self._frame
    })
    button.MouseButton1Click:Connect(function()
        if props.onClick then props.onClick() end
    end)
    self._nextY = self._nextY + 35
    table.insert(self.elements, button)
    return button
end

-- Add a toggle (checkbox)
function Eps1llonUI:AddToggle(props)
    local toggled = props.default or false
    local toggleBtn = createInstance("TextButton", {
        Name = "Toggle",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, self._nextY),
        BackgroundColor3 = Color3.fromRGB(60,60,60),
        Text = ((toggled and "☑ ") or "☐ ") .. (props.text or "Toggle"),
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        Parent = self._frame
    })
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        toggleBtn.Text = ((toggled and "☑ ") or "☐ ") .. (props.text or "Toggle")
        if props.onToggle then props.onToggle(toggled) end
    end)
    self._nextY = self._nextY + 35
    table.insert(self.elements, toggleBtn)
    return toggleBtn
end

-- Add a slider
function Eps1llonUI:AddSlider(props)
    local min, max = props.min or 0, props.max or 100
    local value = props.default or min
    local sliderFrame = createInstance("Frame", {
        Name = "Slider",
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, self._nextY),
        BackgroundTransparency = 1,
        Parent = self._frame
    })
    local label = createInstance("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = (props.text or "Slider") .. ": " .. tostring(value),
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        Parent = sliderFrame
    })
    local sliderBar = createInstance("Frame", {
        Position = UDim2.new(0.5, 10, 0.5, -5),
        Size = UDim2.new(0.4, 0, 0, 10),
        BackgroundColor3 = Color3.fromRGB(80,80,80),
        Parent = sliderFrame
    })
    local sliderBtn = createInstance("TextButton", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((value-min)/(max-min), -8, 0, -3),
        BackgroundColor3 = Color3.fromRGB(180,180,180),
        Text = "",
        Parent = sliderBar
    })
    sliderBtn.MouseButton1Down:Connect(function()
        local userInput = game:GetService("UserInputService")
        local conn; conn = userInput.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local relPos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max-min)*relPos + 0.5)
                label.Text = (props.text or "Slider") .. ": " .. tostring(value)
                sliderBtn.Position = UDim2.new(relPos, -8, 0, -3)
                if props.onChange then props.onChange(value) end
            end
        end)
        userInput.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                conn:Disconnect()
            end
        end)
    end)
    self._nextY = self._nextY + 40
    table.insert(self.elements, sliderFrame)
    return sliderFrame
end

-- Add a textbox/input
function Eps1llonUI:AddTextbox(props)
    local box = createInstance("TextBox", {
        Name = "Textbox",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, self._nextY),
        Text = props.text or "",
        PlaceholderText = props.placeholder or "Enter text...",
        BackgroundColor3 = Color3.fromRGB(50,50,50),
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        Parent = self._frame
    })
    box.FocusLost:Connect(function(enterPressed)
        if props.onEnter then props.onEnter(box.Text) end
    end)
    self._nextY = self._nextY + 35
    table.insert(self.elements, box)
    return box
end

-- Add a dropdown
function Eps1llonUI:AddDropdown(props)
    local choices = props.choices or {}
    local selected = props.default or choices[1] or ""
    local dropdownFrame = createInstance("Frame", {
        Name = "Dropdown",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, self._nextY),
        BackgroundColor3 = Color3.fromRGB(60,60,60),
        Parent = self._frame
    })
    local button = createInstance("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = selected,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        Parent = dropdownFrame
    })

    button.MouseButton1Click:Connect(function()
        for _, v in ipairs(dropdownFrame:GetChildren()) do
            if v:IsA("TextButton") and v ~= button then v:Destroy() end
        end
        for i, choice in ipairs(choices) do
            local opt = createInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 25),
                Position = UDim2.new(0, 0, 0, 30 + (i-1)*25),
                BackgroundColor3 = Color3.fromRGB(70,70,70),
                Text = choice,
                TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                Parent = dropdownFrame
            })
            opt.MouseButton1Click:Connect(function()
                selected = choice
                button.Text = selected
                if props.onSelect then props.onSelect(selected) end
                for _, v in ipairs(dropdownFrame:GetChildren()) do
                    if v:IsA("TextButton") and v ~= button then v:Destroy() end
                end
            end)
        end
    end)

    self._nextY = self._nextY + 35
    table.insert(self.elements, dropdownFrame)
    return dropdownFrame
end

-- Add notification/popup
function Eps1llonUI:Notify(props)
    local message = props.text or "Notification"
    local gui = self._frame.Parent
    local popup = createInstance("TextLabel", {
        Size = UDim2.new(0, 250, 0, 50),
        Position = UDim2.new(1, -260, 0, 10),
        BackgroundColor3 = Color3.fromRGB(30,200,80),
        Text = message,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        Parent = gui
    })
    task.spawn(function()
        wait(props.duration or 2)
        popup:Destroy()
    end)
    return popup
end

return setmetatable({}, Eps1llonUI)
