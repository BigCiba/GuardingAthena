LinkLuaModifier( "modifier_crystal_maiden_2", "abilities/heroes/crystal_maiden/crystal_maiden_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if crystal_maiden_2 == nil then
	crystal_maiden_2 = class({})
end
function crystal_maiden_2:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden_2 == nil then
	modifier_crystal_maiden_2 = class({})
end
function modifier_crystal_maiden_2:OnCreated(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_crystal_maiden_2:DeclareFunctions()
	return {
	}
end