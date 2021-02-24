if Service == nil then
	Service = class({})
end
local public = Service

require("service/payment")

--[[	一些需要用到的特殊函数
]]
--
function Sleep(fTime, szUnique)
	local co = coroutine.running()
	GameRules:GetGameModeEntity():Timer(fTime, function()
		coroutine.resume(co)
	end)
	coroutine.yield()
end

KEY = "BIGCIBA"
Address = "http://bigciba.applinzi.com/dota2api/Inventory.php"
ServerKey = GetDedicatedServerKeyV2(KEY)
REQUEST_TIME_OUT = 30 -- 默认请求超时时长（秒）

--debug用
--不用、活动下架后的接口记得注释或者删除以免出问题
-- 所有接口都要用server_key
-- 玩家
ACTION_QUERY_PLAYER_DATA = "query_player_data"					-- 获取玩家数据
ACTION_CHANGE_HERO_SKIN = "change_hero_skin"					-- 改变皮肤
ACTION_UPDATE_HIGHEST_LEVEL = "update_highest_level"			-- 更新最高难度等级
ACTION_SUBMIT_LETTER = "submit_letter"							-- 玩家提交反馈
ACTION_DAILY_REWARD = "update_daily_reward"						-- 每日奖励
ACTION_SET_LANGUAGE = "set_player_language"						-- 记录玩家的客户端语言
-- 支付
ACTION_REQUEST_QRCODE = "request_qrcode"						-- 请求支付二维码
ACTION_QUERY_ORDER_STATUS = "query_order_status"				-- 支付信息
ACTION_REQUERY_ORDER_STATUS = "requery_order_status"			-- 请求补单
-- 商店、物品
ACTION_QUERY_GOODS = "query_goods"								-- 获取商品
ACTION_QUERY_ALL_ITEMS = "query_all_items"						-- 获取所有物品
ACTION_BUY = "buy"												-- 购买物品
ACTION_BUY_USE_STAR = "buy_use_star"							-- 用星石购买物品
ACTION_BUY_USE_STAR_TICKET = "buy_use_star_and_ticket"			-- 用星石购买，不足的用月石补足
ACTION_USE_ITEM = "use_item"									-- 使用物品
ACTION_OPEN_RED_BAG = "open_red_bag"							-- 开启红包
ACTION_OPEN_FRIEND_EGG = "open_friend_egg"						-- 开启友谊蛋
-- battlepass
ACTION_QUERY_BATTLEPASS_INFO = "query_battlepass_info"			-- 查询战斗通行证
ACTION_COLLECT_REWARD = "collect_reward"						-- 获取赛季本子奖励
ACTION_ADD_EXPERIENCE = "add_experience"						-- 增加battlepass经验
ACTION_QUERY_TASK_INFO = "query_task_info"						-- 获取任务信息
ACTION_UPDATE_TASK_INFO = "update_task_info"					-- 更新任务信息
ACTION_GET_TASK_REWARD = "get_task_reward"						-- 获取任务奖励
ACTION_REPLACE_TASK = "replace_task"							-- 替换任务
-- 天梯排行、最佳记录
ACTION_QUERY_BEST_RECORD = "query_player_best_record"			-- 请求玩家的最高纪录
ACTION_UPDATE_RECORD_RANK = "update_player_record_rank"			-- 更新玩家的天梯分和记录
ACTION_GET_SCORE_RANK = "get_score_rank"						-- 获取天梯排行榜
ACTION_GET_RANK_REWARD = "get_rank_reward"						-- 获取上赛季结算奖励
-- 肉山竞速
ACTION_GET_ROUSHAN_RANK = "get_roushan_rank"					-- 获取肉山记录
ACTION_ADD_ROUSHAN_RANK = "add_roushan_rank"					-- 肉山记录
-- ACTION_ADD_RANK = "add_rank"									-- 添加排行(旧版无用)
-- 信使
ACTION_GET_COURIER_DRAW_LIST = "get_courier_draw_list"			-- 获取随机信使列表
ACTION_GET_COURIER_COMBINE_LIST = "get_courier_combine_list"	-- 获取信使合成列表
ACTION_DRAW_COURIER = "draw_courier"							-- 抽取信使
ACTION_COMBINE_COURIER = "combine_courier"						-- 合成信使	
-- 邮件
ACTION_GET_ALL_MAIL = 'get_all_mails'							-- 获取所有邮件
ACTION_READ_MAIL = 'read_mail'									-- 将邮件标为已读
ACTION_GET_MAIL_ENCLOSURE = 'get_mail_enclosure'				-- 获取邮件附件
ACTION_DELETE_MAIL = 'delete_mail'								-- 删除邮件
-- 无法分类
ACTION_GET_NOTICE_URL = "get_notice_url"						-- 请求公告板url
ACTION_USE_CDKEY = "use_cdkey"									-- 兑换CDKEY
-- 红包
ACTION_QUERY_RED_BAG_INFO = "query_red_bag_info"				-- 请求红包信息
ACTION_GET_GUIDER_REWARD = "get_guider_reward"				-- 获取带新人奖励
-- ACTION_GET_NEW_PLAYER_BAG = "get_new_player_bag"				-- 获取新人/回归玩家红包
-- ACTION_GET_ROSHAN_BAG = "get_roshan_bag"						-- 获取通关红包
--似乎已经无用了
-- ACTION_GET_RANK = "get_rank"									-- 获取排行
-- ACTION_GET_PLAYERS_RECORD_INFO = "get_players_record_info"	-- 获取玩家记录信息
function public:init(bReload)
	if not bReload then
		self.tPlayerServiceData = {}
		self.tInventoryData = {}
		self.tStoreItemData = {}
		-- self.tPlayerAllItems = {}
	end

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)

	CustomUIEvent("ToggleItemEquipState", Dynamic_Wrap(public, "OnToggleItemEquipState"), public)
	CustomUIEvent("PurchaseItem", Dynamic_Wrap(public, "OnPurchaseItem"), public)
	CustomUIEvent("RequestPay", Dynamic_Wrap(public, "OnRequestPay"), public)
	CustomUIEvent("RefreshPlayerData", Dynamic_Wrap(public, "OnRefreshPlayerData"), public)

	if IsInToolsMode() then
		-- CustomUIEvent("DebugRefreshData", Dynamic_Wrap(public, "DebugRefreshData"), public)
	end

	-- Request:Event("get_recharge_url", Dynamic_Wrap(public, "OnGetRechargeUrl"), public)
end

--[[	监听事件
]]
--
function public:OnGameRulesStateChange()
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:RefreshAllData()
	elseif state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		GameRules:GetGameModeEntity():Timer(30, function()
			self.bServerChecked = true

			self:UpdateNetTables()
		end)
	end
end

function public:RefreshAllData()
	local state = GameRules:State_Get()

	for iPlayerID = 0, PlayerResource:GetPlayerCount() - 1, 1 do
		if PlayerResource:IsValidPlayerID(iPlayerID) then
			self:RequestPlayerData(iPlayerID)
		end
	end

	self:RequestStoreItem()

	self:UpdateNetTables()
end

function public:DebugRefreshData()
	self:RefreshAllData()
end

function public:RequestStoreItem()
	self:HTTPRequest("POST", "GetStoreItem", {}, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = json.decode(sBody)
			-- print("RequestStoreItem:")
			-- DeepPrintTable(hBody)
			for i, v in ipairs(hBody) do
				table.insert(self.tStoreItemData, v)
			end
			self:UpdateNetTables()
		end
	end, REQUEST_TIME_OUT)
end
function public:RequestMoneyCome(iPlayerID, price, istype)
	local SteamID = tostring(PlayerResource:GetSteamAccountID(iPlayerID))
	local params = {
		SteamID = SteamID,
		price = price,
		istype = istype,
	}
	self:HTTPRequest("POST", "GetQrcode", params, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = json.decode(sBody)
			print("RequestMoneyCome:")
			DeepPrintTable(hBody)
			self:UpdateNetTables()
		end
	end, REQUEST_TIME_OUT)
end
-- 请求玩家数据
function public:RequestPlayerData(iPlayerID)
	if self.tPlayerServiceData[iPlayerID] == nil then
		self.tPlayerServiceData[iPlayerID] = {
			pet = {},
			skin = {},
			particle = {},
		}
	end
	local Steamid = tostring(PlayerResource:GetSteamAccountID(iPlayerID))
	local Address = "http://bigciba.applinzi.com/dota2api/GetPlayerData.php"
	local handle = CreateHTTPRequestScriptVM("POST", Address)
	handle:SetHTTPRequestGetOrPostParameter("SteamID", Steamid)
	handle:SetHTTPRequestGetOrPostParameter("ServerKey", ServerKey)
	handle:SetHTTPRequestAbsoluteTimeoutMS(REQUEST_TIME_OUT * 1000)
	handle:Send(function(response)
		if response.StatusCode == 200 then
			local hBody = json.decode(response.Body)
			print("RequestPlayerData:")
			DeepPrintTable(hBody)
			if hBody ~= nil then
				self.tInventoryData[iPlayerID] = hBody.inventory
				-- 是否有装备
				local tEquipped = { pet = false, skin = false, particle = false }
				for i, v in ipairs(hBody.inventory) do
					if self.tPlayerServiceData[iPlayerID][v.Type] == nil then
						self.tPlayerServiceData[iPlayerID][v.Type] = {}
						tEquipped[v.Type] = false
					end
					-- 对皮肤进行英雄分类
					if v.Type == "skin" then
						local sHeroName = KeyValues.PlayerItemsKV[v.ItemName].Hero
						if self.tPlayerServiceData[iPlayerID][v.Type][sHeroName] == nil then
							self.tPlayerServiceData[iPlayerID][v.Type][sHeroName] = {}
							tEquipped[sHeroName] = false
						end
						table.insert(self.tPlayerServiceData[iPlayerID][v.Type][sHeroName], {
							ItemName = v.ItemName,
							Equip = v.Equip,
							Expiration = v.Expiration,
							Type = v.Type,
							Experience = v.Experience
						})
						if tEquipped[sHeroName] == false and v.Equip == "1" then
							tEquipped[sHeroName] = true
						end
					else
						table.insert(self.tPlayerServiceData[iPlayerID][v.Type], {
							ItemName = v.ItemName,
							Equip = v.Equip,
							Expiration = v.Expiration,
							Type = v.Type,
							Experience = v.Experience
						})
						if tEquipped[v.Type] == false and v.Equip == "1" then
							tEquipped[v.Type] = true
						end
					end
				end
				-- DeepPrintTable(tEquipped)
				-- 添加默认物品
				for sHeroName, tSkinList in pairs(self.tPlayerServiceData[iPlayerID]["skin"]) do
					table.insert(self.tPlayerServiceData[iPlayerID]["skin"][sHeroName], { ItemName = "default_no_item", Equip = tEquipped[sHeroName] and "0" or "1", Expiration = "9999-12-31", Type = "skin" })
				end
				if #self.tPlayerServiceData[iPlayerID]["pet"] == 0 then
					table.insert(self.tPlayerServiceData[iPlayerID]["pet"], { ItemName = "pet_1", Equip = "1", Expiration = "9999-12-31", Type = "pet" })
					tEquipped.pet = true
				end
				table.insert(self.tPlayerServiceData[iPlayerID]["pet"], { ItemName = "default_no_item", Equip = tEquipped.pet and "0" or "1", Expiration = "9999-12-31", Type = "pet" })
				table.insert(self.tPlayerServiceData[iPlayerID]["particle"], { ItemName = "default_no_item", Equip = tEquipped.particle and "0" or "1", Expiration = "9999-12-31", Type = "particle" })
				-- 分数等级金钱
				self.tPlayerServiceData[iPlayerID].Score = hBody.player_data.Score
				self.tPlayerServiceData[iPlayerID].Level = GuardingAthena:GetPlayerLevel(hBody.player_data.Score)
				self.tPlayerServiceData[iPlayerID].Shard = hBody.player_data.Shard
				self.tPlayerServiceData[iPlayerID].Price = hBody.player_data.Price
				self.tPlayerServiceData[iPlayerID].Hero = ""
				-- DeepPrintTable(self.tPlayerServiceData)
				self:UpdateNetTables()
			end
		end
	end)
end
-- 更新玩家装备状态
function public:RequestUpDataEquip(iPlayerID)
	local Steamid = tostring(PlayerResource:GetSteamAccountID(iPlayerID))
	local ItemList = {}
	-- DeepPrintTable(self.tPlayerServiceData[iPlayerID])
	for sType, tItemList in pairs(self.tPlayerServiceData[iPlayerID]) do
		if sType ~= "skin" and type(tItemList) == "table" then
			for _, tItemData in ipairs(tItemList) do
				if tItemData.ItemName ~= "default_no_item" then
					table.insert(ItemList, { ItemName = tItemData.ItemName, Equip = tItemData.Equip })
				end
			end
		end
	end
	for sHeroName, tItemList in pairs(self.tPlayerServiceData[iPlayerID]["skin"]) do
		for _, tItemData in ipairs(tItemList) do
			if tItemData.ItemName ~= "default_no_item" then
				table.insert(ItemList, { ItemName = tItemData.ItemName, Equip = tItemData.Equip })
			end
		end
	end
	self:HTTPRequest("POST", "ToggleEquipState", { SteamID = Steamid, ItemList = ItemList }, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = json.decode(sBody)
			print(sBody)
			self:UpdateNetTables()
		end
	end, REQUEST_TIME_OUT)
end

function public:HTTPRequest(sMethod, sAction, hParams, hFunc, fTimeout)
	local szURL = Address .. "?action=" .. sAction .. "&version=1.1"
	local handle = CreateHTTPRequestScriptVM(sMethod, szURL)

	-- handle:SetHTTPRequestHeaderValue("Dedicated-Server-Key", ServerKey)
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")

	if hParams == nil then hParams = {} end
	hParams.server_key = ServerKey
	handle:SetHTTPRequestRawPostBody("application/json", json.encode(hParams))

	handle:SetHTTPRequestAbsoluteTimeoutMS((fTimeout or REQUEST_TIME_OUT) * 1000)

	handle:Send(function(response)
		hFunc(response.StatusCode, response.Body, response)
	end)

end

function public:HTTPRequestSync(sMethod, sAction, hParams, fTimeout)
	local co = coroutine.running()
	self:HTTPRequest(sMethod, sAction, hParams, function(iStatusCode, sBody, hResponse)
		coroutine.resume(co, iStatusCode, sBody, hResponse)
	end, fTimeout)
	return coroutine.yield()
end

-- 是否和服务器通讯成功
function public:IsChecked()
	return self.bServerChecked
end

-- 是否有vip
function public:IsVipPlayer(iPlayerID)
	local tItemList = self.tPlayerServiceData[iPlayerID]["other"]
	if tItemList then
		for _, tItemData in ipairs(tItemList) do
			if tonumber(tItemData.Equip) == 1 and tItemData.ItemName == "vip" then
				return true
			end
		end
	end
	return false
end
-- 获取某个类型的已装备物品
function public:GetEquippedItem(iPlayerID, sType, sHeroName)
	local tData = {}
	local tPlayerServiceData = sType == "skin" and self.tPlayerServiceData[iPlayerID][sType][(sHeroName or GuardingAthena.tPlayerSelectionInfo[iPlayerID].player_selected_hero)] or self.tPlayerServiceData[iPlayerID][sType]
	if tPlayerServiceData then
		for _, tItemData in ipairs(tPlayerServiceData) do
			if tonumber(tItemData.Equip) == 1 and tItemData.ItemName ~= "default_no_item" then
				table.insert(tData, tItemData)
			end
		end
	end
	return tData
end
-- 获取某个类型的物品
function public:GetPlayerItem(iPlayerID, sType, sHeroName)
	local tData = {}
	local tPlayerServiceData = sType == "skin" and self.tPlayerServiceData[iPlayerID][sType][(sHeroName or GuardingAthena.tPlayerSelectionInfo[iPlayerID].player_selected_hero)] or self.tPlayerServiceData[iPlayerID][sType]
	if tPlayerServiceData then
		for _, tItemData in ipairs(tPlayerServiceData) do
			if tItemData.ItemName ~= "default_no_item" then
				table.insert(tData, tItemData)
			end
		end
	end
	return tData
end

--更新所有有关的NetTable
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("service", "player_data", self.tPlayerServiceData)
	CustomNetTables:SetTableValue("service", "inventory", self.tInventoryData)
	CustomNetTables:SetTableValue("service", "store_item", self.tStoreItemData)
end

function public:OnToggleItemEquipState(eventSourceIndex, events)
	local iPlayerID = events.PlayerID
	local sItemName = events.ItemName
	local sType = events.Type
	if sType == "skin" then
		if sItemName == "default_no_item" then
			print(events.HeroName)
			sItemName = self:GetEquippedItem(iPlayerID, "skin", events.HeroName)[1].ItemName
			print(sItemName)
		end
		local sHeroName = KeyValues.PlayerItemsKV[sItemName].Hero
		for i, tItemData in pairs(self.tPlayerServiceData[iPlayerID][sType][sHeroName]) do
			if tItemData.ItemName == sItemName then
				tItemData.Equip = tItemData.Equip == "1" and "0" or "1"
			else
				tItemData.Equip = "0"
			end
		end
	elseif sType == "pet" then
		for i, tItemData in ipairs(self.tPlayerServiceData[iPlayerID][sType]) do
			if tItemData.ItemName == sItemName then
				tItemData.Equip = tItemData.Equip == "1" and "0" or "1"
			else
				tItemData.Equip = "0"
			end
		end
	elseif sType == "hero" or sType == "gameplay" or "particle" then
		for i, tItemData in ipairs(self.tPlayerServiceData[iPlayerID][sType]) do
			if tItemData.ItemName == sItemName then
				tItemData.Equip = tItemData.Equip == "1" and "0" or "1"
			end
		end
	end
	self:UpdateNetTables()
	self:RequestUpDataEquip(iPlayerID)
end
function public:OnPurchaseItem(eventSourceIndex, events)
	local iPlayerID = events.PlayerID
	local player = PlayerResource:GetPlayer(iPlayerID)
	local sItemName = events.ItemName
	local Currency = events.Currency
	local SteamID = tostring(PlayerResource:GetSteamAccountID(iPlayerID))
	self:HTTPRequest("POST", "PurchaseItem", { ItemName = sItemName, Currency = Currency, SteamID = SteamID }, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			print(sBody)
			self:RequestPlayerData(iPlayerID)
			CustomGameEventManager:Send_ServerToPlayer(player, "purchase_complete", {})
		end
	end, REQUEST_TIME_OUT)
end
function public:CheckHeroUnlock(iPlayerID, sHeroName)
	if KeyValues.HeroesKv[sHeroName].UnitLabel == nil or KeyValues.HeroesKv[sHeroName].UnitLabel ~= "lock" then
		return true
	end
	local tPlayerHeroData = self.tPlayerServiceData[iPlayerID]["hero"]
	for _, tItemData in ipairs(tPlayerHeroData) do
		if sHeroName == "npc_dota_hero_" .. tItemData.ItemName then
			return true
		end
	end
	return false
end
function public:GameReward(iPlayerID, bWin)
	local SteamID = tostring(PlayerResource:GetSteamAccountID(iPlayerID))
	local Score = bWin and SCORE_REWARD[GameRules:GetCustomGameDifficulty()] or 0
	local Shard = bWin and SHARD_REWARD[GameRules:GetCustomGameDifficulty()] or self:GetLoseShardReward()
	local PetXP = bWin and PETXP_REWARD[GameRules:GetCustomGameDifficulty()] or 0
	local params = {
		SteamID = SteamID,
		Score = Score,
		Shard = Shard,
		PetData = {
			PetName = PlayerResource:GetPlayer(iPlayerID):GetAssignedHero():GetPet():GetUnitName(),
			Exp = PetXP
		}
	}
	self:HTTPRequest("POST", "GameReward", params, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = json.decode(sBody)
		end
	end, REQUEST_TIME_OUT)
end
function public:GetLoseShardReward()
	if GameRules:GetCustomGameDifficulty() < 4 then
		return 0
	else
		return Spawner.gameRound * (GameRules:GetCustomGameDifficulty() - 2)
	end
end
function public:GetPetExperience(iPlayerID, sItemName)
	local PetList = self.tPlayerServiceData[iPlayerID]["pet"]
	for i, PetData in ipairs(PetList) do
		if PetData.ItemName == sItemName then
			return tonumber(PetData.Experience) or 0
		end
	end
	return 0
end
function public:OnRefreshPlayerData(eventSourceIndex, events)
	local iPlayerID = events.PlayerID
	local player = PlayerResource:GetPlayer(iPlayerID)
	local SteamID = tostring(PlayerResource:GetSteamAccountID(iPlayerID))
	self:HTTPRequest("POST", "GetPrice", { SteamID = SteamID }, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = json.decode(sBody)
			print(sBody)
			self.tPlayerServiceData[iPlayerID].Shard = hBody.Shard
			self.tPlayerServiceData[iPlayerID].Price = hBody.Price
			self:UpdateNetTables()
		end
	end, REQUEST_TIME_OUT)
end
return public