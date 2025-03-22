-- Spam DailyDiamonds1 reward
local DailyReward = ReplicatedStorage.__DIRECTORY.TimedRewards["TimedReward | DailyDiamonds1"]

for i = 1, 1000 do  -- Spam claim 1000 times
    pcall(function()
        DailyReward.Claim:FireServer()
    end)
    task.wait(0.05)  -- Short delay to prevent crashes
end
print("Daily rewards claimed 1000 times!")
