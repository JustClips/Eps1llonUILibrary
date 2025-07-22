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

local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Smooth Drag (lerp animation)
local function smoothDrag(frame)
    local dragging, dragInput, startPos, startFramePos
    local targetPos = frame.Position
    local uis = game:GetService("UserInputService")
    local runService = game:GetService("RunService")

    frame.Active = true
    frame.Selectable = true

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = frame.Position
            dragInput = input
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - startPos
            targetPos = UDim2.new(
                startFramePos.X.Scale,
                startFramePos.X.Offset + delta.X,
                startFramePos.Y.Scale,
                startFramePos.Y.Offset + delta.Y
            )
        end
    end)

    runService.RenderStepped:Connect(function()
        if frame.Position ~= targetPos then
            local current = frame.Position
            frame.Position = UDim2.new(
                lerp(current.X.Scale, targetPos.X.Scale, 0.18),
                lerp(current.X.Offset, targetPos.X.Offset, 0.18),
                lerp(current.Y.Scale, targetPos.Y.Scale, 0.18),
                lerp(current.Y.Offset, targetPos.Y.Offset, 0.18)
            )
        end
    end)
end

-- Window
function Eps1llonUI:CreateWindow(props)
    props = props or {}
    local selfWindow = setmetatable({
        title = props.title or "Window",
        elements = {},
        _frame = nil
    }, {__index = self})

    -- Create the main frame (wider than a square)
    local screenGui = createInstance("ScreenGui", {Name = selfWindow.title.."GUI", ResetOnSpawn = false, Parent = game:GetService("CoreGui")})
    local frame = createInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 420, 0, 340),
        Position = UDim2.new(0.5, -210, 0.5, -170),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = screenGui
    })
    -- Add smooth drag to window (top 32px)
    local topBar = createInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        BorderSizePixel = 0,
        Parent = frame
    })
    smoothDrag(topBar)
    -- Title
    createInstance("TextLabel", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = selfWindow.title,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        Parent = topBar
    })
    selfWindow._nextY = 35
    selfWindow._frame = frame
    selfWindow._screenGui = screenGui
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

-- Add a slider (with smooth thumb animation)
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

    -- Animate slider thumb
    local targetRel = (value-min)/(max-min)
    local run = game:GetService("RunService")
    local dragging = false

    local function updatePos()
        sliderBtn.Position = UDim2.new(targetRel, -8, 0, -3)
    end

    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
        local uis = game:GetService("UserInputService")
        local conn; conn = uis.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local relPos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X)/sliderBar.AbsoluteSize.X, 0, 1)
                targetRel = relPos
                value = math.floor(min + (max-min)*relPos + 0.5)
                label.Text = (props.text or "Slider") .. ": " .. tostring(value)
                if props.onChange then props.onChange(value) end
            end
        end)
        uis.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                if conn then conn:Disconnect() end
            end
        end)
    end)

    run.RenderStepped:Connect(function()
        -- Lerp the slider thumb
        local cur = sliderBtn.Position.X.Scale
        if math.abs(cur - targetRel) > 0.001 then
            sliderBtn.Position = UDim2.new(lerp(cur, targetRel, 0.18), -8, 0, -3)
        end
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

-- Add a dropdown (with animated open/close)
function Eps1llonUI:AddDropdown(props)
    local choices = props.choices or {}
    local selected = props.default or choices[1] or ""
    local open = false
    local dropdownFrame = createInstance("Frame", {
        Name = "Dropdown",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, self._nextY),
        BackgroundColor3 = Color3.fromRGB(60,60,60),
        ClipsDescendants = true,
        Parent = self._frame
    })
    local button = createInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = selected,
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSans,
        TextSize = 18,
        Parent = dropdownFrame
    })

    local optsFrame = createInstance("Frame", {
        Name = "DropdownOpts",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0,0,0,30),
        BackgroundTransparency = 1,
        Parent = dropdownFrame
    })

    local run = game:GetService("RunService")
    local expandedHeight = #choices * 26

    button.MouseButton1Click:Connect(function()
        open = not open
    end)

    -- Options
    local optionButtons = {}
    for i, choice in ipairs(choices) do
        local opt = createInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 24),
            Position = UDim2.new(0, 0, 0, (i-1)*26),
            BackgroundColor3 = Color3.fromRGB(70,70,70),
            Text = choice,
            TextColor3 = Color3.new(1,1,1),
            Font = Enum.Font.SourceSans,
            TextSize = 16,
            Parent = optsFrame,
            Visible = false
        })
        opt.MouseButton1Click:Connect(function()
            selected = choice
            button.Text = selected
            if props.onSelect then props.onSelect(selected) end
            open = false
        end)
        optionButtons[i] = opt
    end

    -- Animate open/close
    run.RenderStepped:Connect(function()
        local cur = optsFrame.Size.Y.Offset
        local target = open and expandedHeight or 0
        if math.abs(cur - target) > 1 then
            local newY = lerp(cur, target, 0.18)
            optsFrame.Size = UDim2.new(1, 0, 0, newY)
        else
            optsFrame.Size = UDim2.new(1, 0, 0, target)
        end
        -- Show/hide option buttons
        for i, btn in ipairs(optionButtons) do
            btn.Visible = (optsFrame.Size.Y.Offset >= ((i-0.5)*26))
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
