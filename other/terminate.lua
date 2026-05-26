-- other/terminate.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

if _G.Config then
    for k, _ in pairs(_G.Config.Toggles) do _G.Config.Toggles[k] = false end
end

_G.ClickingActive = false

-- Tüm renderstep kilitlerini serbest bırak
pcall(function() RunService:UnbindFromRenderStep("QeatAutoAim") end)
pcall(function() RunService:UnbindFromRenderStep("QeatMovementLoop") end)
pcall(function() RunService:UnbindFromRenderStep("QeatESPUpdate") end)
pcall(function() RunService:UnbindFromRenderStep("QeatInnocentLoop") end)
pcall(function() RunService:UnbindFromRenderStep("QeatRoleEngine") end)
pcall(function() RunService:UnbindFromRenderStep("QeatCombatMechanics") end)

-- Safe zone temizliği
local plat = Workspace:FindFirstChild("QeatSafePlatform")
if plat then plat:Destroy() end

-- Tüm ESP ve Vurguları yok et
for _, p in ipairs(Players:GetPlayers()) do
    if p.Character then
        local hl = p.Character:FindFirstChild("QeatHighlight")
        if hl then hl:Destroy() end
    end
    if _G.MainGuiInstance then
        local oldESP = _G.MainGuiInstance:FindFirstChild(p.Name .. "_QeatESP")
        if oldESP then oldESP:Destroy() end
    end
end

-- Silah efektlerini kaldır
local drop = Workspace:FindFirstChild("GunDrop")
if drop then
    if drop:FindFirstChild("QeatGunHighlight") then drop.QeatGunHighlight:Destroy() end
    if drop:FindFirstChild("QeatGunBillboard") then drop.QeatGunBillboard:Destroy() end
end

-- Arayüzü sil
if _G.MainGuiInstance then _G.MainGuiInstance:Destroy() end

-- Global belleği temizle
_G.Config = nil
_G.MainGuiInstance = nil
_G.OriginalTransparencies = nil
return true