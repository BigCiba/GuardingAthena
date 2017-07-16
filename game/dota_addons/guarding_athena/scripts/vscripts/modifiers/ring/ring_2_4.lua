ring_2_4 = class({})

function ring_2_4:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end
function ring_2_4:OnAttackLanded( t )
    if IsServer() then
        if t.target == self:GetParent() then
            t.target.percent_reduce_damage = t.target.percent_reduce_damage + 1
            Timers:CreateTimer(10,function ()
                t.target.percent_reduce_damage = t.target.percent_reduce_damage - 1
            end)
        end
    end
end

function ring_2_4:IsHidden() 
	return false
end
function ring_2_4:GetTexture()
    return "item_ring_secret"
end
