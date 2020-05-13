LinkLuaModifier( "modifier_spectre_4", "abilities/heroes/spectre/spectre_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if spectre_4 == nil then
	spectre_4 = class({})
end
function spectre_4:GetIntrinsicModifierName()
	return "modifier_spectre_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_4 == nil then
	modifier_spectre_4 = class({})
end
function modifier_spectre_4:OnCreated(params)
	if IsServer() then
	end
end
function modifier_spectre_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_spectre_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_spectre_4:DeclareFunctions()
	return {
	}
end