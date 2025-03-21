-- Debugging: Print initial message to confirm the script is running
print("Fruit Selector GUI script is running.")

-- Services
local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local itemSpawnerServiceData = ReplicatedStorage:WaitForChild("ItemSpawnerServiceData")
local streamingRemote = itemSpawnerServiceData:WaitForChild("StreamingRemote")

-- GUI Setup
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FruitSelectorGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Active = true
frame.Draggable = true

-- Hide button
local hideButton = Instance.new("TextButton", frame)
hideButton.Size = UDim2.new(0, 30, 0, 20)
hideButton.Position = UDim2.new(1, -30, 0, 0)
hideButton.Text = "X"
hideButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
hideButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Dropdown
local dropdown = Instance.new("ScrollingFrame", frame)
dropdown.Size = UDim2.new(0, 180, 0, 120)
dropdown.Position = UDim2.new(0, 10, 0, 30)
dropdown.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)

local layout = Instance.new("UIListLayout", dropdown)
layout.Padding = UDim.new(0, 5)

-- "Get" button
local getButton = Instance.new("TextButton", frame)
getButton.Size = UDim2.new(0, 180, 0, 30)
getButton.Position = UDim2.new(0, 10, 1, -40)
getButton.Text = "Get"
getButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)

-- Fruit list (use EXACT names from FruitInfo)
local fruits = {
    "Rocket-Rocket", 
    "Ice-Ice", 
    "Spin-Spin" -- Add all fruits
}

local selectedFruit = nil

-- Populate dropdown
for _, fruitName in pairs(fruits) do
    local button = Instance.new("TextButton", dropdown)
    button.Size = UDim2.new(0, 160, 0, 20)
    button.Text = fruitName
    button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    button.MouseButton1Click:Connect(function()
        selectedFruit = fruitName
        print("Selected fruit: " .. selectedFruit)
    end)
end

-- Spawn logic
getButton.MouseButton1Click:Connect(function()
    if selectedFruit then
        local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not rootPart then 
            warn("Player root part not found!")
            return 
        end

        -- Mimic a legitimate request
        streamingRemote:FireServer({
            ItemId = selectedFruit,
            Player = player,
            Position = rootPart.Position + Vector3.new(0, 5, 0), -- Spawn above player
            Timestamp = os.time() -- Optional anti-exploit measure
        })
        print("Requested server to spawn: " .. selectedFruit)
    else
        warn("No fruit selected!")
    end
end)

print("GUI setup complete.")
