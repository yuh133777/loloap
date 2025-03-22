-- Slow passive income method (less detectable)
local DailyReward = ReplicatedStorage.__DIRECTORY.TimedRewards["TimedReward | DailyDiamonds1"]

while true do
    pcall(function()
        DailyReward.Claim:FireServer()
        print("Claimed daily reward:", os.date())
    end)
    task.wait(60)  -- Wait 1 minute between claims
end
