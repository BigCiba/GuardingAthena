if player == nil then
	---@class player
	player = {
	}
end

local public = player

function public:Init(bReload)
	Request:Event("query.operate", Dynamic_Wrap(public, "QueryOperate"), public)
end

function public:login(call, iPlayerID)
	Service:POST('player.login',
	{
		SteamID = GetAccountID(iPlayerID),
		Name = GetPlayerName(iPlayerID),
	}, function(data)
		if data and data.status == 0 then
			-- TODO:
		end
		call(data)
	end)
end

---结算
function public:game_over(iPlayerID, bWin)
	local iLoseShard = GameRules:GetCustomGameDifficulty() < 4 and 0 or Spawner.gameRound * (GameRules:GetCustomGameDifficulty() - 2)
	local diff = GameRules:GetCustomGameDifficulty()
	local Score = bWin and SCORE_REWARD[diff] or 0
	local Shard = bWin and SHARD_REWARD[diff] or iLoseShard
	local PetXP = bWin and PETXP_REWARD[diff] or 0
	local sItemName = ""
	if Pet.GetPetByPlayerID(iPlayerID) then
		sItemName = Pet.GetPetByPlayerID(iPlayerID):GetUnitEntityName()
	end
	Service:POST('player.game_over',
	{
		SteamID = GetAccountID(iPlayerID),
		Score = Score,
		Shard = Shard,
		ItemName = sItemName,
		Experience = PetXP
	}, function(data)
		if data and data.status == 0 then
			print("结算成功")
			-- TODO:
		end
		-- call(data)
	end)
end

--[[	UI事件
]]
---请求一个操作
function public:QueryOperate(params)
	local iPlayerID = params.PlayerID
	local router = params.router
	local ItemName = params.ItemName
	local data = Service:POSTSync(router, {
		SteamID = PlayerResource:GetSteamAccountID(iPlayerID),
		ItemName = ItemName
	})
	if data and data.status == 0 then
		if GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			-- 装备
			if router == "particle.equip" then
				local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
				EachEquippedParticles(iPlayerID, function(tItemData)
					-- 清除旧的
					if hHero.ParticleModifier then
						if type(hHero.ParticleModifier) == "number" then
							ParticleManager:DestroyParticle(hHero.ParticleModifier, false)
						else
							hHero.ParticleModifier:Destroy()
						end
					end
					if tItemData.ItemName == "wing_01" then	-- 金色翅膀
						if hHero:GetUnitName() == "npc_dota_hero_nevermore" then
							hHero.ParticleModifier = ParticleManager:CreateParticle("particles/wings/wing_sf_goldsky_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
						else
							hHero.ParticleModifier = ParticleManager:CreateParticle("particles/skills/wing_sky_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, hHero)
						end
					end
					local Asset = GetItemInfo(tItemData.ItemName).Asset
					print("bigciba", Asset)
					if Asset then
						hHero.ParticleModifier = hHero:AddNewModifier(hHero, nil, Asset, nil)
					end
				end)
			end
			if router == "skin.equip" then
				local hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
				if hHero.GetSkinName then
					hHero:RemoveModifierByName("modifier_" .. hHero:GetSkinName())
				end
				hHero:AddNewModifier(hHero, self, "modifier_" .. ItemName, nil)
			end
		end
		return {
			status = data.status
		}
	end
end

--[[	外部接口
]]
---获取装备的信使
function GetEquippedCourier(iPlayerID)
	local tData = CustomNetTables:GetTableValue("service", "player_courier_" .. iPlayerID)
	for i, tItemData in pairs(tData) do
		if tItemData.Equip == "1" then
			return tItemData
		end
	end
end
---遍历所有装备的特效
---@param iPlayerID 玩家ID
---@param callback 回调 
function EachEquippedParticles(iPlayerID, callback)
	local tData = CustomNetTables:GetTableValue("service", "player_particle_" .. iPlayerID)
	for i, tItemData in pairs(tData) do
		if tItemData.Equip == "1" then
			callback(tItemData)
		end
	end
end
---获取某个英雄装备的皮肤
function GetEquippedSkin(iPlayerID, sHeroName)
	local tData = CustomNetTables:GetTableValue("service", "player_skin_" .. iPlayerID)
	for i, tItemData in pairs(tData) do
		if tItemData.Hero == sHeroName and tItemData.Equip == "1" then
			return tItemData
		end
	end
end
---遍历玩家所有Gameplay物品
---@param iPlayerID 玩家ID
---@param callback 回调 
function EachPlayerGameplay(iPlayerID, callback)
	local tData = CustomNetTables:GetTableValue("service", "player_gameplay_" .. iPlayerID)
	for i, tItemData in pairs(tData) do
		callback(tItemData)
	end
end
---遍历玩家所有其他物品
---@param iPlayerID 玩家ID
---@param callback 回调 
function EachPlayerOther(iPlayerID, callback)
	local tData = CustomNetTables:GetTableValue("service", "player_other_" .. iPlayerID)
	for i, tItemData in pairs(tData) do
		callback(tItemData)
	end
end