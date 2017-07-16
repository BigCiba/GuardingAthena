ring_0_6 = class({})
function ring_0_6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end
function ring_0_6:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        local reduction_const = caster.reduction_const or 0
        caster.reduction_const = reduction_const + 1
    end
end
function ring_0_6:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        local reduction_const = caster.reduction_const or 0
        caster.reduction_const = reduction_const - 1
    end
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
function ring_0_6:IsHidden() 
	return false
end
function ring_0_6:GetTexture()
    return "item_ring_6"
end