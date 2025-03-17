-- Wait for the ScreenGUI named "BanBoi" to load
local screenGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("BanBoi")

-- Ensure the ScreenGUI is enabled and visible
screenGui.Enabled = true

-- Print a confirmation message
print("BanBoi ScreenGUI has been opened.")
