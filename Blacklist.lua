local Blacklist = {
    7429154627 --Tips: 请将封禁玩家的ID添加至这里（记得加逗号）
}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if table.find(Blacklist, LocalPlayer.UserId) then
    Localplayer:Kick("您已被SpaghettistsTeam封禁。请加入QQ群 1084580131 解除封禁。（这或许是暂时的）")
end
