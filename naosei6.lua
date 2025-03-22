local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Fix 1: Remove problematic formatting
local function formatNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

-- Method 1: Guilds Deposit
local Network = ReplicatedStorage:WaitForChild("Network", 5)
if Network then
    local Remote = Network:FindFirstChild("Guilds_DepositDiamonds")
    if Remote and Remote.ClassName == "RemoteFunction" then
        print("SUCCESS: Found deposit remote!")
        for i = 1, 100 do
            Remote:InvokeServer(10000000) -- 10M per call
            print("Added 10M diamonds (Total: "..formatNumber(i*10000000)..")")
            task.wait(0.5)
        end
        return
    end
end

-- Method 2: Timed Rewards Fallback
local directory = ReplicatedStorage:WaitForChild("__DIRECTORY", 5)
if directory then
    local timedRewards = directory:WaitForChild("TimedRewards", 3)
    if timedRewards then
        local reward = timedRewards:FindFirstChild("TimedReward | DailyDiamonds1")
        if reward then
            print("SUCCESS: Found TimedReward!")
            for i = 1, 300 do
                reward.Claim:FireServer()
                print("Claimed reward "..i.."/300 times")
                task.wait(0.3)
            end
            return
        end
    end
end

-- Final fallback
warn("All methods failed! Trying direct approach...")
local Player = game:GetService("Players").LocalPlayer
local leaderstats = Player:WaitForChild("leaderstats", 5)
if leaderstats then
    local Diamonds = leaderstats:FindFirstChild("Diamonds")
    if Diamonds then
        Diamonds.Value = 1000000000
        print("DIRECT OVERRIDE SUCCESS!")
    end
end
