
require("abilities/common")
require("utils")
require("modifiers/BaseClass")
require("abilities/BaseClass")

LinkLuaModifier("modifier_reborn", "modifiers/generic/modifier_reborn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_events", "modifiers/modifier_events.lua", LUA_MODIFIER_MOTION_NONE)

if not IsClient() then return end


if Activated == nil then
	_G.Activated = false
	_G.GameEventListenerIDs = {}
else
	_G.Activated = true
end

function GameEvent(eventName, func, context)
	table.insert(GameEventListenerIDs, ListenToGameEvent(eventName, func, context))
end

function init(bReload)
	if not bReload then
	end
end

if Activated == true then
	for i = #GameEventListenerIDs, 1, -1 do
		StopListeningToGameEvent(GameEventListenerIDs[i])
	end
	_G.GameEventListenerIDs = {}
	init(true)
else
	init(false)
end