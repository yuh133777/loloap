local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== AMERICA GUN INJECTION DEBUG ===")

-- 1. Load modules with validation
local Sync
local Item
local success, err = pcall(function()
    Sync = require(ReplicatedStorage.Database.Sync)
    Item = require(ReplicatedStorage.Database.Sync.Item)
end)

print("Modules loaded:", success and "✅" or "❌ "..tostring(err))
if not success then return end

-- 2. Verify weapons table structure
print("\nWeapons table check:")
print("Type of Item:", typeof(Item))
print("Item contents:", table.concat(table.keys(Item), ", "))
print("Item.Weapons exists?", Item.Weapons ~= nil)

-- 3. Create America gun entry
local AmericaGun = {
    Name = "America", -- Critical: Must match Name field from Item.txt
    ItemName = "America", -- Some systems use different naming
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    ItemType = "Gun",
    Angles = {
        X = 0.6108652381980153,
        Y = math.pi,
        Z = math.pi/2
    }
}

-- 4. Safe injection with verification
print("\nInventory injection:")
if Item.Weapons then
    print("Existing weapons:", table.concat(table.keys(Item.Weapons), ", "))
    Item.Weapons["America"] = AmericaGun
    print("New weapons list:", table.concat(table.keys(Item.Weapons), ", "))
else
    warn("CRITICAL: Weapons table missing!")
    print("Attempting fallback to Sync.Weapons")
    Sync.Weapons = Sync.Weapons or {}
    Sync.Weapons["America"] = AmericaGun
end

-- 5. Inventory update
print("\nProfile update:")
local ChangeProfileData = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Inventory")
    and ReplicatedStorage.Remotes.Inventory:FindFirstChild("ChangeProfileData")

if ChangeProfileData then
    local gunData = {
        ItemID = "America", -- Must match injection key
        Obtained = os.date("%Y-%m-%d"),
        Equipped = false,
        CustomData = {
            Rarity = "Classic",
            Special = "Patriotic"
        }
    }
    
    local success, err = pcall(function()
        ChangeProfileData:FireServer(player, "Weapons", {America = gunData})
    end)
    
    print(success and "✅ Update sent" or "❌ Failed: "..tostring(err))
else
    warn("RemoteEvent not found!")
end

print("\n=== DEBUG COMPLETE ===")
