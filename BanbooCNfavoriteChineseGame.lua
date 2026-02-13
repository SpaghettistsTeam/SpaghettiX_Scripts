--Developed by SpaghettistsTeam
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local OreFolder = workspace:WaitForChild("Ore")

local function TelePort (pos)
    if not pos then return end

    LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(pos)
end

local function AutoMining ()
    for _, ore in ipairs(OreFolder:GetChildren()) do
        if not getgenv().AutoMiningEnabled then break end

        local Cube = ore:WaitForChild("Cube")
        local ClickDetector = Cube and Cube:FindFirstChildOfClass("ClickDetector")
        local orePosition = Cube.Position
        local StatusText = Cube:WaitForChild("OreStatus"):WaitForChild("StatusText")

        if string.find(StatusText.Text, "^矿物已被") then continue end

        TelePort(orePosition)

        fireclickdetector(ClickDetector, 10)

        task.wait(getgenv().MiningRate or .5)
    end
end

while getgenv().AutoMiningEnabled do
    AutoMining()
    task.wait(.1)
end
