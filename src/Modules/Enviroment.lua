local Services = {
    Storage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    Players = game:GetService("Players"),
    Tween = game:GetService("TweenService"),
    UserInput = game:GetService("UserInputService")
}

local FusionModule = require(game.ReplicatedStorage.FusionModule)

local homeTeam = FusionModule.NewTeam({
    TeamName = "Dallas Bears",
    City = "Dallas",
    Colors = {
        Helmet = "#1A1A1A",
        Jersey = "#0055FF",
        Pants = "#FFFFFF",
        Stripe = "#FFD700",
        NumberInner = "#FFFFFF",
        NumberStroke = "#000000",
        Field = "#007F0E"
    }
})

local awayTeam = FusionModule.NewTeam({
    TeamName = "New York Knights",
    City = "New York",
    Colors = {
        Helmet = "#0000FF",
        Jersey = "#FF0000",
        Pants = "#000000",
        Stripe = "#FFFFFF",
        NumberInner = "#FFFFFF",
        NumberStroke = "#000000",
        Field = "#007F0E"
    }
})

local function SetJersey(player, teamInfo, pos)
    pcall(function()
        if not player.Character then
            return
        end

        task.spawn(function()
            local uniform = player.Character:WaitForChild("Uniform")
            wait(0.5)

            if not uniform:FindFirstChild("Helmet") then
                return
            end

            local colors = teamInfo.Colors

            uniform.Helmet.Color = Color3.fromHex(colors.Helmet)
            uniform.Helmet.Mesh.TextureId = ""

            if uniform.Helmet:FindFirstChild("RightLogo") then
                local logoPath = "ReplicatedStorage/Teams/" .. teamInfo.City .. " " .. teamInfo.TeamName .. "/Logo.png"
                uniform.Helmet.RightLogo.Decal.Texture = getcustomasset(logoPath, false)
                uniform.Helmet.LeftLogo.Decal.Texture = getcustomasset(logoPath, false)
            end

            uniform.ShoulderPads.Front.Team.Text = string.upper(teamInfo.TeamName)
            uniform.ShoulderPads.Color = Color3.fromHex(colors.Jersey)
            uniform.Shirt.Color = Color3.fromHex(colors.Jersey)
            uniform.LeftShortSleeve.Color = Color3.fromHex(colors.Jersey)
            uniform.RightShortSleeve.Color = Color3.fromHex(colors.Jersey)

            uniform.LeftPants.Color = Color3.fromHex(colors.Pants)
            uniform.RightPants.Color = Color3.fromHex(colors.Pants)

            uniform.LeftGlove.Color = Color3.fromHex(colors.Stripe)
            uniform.LeftShoe.Color = Color3.fromHex(colors.Stripe)
            uniform.LeftSock.Color = Color3.fromHex(colors.Stripe)
            uniform.RightGlove.Color = Color3.fromHex(colors.Stripe)
            uniform.RightShoe.Color = Color3.fromHex(colors.Stripe)
            uniform.RightSock.Color = Color3.fromHex(colors.Stripe)
        end)
    end)
end

-- Update stadium theme based on the team colors
local function UpdateStadiumTheme(teamInfo)
    local stadium = Services.Workspace:WaitForChild("Models"):WaitForChild("Stadium")
    if not stadium then return end

    local colors = teamInfo.Colors

    if stadium:FindFirstChild("Field") then
        stadium.Field.Color = Color3.fromHex(colors.Field or colors.Jersey)
    end

    if stadium:FindFirstChild("Seats") then
        for _, seat in pairs(stadium.Seats:GetDescendants()) do
            if seat:IsA("BasePart") then
                seat.Color = Color3.fromHex(colors.Jersey)
            end
        end
    end

    if stadium:FindFirstChild("Walls") then
        for _, wall in pairs(stadium.Walls:GetDescendants()) do
            if wall:IsA("BasePart") then
                wall.Color = Color3.fromHex(colors.Helmet)
            end
        end
    end
end

-- Automatically apply jerseys and stadium on load
Services.Players.LocalPlayer.CharacterAdded:Connect(function(player)
    -- Apply Home Team Jersey
    if homeTeam then
        SetJersey(player, homeTeam, "Home")
    end

    -- Apply Away Team Jersey
    if awayTeam then
        SetJersey(player, awayTeam, "Away")
    end
end)

-- Update stadium themes to match teams (Only run on the client)
if homeTeam then
    UpdateStadiumTheme(homeTeam)
end

if awayTeam then
    UpdateStadiumTheme(awayTeam)
end
