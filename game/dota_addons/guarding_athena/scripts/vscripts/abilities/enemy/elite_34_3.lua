LinkLuaModifier( "modifier_elite_34_3", "abilities/enemy/elite_34_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_34_3 == nil then
	elite_34_3 = class({})
end
function elite_34_3:GetIntrinsicModifierName()
	return "modifier_elite_34_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_34_3 == nil then
	modifier_elite_34_3 = class({})
end
function modifier_elite_34_3:OnCreated(params)
	if IsServer() then
	end
end
function modifier_elite_34_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_elite_34_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_elite_34_3:DeclareFunctions()
	return {
	}
end