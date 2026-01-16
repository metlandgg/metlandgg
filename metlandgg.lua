-- Script Roblox dengan GUI Full Screen
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Buat ScreenGui dengan InsertGui=true
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Buat Frame full screen
local frame = Instance.new("Frame")
frame.Name = "FullFrame"
frame.Size = UDim2.new(1, 0, 1, 0)
frame.Position = UDim2.new(0, 0, 0, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Buat TextLabel di tengah
local textLabel = Instance.new("TextLabel")
textLabel.Name = "CenterLabel"
textLabel.Size = UDim2.new(0, 400, 0, 100)
textLabel.Position = UDim2.new(0.5, -200, 0.5, -50) -- Posisi di tengah
textLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
textLabel.BackgroundTransparency = 0.3
textLabel.BorderColor3 = Color3.fromRGB(255, 255, 255)
textLabel.BorderSizePixel = 2
textLabel.Text = "Move to another scripts"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextSize = 24
textLabel.Font = Enum.Font.GothamBold
textLabel.Parent = frame

print("GUI telah dibuat dengan berhasil!")
