-- mm2/roles.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

_G.LastMurderer = nil
_G.AlertedForThisRound = false

RunService:BindToRenderStep("QeatRoleEngine", Enum.RenderPriority.Last.Value - 1, function()
    if not _G.Config or _G.CurrentGame ~= "MM2" then return end
    
    local currentMurderer, currentSheriff = nil, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if p.Character:FindFirstChild("Knife") or p.Character:FindFirstChild("RealKnife") then
                currentMurderer = p
            elseif p.Character:FindFirstChild("Gun") or p.Character:FindFirstChild("Python") then
                currentSheriff = p
            end
            
            for _, child in ipairs(p.Character:GetChildren()) do
                if child:IsA("Tool") then
                    if string.find(string.lower(child.Name), "knife") or string.find(string.lower(child.Name), "slash") or child:FindFirstChild("KnifeScript") then
                        currentMurderer = p
                    elseif string.find(string.lower(child.Name), "gun") or string.find(string.lower(child.Name), "shoot") then
                        currentSheriff = p
                    end
                end
            end
            
            local backpack = p:FindFirstChild("Backpack")
            if backpack then
                for _, item in ipairs(backpack:GetChildren()) do
                    if string.find(string.lower(item.Name), "knife") then currentMurderer = p
                    elseif string.find(string.lower(item.Name), "gun") then currentSheriff = p end
                end
            end
        end
    end
    
    _G.DetectedMurdererGlobal = currentMurderer
    _G.DetectedSheriffGlobal = currentSheriff

    -- Katil Bıçak Çektiğinde Ekran Bildirimi Tetiklemesi
    if currentMurderer and currentMurderer.Character then
        if currentMurderer.Character:FindFirstChildOfClass("Tool") and (not _G.AlertedForThisRound or _G.LastMurderer ~= currentMurderer) then
            _G.LastMurderer = currentMurderer
            _G.AlertedForThisRound = true
            if _G.ShowWarning then
                _G.ShowWarning("⚠️ DIKKAT: " .. string.upper(currentMurderer.Name) .. " BICAK CEKTI! ⚠️")
            end
        end
    end

    -- Dinamik ESP Rol Renklendirme Sistemi
    if _G.Config.Toggles.MM2RoleESP then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = p.Character:FindFirstChild("QeatHighlight")
                if not highlight then
                    highlight = Instance.new("Highlight", p.Character)
                    highlight.Name = "QeatHighlight"
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                end

                if p == currentMurderer then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                elseif p == currentSheriff then
                    if _G.Config.Toggles.MM2HighlightSheriff then
                        highlight.FillColor = Color3.fromRGB(0, 255, 0)
                        highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                    else
                        highlight.FillColor = Color3.fromRGB(0, 0, 255)
                        highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
                    end
                else
                    highlight.FillColor = Color3.fromRGB(255, 215, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
                end
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("QeatHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end)

game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child.Name == "Normal" or child:IsA("Model") then
        _G.AlertedForThisRound = false
        _G.LastMurderer = nil
    end
end)
return true