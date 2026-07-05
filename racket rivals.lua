--[[ Protected by Lua Guard ]]

-- =====================================================
--  Racket Rivals – Babis Rush + Auto Swing (FINAL FIX)
--  - Holds swing for power (configurable)
--  - Waits after ball despawns (20s default, adjustable)
--  - No rotation, ball always stays in front
--  - Smooth movement, PC + Mobile
--  - Camera Lock: dynamically follows the ball from behind
--    (_IIlIIlIIlI resets to normal when ball is lost)
--  - Wide rectangular two‑column UI (Racket Rivals)
--  - Auto Refresh Rush: toggles rush off/on only when
--    ball is lost, resetting detection immediately
-- =====================================================

local Players          = game:GetService("\080\108\097\121\101\114\115")
local RunService       = game:GetService("\082\117\110\083\101\114\118\105\099\101")
local UserInputService = game:GetService("\085\115\101\114\073\110\112\117\116\083\101\114\118\105\099\101")
local TweenService     = game:GetService("\084\119\101\101\110\083\101\114\118\105\099\101")
local _IlllllIlII        = game:GetService("\087\111\114\107\115\112\097\099\101")
local _IllIllllIl = game:GetService("\086\105\114\116\117\097\108\073\110\112\117\116\077\097\110\097\103\101\114")

local _lIIIllIlII = Players.LocalPlayer
local _IlIllllIII = _lIIIllIlII:WaitForChild("\080\108\097\121\101\114\071\117\105")
if not _IlIllllIII then return end

-- ========== CONFIG ==========
local _lIllIlllll = 0x3
local _IIIIllllll = 0x0
local _IIIllllIII = 0xF

local _llIIllIIII = 0x50
local _lIIlIIlllI = 0x14
local _IIIlIlIIII = 0xC8

local _lllIlIllIl = 0.3
local _lIIIIIIIIl = 0.1
local _IlIIlIIIII = 1.0

local _IIIIIlIIIl = 0x4            -- _IlllIlIIll in front of ball (studs)
local _IllIIlIlII = 0x0
local _lIllIllIII = 0xC

-- hold swing for power
local _lIIlllIlll = 0.2            -- how long to hold the swing (seconds)
local _lIIIlIIIlI = 0.05
local _lllIIIlIlI = 1.0

-- time to wait after ball is lost before scanning again
local _IlIIlIlIll = 0x14        -- seconds
local _llIlllIlII = 0x5
local _IlIIIlIIII = 0x3C

-- _IIlIIlIIlI lock settings
local _IIIlIlIlll = 0xA        -- studs behind _lIIIllIlII
local _IIlllIllll = 0x5
local _IIIlIIllIl = 0x19
local _lIlIlIIlII = 0x2           -- studs above _lIIIllIlII
local _IlIIlIlIIl = 0x1
local _lllIllllII = 0xA

-- auto refresh rush (only when ball lost)
local _llIIIIlIlI = false
local _IllIIIIIll = 0x3        -- seconds between re‑attempts
local _IlIlIIIIlI = 0x1
local _lIlIlIlIII = 0x14

-- ========== STATE ==========
local _IIIIllIIIl = false
local _IllllIIIll = false
local _llllIllllI = false
local _IIllllIlIl = nil
local _lllllllIII = false
local _lIIllIlIIl = nil
local _IIllIIIllI = 0x0

local _IIIIIIIIIl = nil
local _IlIIllIlIl = false
local _IlllIIllII = 0x0

-- ========== FIND THE CLOSEST BALLSHADOW ==========
local function _llIIIIIIIl()
    local _IIIlIllllI = {}

    local _IlllIIIllI, result = pcall(function()
        return game:GetChildren()[0x1]:GetChildren()[0x15]:GetChildren()[0x4]
    end)
    if _IlllIIIllI and result and result:IsA("\066\097\115\101\080\097\114\116") then
        table.insert(_IIIlIllllI, result)
    end

    _IlllIIIllI, result = pcall(function()
        return getnilinstances and getnilinstances() or {}
    end)
    if _IlllIIIllI then
        for _, obj in ipairs(result) do
            if obj:IsA("\066\097\115\101\080\097\114\116") and obj.Name == "\066\097\108\108\083\104\097\100\111\119" then
                table.insert(_IIIlIllllI, obj)
            end
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("\066\097\115\101\080\097\114\116") and obj.Name == "\066\097\108\108\083\104\097\100\111\119" then
            table.insert(_IIIlIllllI, obj)
        end
    end

    return _IIIlIllllI
end

local function _lIlIIIlllI()
    local _lIlIlIllll = _llIIIIIIIl()
    if #_lIlIlIllll == 0x0 then return nil end
    if #_lIlIlIllll == 0x1 then return _lIlIlIllll[0x1] end

    local _lIIIIIlIlI = _lIIIllIlII.Character and _lIIIllIlII.Character:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
    if not _lIIIIIlIlI then return _lIlIlIllll[0x1] end

    local _llIlllIIIl = _lIlIlIllll[0x1]
    local _lIIIIlIlII = (_lIIIIIlIlI.Position - _llIlllIIIl.Position).Magnitude
    for i = 0x2, #_lIlIlIllll do
        local _IlIllIIllI = (_lIIIIIlIlI.Position - _lIlIlIllll[i].Position).Magnitude
        if _IlIllIIllI < _lIIIIlIlII then
            _lIIIIlIlII = _IlIllIIllI
            _llIlllIIIl = _lIlIlIllll[i]
        end
    end
    return _llIlllIIIl
end

local function _IllIlIllll(_llIlIIIlII)
    return _llIlIIIlII.Position + Vector3.new(0x0, _llIlIIIlII.Size.Y / 0x2 + _lIllIlllll, 0x0)
end

local function _IlIIllllIl()
    local _lIIlIIIIIl = _lIIIllIlII.Character
    return _lIIlIIIIIl and _lIIlIIIIIl:FindFirstChild("\072\117\109\097\110\111\105\100\082\111\111\116\080\097\114\116")
end

-- ========== ANIMATION CONTROL ==========
local function _IllIIllIlI(character)
    local _lIlIIIlIlI = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
    if not _lIlIIIlIlI then return end
    _lIlIIIlIlI.AutoRotate = false
    _lIlIIIlIlI.PlatformStand = true
    local _IlIlIIIlII = _lIlIIIlIlI:FindFirstChildOfClass("\065\110\105\109\097\116\111\114")
    if _IlIlIIIlII then
        for _, track in ipairs(_IlIlIIIlII:GetPlayingAnimationTracks()) do
            track:Stop(0x0)
        end
    end
    _IlIIllIlIl = true
end

local function _IIlIIIIlIl(character)
    local _lIlIIIlIlI = character and character:FindFirstChildOfClass("\072\117\109\097\110\111\105\100")
    if not _lIlIIIlIlI then return end
    _lIlIIIlIlI.AutoRotate = true
    _lIlIIIlIlI.PlatformStand = false
    _IlIIllIlIl = false
end

local function _llIIllIllI()
    local _lIIlIIIIIl = _lIIIllIlII.Character
    if not _lIIlIIIIIl then return end
    if _IIIIllIIIl or _IllllIIIll then
        _IllIIllIlI(_lIIlIIIIIl)
    else
        _IIlIIIIlIl(_lIIlIIIIIl)
    end
end

-- ========== SWING (with hold for power) ==========
local function _IlIllIlIlI()
    local _lIIlIIIIIl = _lIIIllIlII.Character
    if not _lIIlIIIIIl then return end

    local _lIlllIIIII = _lIIlIIIIIl:FindFirstChildOfClass("\084\111\111\108") or _lIIIllIlII.Backpack:FindFirstChildOfClass("\084\111\111\108")
    if _lIlllIIIII and (_lIlllIIIII.Name:lower():find("\114\097\099\107\101\116") or _lIlllIIIII.Name:lower():find("\114\097\113\117\101\116\116\101")) then
        pcall(function()
            _lIlllIIIII:Activate()
            task.wait(_lIIlllIlll)
            _lIlllIIIII:Deactivate()
        end)
        return
    end

    pcall(function()
        _IllIllllIl:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(_lIIlllIlll)
        _IllIllllIl:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end)
end

-- ========== RUSH LOOP ==========
local function _llllIIIllI()
    local _IIlIIlIIlI = workspace.CurrentCamera
    if _IIlIIlIIlI then
        _IIlIIlIIlI.CameraType = Enum.CameraType.Custom
    end
end

local function _lIIlllIlII()
    if _IIllllIlIl then _IIllllIlIl:Disconnect() end
    _IIllIIIllI = tick()
    _IIIIIIIIIl = nil

    _IIllllIlIl = RunService.RenderStepped:Connect(function(dt)
        local _llIlIIIlII = _lIlIIIlllI()
        local _lIIIIIlIlI = _IlIIllllIl()

        -- unlock _IIlIIlIIlI if no ball and _IIlIIlIIlI lock is on
        if not _llIlIIIlII and _llllIllllI then
            _llllIIIllI()
        end

        -- ball lost handling
        if not _llIlIIIlII then
            if not _IIIIIIIIIl then
                _IIIIIIIIIl = tick()
            end
            if tick() - _IIIIIIIIIl < _IlIIlIlIll then
                return
            end
            return
        else
            _IIIIIIIIIl = nil
        end

        if not _lIIIIIlIlI then return end

        -- ===== AUTO REFRESH RUSH (reactive: only when ball is lost) =====
        -- toggles rush off/on once after _IllIIIIIll seconds to force a re‑scan
        if _llIIIIlIlI and _IIIIllIIIl then
            if not _llIlIIIlII and _IIIIIIIIIl then
                local _llIIlllIIl = tick()
                if _llIIlllIIl - _IlllIIllII >= _IllIIIIIll then
                    _IlllIIllII = _llIIlllIIl
                    _IIIIIIIIIl = nil   -- allow immediate re‑scan after re‑enable
                    _IIIIllIIIl = false
                    _IlIlllIIIl()
                    task.delay(0.05, function()
                        _IIIIllIIIl = true
                        _IlIlllIIIl()
                    end)
                end
            end
        end

        -- movement
        if _IIIIllIIIl then
            local _lllIIllIll = _IllIlIllll(_llIlIIIlII)
            local _IllIlIIIII = Vector3.new(
                _lllIIllIll.X,
                _lIIIIIlIlI.Position.Y,
                _lllIIllIll.Z - _IIIIIlIIIl
            )
            local _IIllIIlIII = (_IllIlIIIII - _lIIIIIlIlI.Position)
            local _IlllIlIIll = _IIllIIlIII.Magnitude
            if _IlllIlIIll > 0.1 then
                _IIllIIlIII = _IIllIIlIII.Unit
                local _lIIlIlllll = math.min(_llIIllIIII * dt, _IlllIlIIll)
                local _lIIlIIIIll = _lIIIIIlIlI.Position + _IIllIIlIII * _lIIlIlllll
                _lIIIIIlIlI.CFrame = _lIIIIIlIlI.CFrame - _lIIIIIlIlI.Position + _lIIlIIIIll
            end
        end

        -- auto swing
        if _IllllIIIll then
            local _llIIlllIIl = tick()
            if _llIIlllIIl - _IIllIIIllI >= _lllIlIllIl then
                _IlIllIlIlI()
                _IIllIIIllI = _llIIlllIIl
            end
        end

        -- _IIlIIlIIlI lock
        if _llllIllllI then
            local _IIlIIlIIlI = workspace.CurrentCamera
            if _IIlIIlIIlI and _lIIIIIlIlI and _llIlIIIlII then
                local _lIIIlIllll = _IllIlIllll(_llIlIIIlII)
                local _IIIlIllIll = _lIIIIIlIlI.Position
                local _IIIIllIIll = (_lIIIlIllll - _IIIlIllIll).Unit
                local _lIIlllllll = _IIIlIllIll - _IIIIllIIll * _IIIlIlIlll + Vector3.new(0x0, _lIlIlIIlII, 0x0)
                _IIlIIlIIlI.CameraType = Enum.CameraType.Scriptable
                _IIlIIlIIlI.CFrame = CFrame.lookAt(_lIIlllllll, _lIIIlIllll)
            end
        end
    end)

    _llIIllIllI()
end

local function _lIIIlIIIIl()
    if _IIllllIlIl then
        _IIllllIlIl:Disconnect()
        _IIllllIlIl = nil
    end
    _llllIIIllI()
    _llIIllIllI()
end

local function _IlIlllIIIl()
    if _IIIIllIIIl or _IllllIIIll or _llllIllllI then
        _lIIlllIlII()
    else
        _lIIIlIIIIl()
    end
end

-- ========== UI ==========
local _lllIIIllIl = UserInputService.TouchEnabled and 0.7 or 0x1

local _lIlIlIIlIl = Instance.new("\083\099\114\101\101\110\071\117\105")
_lIlIlIIlIl.Name = "\066\097\098\105\115\082\117\115\104\095\071\085\073"
_lIlIlIIlIl.ResetOnSpawn = false
_lIlIlIIlIl.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
_lIlIlIIlIl.Parent = _IlIllllIII

-- Floating button
local _lIIlIllIIl = Instance.new("\084\101\120\116\066\117\116\116\111\110")
_lIIlIllIIl.Size = UDim2.new(0x0, 0x34*_lllIIIllIl, 0x0, 0x34*_lllIIIllIl)
_lIIlIllIIl.Position = UDim2.new(0x1, -0x3C*_lllIIIllIl, 0x0, 0x14*_lllIIIllIl)
_lIIlIllIIl.BackgroundColor3 = Color3.fromRGB(0x0, 0x0, 0x0)
_lIIlIllIIl.Text = "\066"
_lIIlIllIIl.TextColor3 = Color3.fromRGB(0x0, 0xAA, 0xFF)
_lIIlIllIIl.TextSize = 0x1C
_lIIlIllIIl.Font = Enum.Font.GothamBold
_lIIlIllIIl.BorderSizePixel = 0x0
_lIIlIllIIl.AutoButtonColor = false
_lIIlIllIIl.ZIndex = 0xA
_lIIlIllIIl.Parent = _lIlIlIIlIl
Instance.new("\085\073\067\111\114\110\101\114", _lIIlIllIIl).CornerRadius = UDim.new(0x0, 0xA*_lllIIIllIl)
local _lIIllIlllI = Instance.new("\085\073\083\116\114\111\107\101", _lIIlIllIIl)
_lIIllIlllI.Color = Color3.fromRGB(0x0, 0xAA, 0xFF)
_lIIllIlllI.Thickness = 0x2
_lIIllIlllI.Transparency = 0.3

-- _llIIIIIlII panel
local _llIIIIIlII = Instance.new("\070\114\097\109\101")
_llIIIIIlII.Size = UDim2.new(0x0, 0x1B8*_lllIIIllIl, 0x0, 0x17C*_lllIIIllIl)
_llIIIIIlII.Position = UDim2.new(0.5, -0xDC*_lllIIIllIl, 0.5, -0xBE*_lllIIIllIl)
_llIIIIIlII.BackgroundColor3 = Color3.fromRGB(0xA,0xA,0xA)
_llIIIIIlII.BorderSizePixel = 0x0
_llIIIIIlII.Visible = false
_llIIIIIlII.ClipsDescendants = true
_llIIIIIlII.ZIndex = 0x14
_llIIIIIlII.Parent = _lIlIlIIlIl
Instance.new("\085\073\067\111\114\110\101\114", _llIIIIIlII).CornerRadius = UDim.new(0x0, 0xA*_lllIIIllIl)
local _IIIIIlIIll = Instance.new("\085\073\083\116\114\111\107\101", _llIIIIIlII)
_IIIIIlIIll.Color = Color3.fromRGB(0xFF,0xFF,0xFF)
_IIIIIlIIll.Thickness = 0x1
_IIIIIlIIll.Transparency = 0.8

-- Title bar
local _llllllllII = Instance.new("\070\114\097\109\101")
_llllllllII.Size = UDim2.new(0x1,0x0,0x0, 0x22*_lllIIIllIl)
_llllllllII.BackgroundColor3 = Color3.fromRGB(0x14,0x14,0x14)
_llllllllII.BorderSizePixel = 0x0
_llllllllII.Parent = _llIIIIIlII
Instance.new("\085\073\067\111\114\110\101\114", _llllllllII).CornerRadius = UDim.new(0x0,0xA*_lllIIIllIl)
local _IIlIlllIll = Instance.new("\070\114\097\109\101")
_IIlIlllIll.Size = UDim2.new(0x1,0x0,0x0,0xA*_lllIIIllIl)
_IIlIlllIll.Position = UDim2.new(0x0,0x0,0x1,-0xA*_lllIIIllIl)
_IIlIlllIll.BackgroundColor3 = Color3.fromRGB(0x14,0x14,0x14)
_IIlIlllIll.BorderSizePixel = 0x0
_IIlIlllIll.Parent = _llllllllII

local _lIllIlllII = Instance.new("\084\101\120\116\076\097\098\101\108")
_lIllIlllII.Size = UDim2.new(0x1,-0x32*_lllIIIllIl,0x1,0x0)
_lIllIlllII.Position = UDim2.new(0x0,0xA*_lllIIIllIl,0x0,0x0)
_lIllIlllII.BackgroundTransparency = 0x1
_lIllIlllII.Text = "\082\097\099\107\101\116\032\082\105\118\097\108\115"
_lIllIlllII.TextColor3 = Color3.fromRGB(0xFF,0xFF,0xFF)
_lIllIlllII.TextSize = 0xC
_lIllIlllII.Font = Enum.Font.GothamBold
_lIllIlllII.TextXAlignment = Enum.TextXAlignment.Left
_lIllIlllII.Parent = _llllllllII

local _IllIlIIIll = Instance.new("\084\101\120\116\066\117\116\116\111\110")
_IllIlIIIll.Size = UDim2.new(0x0,0x14*_lllIIIllIl,0x0,0x14*_lllIIIllIl)
_IllIlIIIll.Position = UDim2.new(0x1,-0x1A*_lllIIIllIl,0x0,0x7*_lllIIIllIl)
_IllIlIIIll.BackgroundColor3 = Color3.fromRGB(0x28,0x28,0x28)
_IllIlIIIll.Text = "\10005"
_IllIlIIIll.TextColor3 = Color3.fromRGB(0xC8,0xC8,0xC8)
_IllIlIIIll.TextSize = 0xA
_IllIlIIIll.Font = Enum.Font.GothamBold
_IllIlIIIll.BorderSizePixel = 0x0
_IllIlIIIll.AutoButtonColor = false
_IllIlIIIll.ZIndex = 0x15
_IllIlIIIll.Parent = _llllllllII
Instance.new("\085\073\067\111\114\110\101\114", _IllIlIIIll).CornerRadius = UDim.new(0x0,0x5*_lllIIIllIl)

-- _lIIllIIlII
local _lIIllIIlII = Instance.new("\070\114\097\109\101")
_lIIllIIlII.Size = UDim2.new(0x1,0x0,0x1,-0x23*_lllIIIllIl)
_lIIllIIlII.Position = UDim2.new(0x0,0x0,0x0,0x23*_lllIIIllIl)
_lIIllIIlII.BackgroundTransparency = 0x1
_lIIllIIlII.Parent = _llIIIIIlII

-- Two columns
local _IIIlIIllll = Instance.new("\070\114\097\109\101")
_IIIlIIllll.Size = UDim2.new(0x1,0x0,0x1,0x0)
_IIIlIIllll.BackgroundTransparency = 0x1
_IIIlIIllll.Parent = _lIIllIIlII

local _lIlIlIIlll = Instance.new("\070\114\097\109\101")
_lIlIlIIlll.Size = UDim2.new(0.5, -0x3*_lllIIIllIl, 0x1, 0x0)
_lIlIlIIlll.Position = UDim2.new(0x0,0x0,0x0,0x0)
_lIlIlIIlll.BackgroundTransparency = 0x1
_lIlIlIIlll.Parent = _IIIlIIllll
local _IlIIIlIllI = Instance.new("\085\073\076\105\115\116\076\097\121\111\117\116", _lIlIlIIlll)
_IlIIIlIllI.Padding = UDim.new(0x0, 0x3*_lllIIIllIl)
_IlIIIlIllI.FillDirection = Enum.FillDirection.Vertical
_IlIIIlIllI.SortOrder = Enum.SortOrder.LayoutOrder
local _IllIllIIII = Instance.new("\085\073\080\097\100\100\105\110\103", _lIlIlIIlll)
_IllIllIIII.PaddingLeft = UDim.new(0x0,0x4*_lllIIIllIl)
_IllIllIIII.PaddingRight = UDim.new(0x0,0x4*_lllIIIllIl)
_IllIllIIII.PaddingTop = UDim.new(0x0,0x2*_lllIIIllIl)

local _llllIlIlll = Instance.new("\070\114\097\109\101")
_llllIlIlll.Size = UDim2.new(0.5, -0x3*_lllIIIllIl, 0x1, 0x0)
_llllIlIlll.Position = UDim2.new(0.5, 0x3*_lllIIIllIl, 0x0, 0x0)
_llllIlIlll.BackgroundTransparency = 0x1
_llllIlIlll.Parent = _IIIlIIllll
local _IlIlIIlllI = Instance.new("\085\073\076\105\115\116\076\097\121\111\117\116", _llllIlIlll)
_IlIlIIlllI.Padding = UDim.new(0x0, 0x3*_lllIIIllIl)
_IlIlIIlllI.FillDirection = Enum.FillDirection.Vertical
_IlIlIIlllI.SortOrder = Enum.SortOrder.LayoutOrder
local _IIllllIIll = Instance.new("\085\073\080\097\100\100\105\110\103", _llllIlIlll)
_IIllllIIll.PaddingLeft = UDim.new(0x0,0x4*_lllIIIllIl)
_IIllllIIll.PaddingRight = UDim.new(0x0,0x4*_lllIIIllIl)
_IIllllIIll.PaddingTop = UDim.new(0x0,0x2*_lllIIIllIl)

-- ========== UI BUILDERS ==========
local function _llIIlIllll(name, subtitle, parent, layoutOrder, callback)
    local _lIIIlIIllI = Instance.new("\084\101\120\116\066\117\116\116\111\110")
    _lIIIlIIllI.Size = UDim2.new(0x1,0x0,0x0, 0x24*_lllIIIllIl)
    _lIIIlIIllI.BackgroundColor3 = Color3.fromRGB(0x16,0x16,0x16)
    _lIIIlIIllI.BorderSizePixel = 0x0
    _lIIIlIIllI.LayoutOrder = layoutOrder
    _lIIIlIIllI.Text = ""
    _lIIIlIIllI.AutoButtonColor = false
    _lIIIlIIllI.Parent = parent
    Instance.new("\085\073\067\111\114\110\101\114", _lIIIlIIllI).CornerRadius = UDim.new(0x0,0x7*_lllIIIllIl)
    local _lIIlIIIlII = Instance.new("\085\073\083\116\114\111\107\101", _lIIIlIIllI)
    _lIIlIIIlII.Color = Color3.fromRGB(0xFF,0xFF,0xFF)
    _lIIlIIIlII.Thickness = 0x1
    _lIIlIIIlII.Transparency = 0.88

    local _IIlIIllIII = Instance.new("\084\101\120\116\076\097\098\101\108")
    _IIlIIllIII.Size = UDim2.new(0x1,-0x28*_lllIIIllIl,0x0,0xE*_lllIIIllIl)
    _IIlIIllIII.Position = UDim2.new(0x0,0x6*_lllIIIllIl,0x0,0x2*_lllIIIllIl)
    _IIlIIllIII.BackgroundTransparency = 0x1
    _IIlIIllIII.Text = name
    _IIlIIllIII.TextColor3 = Color3.fromRGB(0xFF,0xFF,0xFF)
    _IIlIIllIII.TextSize = 0xA
    _IIlIIllIII.Font = Enum.Font.GothamBold
    _IIlIIllIII.TextXAlignment = Enum.TextXAlignment.Left
    _IIlIIllIII.Parent = _lIIIlIIllI
    local _IlIIIlIlIl = Instance.new("\084\101\120\116\076\097\098\101\108")
    _IlIIIlIlIl.Size = UDim2.new(0x1,-0x28*_lllIIIllIl,0x0,0xA*_lllIIIllIl)
    _IlIIIlIlIl.Position = UDim2.new(0x0,0x6*_lllIIIllIl,0x0,0x12*_lllIIIllIl)
    _IlIIIlIlIl.BackgroundTransparency = 0x1
    _IlIIIlIlIl.Text = subtitle
    _IlIIIlIlIl.TextColor3 = Color3.fromRGB(0x78,0x78,0x78)
    _IlIIIlIlIl.TextSize = 0x8
    _IlIIIlIlIl.Font = Enum.Font.Gotham
    _IlIIIlIlIl.TextXAlignment = Enum.TextXAlignment.Left
    _IlIIIlIlIl.Parent = _lIIIlIIllI

    local _llllIlllIl = Instance.new("\070\114\097\109\101")
    _llllIlllIl.Size = UDim2.new(0x0,0x8*_lllIIIllIl,0x0,0x8*_lllIIIllIl)
    _llllIlllIl.Position = UDim2.new(0x1,-0xC*_lllIIIllIl,0.5,-0x4*_lllIIIllIl)
    _llllIlllIl.BackgroundColor3 = Color3.fromRGB(0x50,0x50,0x50)
    _llllIlllIl.BorderSizePixel = 0x0
    _llllIlllIl.ZIndex = 0x15
    _llllIlllIl.Parent = _lIIIlIIllI
    Instance.new("\085\073\067\111\114\110\101\114", _llllIlllIl).CornerRadius = UDim.new(0x1,0x0)

    _lIIIlIIllI.MouseButton1Click:Connect(function()
        callback(_llllIlllIl)
    end)
    return _lIIIlIIllI, _llllIlllIl
end

local function _lIlIIllIll(name, suffix, min, max, default, parent, layoutOrder, callback)
    local _IllllllIII = Instance.new("\070\114\097\109\101")
    _IllllllIII.Size = UDim2.new(0x1,0x0,0x0, 0x38*_lllIIIllIl)
    _IllllllIII.BackgroundColor3 = Color3.fromRGB(0x16,0x16,0x16)
    _IllllllIII.BorderSizePixel = 0x0
    _IllllllIII.LayoutOrder = layoutOrder
    _IllllllIII.Parent = parent
    Instance.new("\085\073\067\111\114\110\101\114", _IllllllIII).CornerRadius = UDim.new(0x0,0x7*_lllIIIllIl)
    local _lIIlIIIlII = Instance.new("\085\073\083\116\114\111\107\101", _IllllllIII)
    _lIIlIIIlII.Color = Color3.fromRGB(0xFF,0xFF,0xFF)
    _lIIlIIIlII.Thickness = 0x1
    _lIIlIIIlII.Transparency = 0.88

    local _llIIllllll = Instance.new("\070\114\097\109\101")
    _llIIllllll.Size = UDim2.new(0x1,0x0,0x0,0x12*_lllIIIllIl)
    _llIIllllll.BackgroundTransparency = 0x1
    _llIIllllll.Parent = _IllllllIII
    local _IIlIIllIII = Instance.new("\084\101\120\116\076\097\098\101\108")
    _IIlIIllIII.Size = UDim2.new(0x1,-0x32*_lllIIIllIl,0x1,0x0)
    _IIlIIllIII.Position = UDim2.new(0x0,0x6*_lllIIIllIl,0x0,0x0)
    _IIlIIllIII.BackgroundTransparency = 0x1
    _IIlIIllIII.Text = name
    _IIlIIllIII.TextColor3 = Color3.fromRGB(0xFF,0xFF,0xFF)
    _IIlIIllIII.TextSize = 0xA
    _IIlIIllIII.Font = Enum.Font.GothamBold
    _IIlIIllIII.TextXAlignment = Enum.TextXAlignment.Left
    _IIlIIllIII.Parent = _llIIllllll
    local _lIIlIlIlIl = Instance.new("\084\101\120\116\076\097\098\101\108")
    _lIIlIlIlIl.Size = UDim2.new(0x0,0x2C*_lllIIIllIl,0x1,0x0)
    _lIIlIlIlIl.Position = UDim2.new(0x1,-0x2C*_lllIIIllIl,0x0,0x0)
    _lIIlIlIlIl.BackgroundTransparency = 0x1
    _lIIlIlIlIl.Text = default .. "\032" .. suffix
    _lIIlIlIlIl.TextColor3 = Color3.fromRGB(0xC8,0xC8,0xC8)
    _lIIlIlIlIl.TextSize = 0x9
    _lIIlIlIlIl.Font = Enum.Font.GothamBold
    _lIIlIlIlIl.TextXAlignment = Enum.TextXAlignment.Right
    _lIIlIlIlIl.Parent = _llIIllllll

    local _lIIIllIlll = Instance.new("\070\114\097\109\101")
    _lIIIllIlll.Size = UDim2.new(0x1,-0xC*_lllIIIllIl,0x0,0x4*_lllIIIllIl)
    _lIIIllIlll.Position = UDim2.new(0x0,0x6*_lllIIIllIl,0x0,0x1A*_lllIIIllIl)
    _lIIIllIlll.BackgroundColor3 = Color3.fromRGB(0x2D,0x2D,0x2D)
    _lIIIllIlll.BorderSizePixel = 0x0
    _lIIIllIlll.Parent = _IllllllIII
    Instance.new("\085\073\067\111\114\110\101\114", _lIIIllIlll).CornerRadius = UDim.new(0x1,0x0)
    local _IIlIIIIIIl = Instance.new("\070\114\097\109\101")
    _IIlIIIIIIl.Size = UDim2.new((default-min)/(max-min),0x0,0x1,0x0)
    _IIlIIIIIIl.BackgroundColor3 = Color3.fromRGB(0xFF,0xFF,0xFF)
    _IIlIIIIIIl.BorderSizePixel = 0x0
    _IIlIIIIIIl.Parent = _lIIIllIlll
    Instance.new("\085\073\067\111\114\110\101\114", _IIlIIIIIIl).CornerRadius = UDim.new(0x1,0x0)
    local _lIIlIlllll = Instance.new("\070\114\097\109\101")
    _lIIlIlllll.Size = UDim2.new(0x0,0xC*_lllIIIllIl,0x0,0xC*_lllIIIllIl)
    _lIIlIlllll.AnchorPoint = Vector2.new(0.5,0.5)
    _lIIlIlllll.Position = UDim2.new((default-min)/(max-min),0x0,0.5,0x0)
    _lIIlIlllll.BackgroundColor3 = Color3.fromRGB(0xFF,0xFF,0xFF)
    _lIIlIlllll.BorderSizePixel = 0x0
    _lIIlIlllll.ZIndex = 0x5
    _lIIlIlllll.Parent = _lIIIllIlll
    Instance.new("\085\073\067\111\114\110\101\114", _lIIlIlllll).CornerRadius = UDim.new(0x1,0x0)
    local _IllllIllII = Instance.new("\070\114\097\109\101")
    _IllllIllII.Size = UDim2.new(0x0,0x6*_lllIIIllIl,0x0,0x6*_lllIIIllIl)
    _IllllIllII.AnchorPoint = Vector2.new(0.5,0.5)
    _IllllIllII.Position = UDim2.new(0.5,0x0,0.5,0x0)
    _IllllIllII.BackgroundColor3 = Color3.fromRGB(0xA,0xA,0xA)
    _IllllIllII.BorderSizePixel = 0x0
    _IllllIllII.ZIndex = 0x6
    _IllllIllII.Parent = _lIIlIlllll
    Instance.new("\085\073\067\111\114\110\101\114", _IllllIllII).CornerRadius = UDim.new(0x1,0x0)

    local _IlIIlIllII = {_lIIIllIlll=_lIIIllIlll, _IIlIIIIIIl=_IIlIIIIIIl, _lIIlIlllll=_lIIlIlllll, _lIIlIlIlIl=_lIIlIlIlIl, min=min, max=max, value=default}

    function _IlIIlIllII:update(inputX)
        local _llIIlllIII = self.rail.AbsolutePosition.X
        local _IlIllIlIll = self.rail.AbsoluteSize.X
        local _IIIIIlIlIl = math.clamp((inputX - _llIIlllIII) / _IlIllIlIll, 0x0, 0x1)
        local _IIllIIIlII = self.min + _IIIIIlIlIl * (self.max - self.min)
        _IIllIIIlII = math.floor(_IIllIIIlII * 0xA + 0.5) / 0xA
        self.value = _IIllIIIlII
        self.fill.Size = UDim2.new(_IIIIIlIlIl, 0x0, 0x1, 0x0)
        self.handle.Position = UDim2.new(_IIIIIlIlIl, 0x0, 0.5, 0x0)
        self.valLabel.Text = _IIllIIIlII .. "\032" .. suffix
        callback(_IIllIIIlII)
    end

    _lIIIllIlll.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            _lIIllIlIIl = _IlIIlIllII
            _IlIIlIllII:update(i.Position.X)
        end
    end)
    _lIIlIlllll.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            _lIIllIlIIl = _IlIIlIllII
        end
    end)

    return _IlIIlIllII
end

-- ========== POPULATE UI (two columns) ==========
-- Left column
_llIIlIllll("\083\112\101\101\100\032\082\117\115\104", "\083\108\105\100\101\044\032\098\097\108\108\032\115\116\097\121\115\032\105\110\032\102\114\111\110\116", _lIlIlIIlll, 0x1, function(_llllIlllIl)
    _IIIIllIIIl = not _IIIIllIIIl
    pcall(function()
        TweenService:Create(_llllIlllIl, TweenInfo.new(0.15), {
            BackgroundColor3 = _IIIIllIIIl and Color3.fromRGB(0xFF,0xFF,0xFF) or Color3.fromRGB(0x50,0x50,0x50)
        }):Play()
    end)
    _IlIlllIIIl()
end)

_llIIlIllll("\065\117\116\111\032\083\119\105\110\103", "\083\112\097\109\032\115\119\105\110\103\115\032\040\080\067\043\077\111\098\105\108\101\041", _lIlIlIIlll, 0x2, function(_llllIlllIl)
    _IllllIIIll = not _IllllIIIll
    pcall(function()
        TweenService:Create(_llllIlllIl, TweenInfo.new(0.15), {
            BackgroundColor3 = _IllllIIIll and Color3.fromRGB(0xFF,0xFF,0xFF) or Color3.fromRGB(0x50,0x50,0x50)
        }):Play()
    end)
    _IlIlllIIIl()
end)

_lIlIIllIll("\072\101\105\103\104\116\032\079\102\102\115\101\116", "\115\116\117\100\115", _IIIIllllll, _IIIllllIII, _lIllIlllll, _lIlIlIIlll, 0x3, function(_IIllIIIlII) _lIllIlllll = _IIllIIIlII end)
_lIlIIllIll("\082\117\115\104\032\083\112\101\101\100", "\115\116\117\100\115\047\115", _lIIlIIlllI, _IIIlIlIIII, _llIIllIIII, _lIlIlIIlll, 0x4, function(_IIllIIIlII) _llIIllIIII = _IIllIIIlII end)
_lIlIIllIll("\083\119\105\110\103\032\067\111\111\108\100\111\119\110", "\115", _lIIIIIIIIl, _IlIIlIIIII, _lllIlIllIl, _lIlIlIIlll, 0x5, function(_IIllIIIlII) _lllIlIllIl = _IIllIIIlII end)
_lIlIIllIll("\070\114\111\110\116\032\068\105\115\116\097\110\099\101", "\115\116\117\100\115", _IllIIlIlII, _lIllIllIII, _IIIIIlIIIl, _lIlIlIIlll, 0x6, function(_IIllIIIlII) _IIIIIlIIIl = _IIllIIIlII end)

-- Right column
_lIlIIllIll("\083\119\105\110\103\032\072\111\108\100", "\115", _lIIIlIIIlI, _lllIIIlIlI, _lIIlllIlll, _llllIlIlll, 0x1, function(_IIllIIIlII) _lIIlllIlll = _IIllIIIlII end)
_lIlIIllIll("\066\097\108\108\032\076\111\115\116\032\087\097\105\116", "\115", _llIlllIlII, _IlIIIlIIII, _IlIIlIlIll, _llllIlIlll, 0x2, function(_IIllIIIlII) _IlIIlIlIll = _IIllIIIlII end)

-- Auto Refresh Rush (reactive)
_llIIlIllll("\065\117\116\111\032\082\101\102\114\101\115\104\032\082\117\115\104", "\082\101\102\114\101\115\104\032\119\104\101\110\032\098\097\108\108\032\105\115\032\108\111\115\116", _llllIlIlll, 0x3, function(_llllIlllIl)
    _llIIIIlIlI = not _llIIIIlIlI
    pcall(function()
        TweenService:Create(_llllIlllIl, TweenInfo.new(0.15), {
            BackgroundColor3 = _llIIIIlIlI and Color3.fromRGB(0xFF,0xFF,0xFF) or Color3.fromRGB(0x50,0x50,0x50)
        }):Play()
    end)
    if _llIIIIlIlI then
        _IlllIIllII = tick()  -- start timing immediately
    end
    _IlIlllIIIl()
end)
_lIlIIllIll("\082\101\102\114\101\115\104\032\073\110\116\101\114\118\097\108", "\115", _IlIlIIIIlI, _lIlIlIlIII, _IllIIIIIll, _llllIlIlll, 0x4, function(_IIllIIIlII) _IllIIIIIll = _IIllIIIlII end)

_llIIlIllll("\067\097\109\101\114\097\032\076\111\099\107", "\070\111\108\108\111\119\032\098\097\108\108\032\102\114\111\109\032\098\101\104\105\110\100", _llllIlIlll, 0x5, function(_llllIlllIl)
    _llllIllllI = not _llllIllllI
    pcall(function()
        TweenService:Create(_llllIlllIl, TweenInfo.new(0.15), {
            BackgroundColor3 = _llllIllllI and Color3.fromRGB(0xFF,0xFF,0xFF) or Color3.fromRGB(0x50,0x50,0x50)
        }):Play()
    end)
    if not _llllIllllI then
        _llllIIIllI()
    end
    _IlIlllIIIl()
end)
_lIlIIllIll("\067\097\109\032\068\105\115\116\097\110\099\101", "\115\116\117\100\115", _IIlllIllll, _IIIlIIllIl, _IIIlIlIlll, _llllIlIlll, 0x6, function(_IIllIIIlII) _IIIlIlIlll = _IIllIIIlII end)
_lIlIIllIll("\067\097\109\032\072\101\105\103\104\116", "\115\116\117\100\115", _IlIIlIlIIl, _lllIllllII, _lIlIlIIlII, _llllIlIlll, 0x7, function(_IIllIIIlII) _lIlIlIIlII = _IIllIIIlII end)

-- ========== INPUT HANDLERS ==========
UserInputService.InputChanged:Connect(function(i)
    if _lIIllIlIIl and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        _lIIllIlIIl:update(i.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _lIIllIlIIl = nil
    end
end)

-- ========== OPEN/CLOSE ==========
local function _IlIIIllllI()
    _lllllllIII = true
    _llIIIIIlII.Visible = true
    _llIIIIIlII.Size = UDim2.new(0x0,0x1B8*_lllIIIllIl,0x0,0x0)
    pcall(function()
        TweenService:Create(_llIIIIIlII, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0x0,0x1B8*_lllIIIllIl,0x0,0x17C*_lllIIIllIl)
        }):Play()
    end)
end

local function _lllllIIllI()
    _lllllllIII = false
    local _lIIlIIIIll = TweenService:Create(_llIIIIIlII, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.new(0x0,0x1B8*_lllIIIllIl,0x0,0x0)
    })
    _lIIlIIIIll:Play()
    _lIIlIIIIll.Completed:Connect(function()
        if not _lllllllIII then _llIIIIIlII.Visible = false end
    end)
end

_lIIlIllIIl.MouseButton1Click:Connect(function()
    if _lllllllIII then _lllllIIllI() else _IlIIIllllI() end
end)
_IllIlIIIll.MouseButton1Click:Connect(_lllllIIllI)

-- Drag main panel
local _IllIIlllII, dragStart, startPos = false, nil, nil
_llllllllII.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _IllIIlllII = true
        dragStart = i.Position
        startPos = _llIIIIIlII.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if _IllIIlllII and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local _IIIllIIIll = i.Position - dragStart
        _llIIIIIlII.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + _IIIllIIIll.X,
            startPos.Y.Scale, startPos.Y.Offset + _IIIllIIIll.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        _IllIIlllII = false
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.J then
        if _lllllllIII then _lllllIIllI() else _IlIIIllllI() end
    end
end)

-- Reset on respawn
_lIIIllIlII.CharacterAdded:Connect(function()
    _IIIIllIIIl = false
    _IllllIIIll = false
    _llllIllllI = false
    _llIIIIlIlI = false
    _IIIIIIIIIl = nil
    _IlllIIllII = 0x0
    _llllIIIllI()
    _lIIIlIIIIl()
end)

print("\091\082\097\099\107\101\116\032\082\105\118\097\108\115\093\032\076\111\097\100\101\100\046\032\065\117\116\111\032\082\101\102\114\101\115\104\032\082\117\115\104\032\040\114\101\097\099\116\105\118\101\041\032\097\100\100\101\100\046")