LinkLuaModifier("modifier_dun", "abilities/items/deputy/item_dun.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dun_active", "abilities/items/deputy/item_dun.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_dun_1 == nil then
	item_dun_1 = class({})
end
function item_dun_1:GetIntrinsicModifierName()
	return "modifier_dun"
end
---------------------------------------------------------------------
if item_dun_2 == nil then
	item_dun_2 = class({})
end
function item_dun_2:GetIntrinsicModifierName()
	return "modifier_dun"
end
---------------------------------------------------------------------
if item_dun_3 == nil then
	item_dun_3 = class({})
end
function item_dun_3:GetIntrinsicModifierName()
	return "modifier_dun"
end
---------------------------------------------------------------------
if item_dun_4 == nil then
	item_dun_4 = class({})
end
function item_dun_4:GetIntrinsicModifierName()
	return "modifier_dun"
end
---------------------------------------------------------------------
if item_dun_5 == nil then
	item_dun_5 = class({})
end
function item_dun_5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_dun_active", {duration = self:GetSpecialValueFor("duration")})
end
function item_dun_5:GetIntrinsicModifierName()
	return "modifier_dun"
end
---------------------------------------------------------------------
-- Modifier
if modifier_dun == nil then
	modifier_dun = class({})
end
function modifier_dun:IsHidden()
	return true
end
function modifier_dun:IsDebuff()
	return false
end
function modifier_dun:IsPurgable()
	return false
end
function modifier_dun:IsPurgeException()
	return false
end
function modifier_dun:IsStunDebuff()
	return false
end
function modifier_dun:AllowIllusionDuplicate()
	return false
end
function modifier_dun:OnCreated(params)
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_resistance = self:GetAbility():GetSpecialValueFor("bonus_resistance")
	if IsServer() then
		self.records = {}
	end
end
function modifier_dun:OnRefresh(params)
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.damage_block = self:GetAbility():GetSpecialValueFor("damage_block")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_resistance = self:GetAbility():GetSpecialValueFor("bonus_resistance")
	if IsServer() then
	end
end
function modifier_dun:OnDestroy()
	if IsServer() then
	end
end
function modifier_dun:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_dun:GetModifierHealthBonus()
	return self.bonus_health
end
function modifier_dun:GetModifierManaBonus()
	return self.bonus_mana
end
function modifier_dun:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end
function modifier_dun:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end
function modifier_dun:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_dun:GetModifierBonusStats_Strength()
	return self.bonus_stats
end
function modifier_dun:GetModifierBonusStats_Agility()
	return self.bonus_stats
end
function modifier_dun:GetModifierBonusStats_Intellect()
	return self.bonus_stats
end
function modifier_dun:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
function modifier_dun:GetModifierMagicalResistanceBonus()
	return self.bonus_resistance
end
function modifier_dun:GetModifierIncomingDamage_Percentage()
	return self.damage_block
end
---------------------------------------------------------------------
if modifier_dun_active == nil then
	modifier_dun_active = class({})
end
function modifier_dun_active:IsHidden()
	return false
end
function modifier_dun_active:IsDebuff()
	return false
end
function modifier_dun_active:IsPurgable()
	return false
end
function modifier_dun_active:IsPurgeException()
	return false
end
function modifier_dun_active:IsStunDebuff()
	return false
end
function modifier_dun_active:AllowIllusionDuplicate()
	return false
end
function modifier_dun_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end
function modifier_dun_active:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_dun_active:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_dun_active:GetAbsoluteNoDamagePure()
	return 1
end
function modifier_dun_active:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end