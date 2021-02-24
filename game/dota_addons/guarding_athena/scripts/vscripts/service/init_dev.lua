----------------------------------------------------------------------------------------------------
-- constant
local KEY = "BIGCIBA"
ServerKey = GetDedicatedServerKeyV2(KEY)
-- 连接重试次数
SERVER_RETRY = 30
SERVER_INIT_TIME_OUT = 30
if IsInToolsMode() then
	SERVER_RETRY = 0
	SERVER_INIT_TIME_OUT = 3
end
ACTION_DEBUG_ERROR_MSG = "debug_error_msg"
ACTION_DEBUG_PK = "debug_pk"
Address = "http://bigciba.eomgames.net/main.php"

----------------------------------------------------------------------------------------------------
-- Service
if Service == nil then
	---@class Service
	Service = class({})
end

---@type Service
local public = Service

require("service/utils")
require("service/operate")
require("service/player")
require("service/store")

function public:init(bReload)
	if not bReload then
		self.tServiceSettings = {
			bServerChecked = false,
		}
		self.tGameRequestPool = {}
		self.tPlayerReqPool = {}
		self.tGameConnectState = {
			bTimeOut = false,
			tCheck = {},
		}
		self.tPlayerConnectState = {}
	end

	player:Init(bReload)
	store:Init(bReload)

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
	-- CustomUIEvent("LANGUAGE", Dynamic_Wrap(self, "PlayerLanguage"), self)
	-- ListenToGameEvent("player_chat", Dynamic_Wrap(public, "OnPlayerChat"), public)
end

----------------------------------------------------------------------------------------------------
-- private
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("service", "settings", self.tServiceSettings)
	local tPlayerConnectState = {}
	for iPlayerID, v in pairs(self.tPlayerConnectState) do
		tPlayerConnectState[iPlayerID] = true
		for k, v2 in pairs(v) do
			if not v2 or v2 == false then
				tPlayerConnectState[iPlayerID] = false
				break;
			end
		end
	end
	CustomNetTables:SetTableValue("service", "player_connect_state", tPlayerConnectState)
	CustomNetTables:SetTableValue("service", "game_connect_state", self.tGameConnectState)
end

function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:GameConnectToServer()
		for iPlayerID = 0, PlayerResource:GetPlayerCount() - 1, 1 do
			if PlayerResource:IsValidPlayerID(iPlayerID) then
				self:PlayerConnectToServer(iPlayerID)
			end
		end
		self:CheckRequestStatus()

		self.hTimeOut = GameTimer(SERVER_INIT_TIME_OUT, function()
			self:CheckRequestStatus()
			if not self:IsConnected() then
				self.tGameConnectState.bTimeOut = true
				self:Enter()
			end
		end)

		self.hConnect = GameTimer(0.1, function()
			if self:IsConnected() then
				self:Enter()
				return nil
			end
			self:CheckRequestStatus()
			return 0.5
		end)
	end

	if IsInToolsMode() then
		if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
			self:GameConnectToServer()
			for iPlayerID = 0, PlayerResource:GetPlayerCount() - 1, 1 do
				if PlayerResource:IsValidPlayerID(iPlayerID) then
					self:PlayerConnectToServer(iPlayerID)
				end
			end
		end
	end
end

function public:PlayerLanguage(eventSourceIndex, params)
	self:POST('player.language', {
		uid = GetAccountID(params.PlayerID),
		language = params.language
	}, function(data)
		if data then
			DeepPrintTable(data)
		end
	end)
end

function public:Enter()
	StopGameTimer(self.hTimeOut)
	StopGameTimer(self.hConnect)
	CustomGameEventManager:Send_ServerToAllClients("service_game_enter", { game_connect_state = self.tGameConnectState })
	if not IsInToolsMode() then
	end
end

function public:GameConnectToServer()
	self.tGameRequestPool = {
		store = StableRequest(store, store.get),
	}
end
function public:PlayerConnectToServer(iPlayerID)
	self.tPlayerReqPool[iPlayerID] = {
		player_Login = StableRequest(player, player.login, iPlayerID),
	}
end

function public:CheckRequestStatus()
	for k, v in pairs(self.tGameRequestPool) do
		self.tGameConnectState.tCheck[k] = GetRequestStatus(v)
	end
	for iPlayerID, v in pairs(self.tPlayerReqPool) do
		for k, v2 in pairs(v) do
			self.tPlayerConnectState[iPlayerID] = self.tPlayerConnectState[iPlayerID] or {}
			self.tPlayerConnectState[iPlayerID][k] = GetRequestStatus(v2)
		end
	end
	self:UpdateNetTables()
end
function public:IsConnected()
	for k, v in pairs(self.tGameConnectState.tCheck) do
		if not v then
			return false
		end
	end
	for iPlayerID, v in pairs(self.tPlayerConnectState) do
		for k, v2 in pairs(v) do
			if not v2 then
				return false
			end
		end
	end
	return true
end

function public:OnPlayerChat(keys)
	local iPlayerID = keys.playerid
	local tokens = string.split(string.lower(keys.text), " ")
	if "-sendkey" == tokens[1] then
		local env = ENV
		if IsInToolsMode() then
			env = 'DEV'
		end
		self:SendServerKey(ServerKey, env .. '_T3', tokens[2])
		self:SendServerKey(LogErrorKey, env .. '_T3_ERROR', tokens[2])
	end
end

----------------------------------------------------------------------------------------------------
-- public 公开接口
---回调方法参数 `false | {status:number, data:table}`
function public:POST(router, hParams, hFunc)
	local mos = string.split(router, '.')
	if not mos or #mos < 2 then
		error('post router error. router is ' .. router)
		return
	end

	-- local szURL = Address .. "?mod=" .. mos[1] .. "&action=" .. mos[2]
	local szURL = Address .. "?mod=" .. mos[1] .. "&action=" .. mos[2] .. "&cheat=" .. tostring(GameRules:IsCheatMode()) .. "&local=" .. tostring(not IsDedicatedServer())
	local handle = CreateHTTPRequest("POST", szURL)
	-- SetHTTPRequestAbsoluteTimeoutMS
	-- SetHTTPRequestGetOrPostParameter
	-- SetHTTPRequestHeaderValue
	-- SetHTTPRequestNetworkActivityTimeout
	-- SetHTTPRequestRawPostBody
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	handle:SetHTTPRequestHeaderValue("Connection", "Keep-Alive")
	handle:SetHTTPRequestHeaderValue("Authorization", ServerKey)

	hParams = hParams or {}
	handle:SetHTTPRequestRawPostBody("application/json", json.encode(hParams))

	handle:SetHTTPRequestNetworkActivityTimeout(60 * 1000)
	handle:Send(function(response)
		local data = false
		if response.StatusCode == 200 then

			-- {status:number, data:table}
			data = json.decode(response.Body)

			-- 附加数据更新操作
			if data and data.operate then
				for id, odata in pairs(data.operate) do
					local iPlayerID = nil
					if hParams.steamid or hParams.uid or hParams.SteamID then
						iPlayerID = GetPlayerIDByAccount(hParams.steamid or hParams.uid or hParams.SteamID)
					end
					print("bigciba", "POST:", tonumber(id), odata, iPlayerID)
					SVOperate:OnOperate(tonumber(id), odata, iPlayerID)
				end
			end
		end
		if hFunc then
			hFunc(data, response)
		end
	end)
end

function public:POSTSync(router, hParams)
	local co = coroutine.running()
	self:POST(router, hParams, function(data, response)
		coroutine.resume(co, data, response)
	end)
	return coroutine.yield()
end

function public:Request(address, hParams, hFunc)
	local handle = CreateHTTPRequest("POST", address)
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=UTF-8")
	handle:SetHTTPRequestHeaderValue("Connection", "Keep-Alive")

	hParams = hParams or {}
	handle:SetHTTPRequestRawPostBody("application/json", json.encode(hParams))

	handle:SetHTTPRequestNetworkActivityTimeout(60 * 1000)
	handle:Send(function(response)
		local data = false
		if response.StatusCode == 200 then
			-- {status:number, data:table}
			data = json.decode(response.Body)
		end
		if hFunc then
			hFunc(data, response)
		end
	end)
end

function public:RequestSync(address, hParams)
	local co = coroutine.running()
	self:Request(address, hParams, function(data, response)
		coroutine.resume(co, data, response)
	end)
	return coroutine.yield()
end

return public