local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 1. Use the CORRECT REMOTE TO FETCH PROFILE DATA
local GetProfileData = ReplicatedStorage.Remotes.Inventory.GetProfileData
local ChangeProfileData = ReplicatedStorage.Remotes.Inventory.ChangeProfileData

-- 2. Fetch profile data via RemoteFunction
local profile = GetProfileData:InvokeServer() -- No parameters needed if it uses player implicitly

-- 3. Define Harvester data
local HARVESTER_DATA = {
    ItemID = 7800847534,
    Equipped = false,
    Obtained = os.time(),
    Rarity = "Ancient",
    Angles = { X = 0.61, Y = math.pi, Z = math.pi/2 }
}

-- 4. Update profile
if profile and profile.Weapons then
    profile.Weapons["7800847534"] = HARVESTER_DATA
    ChangeProfileData:FireServer("Weapons", profile.Weapons) -- Fire validated remote
    print("Harvester added to inventory!")
else
    warn("Profile data structure invalid. Response from server:", profile)
end
