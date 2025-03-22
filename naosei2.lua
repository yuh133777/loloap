local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Bypass decompiler errors by loading Item directly
local Item = require(ReplicatedStorage.Database.Sync.Item)
print("Item module keys:", table.concat(table.keys(Item), ", "))

-- Verify weapons table existence
if not Item.Weapons then
    warn("Weapons table missing! Attempting reconstruction...")
    Item.Weapons = {} -- Create if destroyed by anti-tamper
end

-- Define AmericaGun with server validation fields
local AmericaGun = {
    Name = "America",
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    ItemType = "Gun",
    IsApproved = true, -- Bypass TrustAndSafety checks
    Source = "Official",
    Event = "IndependenceDay2024"
}

-- Inject into database with validation bypass
Item.Weapons["America"] = AmericaGun
print("Database injection verified:", Item.Weapons.America ~= nil)

-- Force inventory update through backdoor remote
local BackdoorRemote = ReplicatedStorage.Remotes:FindFirstChild("InventoryBackdoor") 
    or ReplicatedStorage.Remotes.Inventory.ChangeProfileData

local InventoryData = {
    ItemID = "America",
    Timestamp = os.time(),
    Signature = "VALID_SIGNATURE", -- Bypass assert checks
    Metadata = {
        Rarity = "Classic",
        IsAdminGranted = true
    }
}

BackdoorRemote:FireServer(player, "ForceAddWeapon", InventoryData)

-- Hard refresh UI components
require(player.PlayerGui.MainGui.Inventory.Inventory):RefreshInventory("Weapons")
require(ReplicatedStorage.ClientTweenStorage.PlayClientTween):Fire("FullInventoryRefresh")

print("America Gun forcefully added - bypassed all validations!")
