local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Oyuncunun gerçekten lobide mi yoksa oyunda mı olduğunu ayırt eden akıllı kontrol
local function IsValidTarget(p)
    if p == LocalPlayer then return false end
    if not p.Character or not p.Character:FindFirstChild("HumanoidRootPart") then return false end
    
    local hum = p.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    
    -- 🛑 LOBİ KORUMASI: MM2 lobisi genelde koordinat olarak haritanın çok uzağındadır veya üst kısımdadır.
    -- Eğer hedef oyuncu lobide doğmuşsa (Y koordinatı genellikle çok yüksektir veya lobi bölgesindedir), onu es geç.
    local hrp = p.Character.HumanoidRootPart
    if hrp.Position.Y > 500 then 
        return false 
    end
    
    -- 🎭 İZLEYİCİ / ÖLÜ KORUMASI: MM2'de ölen kişiler şeffaf olur veya görünmezlik moduna (Spectator) geçer.
    if p.Character:FindFirstChild("Head") and p.Character.Head.Transparency > 0.5 then
        return false
    end

    return true
end

RunService:BindToRenderStep("QeatCombatMechanics", Enum.RenderPriority.Camera.Value, function()
    if not _G.Config or _G.CurrentGame ~= "MM2" then return end
    
    local killer = _G.DetectedMurdererGlobal
    local sheriff = _G.DetectedSheriffGlobal

    -- 🎯 Katil Predictive Aim Motoru (Şerif İçin Aimbot)
    if _G.Config.Toggles.MM2SheriffAim and killer and killer.Character then
        local target = killer.Character:FindFirstChild("Head") or killer.Character:FindFirstChild("HumanoidRootPart")
        local hum = killer.Character:FindFirstChildOfClass("Humanoid")
        if target and hum and hum.Health > 0 then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 1)
        end
    end

    -- Counter Teleport & Kill (Katil Yaklaşınca Arkasına Işınlanıp Vurma)
    if _G.Config.Toggles.MM2CounterKill and killer and killer.Character and killer.Character:FindFirstChild("Knife") then
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetHRP = killer.Character:FindFirstChild("HumanoidRootPart")
        local hum = killer.Character:FindFirstChildOfClass("Humanoid")
        if myHRP and targetHRP and hum and hum.Health > 0 then
            myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 4)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end

    -- 🔪 AKILLI KATİL KILL AURA (Yalnızca Hayatta Kalanlara Işınlanır!)
    if _G.Config.Toggles.MM2KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- Eğer lobi koruma platformundaysak (SafeZone) kill aura çalışmasın ki kendi kendimizi bozmayalım
        if LocalPlayer.Character.HumanoidRootPart.Position.Y > 750 then return end

        for _, p in ipairs(Players:GetPlayers()) do
            -- Yeni eklediğimiz IsValidTarget fonksiyonuyla ölüleri ve lobidekileri tamamen eliyoruz
            if IsValidTarget(p) then
                -- Şerif koruması (Silahı varsa dikkat et, yoksa acıma)
                if p ~= sheriff or (sheriff and not sheriff.Character:FindFirstChild("Gun")) then
                    local myHRP = LocalPlayer.Character.HumanoidRootPart
                    
                    -- Adama arkasından sinsi bir şekilde ışınlanıyoruz
                    myHRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2)
                    
                    -- Bıçağı salla
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.01)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    break -- Tek döngüde bir kişiyi hedef al ki oyun çökmesin veya çok fazla titreme yapmasın
                end
            end
        end
    end
end)

return true
