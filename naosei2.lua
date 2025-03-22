local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Use official inventory service
local InventoryService = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InventoryService"))
local ProfileData = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ProfileData"))

-- 2. Weapon data matching game structure
local AMERICA_GUN = {
    ItemID = "196751752", -- Must be string based on your inventory system
    ItemName = "America",
    Image = "http://www.roblox.com/asset/?id=164676043",
    ItemType = "Gun",
    Rarity = "Classic",
    Angles = {
        X = 0,
        Y = 0,
        Z = 0
    },
    CustomProperties = {
        IsPatriotic = true,
        FireRate = 650
    }
}

-- 3. Direct inventory manipulation
local function GrantAmericaGun()
    -- Get actual profile system reference
    local profile = ProfileData.GetProfile(player)
    
    -- Use official addItem method
    local success = InventoryService:AddItem(player, "Weapons", AMERICA_GUN.ItemID, {
        Obtained = os.date("%Y-%m-%d"),
        Equipped = false,
        CustomData = AMERICA_GUN.CustomProperties
    })

    -- Force UI refresh
    if success then
        local InventoryGUI = require(ReplicatedStorage.MainGui.Inventory.Inventory)
        InventoryGUI:RefreshInventory("Weapons")
        print("America Gun successfully added!")
    else
        warn("Failed to add weapon through official systems")
    end
end

-- 4. Execute with error handling
local success, err = pcall(GrantAmericaGun)
if not success then
    warn("Critical failure:", err)
    -- Emergency fallback to direct remote
    ReplicatedStorage.Remotes.Inventory.ChangeProfileData:FireServer(player, "Weapons", {
        [AMERICA_GUN.ItemID] = {
            ItemID = AMERICA_GUN.ItemID,
            Equipped = false,
            Obtained = os.time()
        }
    })
end
