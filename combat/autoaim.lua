-- combat/autoaim.lua
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function IsVisible(targetPart)
    local character = LocalPlayer.Character
    if not character then return false end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character, Camera, targetPart.Parent}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true
    
    local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
    return raycastResult == nil
end

local function GetClosestVisiblePlayerHead()
    local closest, maxDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local head = p.Character.Head
            if IsVisible(head) then
                local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < maxDist then closest = p.Character; maxDist = dist end
                end
            end
        end
    end
    return closest
end

RunService:BindToRenderStep("QeatAutoAim", Enum.RenderPriority.Camera.Value + 1, function()
    if _G.Config and _G.Config.Toggles.AutoAim and _G.CurrentGame == "Rivals" then
        local targetChar = GetClosestVisiblePlayerHead()
        if targetChar and targetChar:FindFirstChild("Head") and targetChar:FindFirstChild("HumanoidRootPart") then
            local targetHead = targetChar.Head
            local targetHRP = targetChar.HumanoidRootPart
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if myHRP then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, _G.Config.AimSmoothness)
                
                local targetPosition = targetHRP.Position
                myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(targetPosition.X, myHRP.Position.Y, targetPosition.Z))
            end
        end
    end
end)
return true