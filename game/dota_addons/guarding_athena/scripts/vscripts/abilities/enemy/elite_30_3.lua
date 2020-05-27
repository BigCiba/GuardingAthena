LinkLuaModifier( "modifier_elite_30_3", "abilities/enemy/elite_30_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elite_30_3_aura", "abilities/enemy/elite_30_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_30_3 == nil then
	elite_30_3 = class({})
end
function elite_30_3:GetIntrinsicModifierName()
	return "modifier_elite_30_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_30_3 == nil then
	modifier_elite_30_3 = class({}, nil, ModifierHidden)
end
function modifier_elite_30_3:IsAura()
	return true
end
function modifier_elite_30_3:GetAuraRadius()
	return self.radius
end
function modifier_elite_30_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_elite_30_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_elite_30_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_elite_30_3:GetModifierAura()
	return "modifier_elite_30_3_aura"
end
function modifier_elite_30_3:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
---------------------------------------------------------------------
if modifier_elite_30_3_aura == nil then
	modifier_elite_30_3_aura = class({}, nil, ModifierBasic)
end
function modifier_elite_30_3_aura:OnCreated(params)
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
end
function modifier_elite_30_3_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_elite_30_3_aura:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_attack
end