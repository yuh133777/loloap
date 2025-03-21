local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Wait for the global database to initialize (critical)
while not _G.Database do
    task.wait()
end

-- 2. Register Harvester in the global database
_G.Database.Weapons["Harvester"] = {
    ItemName = "Harvester",
    Image = "http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=250&height=250&assetId=7800847534",
    ItemType = "Gun",
    Rarity = "Ancient",
    ItemID = 7800847534,
    Event = "Halloween",
    Year = "2021",
    Angles = {
        X = 0.6108652381980153,
        Y = math.pi,
        Z = math.pi/2
    }
}

-- 3. Use the game's official sync system
local ChangeProfileData = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("ChangeProfileData")

-- 4. Update profile using observed data structure
local profileData = {
    Weapons = {
        ["7800847534"] = {
            ItemID = 7800847534,
            Equipped = false,
            Obtained = os.time(),
            CustomData = {
                Rarity = "Ancient",
                Angles = {
                    X = 0.6108652381980153,
                    Y = math.pi,
                    Z = math.pi/2
                }
            }
        }
    }
}

-- 5. Fire the validated remote event
ChangeProfileData:FireServer(player, "Weapons", profileData.Weapons)
print("Harvester forcibly added!")
