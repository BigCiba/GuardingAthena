ring_5_5 = class({})
function ring_5_5:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end
function ring_5_5:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        SetUnitDamagePercent(caster,10)
    end
end
function ring_5_5:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        SetUnitDamagePercent(caster,-10)
    end
end
function ring_5_5:GetModifierBonusStats_Strength( t )
    return 20
end
function ring_5_5:GetModifierBonusStats_Agility( t )
    return 20
end
function ring_5_5:GetModifierBonusStats_Intellect( t )
    return 20
end
function ring_5_5:IsHidden() 
	return false
end
function ring_5_5:GetTexture()
    return "item_ring_broken"
end