LinkLuaModifier( "modifier_god_light", "scripts/vscripts/ability_unit/general/god_light.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if god_light == nil then
	god_light = class({})
end
function god_light:GetIntrinsicModifierName()
	return "modifier_god_light"
end
---------------------------------------------------------------------
--Modifiers
if modifier_god_light == nil then
	modifier_god_light = class({})
end
function modifier_god_light:OnCreated(params)
	if IsServer() then
	end
end
function modifier_god_light:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_god_light:OnDestroy()
	if IsServer() then
	end
end
function modifier_god_light:DeclareFunctions()
	return {
	}
end