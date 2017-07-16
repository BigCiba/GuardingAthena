ring_2_5 = class({})

function ring_2_5:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end
function ring_2_5:OnAttackLanded( t )
    if IsServer() then
        if t.attacker == self:GetParent() then
            t.attacker.percent_bonus_damage = t.attacker.percent_bonus_damage + 1
            Timers:CreateTimer(10,function ()
                t.attacker.percent_bonus_damage = t.attacker.percent_bonus_damage - 1
            end)
        end
    end
end

function ring_2_5:IsHidden() 
	return false
end
function ring_2_5:GetTexture()
    return "item_ring_secret"
end