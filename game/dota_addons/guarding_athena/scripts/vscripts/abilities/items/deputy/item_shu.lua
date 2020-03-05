LinkLuaModifier("modifier_shu", "abilities/items/deputy/item_shu.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shu_active", "abilities/items/deputy/item_shu.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_shu_1 == nil then
	item_shu_1 = class({})
end
function item_shu_1:GetIntrinsicModifierName()
	return "modifier_shu"
end
---------------------------------------------------------------------
if item_shu_2 == nil then
	item_shu_2 = class({})
end
function item_shu_2:GetIntrinsicModifierName()
	return "modifier_shu"
end
---------------------------------------------------------------------
if item_shu_3 == nil then
	item_shu_3 = class({})
end
function item_shu_3:GetIntrinsicModifierName()
	return "modifier_shu"
end
---------------------------------------------------------------------
if item_shu_4 == nil then
	item_shu_4 = class({})
end
function item_shu_4:GetIntrinsicModifierName()
	return "modifier_shu"
end
---------------------------------------------------------------------
if item_shu_5 == nil then
	item_shu_5 = class({})
end
function item_shu_5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_shu_active", {duration = self:GetSpecialValueFor("duration")})
end
function item_shu_5:GetIntrinsicModifierName()
	return "modifier_shu"
end
---------------------------------------------------------------------
-- Modifier
if modifier_shu == nil then
	modifier_shu = class({})
end
function modifier_shu:IsHidden()
	return true
end
function modifier_shu:IsDebuff()
	return false
end
function modifier_shu:IsPurgable()
	return false
end
function modifier_shu:IsPurgeException()
	return false
end
function modifier_shu:IsStunDebuff()
	return false
end
function modifier_shu:AllowIllusionDuplicate()
	return false
end
function modifier_shu:OnCreated(params)
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.cooldown_reduce = self:GetAbility():GetSpecialValueFor("cooldown_reduce")
	if IsServer() then
		self.records = {}
	end
end
function modifier_shu:OnRefresh(params)
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.cooldown_reduce = self:GetAbility():GetSpecialValueFor("cooldown_reduce")
	if IsServer() then
	end
end
function modifier_shu:OnDestroy()
	if IsServer() then
	end
end
function modifier_shu:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
end
function modifier_shu:GetModifierHealthBonus()
	return self.bonus_health
end
function modifier_shu:GetModifierManaBonus()
	return self.bonus_mana
end
function modifier_shu:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end
function modifier_shu:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end
function modifier_shu:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_shu:GetModifierBonusStats_Strength()
	return self.bonus_stats
end
function modifier_shu:GetModifierBonusStats_Agility()
	return self.bonus_stats
end
function modifier_shu:GetModifierBonusStats_Intellect()
	return self.bonus_stats
end
function modifier_shu:GetModifierPercentageCooldown()
	return self.cooldown_reduce
end
---------------------------------------------------------------------
if modifier_shu_active == nil then
	modifier_shu_active = class({})
end
function modifier_shu_active:IsHidden()
	return false
end
function modifier_shu_active:IsDebuff()
	return false
end
function modifier_shu_active:IsPurgable()
	return false
end
function modifier_shu_active:IsPurgeException()
	return false
end
function modifier_shu_active:IsStunDebuff()
	return false
end
function modifier_shu_active:AllowIllusionDuplicate()
	return false
end
function modifier_shu_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end
function modifier_shu_active:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_shu_active:GetModifierBonusStats_Strength()
	if self:GetParent():GetPrimaryAttribute() == 0 then
		return self:GetParent():GetBaseStrength() * 0.5
	end
end
function modifier_shu_active:GetModifierBonusStats_Agility()
	if self:GetParent():GetPrimaryAttribute() == 1 then
		return self:GetParent():GetBaseAgility() * 0.5
	end
end
function modifier_shu_active:GetModifierBonusStats_Intellect()
	if self:GetParent():GetPrimaryAttribute() == 2 then
		return self:GetParent():GetBaseIntellect() * 0.5
	end
end