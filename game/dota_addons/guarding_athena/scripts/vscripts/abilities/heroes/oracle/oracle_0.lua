LinkLuaModifier( "modifier_oracle_0", "abilities/heroes/oracle/oracle_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if oracle_0 == nil then
	oracle_0 = class({})
end
function oracle_0:GetIntrinsicModifierName()
	return "modifier_oracle_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_0 == nil then
	modifier_oracle_0 = class({})
end
function modifier_oracle_0:OnCreated(params)
	if IsServer() then
	end
end
function modifier_oracle_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_oracle_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_oracle_0:DeclareFunctions()
	return {
	}
end