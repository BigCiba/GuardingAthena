ring_0_5 = class({})
function ring_0_5:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end
function ring_0_5:GetModifierBonusStats_Strength( t )
	return 20
end
function ring_0_5:GetModifierBonusStats_Agility( t )
	return 20
end
function ring_0_5:GetModifierBonusStats_Intellect( t )
	return 20
end
function ring_0_5:GetModifierTotalDamageOutgoing_Percentage( t )
	return 10
end
function ring_0_5:IsHidden() 
	return false
end
function ring_0_5:GetTexture()
	return "item_ring_5"
end