local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. Guilds_DepositDiamonds Method (Most Direct)
local Network = ReplicatedStorage:FindFirstChild("Network")
if Network then
    local Remote = Network:FindFirstChild("Guilds_DepositDiamonds")
    if Remote and Remote.ClassName == "RemoteFunction" then
        print("SUCCESS: Found deposit remote!")
        for i = 1, 100 do  -- 100 x 10M = 1B
            Remote:InvokeServer(10000000)
            print(("Added 10M diamonds (Total: %,d)"):format(i*10000000))
            task.wait(0.3)
        end
        return
    end
end

-- 2. Fallback to TimedRewards (If first method failed)
local function SafeDirectoryAccess()
    local directory = ReplicatedStorage:FindFirstChild("__DIRECTORY")
    if not directory then
        error("Critical: __DIRECTORY not found in ReplicatedStorage!")
    end
    
    local timedRewards = directory:FindFirstChild("TimedRewards")
    if not timedRewards then
        error("Missing TimedRewards folder!")
    end
    
    local reward = timedRewards:FindFirstChild("TimedReward | DailyDiamonds1")
    if not reward then
        error("DailyDiamonds1 reward not found!")
    end
    
    return reward
end

local success, reward = pcall(SafeDirectoryAccess)
if success then
    print("SUCCESS: Found TimedReward!")
    for i = 1, 500 do
        reward.Claim:FireServer()
        print(("Claimed reward %d/500 times"):format(i))
        task.wait(0.2)
    end
else
    warn("FATAL ERROR:", reward)
end
