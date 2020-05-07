LinkLuaModifier( "modifier_pet_15_1", "abilities/pets/pet_15_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_15_1_aura", "abilities/pets/pet_15_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if pet_15_1 == nil then
	pet_15_1 = class({})
end
function pet_15_1:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end
function pet_15_1:GetIntrinsicModifierName()
	return "modifier_pet_15_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_15_1 == nil then
	modifier_pet_15_1 = class({}, nil, ModifierHidden)
end
function modifier_pet_15_1:IsAura()
	return true
end
function modifier_pet_15_1:GetAuraRadius()
	return self.radius
end
function modifier_pet_15_1:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_pet_15_1:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_pet_15_1:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_pet_15_1:GetModifierAura()
	return "modifier_pet_15_1_aura"
end
function modifier_pet_15_1:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
---------------------------------------------------------------------
if modifier_pet_15_1_aura == nil then
	modifier_pet_15_1_aura = class({}, nil, ModifierBasic)
end
function modifier_pet_15_1_aura:IsDebuff()
	return true
end
function modifier_pet_15_1_aura:OnCreated(params)
	if IsServer() then
		self.hMaster = self:GetCaster():GetMaster()
		self.interval = self:GetAbilitySpecialValueFor("interval")
		self.damage = self:GetAbilityDamage() * self.hMaster:GetPrimaryStatValue() * self.interval
		self:StartIntervalThink(self.interval)
	end
end
function modifier_pet_15_1_aura:OnIntervalThink()
	self.hMaster:DealDamage(self:GetParent(), self:GetAbility(), self.damage)
end