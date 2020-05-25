if PlayerData== nil then
	PlayerData = class({})
end
local public = PlayerData

function public:init(bReload)
	if not bReload then
		self.playerDatas = {}
	end

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)

	self:UpdateNetTables()
end

function public:UpdateNetTables()
	CustomNetTables:SetTableValue("player_data", "player_datas", self.playerDatas)
end
-- 获得戒指
function public:AddRing(iPlayerID, hItem)
	if #self.playerDatas[iPlayerID].rings < 2 then
		table.insert(self.playerDatas[iPlayerID].rings, {
			sName = hItem:GetAbilityName(),
			iRingIndex = string.sub(hItem:GetAbilityName(),-1),
			sModifierName = "ring_0_"..string.sub(hItem:GetAbilityName(),-1),
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
		iRingIndex = string.sub(hItem:GetAbilityName(),-1),
		sModifierName = "ring_0_"..string.sub(hItem:GetAbilityName(),-1),
		iStartTime = hItem:GetSpecialValueFor("time_start"),
		iEndTime = hItem:GetSpecialValueFor("time_end")
	})
end
-- 获取戒指信息
function public:GetRingData(iPlayerID)
	return self.playerDatas[iPlayerID].rings
end

--[[
	监听
]]--
function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_PRE_GAME then
		-- 初始化玩家数据
		GuardingAthena:EachPlayer(function(n, iPlayerID)
			self.playerDatas[iPlayerID] = {
				rings = {}	-- 戒指
			}
		end)
	end
end

return public