ring_0_4 = class({})
function ring_0_4:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end
function ring_0_4:GetModifierBonusStats_Strength( t )
	return 40
end
function ring_0_4:GetModifierBonusStats_Agility( t )
	return 40
end
function ring_0_4:GetModifierBonusStats_Intellect( t )
	return 40
end
function ring_0_4:GetModifierIncomingDamage_Percentage( t )
	return -10
end
function ring_0_4:IsHidden() 
	return false
end
function ring_0_4:GetTexture()
	return "item_ring_4"
end