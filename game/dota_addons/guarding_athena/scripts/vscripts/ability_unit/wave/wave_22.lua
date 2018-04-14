function OnDeath( t )
    local caster = t.caster
    local ability = t.ability
    local radius = ability:GetSpecialValueFor("radius")
    local damage = ability:GetSpecialValueFor("damage")
    local damageType = ability:GetAbilityDamageType()
    local particle = CreateParticle( "particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_WORLDORIGIN, caster )
    ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( particle, 3, caster:GetAbsOrigin() )
    caster:EmitSound("Hero_Techies.Suicide.Arcana")  
    local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
    CauseDamage(caster,unitGroup,damage,damageType,ability)
end