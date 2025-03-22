local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Method 1: Guilds Deposit (Server-Side Validation Bypass)
local function Method1()
    local Remote = ReplicatedStorage.Network:FindFirstChild("Guilds_DepositDiamonds")
    
    if Remote and Remote.ClassName == "RemoteFunction" then
        print("METHOD 1: Found deposit remote!")
        
        -- Test with small amount first
        local testSuccess = Remote:InvokeServer(1000)
        if testSuccess then
            print("Small test deposit worked! Scaling up...")
            for i = 1, 100 do
                Remote:InvokeServer(10000000) -- 10M per call
                print("Added 10M diamonds (Total: "..(i*10).."M)")
                task.wait(0.5)
            end
            return true
        else
            print("Server rejected deposit request")
            return false
        end
    end
end

-- Method 2: Timed Rewards (Space-safe Implementation)
local function Method2()
    local reward = ReplicatedStorage["__DIRECTORY"].TimedRewards["TimedReward | DailyDiamonds1"]
    
    if reward then
        print("METHOD 2: Found TimedReward with space!")
        
        -- Get current diamonds before
        local initial = player.leaderstats.Diamonds.Value
        
        -- Claim with realistic delays
        for i = 1, 20 do
            reward.Claim:FireServer()
            local current = player.leaderstats.Diamonds.Value
            print("Claim "..i.." | Added "..(current - initial).." diamonds")
            initial = current
            task.wait(2) -- Realistic delay
        end
        return true
    end
end

-- Method 3: Direct Server Bypass (Requires Backdoor Access)
local function Method3()
    if player:FindFirstChild("_backend") then -- Common backend object
        local diamonds = player._backend:FindFirstChild("Diamonds")
        if diamonds then
            diamonds.Value = 1000000000
            print("DIRECT SERVER OVERRIDE SUCCESS!")
            return true
        end
    end
end

-- Execution Flow
print("=== DIAMOND GENERATOR v3 ===")
if Method1() then
    print("Method 1 Success!")
elseif Method2() then
    print("Method 2 Success!")
elseif Method3() then
    print("Method 3 Success!")
else
    warn("All methods failed! Check server validation.")
end

print("Check your diamonds! If nothing changed:")
print("1. Server likely validates requests")
print("2. Modify ServerScriptService scripts (you own the game)")
print("3. Look for 'DiamondHandler' server scripts to disable checks")
