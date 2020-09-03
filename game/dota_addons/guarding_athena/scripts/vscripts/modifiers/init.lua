for sCourierName, tData in pairs(LoadKeyValues("scripts/npc/units/npc_pet.kv")) do
	if type(tData) == "table" and tData.AmbientEffect ~= nil and tData.AmbientEffect ~= "" then
		local sModifierName = tData.AmbientEffect
		LinkLuaModifier(sModifierName, "modifiers/courier_fx/"..sModifierName..".lua", LUA_MODIFIER_MOTION_NONE)
	end
end
LinkLuaModifier("modifier_rubick_01", "modifiers/asset_modifiers/modifier_rubick_01.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rubick_02", "modifiers/asset_modifiers/modifier_rubick_02.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rubick_03", "modifiers/asset_modifiers/modifier_rubick_03.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_round", "modifiers/asset_modifiers/modifier_round.lua", LUA_MODIFIER_MOTION_NONE)