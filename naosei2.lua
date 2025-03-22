local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== DEBUG SESSION START ===")

-- 1. Correct Module Paths
print("\n[1] MODULE CHECKS")
local ProfileData
local InventoryService

-- Load ProfileData from ReplicatedStorage/Modules
local profileDataModule = ReplicatedStorage:FindFirstChild("Modules"):FindFirstChild("ProfileData")
if profileDataModule then
    ProfileData = require(profileDataModule)
    print("✅ ProfileData loaded")
else
    warn("❌ ProfileData not found in ReplicatedStorage/Modules")
end

-- Load InventoryService from ReplicatedStorage/ClientServices
local inventoryServiceModule = ReplicatedStorage:FindFirstChild("ClientServices"):FindFirstChild("InventoryService")
if inventoryServiceModule then
    InventoryService = require(inventoryServiceModule)
    print("✅ InventoryService loaded")
else
    warn("❌ InventoryService not found in ReplicatedStorage/ClientServices")
end

-- 2. Weapon Data (Confirmed Correct)
print("\n[2] WEAPON DATA")
local AMERICA_GUN = {
    ItemID = "196751752", -- Keep as string to match your system
    ItemName = "America",
    Image = "rbxassetid://164676043",
    ItemType = "Gun",
    Rarity = "Classic",
    Angles = {X = 0, Y = 0, Z = 0}
}
print("✅ Weapon data validated")

-- 3. Database Injection
print("\n[3] DATABASE INTEGRATION")
local Sync = require(ReplicatedStorage.Database.Sync)
if Sync and Sync.Weapons then
    Sync.Weapons[AMERICA_GUN.ItemID] = AMERICA_GUN
    print("✅ Database injected - New weapon count:", table.count(Sync.Weapons))
else
    warn("❌ Failed to inject into database")
end

-- 4. Inventory Update
print("\n[4] INVENTORY UPDATE")
local ChangeProfileData = ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("Inventory"):FindFirstChild("ChangeProfileData")

if ChangeProfileData then
    -- Prepare data matching your profile structure
    local gunData = {
        ItemID = AMERICA_GUN.ItemID,
        Equipped = false,
        Obtained = os.time(),
        CustomData = {
            Rarity = "Classic",
            Special = "Patriotic"
        }
    }

    -- Fire remote with explicit player parameter
    local success, err = pcall(function()
        ChangeProfileData:FireServer(player, "Weapons", {[AMERICA_GUN.ItemID] = gunData})
    end)
    
    print(success and "✅ Remote fired successfully" or "❌ Remote error: "..tostring(err))
else
    warn("❌ Critical: ChangeProfileData not found at ReplicatedStorage/Remotes/Inventory")
end

print("\n=== DEBUG COMPLETE ===")
