modifier_status_resistance = class({})

function modifier_status_resistance:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATUS_RESISTANCE,
    }
    return funcs
end
function modifier_status_resistance:OnCreated( t )
    if IsServer() then
        self.status_resistance = t.status_resistance
    end
end
function modifier_status_resistance:GetModifierStatusResistance(t)
    if IsServer() then
        return 100
    end
end
function modifier_status_resistance:IsHidden() 
	return false
end