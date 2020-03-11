LinkLuaModifier("modifier_fu", "abilities/items/deputy/item_fu.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fu_active", "abilities/items/deputy/item_fu.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_fu_1 == nil then
	item_fu_1 = class({})
end
function item_fu_1:GetIntrinsicModifierName()
	return "modifier_fu"
end
---------------------------------------------------------------------
if item_fu_2 == nil then
	item_fu_2 = class({})
end
function item_fu_2:GetIntrinsicModifierName()
	return "modifier_fu"
end
---------------------------------------------------------------------
if item_fu_3 == nil then
	item_fu_3 = class({})
end
function item_fu_3:GetIntrinsicModifierName()
	return "modifier_fu"
end
---------------------------------------------------------------------
if item_fu_4 == nil then
	item_fu_4 = class({})
end
function item_fu_4:GetIntrinsicModifierName()
	return "modifier_fu"
end
---------------------------------------------------------------------
if item_fu_5 == nil then
	item_fu_5 = class({})
end
function item_fu_5:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_fu_active", {duration = 10})
end
function item_fu_5:GetIntrinsicModifierName()
	return "modifier_fu"
end
---------------------------------------------------------------------
-- Modifier
if modifier_fu == nil then
	modifier_fu = class({})
end
function modifier_fu:IsHidden()
	return true
end
function modifier_fu:IsDebuff()
	return false
end
function modifier_fu:IsPurgable()
	return false
end
function modifier_fu:IsPurgeException()
	return false
end
function modifier_fu:IsStunDebuff()
	return false
end
function modifier_fu:AllowIllusionDuplicate()
	return false
end
function modifier_fu:OnCreated(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.cleave_percent = self:GetAbilitySpecialValueFor("cleave_percent")
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbilitySpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.waist_cut_chance = self:GetAbilitySpecialValueFor("waist_cut_chance")
	self.waist_cut_percent = self:GetAbilitySpecialValueFor("waist_cut_percent")
	if IsServer() then
		self.records = {}
	end
end
function modifier_fu:OnRefresh(params)
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	self.cleave_percent = self:GetAbilitySpecialValueFor("cleave_percent")
	self.cleave_radius = self:GetAbilitySpecialValueFor("cleave_radius")
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_health_regen = self:GetAbilitySpecialValueFor("bonus_health_regen")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.waist_cut_chance = self:GetAbilitySpecialValueFor("waist_cut_chance")
	self.waist_cut_percent = self:GetAbilitySpecialValueFor("waist_cut_percent")
	if IsServer() then
	end
end
function modifier_fu:OnDestroy()
	if IsServer() then
	end
end
function modifier_fu:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	}
end
function modifier_fu:OnAttackRecord(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsRangedAttacker() and not params.attacker:IsIllusion() then
		local waist_cut_chance = params.attacker:HasModifier("modifier_fu_active") and self.waist_cut_chance * 2 or self.waist_cut_chance
		if RollPercentage(waist_cut_chance) then
			table.insert(self.records, params.record)
		end
	end
end
function modifier_fu:OnAttackRecordDestroy(params)
	if params.target == nil or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() then
		for i,record in ipairs(self.records) do
			if record == params.record then
				table.remove( self.records, i )
				break
			end
		end
	end
end
function modifier_fu:OnAttackLanded(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsRangedAttacker() and not params.attacker:IsIllusion() then
		local sCleaveParticle = "particles/items_fx/battlefury_cleave.vpcf"
		local flBonusDamage = 0
		for i,record in ipairs(self.records) do
			if record == params.record then
				local waist_cut_percent = params.target:IsConsideredHero() and 0.1 or self.waist_cut_percent
				flBonusDamage = params.target:GetHealth() * waist_cut_percent * 0.01
				sCleaveParticle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf"
				break
			end
		end
		local cleave_percent = params.attacker:HasModifier("modifier_fu_active") and self.cleave_percent * 2 or self.cleave_percent
		local cleave_radius = params.attacker:HasModifier("modifier_fu_active") and self.cleave_radius * 2 or self.cleave_radius
		local cleave_damage = (params.original_damage + flBonusDamage) * cleave_percent * 0.01
		DoCleaveAttack(params.attacker, params.target, self:GetAbility(), cleave_damage, 260, 520, cleave_radius, sCleaveParticle)
		params.attacker:EmitSound("DOTA_Item.BattleFury")
	end
end
function modifier_fu:GetModifierProcAttack_BonusDamage_Pure(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsRangedAttacker() and not params.attacker:IsIllusion() then
		for i,record in ipairs(self.records) do
			if record == params.record then
				local waist_cut_percent = params.target:IsConsideredHero() and 0.1 or self.waist_cut_percent
				return params.target:GetHealth() * waist_cut_percent * 0.01
			end
		end
	end
end
function modifier_fu:GetModifierHealthBonus()
	return self.bonus_health
end
function modifier_fu:GetModifierManaBonus()
	return self.bonus_mana
end
function modifier_fu:GetModifierConstantHealthRegen()
	return self.bonus_health_regen
end
function modifier_fu:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end
function modifier_fu:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end
function modifier_fu:GetModifierBonusStats_Strength()
	return self.bonus_stats
end
function modifier_fu:GetModifierBonusStats_Agility()
	return self.bonus_stats
end
function modifier_fu:GetModifierBonusStats_Intellect()
	return self.bonus_stats
end
function modifier_fu:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
---------------------------------------------------------------------
if modifier_fu_active == nil then
	modifier_fu_active = class({})
end
function modifier_fu_active:IsHidden()
	return false
end
function modifier_fu_active:IsDebuff()
	return false
end
function modifier_fu_active:IsPurgable()
	return false
end
function modifier_fu_active:IsPurgeException()
	return false
end
function modifier_fu_active:IsStunDebuff()
	return false
end
function modifier_fu_active:AllowIllusionDuplicate()
	return false
end