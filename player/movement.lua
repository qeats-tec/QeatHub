--[[
	====================================================================
	  - QeatHub Universal Premium // Movement Module
	  - File: player/movement.lua [FIXED NOCLIP & T-POSE FLY ANIMATION]
	====================================================================
]]

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

-- 🔒 KUSURSUZ VE GÜNCEL NOCLIP MOTORU (Tamamen Yenilendi)
RunService.Stepped:Connect(function()
    if _G.Config.Toggles.Noclip and LocalPlayer.Character then
        local char = LocalPlayer.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        
        -- Karakterin tüm parçalarının çarpışmasını kapatıyoruz
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Karakterin durumunu NoClip moduna zorluyoruz (Yürüme kabiliyetini kaybetmez)
        if hum then
            if hum:GetState() ~= Enum.HumanoidStateType.NoClip then
                hum:ChangeState(Enum.HumanoidStateType.NoClip)
            end
        end
        
        -- Karakter kalın duvarların içinde takılmasın veya geriye fırlatılmasın diye 
        -- eğer Fly aktif değilse ve yürüyorsa, hareket yönüne doğru CFrame itmesi uyguluyoruz.
        if hrp and hum and not _G.Config.Toggles.Fly and hum.MoveDirection.Magnitude > 0 then
            local speedFactor = hum.WalkSpeed * 0.016
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * speedFactor)
        end
    else
        -- Noclip kapatıldığında karakteri normal fizik durumuna döndür (Fly açık değilse)
        if LocalPlayer.Character and not _G.Config.Toggles.Fly then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum:GetState() == Enum.HumanoidStateType.NoClip then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end)

-- 📱 GLOBAL 360° KAMERA YÖNLÜ FLY MOTORU (A-Pose Animasyon Sabitleyicili)
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
        
        -- 🎭 ANIMASYON FIX: Karakterin tüm animasyonlarını dondurur ve A Pozisyonunda (Sabit) tutar
        hum.PlatformStand = true
        for _, track in pairs(hum:GetPlayingAnimationTracks()) do
            track:Stop() -- Çalışan yürüme/koşma animasyonlarını iptal et
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
        
        -- 📱 MOBİL (JOYSTICK) KONTROLLERİ
        if finalVelocity.Magnitude == 0 and hum.MoveDirection.Magnitude > 0 then
            local joystickDir = hum.MoveDirection
            local forwardAmount = Camera.CFrame.LookVector:Dot(joystickDir)
            local rightAmount = Camera.CFrame.RightVector:Dot(joystickDir)
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
        -- Fly kapatıldığında temizlik yap ve karakteri normal moduna döndür
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
        
        -- Eğer noclip de kapalıysa karakteri normal yürütme moduna al
        if hum and hum.PlatformStand and not _G.Config.Toggles.Noclip then
            hum.PlatformStand = false
        end
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
