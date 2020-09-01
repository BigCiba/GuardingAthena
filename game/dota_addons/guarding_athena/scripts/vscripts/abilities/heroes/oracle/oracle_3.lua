LinkLuaModifier( "modifier_oracle_3", "abilities/heroes/oracle/oracle_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if oracle_3 == nil then
	oracle_3 = class({})
end
function oracle_3:GetIntrinsicModifierName()
	return "modifier_oracle_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_3 == nil then
	modifier_oracle_3 = class({})
end
function modifier_oracle_3:OnCreated(params)
	if IsServer() then
	end
end
function modifier_oracle_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_oracle_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_oracle_3:DeclareFunctions()
	return {
	}
end