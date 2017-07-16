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
    if IsServer() then
        local caster = self:GetParent()
        caster.ring_0_3_str = 0
        caster.ring_0_3_agi = 0
        caster.ring_0_3_int = 0
        self:StartIntervalThink( 1 )
    end
end
function ring_0_3:OnIntervalThink()
    if IsServer() then
        local caster = self:GetParent()
        local primaryAttribute = caster:GetPrimaryAttribute()
        if primaryAttribute == 0 then
            caster.ring_0_3_str = caster:GetBaseStrength() * 0.1
        elseif primaryAttribute == 1 then
            caster.ring_0_3_agi = caster:GetBaseAgility() * 0.1
        elseif primaryAttribute == 2 then
            caster.ring_0_3_int = caster:GetBaseIntellect() * 0.1
        end
    end
end
function ring_0_3:GetModifierBonusStats_Strength( t )
    if IsServer() then
        return self:GetParent().ring_0_3_str + 60
    end
end
function ring_0_3:GetModifierBonusStats_Agility( t )
    if IsServer() then
        return self:GetParent().ring_0_3_agi + 60
    end
end
function ring_0_3:GetModifierBonusStats_Intellect( t )
    if IsServer() then
        return self:GetParent().ring_0_3_int + 60
    end
end
function ring_0_3:IsHidden() 
	return false
end
function ring_0_3:GetTexture()
    return "item_ring_3"
end