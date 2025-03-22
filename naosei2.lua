local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Debugging path verification
print("1. Checking ReplicatedStorage...")
if not ReplicatedStorage then warn("Missing ReplicatedStorage!") return end

print("2. Checking Network folder...")
local Network = ReplicatedStorage:FindFirstChild("Network")
if not Network then warn("Missing Network folder!") return end

print("3. Checking RemoteFunction...")
local Remote = Network:FindFirstChild("Guilds_DepositDiamonds")
if not Remote then
    warn("Guilds_DepositDiamonds not found!")
    return
end

print("All path elements verified successfully!")

-- Stealthy execution with smaller chunks
local targetAmount = 1000000000  -- 1 billion
local chunkSize = 10000000  -- 10 million per call
local delayBetweenCalls = 0.25  -- Quarter-second delay

for i = 1, math.ceil(targetAmount/chunkSize) do
    local success, errorMsg = pcall(function()
        Remote:InvokeServer(chunkSize)
        print(("Added %,d diamonds (total: %,d)"):format(chunkSize, i*chunkSize))
    end)
    
    if not success then
        warn(("Failed on chunk %d: %s"):format(i, errorMsg))
        break
    end
    
    task.wait(delayBetweenCalls)
end

print("Operation completed. Check your diamonds!")
