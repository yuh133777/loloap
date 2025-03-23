-- 1. MODIFIED FREE GIFT SCRIPT (Server-Side)
-- Path: ReplicatedStorage.__DIRECTORY.FreeGifts["FreeGift | 1"]
local FreeGift = {
    Settings = {
        Reward = {
            Type = "Diamonds",
            Amount = 100000000, -- 100M diamonds
            Cooldown = 0 -- Instant reset
        },
        Model = workspace.Map["3 | Castle"].INTERACT.Machines.DailyDiamonds1
    }
}
return FreeGift

-- 2. CORE EXPLOIT SCRIPT (Run via Executor)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- Verified path structure
local function GetMachine()
    return Workspace:WaitForChild("Map"):WaitForChild("3 | Castle"):WaitForChild("INTERACT"):WaitForChild("Machines"):WaitForChild("DailyDiamonds1")
end

-- Cooldown bypass
local function RemoveCooldown()
    local FreeGifts = require(ReplicatedStorage.Library.Types.FreeGifts)
    
    -- Patch cooldown check
    local originalCanClaim = FreeGifts.CanClaim
    FreeGifts.CanClaim = function()
        return true
    end
    
    -- Patch last claimed time
    local originalLastClaimed = FreeGifts.GetLastClaimed
    FreeGifts.GetLastClaimed = function()
        return 0
    end
end

-- Auto-farm system
local function AutoFarm()
    local machine = GetMachine()
    local pad = machine:WaitForChild("Pad")
    
    while true do
        -- Force trigger collection
        firetouchinterest(pad, player.Character.HumanoidRootPart, 0)
        firetouchinterest(pad, player.Character.HumanoidRootPart, 1)
        
        -- Force UI refresh
        ReplicatedStorage.__DIRECTORY.FreeGifts["FreeGift | 1"].ClientEvent:FireServer()
        
        print("Claimed 100M diamonds!")
        task.wait(0.5)
    end
end

-- Execution
RemoveCooldown()
task.wait(1)
AutoFarm()
