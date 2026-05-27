--[[
	====================================================================
	  - QeatHub Premium // Modern Key Auth Interface
	  - File: key.lua (Render Integrated)
	====================================================================
]]

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- 🌍 RENDER SUNUCU ADRESİN (Aktif Edildi)
local serverUrl = "https://qh-key.onrender.com/api/verify"
local discordLink = "https://discord.gg/cQwh3Fhq"

-- ==========================================================
-- 🎬 ARAYÜZ KURULUMU (SİBER / HACKER TEMALI)
-- ==========================================================
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("QeatHUB_AuthSystem") then
    LocalPlayer.PlayerGui.QeatHUB_AuthSystem:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QeatHUB_AuthSystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer.PlayerGui

-- Ana Panel Frame
local MainAuthFrame = Instance.new("Frame", ScreenGui)
MainAuthFrame.Size = UDim2.new(0, 360, 0, 240)
MainAuthFrame.Position = UDim2.new(0.5, -180, 0.5, -120)
MainAuthFrame.BackgroundColor3 = Color3.fromRGB(6, 6, 8) -- Cyber Dark Arka Plan
MainAuthFrame.BorderSizePixel = 0

local FrameCorner = Instance.new("UICorner", MainAuthFrame)
FrameCorner.CornerRadius = UDim.new(0, 10)

local FrameStroke = Instance.new("UIStroke", MainAuthFrame)
FrameStroke.Color = Color3.fromRGB(255, 204, 0) -- Neon Sarı Accent
FrameStroke.Thickness = 1.5

-- Sürükleme Motoru (UIS)
local dragging, dragInput, dragStart, startPos
MainAuthFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainAuthFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainAuthFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainAuthFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Başlık Yazısı
local TitleLabel = Instance.new("TextLabel", MainAuthFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ QEATHUB PREMIUM // AUTH"
TitleLabel.TextColor3 = Color3.fromRGB(255, 204, 0)
TitleLabel.Font = Enum.Font.Code
TitleLabel.TextSize = 16

-- Discord Bilgilendirme Alanı
local DiscordLabel = Instance.new("TextLabel", MainAuthFrame)
DiscordLabel.Size = UDim2.new(0.9, 0, 0, 35)
DiscordLabel.Position = UDim2.new(0.05, 0, 0.22, 0)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.Text = "Anahtar almak için Discord sunucumuza katılın:\n" .. discordLink
DiscordLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
DiscordLabel.Font = Enum.Font.Code
DiscordLabel.TextSize = 11
DiscordLabel.TextWrapped = true

-- Discord Link Kopyalama Butonu
local CopyBtn = Instance.new("TextButton", MainAuthFrame)
CopyBtn.Size = UDim2.new(0.5, 0, 0, 24)
CopyBtn.Position = UDim2.new(0.25, 0, 0.38, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
CopyBtn.Text = "Linki Kopyala"
CopyBtn.TextColor3 = Color3.fromRGB(255, 204, 0)
CopyBtn.Font = Enum.Font.Code
CopyBtn.TextSize = 11
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", CopyBtn).Color = Color3.fromRGB(40, 40, 50)

CopyBtn.MouseButton1Click:Connect(function()
    setclipboard(discordLink)
    CopyBtn.Text = "Kopyalandı!"
    task.delay(2, function() CopyBtn.Text = "Linki Kopyala" end)
end)

-- Key Giriş Kutusu (TextBox)
local KeyInputBox = Instance.new("TextBox", MainAuthFrame)
KeyInputBox.Size = UDim2.new(0.8, 0, 0, 36)
KeyInputBox.Position = UDim2.new(0.1, 0, 0.55, 0)
KeyInputBox.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
KeyInputBox.Text = ""
KeyInputBox.PlaceholderText = "Anahtarınızı Buraya Yapıştırın..."
KeyInputBox.PlaceholderColor3 = Color3.fromRGB(70, 70, 80)
KeyInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInputBox.Font = Enum.Font.Code
KeyInputBox.TextSize = 12
Instance.new("UICorner", KeyInputBox).CornerRadius = UDim.new(0, 6)
local BoxStroke = Instance.new("UIStroke", KeyInputBox)
BoxStroke.Color = Color3.fromRGB(40, 40, 50)

-- Durum Bildirim Yazısı (Hataları veya Başarıyı Gösterecek)
local StatusLabel = Instance.new("TextLabel", MainAuthFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0.72, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 204, 0)
StatusLabel.Font = Enum.Font.Code
StatusLabel.TextSize = 11

-- Onayla Butonu (Submit Button)
local SubmitBtn = Instance.new("TextButton", MainAuthFrame)
SubmitBtn.Size = UDim2.new(0.4, 0, 0, 32)
SubmitBtn.Position = UDim2.new(0.3, 0, 0.82, 0)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
SubmitBtn.Text = "[ ONAYLA ]"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 204, 0)
SubmitBtn.Font = Enum.Font.Code
SubmitBtn.TextSize = 13
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)
local BtnStroke = Instance.new("UIStroke", SubmitBtn)
BtnStroke.Color = Color3.fromRGB(255, 204, 0)

-- ==========================================================
-- 🔒 BACKEND API SORGULAMA MOTORU
-- ==========================================================
local function checkKeyWithRender(enteredKey)
    local data = { key = enteredKey }
    local jsonData = HttpService:JSONEncode(data)

    local success, result = pcall(function()
        return HttpService:PostAsync(serverUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        local responseData = HttpService:JSONDecode(result)
        if responseData.success == true then
            return true, "Erişim Onaylandı! QeatHub yükleniyor..."
        else
            return false, responseData.message or "Geçersiz anahtar!"
        end
    else
        return false, "Sunucu hatası veya geçersiz port bağlantısı!"
    end
end

-- Buton Tetikleme İşlemi
SubmitBtn.MouseButton1Click:Connect(function()
    local enteredKey = KeyInputBox.Text
    if enteredKey == "" then
        StatusLabel.Text = "⚠️ Lütfen boş bırakmayın!"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
        return
    end

    StatusLabel.Text = "⚡ Doğrulanıyor..."
    StatusLabel.TextColor3 = Color3.fromRGB(255, 204, 0)

    task.wait(0.5) -- Gerçekçi bir sorgu hissi için ufak bir bekleme

    local isValid, msg = checkKeyWithRender(enteredKey)

    if isValid then
        -- BAŞARILI DURUMU
        StatusLabel.Text = "✅ " .. msg
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 120)
        FrameStroke.Color = Color3.fromRGB(0, 255, 120)
        BtnStroke.Color = Color3.fromRGB(0, 255, 120)
        
        task.wait(1.5)
        ScreenGui:Destroy() -- Giriş ekranını kapat

        -- ==========================================================
        -- 🚀 MAİN SCRIPT TETİKLEME (QeatHub v4.1 Girişi)
        -- ==========================================================
        -- Buraya testlerin tamamen bittiğinde senin main.lua kodlarını
        -- veya GitHub raw üzerinden yükleme motorunu bağlayacağız.
        print("[QeatHub Auth]: Başarılı! Sistem arayüze geçiş yapıyor.")
        
    else
        -- BAŞARISIZ DURUMU
        StatusLabel.Text = "❌ " .. msg
        StatusLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
        FrameStroke.Color = Color3.fromRGB(255, 60, 60)
    end
end)
