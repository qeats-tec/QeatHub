-- mm2/innocent.lua
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local GunDropAlertedThisRound = false

RunService:BindToRenderStep("QeatInnocentLoop", Enum.RenderPriority.Last.Value, function()
    if not _G.Config or _G.CurrentGame ~= "MM2" then return end
    
    -- Safe Zone Platform Motoru
    if _G.Config.Toggles.MM2SafeZone then
        if not Workspace:FindFirstChild("QeatSafePlatform") then
            local Part = Instance.new("Part", Workspace)
            Part.Name = "QeatSafePlatform"
            Part.Size = Vector3.new(30, 2, 30)
            Part.Position = Vector3.new(0, 800, 0)
            Part.Anchored = true
            Part.Transparency = 0.4
            Part.Color = Color3.fromRGB(255, 215, 0)
            Part.Material = Enum.Material.Neon
        end
    end

    -- Yere Düşen Silahı Takip Eden Gun Drop Motoru
    if _G.Config.Toggles.MM2GunESP then
        local drop = Workspace:FindFirstChild("GunDrop")
        if drop and drop:IsA("BasePart") then
            if not GunDropAlertedThisRound and _G.ShowWarning then
                GunDropAlertedThisRound = true
                _G.ShowWarning("🚨 TABANCA DÜŞTÜ! KOŞ AL! 🚨")
            end

            local high = drop:FindFirstChild("QeatGunHighlight")
            if not high then
                high = Instance.new("Highlight", drop)
                high.Name = "QeatGunHighlight"
                high.FillColor = Color3.fromRGB(180, 0, 255)
                high.OutlineColor = Color3.fromRGB(255, 255, 255)
                high.FillTransparency = 0.3
            end

            local bill = drop:FindFirstChild("QeatGunBillboard")
            if not bill then
                bill = Instance.new("BillboardGui", drop)
                bill.Name = "QeatGunBillboard"
                bill.Size = UDim2.new(0, 120, 0, 30)
                bill.AlwaysOnTop = true
                bill.ExtentsOffset = Vector3.new(0, 2.5, 0)
                
                local txt = Instance.new("TextLabel", bill)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = "🔫 TABANCA BURADA!"
                txt.TextColor3 = Color3.fromRGB(180, 0, 255)
                txt.Font = Enum.Font.Code
                txt.TextSize = 13
            end
        end
    end
end)

Workspace.ChildAdded:Connect(function(child)
    if child.Name == "Normal" or child:IsA("Model") then
        GunDropAlertedThisRound = false
    end
end)
return true