item_xie = class({})
function item_xie:GetIntrinsicModifierName()
	return "modifier_item_xie"
end
item_xie_1 = class({}, nil, item_xie)
item_xie_2 = class({}, nil, item_xie)
item_xie_3 = class({}, nil, item_xie)
item_xie_4 = class({}, nil, item_xie)
item_xie_5 = class({}, nil, item_xie)
---------------------------------------------------------------------
--Modifiers
modifier_item_xie = eom_modifier({
	Name = "modifier_item_xie",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	Super = true,
}, nil, item_base)