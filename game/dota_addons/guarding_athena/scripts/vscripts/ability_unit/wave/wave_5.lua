function OnDeath( t )
    local caster = t.caster
    local ability = t.ability
    local radius = ability:GetSpecialValueFor("radius")
    local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
    local unitCount = #unitGroup
    local healAmount = caster:GetMaxHealth() / unitCount
    for i,v in ipairs(unitGroup) do
        Heal(v,healAmount,0,true)
    end
end