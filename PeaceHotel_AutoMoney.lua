--Developed by SpaghettistsTeam
local RunService = game:GetService("RunService")
local MainFolder = workspace:WaitForChild("PeaceHotel")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local WorkPrompt = nil

getgenv().SendRate = 3 --刷钱倍率

local function FindPrompt ()
	for _, prompt in ipairs(MainFolder:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") and prompt.ActionText == "工作" then
			WorkPrompt = prompt or workspace.PeaceHotel:GetChildren()[40]:GetChildren()[4].ProximityPrompt
		end
	end
end

FindPrompt()

LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-393, 124, 629)

for  i = 1, getgenv().SendRate do
	RunService.Heartbeat:Connect(function(deltaTime)
		if WorkPrompt then
			fireproximityprompt(WorkPrompt)
		else
			warn("WorkPrompt Not Found")
			FindPrompt()
		end
	end)
end
