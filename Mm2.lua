--[[ Protected by Lua Guard ]]

-- ============================================
--  Babis MM2 Beta Key - Combined Script
--  Kill All (Murderer) + Bullet TP (Sheriff)
--  Works on Delta (iOS / Android / PC)
-- ============================================

--  CONFIGURATION (edit these if needed)
local DISCORD_INVITE = "\104\116\116\112\115\058\047\047\100\105\115\099\111\114\100\046\103\103\047\116\082\065\051\121\083\116\098\118\113"   -- Permanent invite (never expires)
local VALID_KEY = "\087\055\035\113\076\057\033\120\080\050\064\118\082\056\036\109\078\053\094\122"               -- Key users paste to unlock

--  INTERNAL VARIABLES
local HttpService = game:GetService("\072\116\116\112\083\101\114\118\105\099\101")
local Players = game:GetService("\080\108\097\121\101\114\115")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("\080\108\097\121\101\114\071\117\105")

--  CHECK IF KEY ALREADY VERIFIED (via saved file)
local keyAlreadyVerified = false
pcall(function()
    local content = readfile("\066\097\098\105\115\075\101\121\086\101\114\105\102\105\101\100\046\116\120\116")
    if content == "\116\114\117\101" then
        keyAlreadyVerified = true
    end
end)

-- ===== CREATE MAIN SCREEN GUI =====
local gui = Instance.new("\083\099\114\101\101\110\071\117\105")
gui.Name = "\066\097\098\105\115\066\114\111\107\101\110\066\111\110\101\115"
gui.Parent = playerGui
gui.ResetOnSpawn = false

-- ============================================================
--  KEY ENTRY FRAME (appears only if NOT yet verified)
-- ============================================================
local keyFrame = Instance.new("\070\114\097\109\101")
keyFrame.Size = UDim2.new(0x0, 0x12C, 0x0, 0xC8)
keyFrame.Position = UDim2.new(0.5, -0x96, 0.5, -0x64)
keyFrame.BackgroundColor3 = Color3.fromRGB(0x0, 0x0, 0x0)
keyFrame.BorderSizePixel = 0x0
keyFrame.Visible = not keyAlreadyVerified
keyFrame.Parent = gui

local keyCorner = Instance.new("\085\073\067\111\114\110\101\114")
keyCorner.CornerRadius = UDim.new(0.1, 0x0)
keyCorner.Parent = keyFrame

local titleLabel = Instance.new("\084\101\120\116\076\097\098\101\108")
titleLabel.Size = UDim2.new(0x1, -0x14, 0x0, 0x1E)
titleLabel.Position = UDim2.new(0x0, 0xA, 0x0, 0xA)
titleLabel.BackgroundTransparency = 0x1
titleLabel.Text = "\069\110\116\101\114\032\075\101\121\032\116\111\032\085\110\108\111\099\107"
titleLabel.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 0x12
titleLabel.Parent = keyFrame

local keyBox = Instance.new("\084\101\120\116\066\111\120")
keyBox.Size = UDim2.new(0x1, -0x28, 0x0, 0x23)
keyBox.Position = UDim2.new(0x0, 0x14, 0x0, 0x32)
keyBox.PlaceholderText = "\080\097\115\116\101\032\121\111\117\114\032\107\101\121\032\104\101\114\101\046\046\046"
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(0x28, 0x28, 0x28)
keyBox.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
keyBox.Font = Enum.Font.SourceSans
keyBox.TextSize = 0x10
keyBox.BorderSizePixel = 0x0
keyBox.Parent = keyFrame

local keyBoxCorner = Instance.new("\085\073\067\111\114\110\101\114")
keyBoxCorner.CornerRadius = UDim.new(0.1, 0x0)
keyBoxCorner.Parent = keyBox

local verifyBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
verifyBtn.Size = UDim2.new(0x1, -0x28, 0x0, 0x23)
verifyBtn.Position = UDim2.new(0x0, 0x14, 0x0, 0x5F)
verifyBtn.BackgroundColor3 = Color3.fromRGB(0x3C, 0x3C, 0x3C)
verifyBtn.Text = "\086\101\114\105\102\121\032\075\101\121"
verifyBtn.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
verifyBtn.Font = Enum.Font.SourceSansBold
verifyBtn.TextSize = 0x10
verifyBtn.BorderSizePixel = 0x0
verifyBtn.AutoButtonColor = false
verifyBtn.Parent = keyFrame

local verifyCorner = Instance.new("\085\073\067\111\114\110\101\114")
verifyCorner.CornerRadius = UDim.new(0.1, 0x0)
verifyCorner.Parent = verifyBtn

local getKeyBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
getKeyBtn.Size = UDim2.new(0x1, -0x28, 0x0, 0x23)
getKeyBtn.Position = UDim2.new(0x0, 0x14, 0x0, 0x8C)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(0x0, 0x78, 0xD4)
getKeyBtn.Text = "\071\101\116\032\075\101\121\032\040\074\111\105\110\032\068\105\115\099\111\114\100\041"
getKeyBtn.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
getKeyBtn.Font = Enum.Font.SourceSansBold
getKeyBtn.TextSize = 0x10
getKeyBtn.BorderSizePixel = 0x0
getKeyBtn.AutoButtonColor = false
getKeyBtn.Parent = keyFrame

local getKeyCorner = Instance.new("\085\073\067\111\114\110\101\114")
getKeyCorner.CornerRadius = UDim.new(0.1, 0x0)
getKeyCorner.Parent = getKeyBtn

local statusLabel = Instance.new("\084\101\120\116\076\097\098\101\108")
statusLabel.Size = UDim2.new(0x1, -0x14, 0x0, 0x14)
statusLabel.Position = UDim2.new(0x0, 0xA, 0x0, 0xB4)
statusLabel.BackgroundTransparency = 0x1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(0xFF, 0x50, 0x50)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 0xE
statusLabel.Visible = false
statusLabel.Parent = keyFrame

-- ============================================================
--  TOGGLE BUTTON (black square with white "\066")
--  Hidden until key is verified (or already verified)
-- ============================================================
local toggleBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
toggleBtn.Size = UDim2.new(0x0, 0x3C, 0x0, 0x3C)
toggleBtn.Position = UDim2.new(0.8, 0x0, 0.8, 0x0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0x0, 0x0, 0x0)
toggleBtn.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
toggleBtn.Text = "\066"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 0x1E
toggleBtn.BorderSizePixel = 0x0
toggleBtn.AutoButtonColor = false
toggleBtn.Visible = keyAlreadyVerified
toggleBtn.Parent = gui

local toggleCorner = Instance.new("\085\073\067\111\114\110\101\114")
toggleCorner.CornerRadius = UDim.new(0.3, 0x0)
toggleCorner.Parent = toggleBtn

-- ============================================================
--  MAIN HACK FRAME (Kill All + Bullet TP)
-- ============================================================
local mainFrame = Instance.new("\070\114\097\109\101")
mainFrame.Size = UDim2.new(0x0, 0xDC, 0x0, 0xC8)
mainFrame.Position = UDim2.new(0.5, -0x6E, 0.5, -0x64)
mainFrame.BackgroundColor3 = Color3.fromRGB(0x0, 0x0, 0x0)
mainFrame.BorderSizePixel = 0x0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("\085\073\067\111\114\110\101\114")
mainCorner.CornerRadius = UDim.new(0.1, 0x0)
mainCorner.Parent = mainFrame

local mainTitle = Instance.new("\084\101\120\116\076\097\098\101\108")
mainTitle.Size = UDim2.new(0x1, -0x14, 0x0, 0x28)
mainTitle.Position = UDim2.new(0x0, 0xA, 0x0, 0xA)
mainTitle.BackgroundTransparency = 0x1
mainTitle.Text = "\066\097\098\105\115\032\098\114\111\107\101\110\032\098\111\110\101\115\032\098\101\116\097\032\107\101\121"
mainTitle.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
mainTitle.Font = Enum.Font.SourceSansBold
mainTitle.TextSize = 0x12
mainTitle.Parent = mainFrame

local closeBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
closeBtn.Size = UDim2.new(0x0, 0x1E, 0x0, 0x1E)
closeBtn.Position = UDim2.new(0x1, -0x28, 0x0, 0x5)
closeBtn.BackgroundColor3 = Color3.fromRGB(0x28, 0x28, 0x28)
closeBtn.Text = "\088"
closeBtn.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 0x12
closeBtn.BorderSizePixel = 0x0
closeBtn.AutoButtonColor = false
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("\085\073\067\111\114\110\101\114")
closeCorner.CornerRadius = UDim.new(0.4, 0x0)
closeCorner.Parent = closeBtn

-- Kill All button
local killAllBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
killAllBtn.Size = UDim2.new(0x1, -0x14, 0x0, 0x32)
killAllBtn.Position = UDim2.new(0x0, 0xA, 0x0, 0x3C)
killAllBtn.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x1E)
killAllBtn.Text = "\075\105\108\108\032\065\108\108\032\040\077\117\114\100\101\114\101\114\041\058\032\079\070\070"
killAllBtn.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
killAllBtn.Font = Enum.Font.SourceSans
killAllBtn.TextSize = 0x10
killAllBtn.BorderSizePixel = 0x0
killAllBtn.AutoButtonColor = false
killAllBtn.Parent = mainFrame

local killAllCorner = Instance.new("\085\073\067\111\114\110\101\114")
killAllCorner.CornerRadius = UDim.new(0.1, 0x0)
killAllCorner.Parent = killAllBtn

-- Bullet TP button
local bulletTpBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
bulletTpBtn.Size = UDim2.new(0x1, -0x14, 0x0, 0x32)
bulletTpBtn.Position = UDim2.new(0x0, 0xA, 0x0, 0x82)
bulletTpBtn.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x1E)
bulletTpBtn.Text = "\066\117\108\108\101\116\032\084\080\032\040\083\104\101\114\105\102\102\041\058\032\079\070\070"
bulletTpBtn.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
bulletTpBtn.Font = Enum.Font.SourceSans
bulletTpBtn.TextSize = 0x10
bulletTpBtn.BorderSizePixel = 0x0
bulletTpBtn.AutoButtonColor = false
bulletTpBtn.Parent = mainFrame

local bulletTpCorner = Instance.new("\085\073\067\111\114\110\101\114")
bulletTpCorner.CornerRadius = UDim.new(0.1, 0x0)
bulletTpCorner.Parent = bulletTpBtn

-- ============================================================
--  STATE VARIABLES
-- ============================================================
local killAllOn = false
local bulletTpOn = false

-- ============================================================
--  TOGGLE BUTTON FUNCTIONALITY
-- ============================================================
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ============================================================
--  KILL ALL FEATURE
-- ============================================================
local function killAllLoop()
    while killAllOn do
        pcall(function()
            local char = player.Character
            if char then
                local knife = char:FindFirstChild("\075\110\105\102\101")
                if knife then
                    local events = knife:FindFirstChild("\069\118\101\110\116\115")
                    if events then
                        local HandleTouched = events:FindFirstChild("\072\097\110\100\108\101\084\111\117\099\104\101\100")
                        if HandleTouched then
                            for _, targetPlayer in pairs(Players:GetPlayers()) do
                                if targetPlayer ~= player and targetPlayer.Character then
                                    local root = targetPlayer.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
                                    if root then
                                        HandleTouched:FireServer(root)
                                        task.wait(0.05)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0x1) -- repeat every second
    end
end

killAllBtn.MouseButton1Click:Connect(function()
    killAllOn = not killAllOn
    if killAllOn then
        killAllBtn.Text = "\075\105\108\108\032\065\108\108\032\040\077\117\114\100\101\114\101\114\041\058\032\079\078"
        killAllBtn.BackgroundColor3 = Color3.fromRGB(0x0, 0x64, 0x0)
        task.spawn(killAllLoop)
    else
        killAllBtn.Text = "\075\105\108\108\032\065\108\108\032\040\077\117\114\100\101\114\101\114\041\058\032\079\070\070"
        killAllBtn.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x1E)
    end
end)

-- ============================================================
--  BULLET TP (SHERIFF) FEATURE
-- ============================================================
local bulletTpConnection = nil
local oldNamecall = nil

local function getMurdererRoot()
    local storage = game:GetService("\082\101\112\108\105\099\097\116\101\100\083\116\111\114\097\103\101")
    local remotes = storage:FindFirstChild("\082\101\109\111\116\101\115")
    local extras = remotes and remotes:FindFirstChild("\069\120\116\114\097\115")
    local remote = extras and extras:FindFirstChild("\071\101\116\080\108\097\121\101\114\068\097\116\097")
    if not remote then return nil end

    local success, data = pcall(remote.InvokeServer, remote)
    if not success or type(data) ~= "\116\097\098\108\101" then return nil end

    for plrName, plrData in pairs(data) do
        if plrData.Role == "\077\117\114\100\101\114\101\114" then
            local target = Players:FindFirstChild(plrName)
            if target and target.Character then
                local hrp = target.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
                if hrp then
                    return hrp
                end
            end
        end
    end
    return nil
end

local function getShootRemote()
    local gun = player.Backpack and player.Backpack:FindFirstChild("\071\117\110")
    if not gun then
        if player.Character then
            gun = player.Character:FindFirstChild("\071\117\110")
        end
    end
    return gun and gun:FindFirstChild("\083\104\111\111\116", true)
end

local function enableBulletTP()
    if bulletTpConnection then return end -- already enabled
    
    local remoteRef = nil
    local targetRoot = nil

    bulletTpConnection = game:GetService("\082\117\110\083\101\114\118\105\099\101").RenderStepped:Connect(function()
        remoteRef = getShootRemote()
        targetRoot = getMurdererRoot()
    end)

    oldNamecall = hookmetamethod(game, "\095\095\110\097\109\101\099\097\108\108", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if bulletTpOn and remoteRef and self == remoteRef and method == "\070\105\114\101\083\101\114\118\101\114" and targetRoot then
            args[0x1] = targetRoot.CFrame + Vector3.new(0x0, 0x3, 0x0)
            args[0x2] = targetRoot.CFrame
            return oldNamecall(self, unpack(args))
        end

        return oldNamecall(self, ...)
    end)
end

local function disableBulletTP()
    if bulletTpConnection then
        bulletTpConnection:Disconnect()
        bulletTpConnection = nil
    end
    if oldNamecall then
        hookmetamethod(game, "\095\095\110\097\109\101\099\097\108\108", oldNamecall) -- restore original
        oldNamecall = nil
    end
end

bulletTpBtn.MouseButton1Click:Connect(function()
    bulletTpOn = not bulletTpOn
    if bulletTpOn then
        bulletTpBtn.Text = "\066\117\108\108\101\116\032\084\080\032\040\083\104\101\114\105\102\102\041\058\032\079\078"
        bulletTpBtn.BackgroundColor3 = Color3.fromRGB(0x0, 0x64, 0x0)
        enableBulletTP()
    else
        bulletTpBtn.Text = "\066\117\108\108\101\116\032\084\080\032\040\083\104\101\114\105\102\102\041\058\032\079\070\070"
        bulletTpBtn.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x1E)
        disableBulletTP()
    end
end)

-- ============================================================
--  KEY VERIFICATION (unchanged)
-- ============================================================
verifyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == VALID_KEY then
        pcall(function()
            writefile("\066\097\098\105\115\075\101\121\086\101\114\105\102\105\101\100\046\116\120\116", "\116\114\117\101")
        end)
        keyFrame.Visible = false
        toggleBtn.Visible = true
        mainFrame.Visible = true
        statusLabel.Visible = false
        print("\091\066\097\098\105\115\093\032\075\101\121\032\118\101\114\105\102\105\101\100\032\097\110\100\032\115\097\118\101\100\046\032\071\085\073\032\117\110\108\111\099\107\101\100\032\112\101\114\109\097\110\101\110\116\108\121\046")
    else
        statusLabel.Text = "\073\110\118\097\108\105\100\032\107\101\121\033\032\067\108\105\099\107\032\039\071\101\116\032\075\101\121\039\032\116\111\032\106\111\105\110\032\068\105\115\099\111\114\100\046"
        statusLabel.Visible = true
    end
end)

getKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard(DISCORD_INVITE)
    end)
    statusLabel.Text = "\076\105\110\107\032\099\111\112\105\101\100"
    statusLabel.TextColor3 = Color3.fromRGB(0x0, 0xFF, 0x0)
    statusLabel.Visible = true
    task.wait(0x2)
    statusLabel.Visible = false
end)

-- ============================================================
print("\091\066\097\098\105\115\093\032\067\111\109\098\105\110\101\100\032\077\077\050\032\115\099\114\105\112\116\032\108\111\097\100\101\100\046\032\075\101\121\032\115\121\115\116\101\109\032\097\099\116\105\118\101\046")