--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║  BABIS DEADLY GOLF – COMPACT PRECISION AIMBOT + HOMING   ║
    ║  Detects ball (RigidSync+UserId) & hole (EndPoint)       ║
    ║  Advanced loft scanning (0‑85°) for minimal power        ║
    ║  Obstacle warning, laser beam, compact auto‑scaling GUI  ║
    ║  Hold‑to‑fire with progress bar + instant homing curve   ║
    ╚══════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- Module‑finding helpers
local function findModuleWithFunction(funcName)
    for _, obj in ReplicatedStorage:GetDescendants() do
        if obj:IsA("ModuleScript") then
            local ok, mod = pcall(require, obj)
            if ok and type(mod) == "table" and type(mod[funcName]) == "function" then
                return mod
            end
        end
    end
end

local endPoint = findModuleWithFunction("ComputeTarget")
local golfStrike = findModuleWithFunction("Strike")
local rigidSim = findModuleWithFunction("AddBody")
local swing = nil
pcall(function()
    local playerFSM = require(ReplicatedStorage:WaitForChild("Client"):WaitForChild("Core"):WaitForChild("PlayerFSM"))
    swing = playerFSM.Transitions.Swing
end)
local golfConfig = nil
pcall(function()
    golfConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Config"):WaitForChild("Golf"))
end)
local powerConv = findModuleWithFunction("GetRawPowerRatioFromEffective")

-- ======================= COMPACT GUI (auto‑scales to screen) =======================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BabisDeadlyGolf"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main panel (compact, fixed pixel size, positioned proportionally)
local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.new(0, 175, 0, 255)       -- narrow and short
panel.Position = UDim2.new(1, -185, 0.5, -127) -- right edge, vertically centered
panel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.Parent = screenGui
Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 12)

-- Title bar (draggable)
local titleBar = Instance.new("Frame", panel)
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
titleBar.BorderSizePixel = 0
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)
local titleBarCover = Instance.new("Frame", titleBar)
titleBarCover.Size = UDim2.new(1, 0, 0, 12)
titleBarCover.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
titleBarCover.BorderSizePixel = 0
titleBarCover.Position = UDim2.new(0, 0, 0, 12)

local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, -10, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 13
titleText.Text = "BABIS DEADLY GOLF"
titleText.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle button (small, combined enable/disable)
local toggleBtn = Instance.new("TextButton", panel)
toggleBtn.Size = UDim2.new(1, -16, 0, 28)
toggleBtn.Position = UDim2.new(0.5, 0, 0, 30)
toggleBtn.AnchorPoint = Vector2.new(0.5, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "🔴 DISABLED"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.AutoButtonColor = false
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

-- Info block (compact, single line for each info)
local function makeInfoLabel(yOffset, text)
    local lbl = Instance.new("TextLabel", panel)
    lbl.Size = UDim2.new(1, -16, 0, 14)
    lbl.Position = UDim2.new(0.5, 0, 0, yOffset)
    lbl.AnchorPoint = Vector2.new(0.5, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.Text = text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

local statusLabel = makeInfoLabel(64, "Status: Idle")
local distanceLabel = makeInfoLabel(80, "Dist: --")
local angleLabel = makeInfoLabel(96, "Angle: --°")
local powerLabel = makeInfoLabel(112, "Power: --%")
local obstacleLabel = makeInfoLabel(128, "Obstacle: --")

-- Power slider (0‑115%)
local sliderLabel = Instance.new("TextLabel", panel)
sliderLabel.Size = UDim2.new(1, -16, 0, 14)
sliderLabel.Position = UDim2.new(0.5, 0, 0, 148)
sliderLabel.AnchorPoint = Vector2.new(0.5, 0)
sliderLabel.BackgroundTransparency = 1
sliderLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 11
sliderLabel.Text = "Max Power: 100%"

local sliderBg = Instance.new("Frame", panel)
sliderBg.Size = UDim2.new(1, -16, 0, 10)
sliderBg.Position = UDim2.new(0.5, 0, 0, 164)
sliderBg.AnchorPoint = Vector2.new(0.5, 0)
sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBg.BorderSizePixel = 0
Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 5)

local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.Size = UDim2.new(1, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
sliderFill.BorderSizePixel = 0
Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0, 5)

local sliderBtn = Instance.new("TextButton", sliderBg)
sliderBtn.Size = UDim2.new(0, 14, 0, 14)
sliderBtn.Position = UDim2.new(1, -7, 0.5, -7)
sliderBtn.BackgroundColor3 = Color3.new(1, 1, 1)
sliderBtn.Text = ""
sliderBtn.BorderSizePixel = 0
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(0, 7)

local maxPower = 1.0  -- 0 .. 1.15
local function updateSlider()
    local ratio = math.clamp(maxPower / 1.15, 0, 1)
    sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
    sliderBtn.Position = UDim2.new(ratio, -7, 0.5, -7)
    sliderLabel.Text = "Max Power: " .. math.floor(maxPower * 100 + 0.5) .. "%"
end
updateSlider()

-- Slider drag
local sliderDragging = false
sliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = true
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local absPos = sliderBg.AbsolutePosition
        local absSize = sliderBg.AbsoluteSize
        local rawRatio = math.clamp((input.Position.X - absPos.X) / absSize.X, 0, 1)
        maxPower = rawRatio * 1.15
        updateSlider()
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliderDragging = false
    end
end)

-- Fire button with integrated progress
local strikeBtn = Instance.new("TextButton", panel)
strikeBtn.Size = UDim2.new(1, -16, 0, 32)
strikeBtn.Position = UDim2.new(0.5, 0, 1, -42)
strikeBtn.AnchorPoint = Vector2.new(0.5, 0)
strikeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 20)
strikeBtn.Text = "🔥 HOLD TO LAUNCH"
strikeBtn.TextColor3 = Color3.new(1, 1, 1)
strikeBtn.Font = Enum.Font.GothamBold
strikeBtn.TextSize = 12
Instance.new("UICorner", strikeBtn).CornerRadius = UDim.new(0, 6)

-- Progress bar inside the button (overlay)
local progressOverlay = Instance.new("Frame", strikeBtn)
progressOverlay.Size = UDim2.new(1, 0, 1, 0)
progressOverlay.BackgroundTransparency = 1
progressOverlay.BorderSizePixel = 0
local progressFill = Instance.new("Frame", progressOverlay)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
progressFill.BorderSizePixel = 0
progressFill.BackgroundTransparency = 0.3  -- semi‑transparent progress

-- Dragging the panel via title bar
local drag = false
local dragStartInput, dragStartPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        dragStartInput = input.Position
        dragStartPos = panel.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStartInput
        panel.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
                                   dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

-- Laser beam
local beam = Instance.new("Beam")
beam.Color = ColorSequence.new(Color3.new(0, 1, 0.3))
beam.Transparency = NumberSequence.new(0.35)
beam.Width0 = 0.2
beam.Width1 = 0.2
beam.FaceCamera = true
beam.Enabled = false
beam.Parent = Workspace.Terrain

local attach0 = Instance.new("Attachment", Workspace.Terrain)
local attach1 = Instance.new("Attachment", Workspace.Terrain)
beam.Attachment0 = attach0
beam.Attachment1 = attach1

-- ======================= CORRECT TAG‑BASED DETECTION =======================
local function getYourBallPart()
    for _, part in CollectionService:GetTagged("RigidSync") do
        if part:IsA("BasePart") and part:GetAttribute("RigidSyncId") == player.UserId then
            return part
        end
    end
    return nil
end

local function getHolePosition()
    for _, obj in CollectionService:GetTagged("EndPoint") do
        if obj:IsA("BasePart") then return obj.Position
        elseif obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart.Position
        elseif obj:IsA("Attachment") then return obj.WorldPosition
        end
    end
    return nil
end

-- ======================= AIMBOT STATE & COMPUTATION =======================
local aimbotEnabled = false
local currentAngle = 0
local currentPower = 0
local bestFlatDir = Vector3.new(0, 0, -1)

function computeBestShot()
    local ballPart = getYourBallPart()
    local holePos = getHolePosition()
    if not ballPart or not holePos then
        beam.Enabled = false
        if aimbotEnabled then
            statusLabel.Text = "Status: No ball/hole"
        end
        return
    end

    -- Laser beam
    attach0.WorldPosition = ballPart.Position
    attach1.WorldPosition = holePos
    beam.Enabled = aimbotEnabled

    -- Obstacle detection (simple raycast)
    local obstacleText = "None"
    if aimbotEnabled then
        local rayOrigin = ballPart.Position
        local rayDir = (holePos - rayOrigin).Unit
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Blacklist
        rayParams.FilterDescendantsInstances = {ballPart}
        local rayResult = Workspace:Raycast(rayOrigin, rayDir * 1000, rayParams)
        if rayResult then
            local hitPart = rayResult.Instance
            -- exclude the hole object
            local isHolePart = false
            for _, obj in CollectionService:GetTagged("EndPoint") do
                if obj == hitPart or (obj:IsA("Model") and obj:FindFirstChild(hitPart.Name)) then
                    isHolePart = true
                    break
                end
            end
            if not isHolePart then
                obstacleText = hitPart.Name
            end
        end
    end
    obstacleLabel.Text = "Obstacle: " .. obstacleText

    if not aimbotEnabled then return end
    if not endPoint or not endPoint.ComputeTarget then
        statusLabel.Text = "Status: Module missing"
        return
    end

    local ballPos = ballPart.Position
    local toHole = holePos - ballPos
    local flatDir = Vector3.new(toHole.X, 0, toHole.Z)
    if flatDir.Magnitude < 0.001 then flatDir = Vector3.new(0, 0, -1) end
    flatDir = flatDir.Unit

    -- Scan loft angles 0‑85° (step 2) for minimal power
    local best = nil
    local minPower = math.huge
    for loftDeg = 0, 85, 2 do
        local loftRad = math.rad(loftDeg)
        local result = endPoint.ComputeTarget(ballPos, flatDir, loftRad, maxPower)
        if result and result.powerRatio and result.powerRatio <= maxPower then
            if result.powerRatio < minPower then
                best = {
                    angle = loftDeg,
                    power = result.powerRatio,
                    dir = result.flatDir
                }
                minPower = result.powerRatio
            end
        end
    end

    if best then
        currentAngle = best.angle
        currentPower = math.min(best.power, maxPower)
        bestFlatDir = best.dir
        statusLabel.Text = "Status: Optimal"
    else
        -- Fallback: 45° at max power
        currentAngle = 45
        currentPower = maxPower
        bestFlatDir = flatDir
        statusLabel.Text = "Status: Unreachable"
    end

    if swing then pcall(function() swing.SetAngle(currentAngle) end) end
    local dist = toHole.Magnitude
    distanceLabel.Text = "Dist: " .. string.format("%.1f", dist)
    angleLabel.Text = "Angle: " .. currentAngle .. "°"
    powerLabel.Text = "Power: " .. math.floor(currentPower * 100 + 0.5) .. "%"
end

-- ======================= FIRE WITH HOMING =======================
local function fireStrikeAndHoming()
    local ballPart = getYourBallPart()
    local holePos = getHolePosition()
    if not ballPart or not holePos or not golfStrike then return end
    if golfStrike.IsBallStrikeable and not golfStrike.IsBallStrikeable() then
        strikeBtn.Text = "⛔ Not ready"
        task.delay(0.6, function() strikeBtn.Text = "🔥 HOLD TO LAUNCH" end)
        return
    end

    local minSpeed = golfConfig and golfConfig.minStrikeSpeed or 30
    local maxSpeed = golfConfig and golfConfig.maxStrikeSpeed or 80
    local speed = minSpeed + (maxSpeed - minSpeed) * currentPower
    local loftRad = math.rad(currentAngle)
    local velocity = (bestFlatDir * math.cos(loftRad) + Vector3.new(0, 1, 0) * math.sin(loftRad)).Unit * speed

    local rawPowerRatio = powerConv and powerConv.GetRawPowerRatioFromEffective(currentPower, 1.0) or currentPower
    local strikeData = {
        velocity = velocity,
        rawPowerPercent = rawPowerRatio * 100,
        rawAngle = currentAngle,
        powerPercent = currentPower * 100,
        angle = currentAngle
    }

    local success = golfStrike.Strike(ballPart, strikeData, nil, "ball")
    if not success then
        strikeBtn.Text = "❌ Failed"
        task.delay(0.6, function() strikeBtn.Text = "🔥 HOLD TO LAUNCH" end)
        return
    end

    strikeBtn.Text = "🎯 HOMING ACTIVE"
    statusLabel.Text = "Status: Homing..."

    -- Activate homing after physics kick‑in
    task.delay(0.08, function()
        if not rigidSim then return end
        local targetBodyId = nil
        for _, body in pairs(rigidSim.GetOrderedBodies()) do
            if body.part == ballPart then
                targetBodyId = body.id
                break
            end
        end
        if targetBodyId and holePos then
            rigidSim.SetHoming(targetBodyId, holePos, 200)  -- aggressive turn
            statusLabel.Text = "Status: Homing active"
        else
            statusLabel.Text = "Status: Homing failed"
        end
    end)

    task.delay(0.8, function()
        strikeBtn.Text = "🔥 HOLD TO LAUNCH"
    end)
end

-- Toggle enable
function setEnabled(state)
    aimbotEnabled = state
    toggleBtn.Text = state and "🟢 ENABLED" or "🔴 DISABLED"
    toggleBtn.BackgroundColor3 = state and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(200, 50, 50)
    beam.Enabled = state
    if not state then
        angleLabel.Text = "Angle: --°"
        powerLabel.Text = "Power: --%"
        distanceLabel.Text = "Dist: --"
        obstacleLabel.Text = "Obstacle: --"
        statusLabel.Text = "Status: Idle"
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    setEnabled(not aimbotEnabled)
end)

-- Hold‑to‑fire with progress
local holdActive = false
local holdCancel = false
local holdStart = 0
local HOLD_DURATION = 0.3

RunService.RenderStepped:Connect(function()
    if holdActive and not holdCancel then
        local elapsed = tick() - holdStart
        local progress = math.clamp(elapsed / HOLD_DURATION, 0, 1)
        progressFill.Size = UDim2.new(progress, 0, 1, 0)
        if elapsed >= HOLD_DURATION then
            fireStrikeAndHoming()
            holdActive = false
            progressFill.Size = UDim2.new(0, 0, 1, 0)
        end
    end
end)

strikeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if not aimbotEnabled then return end
        holdActive = true
        holdCancel = false
        holdStart = tick()
        strikeBtn.Text = "⏳ HOLDING..."
        strikeBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    end
end)

strikeBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        if holdActive then
            holdCancel = true
            holdActive = false
            strikeBtn.Text = "🔥 HOLD TO LAUNCH"
            strikeBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 20)
            progressFill.Size = UDim2.new(0, 0, 1, 0)
        end
    end
end)

-- Main update loop
RunService.RenderStepped:Connect(computeBestShot)

setEnabled(false)
print("✅ BABIS DEADLY GOLF AIMBOT – Compact precision + homing ready.")