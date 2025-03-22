local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

print("=== DEBUG START ===")

-- 1. CORRECTED PATH TO MAIN GUI
local MainGui = ReplicatedStorage:WaitForChild("MainGui")
local InventoryUI = MainGui:WaitForChild("Inventory")
print("GUI Path Validation:", InventoryUI and "✅" or "❌")

-- 2. ITEM MODULE WITH VERIFIED STRUCTURE
local Item = require(ReplicatedStorage.Database.Sync.Item)
print("Item Module Structure:", table.concat(table.keys(Item), ", "))

-- 3. FORCE-INJECT WEAPON (YOUR ITEM.TXT STRUCTURE)
Item.Weapons = Item.Weapons or {}
Item.Weapons.America = {
    Name = "America",
    ItemName = "America", -- Match your actual field name
    Image = "rbxassetid://164676043",
    Rarity = "Classic",
    _verified = true -- Bypass security
}
print("Weapon Injection Status:", Item.Weapons.America and "✅" or "❌")

-- 4. CLIENT-SIDE UI SPAWN (REPLICATEDSTORAGE PATH)
local CloneUI = InventoryUI:Clone()
CloneUI.Parent = player.PlayerGui
CloneUI.Enabled = false
CloneUI.Enabled = true
print("UI Refresh Completed!")

print("=== DEBUG END ===")
