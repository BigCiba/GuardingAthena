ability_unit = class({})
function ability_unit:GetIntrinsicModifierName()
	return "modifier_ability_unit"
end
---------------------------------------------------------------------
--Modifiers
modifier_ability_unit = eom_modifier({
	Name = "modifier_ability_unit",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ability_unit:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_ability_unit:OnCreated(params)
	if IsServer() then
	end
end
function modifier_ability_unit:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_ability_unit:OnDestroy()
	if IsServer() then
	end
end
function modifier_ability_unit:DeclareFunctions()
	return {
	}
end
function modifier_ability_unit:EDeclareFunctions()
	return {
	}
end