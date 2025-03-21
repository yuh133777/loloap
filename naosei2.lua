local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Load ProfileData CORRECTLY
local ProfileData = require(ReplicatedStorage.Modules.ProfileData)
local profile = ProfileData.GetProfile(player) -- Not GetPlayerProfile()

-- 2. Define Harvester Data
local HARVESTER_DATA = {
    ItemID = 7800847534,
    Equipped = false,
    Obtained = os.time(),
    Rarity = "Ancient",
    Angles = { X = 0.61, Y = math.pi, Z = math.pi/2 }
}

-- 3. Update Weapons Inventory
if profile and profile.Data then
    profile.Data.Weapons = profile.Data.Weapons or {}
    profile.Data.Weapons["7800847534"] = HARVESTER_DATA

    -- 4. Fire Remote with PLAYER PARAMETER
    local InventoryRemote = ReplicatedStorage.Remotes.Inventory.ChangeProfileData
    InventoryRemote:FireServer(player, "Weapons", { [7800847534] = HARVESTER_DATA })
    print("Harvester added!")
else
    warn("Profile not loaded. Retrying...")
    -- Retry after 5 seconds
    task.wait(5)
    InventoryRemote:FireServer(player, "Weapons", { [7800847534] = HARVESTER_DATA })
end
