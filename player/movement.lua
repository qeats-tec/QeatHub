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

-- 📱 GLOBAL 360° KAMERA YÖNLÜ FLY MOTORU (Mobil + PC %100 Uyumlu)
local FlyBV, FlyBG
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if hrp and hum and _G.Config.Toggles.Fly then
        if not FlyBV then
            FlyBV = Instance.new("BodyVelocity", hrp)
            FlyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            FlyBG = Instance.new("BodyGyro", hrp)
            FlyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        end
        -- Karakter uçarken kameranın baktığı yöne doğru 360 derece dönebilsin
        FlyBG.CFrame = Camera.CFrame
        
        -- Karakterin hareket doğrultusunu sıfırlayarak baştan hesaplıyoruz
        local finalVelocity = Vector3.new(0, 0, 0)
        
        -- ⌨️ BİLGİSAYAR (WASD) KONTROLLERİ
        if not UserInputService:GetFocusedTextBox() then
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then finalVelocity = finalVelocity + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then finalVelocity = finalVelocity - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then finalVelocity = finalVelocity + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then finalVelocity = finalVelocity - Camera.CFrame.RightVector end
        end
        
        -- 📱 MOBİL (JOYSTICK) KONTROLLERİ (PC tuşlarına basılmıyorsa devreye girer)
        if finalVelocity.Magnitude == 0 and hum.MoveDirection.Magnitude > 0 then
            -- Oyunun kendi joystick yönünü alıyoruz
            local joystickDir = hum.MoveDirection
            
            -- Joystick'in İLERİ/GERİ ve SAĞ/SOL basılma oranını kameraya göre hesaplıyoruz
            local forwardAmount = Camera.CFrame.LookVector:Dot(joystickDir)
            local rightAmount = Camera.CFrame.RightVector:Dot(joystickDir)
            
            -- Tamamen kameranın LookVector (bakış açısı) üzerinden dikey eksen dahil hızı veriyoruz!
            finalVelocity = (Camera.CFrame.LookVector * forwardAmount) + (Camera.CFrame.RightVector * rightAmount)
        end
        
        -- Hızı uygula
        if finalVelocity.Magnitude > 0 then
            FlyBV.Velocity = finalVelocity.Unit * _G.Config.FlySpeed
        else
            -- Dokunulmadığında havada çakılı kalsın
            FlyBV.Velocity = Vector3.new(0, 0, 0)
        end
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
