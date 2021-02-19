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
	Service:POST('player.game_over',
	{
		SteamID = GetAccountID(iPlayerID),
		Score = Score,
		Shard = Shard,
		ItemName = Pet.GetPetByPlayerID(iPlayerID):GetUnitEntityName(),
		Experience = PetXP
	}, function(data)
		if data and data.status == 0 then
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
	if data then
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