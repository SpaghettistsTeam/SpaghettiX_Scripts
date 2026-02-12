-- ragebot愤怒的机器人制作教程
-- 你得自己学会抓事件
-- 没有wallbang你自己写
-- 适用于大部分FPS类和近战类
-- 后面你得自己改UI开关 
-- 你想要制作成脚本的形式 就删除开关类的 然后改成循环死亡就掉的
local Players = game:GetService("Players") 
local ReplicatedStore = game:GetService("ReplicatedStorage") 
local RunService = game:GetService("RunService") 
local DebrisService = game:GetService("Debris") 

local LocalPlayer = Players.LocalPlayer -- 获取你自己

-- 远程攻击(自己用dex抓射击事件）
local AttackRemoteA = ReplicatedStore.Remotes.ZombieRelated.PlayerAttack -- 近战攻击事件
local BulletRemote = ReplicatedStore.Remotes.Guns.ReplicateBullet -- 子弹轨迹事件
local DamageRemote = ReplicatedStore.NetworkEvents.RemoteEvent -- 伤害事件事件

-- 频率
local attackIntervalA = 0.3 -- A近战攻击间隔
local attackIntervalB = 0.01 -- B远程攻击间隔

-- 控制
local attackingA = false -- 近战攻击开关
local attackingB = false -- 远程攻击开关
local rotating = false -- 旋转开关

-- 移动属性
local DEFAULT_WALKSPEED = 16 
local DEFAULT_JUMPPOWER = 50 
local currentSpeed = 100 
local currentJump = 100 
local speedEnabled = false 
local jumpEnabled = false 

-- 创建攻击轨迹特效
local function createTrail(origin, targetPos)
	local part = Instance.new("Part") 
	part.Size = Vector3.new(0.2, 0.2, 0.2) -- 尺寸
	part.Anchored = true -- 固定
	part.CanCollide = false -- 无碰撞
	part.Transparency = 1 -- 透明度
	part.CFrame = CFrame.new(origin) -- 设置位置
	part.Parent = workspace 

	local att0 = Instance.new("Attachment", part) -- 起点附着点
	local att1 = Instance.new("Attachment", workspace.Terrain) -- 终点附着点
	att1.WorldPosition = targetPos -- 设置终点位置

	local beam = Instance.new("Beam", part) -- 创建光束
	beam.Attachment0 = att0 
	beam.Attachment1 = att1 
	beam.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255)) -- 颜色光束
	beam.Width0 = 0.3 -- 起点宽度
	beam.Width1 = 0.3 -- 终点宽度
	beam.FaceCamera = true 
	beam.LightEmission = 1 -- 亮度

	DebrisService:AddItem(part, 0.2) -- 显示时间
end

-- 攻击近战玩家
task.spawn(function()
    while true do
        if attackingA and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = LocalPlayer.Character.HumanoidRootPart.Position 
            for _, plr in pairs(Players:GetPlayers()) do 
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then 
                    local dist = (plr.Character.Head.Position - myPos).Magnitude 
                    if dist <= 22 then -- 22米范围内
                        pcall(function() 
                            -- 告诉服务器🥵🥵“我打中了这个入头”
                            AttackRemoteA:InvokeServer(plr.Character.Head)
                        end)
                    end
                end
            end
            task.wait(attackIntervalA) -- 等0.3秒再打
        else
            task.wait(0.1) -- 没开攻击就等0.1秒
        end
    end
end)

-- 远程攻击玩家
task.spawn(function()
	while true do
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart") 
		local hasCrossbow = char and char:FindFirstChild("Crossbow") -- 检查是否手持对应的武器（武器要求）
		if attackingB and hrp and hasCrossbow then 
			local myPos = hrp.Position 
			for _, plr in pairs(Players:GetPlayers()) do 
				if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then 
					local targetHRP = plr.Character.HumanoidRootPart 
					local dist = (targetHRP.Position - myPos).Magnitude 
					if dist <= 100 then -- 100米范围内（过大可能会衰减伤害 除反作弊垃圾的）
						pcall(function() 
							BulletRemote:FireServer({myPos, targetHRP.Position}) -- 发送轨迹
							DamageRemote:FireServer("GUN_DAMAGE", plr.Character) -- 发送伤害
						end)
						createTrail(myPos, targetHRP.Position) -- 显示轨迹特效
						-- 播放射击音效（给自己听）
						local snd = Instance.new("Sound", workspace)
						snd.SoundId = "rbxassetid://9116483270"
						snd.Volume = 1
						snd.PlayOnRemove = true
						snd:Destroy()
						task.wait(attackIntervalB) 
					end
				end
			end
		else
			task.wait(0.01) 
		end
	end
end)

-- 攻击NPC
task.spawn(function()
	while true do
		local char = LocalPlayer.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart") 
		local hasCrossbow = char and char:FindFirstChild("Crossbow") -- 检查是否手持对应的武器（武器要求）
		if attackingB and hrp and hasCrossbow then 
			local myPos = hrp.Position 
			for _, npc in pairs(workspace.LivingThings:GetChildren()) do 
				local targetHRP = npc:FindFirstChild("HumanoidRootPart") 
				if targetHRP then
					local dist = (targetHRP.Position - myPos).Magnitude 
					if dist <= 100 then -- 100米范围内（过大可能会衰减伤害 除反作弊垃圾的）
						pcall(function()
							BulletRemote:FireServer({myPos, targetHRP.Position}) -- 发送轨迹
							DamageRemote:FireServer("GUN_DAMAGE", npc) -- 发送伤害
						end)
						createTrail(myPos, targetHRP.Position) -- 显示轨迹特效
						-- 播放射击音效（给自己听）
						local snd = Instance.new("Sound", workspace)
						snd.SoundId = "rbxassetid://9116483270"
						snd.Volume = 1
						snd.PlayOnRemove = true 
						snd:Destroy() 
						task.wait(attackIntervalB) 
					end
				end
			end
		else
			task.wait(0.01) 
		end
	end
end)

-- 人物旋转功能（攻击时转头 没表要的东西）
local rotateConn 
local function startRotate()
	if rotating then return end 
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end 
	rotating = true 
	rotateConn = RunService.RenderStepped:Connect(function(dt) 
		root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(7200) * dt, 0) -- Y轴旋转
	end)
end

local function stopRotate()
	rotating = false 
	if rotateConn then
		rotateConn:Disconnect() 
		rotateConn = nil
	end
end

-- 移动属性函数
local function updateMovement()
	local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = speedEnabled and currentSpeed or DEFAULT_WALKSPEED
		humanoid.JumpPower = jumpEnabled and currentJump or DEFAULT_JUMPPOWER
	end
end

