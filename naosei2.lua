local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== SCRIPT START ===")

-- 1. Database initialization with timeout
print("\n[1/5] Initializing database...")
local GetSyncData = ReplicatedStorage:FindFirstChild("GetSyncData")
local Database
local startTime = os.clock()

if GetSyncData then
    print("Found GetSyncData RemoteFunction")
    local success, err = pcall(function()
        Database = GetSyncData:InvokeServer()
    end)
    
    if success then
        print("Database received in", os.clock() - startTime, "seconds")
        print("Database structure keys:", table.concat(Database and table.keys(Database) or "nil", ", "))
    else
        warn("Database init failed:", err)
    end
else
    warn("GetSyncData not found in ReplicatedStorage!")
end

-- 2. Weapon registration debug
print("\n[2/5] Registering Harvester...")
if Database and Database.Weapons then
    Database.Weapons["Harvester"] = {
        ItemID = 7800847534,
        Rarity = "Ancient",
        -- ... (rest of your item data)
    }
    print("Weapons after injection:", table.concat(table.keys(Database.Weapons), ", "))
else
    warn("Database.Weapons not available!")
end

-- 3. Profile system debug
print("\n[3/5] Accessing profile system...")
local InventoryRemote = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Inventory")
    and ReplicatedStorage.Remotes.Inventory:FindFirstChild("ChangeProfileData")

if InventoryRemote then
    print("Found ChangeProfileData remote")
else
    warn("Missing critical remote: ReplicatedStorage.Remotes.Inventory.ChangeProfileData")
end

-- 4. Inventory modification attempt
print("\n[4/5] Attempting inventory modification...")
local harvesterEntry = {
    ItemID = 7800847534,
    Equipped = false,
    Obtained = os.time(),
    CustomData = {
        Rarity = "Ancient",
        Angles = {
            X = 0.6108652381980153,
            Y = math.pi,
            Z = math.pi/2
        }
    }
}

local success, err = pcall(function()
    InventoryRemote:FireServer(player, "Weapons", {[7800847534] = harvesterEntry})
end)

print("FireServer result:", success and "Success" or "Failed", "| Error:", err)

-- 5. Final verification
print("\n[5/5] Verifying through UI systems...")
task.wait(2) -- Allow time for replication

local ClientTween = ReplicatedStorage:FindFirstChild("ClientTweenStorage")
if ClientTween then
    print("Attempting UI feedback...")
    pcall(function()
        ClientTween.PlayClientTween:FireServer("InventoryNotification")
    end)
end

print("=== SCRIPT COMPLETE ===")
