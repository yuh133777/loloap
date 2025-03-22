local Reward = ReplicatedStorage.__DIRECTORY.TimedRewards["TimedReward | DailyDiamonds1"]

for _ = 1, 1000 do  -- Adjust loop count as needed
    pcall(function()
        Reward:FindFirstChild("Claim"):FireServer()
    end)
    task.wait(0.1)  -- Avoid client crashes
end
