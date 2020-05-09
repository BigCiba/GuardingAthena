for sCourierName, tData in pairs(LoadKeyValues("scripts/npc/units/npc_pet.kv")) do
	if type(tData) == "table" and tData.AmbientEffect ~= nil and tData.AmbientEffect ~= "" then
		local sModifierName = tData.AmbientEffect
		LinkLuaModifier(sModifierName, "modifiers/courier_fx/"..sModifierName..".lua", LUA_MODIFIER_MOTION_NONE)
	end
end