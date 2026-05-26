local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer

RunService:BindToRenderStep("QeatCombatMechanics", Enum.RenderPriority.Camera.Value, function()
    if not _G.Config or _G.CurrentGame ~= "MM2" then return end
    
    local killer = _G.DetectedMurdererGlobal
    local sheriff = _G.DetectedSheriffGlobal

    -- 🎯 Katil Predictive Aim Motoru (ŞERİF İÇİN AGRESİF ULTRA FAST AIMBOT)
    if _G.Config.Toggles.MM2SheriffAim and killer and killer.Character then
        -- Iskalamayı önlemek için doğrudan Head (Kafa) bölgesini hedef alıyoruz
        local target = killer.Character:FindFirstChild("Head") or killer.Character:FindFirstChild("HumanoidRootPart")
        local hum = killer.Character:FindFirstChildOfClass("Humanoid")
        
        if target and hum and hum.Health > 0 then
            -- _G.Config.AimSmoothness yerine doğrudan 1 koyarak yumuşatmayı sıfırladık!
            -- Bu sayede kameran saliseler içinde katilin kafasına yapışır ve asla ıskalamaz.
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

    -- Katil Kill Aura (Hızlıca Herkesin Arkasına Dolanıp Turu Bitirme)
    if _G.Config.Toggles.MM2KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife") then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    if p ~= sheriff or (sheriff and not sheriff.Character:FindFirstChild("Gun")) then
                        local myHRP = LocalPlayer.Character.HumanoidRootPart
                        myHRP.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                        task.wait(0.02)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    end
                end
            end
        end
    end
end)

return true
