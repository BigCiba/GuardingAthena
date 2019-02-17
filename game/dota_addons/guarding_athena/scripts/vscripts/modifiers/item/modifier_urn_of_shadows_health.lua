modifier_urn_of_shadows_health = class({})

function modifier_urn_of_shadows_health:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
    }
    return funcs
end
function modifier_urn_of_shadows_health:GetTexture()
    return "item_urn_of_shadows"
end
function modifier_urn_of_shadows_health:GetEffectName()
    return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end
function modifier_urn_of_shadows_health:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_urn_of_shadows_health:OnCreated( t )
    if IsServer() then
        self.health = t.health
    end
end
function modifier_urn_of_shadows_health:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT
    end
end
function modifier_urn_of_shadows_health:GetModifierHealthBonus(t)
    if IsServer() then
        return self.health
    end
end
function modifier_urn_of_shadows_health:IsHidden() 
	return false
end