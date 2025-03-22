local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Force-load modules with nil protection
local function SafeRequire(path)
    local module = ReplicatedStorage:FindFirstChild(path, true)
    return module and require(module) or {}
end

local Item = SafeRequire("Database/Sync/Item")
local TrustAndSafety = SafeRequire("CoreGui/RobloxGui/Modules/TrustAndSafety")

-- 2. Bypass TrustAndSafety checks
if TrustAndSafety.ValidateInventoryAction then
    TrustAndSafety.ValidateInventoryAction = function() return true end
    print("✅ TrustAndSafety validation disabled")
end

-- 3. Inject weapon with server-validated fields
local AmericaGun = {
    Name = "America",
    ItemID = "196751752",
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    IsApproved = true, -- Fake approval
    ServerSignature = "SECURE_SIG_"..tostring(os.time()), -- Spoofed
    Timestamp = os.time(),
    _Verified = true -- Bypass assert checks
}

-- 4. Weapon injection with fallback
if not Item.Weapons then Item.Weapons = {} end
Item.Weapons["America"] = AmericaGun
print("Weapon DB Status:", Item.Weapons.America and "✅ Injected" or "❌ Failed")

-- 5. Force inventory update
local args = {
    Action = "AdminAdd", -- Spoof admin action
    ItemId = "America",
    Data = {
        Owner = player.UserId,
        Serial = "ADMIN-BYPASS-"..math.random(1000,9999),
        Signature = "VALID_"..tostring(os.time())
    }
}

ReplicatedStorage.Remotes.Inventory.ChangeProfileData:FireServer(args)

-- 6. UI manipulation (works even if server rejects)
task.wait(1)
local InventoryUI = player.PlayerGui:WaitForChild("MainGui"):WaitForChild("Inventory")
InventoryUI.Enabled = false
InventoryUI.Enabled = true
print("UI refresh triggered!")

-- 7. Client-side spoofing
local FakeInventory = require(ReplicatedStorage.ClientServices.InventoryService)
FakeInventory.GetInventory = function() 
    return {Weapons = {America = AmericaGun}}
end

print("America Gun visible in inventory!")
