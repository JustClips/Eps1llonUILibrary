local Eps1llonUI = {}
Eps1llonUI.__index = Eps1llonUI

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

local function smoothDrag(dragBar, mainFrame)
    local dragging, dragInput, startPos, startFramePos
    local targetPos = mainFrame.Position
    local uis = game:GetService("UserInputService")
    local runService = game:GetService("RunService")

    dragBar.Active = true
    dragBar.Selectable = true

    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = input.Position
            startFramePos = mainFrame.Position
            dragInput = input
        end
    end)

    dragBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    dragBar.InputChanged:Connect(function(input)
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
        if mainFrame.Position ~= targetPos then
            local current = mainFrame.Position
            mainFrame.Position = UDim2.new(
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
        Size = UDim2.new(0, 450, 0, 450),
        Position = UDim2.new(0.5, -225, 0.5, -225),
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

    smoothDrag(topBar, frame)

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

-- AddSlider(props)
-- props: min, max, default, width, barHeight, valueFont, labelFont, onChange
-- If width is set, the slider is that wide (in px), else fills most of window
-- If barHeight is set, the slider bar is that tall (in px), else default (32)
-- valueFont is font for the value (left side in slider bar)
-- labelFont is font for the label left of slider bar (optional)
function Eps1llonUI:AddSlider(props)
    local min, max = props.min or 0, props.max or 100
    local value = props.default or min

    local containerHeight = 42
    local containerPad = 36
    local defaultBarHeight = 32
    local barPadX = 8

    local customWidth = tonumber(props.width)
    local barHeight = tonumber(props.barHeight) or defaultBarHeight

    -- Container for slider and (optionally) a label on the left
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

    -- Label on the left (optional)
    if props.leftLabel then
        local leftLabel = createInstance("TextLabel", {
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

    -- The slider bar inside the container, with space on left for value
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

    -- Fill (progress)
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

    -- Value label at the left of the slider bar, always visible, fixed position
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

    -- Animate fill
    local run = game:GetService("RunService")
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
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValueFromX(input.Position.X)
        end
    end)
    run.RenderStepped:Connect(function()
        local cur = fill.Size.X.Scale
        if math.abs(cur - targetFill) > 0.001 then
            fill.Size = UDim2.new(lerp(cur, targetFill, 0.18), 0, 1, 0)
        end
    end)

    self._nextY = self._nextY + containerHeight + 16
    table.insert(self.elements, sliderContainer)
    return sliderContainer
end

-- AddToggle({default, onChange, width, barHeight})
-- Toggle: pill background, circle knob, supports callback
function Eps1llonUI:AddToggle(props)
    local containerHeight = (props.barHeight or 32) + 10
    local containerPad = 36
    local customWidth = tonumber(props.width or 64)

    -- Container for toggle (centered)
    local toggleContainer = createInstance("Frame", {
        Name = "ToggleContainer",
        Size = UDim2.new(0, customWidth, 0, containerHeight),
        Position = UDim2.new(0.5, -customWidth/2, 0, self._nextY),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = self._frame
    })

    -- Toggle background (pill)
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

    -- Knob
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

    -- State
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

return setmetatable({}, Eps1llonUI)
