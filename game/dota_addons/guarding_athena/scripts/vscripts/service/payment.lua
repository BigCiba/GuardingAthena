local public = Service

local OrderStatus = {}

function AddOrder(order_id)
	OrderStatus[order_id] = true
end
function RemoveOrder(order_id)
	OrderStatus[order_id] = nil
end

function IsValidOrder(order_id)
	return OrderStatus[order_id]
end

function CheckRechargeComplete(iPlayerID, order_id)
	local steamid = tostring(PlayerResource:GetSteamID(iPlayerID))
	local player = PlayerResource:GetPlayer(iPlayerID)
	GameRules:GetGameModeEntity():Timer(3, function()
		coroutine.wrap(function()
			local times = 0
			while true do
				times = times + 1

				if not IsValidOrder(order_id) then
					return
				end

				local iStatusCode, sBody = public:HTTPRequestSync("POST", "GetOrderState", {order_id=order_id}, REQUEST_TIME_OUT)
				print("iStatusCode : "..iStatusCode)
				print("sBody : "..sBody)
				if iStatusCode == 200 and sBody ~= "fail" then
					local hBody = json.decode(sBody)
					if hBody ~= nil then
						RemoveOrder(order_id)
						public.tPlayerServiceData[iPlayerID].ticket_num = new_ticket
						public:UpdateNetTables()
						CustomGameEventManager:Send_ServerToPlayer(player, "payment_complete", {amount= new_ticket-old_ticket})
						return
					end
				end

				if times >= 20 then break end
				Sleep(3)
			end
			RemoveOrder(order_id)
			CustomGameEventManager:Send_ServerToPlayer(player, "payment_faild", {})
		end)()
	end)
end


function public:OnRequestPay(eventSourceIndex, events)
	local iPlayerID = events.PlayerID
	local istype = events.istype
	local price = events.price
	local SteamID = tostring(PlayerResource:GetSteamAccountID(iPlayerID))
	local iStatusCode, sBody = self:HTTPRequestSync("POST", "GetQrcode", {price=price,istype=istype,SteamID=SteamID}, REQUEST_TIME_OUT)
	print("iStatusCode : "..iStatusCode)
	print("sBody : "..sBody)
	if iStatusCode == 200 then
	local hBody = json.decode(sBody)
	if hBody ~= nil then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "show_qrcode", {price=hBody.data.realprice,istype=hBody.data.price_istype,qrcode=hBody.data.qrcode,orderid=hBody.data.orderid})
		AddOrder(hBody.data.orderid)
		CheckRechargeComplete(iPlayerID, hBody.data.orderid)
	end
	self:HTTPRequest("POST", "GetQrcode", {price=price,istype=istype,SteamID=SteamID}, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = json.decode(sBody)
			PrintTable(hBody.data)
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "show_qrcode", {price=hBody.data.realprice,istype=hBody.data.price_istype,qrcode=hBody.data.qrcode,orderid=hBody.data.orderid})
			GameRules:GetGameModeEntity():Timer(10, function ()
				self:HTTPRequest("POST", "GetOrderState", {orderid=hBody.data.orderid}, function(iStatusCode, sBody)
					if iStatusCode == 200 then
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "pay_success", {orderid=hBody.data.orderid})
					end
				end, REQUEST_TIME_OUT)
				return 5
			end)
			AddOrder(hBody.data.orderid)
			CheckRechargeComplete(iPlayerID, hBody.data.orderid)
		end
	end, REQUEST_TIME_OUT)
end
--请求充值的网页
function public:RequestPay(hData)
	local iPlayerID = hData.PlayerID
	local type = hData.type or 1
	local amount = tostring(hData.amount)
	local steamid = tostring(PlayerResource:GetSteamID(iPlayerID))

	local iStatusCode, sBody = self:HTTPRequestSync("POST", ACTION_REQUEST_QRCODE, {amount=amount,steamid=steamid,type=type}, REQUEST_TIME_OUT)
	print("iStatusCode : "..iStatusCode)
	print("sBody : "..sBody)
	local url = ""
	local order_id = -1
	if iStatusCode == 200 then
		local hBody = json.decode(sBody)
		if hBody ~= nil and hBody.link ~= nil then
			url = hBody.link
			order_id = hBody.order_id
			AddOrder(order_id)
			CheckRechargeComplete(iPlayerID, order_id)
		end
	end

	return {url=url, order_id=order_id, type=type}
end

function public:OnClosePaymentPage(eventSourceIndex, tEvents)
	local order_id = tEvents.order_id

	RemoveOrder(order_id)
end

-- 请求补单
function public:OnAutoCheckOrder(eventSourceIndex, events)
	local iPlayerID = events.PlayerID
	self:RequestCheckOrder(iPlayerID)
end
function public:RequestCheckOrder(iPlayerID, sInterval, iPeriod, sNum)
	local sSteamid = tostring(PlayerResource:GetSteamID(iPlayerID))
	sInterval = sInterval or 60--查询冷却60秒
	iPeriod = iPeriod or 3--查询最近3天的
	sNum = sNum or 10--最多查询10条充值记录
	self:HTTPRequest("POST", ACTION_REQUERY_ORDER_STATUS, {steamid=sSteamid, requery_interval=sInterval, requery_period=iPeriod, requery_num=sNum}, function(iStatusCode, sBody)
		if iStatusCode == 200 then
			local hBody = json.decode(sBody)
			print("RequestCheckOrder:")
			DeepPrintTable(hBody)
			if hBody ~= nil then
				if hBody.status == 0 then
					self.tPlayerServiceData[iPlayerID].ticket_num = hBody.ticket_num ~= nil and tonumber(hBody.ticket_num) or 0
					self:UpdateNetTables()
				end
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(iPlayerID), "check_order_result", {iStatus=hBody.status,sMsg = hBody.msg})
			end
		end
	end, 60)
end