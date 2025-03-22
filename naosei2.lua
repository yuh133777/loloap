local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== DEBUG START ===")
print("1. Basic environment check...")
print("Player:", player.Name)
print("PlaceId:", game.PlaceId)

print("\n2. Module pre-check...")
local safeRequire = function(module)
    local success, result = pcall(require, module)
    print("Require attempt:", module:GetFullName(), success)
    return success and result
end

print("\n3. Critical dependencies:")
local ProfileData = safeRequire(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ProfileData"))
local InventoryModule = safeRequire(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("InventoryModule"))

print("\n4. Remote verification:")
local ChangeProfileData = ReplicatedStorage:FindFirstChild("Remotes")
    and ReplicatedStorage.Remotes:FindFirstChild("Inventory")
    and ReplicatedStorage.Remotes.Inventory:FindFirstChild("ChangeProfileData")

if ChangeProfileData then
    print("ChangeProfileData exists")
else
    warn("Missing ChangeProfileData remote!")
end

print("\n5. Inventory modification attempt...")
local harvesterData = {
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
    ChangeProfileData:FireServer(player, "Weapons", {[7800847534] = harvesterData})
    print("FireServer completed without errors")
end)

print("\n6. Final status:")
print("Success:", success)
print("Error:", err)
print("=== DEBUG END ===")
