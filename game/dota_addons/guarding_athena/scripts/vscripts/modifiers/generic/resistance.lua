resistance = class({})

function resistance:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }
    return funcs
end
function resistance:OnCreated( t )
    if IsServer() then
        self.resistance = t.resistance
        self.attribute = t.attribute or MODIFIER_ATTRIBUTE_NONE
    end
end
function resistance:GetAttributes( t )
    if IsServer() then
        return self.attribute
    end
end
function resistance:GetModifierMagicalResistanceBonus(t)
    if IsServer() then
        return self.resistance
    end
end
function resistance:IsHidden() 
	return false
end