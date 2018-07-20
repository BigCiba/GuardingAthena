exclusive = class({})

function exclusive:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end
function exclusive:OnCreated( t )
    if IsServer() then
        self.property = self:GetAbility():GetSpecialValueFor("property") * 0.01
    end
end
function exclusive:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT
    end
end
function exclusive:GetModifierHealthBonus(t)
    if IsServer() then
        return self:GetParent():GetBaseMaxHealth() * self.property
    end
end
function exclusive:GetModifierManaBonus( t )
    if IsServer() then
        return self:GetParent():GetMaxMana() * self.property
    end
end
function exclusive:GetModifierBonusStats_Strength(t)
    if IsServer() then
        return self:GetParent():GetBaseStrength() * self.property
    end
end
function exclusive:GetModifierBonusStats_Agility(t)
    if IsServer() then
        return self:GetParent():GetBaseAgility() * self.property
    end
end
function exclusive:GetModifierBonusStats_Intellect(t)
    if IsServer() then
        return self:GetParent():GetBaseIntellect() * self.property
    end
end
function exclusive:IsHidden() 
	return true
end