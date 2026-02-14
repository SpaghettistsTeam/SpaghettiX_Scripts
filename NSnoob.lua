--Developed by SpaghettistsTeam
local runservice = game:GetService("RunService")
for i = 1, getgenv().AttackRate do

    runservice.Heartbeat:Connect(function()
        game:GetService("ReplicatedStorage"):WaitForChild("Event"):FireServer("ClickedApple")
        game:GetService("ReplicatedStorage"):WaitForChild("Event"):FireServer("ClickedBalloon")
    end)
end
