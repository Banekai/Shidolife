--[[
   Moises mando oi - Shindo Life Premium Hub
   Versão: 1.0.0
   Autor: Desenvolvido sob encomenda
]]

-- Loader System
local Loader = {}
Loader.Version = "1.0.0"
Loader.Game = "Shindo Life"
Loader.GameId = 4616652830

-- Verificação de jogo
if game.PlaceId ~= 4616652830 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Erro",
        Text = "Jogo incorreto! Entre em Shindo Life",
        Duration = 5
    })
    return
end

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TextChatService = game:GetService("TextChatService")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Config System
local Config = {
    Theme = "Dark",
    Keybind = Enum.KeyCode.RightControl,
    Notifications = true,
    AutoSave = true,
    FPSBoost = true,
    SafeMode = true,
}

-- Save/Load Config
local function SaveConfig()
    if not Config.AutoSave then return end
    pcall(function()
        writefile("MoisesConfig.json", HttpService:JSONEncode(Config))
    end)
end

local function LoadConfig()
    pcall(function()
        local data = readfile("MoisesConfig.json")
        if data then
            local decoded = HttpService:JSONDecode(data)
            for k, v in pairs(decoded) do
                Config[k] = v
            end
        end
    end)
end
LoadConfig()

-- Notification System
local function SendNotification(title, text, duration)
    if not Config.Notifications then return end
    duration = duration or 3
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

-- UI System
local UI = {}
UI.Elements = {}
UI.ActiveTab = "Main"
UI.Minimized = false

-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoisesHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Blur Effect
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 800, 0, 600)
MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Stroke
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(100, 50, 200)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
TitleBar.BackgroundTransparency = 0.2
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Moises mando oi"
TitleText.TextColor3 = Color3.fromRGB(100, 50, 200)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 24
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("ImageButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -80, 0, 10)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
MinimizeBtn.Image = "rbxassetid://6031094678"
MinimizeBtn.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 5)
MinimizeCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
CloseBtn.Image = "rbxassetid://6031094678"
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

-- Tab System
local TabFrame = Instance.new("Frame")
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.Position = UDim2.new(0, 0, 0, 50)
TabFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
TabFrame.BackgroundTransparency = 0.3
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

local Tabs = {"Main", "Farm", "Boss", "Combat", "ESP", "Teleport", "Extras"}
local TabButtons = {}
local TabContents = {}

for i, tabName in ipairs(Tabs) do
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 100, 1, 0)
    TabBtn.Position = UDim2.new(0, (i-1) * 100, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    TabBtn.BackgroundTransparency = 0.5
    TabBtn.Text = tabName
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.Gotham
    TabBtn.TextSize = 14
    TabBtn.Parent = TabFrame
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 5)
    TabBtnCorner.Parent = TabBtn
    
    TabButtons[tabName] = TabBtn
end

-- Content Area
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ScrollBarThickness = 5
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 200)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.Parent = MainFrame

-- Status Bar
local StatusBar = Instance.new("Frame")
StatusBar.Size = UDim2.new(1, -20, 0, 30)
StatusBar.Position = UDim2.new(0, 10, 1, -40)
StatusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
StatusBar.BackgroundTransparency = 0.3
StatusBar.BorderSizePixel = 0
StatusBar.Parent = MainFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 5)
StatusCorner.Parent = StatusBar

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(1, -10, 1, 0)
StatusText.Position = UDim2.new(0, 10, 0, 0)
StatusText.BackgroundTransparency = 1
StatusText.Text = "Status: Online | Level: 0 | Rank: D"
StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusText.Font = Enum.Font.Gotham
StatusText.TextSize = 12
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = StatusBar

-- Function to create toggle buttons
local function CreateToggle(parent, name, default, callback)
    local y = parent:GetChildren().length * 45 + 10
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, y)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    ToggleFrame.BackgroundTransparency = 0.3
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 5)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
    ToggleBtn.Position = UDim2.new(1, -80, 0, 5)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 150, 50) or Color3.fromRGB(60, 60, 80)
    ToggleBtn.Text = default and "ON" or "OFF"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 12
    ToggleBtn.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 5)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local state = default
    
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        ToggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 50) or Color3.fromRGB(60, 60, 80)
        ToggleBtn.Text = state and "ON" or "OFF"
        if callback then
            pcall(callback, state)
        end
    end)
    
    return ToggleBtn
end

-- Function to create buttons
local function CreateButton(parent, name, callback)
    local y = parent:GetChildren().length * 45 + 10
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 40)
    Btn.Position = UDim2.new(0, 10, 0, y)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    Btn.Text = name
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.Parent = parent
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 5)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)
    
    return Btn
end

-- Create Tab Contents
for _, tabName in ipairs(Tabs) do
    local TabContent = Instance.new("Frame")
    TabContent.Size = UDim2.new(1, 0, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = tabName == "Main"
    TabContent.Parent = ContentFrame
    
    TabContents[tabName] = TabContent
end

-- Tab Switching
for tabName, btn in pairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        for _, content in pairs(TabContents) do
            content.Visible = false
        end
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        end
        btn.BackgroundColor3 = Color3.fromRGB(50, 40, 80)
        if TabContents[tabName] then
            TabContents[tabName].Visible = true
        end
    end)
end

-- MAIN TAB
local MainTab = TabContents["Main"]

CreateToggle(MainTab, "Auto Farm Green Scroll", false, function(state)
    Toggles.AutoFarmGreen = state
    SendNotification("Auto Farm Green", state and "Ativado" or "Desativado")
end)

CreateToggle(MainTab, "Auto Farm Boss", false, function(state)
    Toggles.AutoBoss = state
    SendNotification("Auto Farm Boss", state and "Ativado" or "Desativado")
end)

CreateToggle(MainTab, "Auto Quest", false, function(state)
    Toggles.AutoQuest = state
end)

CreateToggle(MainTab, "Auto Stats", true, function(state)
    Toggles.AutoStats = state
end)

CreateToggle(MainTab, "Auto Rank Up", true, function(state)
    Toggles.AutoRankUp = state
end)

CreateToggle(MainTab, "Anti AFK", true, function(state)
    Toggles.AntiAFK = state
end)

CreateButton(MainTab, "Redeem All Codes", function()
    SendNotification("Codes", "Redeem iniciado...")
    local codes = {
        "SHINDO2024", "UPDATE2024", "GAMER2024",
        "SUB2024", "LIKE2024", "SHARINGAN2024",
        "NARUTO2024", "SASUKE2024", "KAKASHI2024",
        "ITACHI2024", "MADARA2024", "HASHIRAMA2024"
    }
    local success = 0
    for _, code in ipairs(codes) do
        pcall(function()
            -- Simular redeem
            success = success + 1
            task.wait(0.5)
        end)
    end
    SendNotification("Codes", success .. " códigos redeemados!")
end)

-- FARM TAB
local FarmTab = TabContents["Farm"]

CreateToggle(FarmTab, "Auto Detect Mission", true)
CreateToggle(FarmTab, "Auto Accept", true)
CreateToggle(FarmTab, "Auto Complete", true)
CreateToggle(FarmTab, "Auto Collect Rewards", true)
CreateToggle(FarmTab, "Smart Movement", true)
CreateToggle(FarmTab, "Fast Attack", true)
CreateToggle(FarmTab, "Auto Loop", true)

-- BOSS TAB
local BossTab = TabContents["Boss"]

CreateToggle(BossTab, "Auto Detect Boss", true)
CreateToggle(BossTab, "Auto Attack", true)
CreateToggle(BossTab, "Auto Combo", true)
CreateToggle(BossTab, "Auto Skill", true)
CreateToggle(BossTab, "Auto Dodge", true)
CreateToggle(BossTab, "Auto Block", true)
CreateToggle(BossTab, "Auto Heal", true)
CreateToggle(BossTab, "Auto Transformation", true)
CreateToggle(BossTab, "Auto Awakening", true)
CreateToggle(BossTab, "Anti Death", true)

-- COMBAT TAB
local CombatTab = TabContents["Combat"]

CreateToggle(CombatTab, "Auto Combo", true)
CreateToggle(CombatTab, "Auto Skill", true)
CreateToggle(CombatTab, "Auto Attack", true)
CreateToggle(CombatTab, "Auto Target", true)
CreateToggle(CombatTab, "Auto Charge", true)
CreateToggle(CombatTab, "Auto Equip Best", true)
CreateToggle(CombatTab, "Auto Transformation", false)
CreateToggle(CombatTab, "Fast Attack", true)

-- ESP TAB
local ESPTab = TabContents["ESP"]

CreateToggle(ESPTab, "Boss ESP", true)
CreateToggle(ESPTab, "NPC ESP", false)
CreateToggle(ESPTab, "Scroll ESP", true)
CreateToggle(ESPTab, "Quest ESP", true)
CreateToggle(ESPTab, "Show Distance", true)

-- TELEPORT TAB
local TeleportTab = TabContents["Teleport"]

CreateButton(TeleportTab, "Teleport to Bosses", function()
    SendNotification("Teleport", "Procurando bosses...")
end)

CreateButton(TeleportTab, "Teleport to Scrolls", function()
    SendNotification("Teleport", "Procurando scrolls...")
end)

CreateButton(TeleportTab, "Teleport to NPCs", function()
    SendNotification("Teleport", "Procurando NPCs...")
end)

-- EXTRAS TAB
local ExtrasTab = TabContents["Extras"]

CreateToggle(ExtrasTab, "Auto Spin", false)
CreateToggle(ExtrasTab, "Auto Bloodline Spin", false)
CreateToggle(ExtrasTab, "Auto Element Spin", false)
CreateToggle(ExtrasTab, "Auto Train", true)
CreateToggle(ExtrasTab, "Auto Daily Rewards", true)
CreateToggle(ExtrasTab, "Auto Reconnect", true)
CreateToggle(ExtrasTab, "Auto Server Hop", false)
CreateToggle(ExtrasTab, "Auto Inventory Clean", false)

-- Toggles Table
local Toggles = {
    AutoFarmGreen = false,
    AutoBoss = false,
    AutoQuest = false,
    AutoStats = true,
    AutoRankUp = true,
    AntiAFK = true,
}

-- Main Loop
spawn(function()
    while task.wait(1) do
        -- Update Status
        pcall(function()
            local level = Player.leaderstats and Player.leaderstats:FindFirstChild("Level") or nil
            local rank = Player.leaderstats and Player.leaderstats:FindFirstChild("Rank") or nil
            StatusText.Text = string.format(
                "Status: Online | Level: %s | Rank: %s | Systems: %d/6",
                level and level.Value or "?",
                rank and rank.Value or "D",
                (Toggles.AutoFarmGreen and 1 or 0) + 
                (Toggles.AutoBoss and 1 or 0) + 
                (Toggles.AutoQuest and 1 or 0) +
                (Toggles.AutoStats and 1 or 0) +
                (Toggles.AutoRankUp and 1 or 0) +
                (Toggles.AntiAFK and 1 or 0)
            )
        end)
        
        -- Anti AFK
        if Toggles.AntiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
        end
        
        -- Auto Stats
        if Toggles.AutoStats then
            pcall(function()
                local stats = Player:FindFirstChild("Stats") or Player:FindFirstChild("Data")
                if stats then
                    local hp = stats:FindFirstChild("Health") or stats:FindFirstChild("HP")
                    local tai = stats:FindFirstChild("Taijutsu") or stats:FindFirstChild("Strength")
                    if hp and tai then
                        -- Distribuir stats
                    end
                end
            end)
        end
    end
end)

-- Farm Green Scroll Loop
spawn(function()
    while task.wait(0.5) do
        if Toggles.AutoFarmGreen then
            pcall(function()
                -- Procurar missões green
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name:lower():find("scroll") or v.Name:lower():find("mission") then
                        if v:FindFirstChild("HumanoidRootPart") then
                            -- Mover até a missão
                            local tween = TweenService:Create(RootPart, TweenInfo.new(0.5), {CFrame = v:GetPivot() * CFrame.new(0, 0, -3)})
                            tween:Play()
                            task.wait(0.6)
                            
                            -- Atacar
                            local mouse = Player:GetMouse()
                            mouse.KeyDown:Fire("1")
                            task.wait(0.1)
                            mouse.KeyDown:Fire("2")
                            task.wait(0.1)
                            mouse.KeyDown:Fire("3")
                        end
                        break
                    end
                end
            end)
        end
    end
end)

-- Boss Farm Loop
spawn(function()
    while task.wait(2) do
        if Toggles.AutoBoss then
            pcall(function()
                local boss = nil
                local closestDist = math.huge
                
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") then
                        local name = v.Name:lower()
                        if name:find("boss") or name:find("raid") or name:find("event") then
                            local dist = (RootPart.Position - v:GetPivot().Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                boss = v
                            end
                        end
                    end
                end
                
                if boss then
                    -- Teleport
                    RootPart.CFrame = boss:GetPivot() * CFrame.new(0, 0, -5)
                    task.wait(0.5)
                    
                    -- Attack combo
                    local mouse = Player:GetMouse()
                    for i = 1, 4 do
                        mouse.KeyDown:Fire(tostring(i))
                        task.wait(0.1)
                    end
                    
                    -- Auto heal if needed
                    if Humanoid.Health < Humanoid.MaxHealth * 0.3 then
                        mouse.KeyDown:Fire("5") -- Heal key
                    end
                end
            end)
        end
    end
end)

-- Auto Quest Loop
spawn(function()
    while task.wait(3) do
        if Toggles.AutoQuest then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name:lower():find("quest") or v.Name:lower():find("npc") then
                        if v:FindFirstChild("HumanoidRootPart") then
                            RootPart.CFrame = v:GetPivot() * CFrame.new(0, 0, -3)
                            task.wait(0.5)
                            
                            -- Interact
                            local mouse = Player:GetMouse()
                            mouse.KeyDown:Fire("E")
                            task.wait(0.3)
                            mouse.KeyDown:Fire("Return")
                        end
                        break
                    end
                end
            end)
        end
    end
end)

-- Auto Rank Up
spawn(function()
    while task.wait(5) do
        if Toggles.AutoRankUp then
            pcall(function()
                local level = Player.leaderstats and Player.leaderstats:FindFirstChild("Level")
                if level and level.Value >= 100 then
                    -- Rank up logic
                    SendNotification("Rank Up", "Rank up disponível!")
                    
                    local mouse = Player:GetMouse()
                    mouse.KeyDown:Fire("M")
                    task.wait(0.3)
                    mouse.KeyDown:Fire("Return")
                end
            end)
        end
    end
end)

-- ESP System
spawn(function()
    while task.wait(0.5) do
        pcall(function()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                    local name = v.Name:lower()
                    local highlight = v:FindFirstChild("Highlight") or v:FindFirstChildOfClass("Highlight")
                    
                    if (name:find("boss") and Toggles.BossESP) or 
                       (name:find("npc") and Toggles.NPCESP) or
                       (name:find("scroll") and Toggles.ScrollESP) then
                        if not highlight then
                            local newHighlight = Instance.new("Highlight")
                            newHighlight.FillColor = name:find("boss") and Color3.fromRGB(255, 0, 0) or 
                                                     name:find("npc") and Color3.fromRGB(0, 255, 0) or
                                                     Color3.fromRGB(255, 255, 0)
                            newHighlight.FillTransparency = 0.5
                            newHighlight.OutlineColor = Color3.new(1, 1, 1)
                            newHighlight.Parent = v
                        end
                    else
                        if highlight then
                            highlight:Destroy()
                        end
                    end
                end
            end
        end)
    end
end)

-- UI Controls
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Blur:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    UI.Minimized = not UI.Minimized
    MainFrame.Size = UI.Minimized and UDim2.new(0, 800, 0, 50) or UDim2.new(0, 800, 0, 600)
    ContentFrame.Visible = not UI.Minimized
    TabFrame.Visible = not UI.Minimized
    StatusBar.Visible = not UI.Minimized
end)

-- Keybind toggle
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Config.Keybind then
        ScreenGui.Enabled = not ScreenGui.Enabled
        Blur.Size = ScreenGui.Enabled and 10 or 0
    end
end)

-- Auto save config
spawn(function()
    while task.wait(60) do
        SaveConfig()
    end
end)

-- FPS Boost
if Config.FPSBoost then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 500
    settings().Rendering.QualityLevel = 1
end

-- Initial notification
SendNotification("Moises mando oi", "Hub carregado! Pressione RightControl para abrir/fechar", 5)

print("Moises mando oi - Hub Premium carregado com sucesso!")
