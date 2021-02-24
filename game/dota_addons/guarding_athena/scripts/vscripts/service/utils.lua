if not IsServer() then
	return
end
----------------------------------------------------------------------------------------------------
-- 服务器数据工具脚本
----------------------------------------------------------------------------------------------------
local STABLE = _G._STABLE or {}
_G._STABLE = STABLE
function StableRequest(obj, funRequest, ...)
	local k = DoUniqueString('STABLE')
	STABLE[k] = {
		status = false,
		retry = SERVER_RETRY
	}
	local args = { ... }

	local function callback(status)
		if status then
			STABLE[k] = nil
		else
			STABLE[k].retry = STABLE[k].retry - 1
			if STABLE[k].retry > 0 then
				if args then
					funRequest(obj, callback, unpack(args))
				else
					funRequest(obj, callback)
				end
			else
				STABLE[k] = false
			end
		end
	end

	funRequest(obj, callback, ...)
	return k
end
function GetRequestStatus(index)
	if type(STABLE[index]) == 'table' then
		return STABLE[index].status
	end
	if STABLE[index] == nil then
		return true
	end
	return STABLE[index]
end

function CALL(func, ...)
	if func and type(func) == 'function' then
		local args = { ... };
		return func(unpack(args));
	end
end
-- 获取steamid
function GetAccountID(iPlayerID)
	return tonumber(PlayerResource:GetSteamAccountID(iPlayerID))
end
-- 获取玩家名字
function GetPlayerName(iPlayerID)
	if PlayerResource:IsValidPlayer(iPlayerID) then
		return PlayerResource:GetPlayerName(iPlayerID)
	end
	return -1;
end
-- 根据steamid获取playerid
function GetPlayerIDByAccount(steamid)
	for iPlayerID = 0, PlayerResource:GetPlayerCount() - 1, 1 do
		if PlayerResource:IsValidPlayerID(iPlayerID) then
			if tonumber(PlayerResource:GetSteamAccountID(iPlayerID)) == steamid then
				return iPlayerID
			end
		end
	end
	return -1
end
-- 获取比赛id
function GetMatchID()
	if IsInToolsMode() then
		if _MATCH_ID then
			return _MATCH_ID
		end
		local s = ''
		for k, v in pairs(LocalTime()) do
			s = s .. v
		end
		s = s .. RandomInt(1000, 9999)
		_MATCH_ID = tonumber(s)
		return _MATCH_ID
	end
	return tonumber(tostring(GameRules:GetMatchID()))
end

function GetGameTime()
	return math.floor(GameRules:GetGameTime())
end

--- 发送事件到一个玩家
function SendGameEvent2Player(iPlayerID, sEventName, tData)
	local hPlayer = GetPlayer(iPlayerID)
	if hPlayer then
		CustomGameEventManager:Send_ServerToPlayer(hPlayer, sEventName, tData)
	end
end
--- 发送事件到所有玩家
function SendGameEvent2AllPlayer(sEventName, tData)
	CustomGameEventManager:Send_ServerToAllClients(sEventName, tData)
end