local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local SafePlatform = nil
local GunDropHighlight = nil
local GunDropAlerted = false

RunService.Heartbeat:Connect(function()
    -- Anti-Reset Safe Zone
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

    -- Gun Drop ESP Fix
    if _G.CurrentGame == "MM2" and _G.Config.Toggles.MM2GunESP then
        local gunDrop = Workspace:FindFirstChild("GunDrop")
        if gunDrop and gunDrop:IsA("BasePart") then
            if not GunDropHighlight or not GunDropHighlight.Parent then
                GunDropHighlight = Instance.new("Highlight")
                GunDropHighlight.Name = "QeatGunDropESP"
                GunDropHighlight.FillColor = Color3.fromRGB(255, 165, 0)
                GunDropHighlight.FillTransparency = 0.2
                GunDropHighlight.Parent = gunDrop
            end
            if not GunDropAlerted then
                _G.ShowWarning("SİLAH YERE DÜŞTÜ! ALMAYA GİDİN!")
                GunDropAlerted = true
            end
        end
    else
        if GunDropHighlight then GunDropHighlight:Destroy() GunDropHighlight = nil end
    end
end)

-- Harita yenilendiğinde alarmı sıfırla
Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Normal" or child:IsA("Model") then
        GunDropAlerted = false
    end
end)
