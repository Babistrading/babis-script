--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]

-- ============ ANTI-CHEAT BYPASS (rivals-ac) ============
-- github.com/swish-hub/rivals-ac
-- beta bypass – neutralizes LocalScript3 & MiscellaneousController

local oldtable; oldtable = hookfunction(getrenv().setmetatable, newcclosure(function(Table, Metatable)
    if Metatable and typeof(Metatable) == "table" and rawget(Metatable, "__mode") == "kv" then
        local trace = debug.traceback()
        if trace:find("LocalScript3") or trace:find("MiscellaneousController") then
            return oldtable({1, 2, 3}, {})
        end
    end
    return oldtable(Table, Metatable)
end)) -- credits: milkyboy / swish hub

local oldgc = getgc; getgc = function(...)
    local gc = oldgc(...)
    local filtered = {}
    for _, v in ipairs(gc) do
        if typeof(v) == "function" then
            local src = debug.info(v, "s")
            if not (src and (src:find("LocalScript3") or src:find("MiscellaneousController"))) then
                table.insert(filtered, v)
            end
        else
            table.insert(filtered, v)
        end
    end
    return filtered
end

for _, v in getgc() do
    if typeof(v) == "function" then
        local src = debug.info(v, "s")
        if src and (src:find("LocalScript3") or src:find("MiscellaneousController")) then
            hookfunction(v, newcclosure(function()
                return task.wait(9e9)
            end))
        end
    end
end

-- ============ BABIS FULL SCRIPT ============
--[[
    Babis - Full Script
    Custom Aimbot + Desync + ESP + Misc
    All credits: Babis
--]]

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- // Settings
getgenv().BabisSettings = {
    Aimbot = {
        Enabled = false,
        AimPart = "HumanoidRootPart",  -- "Head" or "HumanoidRootPart"
        TeamCheck = false,
        WallCheck = false,
        Smoothness = 1
    },
    Desync = {
        Enabled = false,
        Offset = 5,                     -- vertical offset (studs down)
        Mode = "Down",                  -- "Down", "Random", "Jitter"
        JitterSpeed = 20
    },
    ESP = {
        Enabled = false,
        ShowBox = false,
        BoxType = "2D",
        ShowName = false,
        ShowHealth = false,
        ShowTracer = false,
        TracerPosition = "Bottom",
        ShowDistance = false,
        ShowSkeleton = false,
        TeamCheck = false
    },
    Misc = {
        InfiniteJump = false,
        WalkSpeed = 16
    }
}

-- ==================== CLASSIC AIMBOT ====================
local aimbotConnection
local function getClosestTarget()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myRoot = char.HumanoidRootPart
    local aimPartName = getgenv().BabisSettings.Aimbot.AimPart
    local teamCheck = getgenv().BabisSettings.Aimbot.TeamCheck
    local wallCheck = getgenv().BabisSettings.Aimbot.WallCheck
    local nearest, minDist = nil, math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if teamCheck and player.Team == LocalPlayer.Team then continue end
        local targetChar = player.Character
        if not targetChar then continue end
        local targetPart = targetChar:FindFirstChild(aimPartName)
        local humanoid = targetChar:FindFirstChild("Humanoid")
        if not targetPart or not humanoid or humanoid.Health <= 0 then continue end

        local dist = (targetPart.Position - myRoot.Position).Magnitude
        if dist >= minDist then continue end

        if wallCheck then
            local rayOrigin = Camera.CFrame.Position
            local rayDirection = (targetPart.Position - rayOrigin).Unit * 1000
            local ignoreList = {char, targetChar}
            local hit = Workspace:FindPartOnRayWithIgnoreList(Ray.new(rayOrigin, rayDirection), ignoreList)
            if hit and not hit:IsDescendantOf(targetChar) then continue end
        end

        minDist = dist
        nearest = targetPart
    end
    return nearest
end

local function startAimbot()
    if aimbotConnection then aimbotConnection:Disconnect() end
    aimbotConnection = RunService.RenderStepped:Connect(function(deltaTime)
        local target = getClosestTarget()
        if target then
            local smoothness = getgenv().BabisSettings.Aimbot.Smoothness
            local desiredLook = CFrame.lookAt(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(desiredLook, math.min(1, smoothness * deltaTime * 10))
        end
    end)
end

local function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
end

-- ==================== CONTINUOUS DESYNC ====================
local desyncConnection
local function startDesync()
    if desyncConnection then desyncConnection:Disconnect() end
    desyncConnection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        -- Save original state
        local origCF = root.CFrame
        local origVel = root.Velocity
        local origRotVel = root.RotVelocity

        -- Calculate fake position
        local settings = getgenv().BabisSettings.Desync
        local offsetVector
        if settings.Mode == "Down" then
            offsetVector = Vector3.new(0, -settings.Offset, 0)
        elseif settings.Mode == "Random" then
            offsetVector = Vector3.new(
                math.random(-settings.Offset, settings.Offset) * 0.5,
                -settings.Offset,
                math.random(-settings.Offset, settings.Offset) * 0.5
            )
        elseif settings.Mode == "Jitter" then
            offsetVector = Vector3.new(
                math.sin(tick() * settings.JitterSpeed) * settings.Offset * 0.3,
                -settings.Offset,
                math.cos(tick() * settings.JitterSpeed) * settings.Offset * 0.3
            )
        end

        root.CFrame = origCF + offsetVector

        -- Restore after rendering (so only server and others see fake pos)
        RunService:BindToRenderStep("DesyncRestore", 101, function()
            root.CFrame = origCF
            root.Velocity = origVel
            root.RotVelocity = origRotVel
            RunService:UnbindFromRenderStep("DesyncRestore")
        end)
    end)
end

local function stopDesync()
    if desyncConnection then
        desyncConnection:Disconnect()
        desyncConnection = nil
    end
end

-- ==================== ESP (DRAWING) ====================
local espObjects = {}
local function clearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Remove() end)
    end
    table.clear(espObjects)
end

local function createESP(player)
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not (humanoid and root and head) or humanoid.Health <= 0 then return end

    local s = getgenv().BabisSettings.ESP
    if s.TeamCheck and player.Team == LocalPlayer.Team then return end

    if s.ShowBox then
        local boxOut = Drawing.new("Square"); boxOut.Thickness = 3; boxOut.Filled = false; boxOut.Color = Color3.new(1,1,1); boxOut.Visible = false; table.insert(espObjects, boxOut)
        local boxIn = Drawing.new("Square"); boxIn.Thickness = 1; boxIn.Filled = false; boxIn.Color = Color3.new(1,1,1); boxIn.Visible = false; table.insert(espObjects, boxIn)
    end
    if s.ShowName then
        local txt = Drawing.new("Text"); txt.Text = player.Name; txt.Size = 13; txt.Center = true; txt.Outline = true; txt.Color = Color3.new(1,1,1); txt.Visible = false; table.insert(espObjects, txt)
    end
    if s.ShowHealth then
        local out = Drawing.new("Square"); out.Thickness = 1; out.Filled = false; out.Color = Color3.new(0,0,0); out.Visible = false; table.insert(espObjects, out)
        local fill = Drawing.new("Square"); fill.Filled = true; fill.Visible = false; table.insert(espObjects, fill)
    end
    if s.ShowTracer then
        local line = Drawing.new("Line"); line.Thickness = 2; line.Color = Color3.new(1,1,1); line.Visible = false; table.insert(espObjects, line)
    end
    if s.ShowDistance then
        local txt = Drawing.new("Text"); txt.Size = 13; txt.Center = true; txt.Outline = true; txt.Color = Color3.new(1,1,1); txt.Visible = false; table.insert(espObjects, txt)
    end
    if s.ShowSkeleton then
        for i = 1, 12 do
            local line = Drawing.new("Line"); line.Thickness = 1; line.Color = Color3.new(1,1,1); line.Visible = false; table.insert(espObjects, line)
        end
    end
end

local function worldToScreen(pos)
    local screenPos, onScreen = Camera:WorldToViewportPoint(pos)
    return Vector2.new(screenPos.X, screenPos.Y), onScreen, screenPos.Z
end

local function updateESP()
    clearESP()
    if not getgenv().BabisSettings.ESP.Enabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then createESP(player) end
    end
end

local function drawESP()
    local s = getgenv().BabisSettings.ESP
    if not s.Enabled then return end

    local idx = 1
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        local char = player.Character
        if not char then continue end
        local humanoid = char:FindFirstChild("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not (humanoid and root and head) or humanoid.Health <= 0 then continue end
        if s.TeamCheck and player.Team == LocalPlayer.Team then continue end

        local headPos, headVis = worldToScreen(head.Position + Vector3.new(0,0.5,0))
        local rootPos, rootVis = worldToScreen(root.Position)
        if not (headVis or rootVis) then
            if s.ShowBox then idx += 2 end
            if s.ShowName then idx += 1 end
            if s.ShowHealth then idx += 2 end
            if s.ShowTracer then idx += 1 end
            if s.ShowDistance then idx += 1 end
            if s.ShowSkeleton then idx += 12 end
            continue
        end

        local topY = headPos.Y
        local bottomY = rootPos.Y
        local height = math.abs(topY - bottomY)
        local width = height / 2
        local centerX = (headPos.X + rootPos.X) / 2

        -- Box
        if s.ShowBox then
            local boxOut = espObjects[idx]; idx += 1
            local boxIn = espObjects[idx]; idx += 1
            if boxOut and boxIn then
                local x = centerX - width/2
                boxOut.Position = Vector2.new(x, topY)
                boxOut.Size = Vector2.new(width, height)
                boxOut.Visible = true
                boxIn.Position = Vector2.new(x, topY)
                boxIn.Size = Vector2.new(width, height)
                boxIn.Visible = true
            end
        end

        -- Name
        if s.ShowName then
            local txt = espObjects[idx]; idx += 1
            if txt then
                txt.Position = Vector2.new(centerX, topY - 15)
                txt.Visible = true
            end
        end

        -- Health
        if s.ShowHealth then
            local out = espObjects[idx]; idx += 1
            local fill = espObjects[idx]; idx += 1
            if out and fill then
                local barX = centerX - width/2 - 8
                out.Position = Vector2.new(barX, topY)
                out.Size = Vector2.new(3, height)
                out.Visible = true

                local hpPercent = humanoid.Health / humanoid.MaxHealth
                local fillHeight = height * hpPercent
                fill.Position = Vector2.new(barX, topY + height - fillHeight)
                fill.Size = Vector2.new(3, fillHeight)
                fill.Color = hpPercent > 0.5 and Color3.new(0,1,0) or Color3.new(1,0,0)
                fill.Visible = true
            end
        end

        -- Tracer
        if s.ShowTracer then
            local line = espObjects[idx]; idx += 1
            if line then
                local from
                if s.TracerPosition == "Bottom" then
                    from = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                elseif s.TracerPosition == "Top" then
                    from = Vector2.new(Camera.ViewportSize.X/2, 0)
                else
                    from = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                end
                line.From = from
                line.To = rootPos
                line.Visible = true
            end
        end

        -- Distance
        if s.ShowDistance then
            local txt = espObjects[idx]; idx += 1
            if txt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
                txt.Text = dist .. "m"
                txt.Position = Vector2.new(centerX, bottomY + 5)
                txt.Visible = true
            end
        end

        -- Skeleton
        if s.ShowSkeleton then
            local startIdx = idx
            idx += 12
            local lines = {}
            for i = 1, 12 do lines[i] = espObjects[startIdx + i - 1] end
            local function connect(b1, b2, i)
                if b1 and b2 and lines[i] then
                    local p1, v1 = worldToScreen(b1.Position)
                    local p2, v2 = worldToScreen(b2.Position)
                    if v1 and v2 then
                        lines[i].From = p1
                        lines[i].To = p2
                        lines[i].Visible = true
                    else
                        lines[i].Visible = false
                    end
                end
            end
            local headBone = head
            local torso = char:FindFirstChild("UpperTorso")
            local lowerTorso = char:FindFirstChild("LowerTorso")
            local lUpperArm = char:FindFirstChild("LeftUpperArm")
            local lLowerArm = char:FindFirstChild("LeftLowerArm")
            local lHand = char:FindFirstChild("LeftHand")
            local rUpperArm = char:FindFirstChild("RightUpperArm")
            local rLowerArm = char:FindFirstChild("RightLowerArm")
            local rHand = char:FindFirstChild("RightHand")
            local lUpperLeg = char:FindFirstChild("LeftUpperLeg")
            local lLowerLeg = char:FindFirstChild("LeftLowerLeg")
            local lFoot = char:FindFirstChild("LeftFoot")
            local rUpperLeg = char:FindFirstChild("RightUpperLeg")
            local rLowerLeg = char:FindFirstChild("RightLowerLeg")
            local rFoot = char:FindFirstChild("RightFoot")

            if torso then
                connect(headBone, torso, 1)
                if lowerTorso then connect(torso, lowerTorso, 2) end
                if lUpperArm then connect(torso, lUpperArm, 3) end
                if rUpperArm then connect(torso, rUpperArm, 6) end
            end
            if lUpperArm and lLowerArm then connect(lUpperArm, lLowerArm, 4) end
            if lLowerArm and lHand then connect(lLowerArm, lHand, 5) end
            if rUpperArm and rLowerArm then connect(rUpperArm, rLowerArm, 7) end
            if rLowerArm and rHand then connect(rLowerArm, rHand, 8) end
            if lowerTorso then
                if lUpperLeg then connect(lowerTorso, lUpperLeg, 9) end
                if rUpperLeg then connect(lowerTorso, rUpperLeg, 11) end
            end
            if lUpperLeg and lLowerLeg then connect(lUpperLeg, lLowerLeg, 10) end
            if rUpperLeg and rLowerLeg then connect(rUpperLeg, rLowerLeg, 12) end
        end
    end
end

-- ==================== GUI (RAYFIELD) ====================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Babis",
    Icon = 0,
    LoadingTitle = "Babis",
    LoadingSubtitle = "by Babis",
    Theme = "Ocean",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BabisHub",
        FileName = "BabisConfig"
    }
})

-- Tabs
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local DesyncTab = Window:CreateTab("Desync", 4483362458)
local ESPTab = Window:CreateTab("ESP", "rewind")
local MiscTab = Window:CreateTab("Misc", 4483362458)
local InfoTab = Window:CreateTab("Info", 4483362458)

-- ===== Aimbot =====
AimbotTab:CreateSection("Classic Aimbot")

AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Callback = function(val)
        getgenv().BabisSettings.Aimbot.Enabled = val
        if val then startAimbot() else stopAimbot() end
    end
})

AimbotTab:CreateButton({
    Name = "Switch Aim Part (HRP/Head)",
    Callback = function()
        local cur = getgenv().BabisSettings.Aimbot.AimPart
        getgenv().BabisSettings.Aimbot.AimPart = (cur == "HumanoidRootPart") and "Head" or "HumanoidRootPart"
        Rayfield:Notify({Title = "Babis", Content = "Aim Part: " .. getgenv().BabisSettings.Aimbot.AimPart})
    end
})

AimbotTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.Aimbot.TeamCheck = val end
})

AimbotTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.Aimbot.WallCheck = val end
})

AimbotTab:CreateSlider({
    Name = "Smoothness",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(val) getgenv().BabisSettings.Aimbot.Smoothness = val end
})

-- ===== Desync =====
DesyncTab:CreateSection("Position Desync (Anti-Aim)")

DesyncTab:CreateToggle({
    Name = "Enable Desync",
    CurrentValue = false,
    Callback = function(val)
        getgenv().BabisSettings.Desync.Enabled = val
        if val then startDesync() else stopDesync() end
    end
})

DesyncTab:CreateSlider({
    Name = "Offset (studs)",
    Range = {1, 15},
    Increment = 1,
    CurrentValue = 5,
    Callback = function(val) getgenv().BabisSettings.Desync.Offset = val end
})

DesyncTab:CreateDropdown({
    Name = "Mode",
    Options = {"Down", "Random", "Jitter"},
    CurrentOption = {"Down"},
    Callback = function(val) getgenv().BabisSettings.Desync.Mode = val[1] end
})

DesyncTab:CreateSlider({
    Name = "Jitter Speed",
    Range = {5, 50},
    Increment = 5,
    CurrentValue = 20,
    Callback = function(val) getgenv().BabisSettings.Desync.JitterSpeed = val end
})

-- ===== ESP =====
ESPTab:CreateSection("Visual Settings")

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Callback = function(val)
        getgenv().BabisSettings.ESP.Enabled = val
        updateESP()
    end
})

ESPTab:CreateToggle({
    Name = "Show Box",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.ESP.ShowBox = val; updateESP() end
})

ESPTab:CreateToggle({
    Name = "Show Name",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.ESP.ShowName = val; updateESP() end
})

ESPTab:CreateToggle({
    Name = "Show Health",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.ESP.ShowHealth = val; updateESP() end
})

ESPTab:CreateToggle({
    Name = "Show Tracer",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.ESP.ShowTracer = val; updateESP() end
})

ESPTab:CreateToggle({
    Name = "Show Distance",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.ESP.ShowDistance = val; updateESP() end
})

ESPTab:CreateToggle({
    Name = "Show Skeleton",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.ESP.ShowSkeleton = val; updateESP() end
})

ESPTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.ESP.TeamCheck = val; updateESP() end
})

ESPTab:CreateDropdown({
    Name = "Box Type",
    Options = {"2D", "Corner"},
    CurrentOption = {"2D"},
    Callback = function(val) getgenv().BabisSettings.ESP.BoxType = val[1] end
})

ESPTab:CreateDropdown({
    Name = "Tracer Position",
    Options = {"Bottom", "Top", "Middle"},
    CurrentOption = {"Bottom"},
    Callback = function(val) getgenv().BabisSettings.ESP.TracerPosition = val[1] end
})

-- ===== Misc =====
MiscTab:CreateSection("Miscellaneous")

MiscTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(val) getgenv().BabisSettings.Misc.InfiniteJump = val end
})

MiscTab:CreateSlider({
    Name = "Walk Speed",
    Range = {0, 200},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 16,
    Callback = function(val)
        getgenv().BabisSettings.Misc.WalkSpeed = val
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end
})

-- ===== Info =====
InfoTab:CreateLabel("Script by Babis", 4483362458, Color3.fromRGB(255,255,255), false)
InfoTab:CreateLabel("UI Library: Rayfield", 4483362458, Color3.fromRGB(255,255,255), false)

-- ==================== LOOPS & EVENTS ====================
RunService.RenderStepped:Connect(drawESP)

UserInputService.JumpRequest:Connect(function()
    if getgenv().BabisSettings.Misc.InfiniteJump then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = getgenv().BabisSettings.Misc.WalkSpeed
end)

-- Cleanup on script removal
script.Destroying:Connect(function()
    stopAimbot()
    stopDesync()
    clearESP()
end)