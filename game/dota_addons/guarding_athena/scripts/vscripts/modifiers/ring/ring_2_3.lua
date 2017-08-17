ring_2_3 = class({})

function ring_2_3:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end
function ring_2_3:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        caster.ring_2_3_str = 0
        caster.ring_2_3_agi = 0
        caster.ring_2_3_int = 0
    end
end
function ring_2_3:OnAttackLanded( t )
    if IsServer() then
        if t.attacker == self:GetParent() then
            local caster = t.attacker
            local primaryAttribute = caster:GetPrimaryAttribute()
            if primaryAttribute == 0 then
                local baseStr = caster:GetBaseStrength() * 0.02
                caster.ring_2_3_str = caster.ring_2_3_str + baseStr
                Timers:CreateTimer(10,function ()
                    caster.ring_2_3_str = caster.ring_2_3_str - baseStr
                end)
            elseif primaryAttribute == 1 then
                local baseAgi = caster:GetBaseAgility() * 0.02
                caster.ring_2_3_agi = caster.ring_2_3_agi + baseAgi
                Timers:CreateTimer(10,function ()
                    caster.ring_2_3_agi = caster.ring_2_3_agi - baseAgi
                end)
            elseif primaryAttribute == 2 then
                local baseInt = caster:GetBaseIntellect() * 0.02
                caster.ring_2_3_int = caster.ring_2_3_int + baseInt
                Timers:CreateTimer(10,function ()
                    caster.ring_2_3_int = caster.ring_2_3_int - baseInt
                end)
            end
            --PropertySystem( t.attacker, t.attacker:GetPrimaryAttribute(), t.attacker:GetPrimaryStatValue() * 0.01, 10 )
        end
    end
end
function ring_2_3:GetModifierBonusStats_Strength( t )
    if IsServer() then
        return self:GetParent().ring_2_3_str
    end
end
function ring_2_3:GetModifierBonusStats_Agility( t )
    if IsServer() then
        return self:GetParent().ring_2_3_agi
    end
end
function ring_2_3:GetModifierBonusStats_Intellect( t )
    if IsServer() then
        return self:GetParent().ring_2_3_int
    end
end
function ring_2_3:IsHidden() 
	return false
end
function ring_2_3:GetTexture()
    return "item_ring_secret"
end
