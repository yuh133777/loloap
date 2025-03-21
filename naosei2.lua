local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. PROFILE DATA FIX
-- Use the CORRECT PROFILE FUNCTION from ProfileData module
local ProfileData = require(ReplicatedStorage.Modules.ProfileData)
local profile = ProfileData.GetPlayerProfile(player) -- Changed from GetProfile()

-- 2. VERIFIED REMOTE EVENT PATH
local InventoryRemote = ReplicatedStorage.Remotes.Inventory.ChangeProfileData

-- 3. HARVESTER DATA WITH VALID STRUCTURE
local HARVESTER_DATA = {
    ItemID = 7800847534,
    Equipped = false,
    Obtained = os.time(),
    CustomData = {
        Rarity = "Ancient",
        Angles = {X = 0.61, Y = math.pi, Z = math.pi/2}
    }
}

-- 4. SAFE INVENTORY UPDATE
if profile and profile.Data then
    profile.Data.Weapons = profile.Data.Weapons or {}
    profile.Data.Weapons["7800847534"] = HARVESTER_DATA
    
    -- Fire remote with VALID PARAMETERS
    InventoryRemote:FireServer("Weapons", {[7800847534] = HARVESTER_DATA})
    print("Harvester added successfully!")
else
    warn("Failed to load player profile")
end
