-- if not IsClient() then return end

-- require("mechanics/asset_modifiers")

-- require("kv")


-- if Activated == nil then
-- 	_G.Activated = false
-- 	_G.GameEventListenerIDs = {}
-- else
-- 	_G.Activated = true
-- end

-- function GameEvent(eventName, func, context)
-- 	table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
-- end

-- function init(bReload)
-- 	if not bReload then
-- 	end
-- end

-- if Activated == true then
-- 	for i = #GameEventListenerIDs, 1, -1 do
-- 		StopListeningToGameEvent(GameEventListenerIDs[i])
-- 	end
-- 	_G.GameEventListenerIDs = {}
-- 	init(true)
-- else
-- 	init(false)
-- end