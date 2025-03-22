local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Load required modules
local Sync = require(ReplicatedStorage.Database.Sync)
local Item = require(ReplicatedStorage.Database.Sync.Item)

-- 2. Define AmericaGun using your game's item structure
local AmericaGun = {
    Name = "America", -- Match Item.txt's "Name" field
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    ItemType = "Gun",
    Event = "Independence",
    Year = 2024,
    Angles = {
        X = 0.6108652381980153,
        Y = math.pi,
        Z = math.pi/2
    },
    CustomProperties = {
        IsSpecial = true,
        Damage = 35
    }
}

-- 3. Inject into Weapons table (from Item module)
Item.Weapons["America"] = AmericaGun -- Use "Name" as key
print("Weapons after injection:", table.concat(table.keys(Item.Weapons), ", "))

-- 4. Update inventory through official systems
local ChangeProfileData = ReplicatedStorage.Remotes.Inventory.ChangeProfileData
local gunData = {
    ItemID = "America", -- Match the key used in injection
    Obtained = os.date("%Y-%m-%d"),
    Equipped = false,
    CustomData = AmericaGun.CustomProperties
}

ChangeProfileData:FireServer(player, "Weapons", {America = gunData})

-- 5. Force inventory refresh
local InventoryGUI = require(player.PlayerGui.MainGui.Inventory.Inventory)
InventoryGUI:RefreshInventory("Weapons")
