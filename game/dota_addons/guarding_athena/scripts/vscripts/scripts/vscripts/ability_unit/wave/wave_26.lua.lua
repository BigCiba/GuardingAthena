LinkLuaModifier( "modifier_wave_26", "scripts/vscripts/ability_unit/wave/wave_26.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_26 == nil then
	wave_26 = class({})
end
function wave_26:GetIntrinsicModifierName()
	return "modifier_wave_26"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_26 == nil then
	modifier_wave_26 = class({})
end
function modifier_wave_26:OnCreated(params)
	if IsServer() then
	end
end
function modifier_wave_26:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_wave_26:OnDestroy()
	if IsServer() then
	end
end
function modifier_wave_26:DeclareFunctions()
	return {
	}
end