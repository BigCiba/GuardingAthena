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

require("service/payment")

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

	Recorder:Init(bReload)
	HeroCard:Init(bReload)
	Store:Init(bReload)
	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)
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
	print('Service:UpdateNetTables ===============================')
	DeepPrintTable(self.tGameRequestPool)
	DeepPrintTable(self.tPlayerReqPool)
	DeepPrintTable(self.tGameConnectState)
	DeepPrintTable(self.tPlayerConnectState)
end

function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		for iPlayerID = 0, PlayerResource:GetPlayerCount() - 1, 1 do
			if PlayerResource:IsValidPlayerID(iPlayerID) then
				self:PlayerConnectToServer(iPlayerID)
			end
		end
		self:GameConnectToServer()
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
end
function public:Enter()
	StopGameTimer(self.hTimeOut)
	StopGameTimer(self.hConnect)
	CustomGameEventManager:Send_ServerToAllClients("service_game_enter", { game_connect_state = self.tGameConnectState })
end

function public:GameConnectToServer()
	self.tGameRequestPool = {
		Recorder_StartMatch = StableRequest(Recorder, Recorder.ReqStartMatch),
		HeroCard_ReqCardsDefaultGrowupInfo = StableRequest(HeroCard, HeroCard.ReqCardsDefaultGrowupInfo),
		HeroCard_ReqCardDefaultAttribute = StableRequest(HeroCard, HeroCard.ReqCardDefaultAttribute),
		BP_ReqDefaultInfo = StableRequest(BP, BP.ReqDefaultInfo),
		Store_ReqSellingItem = StableRequest(Store, Store.ReqSellingItem),
	}
end
function public:PlayerConnectToServer(iPlayerID)
	HeroCard:InitPlayerInfo(iPlayerID)
	Recorder:InitPlayerInfo(iPlayerID)
	-- Commander:InitPlayerInfo(iPlayerID)
	self.tPlayerReqPool[iPlayerID] = {
		User_ReqPlayerLogin = StableRequest(User, User.ReqPlayerLogin, iPlayerID),
		User_ReqUserData = StableRequest(User, User.ReqUserData, iPlayerID),
		HeroCard_ReqCards = StableRequest(HeroCard, HeroCard.ReqPlayerCards, iPlayerID),
		HeroCard_ReqCardGroup = StableRequest(HeroCard, HeroCard.ReqCardGroup, iPlayerID),
		Recorder_ReqPlayerJoin = StableRequest(Recorder, Recorder.ReqPlayerJoin, iPlayerID),
		BP_ReqPlayerBPInfo = StableRequest(BP, BP.ReqPlayerBPInfo, iPlayerID),
	-- Commander_GetPlayerInfos = StableRequest(Commander, Commander.GetPlayerInfos, iPlayerID),
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

----------------------------------------------------------------------------------------------------
-- public 公开接口
function public:POST(sMod, sAction, hParams, hFunc, fTimeout)
	local szURL = Address .. "?mod=" .. sMod .. "&action=" .. sAction
	local handle = CreateHTTPRequestScriptVM("POST", szURL)

	-- handle:SetHTTPRequestHeaderValue("Dedicated-Server-Key", ServerKey)
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")

	if hParams ~= nil then
		handle:SetHTTPRequestRawPostBody("application/json", json.encode(hParams))
	end

	handle:SetHTTPRequestAbsoluteTimeoutMS((fTimeout or 5) * 1000)

	handle:Send(function(response)
		hFunc(response.StatusCode, response.Body, response)
	end)
end

function public:POSTSync(sMod, sAction, hParams, fTimeout)
	local co = coroutine.running()
	self:POST(sMod, sAction, hParams, function(iStatusCode, sBody, hResponse)
		coroutine.resume(co, iStatusCode, sBody, hResponse)
	end, fTimeout)
	return coroutine.yield()
end

return public