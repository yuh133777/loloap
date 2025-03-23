local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Bypass all cooldown checks
local function PatchFreeGifts()
    -- Modify FreeGifts library
    local FreeGifts = require(ReplicatedStorage.Library.Types.FreeGifts)
    
    -- Override cooldown check
    local orig = FreeGifts.IsOnCooldown
    FreeGifts.IsOnCooldown = function()
        return false -- Always available
    end
    
    -- Force refresh interaction
    local machine = workspace["3 | Castle"].INTERACT.Machines.DailyDiamonds1
    machine.Pad.Touched:Connect(function(part)
        if part.Parent == player.Character then
            firetouchinterest(part, machine.Pad, 0)
            firetouchinterest(part, machine.Pad, 1)
        end
    end)
end

-- Force load modified values
PatchFreeGifts()

-- Visual feedback
local DiamondValue = player.leaderstats["💎Diamonds"]
while true do
    DiamondValue.Value = math.max(DiamondValue.Value, 100000000)
    task.wait(0.5)
end
