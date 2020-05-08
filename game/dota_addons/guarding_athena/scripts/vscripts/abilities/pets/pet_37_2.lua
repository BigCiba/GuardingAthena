LinkLuaModifier( "modifier_pet_37_2", "abilities/pets/pet_37_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_37_2_aura", "abilities/pets/pet_37_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_37_2 == nil then
	pet_37_2 = class({})
end
function pet_37_2:GetIntrinsicModifierName()
	return "modifier_pet_37_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_37_2 == nil then
	modifier_pet_37_2 = class({}, nil, ModifierHidden)
end
function modifier_pet_37_2:IsAura()
	return true
end
function modifier_pet_37_2:GetAuraRadius()
	return -1
end
function modifier_pet_37_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_pet_37_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_pet_37_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_pet_37_2:GetAuraEntityReject(hEntity)
	if hEntity == self:GetCaster():GetMaster() then
		return false
	end
	return true
end
function modifier_pet_37_2:GetModifierAura()
	return "modifier_pet_37_2_aura"
end
---------------------------------------------------------------------
if modifier_pet_37_2_aura == nil then
	modifier_pet_37_2_aura = class({}, nil, ModifierHidden)
end
function modifier_pet_37_2_aura:IsDebuff()
	return true
end
function modifier_pet_37_2_aura:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_pet_37_2_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function modifier_pet_37_2_aura:GetModifierAvoidDamage(params)
	if RollPercentage(self.chance) then
		return 1
	end
end