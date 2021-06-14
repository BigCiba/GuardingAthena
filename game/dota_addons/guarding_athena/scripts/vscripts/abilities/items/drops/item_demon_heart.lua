item_demon_heart = class({})
function item_demon_heart:GetIntrinsicModifierName()
	return "modifier_item_demon_heart"
end
---------------------------------------------------------------------
--Modifiers
modifier_item_demon_heart = eom_modifier({
	Name = "modifier_item_demon_heart",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = true,
	RemoveOnDeath = false,
	Super = true,
}, nil, item_base)