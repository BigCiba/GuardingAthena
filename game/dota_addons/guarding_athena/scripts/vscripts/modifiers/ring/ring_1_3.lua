ring_1_3 = class({})

function ring_1_3:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
    }
    return funcs
end
function ring_1_3:GetModifierHealthRegenPercentage( t )
    if IsServer() then
        local owner = self:GetParent()
        local str = owner:GetStrength()
        local regen = str / 200
        return regen
    end
end
function ring_1_3:GetModifierPercentageManaRegen( t )
    if IsServer() then
        local owner = self:GetParent()
        local int = owner:GetIntellect()
        local regen = int / 200
        return regen
    end
end
function ring_1_3:IsHidden() 
	return false
end
function ring_1_3:GetTexture()
    return "item_ring_secret"
end