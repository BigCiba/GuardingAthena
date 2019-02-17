function OnSpellStart( t )
    local caster = t.caster
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * 0.02
    local caster_location = caster:GetAbsOrigin()
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local delay = ability:GetSpecialValueFor("delay")
    local radius = ability:GetSpecialValueFor("radius")
    local distance = ability:GetSpecialValueFor("distance")
    for i=1,24 do
        local point = GetRotationPoint(caster_location, RandomInt(0, distance), RandomInt(0, 360))
        local particle = CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(particle, 0, point)
        Timers:CreateTimer(delay,function (  )
            local particle = CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(particle, 0, point)
            local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
            for i,v in ipairs(unitGroup) do
                CauseDamage(caster, v, damage * v:GetMaxHealth(), DAMAGE_TYPE_MAGICAL)
            end
        end)
    end
end