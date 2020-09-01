LinkLuaModifier( "modifier_oracle_4", "abilities/heroes/oracle/oracle_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if oracle_4 == nil then
	oracle_4 = class({})
end
function oracle_4:GetIntrinsicModifierName()
	return "modifier_oracle_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_4 == nil then
	modifier_oracle_4 = class({})
end
function modifier_oracle_4:OnCreated(params)
	if IsServer() then
	end
end
function modifier_oracle_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_oracle_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_oracle_4:DeclareFunctions()
	return {
	}
end