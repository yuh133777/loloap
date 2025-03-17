local replicatedStorage = game:GetService("ReplicatedStorage")
local unbanEvent = replicatedStorage:FindFirstChild("UnBan")

if unbanEvent then
    unbanEvent:FireServer(102685525) -- Replace with the correct user ID
else
    warn("UnBan RemoteEvent not found!")
end
