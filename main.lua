--[[
	====================================================================
	  - QeatHub Universal Premium
	  - Edition: v3.4 [AUTOMATIC MODULAR ENGINE]
	====================================================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ==========================================================
-- 🛠️ OTOMATİK GITHUB BULUCU MOTORU (TAK-ÇALIŞTIR)
-- ==========================================================
local BaseURL = "https://raw.githubusercontent.com/KendiGithubKullaniciAdin/YeniRepoAdin/main/"

-- Eğer loadstring url'sinden çalıştırılıyorsa repo yolunu otomatik algıla
local scriptUrl = (getfenv and getfenv().script and getfenv().script.ClassName == "StringValue" and getfenv().script.Value) or ""
if string.find(scriptUrl, "raw.githubusercontent.com") then
    local cleanUrl = string.gsub(scriptUrl, "main.lua", "")
    if string.sub(cleanUrl, -1) ~= "/" then cleanUrl = cleanUrl .. "/" end
    BaseURL = cleanUrl
end

-- Oyun Tespiti
_G.CurrentGame = "Universal"
if game.PlaceId == 142823291 or game.GameId == 506727284 then _G.CurrentGame = "MM2"
elseif game.PlaceId == 17625359962 or Workspace:FindFirstChild("Rivals_Assets") then _G.CurrentGame = "Rivals" end

-- Eski UI Temizliği
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("QeatHUB_Premium") then
    LocalPlayer.PlayerGui.QeatHUB_Premium:Destroy()
end

-- Global Konfigürasyon Yapısı
_G.Config = {
    WalkSpeed = 16, JumpPower = 50, FlySpeed = 50, HitboxSize = 12, AimSmoothness = 0.32,
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
WarningLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
WarningLabel.Font = Enum.Font.Code
WarningLabel.TextSize = 22
WarningLabel.Visible = false

_G.ShowWarning = function(text)
    WarningLabel.Text = text
    WarningLabel.Visible = true
    WarningSound:Play()
    task.delay(4, function() if WarningLabel.Text == text then WarningLabel.Visible = false end end)
end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 290)
MainFrame.Position = UDim2.new(0.15, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 215, 0); UIStroke.Thickness = 1.5

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 32); TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(0.8, 0, 1, 0); TitleText.Position = UDim2.new(0.04, 0, 0, 0)
TitleText.BackgroundTransparency = 1; TitleText.Text = "⚡ QEATHUB v3.4 [" .. string.upper(_G.CurrentGame) .. " EDITION]"
TitleText.TextColor3 = Color3.fromRGB(255, 215, 0); TitleText.Font = Enum.Font.Code

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32); MinimizeBtn.Position = UDim2.new(1, -36, 0, 0)
MinimizeBtn.BackgroundTransparency = 1; MinimizeBtn.Text = "[-]"; MinimizeBtn.TextColor3 = Color3.fromRGB(255, 215, 0); MinimizeBtn.Font = Enum.Font.Code

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -125, 1, -40); ContentFrame.Position = UDim2.new(0, 120, 0, 36)
ContentFrame.BackgroundTransparency = 1

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(0, 110, 1, -40); TabBar.Position = UDim2.new(0, 6, 0, 36)
TabBar.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
local TabListLayout = Instance.new("UIListLayout", TabBar); TabListLayout.Padding = UDim.new(0, 4)

local Pages, Tabs = {}, {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", ContentFrame)
    Page.Size = UDim2.new(1, 0, 1, 0); Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 0, 520); Page.ScrollBarThickness = 2
    Page.Visible = false
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)
    Pages[name] = Page
    return Page
end

local CombatPage = CreatePage("Combat")
local PlayerPage = CreatePage("Player")
local WorldPage = CreatePage("World")
local MM2Page = CreatePage("MM2")

local function AddTab(name)
    local Btn = Instance.new("TextButton", TabBar)
    Btn.Size = UDim2.new(1, 0, 0, 32); Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.Text = " " .. name; Btn.TextColor3 = Color3.fromRGB(150, 150, 150); Btn.Font = Enum.Font.Code
    Tabs[name] = Btn
    Btn.MouseButton1Click:Connect(function()
        for k, p in pairs(Pages) do p.Visible = false; Tabs[k].TextColor3 = Color3.fromRGB(150, 150, 150) end
        Pages[name].Visible = true; Btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    end)
end

AddTab("Combat"); AddTab("Player"); AddTab("World")
if _G.CurrentGame == "MM2" then AddTab("MM2"); Pages["MM2"].Visible = true else Pages["Combat"].Visible = true end

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false; TabBar.Visible = false
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 32), "Out", "Quad", 0.15, true)
        MinimizeBtn.Text = "[+]"
    else
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 290), "Out", "Quad", 0.15, true, function() ContentFrame.Visible = true; TabBar.Visible = true end)
        MinimizeBtn.Text = "[-]"
    end
end)

local function CreateToggle(parent, text, configKey, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 34); Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.7, 0, 1, 0); Label.Position = UDim2.new(0.04, 0, 0, 0)
    Label.BackgroundTransparency = 1; Label.Text = text; Label.TextColor3 = Color3.fromRGB(220, 220, 220); Label.Font = Enum.Font.Code
    local Indicator = Instance.new("Frame", Frame)
    Indicator.Size = UDim2.new(0, 30, 0, 14); Indicator.Position = UDim2.new(0.95, -30, 0.5, -7); Indicator.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
    local Dot = Instance.new("Frame", Indicator)
    Dot.Size = UDim2.new(0, 10, 0, 10); Dot.Position = UDim2.new(0, 2, 0.5, -5); Dot.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""
    btn.MouseButton1Click:Connect(function()
        _G.Config.Toggles[configKey] = not _G.Config.Toggles[configKey]
        local active = _G.Config.Toggles[configKey]
        if active then
            TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(15, 45, 15)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.15), {Position = UDim2.new(1, -12, 0.5, -5), BackgroundColor3 = Color3.fromRGB(25, 215, 0)}):Play()
        else
            TweenService:Create(Indicator, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 15, 15)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.15), {Position = UDim2.new(0, 2, 0.5, -5), BackgroundColor3 = Color3.fromRGB(150, 50, 50)}):Play()
        end
        if callback then callback(active) end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 42); Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(0.6, 0, 0, 18); Label.Position = UDim2.new(0.04, 0, 0, 3); Label.BackgroundTransparency = 1; Label.Text = text; Label.TextColor3 = Color3.fromRGB(180, 180, 180); Label.Font = Enum.Font.Code
    local ValueLabel = Instance.new("TextLabel", Frame)
    ValueLabel.Size = UDim2.new(0.3, 0, 0, 18); ValueLabel.Position = UDim2.new(0.65, 0, 0, 3); ValueLabel.BackgroundTransparency = 1; ValueLabel.Text = tostring(default); ValueLabel.TextColor3 = Color3.fromRGB(255, 215, 0); ValueLabel.Font = Enum.Font.Code
    local SliderBar = Instance.new("TextButton", Frame)
    SliderBar.Size = UDim2.new(0.92, 0, 0, 4); SliderBar.Position = UDim2.new(0.04, 0, 0.75, -2); SliderBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35); SliderBar.Text = ""
    local SliderFill = Instance.new("Frame", SliderBar)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); SliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    local function UpdateSlider(input)
        local ratio = math.clamp(input.Position.X - SliderBar.AbsolutePosition.X, 0, SliderBar.AbsoluteSize.X) / SliderBar.AbsoluteSize.X
        local finalVal = math.floor(min + (max - min) * ratio)
        ValueLabel.Text = tostring(finalVal); SliderFill.Size = UDim2.new(ratio, 0, 1, 0); callback(finalVal)
    end
    local conn
    SliderBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then UpdateSlider(i) conn = game:GetService("UserInputService").InputChanged:Connect(function(c) if c.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(c) end end) end end)
    game:GetService("UserInputService").InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 and conn then conn:Disconnect() conn = nil end end)
end

local function CreateSysButton(parent, text, color, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 32); Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22); Btn.Text = text; Btn.TextColor3 = color; Btn.Font = Enum.Font.Code
    Btn.MouseButton1Click:Connect(callback)
end

local ClickWidget = Instance.new("TextButton", ScreenGui)
ClickWidget.Size = UDim2.new(0, 45, 0, 45); ClickWidget.Position = UDim2.new(0.85, 0, 0.5, 0); ClickWidget.BackgroundColor3 = Color3.fromRGB(20, 20, 20); ClickWidget.Text = "TAP"; ClickWidget.TextColor3 = Color3.fromRGB(255, 215, 0); ClickWidget.Font = Enum.Font.Code; ClickWidget.Visible = false; ClickWidget.Active = true; ClickWidget.Draggable = true
Instance.new("UICorner", ClickWidget).CornerRadius = UDim.new(1,0)
_G.ClickingActive = false
ClickWidget.MouseButton1Click:Connect(function()
    _G.ClickingActive = not _G.ClickingActive
    ClickWidget.BackgroundColor3 = _G.ClickingActive and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(20, 20, 20)
    ClickWidget.TextColor3 = _G.ClickingActive and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(255, 215, 0)
end)

-- UI Elemanlarının İnşası
CreateToggle(CombatPage, "Rivals Auto Aim 2.0", "AutoAim")
CreateToggle(CombatPage, "Hitbox Extender", "Hitbox")
CreateSlider(CombatPage, "Hitbox Size Slider", 2, 50, 12, function(v) _G.Config.HitboxSize = v end)
CreateToggle(CombatPage, "Auto Clicker Widget", "AutoClicker", function(s) ClickWidget.Visible = s end)

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
    local function AddTitle(txt) local l = Instance.new("TextLabel", MM2Page) l.Size = UDim2.new(1,-10,0,20); l.BackgroundTransparency = 1; l.Text = "--- "..txt.." ---"; l.TextColor3 = Color3.fromRGB(255, 215, 0); l.Font = Enum.Font.Code end
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
-- 🚀 SUB-MODULE INJECTION ENGINE
-- ==========================================================
local function InjectModule(path)
    local s, res = pcall(function() return loadstring(game:HttpGet(BaseURL .. path))() end)
    if not s then warn("QeatHub Engine Error [" .. path .. "]: " .. tostring(res)) end
end

-- Tüm hile alt dosyalarını arka planda sırayla çekip entegre et
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

-- Sistem Buton Bağlantıları
CreateSysButton(WorldPage, " [>] Inject Infinite Yield", Color3.fromRGB(255, 165, 0), function()
    InjectModule("other/inf_yield.lua")
end)

CreateSysButton(WorldPage, " [!] TERMINATE QEATHUB", Color3.fromRGB(255, 50, 50), function()
    InjectModule("other/terminate.lua")
end)