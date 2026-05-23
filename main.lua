print("Shindo Life Banekai - Carregando...")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShindoLifeBanekai"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 400, 0, 350)
Frame.Position = UDim2.new(0.5, -200, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
Title.Text = "Shindo Life Banekai"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

-- Toggles
local toggles = {
    AutoFarm = false,
    AutoBoss = false,
    AutoSpam = false,
    AntiAFK = true,
}

local y = 50
for name, default in pairs(toggles) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 360, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.Text = name .. " : " .. tostring(default)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = Frame
    
    btn.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        btn.Text = name .. " : " .. tostring(toggles[name])
        if toggles[name] then
            btn.BackgroundColor3 = Color3.fromRGB(0, 130, 50)
        else
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        end
    end)
    
    y = y + 45
end

-- Fechar GUI com Insert
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Anti AFK
spawn(function()
    while task.wait(60) do
        if toggles.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end
    end
end)

-- Auto Farm (aperta teclas 1 e 2)
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

-- Auto Boss (teleporta para o boss mais próximo)
spawn(function()
    while task.wait(3) do
        if toggles.AutoBoss then
            pcall(function()
                local boss = nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Name:lower():find("boss") then
                        boss = v
                        break
                    end
                end
                if boss and RootPart then
                    RootPart.CFrame = boss:GetPivot() * CFrame.new(0, 0, -5)
                end
            end)
        end
    end
end)

-- Auto Spam (aperta teclas 1 a 4)
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

print("Shindo Life Banekai - Carregado com sucesso!")
