--请在注入器中输入 setclipboard(game:GetService("RbxAnalyticsService"):GetClientId()) 来获取自己的hwid(hwid将会复制到你的剪贴板上)
local Whitelist = {
    "f32b9bce-b107-4619-90cc-123611964ee21"--Tips: 请将白名单玩家的hwid添加至这里（记得加逗号）
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local RunService = game:GetService("RunService")

local HWID = RbxAnalyticsService:GetClientId()

if not table.find(Whitelist, HWID) then
    LocalPlayer:Kick("您未被加入白名单 请加入QQ群 1084580131 获取白名单名次。")

    for i = 1, 40 do
        RunService.Heartbeat:Connect(function(deltaTime)
            local part = Instance.new("Part")
            part.Position = Vector3.new(0, 0, 0)
            part.Parent = workspace

            local num =  nil
            print(num.Name)
        end)
    end
end

print("白名单验证已通过. 已验证用户: " .. LocalPlayer.Name, " HWID: " .. HWID)
