--[[ Protected by Lua Guard ]]

(function(...) 
-- ============================================================
--  BABIS GAG 0x2 – ULTIMATE (Enhanced GUI – Mobile + PC)
--  Press B to open the panel. Supports drag on mobile & PC.
--  New: Weather Predictor tab (24h moon forecast)
-- ============================================================

print("=== Babis GAG 2 Ultimate – Starting ===")

-- Services
local Players = game:GetService("Players")
local _lIIIlllIIl = Players.LocalPlayer
if not _lIIIlllIIl then
    warn("LocalPlayer not found")
    return
end

local _IIIIlllIll = _lIIIlllIIl:FindFirstChild("PlayerGui") or Instance.new("PlayerGui", _lIIIlllIIl)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Main ScreenGui with automatic scaling for mobile/PC
local _IIlIlllIlI = Instance.new("ScreenGui")
_IIlIlllIlI.Name = "BabisGAG2Gui"
_IIlIlllIlI.ResetOnSpawn = false
_IIlIlllIlI.Parent = _IIIIlllIll

-- Auto-scaling based on screen size (mobile friendly)
local function _lllIlllIII()
    local _lIlllIIlII = workspace.CurrentCamera
    if not _lIlllIIlII then return end
    local _lIIlIIIIll = _lIlllIIlII.ViewportSize
    local _IlIIIIIlIl = _lIIlIIIIll.X / 0x780
    local _IIlIIIllll = _lIIlIIIIll.Y / 0x438
    local _llIlIIIIlI = math.min(_IlIIIIIlIl, _IIlIIIllll, 1.2)  -- cap at 1.2 for large screens
    local _lIIIIIlIIl = _IIlIlllIlI:FindFirstChild("UIScale")
    if _lIIIIIlIIl then _lIIIIIlIIl.Scale = _llIlIIIIlI end
end

local _lIIIIIlIIl = Instance.new("UIScale")
_lIIIIIlIIl.Name = "UIScale"
_lIIIIIlIIl.Scale = 0x1
_lIIIIIlIIl.Parent = _IIlIlllIlI
_lllIlllIII()
game:GetService("RunService").RenderStepped:Connect(_lllIlllIII)

-- ---------- Style constants ----------
local _llIIIIlIll = Color3.fromRGB(0xF, 0xF, 0x19)
local _IIlIlIlllI = Color3.fromRGB(0x19, 0x19, 0x26)
local _lIIlIIllll = Color3.fromRGB(0xFF, 0xBE, 0x3C)
local _IlIllIlIII = Color3.fromRGB(0xFF, 0xD2, 0x78)
local _lIllllIIIl = Color3.new(0x1, 0x1, 0x1)
local _lllIIIlllI = Color3.fromRGB(0xB4, 0xB4, 0xC8)
local _lllIlIllII = Color3.fromRGB(0x3C, 0x3C, 0x5A)
local _IllIlllIll = Color3.fromRGB(0x23, 0x23, 0x37)
local _lIlIlIIlll = Color3.fromRGB(0x0, 0xB4, 0x78)
local _IlllIlIIIl = Color3.fromRGB(0x50, 0x50, 0x64)
local _IlIIIIllII = Color3.fromRGB(0xFF, 0xFF, 0xFF)
local _lIllIIlIlI = Enum.Font.GothamBlack
local _lIlIlIlllI = Enum.Font.GothamBold
local _IIllllIIII = Enum.Font.GothamSemibold
local _llIllllIlI = Enum.Font.Gotham

-- Helper functions
local function _llIIlIllIl(instance, radius)
    local _llllIlIllI = Instance.new("UICorner")
    _llllIlIllI.CornerRadius = UDim.new(0x0, radius)
    _llllIlIllI.Parent = instance
end

-- ---------- Main Panel (scaled size) ----------
local _llllIllIIl = Instance.new("Frame")
_llllIllIIl.Name = "MainPanel"
_llllIllIIl.Size = UDim2.fromScale(0.85, 0.85)   -- responsive
_llllIllIIl.Position = UDim2.new(0.5, 0x0, 0.5, 0x0)
_llllIllIIl.BackgroundColor3 = _llIIIIlIll
_llllIllIIl.BackgroundTransparency = 0.05
_llllIllIIl.BorderSizePixel = 0x0
_llllIllIIl.AnchorPoint = Vector2.new(0.5, 0.5)
_llllIllIIl.Visible = true
_llllIllIIl.Parent = _IIlIlllIlI
_llIIlIllIl(_llllIllIIl, 0x10)

-- Gradient background
local _IIlIIllIII = Instance.new("UIGradient")
_IIlIIllIII.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0x0, Color3.fromRGB(0x12, 0x12, 0x1E)),
    ColorSequenceKeypoint.new(0x1, Color3.fromRGB(0xC, 0xC, 0x16))
})
_IIlIIllIII.Rotation = 0x2D
_IIlIIllIII.Parent = _llllIllIIl

-- Title bar
local _IIllIIIIll = Instance.new("Frame")
_IIllIIIIll.Size = UDim2.new(0x1, 0x0, 0x0, 0x30)
_IIllIIIIll.BackgroundColor3 = _IIlIlIlllI
_IIllIIIIll.BorderSizePixel = 0x0
_llIIlIllIl(_IIllIIIIll, 0x10)
_IIllIIIIll.Parent = _llllIllIIl

local _lIIIlIlIII = Instance.new("UIGradient")
_lIIIlIlIII.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0x0, Color3.fromRGB(0x1E, 0x1E, 0x2D)),
    ColorSequenceKeypoint.new(0x1, Color3.fromRGB(0x14, 0x14, 0x23))
})
_lIIIlIlIII.Rotation = 0x5A
_lIIIlIlIII.Parent = _IIllIIIIll

local _lIllllIlIl = Instance.new("TextLabel")
_lIllllIlIl.Size = UDim2.new(0.6, 0x0, 0x1, 0x0)
_lIllllIlIl.Position = UDim2.new(0x0, 0x14, 0x0, 0x0)
_lIllllIlIl.BackgroundTransparency = 0x1
_lIllllIlIl.Text = "🌿 Babis GAG 2"
_lIllllIlIl.TextColor3 = _lIIlIIllll
_lIllllIlIl.Font = _lIllIIlIlI
_lIllllIlIl.TextSize = 0x16
_lIllllIlIl.Parent = _IIllIIIIll

-- Universal drag (mouse + touch)
local _IlIlIIlllI, startPos, isDragging = nil, nil, false
_IIllIIIIll.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        _IlIlIIlllI = input.Position
        startPos = _llllIllIIl.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                _IlIlIIlllI = nil
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local _IlIllllllI = input.Position - _IlIlIIlllI
        _llllIllIIl.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + _IlIllllllI.X, startPos.Y.Scale, startPos.Y.Offset + _IlIllllllI.Y)
    end
end)

-- Close button
local _llllIlIIII = Instance.new("TextButton")
_llllIlIIII.Size = UDim2.fromOffset(0x1E, 0x1E)
_llllIlIIII.Position = UDim2.new(0x1, -0x28, 0x0, 0x9)
_llllIlIIII.BackgroundColor3 = Color3.fromRGB(0xC8, 0x3C, 0x3C)
_llllIlIIII.Text = "✕"
_llllIlIIII.TextColor3 = _lIllllIIIl
_llllIlIIII.Font = _lIlIlIlllI
_llllIlIIII.TextSize = 0x10
_llllIlIIII.BorderSizePixel = 0x0
_llIIlIllIl(_llllIlIIII, 0xF)
_llllIlIIII.Parent = _IIllIIIIll
_llllIlIIII.MouseButton1Click:Connect(function() _llllIllIIl.Visible = false end)
_llllIlIIII.MouseEnter:Connect(function()
    TweenService:Create(_llllIlIIII, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0xF0, 0x50, 0x50)}):Play()
end)
_llllIlIIII.MouseLeave:Connect(function()
    TweenService:Create(_llllIlIIII, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0xC8, 0x3C, 0x3C)}):Play()
end)

-- ---------- Tab System (now includes Weather) ----------
local _IlIlIlIIII = {"Farming", "Stealing", "Weather", "Settings"}
local _IlllllIlIl = "Farming"
local _IlllIlIlll = {}
local _lllIlIIIlI = {}

local _llIlIIIIlI = Instance.new("Frame")
_llIlIIIIlI.Size = UDim2.new(0x1, 0x0, 0x0, 0x28)
_llIlIIIIlI.Position = UDim2.new(0x0, 0x0, 0x0, 0x30)
_llIlIIIIlI.BackgroundColor3 = _IIlIlIlllI
_llIlIIIIlI.BorderSizePixel = 0x0
_llIlIIIIlI.Parent = _llllIllIIl

for i, tabName in ipairs(_IlIlIlIIII) do
    local _IlllllIIII = Instance.new("TextButton")
    _IlllllIIII.Size = UDim2.new(0x1/#_IlIlIlIIII, -0x4, 0x1, -0x4)
    _IlllllIIII.Position = UDim2.new((i-0x1)/#_IlIlIlIIII, 0x2, 0x0, 0x2)
    _IlllllIIII.BackgroundColor3 = _IllIlllIll
    _IlllllIIII.Text = tabName
    _IlllllIIII.TextColor3 = _lllIIIlllI
    _IlllllIIII.Font = _IIllllIIII
    _IlllllIIII.TextSize = 0x10
    _IlllllIIII.BorderSizePixel = 0x0
    _llIIlIllIl(_IlllllIIII, 0x8)
    _IlllllIIII.Parent = _llIlIIIIlI
    _IlllIlIlll[tabName] = _IlllllIIII

    local _llIIIllIll = Instance.new("Frame")
    _llIIIllIll.Size = UDim2.new(0x1, -0x10, 0x1, -0x60)
    _llIIIllIll.Position = UDim2.new(0x0, 0x8, 0x0, 0x5C)
    _llIIIllIll.BackgroundTransparency = 0x1
    _llIIIllIll.Visible = (tabName == _IlllllIlIl)
    _llIIIllIll.Parent = _llllIllIIl
    _lllIlIIIlI[tabName] = _llIIIllIll

    local _llIllIllIl = Instance.new("ScrollingFrame")
    _llIllIllIl.Name = "Scroll_" .. tabName
    _llIllIllIl.Size = UDim2.new(0x1, 0x0, 0x1, 0x0)
    _llIllIllIl.BackgroundTransparency = 0x1
    _llIllIllIl.BorderSizePixel = 0x0
    _llIllIllIl.ScrollBarThickness = 0x4
    _llIllIllIl.ScrollBarImageColor3 = Color3.fromRGB(0x64, 0x64, 0x82)
    _llIllIllIl.CanvasSize = UDim2.new(0x0, 0x0, 0x0, 0x258)
    _llIllIllIl.AutomaticCanvasSize = Enum.AutomaticSize.Y
    _llIllIllIl.Parent = _llIIIllIll

    local _IIIlllIIlI = Instance.new("UIListLayout")
    _IIIlllIIlI.Padding = UDim.new(0x0, 0x8)
    _IIIlllIIlI.HorizontalAlignment = Enum.HorizontalAlignment.Center
    _IIIlllIIlI.SortOrder = Enum.SortOrder.LayoutOrder
    _IIIlllIIlI.Parent = _llIllIllIl

    _IlllllIIII.MouseButton1Click:Connect(function()
        _IlllllIlIl = tabName
        for _, f in pairs(_lllIlIIIlI) do f.Visible = false end
        _llIIIllIll.Visible = true
        for _, b in pairs(_IlllIlIlll) do
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = _IllIlllIll, TextColor3 = _lllIIIlllI}):Play()
        end
        TweenService:Create(_IlllllIIII, TweenInfo.new(0.2), {BackgroundColor3 = _lllIlIllII, TextColor3 = _lIllllIIIl}):Play()
    end)
end
_IlllIlIlll[_IlllllIlIl].BackgroundColor3 = _lllIlIllII
_IlllIlIlll[_IlllllIlIl].TextColor3 = _lIllllIIIl

-- ---------- Animated Toggle Switch Creator ----------
local function _llllIIIIll(parent, text, default, callback)
    local _IlIllllllI = Instance.new("Frame")
    _IlIllllllI.Size = UDim2.new(0.9, 0x0, 0x0, 0x28)
    _IlIllllllI.Position = UDim2.new(0.5, 0x0, 0x0, 0x0)
    _IlIllllllI.AnchorPoint = Vector2.new(0.5, 0x0)
    _IlIllllllI.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x2D)
    _IlIllllllI.BorderSizePixel = 0x0
    _llIIlIllIl(_IlIllllllI, 0xA)
    _IlIllllllI.Parent = parent

    local _IlIlIIllII = Instance.new("TextLabel")
    _IlIlIIllII.Size = UDim2.new(0.6, 0x0, 0x1, 0x0)
    _IlIlIIllII.Position = UDim2.new(0x0, 0xC, 0x0, 0x0)
    _IlIlIIllII.BackgroundTransparency = 0x1
    _IlIlIIllII.Text = text
    _IlIlIIllII.TextColor3 = _lIllllIIIl
    _IlIlIIllII.Font = _llIllllIlI
    _IlIlIIllII.TextSize = 0xE
    _IlIlIIllII.TextXAlignment = Enum.TextXAlignment.Left
    _IlIlIIllII.Parent = _IlIllllllI

    local _llIlIlllll = Instance.new("Frame")
    _llIlIlllll.Size = UDim2.fromOffset(0x30, 0x18)
    _llIlIlllll.Position = UDim2.new(0x1, -0x3C, 0.5, -0xC)
    _llIlIlllll.BackgroundColor3 = default and _lIlIlIIlll or _IlllIlIIIl
    _llIlIlllll.BorderSizePixel = 0x0
    _llIIlIllIl(_llIlIlllll, 0xC)
    _llIlIlllll.Parent = _IlIllllllI

    local _llllIllIlI = Instance.new("Frame")
    _llllIllIlI.Size = UDim2.fromOffset(0x14, 0x14)
    _llllIllIlI.Position = UDim2.new(0x0, default and 0x1A or 0x2, 0.5, -0xA)
    _llllIllIlI.BackgroundColor3 = _IlIIIIllII
    _llllIllIlI.BorderSizePixel = 0x0
    _llIIlIllIl(_llllIllIlI, 0xA)
    _llllIllIlI.Parent = _llIlIlllll

    local _llllIIIIlI = default

    local function _llIlIIllll()
        local _IIIIlIlIIl = _llllIIIIlI and _lIlIlIIlll or _IlllIlIIIl
        local _lIllIlllIl = _llllIIIIlI and UDim2.new(0x0, 0x1A, 0.5, -0xA) or UDim2.new(0x0, 0x2, 0.5, -0xA)
        TweenService:Create(_llIlIlllll, TweenInfo.new(0.2), {BackgroundColor3 = _IIIIlIlIIl}):Play()
        TweenService:Create(_llllIllIlI, TweenInfo.new(0.2), {Position = _lIllIlllIl}):Play()
    end

    _IlIllllllI.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            _llllIIIIlI = not _llllIIIIlI
            _llIlIIllll()
            if callback then callback(_llllIIIIlI) end
        end
    end)

    return _IlIllllllI
end

-- ---------- Coin Display ----------
local _IIlIIlIIlI = Instance.new("Frame")
_IIlIIlIIlI.Size = UDim2.new(0.9, 0x0, 0x0, 0x1E)
_IIlIIlIIlI.Position = UDim2.new(0.05, 0x0, 0x1, -0x23)
_IIlIIlIIlI.BackgroundTransparency = 0x1
_IIlIIlIIlI.Parent = _llllIllIIl

local _llllllllII = Instance.new("ImageLabel")
_llllllllII.Size = UDim2.fromOffset(0x18, 0x18)
_llllllllII.Position = UDim2.new(0x0, 0x0, 0.5, -0xC)
_llllllllII.BackgroundTransparency = 0x1
_llllllllII.Image = "rbxassetid://7734056594"
_llllllllII.Parent = _IIlIIlIIlI

local _IlIlIlIlII = Instance.new("TextLabel")
_IlIlIlIlII.Size = UDim2.new(0x1, -0x1E, 0x1, 0x0)
_IlIlIlIlII.Position = UDim2.new(0x0, 0x1E, 0x0, 0x0)
_IlIlIlIlII.BackgroundTransparency = 0x1
_IlIlIlIlII.Text = "0"
_IlIlIlIlII.TextColor3 = _lIIlIIllll
_IlIlIlIlII.Font = _lIlIlIlllI
_IlIlIlIlII.TextSize = 0x14
_IlIlIlIlII.TextXAlignment = Enum.TextXAlignment.Left
_IlIlIlIlII.Parent = _IIlIIlIIlI

-- ---------- Floating B Button ----------
local _IIIlIIlIII = Instance.new("TextButton")
_IIIlIIlIII.Size = UDim2.fromOffset(0x34, 0x34)
_IIIlIIlIII.Position = UDim2.new(0x0, 0xC, 0x0, 0xC)
_IIIlIIlIII.BackgroundColor3 = Color3.fromRGB(0x19, 0x19, 0x28)
_IIIlIIlIII.Text = "B"
_IIIlIIlIII.TextColor3 = _lIIlIIllll
_IIIlIIlIII.Font = _lIlIlIlllI
_IIIlIIlIII.TextSize = 0x1C
_IIIlIIlIII.BorderSizePixel = 0x0
_llIIlIllIl(_IIIlIIlIII, 0x1A)
_IIIlIIlIII.Parent = _IIlIlllIlI

-- Pulse animation
coroutine.wrap(function()
    while _IIIlIIlIII and _IIIlIIlIII.Parent do
        TweenService:Create(_IIIlIIlIII, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromOffset(0x38, 0x38)}):Play()
        task.wait(0.8)
        TweenService:Create(_IIIlIIlIII, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromOffset(0x34, 0x34)}):Play()
        task.wait(0.8)
    end
end)()

_IIIlIIlIII.MouseButton1Click:Connect(function()
    local _IIIIIlIIlI = not _llllIllIIl.Visible
    if _IIIIIlIIlI then
        _llllIllIIl.Visible = true
        _llllIllIIl.Size = UDim2.fromOffset(0x0, 0x0)
        TweenService:Create(_llllIllIIl, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0.85, 0.85)}):Play()
    else
        TweenService:Create(_llllIllIIl, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0x0, 0x0)}):Play()
        task.wait(0.2)
        _llllIllIIl.Visible = false
    end
end)
_IIIlIIlIII.MouseEnter:Connect(function()
    TweenService:Create(_IIIlIIlIII, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0x2D, 0x2D, 0x3C)}):Play()
end)
_IIIlIIlIII.MouseLeave:Connect(function()
    TweenService:Create(_IIIlIIlIII, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0x19, 0x19, 0x28)}):Play()
end)

print("[Babis] Enhanced animated GUI created (mobile+PC).")

-- ==================== Weather Prediction Tab ====================
-- Moon prediction logic (provided)
local _llIlIlIIlI = 0x258
local _IllllIIlIl = {
    {Name = "Rainbow Moon", Chance = 0x6},
    {Name = "Goldmoon", Chance = 0xD},
    {Name = "Bloodmoon", Chance = 0x2},
    {Name = "Moon", Chance = 0x4F}
}

local function _lllIlllIII(_lIllIlllll, order)
    local _lIIllIIIIl = Random.new(_lIllIlllll * 0x3E8 + order)
    local _IIIllIIIll = _lIIllIIIIl:NextNumber() * 0x64
    local _IIIIlIIIII = 0x0
    for _, moon in ipairs(_IllllIIlIl) do
        _IIIIlIIIII = _IIIIlIIIII + moon.Chance
        if _IIIllIIIll <= _IIIIlIIIII then
            return moon.Name
        end
    end
    return "Moon"
end

local function _lIlIllllII()
    local _llIlIlllIl = {}
    local _llIlIIIlll = os.time()
    local _IIllIIllll = _llIlIIIlll + (0x18 * 0xE10)
    for t = _llIlIIIlll, _IIllIIllll, _llIlIlIIlI do
        local _lIllIlllll = math.floor(t / _llIlIlIIlI)
        local _IIIlIIllII = os.date("%I:%M %p", t)
        local _lIIlIIlIII = _lllIlllIII(_lIllIlllll, 0x3)   -- order 0x3 for prediction
        table.insert(_llIlIlllIl, {Time = _IIIlIIllII, Moon = _lIIlIIlIII})
    end
    return _llIlIlllIl
end

-- Build the weather list when the tab is first opened (or on-demand)
local _lIllIIlIIl = _lllIlIIIlI["Weather"]:FindFirstChild("Scroll_Weather")
local _lIlIlIlllI = false

local function _lIlIlIIllI()
    if _lIlIlIlllI then return end
    _lIlIlIlllI = true

    local _IlIlllllII = Instance.new("TextLabel")
    _IlIlllllII.Size = UDim2.new(0.9, 0x0, 0x0, 0x1E)
    _IlIlllllII.BackgroundTransparency = 0x1
    _IlIlllllII.Text = "🌙 24-Hour Moon Forecast"
    _IlIlllllII.TextColor3 = _lIIlIIllll
    _IlIlllllII.Font = _lIlIlIlllI
    _IlIlllllII.TextSize = 0x12
    _IlIlllllII.Parent = _lIllIIlIIl

    local _llIlIlllIl = _lIlIllllII()
    for _, pred in ipairs(_llIlIlllIl) do
        local _lIlllIIIll = Instance.new("Frame")
        _lIlllIIIll.Size = UDim2.new(0.9, 0x0, 0x0, 0x1E)
        _lIlllIIIll.BackgroundColor3 = Color3.fromRGB(0x1E,0x1E,0x2D)
        _lIlllIIIll.BorderSizePixel = 0x0
        _llIIlIllIl(_lIlllIIIll, 0x6)
        _lIlllIIIll.Parent = _lIllIIlIIl

        local _IlIlllIlll = Instance.new("TextLabel")
        _IlIlllIlll.Size = UDim2.new(0.5, 0x0, 0x1, 0x0)
        _IlIlllIlll.BackgroundTransparency = 0x1
        _IlIlllIlll.Text = pred.Time
        _IlIlllIlll.TextColor3 = _lIllllIIIl
        _IlIlllIlll.Font = _IIllllIIII
        _IlIlllIlll.TextSize = 0xE
        _IlIlllIlll.Parent = _lIlllIIIll

        local _IIIIIlIlll = Instance.new("TextLabel")
        _IIIIIlIlll.Size = UDim2.new(0.5, 0x0, 0x1, 0x0)
        _IIIIIlIlll.Position = UDim2.new(0.5, 0x0, 0x0, 0x0)
        _IIIIIlIlll.BackgroundTransparency = 0x1
        _IIIIIlIlll.Text = pred.Moon
        _IIIIIlIlll.TextColor3 = _IlIllIlIII
        _IIIIIlIlll.Font = _llIllllIlI
        _IIIIIlIlll.TextSize = 0xE
        _IIIIIlIlll.Parent = _lIlllIIIll
    end
end

-- Trigger building when the Weather tab is selected
_IlllIlIlll["Weather"].MouseButton1Click:Connect(function()
    _lIlIlIIllI()
end)
-- Also build if it'_IIlIlllllI the default tab (unlikely) or on first open if visible
if _IlllllIlIl == "Weather" then
    _lIlIlIIllI()
end

-- ==================== Background Features (unchanged from previous) ====================
coroutine.wrap(function()
    task.wait(0.5)

    -- ------------------ Configuration ------------------
    local _llIIllllll = 0xF
    local _IlIlIIIIIl = 0.2
    local _llIllIlIlI = 0.5
    local _IIllIIIlll = 0.1
    local _IlIIIIIIII = 0x1E
    local _lIlIlIIIIl = 0x3C
    local _lIIIllIlIl = 0x5

    local _lllIlIIlII = {
        "Dragon's Breath", "Hypno Bloom", "Moon Bloom", "Briar Rose",
        "Venom Spitter", "Poison Apple", "Pomegranate", "Venus Fly Trap",
        "Fire Fern", "Sunflower", "Cherry", "Acorn", "Dragon Fruit",
        "Rocket Pop", "Mango", "Coconut", "Grape", "Banana", "Green Bean",
        "Mushroom", "Pineapple", "Cactus", "Corn", "Bamboo",
        "Apple", "Tomato", "Tulip", "Blueberry", "Strawberry", "Carrot"
    }

    -- ------------------ Safe Require ------------------
    local function _IlIIIlIIll(module)
        local _IIlIlllllI, r = pcall(function() return require(module) end)
        return _IIlIlllllI and r or nil
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local _IIIIIIlIIl = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local _IlIlIlllIl = ReplicatedStorage:FindFirstChild("SharedModules")
    if not _IlIlIlllIl then _IlIlIlllIl = ReplicatedStorage:WaitForChild("SharedModules", 0x5) end

    local _lIlIllIlll = _IlIlIlllIl and _IlIIIlIIll(_IlIlIlllIl:FindFirstChild("Networking"))
    local _IIIlIlIIll = _IlIlIlllIl and _IlIIIlIIll(_IlIlIlllIl:FindFirstChild("Flags") and _IlIlIlllIl.Flags:FindFirstChild("StealFlags"))
    local _lIIlIlllII = _IlIlIlllIl and _IlIIIlIIll(_IlIlIlllIl:FindFirstChild("FruitValueCalc"))

    local _IIIIIlIIlI = nil
    local _lIllllIIIl = _lIIIlllIIl:FindFirstChild("PlayerScripts")
        and _lIIIlllIIl.PlayerScripts:FindFirstChild("Controllers")
        and _lIIIlllIIl.PlayerScripts.Controllers:FindFirstChild("PlantLifecycleHandler")
    if _lIllllIIIl then _IIIIIlIIlI = _IlIIIlIIll(_lIllllIIIl) end

    local _IlIlIlIlll = ReplicatedStorage:FindFirstChild("Night")

    -- ------------------ Get Plot ------------------
    local _llIllllIlI = _IIIIIIlIIl:FindFirstChild("Gardens")
    if not _llIllllIlI then _llIllllIlI = _IIIIIIlIIl:WaitForChild("Gardens", 0xA) end
    if not _llIllllIlI then _IlIlIlIlII.Text = "Error: Gardens not found" return end

    local _IlllIIIllI
    local _lllIlllIII = tick()
    while not _IlllIIIllI and tick() - _lllIlllIII < 0x1E do
        task.wait(0.1)
        for _, plot in pairs(_llIllllIlI:GetChildren()) do
            if plot:GetAttribute("Owner") == _lIIIlllIIl.Name then
                _IlllIIIllI = plot
                break
            end
        end
    end
    if not _IlllIIIllI then _IlIlIlIlII.Text = "Error: Plot not found" return end

    -- ------------------ Coin Detection ------------------
    local function _lIIIlIIlll()
        for _, attr in ipairs({"Sheckles","Coins","Currency","Money","Gems"}) do
            local _lIIIIIlIlI = _lIIIlllIIl:GetAttribute(attr)
            if type(_lIIIIIlIlI) == "number" and _lIIIIIlIlI >= 0x0 then return _lIIIIIlIlI end
        end
        local _IlIllIlIll = _lIIIlllIIl:FindFirstChild("leaderstats")
        if _IlIllIlIll then
            for _, child in pairs(_IlIllIlIll:GetChildren()) do
                if child:IsA("NumberValue") and child.Name:lower():match("coin") or child.Name:lower():match("sheckle") or child.Name:lower():match("money") or child.Name:lower():match("cash") then
                    return child.Value
                end
            end
        end
        for _, child in pairs(_lIIIlllIIl:GetDescendants()) do
            if child:IsA("NumberValue") or child:IsA("IntValue") then
                local _IlIllllIII = child.Name:lower()
                if _IlIllllIII:find("coin") or _IlIllllIII:find("sheckle") or _IlIllllIII:find("money") or _IlIllllIII:find("cash") then
                    local _lIIIIIlIlI = tonumber(child.Value)
                    if _lIIIIIlIlI and _lIIIIIlIlI >= 0x0 then return _lIIIIIlIlI end
                end
            end
        end
        local _llIIIllIII = _lIIIlllIIl:FindFirstChild("PlayerGui")
        if _llIIIllIII then
            for _, lbl in pairs(_llIIIllIII:GetDescendants()) do
                if lbl:IsA("TextLabel") or lbl:IsA("TextButton") then
                    local _IlIIlllIlI = tonumber(lbl.Text:gsub("[^%d.]", ""))
                    if _IlIIlllIlI and _IlIIlllIlI >= 0x0 then return _IlIIlllIlI end
                end
            end
        end
        return 0x0
    end

    coroutine.wrap(function()
        while true do
            task.wait(0x1)
            pcall(function()
                local _llIIIllIIl = _lIIIlIIlll()
                _IlIlIlIlII.Text = tostring(_llIIIllIIl)
            end)
        end
    end)()

    -- ------------------ Advanced Auto Buy (Seeds + Gears + Crates) ------------------
    local _IlIlIIIIII = _lIlIllIlll and _lIlIllIlll.SeedShop and _lIlIllIlll.SeedShop.PurchaseSeed
    local _lIllllllll = ReplicatedStorage:FindFirstChild("StockValues") and ReplicatedStorage.StockValues:FindFirstChild("SeedShop") and ReplicatedStorage.StockValues.SeedShop:FindFirstChild("Items")
    local _IIlIIIIlIl = _lIlIllIlll and _lIlIllIlll.GearShop and _lIlIllIlll.GearShop.PurchaseGear
    local _lllIIlllII = ReplicatedStorage:FindFirstChild("StockValues") and ReplicatedStorage.StockValues:FindFirstChild("GearShop") and ReplicatedStorage.StockValues.GearShop:FindFirstChild("Items")
    local _lllIIIIIlI = _lIlIllIlll and _lIlIllIlll.CrateShop and _lIlIllIlll.CrateShop.PurchaseCrate
    local _lIlIIlllIl = ReplicatedStorage:FindFirstChild("StockValues") and ReplicatedStorage.StockValues:FindFirstChild("CrateShop") and ReplicatedStorage.StockValues.CrateShop:FindFirstChild("Items")

    local _IlIIIlllll = {}
    local _IIIlllIIIl = nil
    if getgc then
        for _, _lIIIIIlIlI in pairs(getgc()) do
            if type(_lIIIIIlIlI) == "function" then
                local _lllIIlllII = debug and debug.info(_lIIIIIlIlI, "s")
                if _lllIIlllII and _lllIIlllII:match("RestockStoreController") and debug.info(_lIIIIIlIlI, "l") == 0x23F then
                    pcall(function()
                        table.insert(_IlIIIlllll, debug.getupvalue(_lIIIIIlIlI, 0x3))
                        _IIIlllIIIl = debug.getupvalue(_lIIIIIlIlI, 0x9)
                    end)
                end
            end
        end
    end

    local function _lllIIIIIlI(item)
        if not _IlIIIlllll or not _IIIlllIIIl then return false end
        for _, options in pairs(_IlIIIlllll) do
            local _lllIIlllIl, result = pcall(function()
                local _IIIIIIIllI = options[item]
                if not _IIIIIIIllI then return false end
                return (_IIIlllIIIl.Data.Sheckles or 0x0) >= _IIIIIIIllI.price
            end)
            if _lllIIlllIl and result then return true end
        end
        return false
    end

    local _llIlIllIll = false

    local function _IlllIIllll(itemName, shopType)
        if not _lllIIIIIlI(itemName) then return end
        if shopType == "Seed" and _IlIlIIIIII then
            pcall(function() _IlIlIIIIII:Fire(itemName) end)
        elseif shopType == "Gear" and _IIlIIIIlIl then
            pcall(function() _IIlIIIIlIl:Fire(itemName) end)
        elseif shopType == "Crate" and _lllIIIIIlI then
            pcall(function() _lllIIIIIlI:Fire(itemName) end)
        end
    end

    coroutine.wrap(function()
        while true do
            if _llIlIllIll then
                if _lIllllllll then
                    for _, item in pairs(_lIllllllll:GetChildren()) do
                        if item:IsA("NumberValue") and item.Value > 0x0 then
                            _IlllIIllll(item.Name, "Seed")
                        end
                    end
                end
                if _lllIIlllII then
                    for _, item in pairs(_lllIIlllII:GetChildren()) do
                        if item:IsA("NumberValue") and item.Value > 0x0 then
                            _IlllIIllll(item.Name, "Gear")
                        end
                    end
                end
                if _lIlIIlllIl then
                    for _, item in pairs(_lIlIIlllIl:GetChildren()) do
                        if item:IsA("NumberValue") and item.Value > 0x0 then
                            _IlllIIllll(item.Name, "Crate")
                        end
                    end
                end
            end
            task.wait(_IIllIIIlll)
        end
    end)()

    -- ------------------ Planting ------------------
    local function _lIIlllIlII(plr) return plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") end
    local function _IIllIIIIll(plr) local _IlllIIIlII = _lIIlllIlII(plr) return _IlllIIIlII and _IlllIIIlII.RootPart end

    local function _lIIIlIllIl(plot)
        local _llIllIlIlI = {}
        if not plot then return _llIllIlIlI end
        for _, _IlIllIIlll in pairs(plot:GetDescendants()) do
            if _IlIllIIlll:IsA("BasePart") and _IlIllIIlll.Name:lower():match("plant") or _IlIllIIlll.Name:lower():match("planter") or _IlIllIIlll.Name:lower():match("area") or _IlIllIIlll.Name:lower():match("soil") or _IlIllIIlll.Name:lower():match("plot") then
                table.insert(_llIllIlIlI, _IlIllIIlll)
            end
        end
        if #_llIllIlIlI == 0x0 then
            local _IIlIlIllIl = plot:FindFirstChild("PlotSizeReference") or plot:FindFirstChildWhichIsA("BasePart")
            if _IIlIlIllIl then table.insert(_llIllIlIlI, _IIlIlIllIl) end
        end
        return _llIllIlIlI
    end

    local function _llllllIlIl(plot)
        local _llIllIlIlI = _lIIIlIllIl(plot)
        if #_llIllIlIlI == 0x0 then return nil end
        local _llIIIIIIIl = _llIllIlIlI[math.random(0x1, #_llIllIlIlI)]
        local _lIIllIllII = _llIIIIIIIl.Size
        return _llIIIIIIIl.CFrame.Position + Vector3.new((math.random()-0.5)*_lIIllIllII.X*0.6, 0x2, (math.random()-0.5)*_lIIllIllII.Z*0.6)
    end

    local function _IlllllIlII()
        local _IlIllIlIlI = _lIIIlllIIl:FindFirstChild("Backpack")
        if not _IlIllIlIlI then return nil end
        local _IllIlIlIlI, bestTier = nil, 0x3E7
        for _, item in pairs(_IlIllIlIlI:GetChildren()) do
            local _lIllllIIll = item:GetAttribute("SeedTool") or item.Name
            if _lIllllIIll then
                local _lIIIIllIlI = 0x3E7
                for i, t in ipairs(_lllIlIIlII) do
                    if _lIllllIIll:find(t, 0x1, true) then _lIIIIllIlI = i break end
                end
                if _lIIIIllIlI < bestTier then bestTier = _lIIIIllIlI; _IllIlIlIlI = item end
            end
        end
        return _IllIlIlIlI
    end

    local function _lIIlllIIII(_IIIllllIlI)
        local _IlllIIllIl = _lIIlllIlII(_lIIIlllIIl)
        if not _IlllIIllIl then return false end
        if _IIIllllIlI.Parent == _lIIIlllIIl.Character then return true end
        _IIIllllIlI.Parent = _lIIIlllIIl.Character
        _IlllIIllIl:EquipTool(_IIIllllIlI)
        return true
    end

    local function _IlIIllllll()
        if not (_lIlIllIlll and _lIlIllIlll.Plant and _lIlIllIlll.Plant.PlantSeed) then return false end
        local _IIIllllIlI = _IlllllIlII()
        if not _IIIllllIlI then return false end
        local _lIlllIIlII = _llllllIlIl(_IlllIIIllI)
        if not _lIlllIIlII then return false end
        local _llIlIIlIIl = _IIIllllIlI:GetAttribute("SeedTool") or _IIIllllIlI.Name
        if not _lIIlllIIII(_IIIllllIlI) then return false end
        local _IIIlIlllll = _IIllIIIIll(_lIIIlllIIl)
        if _IIIlIlllll then _IIIlIlllll.CFrame = CFrame.new(_lIlllIIlII) + Vector3.new(0x0,0x2,0x0) task.wait(0.2) end
        pcall(function() _lIlIllIlll.Plant.PlantSeed:Fire(_lIlllIIlII, _llIlIIlIIl, _IIIllllIlI) end)
        return true
    end

    local function _IlllllIlll()
        local _IlIllIlIlI = _lIIIlllIIl:FindFirstChild("Backpack")
        if not _IlIllIlIlI then return end
        for _, _IIIllllIlI in pairs(_IlIllIlIlI:GetChildren()) do
            if _IIIllllIlI:GetAttribute("SeedTool") then
                local _lIlllIIlII = _llllllIlIl(_IlllIIIllI)
                if _lIlllIIlII and _lIIlllIIII(_IIIllllIlI) then
                    local _IIIlIlllll = _IIllIIIIll(_lIIIlllIIl)
                    if _IIIlIlllll then _IIIlIlllll.CFrame = CFrame.new(_lIlllIIlII) + Vector3.new(0x0,0x2,0x0) end
                    task.wait(0.1)
                    pcall(function() _lIlIllIlll.Plant.PlantSeed:Fire(_lIlllIIlII, _IIIllllIlI:GetAttribute("SeedTool") or _IIIllllIlI.Name, _IIIllllIlI) end)
                    task.wait(0.2)
                end
            end
        end
    end

    -- ------------------ Harvest (instant all at once) ------------------
    local function _llIlllllll(plant)
        local _lIIllIIIII = plant:GetAttribute("MaxAge")
        local _IIllllIIII = plant:GetAttribute("Age")
        return _lIIllIIIII and _IIllllIIII and _IIllllIIII >= _lIIllIIIII
    end

    local function _lllIllIIll(plot)
        local _IllIIllIIl = {}
        local _IIllIlIIIl = plot and plot:FindFirstChild("Plants")
        if not _IIllIlIIIl then return _IllIIllIIl end
        for _, plant in pairs(_IIllIlIIIl:GetChildren()) do
            local _lIlllIIIII = plant:FindFirstChild("Fruits")
            if _lIlllIIIII then
                for _, fruit in pairs(_lIlllIIIII:GetChildren()) do
                    if fruit:IsA("Model") and _llIlllllll(fruit) then table.insert(_IllIIllIIl, fruit) end
                end
            elseif plant:IsA("Model") and _llIlllllll(plant) then table.insert(_IllIIllIIl, plant) end
        end
        return _IllIIllIIl
    end

    local function _IlIIllIllI()
        if not _lIlIllIlll or not _lIlIllIlll.Garden or not _lIlIllIlll.Garden.CollectFruit then return end
        local _IlIIllllII = _lllIllIIll(_IlllIIIllI)
        for _, plant in ipairs(_IlIIllllII) do
            local _llIIIlIIII = plant:GetAttribute("PlantId")
            local _IIlIIIlIII = plant:GetAttribute("FruitId") or ""
            if _llIIIlIIII then
                pcall(function() _lIlIllIlll.Garden.CollectFruit:Fire(_llIIIlIIII, _IIlIIIlIII) end)
            end
        end
    end

    -- ------------------ Sell (instant) ------------------
    local function _llIIllIIlI()
        if _lIlIllIlll and _lIlIllIlll.NPCS and _lIlIllIlll.NPCS.SellAll then
            pcall(function() _lIlIllIlll.NPCS.SellAll:Fire() end)
        end
    end

    -- ------------------ Water / Fertilize ------------------
    local function _lllllIllII(name)
        local _IlIllIlIlI = _lIIIlllIIl:FindFirstChild("Backpack")
        if not _IlIllIlIlI then return nil end
        for _, t in pairs(_IlIllIlIlI:GetChildren()) do
            if t.Name:lower():find(name:lower()) then return t end
        end
        return nil
    end

    local function _IIlIIlllll()
        local _IIIllllIlI = _lllllIllII("Water")
        if not _IIIllllIlI or not _lIIlllIIII(_IIIllllIlI) then return end
        for _, spot in ipairs(_lIIIlIllIl(_IlllIIIllI)) do
            local _IIIlIlllll = _IIllIIIIll(_lIIIlllIIl)
            if _IIIlIlllll then _IIIlIlllll.CFrame = CFrame.new(spot.Position + Vector3.new(0x0,0x3,0x0)) end
            task.wait(0.2)
            if _lIlIllIlll and _lIlIllIlll.Garden and _lIlIllIlll.Garden.Water then
                pcall(function() _lIlIllIlll.Garden.Water:Fire(spot) end)
            end
            task.wait(0.5)
        end
    end

    local function _lIIlllllll()
        local _IIIllllIlI = _lllllIllII("Fertil")
        if not _IIIllllIlI or not _lIIlllIIII(_IIIllllIlI) then return end
        for _, spot in ipairs(_lIIIlIllIl(_IlllIIIllI)) do
            local _IIIlIlllll = _IIllIIIIll(_lIIIlllIIl)
            if _IIIlIlllll then _IIIlIlllll.CFrame = CFrame.new(spot.Position + Vector3.new(0x0,0x3,0x0)) end
            task.wait(0.2)
            if _lIlIllIlll and _lIlIllIlll.Garden and _lIlIllIlll.Garden.Fertilize then
                pcall(function() _lIlIllIlll.Garden.Fertilize:Fire(spot) end)
            end
            task.wait(0.5)
        end
    end

    -- ------------------ Steal ------------------
    local function _lIIlIlllII(player)
        local _IIlIlllllI, r = pcall(function() return player:GetAttribute("IsInOwnGarden") end)
        return _IIlIlllllI and r or false
    end

    local function _IIlIIlIlII(_lllIlIIIll, from, to, speed)
        if not to or not from or not _lllIlIIIll then return end
        local _lIIlIllIIl = (to.Position - from.Position).Magnitude
        local _IIlIIIlIll = _lIIlIllIIl / speed
        local _lIIIlIllIl, elp = nil, 0x0
        pcall(function()
            _lIIIlIllIl = RunService.RenderStepped:Connect(function(dt)
                pcall(function()
                    elp += dt
                    if elp >= _IIlIIIlIll then
                        if _lllIlIIIll.Parent then _lllIlIIIll.CFrame = to end
                        if _lIIIlIllIl then _lIIIlIllIl:Disconnect() end
                        return
                    end
                    if _lllIlIIIll.Parent then _lllIlIIIll.CFrame = from:Lerp(to, elp/_IIlIIIlIll) else _lIIIlIllIl:Disconnect() end
                end)
            end)
        end)
        if _lIIIlIllIl then task.wait(_IIlIIIlIll+0x1) if _lIIIlIllIl.Connected then _lIIIlIllIl:Disconnect() end end
    end

    local function _llIlIlllII() return _IlIlIlIlll and _IlIlIlIlll:IsA("BoolValue") and _IlIlIlIlll.Value end

    local function _lIIlIIllII(model)
        if not _IIIIIlIIlI then return 0x0 end
        local _IIlIlllllI, Entries = pcall(function() return _IIIIIlIIlI:GetActiveEntries() end)
        if not _IIlIlllllI or not Entries then return 0x0 end
        for _llIIIlIIII, data in pairs(Entries) do
            if data and data.Model == model then
                local _IlIlIIIIIl, b = _llIIIlIIII:match("^(%d+)_(.+)$")
                if _IlIlIIIIIl and b then
                    local _lIIIIlIlIl, d = pcall(function() return _IIIIIlIIlI:GetDecayAlpha(tonumber(_IlIlIIIIIl), b) end)
                    return _lIIIIlIlIl and d or 0x0
                end
            end
        end
        return 0x0
    end

    local function _llIlIllllI()
        if not _IIIlIlIIll or not _lIIlIlllII then return nil, -0x1 end
        local _IIIIlIllII, bestValue = nil, -0x1
        for _, plot in pairs(_llIllllIlI:GetChildren()) do
            if plot:IsA("Model") then
                local _IllIIllIIl = plot:FindFirstChild("Plants")
                if _IllIIllIIl then
                    for _, model in pairs(_IllIIllIIl:GetChildren()) do
                        if model:IsA("Model") then
                            local _lIlllIIIII = model:FindFirstChild("Fruits")
                            if _lIlllIIIII then
                                for _, fruit in pairs(_lIlllIIIII:GetChildren()) do
                                    if fruit:IsA("Model") then
                                        local _lIllllIIll = model:GetAttribute("SeedName") or model:GetAttribute("CorePartName")
                                        if _lIllllIIll and _IIIlIlIIll.IsPlantStealable(_lIllllIIll) then
                                            local _IIlIIllIll = tonumber(model:GetAttribute("UserId"))
                                            if _IIlIIllIll then
                                                local _lIlIlIIIII = Players:GetPlayerByUserId(_IIlIIllIll)
                                                if _lIlIlIIIII and not _lIIlIlllII(_lIlIlIIIII) then
                                                    local _IIIIIIlllI = fruit:GetAttribute("Mutation") or ""
                                                    local _lIIIllIllI = fruit:GetAttribute("SizeMulti") or 0x1
                                                    local _IIIlllIllI = _lIIlIIllII(model)
                                                    local _IIlIlllllI, _lIIIIIlIlI = pcall(function() return _lIIlIlllII(_lIllllIIll, _lIIIllIllI, _IIIIIIlllI, _lIIIlllIIl, _IIIlllIllI) end)
                                                    if _IIlIlllllI and _lIIIIIlIlI and _lIIIIIlIlI > bestValue then
                                                        bestValue = _lIIIIIlIlI
                                                        _IIIIlIllII = model
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return _IIIIlIllII, bestValue
    end

    local function _lllIlIIllI(model)
        if not _llIlIlllII() or not model then return end
        local _IIlIIllIll = tonumber(model:GetAttribute("UserId"))
        local _IllIllIlll = model:GetAttribute("PlantId")
        local _IIlIIIlIII = model:GetAttribute("FruitId") or ""
        if not _IIlIIllIll or not _IllIllIlll then return end
        local _IIIllIlIlI = _lIIIlllIIl.Character
        if not _IIIllIlIlI then return end
        local _lllIlIIIll = _IIIllIlIlI:FindFirstChild("HumanoidRootPart")
        if not _lllIlIIIll then return end
        local _IIlIlIllIl = _IlllIIIllI:FindFirstChild("PlotSizeReference")
        if not _IIlIlIllIl then return end
        local _IIIIllIIll = _IIlIlIllIl.CFrame
        local _IlIllIIlll = model:FindFirstChildWhichIsA("BasePart")
        if not _IlIllIIlll then return end
        local _IIlIIIIlll = _IlIllIIlll.CFrame + Vector3.new(0x0,0x3,0x0)
        _IIlIIlIlII(_lllIlIIIll, _IIIIllIIll, _IIlIIIIlll, 33.8)
        task.wait(0x1)
        if _lIlIllIlll and _lIlIllIlll.Steal then
            if _lIlIllIlll.Steal.BeginSteal then _lIlIllIlll.Steal.BeginSteal:Fire(_IIlIIllIll, _IllIllIlll, _IIlIIIlIII) end
            if _lIlIllIlll.Steal.CompleteSteal then _lIlIllIlll.Steal.CompleteSteal:Fire() end
        end
        task.wait(0x1)
        _IIlIIlIlII(_lllIlIIIll, _IIlIIIIlll, _IIIIllIIll, 33.8)
    end

    -- ------------------ Anti-AFK ------------------
    local _IIIIIIllIl = false
    coroutine.wrap(function()
        while true do
            if _IIIIIIllIl then
                local _lllIlIIIll = _IIllIIIIll(_lIIIlllIIl)
                if _lllIlIIIll then _lllIlIIIll.CFrame = _lllIlIIIll.CFrame * CFrame.new(math.random(-0x1,0x1), 0x0, math.random(-0x1,0x1)) end
            end
            task.wait(0x1E)
        end
    end)()

    -- ------------------ Create Toggles & Special Settings ------------------
    local _IIIlllllll, harvestRunning, sellRunning, stealRunning = false, false, false, false
    local _IlllIlIlIl, fertilizeRunning, plantAllRunning = false, false, false

    _llllIIIIll(_lllIlIIIlI["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Farm", false, function(_llllIIIIlI)
        if _llllIIIIlI and not _IIIlllllll then
            _IIIlllllll = true
            coroutine.wrap(function()
                while _IIIlllllll do
                    _IlIIllIllI()
                    _llIIllIIlI()
                    task.wait(0.2)
                    _IlIIllllll()
                    task.wait(_llIIllllll + 0x1)
                end
            end)()
        else
            _IIIlllllll = _llllIIIIlI
        end
    end)

    _llllIIIIll(_lllIlIIIlI["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Harvest", false, function(_llllIIIIlI)
        if _llllIIIIlI and not harvestRunning then
            harvestRunning = true
            coroutine.wrap(function()
                while harvestRunning do
                    _IlIIllIllI()
                    task.wait(_IlIlIIIIIl)
                end
            end)()
        else
            harvestRunning = _llllIIIIlI
        end
    end)

    _llllIIIIll(_lllIlIIIlI["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Sell", false, function(_llllIIIIlI)
        if _llllIIIIlI and not sellRunning then
            sellRunning = true
            coroutine.wrap(function()
                while sellRunning do
                    _llIIllIIlI()
                    task.wait(_llIllIlIlI)
                end
            end)()
        else
            sellRunning = _llllIIIIlI
        end
    end)

    _llllIIIIll(_lllIlIIIlI["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Buy", false, function(_llllIIIIlI)
        _llIlIllIll = _llllIIIIlI
    end)

    _llllIIIIll(_lllIlIIIlI["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Water", false, function(_llllIIIIlI)
        if _llllIIIIlI and not _IlllIlIlIl then
            _IlllIlIlIl = true
            coroutine.wrap(function()
                while _IlllIlIlIl do
                    _IIlIIlllll()
                    task.wait(_IlIIIIIIII)
                end
            end)()
        else
            _IlllIlIlIl = _llllIIIIlI
        end
    end)

    _llllIIIIll(_lllIlIIIlI["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Fertilize", false, function(_llllIIIIlI)
        if _llllIIIIlI and not fertilizeRunning then
            fertilizeRunning = true
            coroutine.wrap(function()
                while fertilizeRunning do
                    _lIIlllllll()
                    task.wait(_lIlIlIIIIl)
                end
            end)()
        else
            fertilizeRunning = _llllIIIIlI
        end
    end)

    _llllIIIIll(_lllIlIIIlI["Farming"]:FindFirstChild("Scroll_Farming"), "Plant All", false, function(_llllIIIIlI)
        if _llllIIIIlI and not plantAllRunning then
            plantAllRunning = true
            coroutine.wrap(function()
                while plantAllRunning do
                    _IlllllIlll()
                    task.wait(0x5)
                end
            end)()
        else
            plantAllRunning = _llllIIIIlI
        end
    end)

    _llllIIIIll(_lllIlIIIlI["Stealing"]:FindFirstChild("Scroll_Stealing"), "Auto Steal", false, function(_llllIIIIlI)
        if _llllIIIIlI and not stealRunning then
            stealRunning = true
            coroutine.wrap(function()
                while stealRunning do
                    if _llIlIlllII() then
                        local _IllIlIlIlI, _ = _llIlIllllI()
                        if _IllIlIlIlI then _lllIlIIllI(_IllIlIlIlI); task.wait(0x2) end
                    end
                    task.wait(_lIIIllIlIl)
                end
            end)()
        else
            stealRunning = _llllIIIIlI
        end
    end)

    local _IllIIIIIll = _lllIlIIIlI["Settings"]:FindFirstChild("Scroll_Settings")
    if _IllIIIIIll then
        local _lllIllIIll = Instance.new("TextLabel")
        _lllIllIIll.Size = UDim2.new(0.9, 0x0, 0x0, 0x16)
        _lllIllIIll.BackgroundTransparency = 0x1
        _lllIllIIll.Text = "Growth Time (seconds)"
        _lllIllIIll.TextColor3 = _lllIIIlllI
        _lllIllIIll.Font = _llIllllIlI
        _lllIllIIll.TextSize = 0xE
        _lllIllIIll.TextXAlignment = Enum.TextXAlignment.Left
        _lllIllIIll.Parent = _IllIIIIIll

        local _IlIIlllIIl = Instance.new("TextBox")
        _IlIIlllIIl.Size = UDim2.new(0.9, 0x0, 0x0, 0x24)
        _IlIIlllIIl.BackgroundColor3 = Color3.fromRGB(0x1E,0x1E,0x2D)
        _IlIIlllIIl.Text = "15"
        _IlIIlllIIl.TextColor3 = _lIllllIIIl
        _IlIIlllIIl.Font = _llIllllIlI
        _IlIIlllIIl.TextSize = 0x10
        _IlIIlllIIl.PlaceholderText = "Seconds"
        _IlIIlllIIl.ClearTextOnFocus = false
        _llIIlIllIl(_IlIIlllIIl, 0x8)
        _IlIIlllIIl.Parent = _IllIIIIIll

        _IlIIlllIIl.FocusLost:Connect(function()
            local _IlIIlllIlI = tonumber(_IlIIlllIIl.Text)
            if _IlIIlllIlI and _IlIIlllIlI > 0x0 then _llIIllllll = _IlIIlllIlI else _IlIIlllIIl.Text = tostring(_llIIllllll) end
        end)

        _llllIIIIll(_IllIIIIIll, "Anti-AFK", false, function(_llllIIIIlI)
            _IIIIIIllIl = _llllIIIIlI
        end)
    end

    print("[Babis] All features loaded. Press B to toggle panel.")
end)()
 end)(...)