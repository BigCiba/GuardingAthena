if Spawner== nil then
	Spawner = class({})
end
local public = Spawner

function public:init(bReload)
	if not bReload then
		self.tRoundInfo = LoadKeyValues("scripts/kv/spawn_info.kv")	-- 进攻怪信息
		self.iDifficulty = GameRules:GetCustomGameDifficulty()
		self.iRoundInterval = 120
	end
	-- 刷怪点
	self.tSpawnerLoc = {
		Entities:FindByName(nil, "shuaguai_1"):GetAbsOrigin(),
		Entities:FindByName(nil, "shuaguai_2"):GetAbsOrigin(),
		Entities:FindByName(nil, "shuaguai_3"):GetAbsOrigin(),
		Entities:FindByName(nil, "shuaguai_4"):GetAbsOrigin()
	}
	-- 进攻点
	self.vBaseLoc = Entities:FindByName(nil, "athena"):GetAbsOrigin()
	self.tCreepMissing = {}	-- 进攻怪
	self.iRound = 1	--当前回合

	GameEvent("entity_killed", Dynamic_Wrap(public, "OnUnitKilled"), public)
	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
end

function public:GetRound()
	return self.iRound
end
function public:GetBaseLocation()
	return self.vBaseLoc
end

-- 开始回合
function public:StartRoundTimer()
	local tRoundData = self:GetRoundData(self.iRound)
	if tRoundData ~= nil then
		self:SummonRound(self.iRound)
		self.iRound = self.iRound + 1
		GameRules:GetGameModeEntity():GameTimer(self.iRoundInterval, function()
			self:StartRoundTimer()
		end)
	end
end

-- 获取回合信息
---@param iRound int | nil 不传为当前波信息
function public:GetRoundData(iRound)
	if iRound == nil then
		iRound = self.iRound
	end
	return self.tRoundInfo["Round"..iRound]
end

-- 刷一波怪
function public:SummonRound(iRound, iCount)
	local tRoundData = self:GetRoundData(iRound)
	local flInterval = tRoundData.Interval or 0	--每个怪的出生间隔
	iCount = (iCount or 0) + 1
	if flInterval == 0 then
		for _, vLocation in ipairs(self.tSpawnerLoc) do
			local hUnit = CreateUnitByName(tRoundData.UnitName, vLocation, true, nil, nil, DOTA_TEAM_BADGUYS)
			hUnit:AddNewModifier(hUnit, nil, "modifier_round", nil)
			table.insert(self.tCreepMissing, hUnit)
		end
	end
	if iCount < tRoundData.UnitCount then
		GameRules:GetGameModeEntity():GameTimer(tRoundData.Interval or 0, function()
			self:SummonRound(iRound, iCount)
		end)
	end
end

---
---监听事件
---
function public:OnGameRulesStateChange(t)
	-- game_event_name	game_rules_state_change
	-- game_event_listener	1468006405
	local iGameState = GameRules:State_Get()
	-- start
	if iGameState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:StartRoundTimer()
	end
end
function public:OnUnitKilled(t)
	local hVictim = EntIndexToHScript(t.entindex_killed)
	local hAttacker = EntIndexToHScript(t.entindex_attacker)
	
	ArrayRemove(self.tCreepMissing, hVictim)
end

-- 测试用
if IsInToolsMode() then
	
end

return public