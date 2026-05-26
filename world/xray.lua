-- world/xray.lua
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.OriginalTransparencies = _G.OriginalTransparencies or {}

task.spawn(function()
    while true do task.wait(1)
        if not _G.Config then break end
        if _G.Config.Toggles.Xray then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) and not Players:GetPlayerFromCharacter(obj.Parent) then
                    if obj.Name ~= "Terrain" and not _G.OriginalTransparencies[obj] then
                        _G.OriginalTransparencies[obj] = obj.Transparency
                        obj.Transparency = 0.65
                    end
                end
            end
        else
            if next(_G.OriginalTransparencies) ~= nil then
                for obj, trans in pairs(_G.OriginalTransparencies) do
                    if obj and obj.Parent then obj.Transparency = trans end
                end
                table.clear(_G.OriginalTransparencies)
            end
        end
    end
end)
return true