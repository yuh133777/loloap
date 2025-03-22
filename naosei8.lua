local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- PROPER EMOJI HANDLING --
local DIAMOND_NAME = "💎 Diamonds" -- Copy-paste the emoji from your game

-- Method 1: Server Validation Bypass
local function Method1()
    local success = pcall(function()
        return ReplicatedStorage.Network.Guilds_DepositDiamonds:InvokeServer(1000)
    end)
    return success
end

-- Method 2: Timed Rewards with Leaderstats Verification
local function Method2()
    local reward = ReplicatedStorage["__DIRECTORY"].TimedRewards["TimedReward | DailyDiamonds1"]
    if not reward then return false end

    local leaderstats = player:WaitForChild("leaderstats", 5)
    if not leaderstats then
        warn("Missing leaderstats folder!")
        return false
    end

    local diamondValue = leaderstats:FindFirstChild(DIAMOND_NAME)
    if not diamondValue then
        warn("Missing "..DIAMOND_NAME.." in leaderstats!")
        return false
    end

    print("Initial Diamonds:", diamondValue.Value)
    for i = 1, 20 do
        reward.Claim:FireServer()
        print("After claim "..i..":", diamondValue.Value)
        task.wait(2)
    end
    return true
end

-- Method 3: Direct Client-Side Override
local function Method3()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local diamondValue = leaderstats:FindFirstChild(DIAMOND_NAME)
        if diamondValue then
            diamondValue.Value = 1000000000
            return true
        end
    end
    return false
end

-- Execution Flow
print("=== ULTIMATE DIAMOND FIX ===")
if Method1() then
    print("Method 1: Server deposit worked!")
elseif Method2() then
    print("Method 2: Timed rewards modified!")
elseif Method3() then
    print("Method 3: Direct client override!")
else
    warn("All methods failed! Server-side validation active.")
end

-- Final verification
local current = player.leaderstats:FindFirstChild(DIAMOND_NAME)
if current then
    print("FINAL DIAMONDS:", current.Value)
else
    warn("Couldn't verify results!")
end
