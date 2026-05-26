local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local SafePlatform = nil
local CurrentGunDrop = nil
local GunESPBox = nil
local GunDropAlerted = false

-- Yere Düşen Silahı Haritanın En Derinliklerinde Bile Olsa Bulan Tarayıcı Fonksiyon
local function FindGunDrop()
    -- Önce dış katmanda ara
    local gun = Workspace:FindFirstChild("GunDrop")
    if gun then return gun end
    
    -- Eğer bulamazsa haritanın içindeki tüm nesnelere bak (Kesin Çözüm)
    for _, desc in ipairs(Workspace:GetDescendants()) do
        if desc.Name == "GunDrop" and desc:IsA("BasePart") then
            return desc
        end
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    -- 1️⃣ ANTI-RESET SAFE ZONE MOTORU
    if _G.Config.Toggles.MM2SafeZone and _G.CurrentGame == "MM2" then
        if not SafePlatform or not SafePlatform.Parent then
            SafePlatform = Instance.new("Part")
            SafePlatform.Name = "QeatSafePlatform"
            SafePlatform.Size = Vector3.new(100, 2, 100)
            SafePlatform.Position = Vector3.new(0, 800, 0)
            SafePlatform.Anchored = true
            SafePlatform.BrickColor = BrickColor.new("Gold")
            SafePlatform.Material = Enum.Material.Neon
            SafePlatform.Parent = Workspace
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if hrp.Position.Y < 750 then hrp.CFrame = CFrame.new(0, 805, 0) end
        end
    else
        if SafePlatform then SafePlatform:Destroy() SafePlatform = nil end
    end

    -- 2️⃣ KUSURSUZ GUN DROP ESP MOTORU (Asla Kaçırmaz)
    if _G.CurrentGame == "MM2" and _G.Config.Toggles.MM2GunESP then
        local gunDrop = FindGunDrop()
        
        if gunDrop then
            -- Silah bulunduysa ve henüz ESP kutusu çizilmediyse çiz
            if not GunESPBox or GunESPBox.Parent ~= gunDrop then
                if GunESPBox then GunESPBox:Destroy() end
                
                -- Duvarların arkasından bile gözüken Premium 3D Box ESP Sistemi
                GunESPBox = Instance.new("BoxHandleAdornment")
                GunESPBox.Name = "QeatGunBox"
                GunESPBox.Size = gunDrop.Size + Vector3.new(0.5, 0.5, 0.5) -- Silahı tamamen kaplasın
                GunESPBox.Color3 = Color3.fromRGB(255, 140, 0) -- Parlak Turuncu Renk
                GunESPBox.AlwaysOnTop = true -- Duvar arkasından görmeyi sağlar (X-Ray Etkisi)
                GunESPBox.ZIndex = 10
                GunESPBox.Adornee = gunDrop
                GunESPBox.Parent = gunDrop
            end
            
            -- Ekranın üstünde büyük kırmızı uyarı yazısı çıkartır ve ses çalar
            if not GunDropAlerted then
                if _G.ShowWarning then
                    _G.ShowWarning("🚨 SİLAH YERE DÜŞTÜ! HEMEN ALMAYA GİDİN! 🚨")
                end
                GunDropAlerted = true
            end
        else
            -- Ortada silah yoksa veya birisi aldıysa ESP'yi temizle
            if GunESPBox then GunESPBox:Destroy() GunESPBox = nil end
        end
    else
        if GunESPBox then GunESPBox:Destroy() GunESPBox = nil end
    end
end)

-- Yeni el başladığında veya harita değiştiğinde uyarı kilidini sıfırla
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Normal" or child:IsA("Model") then
        GunDropAlerted = false
        if GunESPBox then GunESPBox:Destroy() GunESPBox = nil end
    end
end)
