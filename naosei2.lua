local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== DEBUG START ===")

-- 1. Module loader with path validation
local function SafeRequire(path)
    local current = ReplicatedStorage
    for _, part in ipairs(path:split("/")) do
        current = current:FindFirstChild(part)
        if not current then 
            warn("❌ Path broken at:", part)
            return nil
        end
    end
    return require(current)
end

-- 2. Load Item module with debug
local Item = SafeRequire("Database/Sync/Item")
print("Item module loaded:", Item and "✅" or "❌")

-- 3. Bypass TrustAndSafety (added debug)
if Item then
    print("TrustAndSafety bypass status:", 
        Item._verified and "✅" or "❌ (modify structure)")

    -- Force-inject weapon
    Item.Weapons = Item.Weapons or {}
    Item.Weapons.America = {
        Name = "America",
        ItemID = "196751752",
        Image = "rbxassetid://164676043",
        _verified = true -- Bypass assert
    }
    print("Weapon injected:", Item.Weapons.America and "✅" or "❌")
end

-- 4. Client-side UI spoof (works without server)
task.spawn(function()
    local InventoryUI = player.PlayerGui.MainGui.Inventory
    local RealGetInventory = InventoryUI.GetInventory
    InventoryUI.GetInventory = function()
        local fake = RealGetInventory()
        fake.Weapons = fake.Weapons or {}
        fake.Weapons.America = {Equipped = false}
        return fake
    end
    InventoryUI.Enabled = false
    InventoryUI.Enabled = true
    print("UI spoofed!")
end)

print("=== DEBUG END ===")
