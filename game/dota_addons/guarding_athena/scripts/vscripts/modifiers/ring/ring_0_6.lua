ring_0_6 = class({})
function ring_0_6:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT
	}
	return funcs
end
function ring_0_6:GetModifierBonusStats_Strength( t )
	return 60
end
function ring_0_6:GetModifierBonusStats_Agility( t )
	return 60
end
function ring_0_6:GetModifierBonusStats_Intellect( t )
	return 60	
end
function ring_0_6:GetModifierCooldownReduction_Constant( t )
	return 1
end
function ring_0_6:IsHidden() 
	return false
end
function ring_0_6:GetTexture()
	return "item_ring_6"
end