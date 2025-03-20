-- GUI Setup
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0.2, 0, 0.5, 0)
frame.Position = UDim2.new(0, 0, 0.5, 0)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.new(0, 0, 0)

-- Walkspeed Input
local walkspeedBox = Instance.new("TextBox", frame)
walkspeedBox.Size = UDim2.new(0.8, 0, 0.1, 0)
walkspeedBox.Position = UDim2.new(0.1, 0, 0.8, 0)
walkspeedBox.PlaceholderText = "Enter Walkspeed"
walkspeedBox.BackgroundColor3 = Color3.new(1, 1, 1)
walkspeedBox.TextColor3 = Color3.new(0, 0, 0)

local walkspeedButton = Instance.new("TextButton", frame)
walkspeedButton.Size = UDim2.new(0.8, 0, 0.1, 0)
walkspeedButton.Position = UDim2.new(0.1, 0, 0.9, 0)
walkspeedButton.Text = "Set Walkspeed"
walkspeedButton.BackgroundColor3 = Color3.new(0, 0.5, 1)
walkspeedButton.TextColor3 = Color3.new(1, 1, 1)

-- Walkspeed Button Logic
walkspeedButton.MouseButton1Click:Connect(function()
    -- Get the input from the text box
    local speed = tonumber(walkspeedBox.Text)

    -- Check if the input is a valid number
    if speed then
        -- Get the player's character
        local character = game.Players.LocalPlayer.Character
        if character then
            -- Get the Humanoid object
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                -- Set the walkspeed
                humanoid.WalkSpeed = speed
                print("Walkspeed set to:", speed) -- Debugging: Print the walkspeed to the console
            else
                warn("Humanoid not found in character!") -- Debugging: Warn if Humanoid is missing
            end
        else
            warn("Character not found!") -- Debugging: Warn if character is missing
        end
    else
        warn("Invalid input! Please enter a number.") -- Debugging: Warn if input is invalid
    end
end)

-- Fruit List
local fruitList = Instance.new("ScrollingFrame", frame)
fruitList.Size = UDim2.new(0.8, 0, 0.7, 0)
fruitList.Position = UDim2.new(0.1, 0, 0.05, 0)
fruitList.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
fruitList.CanvasSize = UDim2.new(0, 0, 2, 0) -- Allow scrolling

-- ESP Setup
local espBoxes = {} -- Stores ESP boxes for each fruit
local fruitLabels = {} -- Stores labels for each fruit

-- Function to create ESP box
local function createESPBox(fruitInstance)
    local box = Drawing.new("Square")
    box.Visible = true
    box.Color = Color3.new(1, 0, 0) -- Red border
    box.Thickness = 2
    box.Filled = false
    return box
end

-- Function to create fruit label
local function createFruitLabel(fruitName)
    local label = Drawing.new("Text")
    label.Visible = true
    label.Text = fruitName
    label.Color = Color3.new(1, 1, 1) -- White text
    label.Size = 18
    label.Center = true
    return label
end

-- Function to update ESP and GUI
local function updateESP()
    local spawnedItemsFolder = workspace:FindFirstChild("SpawnedItems")
    if not spawnedItemsFolder then return end

    for _, fruitInstance in pairs(spawnedItemsFolder:GetChildren()) do
        local fruitId = fruitInstance.Name
        if not espBoxes[fruitId] then
            -- Create ESP box and label
            espBoxes[fruitId] = createESPBox(fruitInstance)
            fruitLabels[fruitId] = createFruitLabel(fruitInstance.Name)
        end

        -- Update ESP box position
        local position, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(fruitInstance.Position)
        if onScreen then
            espBoxes[fruitId].Visible = true
            espBoxes[fruitId].Position = Vector2.new(position.X, position.Y)
            espBoxes[fruitId].Size = Vector2.new(50, 50) -- Adjust size as needed

            fruitLabels[fruitId].Visible = true
            fruitLabels[fruitId].Position = Vector2.new(position.X, position.Y - 20) -- Position above the box
        else
            espBoxes[fruitId].Visible = false
            fruitLabels[fruitId].Visible = false
        end
    end
end

-- Function to update the fruit list in the GUI
local function updateFruitList()
    local spawnedItemsFolder = workspace:FindFirstChild("SpawnedItems")
    if not spawnedItemsFolder then return end

    -- Clear existing list
    for _, child in pairs(fruitList:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    -- Add new items to the list
    local yOffset = 0
    for _, fruitInstance in pairs(spawnedItemsFolder:GetChildren()) do
        local fruitLabel = Instance.new("TextLabel", fruitList)
        fruitLabel.Text = fruitInstance.Name
        fruitLabel.Size = UDim2.new(0.8, 0, 0.05, 0)
        fruitLabel.Position = UDim2.new(0.1, 0, 0, yOffset)
        fruitLabel.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        fruitLabel.TextColor3 = Color3.new(1, 1, 1)
        yOffset = yOffset + 0.05
    end
end

-- Main Loop
while true do
    updateESP()
    updateFruitList()
    wait(0.1)
end
