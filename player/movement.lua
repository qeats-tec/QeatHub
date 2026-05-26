-- player/movement.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local flyGyro, flyVelocity
local hasDoubleJumped = false

RunService:BindToRenderStep("QeatMovementLoop", Enum.RenderPriority.Character.Value, function()
    if not _G.Config then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    -- Speed Changer
    if _G.Config.Toggles.Speed and hum then
        hum.WalkSpeed = _G.Config.WalkSpeed
    end
    
    -- Jump Changer
    if _G.Config.Toggles.JumpPowerToggle and hum then
        hum.UseJumpPower = true
        hum.JumpPower = _G.Config.JumpPower
    end
    
    -- Fly Engine
    if _G.Config.Toggles.Fly and hrp and hum then
        if not hrp:FindFirstChild("QeatFlyGyro") then
            flyGyro = Instance.new("BodyGyro", hrp)
            flyGyro.Name = "QeatFlyGyro"
            flyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            
            flyVelocity = Instance.new("BodyVelocity", hrp)
            flyVelocity.Name = "QeatFlyVel"
            flyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
        end
        hum.PlatformStand = true
        flyGyro.cframe = Camera.CFrame
        flyVelocity.velocity = hum.MoveDirection * _G.Config.FlySpeed
    else
        if hrp then
            if hrp:FindFirstChild("QeatFlyGyro") then hrp.QeatFlyGyro:Destroy() end
            if hrp:FindFirstChild("QeatFlyVel") then hrp.QeatFlyVel:Destroy() end
        end
        if hum and hum.PlatformStand then hum.PlatformStand = false end
    end
    
    -- Noclip Engine
    if _G.Config.Toggles.Noclip then
        for _, child in ipairs(char:GetDescendants()) do
            if child:IsA("BasePart") then child.CanCollide = false end
        end
    end
    
    -- Double Jump Floor Check
    if hum and hum.FloorMaterial ~= Enum.Material.Air then
        hasDoubleJumped = false
    end
end)

-- Double Jump İstek Dinleyicisi
UserInputService.JumpRequest:Connect(function()
    if _G.Config and _G.Config.Toggles.DoubleJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp and hum:GetState() == Enum.HumanoidStateType.FreeFall and not hasDoubleJumped then
            hasDoubleJumped = true
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, _G.Config.JumpPower, hrp.AssemblyLinearVelocity.Z)
        end
    end
end)
return true