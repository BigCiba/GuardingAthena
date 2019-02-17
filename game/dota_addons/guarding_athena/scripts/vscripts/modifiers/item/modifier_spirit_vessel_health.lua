modifier_spirit_vessel_health = class({})

function modifier_spirit_vessel_health:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end
function modifier_spirit_vessel_health:GetTexture()
    return "item_spirit_vessel"
end
function modifier_spirit_vessel_health:GetEffectName()
    return "particles/items2_fx/spirit_vessel_heal.vpcf"
end
function modifier_spirit_vessel_health:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_spirit_vessel_health:OnCreated( t )
    if IsServer() then
        self.health = t.health
    end
end
function modifier_spirit_vessel_health:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT
    end
end
function modifier_spirit_vessel_health:GetModifierHealthBonus(t)
    if IsServer() then
        return self.health
    end
end
function modifier_spirit_vessel_health:IsHidden() 
	return false
end