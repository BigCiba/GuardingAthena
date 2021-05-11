if SVOperate == nil then
	SVOperate = {}
end

local public = SVOperate

public.msg = {
	[10001] = 'player',
	[10002] = 'player_hero',
	[10003] = 'player_skin',
	[10004] = 'player_particle',
	[10005] = 'player_gameplay',
	[10006] = 'player_other',
	[10007] = 'player_courier',
	[20001] = 'info_store',
}

function public:OnOperate(id, data, playerid)
	DeepPrintTable(data)
	if nil == self.msg[id] then
		return
	end

	-- 玩家数据
	if id > 10000 and id < 20000 and playerid ~= nil then
		CustomNetTables:SetTableValue("service", self.msg[id] .. '_' .. playerid, data)
		-- print("bigcibaOnOperate", self.msg[id] .. '_' .. playerid)
		-- DeepPrintTable(CustomNetTables:GetTableValue("service", self.msg[id] .. '_' .. playerid))
	elseif id > 20000 and id < 30000 then
		CustomNetTables:SetTableValue("service", self.msg[id], data)
	end
end