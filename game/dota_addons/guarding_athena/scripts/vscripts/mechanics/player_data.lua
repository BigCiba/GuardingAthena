if PlayerData == nil then
	PlayerData = class({})
end
local public = PlayerData

function public:init(bReload)
	if not bReload then
		self.playerDatas = {}
	end

	GameEvent("entity_killed", Dynamic_Wrap(public, "OnUnitKilled"), public)
	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)

	CustomUIEvent("select_diff", Dynamic_Wrap(public, "OnPlayerSelectDiff"), public)
	self:UpdateNetTables()
end

function public:UpdateNetTables()
	CustomNetTables:SetTableValue("player_data", "player_datas", self.playerDatas)
end

-- 增加金钱
function public:AddGold(iPlayerID, iCount)
	self.playerDatas[iPlayerID].gold = self.playerDatas[iPlayerID].gold + (iCount or 1)
end
-- 设置金钱
function public:SetGold(iPlayerID, iCount)
	self.playerDatas[iPlayerID].gold = iCount
end
-- 获取金钱
function public:GetGold(iPlayerID)
	return self.playerDatas[iPlayerID].gold
end
-- 设置信使
function public:SetCourier(iPlayerID, hCourier)
	self.playerDatas[iPlayerID].courier = hCourier
end
-- 获取宠物
function public:GetCourier(iPlayerID)
	return self.playerDatas[iPlayerID].courier
end
-- 增加击杀数量
function public:AddKills(iPlayerID, sType, iCount)
	self.playerDatas[iPlayerID].killed[sType] = self.playerDatas[iPlayerID].killed[sType] + (iCount or 1)
end
-- 设置击杀数量
function public:SetKills(iPlayerID, sType, iCount)
	self.playerDatas[iPlayerID].killed[sType] = iCount
end
-- 获取击杀数量
---@param iPlayerID int 玩家ID
---@param sType string | nil 击杀类型{"round", "practice"}或者总表
function public:GetKills(iPlayerID, sType)
	if sType == nil then
		return self.playerDatas[iPlayerID].killed
	end
	return self.playerDatas[iPlayerID].killed[sType]
end

-- 获得戒指
function public:AddRing(iPlayerID, hItem)
	if #self.playerDatas[iPlayerID].rings < 2 then
		table.insert(self.playerDatas[iPlayerID].rings, {
			sName = hItem:GetAbilityName(),
			iRingIndex = string.sub(hItem:GetAbilityName(), -1),
			sModifierName = "ring_0_" .. string.sub(hItem:GetAbilityName(), -1),
			iStartTime = hItem:GetSpecialValueFor("time_start"),
			iEndTime = hItem:GetSpecialValueFor("time_end")
		})
	else
		self:SwapRing(iPlayerID, self.playerDatas[iPlayerID].rings[1].sName, hItem)
	end
	self:UpdateNetTables()
end
-- 更换戒指
function public:SwapRing(iPlayerID, sItemName, hItem)
	for i, tData in ipairs(self.playerDatas[iPlayerID].rings) do
		if tData.sName == sItemName then
			table.remove(self.playerDatas[iPlayerID].rings, i)
			break
		end
	end
	table.insert(self.playerDatas[iPlayerID].rings, {
		sName = hItem:GetAbilityName(),
		iRingIndex = string.sub(hItem:GetAbilityName(), -1),
		sModifierName = "ring_0_" .. string.sub(hItem:GetAbilityName(), -1),
		iStartTime = hItem:GetSpecialValueFor("time_start"),
		iEndTime = hItem:GetSpecialValueFor("time_end")
	})
end
-- 获取戒指信息
function public:GetRingData(iPlayerID)
	return self.playerDatas[iPlayerID].rings
end

--[[	监听
]]
--
function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		-- 初始化英雄选择数据
		GuardingAthena:EachPlayer(function(n, iPlayerID)
			self.playerDatas[iPlayerID] = {
				select_hero = "npc_dota_hero_omniknight", -- 选择英雄
				select_diff = "GameMode_Common", -- 选择的难度
			}
		end)
		self:UpdateNetTables()
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		-- 初始化玩家数据
		GuardingAthena:EachPlayer(function(n, iPlayerID)
			self.playerDatas[iPlayerID] = {
				rings = {}, -- 戒指
				killed = {
					round = 0, -- 防守数量
					practice = 0, -- 练功房击杀数量
				},
				point = {
					round = 0, -- 防守积分
					boss = 0, -- boss积分
					practice = 0	--练功房积分
				},
				courier = nil, -- 信使
				gold = 0, --金钱总量
				damage_record = {
					round = { 0 },
					boss = { 0 },
				}
			}
		end)
	end
end

function public:OnUnitKilled(t)
	local hVictim = EntIndexToHScript(t.entindex_killed)
	local hAttacker = EntIndexToHScript(t.entindex_attacker)

	if hVictim:IsRoundCreep() then
		local iPlayerID = hAttacker:GetSource():GetPlayerID()
		if IsValidPlayerID(iPlayerID) then
			-- 记录进攻怪击杀数量
			self:AddKills(iPlayerID, "round")
			-- 记录进攻怪积分
			---TODO
		end
	end
end

--------------------------------
---UI事件
--------------------------------
function public:OnPlayerSelectDiff(eventSourceIndex, events)
	local iPlayerID = events.PlayerID
	self.playerDatas[iPlayerID].select_diff = events.diff
	self:UpdateNetTables()
end

return public