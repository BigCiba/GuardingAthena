ring_3_6 = class({})

function ring_3_6:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end
function ring_3_6:OnAbilityExecuted( t )
    if IsServer() then
        if t.unit == self:GetParent() then
            local caster = t.unit
            local ability = t.ability
            if ability:IsItem() or ability:IsToggle() or ability:GetCooldown(1) == 0 then
                return
            end
            local primaryAttribute = caster:GetPrimaryAttribute()
            local stats = 0
            if primaryAttribute == 0 then
                stats = caster:GetBaseStrength() * 0.15
            elseif primaryAttribute == 1 then
                stats = caster:GetBaseAgility() * 0.15
            elseif primaryAttribute == 2 then
                stats = caster:GetBaseIntellect() * 0.15
            end
            PropertySystem(caster,primaryAttribute,stats,10)
        end
    end
end
function ring_3_6:IsHidden() 
	return false
end
function ring_3_6:GetTexture()
    return "item_ring_secret"
end