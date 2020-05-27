ring_0_3 = class({})
function ring_0_3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end
function ring_0_3:OnCreated()
end
function ring_0_3:GetModifierBonusStats_Strength( t )
	return self:GetParent():GetBaseStrength() * 0.1 + 60
end
function ring_0_3:GetModifierBonusStats_Agility( t )
	return self:GetParent():GetBaseAgility() * 0.1 + 60
end
function ring_0_3:GetModifierBonusStats_Intellect( t )
	return self:GetParent():GetBaseIntellect() * 0.1 + 60
end
function ring_0_3:IsHidden() 
	return false
end
function ring_0_3:GetTexture()
	return "item_ring_3"
end