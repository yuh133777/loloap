local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== AMERICAGUN INJECTION START ===")

-- 1. Database initialization
print("\n[1/4] Initializing database...")
local GetSyncData = ReplicatedStorage:FindFirstChild("GetSyncData")
local Database

if GetSyncData then
    local success, result = pcall(function()
        return GetSyncData:InvokeServer()
    end)
    
    if success then
        Database = result
        print("✅ Database loaded with", #Database.Weapons, "existing weapons")
    else
        warn("❌ Database init failed:", result)
    end
else
    warn("❌ Critical missing: GetSyncData RemoteFunction")
end

-- 2. Weapon registration
print("\n[2/4] Registering AmericaGun...")
if Database and Database.Weapons then
    Database.Weapons["AmericaGun"] = {
        ItemName = "America",
        Image = "http://www.roblox.com/asset/?id=164676043",
        ItemType = "Gun",
        Rarity = "Classic",
        ItemID = 196751752,
        Angles = {
            X = 0,
            Y = 0,
            Z = 0
        }
    }
    print("✅ Registered AmericaGun in database")
    print("New weapons count:", #Database.Weapons)
else
    warn("❌ Failed to access weapons database")
end

-- 3. Inventory update
print("\n[3/4] Updating inventory...")
local InventoryRemote = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Inventory")
    and ReplicatedStorage.Remotes.Inventory:FindFirstChild("ChangeProfileData")

if InventoryRemote then
    local gunData = {
        ItemID = 196751752,
        Equipped = false,
        Obtained = os.time(),
        CustomData = {
            Rarity = "Classic",
            Paint = "Patriotic" -- Custom property example
        }
    }
    
    local success, err = pcall(function()
        InventoryRemote:FireServer(player, "Weapons", {[196751752] = gunData})
    end)
    
    print(success and "✅ Inventory update sent" or "❌ Inventory update failed:", err)
else
    warn("❌ Missing critical remote: ChangeProfileData")
end

-- 4. UI feedback
print("\n[4/4] Triggering UI effects...")
local ClientTween = ReplicatedStorage:FindFirstChild("ClientTweenStorage")
if ClientTween then
    pcall(function()
        ClientTween.CreateClientTween:FireServer("NewItemPopup", {
            Type = "Fade",
            Goal = Vector3.new(1, 0, 0),
            Time = 0.5
        })
        print("✅ UI animation triggered")
    end)
else
    print("⚠️ ClientTweenStorage not found - skipping UI feedback")
end

print("=== INJECTION COMPLETE ===")
