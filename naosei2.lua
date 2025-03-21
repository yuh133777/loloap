local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Shop = Remotes:WaitForChild("Shop")

-- Use the exact parameters the server expects
local success, errorMsg = Shop.BuyItem:InvokeServer(
    "538886310",  -- ItemID from DevProducts
    "DevProducts", -- ShopType
    "Gems",        -- CurrencyType
    nil            -- Placeholder for GUI (may not be needed)
)

if success then
    print("Success! 100 Gems added.")
else
    warn("Failed:", errorMsg) -- Check F9 for the error details
end
