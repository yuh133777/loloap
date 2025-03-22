local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. PROVEN MODULE PATHS
local Item = require(ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"):WaitForChild("Item"))
local InventoryService = require(ReplicatedStorage:WaitForChild("ClientServices"):WaitForChild("InventoryService"))

-- 2. WEAPON STRUCTURE (FROM YOUR ITEM.TXT)
local AmericaGun = {
    Name = "America", -- Must match EXACTLY
    Image = "rbxassetid://164676043", 
    Rarity = "Classic",
    ItemType = "Gun",
    Angles = {
        X = 0.6108652381980153,
        Y = math.pi,
        Z = math.pi/2
    }
}

-- 3. SAFE DATABASE INJECTION
print("Weapons before:", table.concat(table.keys(Item.Weapons), ", "))
Item.Weapons["America"] = AmericaGun -- Use table.insert if needed
print("Weapons after:", table.concat(table.keys(Item.Weapons), ", "))

-- 4. INVENTORY UPDATE (YOUR INVENTORYSERVICE.TXT METHOD)
local success, err = pcall(function()
    InventoryService:AddItem(player, "Weapons", "America", {
        Obtained = os.date("%Y-%m-%d"),
        Equipped = false,
        CustomData = {
            SpecialEdition = true
        }
    })
end)

-- 5. FAILSAFE WITH DIRECT REMOTE
if not success then
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Inventory"):WaitForChild("ChangeProfileData"):FireServer(
        player,
        "Weapons",
        {
            ["America"] = { -- Match database key
                ItemID = "America",
                Obtained = os.time(),
                Equipped = false
            }
        }
    )
end

-- 6. UI REFRESH (YOUR INVENTORY.TXT METHOD)
require(player:WaitForChild("PlayerGui"):WaitForChild("MainGui"):WaitForChild("Inventory"):WaitForChild("Inventory")):RefreshInventory("Weapons")
