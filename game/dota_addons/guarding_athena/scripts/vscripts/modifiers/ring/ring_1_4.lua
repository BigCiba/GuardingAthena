ring_1_4 = class({})

function ring_1_4:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end
function ring_1_4:OnTakeDamage( t )
    if IsServer() then
        if t.unit == self:GetParent() then
            if RollPercentage(15) then
                local caster = t.unit
                local heal = caster:GetMaxHealth() * 0.2
                local health = caster:GetHealth()
                caster:SetHealth(health + heal)
                --Heal( t.unit, t.unit:GetMaxHealth() * 0.1, 0, true )
            end
        end
    end
end
function ring_1_4:IsHidden() 
	return false
end
function ring_1_4:GetTexture()
    return "item_ring_secret"
end
