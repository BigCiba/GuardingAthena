ring_2_6 = class({})

function ring_2_6:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end
function ring_2_6:OnDeath( t )
    if IsServer() then
        if t.attacker == self:GetParent() then
            local caster = t.attacker
            if caster.ring_2_6_cooldown == nil then
                caster.ring_2_6_cooldown = true
            end
            if caster.ring_2_6_cooldown then 
                for i=1,16 do
                    if caster:GetAbilityByIndex(i-1) then
                        local ability = caster:GetAbilityByIndex(i-1)
                        if ability:GetCooldownTimeRemaining() > 0 then
                            local cdRemaining = ability:GetCooldownTimeRemaining()
                            if cdRemaining < 1 then
                                cdRemaining = 1
                            end
                            ability:EndCooldown()
                            ability:StartCooldown( cdRemaining - 1 )
                        end
                    end
                end
                caster.ring_2_6_cooldown = false
                Timers:CreateTimer(1.5,function ()
                    caster.ring_2_6_cooldown = true
                end)
            end
        end
    end
end

function ring_2_6:IsHidden() 
	return false
end
function ring_2_6:GetTexture()
    return "item_ring_secret"
end