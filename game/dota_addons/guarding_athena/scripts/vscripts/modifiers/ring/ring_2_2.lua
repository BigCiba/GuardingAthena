ring_2_2 = class({})

function ring_2_2:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end
function ring_2_2:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        if caster.gold_rate == nil then
            caster.gold_rate = 0
        end
        caster.gold_rate = caster.gold_rate + 25
    end
end
function ring_2_2:OnDestroy()
    if IsServer() then
        local caster = self:GetParent()
        caster.gold_rate = caster.gold_rate - 25
    end
end
function ring_2_2:GetModifierBonusStats_Strength( t )
    return 80
end
function ring_2_2:GetModifierBonusStats_Agility( t )
    return 80
end
function ring_2_2:GetModifierBonusStats_Intellect( t )
    return 80
end
function ring_2_2:IsHidden() 
	return false
end
function ring_2_2:GetTexture()
    return "item_ring_broken"
end