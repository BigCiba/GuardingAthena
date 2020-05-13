LinkLuaModifier( "modifier_spectre_1", "abilities/heroes/spectre/spectre_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if spectre_1 == nil then
	spectre_1 = class({})
end
function spectre_1:GetIntrinsicModifierName()
	return "modifier_spectre_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_1 == nil then
	modifier_spectre_1 = class({})
end
function modifier_spectre_1:OnCreated(params)
	if IsServer() then
	end
end
function modifier_spectre_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_spectre_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_spectre_1:DeclareFunctions()
	return {
	}
end