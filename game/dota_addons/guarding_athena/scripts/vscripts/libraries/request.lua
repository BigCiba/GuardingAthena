if Request == nil then
	Request = class({})
end

local public = Request

function public:init(bReload)
	self.tEvents = {}

	CustomUIEvent("service_events_req", Dynamic_Wrap(public, "ServiceEventsRequest"), public)
end

-- 注册事件
function public:Event(sEvent, func, context)
	self.tEvents[sEvent] = {
		callback = func,
		context = context,
	}
end

-- 触发服务器事件
function public:ServerEvent(sEvent, iPlayerID, data)
	local tData = {}
	tData.eventName = sEvent
	tData.PlayerID = iPlayerID
	tData._IsServer = true
	tData.data = json.encode(data)
	self:ServiceEventsRequest(-1, tData)
end

function public:ServiceEventsRequest(iEventSourceIndex, tData)
	local hPlayer = PlayerResource:GetPlayer(tData.PlayerID)
	if hPlayer == nil then return end

	local tEventTable = self.tEvents[tData.eventName]
	if tEventTable == nil then return end

	local data = json.decode(tData.data)
	if data == nil then return end

	coroutine.wrap(function()
		data.PlayerID = tData.PlayerID

		local result
		if tEventTable.context ~= nil then
			result = tEventTable.callback(tEventTable.context, data)
		else
			result = tEventTable.callback(data)
		end

		if tData._IsServer ~= true then
			if type(result) ~= 'table' then
				result = {
					status = -1,
					data = result
				}
			end
			CustomGameEventManager:Send_ServerToPlayer(hPlayer, "service_events_res", {
				result = json.encode(result),
				queueIndex = tData.queueIndex,
			})
		end
	end)()
end

return public