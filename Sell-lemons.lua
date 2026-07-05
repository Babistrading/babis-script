--[[ Protected by Lua Guard ]]

--"\091\010\032\032\032\032\066\097\098\105\115\032\115\101\108\108\032\108\101\109\111\110\115\032\8212\032\083\117\112\114\101\109\101\032\070\117\115\105\111\110\032\071\085\073\010\032\032\032\032\068\097\114\107\032\116\104\101\109\101\032\183\032\084\111\103\103\108\101\032\098\117\116\116\111\110\032\183\032\083\108\105\100\101\114\115\032\183\032\065\108\108\032\072\101\097\116\032\077\097\115\116\101\114\032\102\101\097\116\117\114\101\115\032\105\110\116\101\103\114\097\116\101\100\010\032\032\032\032\067\097\115\104\032\100\114\111\112\115\032\102\105\120\101\100\032\183\032\069\110\103\108\105\115\104\032\118\101\114\115\105\111\110\032\183\032\077\097\100\101\032\119\105\116\104\032\108\111\118\101\032\098\121\032\080\121\114\105\116\101\032\060\051\010\093"

if not game:IsLoaded() then game.Loaded:Wait() end

-- ================== SERVICES ==================
local RunService = game:GetService("\082\117\110\083\101\114\118\105\099\101")
local UserInputService = game:GetService("\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101")
local Workspace = game:GetService("\087\111\114\107\115\112\097\099\101")
local Players = game:GetService("\080\108\097\121\101\114\115")
local ReplicatedStorage = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101")
local VirtualUser = game:GetService("\086\105\114\116\117\097\108\085\115\101\114")
local TweenService = game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then warn("\091\066\097\098\105\115\093\032\078\111\032\076\111\099\097\108\080\108\097\121\101\114"); return end

pcall(function() for _,v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end end)

-- ================== LOADING SCREEN ==================
local LoadingScreen = Instance.new("\083\099\114\101\101\110\071\117\105")
LoadingScreen.Name = "\066\097\098\105\115\076\111\097\100\105\110\103"
LoadingScreen.Parent = LocalPlayer:WaitForChild("\080\108\097\121\101\114\071\117\105")
LoadingScreen.ResetOnSpawn = false
LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local LoadingFrame = Instance.new("\070\114\097\109\101")
LoadingFrame.Size = UDim2.new(0, 320, 0, 90)
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -45)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ClipsDescendants = true
LoadingFrame.Parent = LoadingScreen
local lcorner = Instance.new("\085\073\067\111\114\110\101\114"); lcorner.CornerRadius = UDim.new(0, 10); lcorner.Parent = LoadingFrame
local lstroke = Instance.new("\085\073\083\116\114\111\107\101"); lstroke.Color = Color3.fromRGB(255, 215, 0); lstroke.Thickness = 2; lstroke.Parent = LoadingFrame

local LoadingText = Instance.new("\084\101\120\116\076\097\098\101\108")
LoadingText.Text = "\066\097\098\105\115\032\115\101\108\108\032\108\101\109\111\110\115"
LoadingText.Font = Enum.Font.SourceSansBold
LoadingText.TextColor3 = Color3.fromRGB(255, 215, 0)
LoadingText.TextSize = 24
LoadingText.Size = UDim2.new(1, 0, 0, 32)
LoadingText.Position = UDim2.new(0, 0, 0, 12)
LoadingText.BackgroundTransparency = 1
LoadingText.Parent = LoadingFrame

local LoadingSub = Instance.new("\084\101\120\116\076\097\098\101\108")
LoadingSub.Text = "\070\117\115\105\110\103\032\072\101\097\116\032\077\097\115\116\101\114\032\038\032\066\097\098\105\115\032\071\085\073\046\046\046"
LoadingSub.Font = Enum.Font.SourceSans
LoadingSub.TextColor3 = Color3.fromRGB(200, 200, 200)
LoadingSub.TextSize = 13
LoadingSub.Size = UDim2.new(1, 0, 0, 20)
LoadingSub.Position = UDim2.new(0, 0, 0, 50)
LoadingSub.BackgroundTransparency = 1
LoadingSub.Parent = LoadingFrame

-- ================== DATA & STATE ==================
local ScriptData = {
    PlayerTycoon = nil,
    AutoBuyUpgrades = false,
    AutoClick = false,
    AutoUpgradeStands = false,
    AutoCollectFruit = false,
    AutoCollectDrops = false,
    AutoCashVine = false,
    AutoPhoneOffer = false,
    AutoRebirth = false,
    AutoAscend = false,
    AutoEvolve = false,
    AutoPowerUpgrade = false,
    AutoOfflineCash = false,
    AutoTimeCash = false,
    AutoEarnerBoost = false,
    AutoMinigameRace = false,
    AutoMinigameTrade = false,
    AntiAFK = false,
    BoostFPS = false,
    SafeMode = false,
    FruitCycleDelay = 5,
    PhoneOfferResponse = "\065\099\099\101\112\116",
    SafeModeRadius = 45,
    SafeModeDelay = 1.5,
    Stats = {
        upgradesBought = 0, fruitCollected = 0, dropsCollected = 0, clicks = 0,
        phoneOffers = 0, standsUpgraded = 0, rebirths = 0, ascends = 0,
        evolves = 0, powerUpgrades = 0, racesWon = 0, tradesWon = 0, vineCollected = 0,
    },
}

-- ================== HEAT MASTER DETECTION SYSTEM ==================
local CASH_KW = {"\099\097\115\104", "\109\111\110\101\121", "\098\105\108\108", "\099\111\105\110", "\100\114\111\112", "\100\111\108\108\097\114", "\103\111\108\100", "\108\101\109\111\110"}
local MONEY_WORDS = {
    {"\099\101\110\116\105\108\108\105\111\110", 1e303}, {"\118\105\103\105\110\116\105\108\108\105\111\110", 1e63}, {"\110\111\110\105\108\108\105\111\110", 1e30},
    {"\115\101\112\116\105\108\108\105\111\110", 1e24}, {"\115\101\120\116\105\108\108\105\111\110", 1e21}, {"\113\117\105\110\116\105\108\108\105\111\110", 1e18},
    {"\113\117\097\100\114\105\108\108\105\111\110", 1e15}, {"\116\114\105\108\108\105\111\110", 1e12}, {"\098\105\108\108\105\111\110", 1e9},
    {"\109\105\108\108\105\111\110", 1e6}, {"\116\104\111\117\115\097\110\100", 1e3},
}
local MONEY_SHORT = {q = 1e15, t = 1e12, b = 1e9, m = 1e6, k = 1e3}

local function parseMoney(str)
    if not str or str == "" then return nil end
    local raw = str:gsub("\044", "\046"):gsub("\032", ""):lower():gsub("\091\036\093", "")
    local n, rest = raw:match("\040\091\037\100\037\046\093\043\041\040\046\042\041")
    n = tonumber(n)
    if not n or n <= 0 then return nil end
    rest = (rest or ""):gsub("\094\091\037\115\037\046\093\043", ""):gsub("\091\037\115\037\046\093\043\036", "")
    if rest == "" then return n < 1e6 and n or nil end
    for _, row in ipairs(MONEY_WORDS) do
        if rest == row[1] or rest:find(row[1], 1, true) then return n * row[2] end
    end
    for code, mult in pairs(MONEY_SHORT) do
        if #code > 1 and rest:find(code, 1, true) then return n * mult end
    end
    if #rest == 1 and MONEY_SHORT[rest] then return n * MONEY_SHORT[rest] end
    return n
end

local function hw(n, list)
    if not n then return false end
    n = n:lower()
    for _, w in ipairs(list) do
        if n:find(w, 1, true) then return true end
    end
    return false
end

local function FindTycoon()
    for _, v in ipairs(Workspace:GetChildren()) do
        if v:IsA("\070\111\108\100\101\114") and v.Name:match("\084\121\099\111\111\110\037\100") then
            local owner = v:FindFirstChild("\079\119\110\101\114")
            if owner and owner.Value == LocalPlayer then return v end
        end
    end
end

local function findRemotes()
    local found = {Sell = nil, Upgrades = {}}
    for _, child in ipairs(ReplicatedStorage:GetDescendants()) do
        if child:IsA("\082\101\109\111\116\101\069\118\101\110\116") or child:IsA("\082\101\109\111\116\101\070\117\110\099\116\105\111\110") then
            local name = child.Name:lower()
            if name:find("\115\101\108\108") or name:find("\099\097\115\104") or name:find("\100\101\112\111\115\105\116") then
                found.Sell = child
            elseif name:find("\117\112\103\114\097\100\101") or name:find("\098\117\121") or name:find("\112\117\114\099\104\097\115\101") then
                table.insert(found.Upgrades, child)
            end
        end
    end
    return found
end

local function scanCashAndTrees(tycoon)
    local cashParts, trees = {}, {}
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    if not h or not tycoon then return cashParts, trees end
    for _, o in ipairs(tycoon:GetDescendants()) do
        if o:IsA("\066\097\115\101\080\097\114\116") and hw(o.Name, CASH_KW) then
            local d = (h.Position - o.Position).Magnitude
            if d < 150 then table.insert(cashParts, {part = o, dist = d}) end
        end
        if o:IsA("\077\111\100\101\108") and o.Name == "\076\101\109\111\110\084\114\101\101" then
            local pp = o.PrimaryPart or o:FindFirstChildWhichIsA("\066\097\115\101\080\097\114\116")
            if pp then table.insert(trees, {tree = o, pos = pp.Position, dist = (h.Position - pp.Position).Magnitude}) end
        end
    end
    table.sort(cashParts, function(a,b) return a.dist < b.dist end)
    table.sort(trees, function(a,b) return a.dist < b.dist end)
    return cashParts, trees
end

local function collectFruitFromTree(tree)
    if not tree or not tree.Parent then return 0 end
    local collected = 0
    for _, p in ipairs(tree:GetDescendants()) do
        if p:IsA("\066\097\115\101\080\097\114\116") and p.Name == "\070\114\117\105\116" then
            p.CanCollide = false
            local cp = p:FindFirstChild("\067\108\105\099\107\080\097\114\116")
            if cp then
                local dt = cp:FindFirstChildOfClass("\067\108\105\099\107\068\101\116\101\099\116\111\114")
                if dt then pcall(function() fireclickdetector(dt) end); collected = collected + 1 end
            end
        end
    end
    return collected
end

local function scanNearbyPlayers(radius)
    local count = 0
    local pos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    if not pos then return 0 end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
            if hrp and (hrp.Position - pos.Position).Magnitude < radius then count = count + 1 end
        end
    end
    return count
end

-- ================== INITIALIZATION ==================
local startTime = tick()
repeat
    ScriptData.PlayerTycoon = FindTycoon()
    if tick() - startTime > 30 then LoadingSub.Text = "\069\114\114\111\114\058\032\084\121\099\111\111\110\032\110\111\116\032\102\111\117\110\100\046"; task.wait(3); LoadingScreen:Destroy(); return end
    task.wait(0.25)
until ScriptData.PlayerTycoon ~= nil

local remotes = findRemotes()
local sellRemote = remotes.Sell
local upgradeRemotes = remotes.Upgrades or {}

-- ================== CUSTOM GUI FRAMEWORK (IMPROVED) ==================
local BabisGUI = {}
BabisGUI.__index = BabisGUI

local function applyRoundedCorners(gui, radius)
    local corner = Instance.new("\085\073\067\111\114\110\101\114"); corner.CornerRadius = UDim.new(0, radius or 6); corner.Parent = gui
end

local function makeDraggable(gui, dragPart)
    local dragging, startPos, startPos2
    local function begin(inputPos) dragging = true; startPos = inputPos; startPos2 = gui.Position end
    local function move(inputPos)
        if not dragging then return end
        local delta = inputPos - startPos
        gui.Position = UDim2.new(startPos2.X.Scale, startPos2.X.Offset + delta.X, startPos2.Y.Scale, startPos2.Y.Offset + delta.Y)
    end
    local function stop() dragging = false end
    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then begin(input.Position) end
    end)
    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then move(input.Position) end
    end)
    dragPart.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then stop() end
    end)
end

function BabisGUI:CreateNotification(title, msg, duration)
    local notifFrame = Instance.new("\070\114\097\109\101")
    notifFrame.Size = UDim2.new(0, 300, 0, 65)
    notifFrame.Position = UDim2.new(1, -10, 0, 10)
    notifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    applyRoundedCorners(notifFrame, 10)
    local stroke = Instance.new("\085\073\083\116\114\111\107\101"); stroke.Color = Color3.fromRGB(255, 215, 0); stroke.Thickness = 2; stroke.Parent = notifFrame
    notifFrame.Parent = self.ScreenGui

    local titleLabel = Instance.new("\084\101\120\116\076\097\098\101\108")
    titleLabel.Text = title; titleLabel.Font = Enum.Font.SourceSansBold; titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    titleLabel.TextSize = 16; titleLabel.Position = UDim2.new(0, 12, 0, 6); titleLabel.Size = UDim2.new(1, -24, 0, 22); titleLabel.BackgroundTransparency = 1; titleLabel.Parent = notifFrame

    local msgLabel = Instance.new("\084\101\120\116\076\097\098\101\108")
    msgLabel.Text = msg; msgLabel.Font = Enum.Font.SourceSans; msgLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    msgLabel.TextSize = 13; msgLabel.Position = UDim2.new(0, 12, 0, 28); msgLabel.Size = UDim2.new(1, -24, 0, 30); msgLabel.BackgroundTransparency = 1; msgLabel.TextWrapped = true; msgLabel.Parent = notifFrame

    notifFrame:TweenPosition(UDim2.new(1, -310, 0, 10), "\079\117\116", "\081\117\097\100", 0.35, true)
    task.delay(duration or 3.5, function()
        notifFrame:TweenPosition(UDim2.new(1, -10, 0, 10), "\073\110", "\081\117\097\100", 0.35, true)
        task.delay(0.35, function() notifFrame:Destroy() end)
    end)
end

function BabisGUI.new(name)
    local self = setmetatable({}, BabisGUI)
    local gui = Instance.new("\083\099\114\101\101\110\071\117\105")
    gui.Name = "\066\097\098\105\115\083\101\108\108\076\101\109\111\110\115\071\085\073"; gui.Parent = LocalPlayer:WaitForChild("\080\108\097\121\101\114\071\117\105"); gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui = gui

    local mainFrame = Instance.new("\070\114\097\109\101")
    mainFrame.Name = "\077\097\105\110"
    mainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
    mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    applyRoundedCorners(mainFrame, 12)
    local ms = Instance.new("\085\073\083\116\114\111\107\101", mainFrame); ms.Color = Color3.fromRGB(255, 215, 0); ms.Thickness = 2.5
    mainFrame.Parent = gui
    self.MainFrame = mainFrame

    -- Title bar
    local titleBar = Instance.new("\070\114\097\109\101")
    titleBar.Size = UDim2.new(1, 0, 0, 40); titleBar.BackgroundColor3 = Color3.fromRGB(3, 3, 3); titleBar.BorderSizePixel = 0
    applyRoundedCorners(titleBar, 12); titleBar.Parent = mainFrame

    local titleText = Instance.new("\084\101\120\116\076\097\098\101\108")
    titleText.Text = name; titleText.Font = Enum.Font.SourceSansBold; titleText.TextColor3 = Color3.fromRGB(255, 215, 0); titleText.TextSize = 22
    titleText.Position = UDim2.new(0, 14, 0, 0); titleText.Size = UDim2.new(1, -60, 1, 0); titleText.BackgroundTransparency = 1; titleText.TextXAlignment = Enum.TextXAlignment.Left; titleText.Parent = titleBar

    local closeBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
    closeBtn.Text = "\10005"; closeBtn.Font = Enum.Font.SourceSansBold; closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255); closeBtn.TextSize = 20
    closeBtn.Size = UDim2.new(0, 40, 0, 40); closeBtn.Position = UDim2.new(1, -40, 0, 0); closeBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40); closeBtn.BorderSizePixel = 0
    applyRoundedCorners(closeBtn, 10); closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function() self:Destroy() end)

    -- Persistent toggle button (B) – always visible, toggles main frame
    local toggleButton = Instance.new("\084\101\120\116\066\117\116\116\111\110")
    toggleButton.Name = "\066\097\098\105\115\084\111\103\103\108\101"
    toggleButton.Size = UDim2.new(0, 56, 0, 56)
    toggleButton.Position = UDim2.new(1, -66, 1, -66)
    toggleButton.BackgroundTransparency = 1                -- no fill, just the yellow border and the B
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "\066"
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.TextColor3 = Color3.fromRGB(255, 215, 0)
    toggleButton.TextSize = 34
    applyRoundedCorners(toggleButton, 14)
    local bStroke = Instance.new("\085\073\083\116\114\111\107\101"); bStroke.Color = Color3.fromRGB(255, 215, 0); bStroke.Thickness = 3; bStroke.Parent = toggleButton
    toggleButton.Parent = gui
    toggleButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    makeDraggable(toggleButton, toggleButton)
    self.ToggleButton = toggleButton

    makeDraggable(mainFrame, titleBar)

    -- Tab bar
    local tabBar = Instance.new("\070\114\097\109\101")
    tabBar.Size = UDim2.new(1, 0, 0, 36); tabBar.Position = UDim2.new(0, 0, 0, 40); tabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); tabBar.BorderSizePixel = 0; tabBar.Parent = mainFrame

    local contentFrame = Instance.new("\070\114\097\109\101")
    contentFrame.Size = UDim2.new(1, -4, 1, -80); contentFrame.Position = UDim2.new(0, 2, 0, 80); contentFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10); contentFrame.BorderSizePixel = 0
    applyRoundedCorners(contentFrame, 10); contentFrame.Parent = mainFrame

    local scroll = Instance.new("\083\099\114\111\108\108\105\110\103\070\114\097\109\101")
    scroll.Size = UDim2.new(1, 0, 1, 0); scroll.CanvasSize = UDim2.new(0, 0, 0, 0); scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 8; scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0); scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.BorderSizePixel = 0; scroll.Parent = contentFrame

    -- Resize handle
    local resizeHandle = Instance.new("\084\101\120\116\066\117\116\116\111\110")
    resizeHandle.Size = UDim2.new(0, 20, 0, 20); resizeHandle.Position = UDim2.new(1, -20, 1, -20); resizeHandle.BackgroundColor3 = Color3.fromRGB(255, 215, 0); resizeHandle.BorderSizePixel = 0
    resizeHandle.TextColor3 = Color3.fromRGB(0, 0, 0); resizeHandle.Font = Enum.Font.SourceSansBold; resizeHandle.TextSize = 16; resizeHandle.Text = "\10529"
    applyRoundedCorners(resizeHandle, 6); resizeHandle.Parent = mainFrame

    local resizing = false
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = true end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = mainFrame.AbsolutePosition
            local newWidth = math.max(320, mousePos.X - framePos.X)
            local newHeight = math.max(240, mousePos.Y - framePos.Y)
            mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
            mainFrame.Position = UDim2.new(0, framePos.X, 0, framePos.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then resizing = false end
    end)

    self.TabBar = tabBar; self.Scroll = scroll; self.Tabs = {}; self.ActiveTab = nil
    return self
end

function BabisGUI:CreateTab(name)
    local tabFrame = Instance.new("\070\114\097\109\101")
    tabFrame.Name = name.."\084\097\098"; tabFrame.Size = UDim2.new(1, 0, 1, 0); tabFrame.BackgroundTransparency = 1; tabFrame.Visible = false; tabFrame.Parent = self.Scroll

    local tabButton = Instance.new("\084\101\120\116\066\117\116\116\111\110")
    tabButton.Text = name; tabButton.Font = Enum.Font.SourceSansBold; tabButton.TextColor3 = Color3.fromRGB(180, 180, 180); tabButton.TextSize = 15
    tabButton.Size = UDim2.new(0, 105, 1, -3); tabButton.Position = UDim2.new(0, #self.Tabs * 105 + 3, 0, 1)
    tabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25); tabButton.BorderSizePixel = 0; applyRoundedCorners(tabButton, 8); tabButton.Parent = self.TabBar

    local tabData = {name=name, button=tabButton, frame=tabFrame}
    table.insert(self.Tabs, tabData)

    local function setActive(index)
        for i,t in ipairs(self.Tabs) do
            t.button.BackgroundColor3 = (i==index) and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(25, 25, 25)
            t.button.TextColor3 = (i==index) and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(180, 180, 180)
            t.frame.Visible = (i==index)
        end
        self.ActiveTab = index
    end
    tabButton.MouseButton1Click:Connect(function()
        local idx = table.find(self.Tabs, tabData)
        if idx then setActive(idx) end
    end)
    if #self.Tabs == 1 then setActive(1) end

    local tabMethods = {
        Scroll = self.Scroll, TabFrame = tabFrame, SectionY = 0,
        Notify = function(title, msg, dur) self:CreateNotification(title, msg, dur) end,
    }

    function tabMethods:CreateSection(name)
        local sectionLabel = Instance.new("\084\101\120\116\076\097\098\101\108")
        sectionLabel.Text = name; sectionLabel.Font = Enum.Font.SourceSansBold; sectionLabel.TextColor3 = Color3.fromRGB(255, 215, 0); sectionLabel.TextSize = 18
        sectionLabel.Position = UDim2.new(0, 14, 0, self.SectionY); sectionLabel.Size = UDim2.new(1, -28, 0, 28); sectionLabel.BackgroundTransparency = 1; sectionLabel.Parent = tabFrame
        self.SectionY = self.SectionY + 34; self.Scroll.CanvasSize = UDim2.new(0, 0, 0, self.SectionY + 50) -- extra padding so everything is reachable
    end

    function tabMethods:CreateDivider()
        local divider = Instance.new("\070\114\097\109\101")
        divider.Position = UDim2.new(0, 14, 0, self.SectionY); divider.Size = UDim2.new(1, -28, 0, 2); divider.BackgroundColor3 = Color3.fromRGB(80, 80, 80); divider.BorderSizePixel = 0; divider.Parent = tabFrame
        self.SectionY = self.SectionY + 12; self.Scroll.CanvasSize = UDim2.new(0, 0, 0, self.SectionY + 50)
    end

    function tabMethods:CreateToggle(options)
        local frame = Instance.new("\070\114\097\109\101"); frame.Position = UDim2.new(0, 14, 0, self.SectionY); frame.Size = UDim2.new(1, -28, 0, 36); frame.BackgroundTransparency = 1; frame.Parent = tabFrame
        local label = Instance.new("\084\101\120\116\076\097\098\101\108"); label.Text = options.Name or "\084\111\103\103\108\101"; label.Font = Enum.Font.SourceSans; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 16
        label.Size = UDim2.new(0, 240, 1, 0); label.BackgroundTransparency = 1; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = frame
        local btn = Instance.new("\084\101\120\116\066\117\116\116\111\110"); btn.Size = UDim2.new(0, 50, 0, 28); btn.Position = UDim2.new(1, -54, 0.5, -14)
        btn.BackgroundColor3 = (options.CurrentValue or false) and Color3.fromRGB(0, 220, 110) or Color3.fromRGB(220, 40, 40); btn.BorderSizePixel = 0
        btn.Text = (options.CurrentValue and "\079\078" or "\079\070\070"); btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.TextSize = 14; applyRoundedCorners(btn, 8); btn.Parent = frame
        local state = options.CurrentValue or false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 220, 110) or Color3.fromRGB(220, 40, 40)
            btn.Text = state and "\079\078" or "\079\070\070"
            if options.Callback then options.Callback(state) end
        end)
        self.SectionY = self.SectionY + 40; self.Scroll.CanvasSize = UDim2.new(0, 0, 0, self.SectionY + 50)
    end

    function tabMethods:CreateButton(options)
        local btn = Instance.new("\084\101\120\116\066\117\116\116\111\110"); btn.Text = options.Name or "\066\117\116\116\111\110"
        btn.Size = UDim2.new(1, -28, 0, 36); btn.Position = UDim2.new(0, 14, 0, self.SectionY)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); btn.BorderSizePixel = 0; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSansBold; btn.TextSize = 16; applyRoundedCorners(btn, 10)
        local stroke = Instance.new("\085\073\083\116\114\111\107\101"); stroke.Color = Color3.fromRGB(255, 215, 0); stroke.Thickness = 1.5; stroke.Parent = btn
        btn.Parent = tabFrame; btn.MouseButton1Click:Connect(function() if options.Callback then options.Callback() end end)
        self.SectionY = self.SectionY + 44; self.Scroll.CanvasSize = UDim2.new(0, 0, 0, self.SectionY + 50)
        return btn
    end

    function tabMethods:CreateSlider(options)
        local name = options.Name or "\083\108\105\100\101\114"; local minVal = options.Min or 0; local maxVal = options.Max or 100
        local default = options.Default or minVal; local callback = options.Callback; local step = options.Step or 1

        local sliderFrame = Instance.new("\070\114\097\109\101"); sliderFrame.Position = UDim2.new(0, 14, 0, self.SectionY); sliderFrame.Size = UDim2.new(1, -28, 0, 65); sliderFrame.BackgroundTransparency = 1; sliderFrame.Parent = tabFrame

        local label = Instance.new("\084\101\120\116\076\097\098\101\108"); label.Text = name; label.Font = Enum.Font.SourceSans; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 15
        label.Size = UDim2.new(1, -70, 0, 22); label.BackgroundTransparency = 1; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = sliderFrame

        local valueLabel = Instance.new("\084\101\120\116\076\097\098\101\108"); valueLabel.Text = tostring(default); valueLabel.Font = Enum.Font.SourceSansBold; valueLabel.TextColor3 = Color3.fromRGB(255, 215, 0); valueLabel.TextSize = 15
        valueLabel.Size = UDim2.new(0, 70, 0, 22); valueLabel.Position = UDim2.new(1, -70, 0, 0); valueLabel.BackgroundTransparency = 1; valueLabel.TextXAlignment = Enum.TextXAlignment.Right; valueLabel.Parent = sliderFrame

        local sliderBar = Instance.new("\070\114\097\109\101"); sliderBar.Size = UDim2.new(1, 0, 0, 10); sliderBar.Position = UDim2.new(0, 0, 0, 34)
        sliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35); sliderBar.BorderSizePixel = 0; applyRoundedCorners(sliderBar, 5); sliderBar.Parent = sliderFrame

        local fill = Instance.new("\070\114\097\109\101"); fill.Size = UDim2.new((default - minVal) / (maxVal - minVal), 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(255, 215, 0); fill.BorderSizePixel = 0; applyRoundedCorners(fill, 5); fill.Parent = sliderBar

        local knob = Instance.new("\084\101\120\116\066\117\116\116\111\110"); knob.Size = UDim2.new(0, 22, 0, 22); knob.Position = UDim2.new((default - minVal) / (maxVal - minVal), -11, 0.5, -11)
        knob.BackgroundColor3 = Color3.fromRGB(255, 215, 0); knob.BorderSizePixel = 0; knob.Text = ""; applyRoundedCorners(knob, 11); knob.Parent = sliderBar

        local dragging = false
        local function updateKnob(inputX)
            local barAbs = sliderBar.AbsolutePosition.X; local barWidth = sliderBar.AbsoluteSize.X
            local relX = math.clamp((inputX - barAbs) / barWidth, 0, 1)
            local rawVal = minVal + relX * (maxVal - minVal)
            local stepped = math.floor(rawVal / step + 0.5) * step; stepped = math.clamp(stepped, minVal, maxVal)
            local finalRel = (stepped - minVal) / (maxVal - minVal)
            knob.Position = UDim2.new(finalRel, -11, 0.5, -11); fill.Size = UDim2.new(finalRel, 0, 1, 0)
            valueLabel.Text = tostring(stepped)
            if callback then callback(stepped) end
        end

        knob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateKnob(input.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)

        self.SectionY = self.SectionY + 70; self.Scroll.CanvasSize = UDim2.new(0, 0, 0, self.SectionY + 50)
    end

    function tabMethods:CreateDropdown(options)
        local dropdownFrame = Instance.new("\070\114\097\109\101"); dropdownFrame.Position = UDim2.new(0, 14, 0, self.SectionY); dropdownFrame.Size = UDim2.new(1, -28, 0, 36); dropdownFrame.BackgroundTransparency = 1; dropdownFrame.Parent = tabFrame
        local label = Instance.new("\084\101\120\116\076\097\098\101\108"); label.Text = options.Name or "\068\114\111\112\100\111\119\110"; label.Font = Enum.Font.SourceSans; label.TextColor3 = Color3.fromRGB(255, 255, 255); label.TextSize = 16
        label.Size = UDim2.new(0, 190, 1, 0); label.BackgroundTransparency = 1; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = dropdownFrame
        local mainBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110"); mainBtn.Size = UDim2.new(0, 220, 0, 30); mainBtn.Position = UDim2.new(0, 195, 0, 3)
        mainBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25); mainBtn.BorderSizePixel = 0; mainBtn.TextColor3 = Color3.fromRGB(255, 255, 255); mainBtn.Font = Enum.Font.SourceSans; mainBtn.TextSize = 15
        mainBtn.Text = options.Options[options.Default or 1] or "\083\101\108\101\099\116"
        applyRoundedCorners(mainBtn, 8); mainBtn.Parent = dropdownFrame
        local listFrame = Instance.new("\070\114\097\109\101"); listFrame.Size = UDim2.new(0, 220, 0, 0); listFrame.Position = UDim2.new(0, 195, 0, 36)
        listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20); listFrame.BorderSizePixel = 0; listFrame.ClipsDescendants = true; applyRoundedCorners(listFrame, 8); listFrame.Visible = false; listFrame.Parent = dropdownFrame
        local itemHeight = 28
        for i, item in ipairs(options.Options) do
            local itemBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110"); itemBtn.Text = item; itemBtn.Size = UDim2.new(1, 0, 0, itemHeight); itemBtn.Position = UDim2.new(0, 0, 0, (i-1)*itemHeight)
            itemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); itemBtn.BorderSizePixel = 0; itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255); itemBtn.Font = Enum.Font.SourceSans; itemBtn.TextSize = 14; itemBtn.Parent = listFrame
            itemBtn.MouseButton1Click:Connect(function()
                mainBtn.Text = item; listFrame.Visible = false
                if options.Callback then options.Callback(item) end
            end)
        end
        local expanded = false
        mainBtn.MouseButton1Click:Connect(function()
            expanded = not expanded; listFrame.Visible = expanded
            if expanded then listFrame.Size = UDim2.new(0, 220, 0, #options.Options * itemHeight) else listFrame.Size = UDim2.new(0, 220, 0, 0) end
        end)
        self.SectionY = self.SectionY + 40; self.Scroll.CanvasSize = UDim2.new(0, 0, 0, self.SectionY + 50)
        return mainBtn
    end

    return tabMethods
end

function BabisGUI:Destroy() if self.ScreenGui then self.ScreenGui:Destroy() end end

-- ================== CREATE GUI ==================
local BabisWindow = BabisGUI.new("\066\097\098\105\115\032\115\101\108\108\032\108\101\109\111\110\115")
local FarmTab = BabisWindow:CreateTab("\070\097\114\109")
local BonusTab = BabisWindow:CreateTab("\066\111\110\117\115")
local StatsTab = BabisWindow:CreateTab("\083\116\097\116\115")
local SettingsTab = BabisWindow:CreateTab("\083\101\116\116\105\110\103\115")

-- ================== FARM TAB ==================
FarmTab:CreateSection("\067\111\114\101\032\065\117\116\111\109\097\116\105\111\110")
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\066\117\121\032\085\112\103\114\097\100\101\115", Callback = function(v) ScriptData.AutoBuyUpgrades = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\067\108\105\099\107\032\073\110\099\111\109\101", Callback = function(v) ScriptData.AutoClick = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\085\112\103\114\097\100\101\032\083\116\097\110\100\115", Callback = function(v) ScriptData.AutoUpgradeStands = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\067\111\108\108\101\099\116\032\070\114\117\105\116", Callback = function(v) ScriptData.AutoCollectFruit = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\067\111\108\108\101\099\116\032\068\114\111\112\115", Callback = function(v) ScriptData.AutoCollectDrops = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\067\097\115\104\032\086\105\110\101", Callback = function(v) ScriptData.AutoCashVine = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\080\104\111\110\101\032\079\102\102\101\114", Callback = function(v) ScriptData.AutoPhoneOffer = v end })
FarmTab:CreateSection("\080\114\101\115\116\105\103\101")
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\082\101\098\105\114\116\104", Callback = function(v) ScriptData.AutoRebirth = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\065\115\099\101\110\100", Callback = function(v) ScriptData.AutoAscend = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\069\118\111\108\118\101", Callback = function(v) ScriptData.AutoEvolve = v end })
FarmTab:CreateToggle({ Name = "\065\117\116\111\032\080\111\119\101\114\032\085\112\103\114\097\100\101", Callback = function(v) ScriptData.AutoPowerUpgrade = v end })
FarmTab:CreateSection("\083\097\102\101\116\121")
FarmTab:CreateToggle({ Name = "\083\097\102\101\032\077\111\100\101\032\040\080\097\117\115\101\032\110\101\097\114\032\112\108\097\121\101\114\115\041", Callback = function(v) ScriptData.SafeMode = v end })

-- ================== BONUS TAB ==================
BonusTab:CreateSection("\069\120\116\114\097\032\066\111\111\115\116\115")
BonusTab:CreateToggle({ Name = "\065\117\116\111\032\068\111\117\098\108\101\032\079\102\102\108\105\110\101\032\067\097\115\104", Callback = function(v) ScriptData.AutoOfflineCash = v end })
BonusTab:CreateToggle({ Name = "\065\117\116\111\032\085\115\101\032\084\105\109\101\032\067\097\115\104", Callback = function(v) ScriptData.AutoTimeCash = v end })
BonusTab:CreateToggle({ Name = "\065\117\116\111\032\085\115\101\032\069\097\114\110\101\114\032\066\111\111\115\116", Callback = function(v) ScriptData.AutoEarnerBoost = v end })
BonusTab:CreateSection("\077\105\110\105\103\097\109\101\115")
BonusTab:CreateToggle({ Name = "\065\117\116\111\032\077\105\110\105\103\097\109\101\032\082\097\099\101", Callback = function(v) ScriptData.AutoMinigameRace = v end })
BonusTab:CreateToggle({ Name = "\065\117\116\111\032\077\105\110\105\103\097\109\101\032\084\114\097\100\101", Callback = function(v) ScriptData.AutoMinigameTrade = v end })

-- ================== STATS TAB ==================
StatsTab:CreateSection("\076\105\118\101\032\083\116\097\116\105\115\116\105\099\115")
local statUpg = StatsTab:CreateButton({ Name = "\085\112\103\114\097\100\101\115\032\066\111\117\103\104\116\058\032\048" })
local statClick = StatsTab:CreateButton({ Name = "\073\110\099\111\109\101\032\067\108\105\099\107\115\058\032\048" })
local statStands = StatsTab:CreateButton({ Name = "\083\116\097\110\100\115\032\085\112\103\114\097\100\101\100\058\032\048" })
local statFruit = StatsTab:CreateButton({ Name = "\070\114\117\105\116\032\067\111\108\108\101\099\116\101\100\058\032\048" })
local statDrop = StatsTab:CreateButton({ Name = "\068\114\111\112\115\032\067\111\108\108\101\099\116\101\100\058\032\048" })
local statPhone = StatsTab:CreateButton({ Name = "\080\104\111\110\101\032\079\102\102\101\114\115\058\032\048" })
local statVine = StatsTab:CreateButton({ Name = "\086\105\110\101\032\067\111\108\108\101\099\116\101\100\058\032\048" })
local statCash = StatsTab:CreateButton({ Name = "\067\097\115\104\058\032\048" })
local statReb = StatsTab:CreateButton({ Name = "\082\101\098\105\114\116\104\115\058\032\048" })
local statAsc = StatsTab:CreateButton({ Name = "\065\115\099\101\110\100\115\058\032\048" })
local statEvo = StatsTab:CreateButton({ Name = "\069\118\111\108\118\101\115\058\032\048" })
local statPower = StatsTab:CreateButton({ Name = "\080\111\119\101\114\032\085\112\103\114\097\100\101\115\058\032\048" })
local statRaces = StatsTab:CreateButton({ Name = "\082\097\099\101\115\032\087\111\110\058\032\048" })
local statTrades = StatsTab:CreateButton({ Name = "\084\114\097\100\101\115\032\087\111\110\058\032\048" })

task.spawn(function()
    while true do task.wait(1)
        local s = ScriptData.Stats
        pcall(function() statUpg.Text = "\085\112\103\114\097\100\101\115\032\066\111\117\103\104\116\058\032"..s.upgradesBought end)
        pcall(function() statClick.Text = "\073\110\099\111\109\101\032\067\108\105\099\107\115\058\032"..s.clicks end)
        pcall(function() statStands.Text = "\083\116\097\110\100\115\032\085\112\103\114\097\100\101\100\058\032"..s.standsUpgraded end)
        pcall(function() statFruit.Text = "\070\114\117\105\116\032\067\111\108\108\101\099\116\101\100\058\032"..s.fruitCollected end)
        pcall(function() statDrop.Text = "\068\114\111\112\115\032\067\111\108\108\101\099\116\101\100\058\032"..s.dropsCollected end)
        pcall(function() statPhone.Text = "\080\104\111\110\101\032\079\102\102\101\114\115\058\032"..s.phoneOffers end)
        pcall(function() statVine.Text = "\086\105\110\101\032\067\111\108\108\101\099\116\101\100\058\032"..s.vineCollected end)
        pcall(function() statCash.Text = "\067\097\115\104\058\032"..math.floor(getCash()) end)
        pcall(function() statReb.Text = "\082\101\098\105\114\116\104\115\058\032"..s.rebirths end)
        pcall(function() statAsc.Text = "\065\115\099\101\110\100\115\058\032"..s.ascends end)
        pcall(function() statEvo.Text = "\069\118\111\108\118\101\115\058\032"..s.evolves end)
        pcall(function() statPower.Text = "\080\111\119\101\114\032\085\112\103\114\097\100\101\115\058\032"..s.powerUpgrades end)
        pcall(function() statRaces.Text = "\082\097\099\101\115\032\087\111\110\058\032"..s.racesWon end)
        pcall(function() statTrades.Text = "\084\114\097\100\101\115\032\087\111\110\058\032"..s.tradesWon end)
    end
end)

-- ================== SETTINGS TAB ==================
SettingsTab:CreateSection("\067\111\110\102\105\103\117\114\097\116\105\111\110")
SettingsTab:CreateSlider({ Name = "\070\114\117\105\116\032\083\119\101\101\112\032\068\101\108\097\121\032\040\115\101\099\041", Min = 2, Max = 30, Default = ScriptData.FruitCycleDelay, Step = 1, Callback = function(v) ScriptData.FruitCycleDelay = v end })
SettingsTab:CreateSlider({ Name = "\083\097\102\101\032\077\111\100\101\032\082\097\100\105\117\115", Min = 20, Max = 100, Default = ScriptData.SafeModeRadius, Step = 5, Callback = function(v) ScriptData.SafeModeRadius = v end })
SettingsTab:CreateDropdown({ Name = "\080\104\111\110\101\032\079\102\102\101\114\032\082\101\115\112\111\110\115\101", Options = {"\065\099\099\101\112\116","\082\097\105\115\101","\082\101\106\101\099\116"}, Default = 1, Callback = function(v) ScriptData.PhoneOfferResponse = v end })
SettingsTab:CreateToggle({ Name = "\065\110\116\105\045\065\070\075", Callback = function(v) ScriptData.AntiAFK = v end })
SettingsTab:CreateToggle({ Name = "\066\111\111\115\116\032\070\080\083", Callback = function(v) ScriptData.BoostFPS = v; if v then enableFPSBoost() else disableFPSBoost() end end })

-- ================== CASH GETTER ==================
function getCash()
    local ls = LocalPlayer:FindFirstChild("\108\101\097\100\101\114\115\116\097\116\115")
    if not ls then return 0 end
    for _, v in ipairs(ls:GetChildren()) do
        if (v:IsA("\078\117\109\098\101\114\086\097\108\117\101") or v:IsA("\073\110\116\086\097\108\117\101")) then
            local n = v.Name:lower()
            if n:find("\099\097\115\104") or n:find("\109\111\110\101\121") or n:find("\108\101\109\111\110") then return v.Value end
        end
    end
    return 0
end

-- ================== ALL AUTOMATION LOOPS ==================

-- Auto Buy Upgrades (Heat Master style)
local buyLock = {}
task.spawn(function()
    while not ScriptData.PlayerTycoon do task.wait(0.5) end
    RunService.Heartbeat:Connect(function()
        if not ScriptData.AutoBuyUpgrades then return end
        if ScriptData.SafeMode and scanNearbyPlayers(ScriptData.SafeModeRadius) > 0 then return end
        local t = ScriptData.PlayerTycoon
        if not t then return end
        local purchases = t:FindFirstChild("\080\117\114\099\104\097\115\101\115")
        if not purchases then return end
        for _, obj in ipairs(purchases:GetDescendants()) do
            if not ScriptData.AutoBuyUpgrades then break end
            if not (obj:IsA("\082\101\109\111\116\101\070\117\110\099\116\105\111\110") and obj.Name == "\080\117\114\099\104\097\115\101") then continue end
            local btn = obj.Parent
            if not btn or buyLock[obj] or btn:GetAttribute("\080\117\114\099\104\097\115\101\100") == true or btn:GetAttribute("\069\110\097\098\108\101\100") == false or btn:GetAttribute("\083\104\111\119\110") == false then continue end
            buyLock[obj] = true
            task.spawn(function()
                pcall(function() obj:InvokeServer(false) end)
                ScriptData.Stats.upgradesBought += 1
                task.wait(1)
                buyLock[obj] = nil
            end)
        end
    end)
end)

-- Auto Click Income (Wake)
local INCOME_STREAMS = {"\076\101\109\111\110\068\097\115\104","\076\101\109\111\110\068\101\112\111\116","\076\101\109\111\110\076\097\098\115","\076\101\109\111\110\084\114\097\100\105\110\103","\076\101\109\111\110\082\101\112\117\098\108\105\099","\076\101\109\111\110\082\111\098\111\116\105\099\115","\076\101\109\111\110\083\116\097\110\100","\076\101\109\111\110\088"}
local cachedWakeRF = nil
local function buildWakeRFCache()
    cachedWakeRF = nil
    for _, v in ipairs(ScriptData.PlayerTycoon and ScriptData.PlayerTycoon.Remotes:GetChildren() or {}) do
        if v.Name == "\087\097\107\101\073\110\099\111\109\101\083\116\114\101\097\109" and v:IsA("\082\101\109\111\116\101\070\117\110\099\116\105\111\110") then cachedWakeRF = v; break end
    end
end
buildWakeRFCache()
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if not ScriptData.AutoClick then return end
        if ScriptData.SafeMode and scanNearbyPlayers(ScriptData.SafeModeRadius) > 0 then return end
        if not cachedWakeRF then buildWakeRFCache() return end
        for _, s in ipairs(INCOME_STREAMS) do
            task.spawn(function() pcall(function() cachedWakeRF:InvokeServer(s) end); ScriptData.Stats.clicks += 1 end)
        end
    end)
end)

-- Auto Upgrade Stands (Heat Master style)
local cachedStandRFs = {}
local function buildStandRFCache()
    cachedStandRFs = {}
    local t = ScriptData.PlayerTycoon
    if not t then return end
    local purchases = t:FindFirstChild("\080\117\114\099\104\097\115\101\115")
    if not purchases then return end
    for _, standName in ipairs({"\076\101\109\111\110\068\097\115\104","\076\101\109\111\110\032\068\101\112\111\116","\076\101\109\111\110\032\076\097\098\115","\076\101\109\111\110\032\083\116\097\110\100","\076\101\109\111\110\032\084\114\097\100\105\110\103","\076\101\109\111\110\032\082\101\112\117\098\108\105\099","\076\101\109\111\110\032\082\111\098\111\116\105\099\115","\076\101\109\111\110\088"}) do
        local standFolder = purchases:FindFirstChild(standName)
        if standFolder then
            local standModel = standFolder:FindFirstChild(standName)
            if standModel then
                for _, obj in ipairs(standModel:GetDescendants()) do
                    if obj:IsA("\082\101\109\111\116\101\070\117\110\099\116\105\111\110") and obj.Name == "\085\112\103\114\097\100\101" then
                        cachedStandRFs[standName] = obj; break
                    end
                end
            end
        end
    end
end
buildStandRFCache()
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if not ScriptData.AutoUpgradeStands then return end
        if ScriptData.SafeMode and scanNearbyPlayers(ScriptData.SafeModeRadius) > 0 then return end
        if not next(cachedStandRFs) then buildStandRFCache() return end
        for _, rf in pairs(cachedStandRFs) do
            task.spawn(function()
                local ok = pcall(function() rf:InvokeServer(5) end)
                if ok then ScriptData.Stats.standsUpgraded += 1 end
            end)
        end
    end)
end)

-- Auto Collect Fruit & Drops (HEAT MASTER INTEGRATION - WORKING)
task.spawn(function()
    while true do
        task.wait(ScriptData.FruitCycleDelay)
        if not ScriptData.AutoCollectFruit and not ScriptData.AutoCollectDrops then continue end
        if ScriptData.SafeMode and scanNearbyPlayers(ScriptData.SafeModeRadius) > 0 then continue end

        local tycoon = ScriptData.PlayerTycoon or FindTycoon()
        if not tycoon then continue end

        local cashParts, trees = scanCashAndTrees(tycoon)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
        if not h then continue end
        local saved = h.CFrame

        -- Collect cash drops (physical proximity)
        if ScriptData.AutoCollectDrops and #cashParts > 0 then
            for _, entry in ipairs(cashParts) do
                if not ScriptData.AutoCollectDrops then break end
                if entry.dist > 8 then
                    pcall(function() h.CFrame = CFrame.new(entry.part.Position + Vector3.new(0, 3, 0)) end)
                    task.wait(0.05)
                end
                pcall(function()
                    firetouchinterest(h, entry.part, 0)
                    firetouchinterest(h, entry.part, 1)
                end)
                ScriptData.Stats.dropsCollected += 1
                task.wait(0.1)
            end
        end

        -- Collect fruits from trees
        if ScriptData.AutoCollectFruit and #trees > 0 then
            for _, entry in ipairs(trees) do
                if not ScriptData.AutoCollectFruit then break end
                if entry.dist > 8 then
                    pcall(function() h.CFrame = CFrame.new(entry.pos + Vector3.new(0, 3, 0)) end)
                    task.wait(0.05)
                end
                local collected = collectFruitFromTree(entry.tree)
                ScriptData.Stats.fruitCollected += collected
                task.wait(0.1)
            end
        end

        pcall(function() h.CFrame = saved end)
    end
end)

-- Remote-based CashDropService (HEAT MASTER)
task.spawn(function()
    local core = ReplicatedStorage:WaitForChild("\067\111\114\101", 10)
    if core then
        local signal = core:FindFirstChild("\082\101\109\111\116\101\083\105\103\110\097\108")
        local request = core:FindFirstChild("\082\101\109\111\116\101\082\101\113\117\101\115\116")
        if signal and request then
            local newDrop = signal:FindFirstChild("\067\097\115\104\068\114\111\112\083\101\114\118\105\099\101\046\078\101\119")
            local redeemDrop = request:FindFirstChild("\067\097\115\104\068\114\111\112\083\101\114\118\105\099\101\046\082\101\100\101\101\109")
            if newDrop and redeemDrop then
                newDrop.OnClientEvent:Connect(function(id)
                    if not ScriptData.AutoCollectDrops then return end
                    if id == nil then return end
                    task.spawn(function()
                        local ok = pcall(function() return redeemDrop:InvokeServer(id) end)
                        if ok then ScriptData.Stats.dropsCollected += 1 end
                    end)
                end)
            end
        end
    end
end)

-- Auto Cash Vine
task.spawn(function()
    while true do
        task.wait(30)
        if not ScriptData.AutoCashVine then continue end
        local map = Workspace:FindFirstChild("\077\097\112")
        if not map then continue end
        local sewer = map:FindFirstChild("\083\101\119\101\114")
        if not sewer then continue end
        local cvFolder = sewer:FindFirstChild("\067\097\115\104\086\105\110\101")
        if not cvFolder then continue end
        local cvModel = cvFolder:FindFirstChild("\067\097\115\104\086\105\110\101")
        if not cvModel then continue end
        local useRF = cvModel:FindFirstChild("\085\115\101")
        if not useRF or not useRF:IsA("\082\101\109\111\116\101\070\117\110\099\116\105\111\110") then continue end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
        if not root then continue end
        local saved = root.CFrame
        local targetPart = cvModel:FindFirstChildOfClass("\066\097\115\101\080\097\114\116") or cvFolder:FindFirstChildOfClass("\066\097\115\101\080\097\114\116")
        if targetPart then
            pcall(function() root.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, 3, 0)) end)
            task.wait(0.2)
        end
        local ok = pcall(function() useRF:InvokeServer() end)
        if ok then ScriptData.Stats.vineCollected += 1 end
        task.wait(0.2)
        pcall(function() root.CFrame = saved end)
    end
end)

-- Phone Offer
local phoneEvent, phoneConn = nil, nil
local activeOffer, offerHandled = false, false
local function respondToOffer()
    if not phoneEvent then return end
    offerHandled = true
    pcall(function() phoneEvent:FireServer(ScriptData.PhoneOfferResponse) end)
    ScriptData.Stats.phoneOffers += 1
end
local function setupPhoneOffer()
    local t = ScriptData.PlayerTycoon
    if not t then return end
    local remotes = t:FindFirstChild("\082\101\109\111\116\101\115")
    if not remotes then return end
    local ev = remotes:FindFirstChild("\080\104\111\110\101\079\102\102\101\114")
    if not ev then return end
    phoneEvent = ev
    if phoneConn then phoneConn:Disconnect() end
    phoneConn = phoneEvent.OnClientEvent:Connect(function(val)
        if type(val) == "\110\117\109\098\101\114" then
            activeOffer = true; offerHandled = false
            if ScriptData.AutoPhoneOffer then respondToOffer() end
        else
            activeOffer = false; offerHandled = false
        end
    end)
end
setupPhoneOffer()
task.spawn(function()
    while true do
        task.wait(0.5)
        if ScriptData.AutoPhoneOffer and activeOffer and not offerHandled then respondToOffer() end
    end
end)

-- Prestige loops (Rebirth, Ascend, Evolve, PowerUpgrade) - unchanged
local rebirthCooldown = false
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if not ScriptData.AutoRebirth or rebirthCooldown then return end
        local r = ScriptData.PlayerTycoon and ScriptData.PlayerTycoon.Remotes:FindFirstChild("\082\101\098\105\114\116\104")
        if not r then return end
        task.spawn(function()
            rebirthCooldown = true
            local ok = pcall(function() r:InvokeServer() end)
            if ok then ScriptData.Stats.rebirths += 1 end
            task.wait(5)
            rebirthCooldown = false
        end)
    end)
end)

task.spawn(function()
    while true do
        task.wait(8)
        if not ScriptData.AutoAscend then continue end
        local r = ScriptData.PlayerTycoon and ScriptData.PlayerTycoon.Remotes:FindFirstChild("\065\115\099\101\110\100")
        if r then pcall(function() r:InvokeServer() end); ScriptData.Stats.ascends += 1 end
    end
end)

task.spawn(function()
    while true do
        task.wait(8)
        if not ScriptData.AutoEvolve then continue end
        local r = ScriptData.PlayerTycoon and ScriptData.PlayerTycoon.Remotes:FindFirstChild("\069\118\111\108\118\101")
        if r then pcall(function() r:InvokeServer() end); ScriptData.Stats.evolves += 1 end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        if not ScriptData.AutoPowerUpgrade then continue end
        local r = ScriptData.PlayerTycoon and ScriptData.PlayerTycoon.Remotes:FindFirstChild("\085\112\103\114\097\100\101\080\111\119\101\114\076\101\118\101\108")
        if not r then continue end
        for _, pn in ipairs({"\085\112\103\114\097\100\101\083\116\097\099\107","\066\117\121\078\101\120\116","\077\097\110\097\103\101","\087\097\108\107\083\112\101\101\100","\067\108\105\099\107\070\114\117\105\116\086\097\108\117\101"}) do
            task.spawn(function() pcall(function() r:InvokeServer(pn) end); ScriptData.Stats.powerUpgrades += 1 end)
        end
    end
end)

-- Bonus Boosts
task.spawn(function() while true do task.wait(20); if ScriptData.AutoOfflineCash then pcall(function() ScriptData.PlayerTycoon.Remotes.DoubleOfflineCash:InvokeServer() end) end end end)
task.spawn(function() while true do task.wait(10); if ScriptData.AutoTimeCash then pcall(function() ScriptData.PlayerTycoon.Remotes.UseTimeCash:InvokeServer() end) end end end)
task.spawn(function() while true do task.wait(10); if ScriptData.AutoEarnerBoost then pcall(function() ScriptData.PlayerTycoon.Remotes.UseEarnerBoost:InvokeServer() end) end end end)

-- Minigames
local raceCD = false
task.spawn(function() while true do task.wait(5)
    if not ScriptData.AutoMinigameRace or raceCD then continue end
    local core = ReplicatedStorage:FindFirstChild("\067\111\114\101"); if not core then continue end
    local request = core:FindFirstChild("\082\101\109\111\116\101\082\101\113\117\101\115\116"); if not request then continue end
    local startRF = request:FindFirstChild("\077\105\110\105\103\097\109\101\082\097\099\101\083\101\114\118\105\099\101\046\083\116\097\114\116"); local endRF = request:FindFirstChild("\077\105\110\105\103\097\109\101\082\097\099\101\083\101\114\118\105\099\101\046\069\110\100")
    if not startRF or not endRF then continue end
    raceCD = true; task.spawn(function() local ok, res = pcall(function() return startRF:InvokeServer() end)
        if ok and res then task.wait(0.25); pcall(function() endRF:InvokeServer(1) end); ScriptData.Stats.racesWon += 1 end
        task.wait(3); raceCD = false
    end)
end end)

local tradeCD = false
task.spawn(function() while true do task.wait(5)
    if not ScriptData.AutoMinigameTrade or tradeCD then continue end
    local core = ReplicatedStorage:FindFirstChild("\067\111\114\101"); if not core then continue end
    local request = core:FindFirstChild("\082\101\109\111\116\101\082\101\113\117\101\115\116"); if not request then continue end
    local startRF = request:FindFirstChild("\077\105\110\105\103\097\109\101\084\114\097\100\101\083\101\114\118\105\099\101\046\083\116\097\114\116"); local endRF = request:FindFirstChild("\077\105\110\105\103\097\109\101\084\114\097\100\101\083\101\114\118\105\099\101\046\069\110\100")
    if not startRF or not endRF then continue end
    tradeCD = true; task.spawn(function() local ok, res = pcall(function() return startRF:InvokeServer() end)
        if ok and res then task.wait(0.25); pcall(function() endRF:InvokeServer(1) end); ScriptData.Stats.tradesWon += 1 end
        task.wait(3); tradeCD = false
    end)
end end)

-- Anti-AFK (VirtualUser)
LocalPlayer.Idled:Connect(function()
    if not ScriptData.AntiAFK then return end
    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
end)
task.spawn(function() while true do task.wait(900)
    if not ScriptData.AntiAFK then continue end
    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
end end)

-- FPS Boost
local removedObjects, fpsActive = {}, false
function enableFPSBoost()
    if fpsActive then return end; fpsActive = true
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("\084\101\120\116\117\114\101") or obj:IsA("\068\101\099\097\108") or obj:IsA("\080\097\114\116\105\099\108\101\069\109\105\116\116\101\114") or obj:IsA("\084\114\097\105\108") or obj:IsA("\083\109\111\107\101") or obj:IsA("\070\105\114\101") or obj:IsA("\083\112\097\114\107\108\101\115") then
            table.insert(removedObjects, {obj=obj, parent=obj.Parent}); obj.Parent = nil
        end
    end
    local lighting = game:GetService("\076\105\103\104\116\105\110\103"); lighting.GlobalShadows = false; lighting.Brightness = 2
end
function disableFPSBoost()
    if not fpsActive then return end; fpsActive = false
    for _, e in ipairs(removedObjects) do pcall(function() e.obj.Parent = e.parent end) end
    removedObjects = {}
    local lighting = game:GetService("\076\105\103\104\116\105\110\103"); lighting.GlobalShadows = true; lighting.Brightness = 1
end

-- Character reset
LocalPlayer.CharacterAdded:Connect(function() task.wait(2); buildStandRFCache(); buildWakeRFCache(); setupPhoneOffer(); buyLock = {} end)

-- ================== KEYBINDS (F2-F7) ==================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F2 then ScriptData.AutoCollectFruit = not ScriptData.AutoCollectFruit; BabisWindow:CreateNotification("\070\050", "\065\117\116\111\032\067\111\108\108\101\099\116\032\070\114\117\105\116\058\032"..(ScriptData.AutoCollectFruit and "\079\078" or "\079\070\070"), 2) end
    if input.KeyCode == Enum.KeyCode.F3 then ScriptData.AutoBuyUpgrades = not ScriptData.AutoBuyUpgrades; BabisWindow:CreateNotification("\070\051", "\065\117\116\111\032\066\117\121\032\085\112\103\114\097\100\101\115\058\032"..(ScriptData.AutoBuyUpgrades and "\079\078" or "\079\070\070"), 2) end
    if input.KeyCode == Enum.KeyCode.F4 then ScriptData.SafeMode = not ScriptData.SafeMode; BabisWindow:CreateNotification("\070\052", "\083\097\102\101\032\077\111\100\101\058\032"..(ScriptData.SafeMode and "\079\078" or "\079\070\070"), 2) end
    if input.KeyCode == Enum.KeyCode.F5 then ScriptData.AutoUpgradeStands = not ScriptData.AutoUpgradeStands; BabisWindow:CreateNotification("\070\053", "\085\112\103\114\097\100\101\032\083\116\097\110\100\115\058\032"..(ScriptData.AutoUpgradeStands and "\079\078" or "\079\070\070"), 2) end
    if input.KeyCode == Enum.KeyCode.F6 then
        ScriptData.AutoCollectFruit = false; ScriptData.AutoBuyUpgrades = false; ScriptData.AutoUpgradeStands = false; ScriptData.AutoCollectDrops = false; ScriptData.SafeMode = false
        BabisWindow:CreateNotification("\070\054", "\080\065\078\073\067\058\032\065\108\108\032\115\116\111\112\112\101\100\033", 3)
    end
    if input.KeyCode == Enum.KeyCode.F7 then BabisWindow.MainFrame.Visible = not BabisWindow.MainFrame.Visible end
end)

-- ================== FINAL INIT ==================
task.wait(1.5)
LoadingScreen:Destroy()
BabisWindow:CreateNotification("\066\097\098\105\115\032\115\101\108\108\032\108\101\109\111\110\115", "\070\117\115\105\111\110\032\071\085\073\032\108\111\097\100\101\100\033\032\072\101\097\116\032\077\097\115\116\101\114\032\102\101\097\116\117\114\101\115\032\105\110\116\101\103\114\097\116\101\100\046\032\070\050\045\070\055\032\107\101\121\115\032\097\099\116\105\118\101\046", 5)
print("\066\097\098\105\115\032\115\101\108\108\032\108\101\109\111\110\115\032\102\117\108\108\121\032\108\111\097\100\101\100\032\045\032\072\101\097\116\032\077\097\115\116\101\114\032\102\117\115\105\111\110\032\099\111\109\112\108\101\116\101\046")