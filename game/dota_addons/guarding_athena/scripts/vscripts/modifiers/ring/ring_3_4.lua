ring_3_4 = class({})

function ring_3_4:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end
function ring_3_4:OnTakeDamage( t )
    if IsServer() then
        if t.unit == self:GetParent() then
            if t.attacker.ring_3_4_debuff == nil then
                SetUnitDamagePercent(t.attacker,-50)
                t.attacker.ring_3_4_debuff = 10
                Timers:CreateTimer(1,function ()
                    if t.attacker.ring_3_4_debuff > 0 then
                        t.attacker.ring_3_4_debuff = t.attacker.ring_3_4_debuff - 1
                        return 1
                    else
                        SetUnitDamagePercent(t.attacker,50)
                        t.attacker.ring_3_4_debuff = nil
                    end
                end)
            else
                t.attacker.ring_3_4_debuff = 10
            end
        end
    end
end

function ring_3_4:IsHidden() 
	return false
end
function ring_3_4:GetTexture()
    return "item_ring_secret"
end