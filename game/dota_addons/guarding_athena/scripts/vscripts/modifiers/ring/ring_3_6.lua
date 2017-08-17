ring_3_6 = class({})

function ring_3_6:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
    return funcs
end
function ring_3_6:OnCreated()
    if IsServer() then
        local caster = self:GetParent()
        caster.ring_3_6_str = 0
        caster.ring_3_6_agi = 0
        caster.ring_3_6_int = 0
    end
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
            --[[ local stats = 0
            if primaryAttribute == 0 then
                stats = caster:GetBaseStrength() * 0.15
            elseif primaryAttribute == 1 then
                stats = caster:GetBaseAgility() * 0.15
            elseif primaryAttribute == 2 then
                stats = caster:GetBaseIntellect() * 0.15
            end ]]
            if primaryAttribute == 0 then
                local baseStr = caster:GetBaseStrength() * 0.25
                caster.ring_3_6_str = caster.ring_3_6_str + baseStr
                Timers:CreateTimer(10,function ()
                    caster.ring_3_6_str = caster.ring_3_6_str - baseStr
                end)
            elseif primaryAttribute == 1 then
                local baseAgi = caster:GetBaseAgility() * 0.25
                caster.ring_3_6_agi = caster.ring_3_6_agi + baseAgi
                Timers:CreateTimer(10,function ()
                    caster.ring_3_6_agi = caster.ring_3_6_agi - baseAgi
                end)
            elseif primaryAttribute == 2 then
                local baseInt = caster:GetBaseIntellect() * 0.25
                caster.ring_3_6_int = caster.ring_3_6_int + baseInt
                Timers:CreateTimer(10,function ()
                    caster.ring_3_6_int = caster.ring_3_6_int - baseInt
                end)
            end
            --PropertySystem(caster,primaryAttribute,stats,10)
        end
    end
end
function ring_3_6:GetModifierBonusStats_Strength( t )
    if IsServer() then
        return self:GetParent().ring_3_6_str
    end
end
function ring_3_6:GetModifierBonusStats_Agility( t )
    if IsServer() then
        return self:GetParent().ring_3_6_agi
    end
end
function ring_3_6:GetModifierBonusStats_Intellect( t )
    if IsServer() then
        return self:GetParent().ring_3_6_int
    end
end
function ring_3_6:IsHidden() 
	return false
end
function ring_3_6:GetTexture()
    return "item_ring_secret"
end