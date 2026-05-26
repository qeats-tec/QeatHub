-- world/esp.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function CreateESP(player)
    if _G.MainGuiInstance and _G.MainGuiInstance:FindFirstChild(player.Name .. "_QeatESP") then return end
    if not _G.MainGuiInstance then return end
    
    local Box = Instance.new("BoxHandleAdornment")
    Box.Name = player.Name .. "_QeatESP"
    Box.AlwaysOnTop = true
    Box.ZIndex = 5
    Box.Color3 = Color3.fromRGB(255, 215, 0)
    Box.Transparency = 0.4
    Box.Size = Vector3.new(4, 5.5, 1)
    Box.Parent = _G.MainGuiInstance
    
    local function updateAdornee(char)
        if char then
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            if hrp then Box.Adornee = hrp end
        end
    end
    updateAdornee(player.Character)
    player.CharacterAdded:Connect(updateAdornee)
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= LocalPlayer then CreateESP(p) end end)

RunService:BindToRenderStep("QeatESPUpdate", Enum.RenderPriority.Last.Value, function()
    if not _G.Config or not _G.MainGuiInstance then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local adorn = _G.MainGuiInstance:FindFirstChild(p.Name .. "_QeatESP")
            if adorn then
                if _G.CurrentGame == "Rivals" then
                    adorn.Visible = _G.Config.Toggles.ESP and (p.Team ~= LocalPlayer.Team)
                else
                    if _G.CurrentGame == "MM2" and _G.Config.Toggles.MM2RoleESP then
                        adorn.Visible = false -- MM2'de rol ESP'si açıksa normal kutuyu gizle çakışmasınlar
                    else
                        adorn.Visible = _G.Config.Toggles.ESP
                    end
                end
            end
        end
    end
end)
return true