local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Bypass module errors
local function ForceLoadModule(path)
    local module = ReplicatedStorage:FindFirstChild(path, true)
    return module and require(module) or {}
end

-- 2. Load critical modules
local Item = ForceLoadModule("Database/Sync/Item")
local Sync = ForceLoadModule("Database/Sync")
print("🔍 Modules loaded:", Item ~= nil and Sync ~= nil)

-- 3. Inject weapon DIRECTLY into client-side database
Item.Weapons = Item.Weapons or {}
Item.Weapons.America = {
    Name = "America",
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    _bypass = true -- Disable security checks
}
print("🔫 Weapon injected:", Item.Weapons.America ~= nil)

-- 4. Spoof inventory UI (works without server)
local function HijackUI()
    local Inventory = player.PlayerGui:WaitForChild("MainGui"):WaitForChild("Inventory")
    local OldRefresh = Inventory.RefreshInventory
    Inventory.RefreshInventory = function(self, category)
        OldRefresh(self, category)
        if category == "Weapons" then
            -- Force-add fake entry
            self.Container.Weapons.America = {
                ItemName = "America",
                Rarity = "Classic",
                Image = "rbxassetid://164676043"
            }
        end
    end
    Inventory.Enabled = false
    Inventory.Enabled = true
    print("🔄 UI hijacked!")
end

-- 5. Execute
HijackUI()
print("✅ America Gun FORCED into inventory!")
