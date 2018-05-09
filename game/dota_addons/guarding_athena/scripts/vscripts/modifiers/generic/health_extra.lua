health_extra = class({})

function health_extra:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
    return funcs
end
function health_extra:OnCreated( t )
    if IsServer() then
        self.health = t.health
        self.attribute = t.attribute or MODIFIER_ATTRIBUTE_NONE
    end
end
function health_extra:GetAttributes( t )
    if IsServer() then
        return self.attribute
    end
end
function health_extra:GetModifierExtraHealthBonus(t)
    if IsServer() then
        return self.health
    end
end
function health_extra:IsHidden() 
	return true
end