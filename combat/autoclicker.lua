-- combat/autoclicker.lua
local VirtualInputManager = game:GetService("VirtualInputManager")

task.spawn(function()
    while true do task.wait(0.01)
        if not _G.Config then break end
        if _G.Config.Toggles.AutoClicker and _G.ClickingActive then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
end)
return true