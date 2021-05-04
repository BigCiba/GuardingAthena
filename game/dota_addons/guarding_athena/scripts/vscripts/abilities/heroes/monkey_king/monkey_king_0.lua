monkey_king_0 = class({})
function monkey_king_0:GetIntrinsicModifierName()
	return "modifier_monkey_king_0"
end
---------------------------------------------------------------------
--Modifiers
modifier_monkey_king_0 = eom_modifier({
	Name = "modifier_monkey_king_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_0:GetAbilitySpecialValue()
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.damage_deep = self:GetAbilitySpecialValueFor("damage_deep")
	self.scepter_chance = self:GetAbilitySpecialValueFor("scepter_chance")
	self.scepter_critical = self:GetAbilitySpecialValueFor("scepter_critical")
end
function modifier_monkey_king_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
	}
end
function modifier_monkey_king_0:GetModifierIncomingDamage_Percentage(params)
	local flHealthPct = 100 - params.attacker:GetHealthPercent()
	return -flHealthPct * self.damage_reduce
end
function modifier_monkey_king_0:GetModifierTotalDamageOutgoing_Percentage(params)
	local flHealthPct = 100 - params.target:GetHealthPercent()
	return flHealthPct * self.damage_deep
end
function modifier_monkey_king_0:GetModifierProcAttack_BonusDamage_Pure(params)
	if self:GetParent():GetScepterLevel() >= 3 and RollPseudoRandomPercentage(self.scepter_chance, self:GetParent():entindex(), self:GetParent()) then
		local flDamage = params.original_damage * self.scepter_critical
		CreateNumberEffect(params.target, flDamage, 1.5, MSG_ORIT, "orange", 4)
		return flDamage
	end
end