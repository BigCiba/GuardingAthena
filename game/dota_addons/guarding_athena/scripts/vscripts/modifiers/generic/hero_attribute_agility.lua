hero_attribute_agility = class({})

function hero_attribute_agility:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
    return funcs
end
function hero_attribute_agility:OnCreated( t )
    if IsServer() then
        self.iCount = self:GetParent():GetBaseAgility()
    end
end
function hero_attribute_agility:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
    end
end
function hero_attribute_agility:GetModifierAttackSpeedBonus_Constant(t)
    if IsServer() then
        self:SetStackCount(self.iCount)
        return self.iCount
    end
    if IsClient() then
        return self:GetStackCount()
    end
end
function hero_attribute_agility:GetModifierMoveSpeedBonus_Constant()
    if IsServer() then
        self:SetStackCount(self.iCount)
        return self.iCount
    end
    if IsClient() then
        return self:GetStackCount()
    end
end
function hero_attribute_agility:GetModifierIgnoreMovespeedLimit()
    return 1
end
function hero_attribute_agility:GetModifierMoveSpeed_Limit()
    return 700
end
function hero_attribute_agility:IsHidden() 
	return true
end