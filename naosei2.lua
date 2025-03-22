-- Exploit Guilds_DepositDiamonds RemoteFunction
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.Network.Guilds_DepositDiamonds

-- Directly add 1B diamonds
local success, errorMsg = pcall(function()
    Remote:InvokeServer(1000000000) -- 1,000,000,000 diamonds
end)

if success then
    print("Success! 1 BILLION DIAMONDS ADDED!")
else
    warn("Failed:", errorMsg)
    print("Trying backup methods...")
end
