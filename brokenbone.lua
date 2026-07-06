--[[ Protected by Lua Guard ]]

(function(...) 
-- ============================================
--  Babis broken bones beta key - by Babis
--  Complete script with persistent key check
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

-- Rounded corners for key frame
local keyCorner = Instance.new("\085\073\067\111\114\110\101\114")
keyCorner.CornerRadius = UDim.new(0.1, 0x0)
keyCorner.Parent = keyFrame

-- Title
local titleLabel = Instance.new("\084\101\120\116\076\097\098\101\108")
titleLabel.Size = UDim2.new(0x1, -0x14, 0x0, 0x1E)
titleLabel.Position = UDim2.new(0x0, 0xA, 0x0, 0xA)
titleLabel.BackgroundTransparency = 0x1
titleLabel.Text = "\069\110\116\101\114\032\075\101\121\032\116\111\032\085\110\108\111\099\107"
titleLabel.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 0x12
titleLabel.Parent = keyFrame

-- Key input box
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

-- Verify Key button
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

-- Get Key button (copies Discord invite)
local getKeyBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
getKeyBtn.Size = UDim2.new(0x1, -0x28, 0x0, 0x23)
getKeyBtn.Position = UDim2.new(0x0, 0x14, 0x0, 0x8C)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(0x0, 0x78, 0xD4)   -- Discord-like blue
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

-- Status label (error / success messages)
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
toggleBtn.Visible = keyAlreadyVerified   -- show only if already verified
toggleBtn.Parent = gui

local toggleCorner = Instance.new("\085\073\067\111\114\110\101\114")
toggleCorner.CornerRadius = UDim.new(0.3, 0x0)
toggleCorner.Parent = toggleBtn

-- ============================================================
--  MAIN HACK FRAME (Infinite Money + Auto Upgrade)
-- ============================================================
local mainFrame = Instance.new("\070\114\097\109\101")
mainFrame.Size = UDim2.new(0x0, 0xDC, 0x0, 0xF0)
mainFrame.Position = UDim2.new(0.5, -0x6E, 0.5, -0x78)
mainFrame.BackgroundColor3 = Color3.fromRGB(0x0, 0x0, 0x0)
mainFrame.BorderSizePixel = 0x0
mainFrame.Visible = false         -- toggled by the B button
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("\085\073\067\111\114\110\101\114")
mainCorner.CornerRadius = UDim.new(0.1, 0x0)
mainCorner.Parent = mainFrame

-- Title inside the panel
local mainTitle = Instance.new("\084\101\120\116\076\097\098\101\108")
mainTitle.Size = UDim2.new(0x1, -0x14, 0x0, 0x28)
mainTitle.Position = UDim2.new(0x0, 0xA, 0x0, 0xA)
mainTitle.BackgroundTransparency = 0x1
mainTitle.Text = "\066\097\098\105\115\032\098\114\111\107\101\110\032\098\111\110\101\115\032\098\101\116\097\032\107\101\121"
mainTitle.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
mainTitle.Font = Enum.Font.SourceSansBold
mainTitle.TextSize = 0x12
mainTitle.Parent = mainFrame

-- Close button (X)
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

-- Infinite Money toggle button
local infMoneyBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
infMoneyBtn.Size = UDim2.new(0x1, -0x14, 0x0, 0x32)
infMoneyBtn.Position = UDim2.new(0x0, 0xA, 0x0, 0x3C)
infMoneyBtn.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x1E)
infMoneyBtn.Text = "\073\110\102\105\110\105\116\101\032\077\111\110\101\121\058\032\079\070\070"
infMoneyBtn.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
infMoneyBtn.Font = Enum.Font.SourceSans
infMoneyBtn.TextSize = 0x10
infMoneyBtn.BorderSizePixel = 0x0
infMoneyBtn.AutoButtonColor = false
infMoneyBtn.Parent = mainFrame

local infMoneyCorner = Instance.new("\085\073\067\111\114\110\101\114")
infMoneyCorner.CornerRadius = UDim.new(0.1, 0x0)
infMoneyCorner.Parent = infMoneyBtn

-- Auto Upgrade toggle button
local autoUpgradeBtn = Instance.new("\084\101\120\116\066\117\116\116\111\110")
autoUpgradeBtn.Size = UDim2.new(0x1, -0x14, 0x0, 0x32)
autoUpgradeBtn.Position = UDim2.new(0x0, 0xA, 0x0, 0x82)
autoUpgradeBtn.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x1E)
autoUpgradeBtn.Text = "\065\117\116\111\032\085\112\103\114\097\100\101\058\032\079\070\070"
autoUpgradeBtn.TextColor3 = Color3.fromRGB(0xFF, 0xFF, 0xFF)
autoUpgradeBtn.Font = Enum.Font.SourceSans
autoUpgradeBtn.TextSize = 0x10
autoUpgradeBtn.BorderSizePixel = 0x0
autoUpgradeBtn.AutoButtonColor = false
autoUpgradeBtn.Parent = mainFrame

local autoUpgradeCorner = Instance.new("\085\073\067\111\114\110\101\114")
autoUpgradeCorner.CornerRadius = UDim.new(0.1, 0x0)
autoUpgradeCorner.Parent = autoUpgradeBtn

-- ============================================================
--  STATE VARIABLES
-- ============================================================
local infMoneyOn = false
local autoUpgradeOn = false

-- ============================================================
--  BUTTON FUNCTIONALITY
-- ============================================================

-- Toggle the main hack panel with the black B button
toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Close the panel with the X button
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- ---------- INFINITE MONEY ----------
local function infMoneyLoop()
    while infMoneyOn do
        pcall(function()
            local updateMoney = filtergc("\102\117\110\099\116\105\111\110", {Name = "\085\112\100\097\116\101\077\111\110\101\121"}, true)
            updateMoney(0x5AF3107A3FFF)
        end)
        task.wait(0x1)
    end
end

infMoneyBtn.MouseButton1Click:Connect(function()
    infMoneyOn = not infMoneyOn
    if infMoneyOn then
        infMoneyBtn.Text = "\073\110\102\105\110\105\116\101\032\077\111\110\101\121\058\032\079\078"
        infMoneyBtn.BackgroundColor3 = Color3.fromRGB(0x0, 0x64, 0x0)   -- green
        task.spawn(infMoneyLoop)
    else
        infMoneyBtn.Text = "\073\110\102\105\110\105\116\101\032\077\111\110\101\121\058\032\079\070\070"
        infMoneyBtn.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x1E)
    end
end)

-- ---------- AUTO UPGRADE ----------
local function autoUpgradeLoop()
    while autoUpgradeOn do
        pcall(function()
            local upgrades = playerGui:FindFirstChild("\071\117\105")
            if upgrades then
                upgrades = upgrades:FindFirstChild("\083\104\111\112")
                if upgrades then
                    upgrades = upgrades:FindFirstChild("\066\111\100\121")
                    if upgrades then
                        upgrades = upgrades:FindFirstChild("\085\112\103\114\097\100\101\115")
                        if upgrades then
                            upgrades = upgrades:FindFirstChild("\084\097\098\108\101")
                            if upgrades then
                                for _, v in pairs(upgrades:GetChildren()) do
                                    if v:FindFirstChild("\066") then
                                        for _, conn in pairs(getconnections(v.B.MouseButton1Up)) do
                                            task.spawn(function()
                                                conn.Function()
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end

autoUpgradeBtn.MouseButton1Click:Connect(function()
    autoUpgradeOn = not autoUpgradeOn
    if autoUpgradeOn then
        autoUpgradeBtn.Text = "\065\117\116\111\032\085\112\103\114\097\100\101\058\032\079\078"
        autoUpgradeBtn.BackgroundColor3 = Color3.fromRGB(0x0, 0x64, 0x0)
        task.spawn(autoUpgradeLoop)
    else
        autoUpgradeBtn.Text = "\065\117\116\111\032\085\112\103\114\097\100\101\058\032\079\070\070"
        autoUpgradeBtn.BackgroundColor3 = Color3.fromRGB(0x1E, 0x1E, 0x1E)
    end
end)

-- ---------- KEY VERIFICATION ----------
verifyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == VALID_KEY then
        -- Save verification locally
        pcall(function()
            writefile("\066\097\098\105\115\075\101\121\086\101\114\105\102\105\101\100\046\116\120\116", "\116\114\117\101")
        end)
        -- Hide key frame, show toggle button and panel
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

-- ---------- GET KEY (copies Discord invite) ----------
getKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard(DISCORD_INVITE)
    end)
    -- Show "\076\105\110\107\032\099\111\112\105\101\100" notification
    statusLabel.Text = "\076\105\110\107\032\099\111\112\105\101\100"
    statusLabel.TextColor3 = Color3.fromRGB(0x0, 0xFF, 0x0)   -- green
    statusLabel.Visible = true
    task.wait(0x2)
    statusLabel.Visible = false
end)

-- ============================================================
--  END OF SCRIPT
-- ============================================================
print("\091\066\097\098\105\115\093\032\083\099\114\105\112\116\032\108\111\097\100\101\100\046\032\070\105\114\115\116\032\101\120\101\099\117\116\105\111\110\058\032\101\110\116\101\114\032\116\104\101\032\107\101\121\046\032\083\117\098\115\101\113\117\101\110\116\032\114\117\110\115\032\119\105\108\108\032\115\107\105\112\032\105\116\032\097\117\116\111\109\097\116\105\099\097\108\108\121\046")
 end)(...)