-- Bypass remotes entirely (client-side override)
local Player = game:GetService("Players").LocalPlayer
if Player:FindFirstChild("leaderstats") then
    local Diamonds = Player.leaderstats:FindFirstChild("Diamonds")
    if Diamonds then
        Diamonds.Value = 1000000000
        print("Direct value override successful!")
    end
end
