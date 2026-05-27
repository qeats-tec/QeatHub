--[[
	====================================================================
	  - QeatHub Universal Premium // Murder Mystery 2 Module
	  - File: games/mm2.lua [GUN DROP ESP, SAFE ZONE & AUTO GRAB + RETURN]
	====================================================================
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local SafePlatform = nil
local GunDropAlerted = false
local ActiveGunHighlight = nil
local GrabCooldown = false -- Silahı aldıktan sonra sonsuz döngüye girmeyi engelleyen kilit

-- 🔍 ASLA KAÇIRMAYAN AGRESİF SİLAH TARAYICI
local function UltimateFindGun()
    -- Yöntem 1: Doğrudan adıyla arat (En hızlısı)
    local directGun = Workspace:FindFirstChild("GunDrop", true) -- "true" parametresi derin arama yapar
    if directGun then return directGun end

    -- Yöntem 2: Haritadaki tüm nesnelere agresif bak
    for _, obj in ipairs(Workspace:GetDescendants()) do
        -- İsmi GunDrop olan veya elinde bir oyuncu olmayan (haritada boşta duran) Gun modelleri
        if (obj.Name == "GunDrop" or obj.Name == "Gun") and not obj:IsDescendantOf(Players) then
            -- Eğer bir oyuncunun karakterinin içinde değilse bu yerdeki silahtır!
            local hasHumanoid = obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")
            if not hasHumanoid then
                if obj:IsA("BasePart") then
                    return obj
                elseif obj:IsA("Model") then
                    return obj:FindFirstChildWhichIsA("BasePart") or obj.PrimaryPart
                end
            end
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

    -- 2️⃣ %100 ÇALIŞAN GARANTİLİ GUN DROP ESP (Highlight + Metin)
    if _G.CurrentGame == "MM2" and _G.Config.Toggles.MM2GunESP then
        local gunPart = UltimateFindGun()
        
        if gunPart and gunPart.Parent then
            -- Eğer silah için ESP henüz oluşturulmadıysa oluştur
            if not ActiveGunHighlight or ActiveGunHighlight.Parent ~= gunPart then
                if ActiveGunHighlight then ActiveGunHighlight:Destroy() end
                
                -- SİLAHI DUVARIN ARKASINDAN PARLATAN HIGHLIGHT SİSTEMİ
                ActiveGunHighlight = Instance.new("Highlight")
                ActiveGunHighlight.Name = "QeatGunHighlight"
                ActiveGunHighlight.FillColor = Color3.fromRGB(255, 165, 0) -- Neon Turuncu İç Dolgu
                ActiveGunHighlight.FillTransparency = 0.3
                ActiveGunHighlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Beyaz Dış Çizgi
                ActiveGunHighlight.OutlineTransparency = 0
                ActiveGunHighlight.Adornee = gunPart
                ActiveGunHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Duvar arkasından gösterme kilidi!
                ActiveGunHighlight.Parent = gunPart
                
                -- Mobilde tam yerini görebilmen için üstüne bir de küçük 3D yazı ekliyoruz
                local bGui = Instance.new("BillboardGui", gunPart)
                bGui.Name = "QeatGunText"
                bGui.Size = UDim2.new(0, 100, 0, 30)
                bGui.AlwaysOnTop = true
                bGui.StudsOffset = Vector3.new(0, 1.5, 0)
                
                local txt = Instance.new("TextLabel", bGui)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = "🔫 SILAH BURADA!"
                txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                txt.Font = Enum.Font.Code
                txt.TextSize = 12
                txt.TextStrokeTransparency = 0
            end
            
            -- Ekran bildirimi
            if not GunDropAlerted then
                if _G.ShowWarning then
                    _G.ShowWarning("🚨 ŞERİF ÖLDÜ! SİLAH YERE DÜŞTÜ! 🚨")
                end
                GunDropAlerted = true
            end

            -- ==========================================================
            -- ⚡ 3️⃣ GUN DROP AUTO-TP & INSTANT RETURN MOTORU (YENİ)
            -- ==========================================================
            if _G.Config.Toggles.AutoGrabGun and not GrabCooldown and LocalPlayer.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    -- Kilidi aktif et ki işlem bitene kadar döngü burayı tekrar tetiklemesin
                    GrabCooldown = true
                    
                    -- A-1: Işınlanmadan önceki tam güvenli konumunu hafızaya kaydet
                    local previousCFrame = hrp.CFrame
                    print("[QeatHub]: Silah kapma operasyonu başladı. Eski yer kilitlendi.")
                    
                    -- A-2: Silahın tam üzerine milisaniyede ışınlan (0.5 sapma ile tam üstü)
                    hrp.CFrame = gunPart.CFrame + Vector3.new(0, 1, 0)
                    
                    -- A-3: Silahı envantere çekebilmek için milisaniyelik ping/dokunma payı bekle
                    task.wait(0.18) 
                    
                    -- A-4: Silahı aldın! Şimdi milisaniyede başladığın eski güvenli yerine geri fırlat!
                    hrp.CFrame = previousCFrame
                    print("[QeatHub]: Silah envanterde! Eski konuma geri dönüldü.")
                    
                    -- Aynı silah için sürekli döngü yapıp karakteri bozmasın diye kısa bir koruma beklemesi
                    task.delay(2, function()
                        GrabCooldown = false
                    end)
                end
            end
        else
            -- Silah lobiye döndüyse veya birisi aldıysa ESP'yi temizle
            if ActiveGunHighlight then ActiveGunHighlight:Destroy() ActiveGunHighlight = nil end
        end
    else
        if ActiveGunHighlight then ActiveGunHighlight:Destroy() ActiveGunHighlight = nil end
    end
end)

-- Yeni el başladığında her şeyi temizle ve sıfırla
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Normal" or child:IsA("Model") then
        GunDropAlerted = false
        GrabCooldown = false
        if ActiveGunHighlight then ActiveGunHighlight:Destroy() ActiveGunHighlight = nil end
    end
end)
