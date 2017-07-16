ring_4_4 = class({})
function ring_4_4:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end
function ring_4_4:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        caster.percent_reduce_damage = caster.percent_reduce_damage + 10
    end
end
function ring_4_4:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        caster.percent_reduce_damage = caster.percent_reduce_damage - 10 
    end
end
function ring_4_4:GetModifierBonusStats_Strength( t )
    return 40
end
function ring_4_4:GetModifierBonusStats_Agility( t )
    return 40
end
function ring_4_4:GetModifierBonusStats_Intellect( t )
    return 40
end
function ring_4_4:IsHidden() 
	return false
end
function ring_4_4:GetTexture()
    return "item_ring_broken"
end