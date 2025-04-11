local HttpService = game:GetService("HttpService")

-- URL of your GitHub raw JSON file
local url = "https://raw.githubusercontent.com/Grubbalisious/Fusion-API/refs/heads/main/src/teams"

-- Function to retrieve the JSON data
local function GetTeamData()
    local success, response = pcall(function()
        return HttpService:GetAsync(url)
    end)

    if success then
        return HttpService:JSONDecode(response)
    else
        warn("Failed to load team data from GitHub")
        return nil
    end
end

-- Get the team data from GitHub
local teams = GetTeamData()

-- Function to update stadium based on the home team's asset ID
local function UpdateStadium(stadiumAssetId)
    local game = game
    local workspace = game:GetService("Workspace")
    for _, descendant in ipairs(workspace:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name == "Stadium" then
            descendant:Destroy()  -- Remove the existing stadium
            local assetModel = game:GetObjects("rbxassetid://" .. stadiumAssetId)[1]
            if assetModel then
                assetModel.Parent = workspace
                print("Stadium model replaced with asset ID:", stadiumAssetId)
            else
                warn("Failed to load asset with ID:", stadiumAssetId)
            end
        end
    end
end

-- Function to set player's uniform based on team colors
local function SetPlayerUniform(player, team)
    local character = player.Character or player.CharacterAdded:Wait()
    local uniform = character:WaitForChild('Uniform')

    -- Apply team colors to the uniform
    uniform.Shirt.Color = Color3.fromHex(team.Colors.JerseyShirt)
    uniform.Helmet.Color = Color3.fromHex(team.Colors.Helmet)
    uniform.LeftPants.Color = Color3.fromHex(team.Colors.LeftPants)
    uniform.RightPants.Color = Color3.fromHex(team.Colors.RightPants)
    uniform.LeftShoe.Color = Color3.fromHex(team.Colors.LeftShoe)
    uniform.RightShoe.Color = Color3.fromHex(team.Colors.RightShoe)
    uniform.LeftGlove.Color = Color3.fromHex(team.Colors.LeftGlove)
    uniform.RightGlove.Color = Color3.fromHex(team.Colors.RightGlove)
    uniform.LeftSock.Color = Color3.fromHex(team.Colors.LeftSock)
    uniform.RightSock.Color = Color3.fromHex(team.Colors.RightSock)

    -- Update logo (if you have logos on the uniform)
    if uniform:FindFirstChild("Helmet") and uniform.Helmet:FindFirstChild("RightLogo") then
        uniform.Helmet.RightLogo.Decal.Texture = "rbxassetid://" .. team.StadiumAssetId
        uniform.Helmet.LeftLogo.Decal.Texture = "rbxassetid://" .. team.StadiumAssetId
    end
end

-- Function to apply changes to all players based on their team
local function ApplyUniformsToAllPlayers(homeTeam)
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        SetPlayerUniform(player, homeTeam)  -- Apply the home team's uniform to all players
    end
end



-- Update stadium and apply uniforms to all players
UpdateStadium(homeTeam.StadiumAssetId)
ApplyUniformsToAllPlayers(homeTeam)
