require("abilities/common")
require("utils")
require("modifiers/BaseClass")
require("abilities/BaseClass")
require("modifiers/init")

LinkLuaModifier("modifier_reborn", "modifiers/generic/modifier_reborn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fix_damage", "modifiers/modifier_fix_damage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_events", "modifiers/modifier_events.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pet_base", "modifiers/generic/modifier_pet_base.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nature", "modifiers/generic/modifier_nature.lua", LUA_MODIFIER_MOTION_NONE)

if not IsClient() then return end

require("kv")


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