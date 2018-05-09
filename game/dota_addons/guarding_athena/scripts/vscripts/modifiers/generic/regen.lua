regen = class({})

function regen:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
    return funcs
end
function regen:OnCreated( t )
    if IsServer() then
        self.regen = t.regen
        self.attribute = t.attribute or MODIFIER_ATTRIBUTE_NONE
        CustomNetTables:SetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex(),{regen=t.regen})
    end
end
function regen:GetAttributes( t )
    if IsServer() then
        return self.attribute
    end
end
function regen:GetModifierConstantHealthRegen(t)
    if IsServer() then
        return self.regen
    end
    local regen = CustomNetTables:GetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex())
    if regen and regen.regen then
        return regen.regen
    end
end
function regen:IsHidden() 
	return true
end