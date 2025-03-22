local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Load critical modules
local Sync = require(ReplicatedStorage.Database.Sync)
local Item = Sync.Item -- Weapons are stored here
local InventoryService = require(ReplicatedStorage.ClientServices.InventoryService)

-- Define America Gun according to your game's item structure
local AMERICA_GUN = {
    Name = "America", -- Must match Name field from Item.Weapons
    ItemName = "America", -- Some systems use different naming
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    ItemType = "Gun",
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

-- Inject into weapons database
Item.Weapons["America"] = AMERICA_GUN -- Match key format from Item.Weapons

-- Add to inventory using official service
local success = InventoryService:AddItem(player, "Weapons", "America", {
    Obtained = os.date("%Y-%m-%d"),
    Equipped = false,
    CustomData = {
        Rarity = "Classic",
        Special = "Patriotic"
    }
})

-- Fallback to direct remote if needed
if not success then
    ReplicatedStorage.Remotes.Inventory.ChangeProfileData:FireServer(
        player,
        "Weapons",
        {
            ["America"] = { -- Match the key used in Item.Weapons
                ItemID = "America",
                Obtained = os.time(),
                Equipped = false
            }
        }
    )
end

-- Force inventory refresh
require(player.PlayerGui.MainGui.Inventory.Inventory):RefreshInventory("Weapons")
