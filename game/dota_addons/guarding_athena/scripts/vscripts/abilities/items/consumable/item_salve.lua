item_salve = class({})
function item_salve:OnSpellStart()
	local hCaster = self:GetCaster()
	if hCaster:IsCourier() then
		hCaster = hCaster:GetOwner()
	end
	local buff_duration = self:GetSpecialValueFor("buff_duration")
	if hCaster:HasModifier("modifier_" .. self:GetAbilityName()) then
		local hModifier = hCaster:FindModifierByName("modifier_" .. self:GetAbilityName())
		hModifier:SetDuration(hModifier:GetRemainingTime() + buff_duration, true)
	else
		hCaster:AddNewModifier(hCaster, self, "modifier_" .. self:GetAbilityName(), { duration = buff_duration })
	end
	hCaster:EmitSound("DOTA_Item.HealingSalve.Activate")
	self:SpendCharge()
end

item_salve1 = class({}, nil, item_salve)
item_salve2 = class({}, nil, item_salve)
item_salve3 = class({}, nil, item_salve)
item_salve4 = class({}, nil, item_salve)
---------------------------------------------------------------------
--Modifiers
modifier_item_salve = class({})
function modifier_item_salve:GetAbilitySpecialValue()
	self.hp_per_tick = self:GetAbilitySpecialValueFor("hp_per_tick")
end
function modifier_item_salve:GetTexture()
	return string.gsub(self:GetName(), "modifier_", "")
end
function modifier_item_salve:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.hp_per_tick or 0
	}
end
---------------------------------------------------------------------
modifier_item_salve1 = eom_modifier({
	Name = "modifier_item_salve1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, modifier_item_salve)
---------------------------------------------------------------------
modifier_item_salve2 = eom_modifier({
	Name = "modifier_item_salve2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, modifier_item_salve)
---------------------------------------------------------------------
modifier_item_salve3 = eom_modifier({
	Name = "modifier_item_salve3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, modifier_item_salve)
---------------------------------------------------------------------
modifier_item_salve4 = eom_modifier({
	Name = "modifier_item_salve4",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, modifier_item_salve)