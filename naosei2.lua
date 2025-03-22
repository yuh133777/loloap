local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local player = Players.LocalPlayer

-- 1. Load ApolloClient from CorePackages
local ApolloClient = require(CorePackages.Packages.ApolloClient)
local InGameServices = require(CorePackages.InGameServices)

-- 2. Initialize game services
local InventoryService = InGameServices.InventoryService
local ProfileService = InGameServices.ProfileService

-- 3. ApolloClient query template for inventory updates
local HARVESTER_MUTATION = ApolloClient.gql[[
  mutation AddHarvester($playerId: ID!, $itemId: ID!) {
    addInventoryItem(playerId: $playerId, itemId: $itemId) {
      success
      item {
        id
        name
        equipped
      }
    }
  }
]]

-- 4. Function to grant Harvester
local function GrantHarvester()
    -- Get player profile via official service
    local profile = ProfileService:GetPlayerProfile(player)
    if not profile then
        warn("Profile not loaded!")
        return
    end

    -- Execute ApolloClient mutation
    local result = ApolloClient:mutate({
        mutation = HARVESTER_MUTATION,
        variables = {
            playerId = tostring(player.UserId),
            itemId = "7800847534"
        }
    })

    -- Handle response
    if result.data.addInventoryItem.success then
        print("Harvester added via ApolloClient!")
        -- Trigger UI update
        ReplicatedStorage.ClientTweenStorage.PlayClientTween:FireServer("InventoryRefresh")
    else
        warn("Mutation failed:", result.errors)
    end
end

-- 5. Error handling wrapper
local success, err = pcall(GrantHarvester)
if not success then
    warn("Critical error:", err)
    -- Fallback to direct remote
    ReplicatedStorage.Remotes.Inventory.ChangeProfileData:FireServer(
        player,
        "Weapons",
        {["7800847534"] = {
            ItemID = 7800847534,
            Equipped = false,
            Obtained = os.time()
        }}
    )
end
