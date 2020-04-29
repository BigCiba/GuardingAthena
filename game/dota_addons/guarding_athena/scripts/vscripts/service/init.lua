if Service == nil then
	Service = class({})
end
local public = Service

--[[
	一些需要用到的特殊函数
]]--
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
		-- self.tPlayerAllItems = {}
	end

	GameEvent("game_rules_state_change", Dynamic_Wrap(public, "OnGameRulesStateChange"), public)

	-- CustomUIEvent("ChangeSkin", Dynamic_Wrap(public, "OnChangeSkin"), public)

	if IsInToolsMode() then
		-- CustomUIEvent("DebugRefreshData", Dynamic_Wrap(public, "DebugRefreshData"), public)
	end

	-- Request:Event("get_recharge_url", Dynamic_Wrap(public, "OnGetRechargeUrl"), public)
end

--[[
	监听事件
]]--
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

	for iPlayerID = 0, PlayerResource:GetPlayerCount()-1, 1 do
		if PlayerResource:IsValidPlayerID(iPlayerID) then
			self:RequestPlayerData(iPlayerID)
		end
	end

	self:UpdateNetTables()
end

function public:DebugRefreshData()
	self:RefreshAllData()
end

-- 请求玩家数据
function public:RequestPlayerData(iPlayerID)
	local Steamid = tostring(PlayerResource:GetSteamAccountID(iPlayerID))
	local Address = "http://bigciba.applinzi.com/dota2api/GetPlayerData.php"
	local handle = CreateHTTPRequestScriptVM("POST",Address)
	handle:SetHTTPRequestGetOrPostParameter("SteamID", Steamid)
	handle:SetHTTPRequestGetOrPostParameter("ServerKey", ServerKey)
	handle:SetHTTPRequestAbsoluteTimeoutMS(REQUEST_TIME_OUT * 1000)
	handle:Send(function(response)
		if response.StatusCode == 200 then
			local hBody = json.decode(response.Body)
			print("RequestPlayerData:")
			DeepPrintTable(hBody)
			if hBody ~= nil then
				if self.tPlayerServiceData[iPlayerID] == nil then
					self.tPlayerServiceData[iPlayerID] = {}
				end
				for i, v in ipairs(hBody) do
					if self.tPlayerServiceData[iPlayerID][v.Type] == nil then
						self.tPlayerServiceData[iPlayerID][v.Type] = {}
					end
					table.insert(self.tPlayerServiceData[iPlayerID][v.Type], {
						ItemName = v.ItemName,
						Equip = v.Equip,
						Expiration = v.Expiration,
						Type = v.Type
					})
				end
				self.tPlayerServiceData[iPlayerID].Score = hBody[1].Score
				self.tPlayerServiceData[iPlayerID].Level = GuardingAthena:GetPlayerLevel(hBody[1].Score)
				
				DeepPrintTable(self.tPlayerServiceData[iPlayerID])
				-- for key, value in pairs(hBody) do
				-- 	if  then
						
				-- 	end
				-- end
				-- self.tPlayerServiceData[iPlayerID].star_num = tonumber(hBody.star_num)
				self:UpdateNetTables()
			end
		end
	end)
end

function public:HTTPRequest(sMethod, sAction, hParams, hFunc, fTimeout)
	local szURL = Address.."?action="..sAction.."&version=1.1"
	local handle = CreateHTTPRequestScriptVM(sMethod, szURL)

	-- handle:SetHTTPRequestHeaderValue("Dedicated-Server-Key", ServerKey)
	handle:SetHTTPRequestHeaderValue("Content-Type", "application/json;charset=uft-8")

	if hParams == nil then hParams = {} end
	hParams.server_key = ServerKey
	handle:SetHTTPRequestRawPostBody("application/json", json.encode(hParams))

	handle:SetHTTPRequestAbsoluteTimeoutMS((fTimeout or REQUEST_TIME_OUT)*1000)
	
	handle:Send(function( response )
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

--更新所有有关的NetTable
function public:UpdateNetTables()
	CustomNetTables:SetTableValue("service", "player_data", self.tPlayerServiceData)
end

return public