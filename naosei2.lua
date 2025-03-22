local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Force database initialization like the game does
local GetSyncData = ReplicatedStorage:WaitForChild("GetSyncData")
local Database = GetSyncData:InvokeServer()
print("Database initialized:", Database ~= nil)

-- 2. Register Harvester in weapons database
Database.Weapons["Harvester"] = {
    ItemName = "Harvester",
    Image = "http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=250&height=250&assetId=7800847534",
    ItemType = "Gun",
    Rarity = "Ancient",
    ItemID = 7800847534,
    Event = "Halloween",
    Year = "2021",
    Angles = {
        X = 0.6108652381980153,
        Y = math.pi,
        Z = math.pi/2
    }
}

-- 3. Get inventory components
local InventoryRemote = ReplicatedStorage.Remotes.Inventory.ChangeProfileData
local ClientTween = ReplicatedStorage.ClientTweenStorage

-- 4. Create fake "new item" animation
local function PlayFakeUnlockAnimation()
    ClientTween.CreateClientTween:FireServer("InventoryNotification", {
        Type = "Scale",
        Goal = Vector3.new(1.2, 1.2, 1),
        Time = 0.3,
        Style = "Elastic"
    })
    ClientTween.PlayClientTween:FireServer("InventoryNotification")
end

-- 5. Modified inventory grant sequence
local function GrantHarvester()
    -- Get fresh profile data
    local profile = ReplicatedStorage.Remotes.Inventory.GetProfileData:InvokeServer()
    print("Profile received:", profile)
    
    if not profile.Weapons then
        profile.Weapons = {}
    end
    
    -- Add item with validated structure
    profile.Weapons["7800847534"] = {
        ItemID = 7800847534,
        Equipped = false,
        Obtained = os.time(),
        CustomData = {
            Rarity = "Ancient",
            ModelOffset = CFrame.Angles(
                math.rad(35),
                math.pi,
                math.rad(90)
        }
    }
    
    -- Update server and client
    InventoryRemote:FireServer(player, "Weapons", profile.Weapons)
    PlayFakeUnlockAnimation()
    
    -- Force inventory refresh
    ReplicatedStorage.Remotes.Inventory.ProfileDataChanged:Fire("Weapons", profile.Weapons)
    print("Update sequence completed!")
end

-- 6. Execute with error handling
local success, err = pcall(GrantHarvester)
if not success then
    warn("Critical error:", err)
    -- Attempt emergency write
    ReplicatedStorage.Remotes.Misc.GetPlayerProfile:InvokeServer(player):AddItem("Weapons", "7800847534")
end
