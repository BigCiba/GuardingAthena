ring_5_6 = class({})

function ring_5_6:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end
function ring_5_6:OnAbilityExecuted( t )
    if IsServer() then
        if t.unit == self:GetParent() then
            local caster = t.unit
            local ability = t.ability
            if ability:IsItem() or ability:IsToggle() or ability:GetCooldown(1) == 0 then
                return
            end
            CreateParticle("particles/items/ring/ring_5_6.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster,1)
            SetUnitDamagePercent(caster,25,10)
        end
    end
end
function ring_5_6:IsHidden() 
	return false
end
function ring_5_6:GetTexture()
    return "item_ring_secret"
end