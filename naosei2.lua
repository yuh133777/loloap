-- Exploit the Guilds_DepositDiamonds RemoteFunction
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.Network.Guilds_DepositDiamonds

-- Call the RemoteFunction with 1,000,000,000 gems
local success, errorMsg = pcall(function()
    Remote:InvokeServer(1000000000)
end)

if success then
    print("Successfully added 1B gems!")
else
    warn("Error:", errorMsg)
end
