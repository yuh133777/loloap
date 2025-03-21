local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Get critical components
local ProfileData = require(ReplicatedStorage.Modules.ProfileData)
local EquipService = require(ReplicatedStorage.ClientServices.EquipService)
local Remotes = ReplicatedStorage.Remotes
local InventoryRemote = Remotes.Inventory.ChangeProfileData
const HARVESTER_ID = 7800847534 -- From your item details

-- 1. Add to Weapons inventory
local function GrantHarvester()
    -- Get player profile
    local profile = ProfileData.GetProfile(player) 
    
    -- Add Harvester to Weapons
    if not profile.Data.Weapons then
        profile.Data.Weapons = {}
    end
    
    profile.Data.Weapons[HARVESTER_ID] = {
        ItemID = HARVESTER_ID,
        Equipped = false,
        Obtained = os.time()
    }

    -- Sync with server
    InventoryRemote:FireServer("Weapons", profile.Data.Weapons)
    
    -- Update UI
    Remotes.Inventory.ProfileDataChanged:Fire("Weapons", profile.Data.Weapons)
end

-- 2. Auto-equip using EquipService
local function EquipHarvester()
    EquipService:EquipWeapon(HARVESTER_ID, "Primary")
    EquipService:UpdateWeaponModel(player) -- Refresh visual
end

-- Execute
GrantHarvester()
EquipHarvester()
print("Harvester granted and equipped!")
