-- Debugging: Print initial message to confirm the script is running
print("Fruit Selector GUI script is running.")

-- Create the GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FruitSelectorGUI"

-- Debugging: Print GUI creation
print("GUI created and parented to PlayerGui.")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 200) -- Increased height to accommodate the "Get" button below the dropdown
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Active = true
frame.Draggable = true

-- Debugging: Print frame creation
print("Frame created and added to GUI.")

local hideButton = Instance.new("TextButton", frame)
hideButton.Size = UDim2.new(0, 30, 0, 20)
hideButton.Position = UDim2.new(1, -30, 0, 0)
hideButton.Text = "X"
hideButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
hideButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    print("Hide button clicked. Frame visibility toggled.") -- Debugging: Print hide button click
end)

-- Dropdown (ScrollingFrame)
local dropdown = Instance.new("ScrollingFrame", frame)
dropdown.Size = UDim2.new(0, 180, 0, 120) -- Adjusted size to fit within the frame
dropdown.Position = UDim2.new(0, 10, 0, 30)
dropdown.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)

local layout = Instance.new("UIListLayout", dropdown)
layout.Padding = UDim.new(0, 5)

-- Debugging: Print dropdown creation
print("Dropdown created and added to frame.")

-- "Get" button (placed below the dropdown)
local getButton = Instance.new("TextButton", frame)
getButton.Size = UDim2.new(0, 180, 0, 30)
getButton.Position = UDim2.new(0, 10, 1, -40) -- Positioned below the dropdown
getButton.Text = "Get"
getButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)

-- Debugging: Print get button creation
print("Get button created and added to frame.")

-- List of fruits
local fruits = {
    "Rocket", "Spin", "Blade", "Spring", "Bomb", "Smoke", "Spike", "Flame", "Falcon", "Ice", "Sand", "Dark", "Diamond", 
    "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake", "Buddha", "Love", "Spider", "Sound", "Phoenix", "Portal", 
    "Rumble", "Pain", "Blizzard", "Gravity", "Mammoth", "T-Rex", "Dough", "Shadow", "Venom", "Control", "Gas", "Spirit", 
    "Leopard", "Yeti", "Kitsune", "Dragon"
}

-- Create a table to store the selected fruit
local fruitData = {
    selectedFruit = nil
}

-- Populate the dropdown with fruits
for _, fruitName in pairs(fruits) do
    local button = Instance.new("TextButton", dropdown)
    button.Size = UDim2.new(0, 160, 0, 20)
    button.Text = fruitName
    button.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
    button.MouseButton1Click:Connect(function()
        fruitData.selectedFruit = fruitName
        print("Selected fruit: " .. fruitData.selectedFruit) -- Debugging: Print selected fruit
    end)
    dropdown.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

-- Debugging: Print dropdown population
print("Dropdown populated with fruits.")

-- Function to spawn the selected fruit as a model in the game world
getButton.MouseButton1Click:Connect(function()
    if fruitData.selectedFruit then
        print("Attempting to spawn fruit: " .. fruitData.selectedFruit) -- Debugging: Print attempt to spawn fruit

        -- Use pcall to catch errors during fruit spawning
        local success, errorMessage = pcall(function()
            -- Create the fruit model
            local fruitModel = Instance.new("Model")
            fruitModel.Name = fruitData.selectedFruit .. "-" .. fruitData.selectedFruit

            -- Create a part to represent the fruit
            local fruitPart = Instance.new("Part", fruitModel)
            fruitPart.Name = "Handle"
            fruitPart.Size = Vector3.new(2, 2, 2)
            fruitPart.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0) -- Spawn near the player
            fruitPart.Anchored = true
            fruitPart.CanCollide = true
            fruitPart.BrickColor = BrickColor.new("Bright red") -- Customize the color as needed

            -- Add a TouchInterest to allow players to collect the fruit
            local touchInterest = Instance.new("TouchTransmitter", fruitPart)
            touchInterest.Name = "TouchInterest"

            -- Parent the fruit model to the workspace
            fruitModel.Parent = workspace

            -- Optional: Add a script to handle collection logic (if needed)
            local collectionScript = Instance.new("Script", fruitModel)
            collectionScript.Name = "FruitCollectionScript"
            collectionScript.Source = [[
                local tool = script.Parent
                local handle = tool:WaitForChild("Handle")
                local touchInterest = handle:WaitForChild("TouchInterest")

                touchInterest.Touched:Connect(function(hit)
                    local player = game.Players:GetPlayerFromCharacter(hit.Parent)
                    if player then
                        -- Add the fruit to the player's backpack
                        local toolClone = tool:Clone()
                        toolClone.Parent = player.Backpack
                        tool:Destroy() -- Remove the fruit from the world
                    end
                end)
            ]]

            print("Successfully spawned " .. fruitData.selectedFruit .. " in the game world.") -- Debugging: Print success
        end)

        -- If an error occurred, print it
        if not success then
            print("Error spawning fruit: " .. tostring(errorMessage)) -- Debugging: Print error
        end
    else
        print("No fruit selected.") -- Debugging: Print if no fruit is selected
    end
end)

-- Debugging: Print final message to confirm script setup is complete
print("Fruit Selector GUI setup complete. Ready to use.")
