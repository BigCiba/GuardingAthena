modifier_spectre_health = class({})

function modifier_spectre_health:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end
function modifier_spectre_health:OnCreated( t )
    if IsServer() then
        self.health = t.health
    end
end
function modifier_spectre_health:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT
    end
end
function modifier_spectre_health:GetModifierHealthBonus(t)
    if IsServer() then
        return self.health
    end
end
function modifier_spectre_health:IsHidden() 
	return true
end