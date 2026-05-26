-- combat/hitbox.lua
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

task.spawn(function()
    while true do task.wait(0.5)
        if not _G.Config then break end
        if _G.Config.Toggles.Hitbox and _G.CurrentGame == "Rivals" then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(_G.Config.HitboxSize, _G.Config.HitboxSize, _G.Config.HitboxSize)
                    hrp.Transparency = 0.7
                    hrp.Color = Color3.fromRGB(255, 215, 0)
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
            end
        else
            if _G.CurrentGame == "Rivals" then
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
return true