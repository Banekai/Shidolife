-- Script direto e funcional
print("Shindo Life Banekai - Iniciando...")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BanekaiGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Title.Text = "Shindo Life Banekai"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local toggles = { AutoFarm = false, AutoBoss = false, AutoSpam = false, AntiAFK = true }
local y = 50
for name, default in pairs(toggles) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 360, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = name .. " : " .. tostring(default)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = Frame
    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = name .. " : " .. tostring(toggles[name])
        btn.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 130, 50) or Color3.fromRGB(40, 40, 55)
    end)
    y = y + 45
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

spawn(function()
    while task.wait(60) do
        if toggles.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0,0))
        end
    end
end)

spawn(function()
    while task.wait(0.15) do
        if toggles.AutoFarm then
            pcall(function()
                local mouse = Player:GetMouse()
                mouse.KeyDown:Fire("1")
                task.wait(0.05)
                mouse.KeyDown:Fire("2")
            end)
        end
    end
end)

spawn(function()
    while task.wait(3) do
        if toggles.AutoBoss then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name:lower():find("boss") then
                        if RootPart then RootPart.CFrame = v:GetPivot() * CFrame.new(0,0,-5) end
                        break
                    end
                end
            end)
        end
    end
end)

spawn(function()
    while task.wait(0.6) do
        if toggles.AutoSpam then
            pcall(function()
                local mouse = Player:GetMouse()
                for i = 1, 4 do
                    mouse.KeyDown:Fire(tostring(i))
                    task.wait(0.1)
                end
            end)
        end
    end
end)

print("Shindo Life Banekai - Pronto!")
