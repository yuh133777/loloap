local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("=== PATH VERIFICATION ===")
print("1. ReplicatedStorage exists?", ReplicatedStorage ~= nil)
print("2. Network folder exists?", ReplicatedStorage:FindFirstChild("Network") ~= nil)

local Network = ReplicatedStorage:FindFirstChild("Network")
if Network then
    print("3. Guilds_DepositDiamonds exists?", Network:FindFirstChild("Guilds_DepositDiamonds") ~= nil)
    print("4. Type of object:", Network.Guilds_DepositDiamonds.ClassName)
end

print("=== ALTERNATIVE PATHS ===")
print("5. TimedReward exists?", ReplicatedStorage:FindFirstChild("__DIRECTORY") 
    and ReplicatedStorage.__DIRECTORY:FindFirstChild("TimedRewards") 
    and ReplicatedStorage.__DIRECTORY.TimedRewards:FindFirstChild("TimedReward | DailyDiamonds1") ~= nil)

print("6. Rebirth exists?", ReplicatedStorage:FindFirstChild("__DIRECTORY") 
    and ReplicatedStorage.__DIRECTORY:FindFirstChild("Rebirths") 
    and ReplicatedStorage.__DIRECTORY.Rebirths:FindFirstChild("Rebirth | 1") ~= nil)
