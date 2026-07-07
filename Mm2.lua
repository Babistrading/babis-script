-- ============================================
--  Babis MM2 Beta Key - Combined Script
--  Kill All (Murderer) + Bullet TP (Sheriff)
--  Works on Delta (iOS / Android / PC)
-- ============================================

--  CONFIGURATION (edit these if needed)
local DISCORD_INVITE = "https://discord.gg/tRA3yStbvq"   -- Permanent invite (never expires)
local VALID_KEY = "W7#qL9!xP2@vR8$mN5^z"               -- Key users paste to unlock

--  INTERNAL VARIABLES
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--  CHECK IF KEY ALREADY VERIFIED (via saved file)
local keyAlreadyVerified = false
pcall(function()
    local content = readfile("BabisKeyVerified.txt")
    if content == "true" then
        keyAlreadyVerified = true
    end
end)

-- ===== CREATE MAIN SCREEN GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "BabisBrokenBones"
gui.Parent = playerGui
gui.ResetOnSpawn = false

-- ============================================================
--  KEY ENTRY FRAME (appears only if NOT yet verified)
-- ============================================================
local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 300, 0, 200)
keyFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
keyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keyFrame.BorderSizePixel = 0
keyFrame.Visible = not keyAlreadyVerified
keyFrame.Parent = gui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0.1, 0)
keyCorner.Parent = keyFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -20, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Enter Key to Unlock"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 35)
keyBox.Position = UDim2.new(0, 20, 0, 50)
keyBox.PlaceholderText = "Paste your key here..."
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.SourceSans
keyBox.TextSize = 16
keyBox.BorderSizePixel = 0
keyBox.Parent = keyFrame

local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0.1, 0)
keyBoxCorner.Parent = keyBox

local verifyBtn = Instance.new("TextButton")
verifyBtn.Size = UDim2.new(1, -40, 0, 35)
verifyBtn.Position = UDim2.new(0, 20, 0, 95)
verifyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
verifyBtn.Text = "Verify Key"
verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
verifyBtn.Font = Enum.Font.SourceSansBold
verifyBtn.TextSize = 16
verifyBtn.BorderSizePixel = 0
verifyBtn.AutoButtonColor = false
verifyBtn.Parent = keyFrame

local verifyCorner = Instance.new("UICorner")
verifyCorner.CornerRadius = UDim.new(0.1, 0)
verifyCorner.Parent = verifyBtn

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(1, -40, 0, 35)
getKeyBtn.Position = UDim2.new(0, 20, 0, 140)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
getKeyBtn.Text = "Get Key (Join Discord)"
getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyBtn.Font = Enum.Font.SourceSansBold
getKeyBtn.TextSize = 16
getKeyBtn.BorderSizePixel = 0
getKeyBtn.AutoButtonColor = false
getKeyBtn.Parent = keyFrame

local getKeyCorner = Instance.new("UICorner")
getKeyCorner.CornerRadius = UDim.new(0.1, 0)
getKeyCorner.Parent = getKeyBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 180)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.Visible = false
statusLabel.Parent = keyFrame

-- ============================================================
--  TOGGLE BUTTON (black square with white "B")
--  Hidden until key is verified (or already verified)
-- ============================================================
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0.8, 0, 0.8, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Text = "B"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 30
toggleBtn.BorderSizePixel = 0
toggleBtn.AutoButtonColor = false
toggleBtn.Visible = keyAlreadyVerified
toggleBtn.Parent = gui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0.3, 0)
toggleCorner.Parent = toggleBtn

-- ============================================================
--  MAIN HACK FRAME (Kill All + Bullet TP)
-- ============================================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0.1, 0)
mainCorner.Parent = mainFrame

local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, -20, 0, 40)
mainTitle.Position = UDim2.new(0, 10, 0, 10)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "Babis broken bones beta key"
mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
mainTitle.Font = Enum.Font.SourceSansBold
mainTitle.TextSize = 18
mainTitle.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0.4, 0)
closeCorner.Parent = closeBtn

-- Kill All button
local killAllBtn = Instance.new("TextButton")
killAllBtn.Size = UDim2.new(1, -20, 0, 50)
killAllBtn.Position = UDim2.new(0, 10, 0, 60)
killAllBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
killAllBtn.Text = "Kill All (Murderer): OFF"
killAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
killAllBtn.Font = Enum.Font.SourceSans
killAllBtn.TextSize = 16
killAllBtn.BorderSizePixel = 0
killAllBtn.AutoButtonColor = false
killAllBtn.Parent = mainFrame

local killAllCorner = Instance.new("UICorner")
killAllCorner.CornerRadius = UDim.new(0.1, 0)
killAllCorner.Parent = killAllBtn

-- Bullet TP button
local bulletTpBtn = Instance.new("TextButton")
bulletTpBtn.Size = UDim2.new(1, -20, 0, 50)
bulletTpBtn.Position = UDim2.new(0, 10, 0, 130)
bulletTpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bulletTpBtn.Text = "Bullet TP (Sheriff): OFF"
bulletTpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
bulletTpBtn.Font = Enum.Font.SourceSans
bulletTpBtn.TextSize = 16
bulletTpBtn.BorderSizePixel = 0
bulletTpBtn.AutoButtonColor = false
bulletTpBtn.Parent = mainFrame

local bulletTpCorner = Instance.new("UICorner")
bulletTpCorner.CornerRadius = UDim.new(0.1, 0)
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
                local knife = char:FindFirstChild("Knife")
                if knife then
                    local events = knife:FindFirstChild("Events")
                    if events then
                        local HandleTouched = events:FindFirstChild("HandleTouched")
                        if HandleTouched then
                            for _, targetPlayer in pairs(Players:GetPlayers()) do
                                if targetPlayer ~= player and targetPlayer.Character then
                                    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
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
        task.wait(1) -- repeat every second
    end
end

killAllBtn.MouseButton1Click:Connect(function()
    killAllOn = not killAllOn
    if killAllOn then
        killAllBtn.Text = "Kill All (Murderer): ON"
        killAllBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        task.spawn(killAllLoop)
    else
        killAllBtn.Text = "Kill All (Murderer): OFF"
        killAllBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)

-- ============================================================
--  BULLET TP (SHERIFF) FEATURE
-- ============================================================
local bulletTpConnection = nil
local oldNamecall = nil

local function getMurdererRoot()
    local storage = game:GetService("ReplicatedStorage")
    local remotes = storage:FindFirstChild("Remotes")
    local extras = remotes and remotes:FindFirstChild("Extras")
    local remote = extras and extras:FindFirstChild("GetPlayerData")
    if not remote then return nil end

    local success, data = pcall(remote.InvokeServer, remote)
    if not success or type(data) ~= "table" then return nil end

    for plrName, plrData in pairs(data) do
        if plrData.Role == "Murderer" then
            local target = Players:FindFirstChild(plrName)
            if target and target.Character then
                local hrp = target.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    return hrp
                end
            end
        end
    end
    return nil
end

local function getShootRemote()
    local gun = player.Backpack and player.Backpack:FindFirstChild("Gun")
    if not gun then
        if player.Character then
            gun = player.Character:FindFirstChild("Gun")
        end
    end
    return gun and gun:FindFirstChild("Shoot", true)
end

local function enableBulletTP()
    if bulletTpConnection then return end -- already enabled
    
    local remoteRef = nil
    local targetRoot = nil

    bulletTpConnection = game:GetService("RunService").RenderStepped:Connect(function()
        remoteRef = getShootRemote()
        targetRoot = getMurdererRoot()
    end)

    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if bulletTpOn and remoteRef and self == remoteRef and method == "FireServer" and targetRoot then
            args[1] = targetRoot.CFrame + Vector3.new(0, 3, 0)
            args[2] = targetRoot.CFrame
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
        hookmetamethod(game, "__namecall", oldNamecall) -- restore original
        oldNamecall = nil
    end
end

bulletTpBtn.MouseButton1Click:Connect(function()
    bulletTpOn = not bulletTpOn
    if bulletTpOn then
        bulletTpBtn.Text = "Bullet TP (Sheriff): ON"
        bulletTpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
        enableBulletTP()
    else
        bulletTpBtn.Text = "Bullet TP (Sheriff): OFF"
        bulletTpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        disableBulletTP()
    end
end)

-- ============================================================
--  KEY VERIFICATION (unchanged)
-- ============================================================
verifyBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == VALID_KEY then
        pcall(function()
            writefile("BabisKeyVerified.txt", "true")
        end)
        keyFrame.Visible = false
        toggleBtn.Visible = true
        mainFrame.Visible = true
        statusLabel.Visible = false
        print("[Babis] Key verified and saved. GUI unlocked permanently.")
    else
        statusLabel.Text = "Invalid key! Click 'Get Key' to join Discord."
        statusLabel.Visible = true
    end
end)

getKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard(DISCORD_INVITE)
    end)
    statusLabel.Text = "Link copied"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    statusLabel.Visible = true
    task.wait(2)
    statusLabel.Visible = false
end)

-- ============================================================
print("[Babis] Combined MM2 script loaded. Key system active.")