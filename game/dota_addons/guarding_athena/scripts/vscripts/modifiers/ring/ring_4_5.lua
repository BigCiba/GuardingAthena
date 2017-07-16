ring_4_5 = class({})

function ring_4_5:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
    return funcs
end
function ring_4_5:OnTakeDamage( t )
    if IsServer() then
        if t.unit == self:GetParent() then
            local caster = t.unit
            local target = t.attacker
            local damage = t.damage
            --local percent = damage / caster:GetMaxHealth()
            --local target_damage = target:GetMaxHealth() * percent
            local damageType = DAMAGE_TYPE_PURE
            --[[if target:IsAncient() then
                damageType = DAMAGE_TYPE_MAGICAL
                target_damage = target_damage * 0.5
            end]]
            Heal(caster,damage * 0.25,0,false)
            damage = t.unit:GetPrimaryStatValue()
            local particleMax = 6
            local particleCount = 0
            local unitGroup = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 600,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, false)
            for k,v in pairs(unitGroup) do
                CauseDamage(caster,v,damage,damageType)
                if particleCount < particleMax then
                    local particle = CreateParticle("particles/items/ring/ring_4_5.vpcf",PATTACH_CUSTOMORIGIN,caster,1)
                    ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
                    ParticleManager:SetParticleControl( particle, 1, v:GetAbsOrigin() )
                    particleCount = particleCount + 1
                end
            end
        end
    end
end
function ring_4_5:IsHidden() 
	return false
end
function ring_4_5:GetTexture()
    return "item_ring_secret"
end