LinkLuaModifier( "modifier_pet_41_1", "abilities/pets/pet_41_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_41_1_aura", "abilities/pets/pet_41_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_41_1 == nil then
	pet_41_1 = class({})
end
function pet_41_1:GetIntrinsicModifierName()
	return "modifier_pet_41_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_41_1 == nil then
	modifier_pet_41_1 = class({}, nil, ModifierHidden)
end
function modifier_pet_41_1:IsAura()
	return true
end
function modifier_pet_41_1:GetAuraRadius()
	return -1
end
function modifier_pet_41_1:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_pet_41_1:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_pet_41_1:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_pet_41_1:GetAuraEntityReject(hEntity)
	if hEntity == self:GetCaster():GetMaster() then
		return false
	end
	return true
end
function modifier_pet_41_1:GetModifierAura()
	return "modifier_pet_41_1_aura"
end
---------------------------------------------------------------------
if modifier_pet_41_1_aura == nil then
	modifier_pet_41_1_aura = class({}, nil, ModifierHidden)
end
function modifier_pet_41_1_aura:IsDebuff()
	return true
end
function modifier_pet_41_1_aura:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	if IsServer() then
	end
end
function modifier_pet_41_1_aura:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_pet_41_1_aura:GetModifierMoveSpeedBonus_Percentage(params)
	return self.movespeed
end