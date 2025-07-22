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
        Size = UDim2.new(0, 420, 0, 340),
        Position = UDim2.new(0.5, -210, 0.5, -170),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = screenGui
    })
    local topBar = createInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Color3.fromRGB(30,30,30),
        BorderSizePixel = 0,
        Parent = frame
    })
    smoothDrag(topBar)
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
    selfWindow._nextY = 40
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

-- Rayfield-like Slider (no knob, just fill, full bar, smooth)
function Eps1llonUI:AddSlider(props)
    local min, max = props.min or 0, props.max or 100
    local value = props.default or min
    local sliderFrame = createInstance("Frame", {
        Name = "Slider",
        Size = UDim2.new(1, -40, 0, 38),
        Position = UDim2.new(0, 20, 0, self._nextY),
        BackgroundTransparency = 1,
        Parent = self._frame
    })
    local label = createInstance("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = (props.text or "Slider"),
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 17,
        Parent = sliderFrame,
        TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.new(0,0,0,0)
    })
    local valueLabel = createInstance("TextLabel", {
        Size = UDim2.new(0, 42, 0, 26),
        Position = UDim2.new(1, -45, 0, 6),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = Color3.new(1,1,1),
        Font = Enum.Font.SourceSans,
        TextSize = 15,
        Parent = sliderFrame,
        TextXAlignment = Enum.TextXAlignment.Right
    })

    local sliderBar = createInstance("Frame", {
        Position = UDim2.new(0, 0, 1, -15),
        Size = UDim2.new(1, 0, 0, 8),
        BackgroundColor3 = Color3.fromRGB(70,70,70),
        BorderSizePixel = 0,
        Parent = sliderFrame
    })
    local fill = createInstance("Frame", {
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new((value-min)/(max-min), 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(20,140,255),
        BorderSizePixel = 0,
        Parent = sliderBar
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

    self._nextY = self._nextY + 46
    table.insert(self.elements, sliderFrame)
    return sliderFrame
end

return setmetatable({}, Eps1llonUI)
