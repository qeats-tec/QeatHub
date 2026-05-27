--[[
	====================================================================
	  - QeatHub Universal Premium
	  - Edition: v4.1 [MINI MODE & ANIMATED MODERN UI]
	====================================================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Senin Net GitHub Raw Bağlantın
local BaseURL = "https://raw.githubusercontent.com/qeats-tec/QeatHub/refs/heads/main/"

-- Oyun Tespiti
_G.CurrentGame = "Universal"
if game.PlaceId == 142823291 or game.GameId == 506727284 then _G.CurrentGame = "MM2"
elseif game.PlaceId == 17625359962 or Workspace:FindFirstChild("Rivals_Assets") then _G.CurrentGame = "Rivals" end

-- Eski UI Temizliği
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("QeatHUB_Premium") then
    LocalPlayer.PlayerGui.QeatHUB_Premium:Destroy()
end

-- 🛠️ GLOBAL CONFIG
_G.Config = {
    WalkSpeed = 45, JumpPower = 85, FlySpeed = 50, HitboxSize = 12, AimSmoothness = 0.32,
    Toggles = {
        Hitbox = false, AutoClicker = false, Speed = false, JumpPowerToggle = false,
        Xray = false, ESP = false, Noclip = false, AutoAim = false, Fly = false, DoubleJump = false,
        MM2SafeZone = false, MM2RoleESP = false, MM2SheriffAim = false,
        MM2CounterKill = false, MM2KillAura = false, MM2HighlightSheriff = false, MM2GunESP = false
    }
}

-- Arayüz Kurulumu
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QeatHUB_Premium"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui
_G.MainGuiInstance = ScreenGui

local WarningSound = Instance.new("Sound", Workspace)
WarningSound.SoundId = "rbxassetid://1222213261"
WarningSound.Volume = 2

local WarningLabel = Instance.new("TextLabel", ScreenGui)
WarningLabel.Size = UDim2.new(1, 0, 0, 40)
WarningLabel.Position = UDim2.new(0, 0, 0.12, 0)
WarningLabel.BackgroundTransparency = 1
WarningLabel.Text = ""
WarningLabel.TextColor3 = Color3.fromRGB(255, 204, 0)
WarningLabel.Font = Enum.Font.Code
WarningLabel.TextSize = 22
WarningLabel.Visible = false

_G.ShowWarning = function(text)
    WarningLabel.Text = "⚠️ " .. text
    WarningLabel.Visible = true
    WarningSound:Play()
    task.delay(4, function() if WarningLabel.Text == "⚠️ " .. text then WarningLabel.Visible = false end end)
end

-- ==========================================================
-- 🎬 İNTRO & LOGO ANİMASYONU
-- ==========================================================
local IntroFrame = Instance.new("Frame", ScreenGui)
IntroFrame.Size = UDim2.new(0, 300, 0, 150)
IntroFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
IntroFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
IntroFrame.BackgroundTransparency = 1
IntroFrame.BorderSizePixel = 0

local IntroCorner = Instance.new("UICorner", IntroFrame)
IntroCorner.CornerRadius = UDim.new(0, 16)

local IntroStroke = Instance.new("UIStroke", IntroFrame)
IntroStroke.Color = Color3.fromRGB(255, 204, 0)
IntroStroke.Thickness = 2
IntroStroke.Transparency = 1

local IntroText = Instance.new("TextLabel", IntroFrame)
IntroText.Size = UDim2.new(1, 0, 0, 60)
IntroText.Position = UDim2.new(0, 0, 0.2, 0)
IntroText.BackgroundTransparency = 1
IntroText.Text = "QeatHUB"
IntroText.TextColor3 = Color3.fromRGB(255, 204, 0)
IntroText.Font = Enum.Font.Code
IntroText.TextSize = 42
IntroText.TextTransparency = 1

local IntroSubText = Instance.new("TextLabel", IntroFrame)
IntroSubText.Size = UDim2.new(1, 0, 0, 30)
IntroSubText.Position = UDim2.new(0, 0, 0.6, 0)
IntroSubText.BackgroundTransparency = 1
IntroSubText.Text = "Sistem Yükleniyor..."
IntroSubText.TextColor3 = Color3.fromRGB(150, 150, 160)
IntroSubText.Font = Enum.Font.Code
IntroSubText.TextSize = 14
IntroSubText.TextTransparency = 1

-- ==========================================================
-- 🛠️ ANA PANEL (MODERN SİBER TEMALI)
-- ==========================================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 440, 0, 320)
MainFrame.Position = UDim2.new(0.5, -220, 1.2, 0) -- Giriş animasyonu için aşağıda başlıyor
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = false
MainFrame.Visible = false

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 204, 0)
UIStroke.Thickness = 1.5

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0.04, 0, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "⚡ QEATHUB v4.1 // " .. string.upper(_G.CurrentGame) .. " PREMIUM"
TitleText.TextColor3 = Color3.fromRGB(255, 204, 0)
TitleText.Font = Enum.Font.Code
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- [ New ] Mini Mode Butonu (Kare)
local MiniModeBtn = Instance.new("TextButton", TitleBar)
MiniModeBtn.Size = UDim2.new(0, 32, 0, 32)
MiniModeBtn.Position = UDim2.new(1, -72, 0, 3)
MiniModeBtn.BackgroundTransparency = 1
MiniModeBtn.Text = "[▢]"
MiniModeBtn.TextColor3 = Color3.fromRGB(255, 204, 0)
MiniModeBtn.Font = Enum.Font.Code
MiniModeBtn.TextSize = 14

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -38, 0, 3)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "[-]"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 204, 0)
MinimizeBtn.Font = Enum.Font.Code

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -145, 1, -48)
ContentFrame.Position = UDim2.new(0, 135, 0, 44)
ContentFrame.BackgroundTransparency = 1

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0, 115, 1, -52)
TabBar.Position = UDim2.new(0, 10, 0, 44)
TabBar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 8)
local TabListLayout = Instance.new("UIListLayout", TabBar); TabListLayout.Padding = UDim.new(0, 5)

-- ==========================================================
-- 🔄 [ YENİ ÖZELLİK ] MİNİ BUTON MODU (WIDGET OLUŞTURMA)
-- ==========================================================
local MiniWidget = Instance.new("TextButton", ScreenGui)
MiniWidget.Size = UDim2.new(0, 45, 0, 45)
MiniWidget.Position = UDim2.new(0.02, 0, 0.2, 0)
MiniWidget.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
MiniWidget.BorderSizePixel = 0
MiniWidget.Text = "Q"
MiniWidget.TextColor3 = Color3.fromRGB(255, 204, 0)
MiniWidget.Font = Enum.Font.Code
MiniWidget.TextSize = 24
MiniWidget.Visible = false
MiniWidget.Active = true
MiniWidget.Draggable = true

local MiniWidgetCorner = Instance.new("UICorner", MiniWidget)
MiniWidgetCorner.CornerRadius = UDim.new(0, 10)

local MiniWidgetStroke = Instance.new("UIStroke", MiniWidget)
MiniWidgetStroke.Color = Color3.fromRGB(255, 204, 0)
MiniWidgetStroke.Thickness = 2

-- ==========================================================
-- 🎛️ PANEL KÜÇÜLTME & MİNİ MOD KONTROLLERİ
-- ==========================================================
local isMinimized = false

-- Klasik Satır Haline Getirme Tuşu
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false; TabBar.Visible = false; MiniModeBtn.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 440, 0, 38), "Out", "Quad", 0.15, true)
        MinimizeBtn.Text = "[+]"
    else
        MainFrame:TweenSize(UDim2.new(0, 440, 0, 320), "Out", "Quad", 0.15, true, function() 
            ContentFrame.Visible = true; TabBar.Visible = true; MiniModeBtn.Visible = true 
        end)
        MinimizeBtn.Text = "[-]"
    end
end)

-- Dehşet Kare Tuşu: Tamamen Ufacık Butona Çevirme
MiniModeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniWidget.Visible = true
    -- Dönüşürken ufak bir parlayış efekti
    MiniWidget.Size = UDim2.new(0, 55, 0, 55)
    TweenService:Create(MiniWidget, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 45, 0, 45)}):Play()
end)

-- Ufalan Butondan Eski Haline Geri Dönme Tuşu
MiniWidget.MouseButton1Click:Connect(function()
    MiniWidget.Visible = false
    MainFrame.Visible = true
    -- Aşağıdan yukarı açılma efektini tekrar tetikle
    MainFrame.Size = UDim2.new(0, 440, 0, 320)
    local oldPos = MainFrame.Position
    MainFrame.Position = UDim2.new(oldPos.X.Scale, oldPos.X.Offset, oldPos.Y.Scale, oldPos.Y.Offset + 50)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = oldPos}):Play()
end)

-- ==========================================================
-- SAYFA VE ÖZELLİK EKLEME FONKSİYONLARI
-- ==========================================================
local Pages, Tabs = {}, {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 550); Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 204, 0)
    Page.Visible = false
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 7)
    Pages[name] = Page
    return Page
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local WorldPage = CreatePage("World")
local MM2Page = CreatePage("MM2")

local function AddTab(name, displayName)
    local Btn = Instance.new("TextButton", TabBar)
    Btn.Size = UDim2.new(1, 0, 0, 34); Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Btn.Text = "  " .. displayName; Btn.TextColor3 = Color3.fromRGB(140, 140, 150); Btn.Font = Enum.Font.Code; Btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Tabs[name] = Btn
    Btn.MouseButton1Click:Connect(function()
        for k, p in pairs(Pages) do p.Visible = false; Tabs[k].TextColor3 = Color3.fromRGB(140, 140, 150) end
        Pages[name].Visible = true; Btn.TextColor3 = Color3.fromRGB(255, 204, 0)
    end)
end

AddTab("Combat", "Çatışma"); AddTab("Player", "Karakter"); AddTab("World", "Çevre / ESP")
if _G.CurrentGame == "MM2" then AddTab("MM2", "MM2 Özel"); Pages["MM2"].Visible = true else Pages["Combat"].Visible = true end

local function CreateToggle(parent, text, configKey, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 36); Frame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0.04, 0, 0, 0)
    Label.BackgroundTransparency = 1; Label.Text = text; Label.TextColor3 = Color3.fromRGB(230, 230, 235); Label.Font = Enum.Font.Code; Label.TextXAlignment = Enum.TextXAlignment.Left
    local Indicator = Instance.new("Frame", Frame)
    Indicator.Size = UDim2.new(0, 32, 0, 16); Indicator.Position = UDim2.new(0.95, -32, 0.5, -8); Indicator.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    local Dot = Instance.new("Frame", Indicator)
    Dot.Size = UDim2.new(0, 12, 0, 12); Dot.Position = UDim2.new(0, 2, 0.5, -6); Dot.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""
    btn.MouseButton1Click:Connect(function()
        _G.Config.Toggles[configKey] = not _G.Config.Toggles[configKey]
        local active = _G.Config.Toggles[configKey]
        if active then
            TweenService:Create(Indicator, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(15, 40, 15)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.12), {Position = UDim2.new(1, -14, 0.5, -6), BackgroundColor3 = Color3.fromRGB(255, 204, 0)}):Play()
        else
            TweenService:Create(Indicator, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30, 10, 10)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.12), {Position = UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Color3.fromRGB(160, 40, 40)}):Play()
        end
        if callback then callback(active) end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 44); Frame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 0, 20); Label.Position = UDim2.new(0.04, 0, 0, 4); Label.BackgroundTransparency = 1; Label.Text = text; Label.TextColor3 = Color3.fromRGB(170, 170, 180); Label.Font = Enum.Font.Code; Label.TextXAlignment = Enum.TextXAlignment.Left
    local ValueLabel = Instance.new("TextLabel", Frame)
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 20); ValueLabel.Position = UDim2.new(0.65, 0, 0, 4); ValueLabel.BackgroundTransparency = 1; ValueLabel.Text = tostring(default); ValueLabel.TextColor3 = Color3.fromRGB(255, 204, 0); ValueLabel.Font = Enum.Font.Code; ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    local SliderBar = Instance.new("TextButton", Frame)
    SliderBar.Size = UDim2.new(0.92, 0, 0, 4); SliderBar.Position = UDim2.new(0.04, 0, 0.76, -2); SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35); SliderBar.Text = ""
    local SliderFill = Instance.new("Frame", SliderBar)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); SliderFill.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
    
    local function UpdateSlider(input)
        local ratio = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X) / SliderBar.AbsoluteSize.X
        local finalVal = math.floor(min + (max - min) * ratio)
        ValueLabel.Text = tostring(finalVal); SliderFill.Size = UDim2.new(ratio, 0, 1, 0)
        callback(finalVal)
    end
    local conn
    SliderBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then UpdateSlider(i) conn = UserInputService.InputChanged:Connect(function(c) if c.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(c) end end) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 and conn then conn:Disconnect() conn = nil end end)
end

local function CreateSysButton(parent, text, color, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 34); Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 26); Btn.Text = text; Btn.TextColor3 = color; Btn.Font = Enum.Font.Code
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

-- ÖZELLİKLERİ HARİTALA
CreateToggle(CombatPage, "Rivals Auto Aim 2.0", "AutoAim")
CreateToggle(CombatPage, "Hitbox Extender", "Hitbox")
CreateSlider(CombatPage, "Hitbox Size Slider", 2, 50, 12, function(v) _G.Config.HitboxSize = v end)
CreateToggle(CombatPage, "Auto Clicker Widget", "AutoClicker")

CreateToggle(PlayerPage, "Enable Speed Changer", "Speed")
CreateSlider(PlayerPage, "Set Speed Value", 16, 150, 45, function(v) _G.Config.WalkSpeed = v end)
CreateToggle(PlayerPage, "Enable Jump Changer", "JumpPowerToggle")
CreateSlider(PlayerPage, "Set Jump Power", 50, 300, 85, function(v) _G.Config.JumpPower = v end)
CreateToggle(PlayerPage, "Double Jump Engine", "DoubleJump")
CreateToggle(PlayerPage, "Fly Engine", "Fly")
CreateSlider(PlayerPage, "Fly Speed Value", 10, 300, 50, function(v) _G.Config.FlySpeed = v end)
CreateToggle(PlayerPage, "Noclip Engine", "Noclip")

CreateToggle(WorldPage, "Visual ESP Box", "ESP")
CreateToggle(WorldPage, "X-Ray Vision", "Xray")

if _G.CurrentGame == "MM2" then
    local function AddTitle(txt) local l = Instance.new("TextLabel", MM2Page) l.Size = UDim2.new(1,-10,0,24); l.BackgroundTransparency = 1; l.Text = "// " .. txt .. " //"; l.TextColor3 = Color3.fromRGB(255, 204, 0); l.Font = Enum.Font.Code end
    AddTitle("INNOCENT FEATURES")
    CreateToggle(MM2Page, "Anti-Reset Safe Zone", "MM2SafeZone")
    CreateToggle(MM2Page, "Dynamic Role ESP", "MM2RoleESP")
    CreateToggle(MM2Page, "Sheriff Gun Drop ESP", "MM2GunESP")
    AddTitle("SHERIFF FEATURES")
    CreateToggle(MM2Page, "Murderer Predictive Aim", "MM2SheriffAim")
    CreateToggle(MM2Page, "Counter Teleport & Shoot", "MM2CounterKill")
    AddTitle("MURDERER FEATURES")
    CreateToggle(MM2Page, "Kill Aura (Teleport)", "MM2KillAura")
    CreateToggle(MM2Page, "Highlight Sheriff (Green)", "MM2HighlightSheriff")
end

-- ==========================================================
-- 🚀 MODÜL ENJEKTE MOTORU
-- ==========================================================
local function InjectModule(path)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(BaseURL .. path))()
    end)
    if not success then
        warn("🔴 QeatHub Klasör Motoru Hatası [" .. path .. "]: " .. tostring(result))
    end
end

InjectModule("combat/autoaim.lua")
InjectModule("combat/hitbox.lua")
InjectModule("combat/autoclicker.lua")
InjectModule("player/movement.lua")
InjectModule("world/esp.lua")
InjectModule("world/xray.lua")

if _G.CurrentGame == "MM2" then
    InjectModule("mm2/innocent.lua")
    InjectModule("mm2/roles.lua")
    InjectModule("mm2/sheriff_murderer.lua")
end

CreateSysButton(WorldPage, " [>] Inject Infinite Yield", Color3.fromRGB(255, 165, 0), function()
    InjectModule("other/inf_yield.lua")
end)

CreateSysButton(WorldPage, " [!] TERMINATE QEATHUB", Color3.fromRGB(255, 50, 50), function()
    InjectModule("other/terminate.lua")
end)

-- ==========================================================
-- ⚡ AÇILIŞ TWEEN AKIŞI
-- ==========================================================
task.spawn(function()
    TweenService:Create(IntroFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(IntroStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    task.wait(0.4)
    TweenService:Create(IntroSubText, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    
    task.wait(2.2)
    
    TweenService:Create(IntroFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    TweenService:Create(IntroStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Transparency = 1}):Play()
    TweenService:Create(IntroText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    TweenService:Create(IntroSubText, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    
    task.wait(0.5)
    IntroFrame:Destroy()
    
    MainFrame.Visible = true
    MainFrame.Active = true; MainFrame.Draggable = true
    MainFrame:TweenPosition(UDim2.new(0.15, 0, 0.25, 0), "Out", "Back", 0.7, true)
end)
