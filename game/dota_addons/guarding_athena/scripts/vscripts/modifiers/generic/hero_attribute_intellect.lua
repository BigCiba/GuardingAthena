hero_attribute_intellect = class({})

function hero_attribute_intellect:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
    return funcs
end
function hero_attribute_intellect:OnCreated( t )
    if IsServer() then
        self.iCount = self:GetParent():GetBaseIntellect() * 0.2
    end
end
function hero_attribute_intellect:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
    end
end
function hero_attribute_intellect:GetModifierConstantManaRegen(t)
    if IsServer() then
        self:SetStackCount(self.iCount)
        return self.iCount
    end
    if IsClient() then
        return self:GetStackCount()
    end
end
function hero_attribute_intellect:GetModifierIgnoreMovespeedLimit()
    return 1
end
function hero_attribute_intellect:GetModifierMoveSpeed_Limit()
    return 600
end
function hero_attribute_intellect:IsHidden() 
	return true
end