local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. DIRECTLY LOAD ITEM MODULE (Bypass Sync decompiler issues)
local Item = require(ReplicatedStorage.Database.Sync.Item)
local InventoryService = require(ReplicatedStorage.ClientServices.InventoryService)

-- 2. Define AmericaGun with EXACT fields from your Item.txt
local AmericaGun = {
    Name = "America", -- Critical: Matches Name field in Item.Weapons
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    ItemType = "Gun",
    Angles = {
        X = 0.6108652381980153,
        Y = math.pi,
        Z = math.pi/2
    },
    CustomData = {
        IsLimited = true,
        ReleaseYear = 2024
    }
}

-- 3. Inject into weapons database (PROVEN STRUCTURE)
print("Existing weapons before:", table.concat(table.keys(Item.Weapons), ", "))
Item.Weapons.America = AmericaGun -- Use dot notation for safety
print("New weapons after:", table.concat(table.keys(Item.Weapons), ", "))

-- 4. Update inventory using OFFICIAL METHOD
local success, err = pcall(function()
    return InventoryService:AddItem(player, "Weapons", "America", {
        Obtained = os.date("%Y-%m-%d"),
        Equipped = false,
        CustomData = AmericaGun.CustomData
    })
end)

-- 5. Fallback with debug
if not success then
    warn("InventoryService failed:", err)
    print("Attempting direct remote...")
    local args = {
        player,
        "Weapons",
        {
            America = { -- Match database key
                ItemID = "America",
                Obtained = os.time(),
                Equipped = false
            }
        }
    }
    ReplicatedStorage.Remotes.Inventory.ChangeProfileData:FireServer(unpack(args))
end

-- 6. Force UI refresh (YOUR CONFIRMED PATH)
require(player.PlayerGui.MainGui.Inventory.Inventory):RefreshInventory("Weapons")
print("America Gun should now be visible!")
