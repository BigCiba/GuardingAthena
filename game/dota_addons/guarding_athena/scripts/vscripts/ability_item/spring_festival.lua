function Firecracker(t)
    local caster = t.caster
    local ability = t.ability
    local point = t.target_points[1]
    local duration = ability:GetSpecialValueFor("duration")
    local radius = ability:GetSpecialValueFor("radius")
    local delay = ability:GetSpecialValueFor("delay")
    local interval = ability:GetSpecialValueFor("interval")
    local damage = ability:GetSpecialValueFor("damage")
    local damageType = ability:GetAbilityDamageType()
    local p = CreateParticle("particles/econ/events/new_bloom/firecracker_explode.vpcf",PATTACH_ABSORIGIN,caster,10)
    ParticleManager:SetParticleControl( p, 0, point)
    CreateSound("Custom.Firecrackers",t.caster)
    local time = 0
    Timers:CreateTimer(delay,function ()
        if time < duration then
            local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
            CauseDamage(caster,unitGroup,damage,damageType,ability)
            time = time + interval
            return interval
        end
    end)
end
function FirecrackerBig(t)
    local p = CreateParticle("particles/themed_fx/cny_firecrackers_direend.vpcf",PATTACH_ABSORIGIN,t.caster,10)
    ParticleManager:SetParticleControl( p, 0, t.caster:GetAbsOrigin())
end