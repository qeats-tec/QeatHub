local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Speed & Jump Kontrol Döngüsü
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if _G.Config.Toggles.Speed then hum.WalkSpeed = _G.Config.WalkSpeed end
        if _G.Config.Toggles.JumpPowerToggle then 
            hum.UseJumpPower = true
            hum.JumpPower = _G.Config.JumpPower 
        end
    end
end)

-- Kusursuz Noclip Döngüsü
RunService.Stepped:Connect(function()
    if _G.Config.Toggles.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide == true and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)

-- 3D Yukarı/Aşağı Destekli Gelişmiş Uçma Motoru (Fly Fix)
local FlyBV, FlyBG
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and _G.Config.Toggles.Fly then
        if not FlyBV then
            FlyBV = Instance.new("BodyVelocity", hrp)
            FlyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            FlyBG = Instance.new("BodyGyro", hrp)
            FlyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        end
        FlyBG.CFrame = Camera.CFrame
        
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end -- YUKARI
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end -- AŞAĞI
        
        FlyBV.Velocity = moveDir.Unit * _G.Config.FlySpeed
        if moveDir == Vector3.new(0,0,0) then FlyBV.Velocity = Vector3.new(0,0,0) end
    else
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
    end
end)

-- Double Jump Motoru Fix
local HasDoubleJumped = false
UserInputService.JumpRequest:Connect(function()
    if _G.Config.Toggles.DoubleJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            if hum:GetState() == Enum.HumanoidStateType.Freefall and not HasDoubleJumped then
                HasDoubleJumped = true
                hrp.Velocity = Vector3.new(hrp.Velocity.X, _G.Config.JumpPower, hrp.Velocity.Z)
            end
        end
    end
end)
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then HasDoubleJumped = false end
    end
end)
