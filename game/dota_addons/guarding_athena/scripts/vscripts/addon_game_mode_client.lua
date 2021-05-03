function init(bReload)
	_G.json = require("game/dkjson")
	require("abilities/common")
	require("modifiers/events")
	require("modifiers/eom_modifier")
	require("utils")
	require("modifiers/BaseClass")
	require("abilities/BaseClass")
	require("modifiers/init")
	require("mechanics/asset_modifiers")
	require("kv")


	_G.GameEventListenerIDs = {}

	function GameEvent(eventName, func, context)
		table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
	end

	if not bReload then
	end

	local t = {
		-- "mechanics/ability_upgrades",
	}
	for k, v in pairs(t) do
		local t = require(v)
		if t ~= nil and type(t) == "table" then
			_G[k] = t
			if t.init ~= nil then
				t:init(bReload)
			end
		end
	end


	GameEvent("client_reload_game_keyvalues", function()
		reload()
	end, nil)
end

function reload()
	for i = #GameEventListenerIDs, 1, -1 do
		StopListeningToGameEvent(GameEventListenerIDs[i])
	end
	_G.GameEventListenerIDs = {}
	init(true)
end

init(false)