hero_attribute_strength = class({})

function hero_attribute_strength:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
    return funcs
end
function hero_attribute_strength:OnCreated( t )
    self.iCount = self:GetParent():GetBaseStrength() * 0.2
    if IsServer() then
    end
end
function hero_attribute_strength:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
    end
end
function hero_attribute_strength:GetModifierConstantHealthRegen(t)
    if IsServer() then
        self:SetStackCount(self.iCount)
        return self.iCount
    end
    if IsClient() then
        return self:GetStackCount()
    end
end
function hero_attribute_strength:GetModifierIgnoreMovespeedLimit()
    return 1
end
function hero_attribute_strength:GetModifierMoveSpeed_Limit()
    return 650
end
function hero_attribute_strength:IsHidden() 
	return true
end