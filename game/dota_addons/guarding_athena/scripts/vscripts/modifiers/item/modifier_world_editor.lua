modifier_world_editor = class({})

function modifier_world_editor:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_AVOID_DAMAGE,
    }
    return funcs
end
function modifier_world_editor:GetEffectName()
    return "particles/items2_fx/urn_of_shadows_heal.vpcf"
end
function modifier_world_editor:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_world_editor:OnCreated( t )
    self.health = t.health
    self.health_regen_percent = t.health_regen_percent
    self.model_scale = t.model_scale
end
function modifier_world_editor:GetAttributes( t )
    if IsServer() then
        return MODIFIER_ATTRIBUTE_PERMANENT
    end
end
function modifier_world_editor:GetModifierHealthBonus(t)
    return self.health
end
function modifier_world_editor:GetModifierHealthRegenPercentage(t)
    return self.health_regen_percent
end
function modifier_world_editor:GetModifierModelScale(t)
    return self.model_scale
end
function modifier_world_editor:GetModifierAvoidDamage(t)
    if IsServer() then
        local caster = self:GetCaster()
        if t.damage < caster:GetMaxHealth() * 0.1 then
            return 1
        end
    end
end
function modifier_world_editor:IsHidden() 
	return false
end