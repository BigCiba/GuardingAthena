if store == nil then
	---@class store
	store = {}
end

local public = store

function public:Init(bReload)
	if not bReload then
		self.tOrderList = {}

		self.hOrderTimer = Timer(3, function()
			for order, state in pairs(self.tOrderList) do
				if state == false then
					local data = Service:POSTSync('store.order_query', {
						orderid = order,
					})
					if data.status == 0 and data.data == 1 then
						self.tOrderList[order] = true
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "payment_complete", {})
					end
				end
			end
			return 3
		end)
	end
	Request:Event("store.buy", Dynamic_Wrap(public, "StoreBuyItem"), public)
	Request:Event("order.create", Dynamic_Wrap(public, "StoreCreateOrder"), public)
	Request:Event("order.query", Dynamic_Wrap(public, "StoreOrderQuery"), public)
	Request:Event("order.check", Dynamic_Wrap(public, "OrderCheck"), public)
end

function public:get(call, iPlayerID)
	Service:POST('store.get', {}, function(data)
		print('store.get')
		if data and data.status == 0 then
			-- TODO:
		end
		call(data)
	end)
end

--[[	UI事件
]]
function public:StoreBuyItem(params)
	local iPlayerID = params.PlayerID
	local ItemName = params.ItemName
	local paytype = params.paytype
	local itemid = -1

	local err = {
		status = -1,
		data = 'params error'
	}

	local tSealItem = CustomNetTables:GetTableValue("service", "info_store")
	for i, tItemData in pairs(tSealItem) do
		if tItemData.ItemName == ItemName then
			itemid = tItemData.itemid
		end
	end

	local data = Service:POSTSync('store.buy', {
		uid = GetAccountID(iPlayerID),
		itemid = itemid,
		paytype = paytype,
	})

	if data and data.status == 0 then
		return { status = 0 }
	end
	return { status = -1 }
end

function public:StoreCreateOrder(params)
	local iPlayerID = params.PlayerID
	local amount = params.amount
	local itemcount = params.itemcount
	local paytype = params.paytype
	local title = params.title
	local body = params.body

	local err = {
		status = -1,
		data = 'params error'
	}


	-- payssion 特殊处理
	local pmid = '';
	if tonumber(paytype) == nil then
		pmid = paytype
		paytype = 4000
	end

	local tReqData = {
		uid = GetAccountID(iPlayerID),
		itemid = 100001,
		amount = amount,
		itemcount = itemcount,
		paytype = paytype,
		pmid = pmid,
		body = body,
		title = title,
	}

	print('StoreCreateOrder req:')
	DeepPrintTable(tReqData)

	local data = Service:POSTSync('store.order_create', tReqData)

	print('StoreCreateOrder res:')
	DeepPrintTable(data)

	if data and data.status == 1 then
		-- self.tOrderList[data.data.order] = false
		local count = 20
		Timer(3, function()
			if count > 0 then
				count = count - 1
				local res = Service:POST('store.order_query', {
					uid = GetAccountID(iPlayerID),
					orderid = data.data.order,
				}, function(res)
					if res.status == 0 and res.data == 1 then
						-- self.tOrderList[order] = true
						count = 0
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "payment_complete", {})
					end
				end)
				return 3
			else
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "payment_faild", {})
			end
		end)
	end

	print('StoreCreateOrder return:')

	return data
end

function public:StoreOrderQuery(params)
	local iPlayerID = params.PlayerID
	local order = params.order

	if not order then
		return "NOT_ORDER"
	end

	local data = Service:POSTSync('shop.order_query', {
		uid = GetAccountID(iPlayerID),
		orderid = order
	})

	return data
end

function public:OrderCheck(params)
	local iPlayerID = params.PlayerID

	local data = Service:POSTSync('store.order_check', {
		uid = GetAccountID(iPlayerID),
	})

	if data and data.status == 0 then
		return { status = 0 }
	end
	return { status = -1 }
end

--[[	外部接口
]]
-- 获取商品配置表信息
function GetItemInfo(sItemName)
	local tData = CustomNetTables:GetTableValue("service", "info_store")
	for i, tItemData in pairs(tData) do
		if tItemData.ItemName == sItemName then
			return tItemData
		end
	end
end