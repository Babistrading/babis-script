--[[ Protected by Lua Guard ]]

(function(...) 
-- ============================================================
--  BABIS GAG 0x2 – ULTIMATE (Scrollable + Weather + Mobile/PC)
--  Press B to toggle panel. Responsive scaling, draggable.
--  New Weather tab: 24h moon forecast.
--  Improved Auto Buy with fallback prices.
-- ============================================================

print("=== Babis GAG 2 Ultimate – Starting ===")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("LocalPlayer not found")
    return
end

local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or Instance.new("PlayerGui", LocalPlayer)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Main ScreenGui with auto-scaling for mobile/PC
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BabisGAG2Gui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Add UIScale to adapt to different screens
local uiScale = Instance.new("UIScale")
uiScale.Name = "UIScale"
uiScale.Scale = 0x1
uiScale.Parent = screenGui

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local viewport = camera.ViewportSize
    local scaleX = viewport.X / 0x780
    local scaleY = viewport.Y / 0x438
    local scale = math.min(scaleX, scaleY, 1.2)   -- cap at 1.2
    if uiScale then uiScale.Scale = scale end
end
updateScale()
game:GetService("RunService").RenderStepped:Connect(updateScale)

-- ---------- Style constants ----------
local COLOR_BG = Color3.fromRGB(0xF, 0xF, 0x19)
local COLOR_SECTION = Color3.fromRGB(0x19, 0x19, 0x26)
local COLOR_ACCENT = Color3.fromRGB(0xFF, 0xBE, 0x3C)
local COLOR_ACCENT_LIGHT = Color3.fromRGB(0xFF, 0xD2, 0x78)
local COLOR_TEXT = Color3.new(0x1, 0x1, 0x1)
local COLOR_TEXT_SECONDARY = Color3.fromRGB(0xB4, 0xB4, 0xC8)
local COLOR_ON = Color3.fromRGB(0x3C, 0x3C, 0x5A)
local COLOR_OFF = Color3.fromRGB(0x23, 0x23, 0x37)
local COLOR_TOGGLE_TRACK_ON = Color3.fromRGB(0x0, 0xB4, 0x78)
local COLOR_TOGGLE_TRACK_OFF = Color3.fromRGB(0x50, 0x50, 0x64)
local COLOR_TOGGLE_KNOB = Color3.fromRGB(0xFF, 0xFF, 0xFF)
local FONT_TITLE = Enum.Font.GothamBlack
local FONT_BOLD = Enum.Font.GothamBold
local FONT_SEMIBOLD = Enum.Font.GothamSemibold
local FONT_REGULAR = Enum.Font.Gotham

-- Helper: apply corner
local function applyCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0x0, radius)
    corner.Parent = instance
end

-- ---------- Main Panel ----------
local mainPanel = Instance.new("Frame")
mainPanel.Name = "MainPanel"
mainPanel.Size = UDim2.fromOffset(0x190, 0x208)   -- base size; UIScale will handle scaling
mainPanel.Position = UDim2.new(0.5, -0xC8, 0.5, -0x104)
mainPanel.BackgroundColor3 = COLOR_BG
mainPanel.BackgroundTransparency = 0.05
mainPanel.BorderSizePixel = 0x0
mainPanel.AnchorPoint = Vector2.new(0.5, 0.5)
mainPanel.Visible = true
mainPanel.Parent = screenGui
applyCorner(mainPanel, 0x10)

-- Gradient background
local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0x0, Color3.fromRGB(0x12, 0x12, 0x1E)),
    ColorSequenceKeypoint.new(0x1, Color3.fromRGB(0xC, 0xC, 0x16))
})
mainGradient.Rotation = 0x2D
mainGradient.Parent = mainPanel

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(0x1, 0x0, 0x0, 0x30)
titleBar.BackgroundColor3 = COLOR_SECTION
titleBar.BorderSizePixel = 0x0
applyCorner(titleBar, 0x10)
titleBar.Parent = mainPanel

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0x0, Color3.fromRGB(0x1E, 0x1E, 0x2D)),
    ColorSequenceKeypoint.new(0x1, Color3.fromRGB(0x14, 0x14, 0x23))
})
titleGradient.Rotation = 0x5A
titleGradient.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0x0, 0x1, 0x0)
titleLabel.Position = UDim2.new(0x0, 0x14, 0x0, 0x0)
titleLabel.BackgroundTransparency = 0x1
titleLabel.Text = "🌿 Babis GAG 2"
titleLabel.TextColor3 = COLOR_ACCENT
titleLabel.Font = FONT_TITLE
titleLabel.TextSize = 0x16
titleLabel.Parent = titleBar

-- Universal drag (mouse + touch)
local dragStart, startPos, isDragging = nil, nil, false
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = mainPanel.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                isDragging = false
                dragStart = nil
            end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(0x1E, 0x1E)
closeBtn.Position = UDim2.new(0x1, -0x28, 0x0, 0x9)
closeBtn.BackgroundColor3 = Color3.fromRGB(0xC8, 0x3C, 0x3C)
closeBtn.Text = "✕"
closeBtn.TextColor3 = COLOR_TEXT
closeBtn.Font = FONT_BOLD
closeBtn.TextSize = 0x10
closeBtn.BorderSizePixel = 0x0
applyCorner(closeBtn, 0xF)
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() mainPanel.Visible = false end)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0xF0, 0x50, 0x50)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0xC8, 0x3C, 0x3C)}):Play()
end)

-- ---------- Tab System (Farming, Stealing, Weather, Settings) ----------
local tabs = {"Farming", "Stealing", "Weather", "Settings"}
local selectedTab = "Farming"
local tabButtons = {}
local tabFrames = {}

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0x1, 0x0, 0x0, 0x28)
tabBar.Position = UDim2.new(0x0, 0x0, 0x0, 0x30)
tabBar.BackgroundColor3 = COLOR_SECTION
tabBar.BorderSizePixel = 0x0
tabBar.Parent = mainPanel

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0x1/#tabs, -0x4, 0x1, -0x4)
    btn.Position = UDim2.new((i-0x1)/#tabs, 0x2, 0x0, 0x2)
    btn.BackgroundColor3 = COLOR_OFF
    btn.Text = tabName
    btn.TextColor3 = COLOR_TEXT_SECONDARY
    btn.Font = FONT_SEMIBOLD
    btn.TextSize = 0xE
    btn.BorderSizePixel = 0x0
    applyCorner(btn, 0x8)
    btn.Parent = tabBar
    tabButtons[tabName] = btn

    local content = Instance.new("Frame")
    content.Size = UDim2.new(0x1, -0x10, 0x1, -0x60)
    content.Position = UDim2.new(0x0, 0x8, 0x0, 0x5C)
    content.BackgroundTransparency = 0x1
    content.Visible = (tabName == selectedTab)
    content.Parent = mainPanel
    tabFrames[tabName] = content

    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Scroll_" .. tabName
    scroll.Size = UDim2.new(0x1, 0x0, 0x1, 0x0)
    scroll.BackgroundTransparency = 0x1
    scroll.BorderSizePixel = 0x0
    scroll.ScrollBarThickness = 0x4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(0x64, 0x64, 0x82)
    scroll.CanvasSize = UDim2.new(0x0, 0x0, 0x0, 0x258)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = content

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0x0, 0x8)
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scroll

    btn.MouseButton1Click:Connect(function()
        selectedTab = tabName
        for _, f in pairs(tabFrames) do f.Visible = false end
        content.Visible = true
        for _, b in pairs(tabButtons) do
            TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_OFF, TextColor3 = COLOR_TEXT_SECONDARY}):Play()
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = COLOR_ON, TextColor3 = COLOR_TEXT}):Play()
    end)
end
tabButtons[selectedTab].BackgroundColor3 = COLOR_ON
tabButtons[selectedTab].TextColor3 = COLOR_TEXT

-- ---------- Animated Toggle Switch Creator ----------
local function createToggleSwitch(parent, text, default, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0.9, 0x0, 0x0, 0x28)
    container.Position = UDim2.new(0.5, 0x0, 0x0, 0x0)
    container.AnchorPoint = Vector2.new(0.5, 0x0)
    container.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x2D)
    container.BorderSizePixel = 0x0
    applyCorner(container, 0xA)
    container.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0x0, 0x1, 0x0)
    label.Position = UDim2.new(0x0, 0xC, 0x0, 0x0)
    label.BackgroundTransparency = 0x1
    label.Text = text
    label.TextColor3 = COLOR_TEXT
    label.Font = FONT_REGULAR
    label.TextSize = 0xE
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local track = Instance.new("Frame")
    track.Size = UDim2.fromOffset(0x30, 0x18)
    track.Position = UDim2.new(0x1, -0x3C, 0.5, -0xC)
    track.BackgroundColor3 = default and COLOR_TOGGLE_TRACK_ON or COLOR_TOGGLE_TRACK_OFF
    track.BorderSizePixel = 0x0
    applyCorner(track, 0xC)
    track.Parent = container

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(0x14, 0x14)
    knob.Position = UDim2.new(0x0, default and 0x1A or 0x2, 0.5, -0xA)
    knob.BackgroundColor3 = COLOR_TOGGLE_KNOB
    knob.BorderSizePixel = 0x0
    applyCorner(knob, 0xA)
    knob.Parent = track

    local state = default

    local function updateVisual()
        local targetTrackColor = state and COLOR_TOGGLE_TRACK_ON or COLOR_TOGGLE_TRACK_OFF
        local targetKnobPos = state and UDim2.new(0x0, 0x1A, 0.5, -0xA) or UDim2.new(0x0, 0x2, 0.5, -0xA)
        TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = targetTrackColor}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = targetKnobPos}):Play()
    end

    container.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            state = not state
            updateVisual()
            if callback then callback(state) end
        end
    end)

    return container
end

-- ---------- Coin Display ----------
local coinFrame = Instance.new("Frame")
coinFrame.Size = UDim2.new(0.9, 0x0, 0x0, 0x1E)
coinFrame.Position = UDim2.new(0.05, 0x0, 0x1, -0x23)
coinFrame.BackgroundTransparency = 0x1
coinFrame.Parent = mainPanel

local coinIcon = Instance.new("ImageLabel")
coinIcon.Size = UDim2.fromOffset(0x18, 0x18)
coinIcon.Position = UDim2.new(0x0, 0x0, 0.5, -0xC)
coinIcon.BackgroundTransparency = 0x1
coinIcon.Image = "rbxassetid://7734056594"
coinIcon.Parent = coinFrame

local coinLabel = Instance.new("TextLabel")
coinLabel.Size = UDim2.new(0x1, -0x1E, 0x1, 0x0)
coinLabel.Position = UDim2.new(0x0, 0x1E, 0x0, 0x0)
coinLabel.BackgroundTransparency = 0x1
coinLabel.Text = "0"
coinLabel.TextColor3 = COLOR_ACCENT
coinLabel.Font = FONT_BOLD
coinLabel.TextSize = 0x14
coinLabel.TextXAlignment = Enum.TextXAlignment.Left
coinLabel.Parent = coinFrame

-- ---------- Floating B Button ----------
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.fromOffset(0x34, 0x34)
floatBtn.Position = UDim2.new(0x0, 0xC, 0x0, 0xC)
floatBtn.BackgroundColor3 = Color3.fromRGB(0x19, 0x19, 0x28)
floatBtn.Text = "B"
floatBtn.TextColor3 = COLOR_ACCENT
floatBtn.Font = FONT_BOLD
floatBtn.TextSize = 0x1C
floatBtn.BorderSizePixel = 0x0
applyCorner(floatBtn, 0x1A)
floatBtn.Parent = screenGui

-- Pulse animation
coroutine.wrap(function()
    while floatBtn and floatBtn.Parent do
        TweenService:Create(floatBtn, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromOffset(0x38, 0x38)}):Play()
        task.wait(0.8)
        TweenService:Create(floatBtn, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.fromOffset(0x34, 0x34)}):Play()
        task.wait(0.8)
    end
end)()

floatBtn.MouseButton1Click:Connect(function()
    local targetVisible = not mainPanel.Visible
    if targetVisible then
        mainPanel.Visible = true
        mainPanel.Size = UDim2.fromOffset(0x0, 0x0)
        TweenService:Create(mainPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(0x190, 0x208)}):Play()
    else
        TweenService:Create(mainPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.fromOffset(0x0, 0x0)}):Play()
        task.wait(0.2)
        mainPanel.Visible = false
    end
end)
floatBtn.MouseEnter:Connect(function()
    TweenService:Create(floatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0x2D, 0x2D, 0x3C)}):Play()
end)
floatBtn.MouseLeave:Connect(function()
    TweenService:Create(floatBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0x19, 0x19, 0x28)}):Play()
end)

print("[Babis] Enhanced GUI created (mobile+PC).")

-- ==================== Weather Prediction Tab ====================
local sum = 0x258
local moonChances = {
    {Name = "Rainbow Moon", Chance = 0x6},
    {Name = "Goldmoon", Chance = 0xD},
    {Name = "Bloodmoon", Chance = 0x2},
    {Name = "Moon", Chance = 0x4F}
}

local function getMoonType(cycleID, order)
    local rng = Random.new(cycleID * 0x3E8 + order)
    local roll = rng:NextNumber() * 0x64
    local sum2 = 0x0
    for _, moon in ipairs(moonChances) do
        sum2 = sum2 + moon.Chance
        if roll <= sum2 then
            return moon.Name
        end
    end
    return "Moon"
end

local function getPredictions24h()
    local predictions = {}
    local startTime = os.time()
    local endTime = startTime + (0x18 * 0xE10)
    for t = startTime, endTime, sum do
        local cycleID = math.floor(t / sum)
        local timeString = os.date("%I:%M %p", t)
        local moonType = getMoonType(cycleID, 0x3)
        table.insert(predictions, {Time = timeString, Moon = moonType})
    end
    return predictions
end

local weatherScroll = tabFrames["Weather"]:FindFirstChild("Scroll_Weather")
local weatherBuilt = false

local function buildWeatherList()
    if weatherBuilt then return end
    weatherBuilt = true

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.9, 0x0, 0x0, 0x1E)
    title.BackgroundTransparency = 0x1
    title.Text = "🌙 24-Hour Moon Forecast"
    title.TextColor3 = COLOR_ACCENT
    title.Font = FONT_BOLD
    title.TextSize = 0x12
    title.Parent = weatherScroll

    local predictions = getPredictions24h()
    for _, pred in ipairs(predictions) do
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(0.9, 0x0, 0x0, 0x1E)
        entry.BackgroundColor3 = Color3.fromRGB(0x1E,0x1E,0x2D)
        entry.BorderSizePixel = 0x0
        applyCorner(entry, 0x6)
        entry.Parent = weatherScroll

        local timeLabel = Instance.new("TextLabel")
        timeLabel.Size = UDim2.new(0.5, 0x0, 0x1, 0x0)
        timeLabel.BackgroundTransparency = 0x1
        timeLabel.Text = pred.Time
        timeLabel.TextColor3 = COLOR_TEXT
        timeLabel.Font = FONT_SEMIBOLD
        timeLabel.TextSize = 0xE
        timeLabel.Parent = entry

        local moonLabel = Instance.new("TextLabel")
        moonLabel.Size = UDim2.new(0.5, 0x0, 0x1, 0x0)
        moonLabel.Position = UDim2.new(0.5, 0x0, 0x0, 0x0)
        moonLabel.BackgroundTransparency = 0x1
        moonLabel.Text = pred.Moon
        moonLabel.TextColor3 = COLOR_ACCENT_LIGHT
        moonLabel.Font = FONT_REGULAR
        moonLabel.TextSize = 0xE
        moonLabel.Parent = entry
    end
end

tabButtons["Weather"].MouseButton1Click:Connect(buildWeatherList)
if selectedTab == "Weather" then
    buildWeatherList()
end

-- ==================== Background Features ====================
coroutine.wrap(function()
    task.wait(0.5)

    -- ------------------ Configuration ------------------
    local GROW_TIME = 0xF
    local SELL_INTERVAL = 0.5
    local HARVEST_INTERVAL = 0.5
    local BUY_INTERVAL = 0.1
    local WATER_INTERVAL = 0x1E
    local FERTILIZE_INTERVAL = 0x3C
    local STEAL_INTERVAL = 0x5

    local SEED_TIERS = {
        "Dragon's Breath", "Hypno Bloom", "Moon Bloom", "Briar Rose",
        "Venom Spitter", "Poison Apple", "Pomegranate", "Venus Fly Trap",
        "Fire Fern", "Sunflower", "Cherry", "Acorn", "Dragon Fruit",
        "Rocket Pop", "Mango", "Coconut", "Grape", "Banana", "Green Bean",
        "Mushroom", "Pineapple", "Cactus", "Corn", "Bamboo",
        "Apple", "Tomato", "Tulip", "Blueberry", "Strawberry", "Carrot"
    }

    local FALLBACK_PRICES = {
        ["Carrot"] = 0x1, ["Strawberry"] = 0xA, ["Blueberry"] = 0x19,
        ["Tulip"] = 0x28, ["Tomato"] = 0xC8, ["Apple"] = 0x190,
        ["Bamboo"] = 0x2BC, ["Corn"] = 0x9C4, ["Cactus"] = 0x1388,
        ["Pineapple"] = 0x2710, ["Mushroom"] = 0x3A98, ["Green Bean"] = 0x4E20,
        ["Banana"] = 0x7530, ["Grape"] = 0xC350, ["Coconut"] = 0x222E0,
        ["Mango"] = 0x493E0, ["Rocket Pop"] = 0x6B6C, ["Dragon Fruit"] = 0x1D4C0,
        ["Acorn"] = 0xAAE60, ["Cherry"] = 0x124F80, ["Sunflower"] = 0x4C4B40,
        ["Fire Fern"] = 0x5B8D80, ["Venus Fly Trap"] = 0x6ACFC0,
        ["Pomegranate"] = 0xB71B00, ["Poison Apple"] = 0x17D7840,
        ["Venom Spitter"] = 0x1C9C380, ["Briar Rose"] = 0x2FAF080,
        ["Moon Bloom"] = 0x3DFD240, ["Hypno Bloom"] = 0x55D4A80,
        ["Dragon's Breath"] = 0x7BFA480,
    }

    -- ------------------ Safe Require ------------------
    local function safeRequire(module)
        local s, r = pcall(function() return require(module) end)
        return s and r or nil
    end

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local RunService = game:GetService("RunService")

    local SharedModules = ReplicatedStorage:FindFirstChild("SharedModules")
    if not SharedModules then SharedModules = ReplicatedStorage:WaitForChild("SharedModules", 0x5) end

    local Networking = SharedModules and safeRequire(SharedModules:FindFirstChild("Networking"))
    local StealFlags = SharedModules and safeRequire(SharedModules:FindFirstChild("Flags") and SharedModules.Flags:FindFirstChild("StealFlags"))
    local FruitValueCalc = SharedModules and safeRequire(SharedModules:FindFirstChild("FruitValueCalc"))

    local PlantCycleModule = nil
    local PlantLifecycleHandler = LocalPlayer:FindFirstChild("PlayerScripts")
        and LocalPlayer.PlayerScripts:FindFirstChild("Controllers")
        and LocalPlayer.PlayerScripts.Controllers:FindFirstChild("PlantLifecycleHandler")
    if PlantLifecycleHandler then PlantCycleModule = safeRequire(PlantLifecycleHandler) end

    local Night = ReplicatedStorage:FindFirstChild("Night")

    -- ------------------ Get Plot ------------------
    local Gardens = Workspace:FindFirstChild("Gardens")
    if not Gardens then Gardens = Workspace:WaitForChild("Gardens", 0xA) end
    if not Gardens then coinLabel.Text = "Error: Gardens not found" return end

    local OwnerPlot
    local st = tick()
    while not OwnerPlot and tick() - st < 0x1E do
        task.wait(0.1)
        for _, plot in pairs(Gardens:GetChildren()) do
            if plot:GetAttribute("Owner") == LocalPlayer.Name then
                OwnerPlot = plot
                break
            end
        end
    end
    if not OwnerPlot then coinLabel.Text = "Error: Plot not found" return end

    -- ------------------ Coin Detection ------------------
    local function getCoins()
        for _, attr in ipairs({"Sheckles","Coins","Currency","Money","Gems"}) do
            local v = LocalPlayer:GetAttribute(attr)
            if type(v) == "number" and v >= 0x0 then return v end
        end
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        if ls then
            for _, child in pairs(ls:GetChildren()) do
                if child:IsA("NumberValue") and child.Name:lower():match("coin") or child.Name:lower():match("sheckle") or child.Name:lower():match("money") or child.Name:lower():match("cash") then
                    return child.Value
                end
            end
        end
        for _, child in pairs(LocalPlayer:GetDescendants()) do
            if child:IsA("NumberValue") or child:IsA("IntValue") then
                local n = child.Name:lower()
                if n:find("coin") or n:find("sheckle") or n:find("money") or n:find("cash") then
                    local v = tonumber(child.Value)
                    if v and v >= 0x0 then return v end
                end
            end
        end
        local gui = LocalPlayer:FindFirstChild("PlayerGui")
        if gui then
            for _, lbl in pairs(gui:GetDescendants()) do
                if lbl:IsA("TextLabel") or lbl:IsA("TextButton") then
                    local num = tonumber(lbl.Text:gsub("[^%d.]", ""))
                    if num and num >= 0x0 then return num end
                end
            end
        end
        return 0x0
    end

    coroutine.wrap(function()
        while true do
            task.wait(0x1)
            pcall(function() coinLabel.Text = tostring(getCoins()) end)
        end
    end)()

    -- ------------------ Improved Auto Buy Logic ------------------
    local PurchaseSeeds = Networking and Networking.SeedShop and Networking.SeedShop.PurchaseSeed
    local SeedsStock = ReplicatedStorage:FindFirstChild("StockValues") and ReplicatedStorage.StockValues:FindFirstChild("SeedShop") and ReplicatedStorage.StockValues.SeedShop:FindFirstChild("Items")

    local prices = {}
    if getgc then
        for _, v in pairs(getgc()) do
            if type(v) == "function" then
                local info = debug and debug.info(v, "s")
                if info and info:match("RestockStoreController") and debug.info(v, "l") == 0x23F then
                    pcall(function() table.insert(prices, debug.getupvalue(v, 0x3)) end)
                end
            end
        end
    end

    local function getPrice(item)
        if prices then
            for _, options in pairs(prices) do
                local s, r = pcall(function() return options[item] and options[item].price end)
                if s and r then return r end
            end
        end
        return FALLBACK_PRICES[item]
    end

    local function canAfford(item) return getCoins() >= (getPrice(item) or 0x0) end

    local function getBestAffordableSeed()
        if not SeedsStock then return nil end
        local best, bestTier = nil, math.huge
        for _, seed in pairs(SeedsStock:GetChildren()) do
            if seed:IsA("NumberValue") and seed.Value > 0x0 and canAfford(seed.Name) then
                local tier = 0x3E7
                for i, t in ipairs(SEED_TIERS) do
                    if seed.Name:find(t, 0x1, true) then tier = i break end
                end
                if tier < bestTier then bestTier = tier; best = seed.Name end
            end
        end
        return best
    end

    local function buySeed(name)
        if not name or not PurchaseSeeds then return end
        pcall(function() PurchaseSeeds:Fire(name) end)
    end

    -- ------------------ Planting ------------------
    local function getHumanoid(plr) return plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") end
    local function getRoot(plr) local h = getHumanoid(plr) return h and h.RootPart end

    local function getAllPlantSpots(plot)
        local spots = {}
        if not plot then return spots end
        for _, part in pairs(plot:GetDescendants()) do
            if part:IsA("BasePart") and part.Name:lower():match("plant") or part.Name:lower():match("planter") or part.Name:lower():match("area") or part.Name:lower():match("soil") or part.Name:lower():match("plot") then
                table.insert(spots, part)
            end
        end
        if #spots == 0x0 then
            local ref = plot:FindFirstChild("PlotSizeReference") or plot:FindFirstChildWhichIsA("BasePart")
            if ref then table.insert(spots, ref) end
        end
        return spots
    end

    local function randomPlantPos(plot)
        local spots = getAllPlantSpots(plot)
        if #spots == 0x0 then return nil end
        local sel = spots[math.random(0x1, #spots)]
        local sz = sel.Size
        return sel.CFrame.Position + Vector3.new((math.random()-0.5)*sz.X*0.6, 0x2, (math.random()-0.5)*sz.Z*0.6)
    end

    local function findBestSeedTool()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return nil end
        local best, bestTier = nil, 0x3E7
        for _, item in pairs(bp:GetChildren()) do
            local seed = item:GetAttribute("SeedTool") or item.Name
            if seed then
                local tier = 0x3E7
                for i, t in ipairs(SEED_TIERS) do
                    if seed:find(t, 0x1, true) then tier = i break end
                end
                if tier < bestTier then bestTier = tier; best = item end
            end
        end
        return best
    end

    local function equipTool(tool)
        local hum = getHumanoid(LocalPlayer)
        if not hum then return false end
        if tool.Parent == LocalPlayer.Character then return true end
        tool.Parent = LocalPlayer.Character
        hum:EquipTool(tool)
        return true
    end

    local function plantSeed()
        if not (Networking and Networking.Plant and Networking.Plant.PlantSeed) then return false end
        local tool = findBestSeedTool()
        if not tool then return false end
        local pos = randomPlantPos(OwnerPlot)
        if not pos then return false end
        local seedName = tool:GetAttribute("SeedTool") or tool.Name
        if not equipTool(tool) then return false end
        local root = getRoot(LocalPlayer)
        if root then root.CFrame = CFrame.new(pos) + Vector3.new(0x0,0x2,0x0) task.wait(0.2) end
        pcall(function() Networking.Plant.PlantSeed:Fire(pos, seedName, tool) end)
        return true
    end

    local function plantAllSeeds()
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return end
        for _, tool in pairs(bp:GetChildren()) do
            if tool:GetAttribute("SeedTool") then
                local pos = randomPlantPos(OwnerPlot)
                if pos and equipTool(tool) then
                    local root = getRoot(LocalPlayer)
                    if root then root.CFrame = CFrame.new(pos) + Vector3.new(0x0,0x2,0x0) end
                    task.wait(0.1)
                    pcall(function() Networking.Plant.PlantSeed:Fire(pos, tool:GetAttribute("SeedTool") or tool.Name, tool) end)
                    task.wait(0.2)
                end
            end
        end
    end

    -- ------------------ Harvest ------------------
    local function isGrown(plant)
        local maxAge = plant:GetAttribute("MaxAge")
        local currentAge = plant:GetAttribute("Age")
        return maxAge and currentAge and currentAge >= maxAge
    end

    local function getHarvestablePlants(plot)
        local plants = {}
        local folder = plot and plot:FindFirstChild("Plants")
        if not folder then return plants end
        for _, plant in pairs(folder:GetChildren()) do
            local fruits = plant:FindFirstChild("Fruits")
            if fruits then
                for _, fruit in pairs(fruits:GetChildren()) do
                    if fruit:IsA("Model") and isGrown(fruit) then table.insert(plants, fruit) end
                end
            elseif plant:IsA("Model") and isGrown(plant) then table.insert(plants, plant) end
        end
        return plants
    end

    local function harvestPlant(plant)
        if not plant or not Networking or not Networking.Garden or not Networking.Garden.CollectFruit then return end
        local id = plant:GetAttribute("PlantId")
        local fid = plant:GetAttribute("FruitId") or ""
        if id then pcall(function() Networking.Garden.CollectFruit:Fire(id, fid) end) end
    end

    -- ------------------ Sell ------------------
    local function sellAll()
        if Networking and Networking.NPCS and Networking.NPCS.SellAll then
            pcall(function() Networking.NPCS.SellAll:Fire() end)
        end
    end

    -- ------------------ Water / Fertilize ------------------
    local function getToolByPartial(name)
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if not bp then return nil end
        for _, t in pairs(bp:GetChildren()) do
            if t.Name:lower():find(name:lower()) then return t end
        end
        return nil
    end

    local function waterAll()
        local tool = getToolByPartial("Water")
        if not tool or not equipTool(tool) then return end
        for _, spot in ipairs(getAllPlantSpots(OwnerPlot)) do
            local root = getRoot(LocalPlayer)
            if root then root.CFrame = CFrame.new(spot.Position + Vector3.new(0x0,0x3,0x0)) end
            task.wait(0.2)
            if Networking and Networking.Garden and Networking.Garden.Water then
                pcall(function() Networking.Garden.Water:Fire(spot) end)
            end
            task.wait(0.5)
        end
    end

    local function fertilizeAll()
        local tool = getToolByPartial("Fertil")
        if not tool or not equipTool(tool) then return end
        for _, spot in ipairs(getAllPlantSpots(OwnerPlot)) do
            local root = getRoot(LocalPlayer)
            if root then root.CFrame = CFrame.new(spot.Position + Vector3.new(0x0,0x3,0x0)) end
            task.wait(0.2)
            if Networking and Networking.Garden and Networking.Garden.Fertilize then
                pcall(function() Networking.Garden.Fertilize:Fire(spot) end)
            end
            task.wait(0.5)
        end
    end

    -- ------------------ Steal ------------------
    local function canSteal(player)
        local s, r = pcall(function() return player:GetAttribute("IsInOwnGarden") end)
        return s and r or false
    end

    local function teleportTo(hrp, from, to, speed)
        if not to or not from or not hrp then return end
        local dist = (to.Position - from.Position).Magnitude
        local dur = dist / speed
        local con, elp = nil, 0x0
        pcall(function()
            con = RunService.RenderStepped:Connect(function(dt)
                pcall(function()
                    elp += dt
                    if elp >= dur then
                        if hrp.Parent then hrp.CFrame = to end
                        if con then con:Disconnect() end
                        return
                    end
                    if hrp.Parent then hrp.CFrame = from:Lerp(to, elp/dur) else con:Disconnect() end
                end)
            end)
        end)
        if con then task.wait(dur+0x1) if con.Connected then con:Disconnect() end end
    end

    local function isNight() return Night and Night:IsA("BoolValue") and Night.Value end

    local function getDecay(model)
        if not PlantCycleModule then return 0x0 end
        local s, Entries = pcall(function() return PlantCycleModule:GetActiveEntries() end)
        if not s or not Entries then return 0x0 end
        for id, data in pairs(Entries) do
            if data and data.Model == model then
                local a, b = id:match("^(%d+)_(.+)$")
                if a and b then
                    local ok, d = pcall(function() return PlantCycleModule:GetDecayAlpha(tonumber(a), b) end)
                    return ok and d or 0x0
                end
            end
        end
        return 0x0
    end

    local function getBestStealTarget()
        if not StealFlags or not FruitValueCalc then return nil, -0x1 end
        local bestModel, bestValue = nil, -0x1
        for _, plot in pairs(Gardens:GetChildren()) do
            if plot:IsA("Model") then
                local plants = plot:FindFirstChild("Plants")
                if plants then
                    for _, model in pairs(plants:GetChildren()) do
                        if model:IsA("Model") then
                            local fruits = model:FindFirstChild("Fruits")
                            if fruits then
                                for _, fruit in pairs(fruits:GetChildren()) do
                                    if fruit:IsA("Model") then
                                        local seed = model:GetAttribute("SeedName") or model:GetAttribute("CorePartName")
                                        if seed and StealFlags.IsPlantStealable(seed) then
                                            local uid = tonumber(model:GetAttribute("UserId"))
                                            if uid then
                                                local target = Players:GetPlayerByUserId(uid)
                                                if target and not canSteal(target) then
                                                    local mutation = fruit:GetAttribute("Mutation") or ""
                                                    local sizeMul = fruit:GetAttribute("SizeMulti") or 0x1
                                                    local decay = getDecay(model)
                                                    local s, v = pcall(function() return FruitValueCalc(seed, sizeMul, mutation, LocalPlayer, decay) end)
                                                    if s and v and v > bestValue then
                                                        bestValue = v
                                                        bestModel = model
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
        return bestModel, bestValue
    end

    local function performSteal(model)
        if not isNight() or not model then return end
        local uid = tonumber(model:GetAttribute("UserId"))
        local pid = model:GetAttribute("PlantId")
        local fid = model:GetAttribute("FruitId") or ""
        if not uid or not pid then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local ref = OwnerPlot:FindFirstChild("PlotSizeReference")
        if not ref then return end
        local oldCF = ref.CFrame
        local part = model:FindFirstChildWhichIsA("BasePart")
        if not part then return end
        local targetCF = part.CFrame + Vector3.new(0x0,0x3,0x0)
        teleportTo(hrp, oldCF, targetCF, 33.8)
        task.wait(0x1)
        if Networking and Networking.Steal then
            if Networking.Steal.BeginSteal then Networking.Steal.BeginSteal:Fire(uid, pid, fid) end
            if Networking.Steal.CompleteSteal then Networking.Steal.CompleteSteal:Fire() end
        end
        task.wait(0x1)
        teleportTo(hrp, targetCF, oldCF, 33.8)
    end

    -- ------------------ Anti-AFK ------------------
    local afkEnabled = false
    coroutine.wrap(function()
        while true do
            if afkEnabled then
                local hrp = getRoot(LocalPlayer)
                if hrp then hrp.CFrame = hrp.CFrame * CFrame.new(math.random(-0x1,0x1), 0x0, math.random(-0x1,0x1)) end
            end
            task.wait(0x1E)
        end
    end)()

    -- ------------------ Create Toggles & Connect ------------------
    local farmRunning, harvestRunning, sellRunning, buyRunning, stealRunning = false, false, false, false, false
    local waterRunning, fertilizeRunning, plantAllRunning = false, false, false

    -- Farming Tab
    createToggleSwitch(tabFrames["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Farm", false, function(state)
        if state and not farmRunning then
            farmRunning = true
            coroutine.wrap(function()
                while farmRunning do
                    for _, fruit in ipairs(getHarvestablePlants(OwnerPlot)) do harvestPlant(fruit) end
                    sellAll()
                    task.wait(0.5)
                    local best = getBestAffordableSeed()
                    if best then buySeed(best); task.wait(0x1) end
                    plantSeed()
                    task.wait(GROW_TIME + 0x1)
                end
                farmRunning = false
            end)()
        else
            farmRunning = state
        end
    end)

    createToggleSwitch(tabFrames["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Harvest", false, function(state)
        if state and not harvestRunning then
            harvestRunning = true
            coroutine.wrap(function()
                while harvestRunning do
                    for _, fruit in ipairs(getHarvestablePlants(OwnerPlot)) do harvestPlant(fruit) end
                    task.wait(HARVEST_INTERVAL)
                end
                harvestRunning = false
            end)()
        else
            harvestRunning = state
        end
    end)

    createToggleSwitch(tabFrames["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Sell", false, function(state)
        if state and not sellRunning then
            sellRunning = true
            coroutine.wrap(function()
                while sellRunning do
                    sellAll()
                    task.wait(SELL_INTERVAL)
                end
                sellRunning = false
            end)()
        else
            sellRunning = state
        end
    end)

    createToggleSwitch(tabFrames["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Buy", false, function(state)
        if state and not buyRunning then
            buyRunning = true
            coroutine.wrap(function()
                while buyRunning do
                    local best = getBestAffordableSeed()
                    if best then buySeed(best) end
                    task.wait(BUY_INTERVAL)
                end
                buyRunning = false
            end)()
        else
            buyRunning = state
        end
    end)

    createToggleSwitch(tabFrames["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Water", false, function(state)
        if state and not waterRunning then
            waterRunning = true
            coroutine.wrap(function()
                while waterRunning do
                    waterAll()
                    task.wait(WATER_INTERVAL)
                end
                waterRunning = false
            end)()
        else
            waterRunning = state
        end
    end)

    createToggleSwitch(tabFrames["Farming"]:FindFirstChild("Scroll_Farming"), "Auto Fertilize", false, function(state)
        if state and not fertilizeRunning then
            fertilizeRunning = true
            coroutine.wrap(function()
                while fertilizeRunning do
                    fertilizeAll()
                    task.wait(FERTILIZE_INTERVAL)
                end
                fertilizeRunning = false
            end)()
        else
            fertilizeRunning = state
        end
    end)

    createToggleSwitch(tabFrames["Farming"]:FindFirstChild("Scroll_Farming"), "Plant All", false, function(state)
        if state and not plantAllRunning then
            plantAllRunning = true
            coroutine.wrap(function()
                while plantAllRunning do
                    plantAllSeeds()
                    task.wait(0x5)
                end
                plantAllRunning = false
            end)()
        else
            plantAllRunning = state
        end
    end)

    -- Stealing Tab
    createToggleSwitch(tabFrames["Stealing"]:FindFirstChild("Scroll_Stealing"), "Auto Steal", false, function(state)
        if state and not stealRunning then
            stealRunning = true
            coroutine.wrap(function()
                while stealRunning do
                    if isNight() then
                        local best, _ = getBestStealTarget()
                        if best then performSteal(best); task.wait(0x2) end
                    end
                    task.wait(STEAL_INTERVAL)
                end
                stealRunning = false
            end)()
        else
            stealRunning = state
        end
    end)

    -- Settings Tab
    local settingsScroll = tabFrames["Settings"]:FindFirstChild("Scroll_Settings")
    if settingsScroll then
        local growthLabel = Instance.new("TextLabel")
        growthLabel.Size = UDim2.new(0.9, 0x0, 0x0, 0x16)
        growthLabel.BackgroundTransparency = 0x1
        growthLabel.Text = "Growth Time (seconds)"
        growthLabel.TextColor3 = COLOR_TEXT_SECONDARY
        growthLabel.Font = FONT_REGULAR
        growthLabel.TextSize = 0xE
        growthLabel.TextXAlignment = Enum.TextXAlignment.Left
        growthLabel.Parent = settingsScroll

        local growthInput = Instance.new("TextBox")
        growthInput.Size = UDim2.new(0.9, 0x0, 0x0, 0x24)
        growthInput.BackgroundColor3 = Color3.fromRGB(0x1E,0x1E,0x2D)
        growthInput.Text = "15"
        growthInput.TextColor3 = COLOR_TEXT
        growthInput.Font = FONT_REGULAR
        growthInput.TextSize = 0x10
        growthInput.PlaceholderText = "Seconds"
        growthInput.ClearTextOnFocus = false
        applyCorner(growthInput, 0x8)
        growthInput.Parent = settingsScroll

        growthInput.FocusLost:Connect(function()
            local num = tonumber(growthInput.Text)
            if num and num > 0x0 then GROW_TIME = num else growthInput.Text = tostring(GROW_TIME) end
        end)

        createToggleSwitch(settingsScroll, "Anti-AFK", false, function(state)
            afkEnabled = state
        end)
    end

    print("[Babis] All features loaded. Press B to toggle panel.")
end)()
 end)(...)