local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Validate critical modules
local Item
local InventoryService
local success, err = pcall(function()
    Item = require(ReplicatedStorage.Database.Sync.Item)
    InventoryService = require(ReplicatedStorage.ClientServices.InventoryService)
end)

if not success then
    warn("MODULE LOAD FAILED:", err)
    return
end

-- 2. Verify Weapons table exists
if not Item.Weapons then
    warn("CRITICAL ERROR: Weapons table not found in Item module")
    warn("Item module keys:", table.concat(table.keys(Item), ", "))
    return
end

-- 3. Define AmericaGun with VALIDATED STRUCTURE
local AmericaGun = {
    Name = "America", -- Must match your Item.Weapons format
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    ItemType = "Gun",
    Angles = {
        X = 0.6108652381980153,
        Y = math.pi,
        Z = math.pi/2
    }
}

-- 4. Safe database injection
print("Weapons before:", table.concat(table.keys(Item.Weapons), ", "))
Item.Weapons["America"] = AmericaGun
print("Weapons after:", table.concat(table.keys(Item.Weapons), ", "))

-- 5. Inventory update with error handling
local inventorySuccess, inventoryErr = pcall(function()
    return InventoryService:AddItem(player, "Weapons", "America", {
        Obtained = os.date("%Y-%m-%d"),
        Equipped = false,
        CustomData = {
            SpecialEdition = true
        }
    })
end)

-- 6. Fallback system
if not inventorySuccess then
    print("InventoryService failed. Attempting direct remote...")
    local ChangeProfileData = ReplicatedStorage.Remotes.Inventory.ChangeProfileData
    if ChangeProfileData then
        ChangeProfileData:FireServer(
            player,
            "Weapons",
            {
                ["America"] = { -- Match the injected key
                    ItemID = "America",
                    Obtained = os.time(),
                    Equipped = false
                }
            }
        )
    else
        warn("ChangeProfileData remote not found!")
    end
end

-- 7. Force UI refresh
local InventoryGUI = player.PlayerGui.MainGui.Inventory:FindFirstChild("Inventory")
if InventoryGUI then
    require(InventoryGUI):RefreshInventory("Weapons")
    print("UI refresh triggered!")
else
    warn("InventoryGUI LocalScript not found!")
end
