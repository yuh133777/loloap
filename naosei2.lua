local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Wait for database initialization
print("Waiting for database...")
while not _G.Database do
    task.wait(1)
end
print("Database loaded!")

-- 2. Inject Harvester into global database
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
print("Database injection successful:", _G.Database.Weapons["Harvester"] ~= nil)

-- 3. Get profile data
local GetProfileData = ReplicatedStorage.Remotes.Inventory.GetProfileData
local ChangeProfileData = ReplicatedStorage.Remotes.Inventory.ChangeProfileData
local ProfileDataChanged = ReplicatedStorage.Remotes.Inventory.ProfileDataChanged

print("Fetching profile...")
local profile = GetProfileData:InvokeServer()
print("Profile received:", profile)

-- 4. Prepare inventory update
local HARVESTER_ENTRY = {
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

-- 5. Update profile
profile.Weapons = profile.Weapons or {}
profile.Weapons["7800847534"] = HARVESTER_ENTRY

print("Sending profile update...")
ChangeProfileData:FireServer(player, "Weapons", profile.Weapons)

-- 6. Force UI refresh
ProfileDataChanged:Fire("Weapons", profile.Weapons)
print("UI refresh triggered!")

-- 7. Verify through official systems
task.wait(2) -- Wait for replication
print("Final verification through InventoryService:")
local InventoryService = require(ReplicatedStorage.ClientServices.InventoryService)
print("Has Harvester?", InventoryService:GetInventory(player, "Weapons")["7800847534"] ~= nil)
