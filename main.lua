--[[
	
 ________  _______   ________  _________  ___  ___  ___  ___  ________     
|\   __  \|\  ___ \ |\   __  \|\___   ___\\  \|\  \|\  \|\  \|\   __  \    
\ \  \|\  \ \   __/|\ \  \|\  \|___ \  \_\ \  \\\  \ \  \\\  \ \  \|\  \ \  \|\ /_   
 \ \  \\\  \ \  \_|/_\ \   __  \   \ \  \ \ \   __  \ \  \\\  \ \   __  \  
  \ \  \\\  \ \  \_|\ \ \  \ \  \   \ \  \ \ \  \ \  \ \  \\\  \ \  \|\  \ 
   \ \_____  \ \_______\ \__\ \__\   \ \__\ \ \__\ \__\ \_______\ \_______\
    \|___| \__\|_______|\|__|\|__|    \|__|  \|__|\|__|\|_______|\|_______|
          \|__|                                                            

	====================================================================
	  - QeatHub Universal Premium
	  - Edition: v3.3 [GUN DROP ESP INTEGRATED]
	====================================================================
	
	"Imitation is the sincerest form of flattery."
	 
	 - Goodbye, .... ;)
	
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Hangi oyunda olduğumuzu otomatik tespit etme motoru
local CurrentGame = "Universal"
if game.PlaceId == 142823291 or game.GameId == 506727284 then -- MM2 ID Kontrolleri
    CurrentGame = "MM2"
elseif game.PlaceId == 17625359962 or workspace:FindFirstChild("Rivals_Assets") then -- Rivals Kontrolü
    CurrentGame = "Rivals"
end

-- Eski arayüz kalıntılarını temizle
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("QeatHUB_Premium") then
    LocalPlayer.PlayerGui.QeatHUB_Premium:Destroy()
end

-- Config Yapısı
local Config = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    HitboxSize = 12,
    AimSmoothness = 0.32,
    Toggles = {
        Hitbox = false, AutoClicker = false, Speed = false, JumpPowerToggle = false,
        Xray = false, ESP = false, Noclip = false, AutoAim = false, Fly = false, DoubleJump = false,
        -- MM2 Özel Toggles
        MM2SafeZone = false, MM2RoleESP = false, MM2SheriffAim = false,
        MM2CounterKill = false, MM2KillAura = false, MM2HighlightSheriff = false,
        MM2GunESP = false -- Yeni eklenen Gun ESP özelliği
    }
}

-- [[ UI TASARIMI ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QeatHUB_Premium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- MM2 Ses ve Ekran Bildirim Nesneleri
local WarningSound = Instance.new("Sound", workspace)
WarningSound.SoundId = "rbxassetid://1222213261"
WarningSound.Volume = 2

local WarningLabel = Instance.new("TextLabel")
WarningLabel.Size = UDim2.new(1, 0, 0, 40)
WarningLabel.Position = UDim2.new(0, 0, 0.12, 0)
WarningLabel.BackgroundTransparency = 1
WarningLabel.Text = ""
WarningLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
WarningLabel.Font = Enum.Font.Code
WarningLabel.TextSize = 22
WarningLabel.Visible = false
WarningLabel.Parent = ScreenGui

local LastMurderer = nil
local AlertedForThisRound = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 290)
MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 215, 0)
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 8)
BarCorner.Parent = TitleBar

local BarLine = Instance.new("Frame")
BarLine.Size = UDim2.new(1, 0, 0, 4)
BarLine.Position = UDim2.new(0, 0, 1, -4)
BarLine.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
BarLine.BorderSizePixel = 0
BarLine.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.8, 0, 1, 0)
TitleText.Position = UDim2.new(0.04, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ QEATHUB v3.3 [" .. string.upper(CurrentGame) .. " EDITION]"
TitleText.TextColor3 = Color3.fromRGB(255, 215, 0)
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -36, 0, 0)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "[-]"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
MinimizeBtn.Font = Enum.Font.Code
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TitleBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -125, 1, -40)
ContentFrame.Position = UDim2.new(0, 120, 0, 36)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 110, 1, -40)
TabBar.Position = UDim2.new(0, 6, 0, 36)
TabBar.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame

local TabBarCorner = Instance.new("UICorner")
TabBarCorner.CornerRadius = UDim.new(0, 6)
TabBarCorner.Parent = TabBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.Padding = UDim.new(0, 4)

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 4)
TabPadding.PaddingLeft = UDim.new(0, 4)
TabPadding.PaddingRight = UDim.new(0, 4)
TabPadding.Parent = TabBar

local Pages = {}
local Tabs = {}

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 500)
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
    Page.Visible = false
    Page.Parent = ContentFrame
    
    local List = Instance.new("UIListLayout")
    List.Parent = Page
    List.Padding = UDim.new(0, 6)
    
    Pages[name] = Page
    return Page
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local WorldPage = CreatePage("World")
local MM2Page = CreatePage("MM2")

local function AddTab(name)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.BorderSizePixel = 0
    Btn.Text = " " .. name
    Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.Parent = TabBar
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Btn
    
    Tabs[name] = Btn
    
    Btn.MouseButton1Click:Connect(function()
        for k, p in pairs(Pages) do 
            p.Visible = false 
            Tabs[k].TextColor3 = Color3.fromRGB(150, 150, 150)
            Tabs[k].BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        end
        Pages[name].Visible = true
        Btn.TextColor3 = Color3.fromRGB(255, 215, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 20)
    end)
end

AddTab("Combat")
AddTab("Player")
AddTab("World")

if CurrentGame == "MM2" then
    AddTab("MM2")
    Pages["MM2"].Visible = true
    Tabs["MM2"].TextColor3 = Color3.fromRGB(255, 215, 0)
else
    Pages["Combat"].Visible = true
    Tabs["Combat"].TextColor3 = Color3.fromRGB(255, 215, 0)
end

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        TabBar.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 32), "Out", "Quad", 0.15, true)
        MinimizeBtn.Text = "[+]"
    else
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 290), "Out", "Quad", 0.15, true, function()
            ContentFrame.Visible = true
            TabBar.Visible = true
        end)
        MinimizeBtn.Text = "[-]"
    end
end)

local function CreateToggle(parent, text, configKey, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 34)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent
    
    local FCorn = Instance.new("UICorner")
    FCorn.CornerRadius = UDim.new(0, 5)
    FCorn.Parent = Frame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.04, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 30, 0, 14)
    Indicator.Position = UDim2.new(0.95, -30, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Frame
    
    local ICorn = Instance.new("UICorner")
    ICorn.CornerRadius = UDim.new(1, 0)
    ICorn.Parent = Indicator
    
    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.Position = UDim2.new(0, 2, 0.5, -5)
    Dot.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    Dot.BorderSizePixel = 0
    Dot.Parent = Indicator
    
    local DCorn = Instance.new("UICorner")
    DCorn.CornerRadius = UDim.new(1, 0)
    DCorn.Parent = Dot
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(35, 35, 35)
    Stroke.Thickness = 1
    Stroke.Parent = Frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = Frame
    
    btn.MouseButton1Click:Connect(function()
        Config.Toggles[configKey] = not Config.Toggles[configKey]
        local active = Config.Toggles[configKey]
        if active then
            TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15, 45, 15)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.15), {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = Color3.fromRGB(25, 215, 0)}):Play()
            Stroke.Color = Color3.fromRGB(255, 215, 0)
        else
            TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 15, 15)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(150, 50, 50)}):Play()
            Stroke.Color = Color3.fromRGB(35, 35, 35)
        end
        callback(active)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 42)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BorderSizePixel = 0
    Frame.Parent = parent

    local SCorn = Instance.new("UICorner")
    SCorn.CornerRadius = UDim.new(0, 5)
    SCorn.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 18)
    Label.Position = UDim2.new(0.04, 0, 0, 3)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.Font = Enum.Font.Code
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 18)
    ValueLabel.Position = UDim2.new(0.65, 0, 0, 3)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    ValueLabel.Font = Enum.Font.Code
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame

    local SliderBar = Instance.new("TextButton")
    SliderBar.Size = UDim2.new(0.92, 0, 0, 4)
    SliderBar.Position = UDim2.new(0.04, 0, 0.75, -2)
    SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SliderBar.BorderSizePixel = 0
    SliderBar.Text = ""
    SliderBar.Parent = Frame

    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local function UpdateSlider(input)
        local totalWidth = SliderBar.AbsoluteSize.X
        local relativeX = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, totalWidth)
        local ratio = relativeX / totalWidth
        local finalVal = math.floor(min + (max - min) * ratio)
        
        ValueLabel.Text = tostring(finalVal)
        SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        callback(finalVal)
    end

    local connection
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            UpdateSlider(input)
            connection = UserInputService.InputChanged:Connect(function(change)
                if change.UserInputType == Enum.UserInputType.MouseMovement or change.UserInputType == Enum.UserInputType.Touch then
                    UpdateSlider(change)
                end
            end)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if connection then connection:Disconnect() connection = nil end
        end
    end)
end

local function CreateSysButton(parent, text, color, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -10, 0, 32)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.BorderSizePixel = 0
    Btn.Text = text
    Btn.TextColor3 = color
    Btn.Font = Enum.Font.Code
    Btn.TextSize = 11
    Btn.Parent = parent
    
    local BCorn = Instance.new("UICorner")
    BCorn.CornerRadius = UDim.new(0, 5)
    BCorn.Parent = Btn
    
    local BStroke = Instance.new("UIStroke")
    BStroke.Color = color
    BStroke.Thickness = 1
    BStroke.Parent = Btn

    Btn.MouseButton1Click:Connect(callback)
end

-- ==========================================================
-- 🎯 COMBAT MODULE (ROBLOX RIVALS)
-- ==========================================================

CreateToggle(CombatPage, "Rivals Auto Aim 2.0", "AutoAim", function() end)

local function IsVisible(targetPart)
    local character = LocalPlayer.Character
    if not character then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character, Camera, targetPart.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    return raycastResult == nil
end

local function GetClosestVisiblePlayerHead()
    local closest, maxDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            if IsVisible(head) then
                local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < maxDist then closest = p.Character; maxDist = dist end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Config.Toggles.AutoAim and CurrentGame == "Rivals" then
        local targetChar = GetClosestVisiblePlayerHead()
        if targetChar and targetChar:FindFirstChild("Head") and targetChar:FindFirstChild("HumanoidRootPart") then
            local targetHead = targetChar.Head
            local targetHRP = targetChar.HumanoidRootPart
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if myHRP then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Config.AimSmoothness)
                
                local targetPosition = targetHRP.Position
                myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(targetPosition.X, myHRP.Position.Y, targetPosition.Z))
            end
        end
    end
end)

CreateToggle(CombatPage, "Hitbox Extender (Rivals Safe)", "Hitbox", function() end)
task.spawn(function()
    while true do task.wait(0.5)
        if Config.Toggles.Hitbox and CurrentGame == "Rivals" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    hrp.Transparency = 0.7; hrp.Color = Color3.fromRGB(255, 215, 0)
                    hrp.Material = Enum.Material.Neon; hrp.CanCollide = false
                end
            end
        else
            if CurrentGame == "Rivals" then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                        p.Character.HumanoidRootPart.Transparency = 1
                    end
                end
            end
        end
    end
end)

local ClickWidget = Instance.new("TextButton")
ClickWidget.Size = UDim2.new(0, 45, 0, 45)
ClickWidget.Position = UDim2.new(0.85, 0, 0.5, 0)
ClickWidget.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ClickWidget.BorderColor3 = Color3.fromRGB(255, 215, 0)
ClickWidget.Text = "TAP"
ClickWidget.TextColor3 = Color3.fromRGB(255, 215, 0)
ClickWidget.Font = Enum.Font.Code
ClickWidget.Visible = false
ClickWidget.Active = true; ClickWidget.Draggable = true
local UICorner = Instance.new("UICorner") ; UICorner.CornerRadius = UDim.new(1,0) ; UICorner.Parent = ClickWidget
local ClickStroke = Instance.new("UIStroke"); ClickStroke.Color = Color3.fromRGB(255,215,0); ClickStroke.Thickness = 1.5; ClickStroke.Parent = ClickWidget
ClickWidget.Parent = ScreenGui

CreateToggle(CombatPage, "Auto Clicker Widget", "AutoClicker", function(state) ClickWidget.Visible = state end)
local clicking = false
ClickWidget.MouseButton1Click:Connect(function()
    clicking = not clicking
    ClickWidget.BackgroundColor3 = clicking and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(20, 20, 20)
    ClickWidget.TextColor3 = clicking and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(255, 215, 0)
end)
task.spawn(function()
    while true do task.wait(0.01)
        if Config.Toggles.AutoClicker and clicking then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)

-- ==========================================================
-- ⚡ PLAYER MODULE (KARAKTER AYARLARI)
-- ==========================================================

CreateToggle(PlayerPage, "Enable Speed Changer", "Speed", function() end)
CreateSlider(PlayerPage, "Set Speed Value", 16, 150, 45, function(value) Config.WalkSpeed = value end)

RunService.RenderStepped:Connect(function()
    if Config.Toggles.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)

CreateToggle(PlayerPage, "Enable Jump Changer", "JumpPowerToggle", function() end)
CreateSlider(PlayerPage, "Set Jump Power", 50, 300, 85, function(value) Config.JumpPower = value end)

RunService.RenderStepped:Connect(function()
    if Config.Toggles.JumpPowerToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.UseJumpPower = true
        hum.JumpPower = Config.JumpPower
    end
end)

CreateToggle(PlayerPage, "Double Jump Engine", "DoubleJump", function() end)
local hasDoubleJumped = false
UserInputService.JumpRequest:Connect(function()
    if Config.Toggles.DoubleJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if hum and hum:GetState() == Enum.HumanoidStateType.FreeFall and not hasDoubleJumped then
            hasDoubleJumped = true
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, Config.JumpPower, hrp.AssemblyLinearVelocity.Z)
        end
    end
end)
RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid").FloorMaterial ~= Enum.Material.Air then
            hasDoubleJumped = false
        end
    end
end)

CreateToggle(PlayerPage, "Fly Engine", "Fly", function() end)
local flyGyro, flyVelocity
RunService.RenderStepped:Connect(function()
    if Config.Toggles.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if not hrp:FindFirstChild("QeatFlyGyro") then
            flyGyro = Instance.new("BodyGyro", hrp)
            flyGyro.Name = "QeatFlyGyro"
            flyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            
            flyVelocity = Instance.new("BodyVelocity", hrp)
            flyVelocity.Name = "QeatFlyVel"
            flyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        end
        if hum then hum.PlatformStand = true end
        flyGyro.cframe = Camera.CFrame
        flyVelocity.velocity = (hum and hum.MoveDirection or Vector3.new(0,0,0)) * Config.FlySpeed
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hrp:FindFirstChild("QeatFlyGyro") then hrp.QeatFlyGyro:Destroy() end
            if hrp:FindFirstChild("QeatFlyVel") then hrp.QeatFlyVel:Destroy() end
            if hum then hum.PlatformStand = false end
        end
    end
end)

CreateToggle(PlayerPage, "Noclip Engine", "Noclip", function() end)
RunService.Stepped:Connect(function()
    if Config.Toggles.Noclip and LocalPlayer.Character then
        for _, child in ipairs(LocalPlayer.Character:GetDescendants()) do
            if child:IsA("BasePart") then child.CanCollide = false end
        end
    end
end)

-- ==========================================================
-- 🗺️ WORLD MODULE (ESP & XRAY)
-- ==========================================================

CreateToggle(WorldPage, "Visual ESP Box", "ESP", function(state)
    if not state then
        for _, p in ipairs(Players:GetPlayers()) do
            local oldHighlight = p.Character and p.Character:FindFirstChild("QeatHighlight")
            if oldHighlight then oldHighlight:Destroy() end
        end
    end
end)

local function CreateESP(player)
    if ScreenGui:FindFirstChild(player.Name .. "_QeatESP") then return end
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = player.Name .. "_QeatESP"
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Color3 = Color3.fromRGB(255, 215, 0)
    Box.Transparency = 0.4
    Box.Size = Vector3.new(4, 5.5, 1)
    Box.Parent = ScreenGui
    
    local function updateAdornee(char)
        if char then
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then Box.Adornee = hrp end
        end
    end
    updateAdornee(player.Character)
    player.CharacterAdded:Connect(updateAdornee)
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)

RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local adorn = ScreenGui:FindFirstChild(p.Name .. "_QeatESP")
            if adorn then
                if CurrentGame == "Rivals" then
                    adorn.Visible = Config.Toggles.ESP and (p.Team ~= LocalPlayer.Team)
                else
                    if CurrentGame == "MM2" and Config.Toggles.MM2RoleESP then
                        adorn.Visible = false
                    else
                        adorn.Visible = Config.Toggles.ESP
                    end
                end
            end
        end
    end
end)

local originalTransparencies = {}
CreateToggle(WorldPage, "X-Ray Vision", "Xray", function(state)
    if state then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) and not Players:GetPlayerFromCharacter(obj.Parent) then
                if obj.Name ~= "Terrain" then originalTransparencies[obj] = obj.Transparency; obj.Transparency = 0.65 end
            end
        end
    else
        for obj, trans in pairs(originalTransparencies) do if obj and obj.Parent then obj.Transparency = trans end end
        table.clear(originalTransparencies)
    end
end)

-- ==========================================================
-- 🔪 MM2 PREMIUM FEATURES
-- ==========================================================
if CurrentGame == "MM2" then
    local function CreateSectionTitle(parent, text)
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -10, 0, 20)
        Title.BackgroundTransparency = 1
        Title.Text = "--- " .. text .. " ---"
        Title.TextColor3 = Color3.fromRGB(255, 215, 0)
        Title.Font = Enum.Font.Code
        Title.TextSize = 11
        Title.Parent = parent
    end

    -- 🛡️ INNOCENT MODULE
    CreateSectionTitle(MM2Page, "INNOCENT FEATURES")
    CreateToggle(MM2Page, "Anti-Reset Safe Zone", "MM2SafeZone", function(state)
        if state then
            if not workspace:FindFirstChild("QeatSafePlatform") then
                local Part = Instance.new("Part", workspace)
                Part.Name = "QeatSafePlatform"
                Part.Size = Vector3.new(30, 2, 30)
                Part.Position = Vector3.new(0, 800, 0)
                Part.Anchored = true
                Part.Transparency = 0.4
                Part.Color = Color3.fromRGB(255, 215, 0)
                Part.Material = Enum.Material.Neon
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 805, 0)
            end
        else
            local plat = workspace:FindFirstChild("QeatSafePlatform")
            if plat then plat:Destroy() end
        end
    end)
    CreateToggle(MM2Page, "Dynamic Role ESP", "MM2RoleESP", function(state)
        if not state then
            for _, p in ipairs(Players:GetPlayers()) do
                local oldHighlight = p.Character and p.Character:FindFirstChild("QeatHighlight")
                if oldHighlight then oldHighlight:Destroy() end
            end
        end
    end)
    
    -- 🆕 YERE DÜŞEN SİLAHI TAKİP EDEN BAĞIMSIZ YENİ HİLE BUTONU!
    CreateToggle(MM2Page, "Sheriff Gun Drop ESP", "MM2GunESP", function(state)
        if not state then
            local drop = workspace:FindFirstChild("GunDrop")
            if drop then
                if drop:FindFirstChild("QeatGunHighlight") then drop.QeatGunHighlight:Destroy() end
                if drop:FindFirstChild("QeatGunBillboard") then drop.QeatGunBillboard:Destroy() end
            end
        end
    end)

    -- 🔫 SHERIFF MODULE
    CreateSectionTitle(MM2Page, "SHERIFF FEATURES")
    CreateToggle(MM2Page, "Murderer Predictive Aim", "MM2SheriffAim", function() end)
    CreateToggle(MM2Page, "Counter Teleport & Shoot", "MM2CounterKill", function() end)

    -- 🔴 MURDERER MODULE
    CreateSectionTitle(MM2Page, "MURDERER FEATURES")
    CreateToggle(MM2Page, "Kill Aura (Teleport Loop)", "MM2KillAura", function() end)
    CreateToggle(MM2Page, "Highlight Sheriff (Green)", "MM2HighlightSheriff", function() end)

    local detectedMurdererPlayer = nil
    local GunDropAlertedThisRound = false

    -- MM2 Ana Algılama ve Takip Motoru
    RunService.RenderStepped:Connect(function()
        if not Config.Toggles.MM2RoleESP and not Config.Toggles.MM2HighlightSheriff and not Config.Toggles.MM2CounterKill and not Config.Toggles.MM2KillAura and not Config.Toggles.MM2SheriffAim and not Config.Toggles.MM2GunESP then 
            WarningLabel.Visible = false
            detectedMurdererPlayer = nil
            return 
        end
        
        local currentMurderer, currentSheriff = nil, nil
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if p.Character:FindFirstChild("Knife") or p.Character:FindFirstChild("RealKnife") then
                    currentMurderer = p
                elseif p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Python") then
                    currentSheriff = p
                end
                
                for _, child in ipairs(p.Character:GetChildren()) do
                    if child:IsA("Tool") then
                        if string.find(string.lower(child.Name), "knife") or string.find(string.lower(child.Name), "slash") or child:FindFirstChild("KnifeScript") then
                            currentMurderer = p
                        elseif string.find(string.lower(child.Name), "gun") or string.find(string.lower(child.Name), "shoot") then
                            currentSheriff = p
                        end
                    end
                end
                
                local backpack = p:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if string.find(string.lower(item.Name), "knife") then
                            currentMurderer = p
                        elseif string.find(string.lower(item.Name), "gun") then
                            currentSheriff = p
                        end
                    end
                end
            end
        end

        detectedMurdererPlayer = currentMurderer

        -- 🚨 Katil Bıçak Çektiğinde Çalışan Alarm
        if currentMurderer and currentMurderer.Character then
            if currentMurderer.Character:FindFirstChildOfClass("Tool") and (not AlertedForThisRound or LastMurderer ~= currentMurderer) then
                LastMurderer = currentMurderer
                AlertedForThisRound = true
                
                WarningLabel.Text = "⚠️ DIKKAT: " .. string.upper(currentMurderer.Name) .. " BICAK CEKTI! ⚠️"
                WarningLabel.Visible = true
                WarningSound:Play()
                
                task.delay(4, function()
                    if LastMurderer == currentMurderer then WarningLabel.Visible = false end
                end)
            end
        end

        -- 🎯 🆕 GUN DROP ESP GÖRSEL MOTORU
        if Config.Toggles.MM2GunESP then
            local drop = workspace:FindFirstChild("GunDrop")
            if drop and drop:IsA("BasePart") then
                -- Silah Düştüğünde Ekranın Üstüne Yazı ve Ses Ver
                if not GunDropAlertedThisRound then
                    GunDropAlertedThisRound = true
                    WarningLabel.Text = "🚨 TABANCA DÜŞTÜ! KOŞ AL! 🚨"
                    WarningLabel.Visible = true
                    WarningSound:Play()
                    task.delay(4, function() WarningLabel.Visible = false end)
                end

                -- Mor Vurgu Parlaması (Highlight)
                local high = drop:FindFirstChild("QeatGunHighlight")
                if not high then
                    high = Instance.new("Highlight")
                    high.Name = "QeatGunHighlight"
                    high.FillColor = Color3.fromRGB(180, 0, 255) -- Parlak Mor
                    high.OutlineColor = Color3.fromRGB(255, 255, 255)
                    high.FillTransparency = 0.3
                    high.Adornee = drop
                    high.Parent = drop
                end

                -- Silahın Üstünde 3D Yazı Göstergesi (Billboard)
                local bill = drop:FindFirstChild("QeatGunBillboard")
                if not bill then
                    bill = Instance.new("BillboardGui")
                    bill.Name = "QeatGunBillboard"
                    bill.Size = UDim2.new(0, 120, 0, 30)
                    bill.AlwaysOnTop = true
                    bill.ExtentsOffset = Vector3.new(0, 2.5, 0)
                    
                    local txt = Instance.new("TextLabel")
                    txt.Size = UDim2.new(1, 0, 1, 0)
                    txt.BackgroundTransparency = 1
                    txt.Text = "🔫 TABANCA BURADA!"
                    txt.TextColor3 = Color3.fromRGB(180, 0, 255)
                    txt.Font = Enum.Font.Code
                    txt.TextSize = 13
                    txt.Parent = bill
                    bill.Parent = drop
                end
            end
        end

        -- 🎨 Oyuncu Rol Highlight Renklendirmeleri
        if Config.Toggles.MM2RoleESP then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local highlight = p.Character:FindFirstChild("QeatHighlight")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "QeatHighlight"
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Adornee = p.Character
                        highlight.Parent = p.Character
                    end

                    if p == currentMurderer then
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                    elseif p == currentSheriff then
                        if Config.Toggles.MM2HighlightSheriff then
                            highlight.FillColor = Color3.fromRGB(0, 255, 0)
                            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                        else
                            highlight.FillColor = Color3.fromRGB(0, 0, 255)
                            highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
                        end
                    else
                        highlight.FillColor = Color3.fromRGB(255, 215, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
                    end
                end
            end
        end

        -- Counter Kill Tetikleyicisi
        if Config.Toggles.MM2CounterKill and currentMurderer and currentMurderer.Character and currentMurderer.Character:FindFirstChild("Knife") then
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHRP = currentMurderer.Character:FindFirstChild("HumanoidRootPart")
            if myHRP and targetHRP then
                myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 4)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end

        -- Kill Aura Tetikleyicisi
        if Config.Toggles.MM2KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife") then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                    if p ~= currentSheriff or (currentSheriff and not currentSheriff.Character:FindFirstChild("Gun")) then
                        local myHRP = LocalPlayer.Character.HumanoidRootPart
                        myHRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                        task.wait(0.02)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end
                end
            end
        end
    end)

    -- Şerif Auto Aim Motoru (Katil Önbelleğine Kilitlenme)
    RunService.RenderStepped:Connect(function()
        if Config.Toggles.MM2SheriffAim and CurrentGame == "MM2" then
            if detectedMurdererPlayer and detectedMurdererPlayer.Character and detectedMurdererPlayer.Character:FindFirstChild("HumanoidRootPart") and detectedMurdererPlayer.Character:FindFirstChild("Humanoid") and detectedMurdererPlayer.Character.Humanoid.Health > 0 then
                local targetPart = detectedMurdererPlayer.Character:FindFirstChild("Chest") or detectedMurdererPlayer.Character:FindFirstChild("HumanoidRootPart")
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myHRP and targetPart then
                    Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPart.Position), Config.AimSmoothness)
                end
            end
        end
    end)

    -- Harita Yenilenmesini İzleyen Döngü
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "Normal" or child:IsA("Model") then
            AlertedForThisRound = false
            GunDropAlertedThisRound = false
            LastMurderer = nil
            WarningLabel.Visible = false
        end
        
        if Config.Toggles.MM2SafeZone then
            task.wait(2.5)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 805, 0)
            end
        end
    end)
end

-- SYSTEM BUTTONS
CreateSysButton(WorldPage, " [>] Inject Infinite Yield", Color3.fromRGB(255, 165, 0), function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeY/infiniteyield/master/source'))()
end)

CreateSysButton(WorldPage, " [!] TERMINATE QEATHUB", Color3.fromRGB(255, 50, 50), function()
    for k, _ in pairs(Config.Toggles) do Config.Toggles[k] = false end
    local plat = workspace:FindFirstChild("QeatSafePlatform")
    if plat then plat:Destroy() end
    for _, p in ipairs(Players:GetPlayers()) do
        local oldHighlight = p.Character and p.Character:FindFirstChild("QeatHighlight")
        if oldHighlight then oldHighlight:Destroy() end
    end
    ScreenGui:Destroy()
end)
