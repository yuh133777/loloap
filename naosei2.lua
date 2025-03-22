local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== DEBUG SESSION START ===")

-- 1. Database Initialization with Error Handling
print("\n[1] DATABASE INITIALIZATION")
local Sync
local databaseSuccess, databaseErr = pcall(function()
    Sync = require(ReplicatedStorage:WaitForChild("Database"):WaitForChild("Sync"))
end)

if databaseSuccess then
    print("✅ Database module loaded successfully")
else
    warn("❌ Failed to load database:", databaseErr)
    return -- Stop execution if database fails
end

-- 2. Validate Weapons Table
print("\n[2] DATABASE STRUCTURE VALIDATION")
if not Sync.Weapons then
    warn("❌ Critical: 'Weapons' table not found in Sync module")
    print("Existing Sync keys:", table.concat(table.keys(Sync), ", "))
    return
else
    print("✅ Weapons table verified")
    print("Initial weapon count:", table.count(Sync.Weapons))
end

-- 3. Weapon Injection
print("\n[3] WEAPON INJECTION")
local AMERICA_GUN = {
    ItemID = "196751752",
    ItemName = "America",
    Image = "rbxassetid://164676043",
    ItemType = "Gun",
    Rarity = "Classic",
    Angles = {X = 0, Y = 0, Z = 0}
}

local injectionSuccess, injectionErr = pcall(function()
    Sync.Weapons[AMERICA_GUN.ItemID] = AMERICA_GUN
end)

if injectionSuccess then
    print("✅ Weapon injected successfully")
    print("New weapon count:", table.count(Sync.Weapons))
else
    warn("❌ Injection failed:", injectionErr)
end

-- 4. Inventory Update Fallback
print("\n[4] INVENTORY UPDATE")
local ChangeProfileData = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Inventory")
    and ReplicatedStorage.Remotes.Inventory:FindFirstChild("ChangeProfileData")

if ChangeProfileData then
    local gunData = {
        ItemID = AMERICA_GUN.ItemID,
        Equipped = false,
        Obtained = os.time(),
        CustomData = {
            Rarity = "Classic",
            Special = "Patriotic"
        }
    }

    local remoteSuccess, remoteErr = pcall(function()
        ChangeProfileData:FireServer(player, "Weapons", {[AMERICA_GUN.ItemID] = gunData})
    end)

    print(remoteSuccess and "✅ Remote update sent" or "❌ Remote error: "..tostring(remoteErr))
else
    warn("❌ ChangeProfileData remote not found")
end

print("\n=== DEBUG COMPLETE ===")
