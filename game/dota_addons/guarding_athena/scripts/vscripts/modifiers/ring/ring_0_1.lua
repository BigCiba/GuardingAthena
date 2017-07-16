ring_0_1 = class({})

function ring_0_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end
function ring_0_1:GetModifierHealthRegenPercentage( t )
    if IsServer() then
        return 6
    end
end
function ring_0_1:GetModifierTotalPercentageManaRegen( t )
    if IsServer() then
        return 6
    end
end
function ring_0_1:GetModifierBonusStats_Strength( t )
    return 40
end
function ring_0_1:GetModifierBonusStats_Agility( t )
    return 40
end
function ring_0_1:GetModifierBonusStats_Intellect( t )
    return 40
end
function ring_0_1:IsHidden() 
	return false
end
function ring_0_1:GetTexture()
    return "item_ring_1"
end
