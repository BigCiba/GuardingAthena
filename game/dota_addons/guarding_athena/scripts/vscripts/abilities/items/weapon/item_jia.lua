item_jia = class({})
function item_jia:GetIntrinsicModifierName()
	return "modifier_item_jia"
end
item_jia_1 = class({}, nil, item_jia)
item_jia_2 = class({}, nil, item_jia)
item_jia_3 = class({}, nil, item_jia)
item_jia_4 = class({}, nil, item_jia)
item_jia_5 = class({}, nil, item_jia)
---------------------------------------------------------------------
--Modifiers
modifier_item_jia = eom_modifier({
	Name = "modifier_item_jia",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	Super = true,
}, nil, item_base)
function modifier_item_jia:GetAbilitySpecialValue()
	self.avoid_chance = self:GetAbilitySpecialValueFor("avoid_chance")
end
function modifier_item_jia:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_item_jia:GetModifierAvoidDamage()
	if PRD(self, self.avoid_chance, "modifier_item_jia") then
		return 1
	end
end