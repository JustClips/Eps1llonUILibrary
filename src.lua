local Eps1llonUI = {}
Eps1llonUI.__index = Eps1llonUI

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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

-- Full window drag
local function makeDraggable(frame)
    local dragging, dragInput, startPos, startFramePos
    local targetPos = frame.Position
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

    RunService.RenderStepped:Connect(function()
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

function Eps1llonUI:CreateWindow(props)
    props = props or {}
    local selfWindow = setmetatable({
        title = props.title or "Window",
        elements = {},
        _frame = nil
    }, {__index = self})

    local screenGui = createInstance("ScreenGui", {Name = selfWindow.title.."GUI", ResetOnSpawn = false, Parent = game:GetService("CoreGui")})
    local frame = createInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 450, 0, 490),
        Position = UDim2.new(0.5, -225, 0.5, -245),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = screenGui
    })
    local mainCorner = Instance.new("UICorner", frame)
    mainCorner.CornerRadius = UDim.new(0, 8)

    local topBar = createInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        BorderSizePixel = 0,
        Parent = frame
    })
    local topCorner = Instance.new("UICorner", topBar)
    topCorner.CornerRadius = UDim.new(0, 8)

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

    makeDraggable(frame)

    selfWindow._nextY = 54
    selfWindow._frame = frame
    selfWindow._screenGui = screenGui
    return selfWindow
end

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

function Eps1llonUI:AddSlider(props)
    local min, max = props.min or 0, props.max or 100
    local value = props.default or min

    local containerHeight = 42
    local containerPad = 36
    local defaultBarHeight = 32
    local barPadX = 8

    local customWidth = tonumber(props.width)
    local barHeight = tonumber(props.barHeight) or defaultBarHeight

    local sliderContainer = createInstance("Frame", {
        Name = "SliderContainer",
        Size = customWidth and UDim2.new(0, customWidth, 0, containerHeight) or UDim2.new(1, -containerPad*2, 0, containerHeight),
        Position = customWidth and UDim2.new(0.5, -customWidth/2, 0, self._nextY)
                  or UDim2.new(0, containerPad, 0, self._nextY),
        BackgroundColor3 = Color3.fromRGB(22, 23, 30),
        BorderSizePixel = 0,
        Parent = self._frame
    })
    local containerCorner = Instance.new("UICorner", sliderContainer)
    containerCorner.CornerRadius = UDim.new(0, 10)

    if props.leftLabel then
        createInstance("TextLabel", {
            Name = "LeftLabel",
            Size = UDim2.new(0, 66, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = props.leftLabel,
            TextColor3 = Color3.fromRGB(210, 220, 255),
            Font = props.labelFont or Enum.Font.SourceSansBold,
            TextSize = 15,
            Parent = sliderContainer,
            TextXAlignment = Enum.TextXAlignment.Left
        })
    end

    local valueBoxWidth = 54
    local sliderBar = createInstance("Frame", {
        Position = UDim2.new(0, barPadX + valueBoxWidth, 0.5, -barHeight/2),
        Size = UDim2.new(1, -(barPadX*2 + valueBoxWidth), 0, barHeight),
        BackgroundColor3 = Color3.fromRGB(54, 61, 76),
        BorderSizePixel = 0,
        Parent = sliderContainer
    })
    local barCorner = Instance.new("UICorner", sliderBar)
    barCorner.CornerRadius = UDim.new(0, 8)

    local fill = createInstance("Frame", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new((value-min)/(max-min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 145, 255),
        BorderSizePixel = 0,
        Parent = sliderBar,
        ClipsDescendants = true
    })
    local fillCorner = Instance.new("UICorner", fill)
    fillCorner.CornerRadius = UDim.new(0, 8)

    local valueLabel = createInstance("TextLabel", {
        Name = "SliderValue",
        Size = UDim2.new(0, valueBoxWidth, 1, 0),
        Position = UDim2.new(0, barPadX, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = Color3.fromRGB(230, 240, 255),
        Font = props.valueFont or Enum.Font.SourceSansSemibold,
        TextSize = 18,
        Parent = sliderContainer,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    local targetFill = (value-min)/(max-min)
    local dragging = false

    local function updateValueFromX(x)
        local rel = math.clamp((x - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max-min)*rel + 0.5)
        targetFill = rel
        valueLabel.Text = tostring(value)
        if props.onChange then props.onChange(value) end
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValueFromX(input.Position.X)
        end
    end)
    sliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValueFromX(input.Position.X)
        end
    end)
    RunService.RenderStepped:Connect(function()
        local cur = fill.Size.X.Scale
        if math.abs(cur - targetFill) > 0.001 then
            fill.Size = UDim2.new(lerp(cur, targetFill, 0.18), 0, 1, 0)
        end
    end)

    self._nextY = self._nextY + containerHeight + 16
    table.insert(self.elements, sliderContainer)
    return sliderContainer
end

function Eps1llonUI:AddToggle(props)
    local containerHeight = (props.barHeight or 32) + 10
    local customWidth = tonumber(props.width or 64)

    local toggleContainer = createInstance("Frame", {
        Name = "ToggleContainer",
        Size = UDim2.new(0, customWidth, 0, containerHeight),
        Position = UDim2.new(0.5, -customWidth/2, 0, self._nextY),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = self._frame
    })

    local barHeight = props.barHeight or 32
    local toggleBar = createInstance("Frame", {
        Name = "ToggleBar",
        Size = UDim2.new(0, customWidth, 0, barHeight),
        Position = UDim2.new(0, 0, 0.5, -barHeight/2),
        BackgroundColor3 = Color3.fromRGB(38, 39, 45),
        BorderSizePixel = 0,
        Parent = toggleContainer
    })
    local barCorner = Instance.new("UICorner", toggleBar)
    barCorner.CornerRadius = UDim.new(1, 0)

    local knobSize = barHeight - 6
    local knob = createInstance("Frame", {
        Name = "ToggleKnob",
        Size = UDim2.new(0, knobSize, 0, knobSize),
        Position = UDim2.new(0, 3, 0.5, -knobSize/2),
        BackgroundColor3 = Color3.fromRGB(82, 82, 82),
        BorderSizePixel = 0,
        Parent = toggleBar
    })
    local knobCorner = Instance.new("UICorner", knob)
    knobCorner.CornerRadius = UDim.new(1, 0)

    local state = props.default and true or false
    local function updateToggle()
        if state then
            knob:TweenPosition(UDim2.new(1, -knobSize-3, 0.5, -knobSize/2), "Out", "Quad", 0.15, true)
            toggleBar.BackgroundColor3 = Color3.fromRGB(0, 145, 255)
            knob.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
        else
            knob:TweenPosition(UDim2.new(0, 3, 0.5, -knobSize/2), "Out", "Quad", 0.15, true)
            toggleBar.BackgroundColor3 = Color3.fromRGB(38, 39, 45)
            knob.BackgroundColor3 = Color3.fromRGB(82, 82, 82)
        end
    end
    updateToggle()

    toggleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateToggle()
            if props.onChange then
                props.onChange(state)
            end
        end
    end)
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state = not state
            updateToggle()
            if props.onChange then
                props.onChange(state)
            end
        end
    end)

    self._nextY = self._nextY + containerHeight + 10
    table.insert(self.elements, toggleContainer)
    return toggleContainer
end

function Eps1llonUI:AddInput(props)
    local boxWidth = tonumber(props.width) or 260
    local boxHeight = 36

    local boxFrame = createInstance("Frame", {
        Name = "InputContainer",
        Size = UDim2.new(0, boxWidth, 0, boxHeight),
        Position = UDim2.new(0.5, -boxWidth/2, 0, self._nextY),
        BackgroundColor3 = Color3.fromRGB(28,32,45),
        BorderSizePixel = 0,
        Parent = self._frame
    })
    local boxCorner = Instance.new("UICorner", boxFrame)
    boxCorner.CornerRadius = UDim.new(0, 10)

    local input = createInstance("TextBox", {
        Name = "InputBox",
        Size = UDim2.new(1, -16, 1, -12),
        Position = UDim2.new(0, 8, 0, 6),
        BackgroundColor3 = Color3.fromRGB(46, 51, 70),
        BorderSizePixel = 0,
        Font = props.font or Enum.Font.SourceSansSemibold,
        TextColor3 = Color3.new(1,1,1),
        TextSize = 17,
        PlaceholderColor3 = Color3.fromRGB(150,150,160),
        PlaceholderText = props.placeholder or "Type here...",
        Text = props.default or "",
        Parent = boxFrame
    })
    local inputCorner = Instance.new("UICorner", input)
    inputCorner.CornerRadius = UDim.new(0, 8)

    input.Focused:Connect(function()
        TweenService:Create(input, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(0, 145, 255)}):Play()
    end)
    input.FocusLost:Connect(function(enter)
        TweenService:Create(input, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(46, 51, 70)}):Play()
        if props.onChange then
            props.onChange(input.Text, enter)
        end
    end)
    input:GetPropertyChangedSignal("Text"):Connect(function()
        if props.onTextChanged then
            props.onTextChanged(input.Text)
        end
    end)

    self._nextY = self._nextY + boxHeight + 14
    table.insert(self.elements, boxFrame)
    return boxFrame
end

function Eps1llonUI:AddDropdown(props)
    local options = props.options or {}
    local boxWidth = tonumber(props.width) or 220
    local boxHeight = 36

    local boxFrame = createInstance("Frame", {
        Name = "DropdownContainer",
        Size = UDim2.new(0, boxWidth, 0, boxHeight),
        Position = UDim2.new(0.5, -boxWidth/2, 0, self._nextY),
        BackgroundColor3 = Color3.fromRGB(28,32,45),
        BorderSizePixel = 0,
        Parent = self._frame,
        ClipsDescendants = true
    })
    local boxCorner = Instance.new("UICorner", boxFrame)
    boxCorner.CornerRadius = UDim.new(0, 10)

    local selected = props.default or (options[1] or "")
    local dropdown = createInstance("TextButton", {
        Name = "DropdownButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = selected,
        TextColor3 = Color3.new(1,1,1),
        Font = props.font or Enum.Font.SourceSansBold,
        TextSize = 16,
        Parent = boxFrame,
        AutoButtonColor = false
    })

    local arrow = createInstance("TextLabel", {
        Size = UDim2.new(0, 22, 0, boxHeight),
        Position = UDim2.new(1, -28, 0, 0),
        BackgroundTransparency = 1,
        Text = "▼",
        TextColor3 = Color3.fromRGB(170,170,180),
        Font = Enum.Font.Gotham,
        TextSize = 16,
        Parent = boxFrame
    })

    local listFrame = createInstance("Frame", {
        Name = "DropdownList",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(32,36,50),
        BorderSizePixel = 0,
        Parent = boxFrame,
        ClipsDescendants = true
    })
    local listCorner = Instance.new("UICorner", listFrame)
    listCorner.CornerRadius = UDim.new(0, 10)

    local layout = Instance.new("UIListLayout", listFrame)
    layout.Padding = UDim.new(0, 0)

    local open = false
    local buttonHeight = 32

    local function toggleDropdown()
        open = not open
        if open then
            TweenService:Create(boxFrame, TweenInfo.new(0.18), {Size = UDim2.new(0, boxWidth, 0, boxHeight + #options*buttonHeight)}):Play()
            TweenService:Create(listFrame, TweenInfo.new(0.18), {Size = UDim2.new(1, 0, 0, #options*buttonHeight)}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.18), {Rotation = 180}):Play()
        else
            TweenService:Create(boxFrame, TweenInfo.new(0.18), {Size = UDim2.new(0, boxWidth, 0, boxHeight)}):Play()
            TweenService:Create(listFrame, TweenInfo.new(0.18), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(arrow, TweenInfo.new(0.18), {Rotation = 0}):Play()
        end
    end

    dropdown.MouseButton1Click:Connect(toggleDropdown)

    for i, option in ipairs(options) do
        local btn = createInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, buttonHeight),
            BackgroundTransparency = 1,
            Text = tostring(option),
            TextColor3 = Color3.new(1,1,1),
            Font = props.font or Enum.Font.SourceSans,
            TextSize = 16,
            Parent = listFrame,
            AutoButtonColor = true
        })
        btn.MouseButton1Click:Connect(function()
            selected = option
            dropdown.Text = tostring(option)
            toggleDropdown()
            if props.onChange then
                props.onChange(option)
            end
        end)
    end

    self._nextY = self._nextY + boxHeight + 18
    table.insert(self.elements, boxFrame)
    return boxFrame
end

return setmetatable({}, Eps1llonUI)
