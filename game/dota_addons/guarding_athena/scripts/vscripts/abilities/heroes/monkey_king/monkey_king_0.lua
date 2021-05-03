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
end
function modifier_monkey_king_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE 
	}
end
function modifier_monkey_king_0:GetModifierIncomingDamage_Percentage(params)
	local flHealthPct = 100 - params.attacker:GetHealthPercent()
	return -flHealthPct * 2
end
function modifier_monkey_king_0:GetModifierTotalDamageOutgoing_Percentage(params)
	local flHealthPct = 100 - params.target:GetHealthPercent()
	return flHealthPct * self.damage_deep
end