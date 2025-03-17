-- Access ReplicatedStorage
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Access the "Cases" folder
local CasesFolder = ReplicatedStorage:FindFirstChild("Cases")

if CasesFolder then
    -- List of case names
    local caseNames = {
        "Hapax Case", "Hiato Case", "Imaginem Case", "Karambit Case", 
        "Kitter Case", "Militia Case", "Modern Case", "Remastered Case", 
        "SCR Case", "Vortax Case"
    }

    -- Loop through each case name
    for _, caseName in pairs(caseNames) do
        -- Find the case folder
        local caseFolder = CasesFolder:FindFirstChild(caseName)
        if caseFolder then
            -- Find the "Available" bool value
            local available = caseFolder:FindFirstChild("Available")
            if available then
                -- Find the "CollectionPrice" string inside "Available"
                local collectionPrice = available:FindFirstChild("CollectionPrice")
                if collectionPrice then
                    -- Set the value of "CollectionPrice" to "0"
                    collectionPrice.Value = "0"
                    print(`Set {caseName}'s CollectionPrice to 0 credits.`)
                else
                    warn(`"CollectionPrice" not found in {caseName}'s "Available" folder.`)
                end
            else
                warn(`"Available" not found in {caseName} folder.`)
            end
        else
            warn(`Case folder "{caseName}" not found in "Cases" folder.`)
        end
    end
else
    warn(`"Cases" folder not found in ReplicatedStorage.`)
end
