LinkLuaModifier("modifier_mystletainn", "abilities/items/artifact/item_mystletainn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mystletainn_debuff", "abilities/items/artifact/item_mystletainn.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_mystletainn == nil then
	item_mystletainn = class({})
end
function item_mystletainn:GetIntrinsicModifierName()
	return "modifier_mystletainn"
end
---------------------------------------------------------------------
-- Modifier
if modifier_mystletainn == nil then
	modifier_mystletainn = class({})
end
function modifier_mystletainn:IsHidden()
	return true
end
function modifier_mystletainn:IsDebuff()
	return false
end
function modifier_mystletainn:IsPurgable()
	return false
end
function modifier_mystletainn:IsPurgeException()
	return false
end
function modifier_mystletainn:IsStunDebuff()
	return false
end
function modifier_mystletainn:AllowIllusionDuplicate()
	return false
end
function modifier_mystletainn:OnCreated(params)
	self.attribute = self:GetAbilitySpecialValueFor("attribute")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.attack = self:GetAbilitySpecialValueFor("attack")
	self.critical = self:GetAbilitySpecialValueFor("critical")
	self.absorb = self:GetAbilitySpecialValueFor("absorb")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.critical_rate = self:GetAbilitySpecialValueFor("critical_rate")
	self.attack_increase = self:GetAbilitySpecialValueFor("attack_increase")
	self.attack_rate = self:GetAbilitySpecialValueFor("attack_rate")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() - self.attack_rate)

		self:StartIntervalThink(self.interval)
	end
end
function modifier_mystletainn:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() + self.attack_rate)
	end
end
function modifier_mystletainn:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local flDamage = self.absorb * hParent:GetMaxHealth()
		if hParent:GetHealth() > flDamage then
			-- local tDamageInfo = CreateDamageTable(hParent, hParent, self:GetAbility(), flDamage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION)
			-- ApplyDamage(tDamageInfo)
			RemoveHealth(hParent, flDamage)
			hParent:SetBaseDamageMax(hParent:GetBaseDamageMax() + self.attack_increase)
			hParent:SetBaseDamageMin(hParent:GetBaseDamageMin() + self.attack_increase)
		end
	end
end
function modifier_mystletainn:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	}
end
function modifier_mystletainn:GetModifierPreAttack_BonusDamage()
	return self.attack
end
function modifier_mystletainn:GetModifierBonusStats_Strength()
	return self.attribute
end
function modifier_mystletainn:GetModifierBonusStats_Agility()
	return self.attribute
end
function modifier_mystletainn:GetModifierBonusStats_Intellect()
	return self.attribute
end
function modifier_mystletainn:GetModifierProcAttack_BonusDamage_Physical(params)
	if params.target == nil then return end
	if params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:IsIllusion() then
		if RollPercentage(self.critical_rate) then
			params.target:AddNewModifier(params.attacker, self:GetAbility(), "modifier_mystletainn_debuff", {duration = self.duration})
			CreateNumberEffect(params.target, params.damage * self.critical, 1.5, MSG_ORIT, "orange", 4)
			return params.damage * self.critical
		end
	end
end
---------------------------------------------------------------------
if modifier_mystletainn_debuff == nil then
	modifier_mystletainn_debuff = class({})
end
function modifier_mystletainn_debuff:IsHidden()
	return false
end
function modifier_mystletainn_debuff:IsDebuff()
	return true
end
function modifier_mystletainn_debuff:IsPurgable()
	return true
end
function modifier_mystletainn_debuff:IsPurgeException()
	return false
end
function modifier_mystletainn_debuff:IsStunDebuff()
	return false
end
function modifier_mystletainn_debuff:AllowIllusionDuplicate()
	return false
end
function modifier_mystletainn_debuff:OnCreated(params)
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
end
function modifier_mystletainn_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
	}
end
function modifier_mystletainn_debuff:GetModifierIncomingPhysicalDamage_Percentage()
	return self.damage_deepen + 100
end