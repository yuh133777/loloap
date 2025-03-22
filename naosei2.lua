local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== DEBUG SESSION START ===")
print("Player:", player.Name)
print("PlaceID:", game.PlaceId)

-- 1. Module verification
print("\n[1] MODULE CHECKS")
local InventoryService, ProfileData
local modulePaths = {
    InventoryService = "Modules.InventoryService",
    ProfileData = "Modules.ProfileData",
    InventoryGUI = "MainGui.Inventory.Inventory"
}

for name, path in pairs(modulePaths) do
    local module = ReplicatedStorage:FindFirstChild(path)
    print(("%s exists: %s"):format(path, module and "✅" or "❌"))
    if module then
        local success, result = pcall(require, module)
        print(("%s loaded: %s"):format(name, success and "✅" or "❌"))
        if success then
            _G[name] = result
        end
    end
end

-- 2. Weapon data validation
print("\n[2] WEAPON DATA")
local AMERICA_GUN = {
    ItemID = "196751752",
    ItemName = "America",
    Image = "rbxassetid://164676043",
    ItemType = "Gun",
    Rarity = "Classic",
    Event = "Independence",
    Year = 2024,
    Angles = {
        X = 0,
        Y = 0,
        Z = 0
    }
}
print("Weapon structure validated:", AMERICA_GUN and "✅" or "❌")

-- 3. Database injection
print("\n[3] DATABASE INTEGRATION")
local Sync = require(ReplicatedStorage.Database.Sync)
if Sync.Weapons then
    Sync.Weapons[AMERICA_GUN.ItemID] = AMERICA_GUN
    print("Database injected:", Sync.Weapons[AMERICA_GUN.ItemID] and "✅" or "❌")
else
    warn("Critical: Weapons database not found!")
end

-- 4. Profile system access
print("\n[4] PROFILE SYSTEM")
local profile
if _G.ProfileData then
    profile = _G.ProfileData.GetProfile(player)
    print("Profile loaded:", profile and "✅" or "❌")
else
    warn("ProfileData module failed to load")
end

-- 5. Inventory addition attempt
print("\n[5] INVENTORY ADDITION")
local success = false
if _G.InventoryService then
    success = _G.InventoryService:AddItem(player, "Weapons", AMERICA_GUN.ItemID, {
        Obtained = os.date("%Y-%m-%d"),
        Equipped = false,
        CustomData = {
            SpecialTag = "Patriotic"
        }
    })
    print("Service addition result:", success and "✅" or "❌")
end

-- 6. Remote fallback
if not success then
    print("\n[6] REMOTE FALLBACK")
    local ChangeProfileData = ReplicatedStorage:FindFirstChild("Remotes.Inventory.ChangeProfileData")
    if ChangeProfileData then
        local args = {
            player,
            "Weapons",
            {
                [AMERICA_GUN.ItemID] = {
                    ItemID = AMERICA_GUN.ItemID,
                    Equipped = false,
                    Obtained = os.time(),
                    CustomData = {
                        Rarity = "Classic"
                    }
                }
            }
        }
        local rSuccess, rErr = pcall(ChangeProfileData.FireServer, ChangeProfileData, unpack(args))
        print("Remote fired:", rSuccess and "✅" or "❌")
        print("Remote error:", rErr or "None")
    else
        warn("Critical: ChangeProfileData remote missing!")
    end
end

-- 7. UI refresh
print("\n[7] UI REFRESH")
if _G.InventoryGUI then
    pcall(_G.InventoryGUI.RefreshInventory, _G.InventoryGUI, "Weapons")
    print("UI refresh attempted")
else
    print("InventoryGUI module not available")
end

print("\n=== DEBUG COMPLETE ===")
