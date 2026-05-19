-- ====================================================================
-- 💛 QEATHUB UNIVERSAL v3.6 - FULLY INDEPENDENT REBUILT (2026)
-- ====================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Eski sürümleri hafızadan tamamen kazıyalım
if PlayerGui:FindFirstChild("QeatHubDelta") then
    PlayerGui.QeatHubDelta:Destroy()
end

-- ANA CONTAINER
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QeatHubDelta"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ANA PANEL (Hacker Havası: Sade, Siyah ve Neon Sarı)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(255, 215, 0) -- Saf Sarı
MainStroke.Parent = MainFrame

-- LOGO / BAŞLIK
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "💛 QeatHub v3.6 | Independent Stable"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- SOL PANEL (SEKMELER)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 120, 1, -55)
TabBar.Position = UDim2.new(0, 10, 0, 45)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 5)
TabList.Parent = TabBar

-- SAĞ PANEL (ÖZELLİKLER)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -150, 1, -55)
Container.Position = UDim2.new(0, 140, 0, 45)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local pages = {}
local currentTab = nil

-- SEKMELERİ OLUŞTURAN MOTOR
local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.CanvasSize = UDim2.new(0, 0, 0, 500)
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
    Page.Visible = false
    Page.Parent = Container

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 6)
    PageList.Parent = Page

    pages[name] = Page

    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 12
    TabBtn.Parent = TabBar

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = TabBtn

    TabBtn.MouseButton1Click:Connect(function()
        if currentTab then currentTab.Visible = false end
        for _, btn in pairs(TabBar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
        Page.Visible = true
        currentTab = Page
    end)

    if not currentTab then
        TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        TabBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
        Page.Visible = true
        currentTab = Page
    end
end

-- STANDARD BUTON EKLEME (Callback'e butonun kendisini paslıyoruz)
local function NewButton(tab, name, callback)
    local targetPage = pages[tab]
    if not targetPage then return end

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 12
    Btn.Parent = targetPage

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 4)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        callback(Btn) -- Hata düzeltmesi: self yerine doğrudan Btn objesini gönderiyoruz
    end)
end

-- INPUT (VERİ GİRİŞLİ) BUTON EKLEME
local function NewInput(tab, placeholder, btnText, callback)
    local targetPage = pages[tab]
    if not targetPage then return end

    local BoxFrame = Instance.new("Frame")
    BoxFrame.Size = UDim2.new(1, -5, 0, 35)
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.Parent = targetPage

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.4, -5, 1, 0)
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 12
    Box.Parent = BoxFrame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = Box

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.6, 0, 1, 0)
    Btn.Position = UDim2.new(0.4, 0, 0, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Btn.Text = btnText
    Btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = 12
    Btn.Parent = BoxFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        callback(Box.Text)
    end)
end

-- ==========================================
--  KATEGORİLER
-- ==========================================
CreateTab("🎯 Combat")
CreateTab("⚡ Player")
CreateTab("🗺️ World")
CreateTab("🛠️ System")

-- ==========================================
--  🔥 MODÜLLER
-- ==========================================

-- [1] WALKSPEED MODÜLÜ
local currentSpeed = 16
NewInput("⚡ Player", "Hız (Örn: 60)", "⚡ Hızı Değiştir", function(val)
    local num = tonumber(val)
    if num then
        currentSpeed = num
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = currentSpeed end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then hum.WalkSpeed = currentSpeed end
end)

-- [2] INFINITE JUMP MODÜLÜ
local infJumpActive = false
NewButton("⚡ Player", "🎚️ Sonsuz Zıplama: KAPALI", function(buttonObj)
    infJumpActive = not infJumpActive
    if infJumpActive then
        buttonObj.Text = "🎚️ Sonsuz Zıplama: AKTİF"
    else
        buttonObj.Text = "🎚️ Sonsuz Zıplama: KAPALI"
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpActive then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState("Jumping") end
    end
end)

-- [3] SHIFTLOCK
local slActive = false
NewButton("⚡ Player", "🔒 Evrensel Shiftlock Aç/Kapat", function()
    slActive = not slActive
    pcall(function() LocalPlayer.DevEnableMouseLock = slActive end)
end)

-- [4] HITBOX EXPANDER
local hitboxEnabled = false
local hitboxSize = 15
NewButton("🎯 Combat", "⭕ Hitbox Genişletici Aç/Kapat", function(buttonObj)
    hitboxEnabled = not hitboxEnabled
    if hitboxEnabled then
        buttonObj.Text = "⭕ Hitbox Genişletici: AKTİF"
        task.spawn(function()
            -- Döngünün çakışmasını engellemek için mevcut durumu kontrol ediyoruz
            while hitboxEnabled do
                task.wait(0.5)
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        pcall(function()
                            local hrp = p.Character.HumanoidRootPart
                            hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                            hrp.Transparency = 0.6
                            hrp.Color = Color3.fromRGB(255, 215, 0)
                            hrp.CanCollide = false
                        end)
                    end
                end
            end
        end)
    else
        buttonObj.Text = "⭕ Hitbox Genişletici: KAPALI"
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                pcall(function()
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end)
            end
        end
    end
end)

NewInput("🎯 Combat", "Boyut (Örn: 20)", "📏 Hitbox Boyutu Ayarla", function(val)
    local num = tonumber(val)
    if num then hitboxSize = num end
end)

-- [5] AUTO CLICKER WIDGET
local clickerActive = false
local clickSpeed = 0.1

local ClickerWidget = Instance.new("TextButton")
ClickerWidget.Name = "ClickerWidget"
ClickerWidget.Size = UDim2.new(0, 50, 0, 50)
ClickerWidget.Position = UDim2.new(0.85, 0, 0.2, 0)
ClickerWidget.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ClickerWidget.Text = "CLICK"
ClickerWidget.TextColor3 = Color3.fromRGB(255, 255, 255)
ClickerWidget.Font = Enum.Font.GothamBold
ClickerWidget.TextSize = 10
ClickerWidget.Visible = false
ClickerWidget.Parent = ScreenGui

local WidgetCorner = Instance.new("UICorner")
WidgetCorner.CornerRadius = UDim.new(1, 0)
WidgetCorner.Parent = ClickerWidget

ClickerWidget.MouseButton1Click:Connect(function()
    clickerActive = not clickerActive
    if clickerActive then
        ClickerWidget.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        task.spawn(function()
            while clickerActive do
                local x = ClickerWidget.AbsolutePosition.X + 25
                local y = ClickerWidget.AbsolutePosition.Y + 25
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
                task.wait(clickSpeed)
            end
        end)
    else
        ClickerWidget.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

NewButton("🎯 Combat", "🔘 Mobil Auto Clicker Widget", function()
    ClickerWidget.Visible = not ClickerWidget.Visible
end)

NewInput("🎯 Combat", "Hız (Örn: 0.05)", "⏱️ Tıklama Saniyesi", function(val)
    local num = tonumber(val)
    if num then clickSpeed = num end
end)

-- [6] X-RAY MAP ENGINE
local xrayActive = false
local originalTransparencies = {}
NewButton("🗺️ World", "🏢 Tüm Haritayı Şeffaf Yap (X-Ray)", function()
    xrayActive = not xrayActive
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:Parent:FindFirstChildOfClass("Humanoid") and not obj:IsA("Terrain") then
            if not originalTransparencies[obj] then
                originalTransparencies[obj] = obj.Transparency
            end
            obj.Transparency = xrayActive and 0.65 or originalTransparencies[obj]
        end
    end
end)

-- [7] SYSTEM BACKDOORS
NewButton("🛠️ System", "💻 Infinite Yield Panel Yükle", function()
    pcall(function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeY/infiniteyield/master/source'))()
    end)
end)

NewButton("🛠️ System", "❌ Menüyü Tamamen Kapat", function()
    ScreenGui:Destroy()
end)

-- ==========================================
--  📱 ARAYÜZ KONTROLLERİ (KÜÇÜLME VE DRAG)
-- ==========================================
local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Position = UDim2.new(0.02, 0, 0.1, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinBtn.Text = "💛"
MinBtn.TextSize = 16
MinBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
MinBtn.Parent = ScreenGui

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinBtn

local MinStroke = Instance.new("UIStroke")
MinStroke.Thickness = 1.5
MinStroke.Color = Color3.fromRGB(255, 215, 0)
MinStroke.Parent = MinBtn

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function DragEngine(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

DragEngine(MainFrame)
DragEngine(MinBtn)
DragEngine(ClickerWidget)
