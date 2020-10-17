for sCourierName, tData in pairs(LoadKeyValues("scripts/npc/units/npc_pet.kv")) do
	if type(tData) == "table" and tData.AmbientEffect ~= nil and tData.AmbientEffect ~= "" then
		local sModifierName = tData.AmbientEffect
		LinkLuaModifier(sModifierName, "modifiers/courier_fx/"..sModifierName..".lua", LUA_MODIFIER_MOTION_NONE)
	end
end
-- 通用
LinkLuaModifier("modifier_knockback_custom", "modifiers/utils/modifier_knockback_custom.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_round", "modifiers/asset_modifiers/modifier_round.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_attribute", "modifiers/asset_modifiers/modifier_hero_attribute.lua", LUA_MODIFIER_MOTION_NONE)
-- 饰品特效
LinkLuaModifier("modifier_omniknight_01", "modifiers/asset_modifiers/modifier_omniknight_01.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_windrunner_01", "modifiers/asset_modifiers/modifier_windrunner_01.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rubick_01", "modifiers/asset_modifiers/modifier_rubick_01.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rubick_02", "modifiers/asset_modifiers/modifier_rubick_02.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rubick_03", "modifiers/asset_modifiers/modifier_rubick_03.lua", LUA_MODIFIER_MOTION_NONE)