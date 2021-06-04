item_clarity = class({})
function item_clarity:OnSpellStart()
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
	hCaster:EmitSound("DOTA_Item.ClarityPotion.Activate")
	self:SpendCharge()
end

item_clarity1 = class({}, nil, item_clarity)
item_clarity2 = class({}, nil, item_clarity)
item_clarity3 = class({}, nil, item_clarity)
item_clarity4 = class({}, nil, item_clarity)
---------------------------------------------------------------------
--Modifiers
modifier_item_clarity = class({})
function modifier_item_clarity:GetTexture()
	return string.gsub(self:GetName(), "modifier_", "")
end
function modifier_item_clarity:GetAbilitySpecialValue()
	self.mana_per_tick = self:GetAbilitySpecialValueFor("mana_per_tick")
end
function modifier_item_clarity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = self.mana_per_tick or 0
	}
end
---------------------------------------------------------------------
modifier_item_clarity1 = eom_modifier({
	Name = "modifier_item_clarity1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, modifier_item_clarity)
---------------------------------------------------------------------
modifier_item_clarity2 = eom_modifier({
	Name = "modifier_item_clarity2",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, modifier_item_clarity)
---------------------------------------------------------------------
modifier_item_clarity3 = eom_modifier({
	Name = "modifier_item_clarity3",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, modifier_item_clarity)
---------------------------------------------------------------------
modifier_item_clarity4 = eom_modifier({
	Name = "modifier_item_clarity4",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = true,
	IsPurgeException = true,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
}, nil, modifier_item_clarity)